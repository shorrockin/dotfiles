import {spawn, spawnSync} from 'node:child_process';
import {mkdtemp, writeFile, rm} from 'node:fs/promises';
import {tmpdir} from 'node:os';
import {join} from 'node:path';
import {emitKeypressEvents} from 'node:readline';
import {safeText} from './herdr.mjs';
import {shellQuote} from './process.mjs';

const controls = 'Enter: open / remote details · Esc: close\nCtrl+R: refresh · Ctrl+E: connections';

export function fzfArgs(query, statusFile) {
  return ['--layout=reverse', '--border=none', '--info=inline', '--no-multi', '--no-mouse',
    '--delimiter=\t', '--with-nth=2..', '--nth=1', '--tiebreak=index', '--tabstop=32',
    '--prompt=Workspace> ', '--header', `Loading saved machines…\n${controls}`,
    '--print-query', '--expect=ctrl-r,ctrl-e', '--query', query,
    '--bind', `load:transform-header:cat ${shellQuote(statusFile)}`];
}

export function matchesQuery(row, query) {
  const result = spawnSync('fzf', ['--delimiter=\t', '--with-nth=2..', '--nth=1', '--filter', query], {
    input: encodeRow(row, 0), encoding: 'utf8', timeout: 2000,
    env: {...process.env, FZF_DEFAULT_OPTS: '', FZF_DEFAULT_OPTS_FILE: ''},
  });
  if (result.error) throw result.error;
  if (![0, 1].includes(result.status)) throw new Error(result.stderr || 'Could not validate the selected workspace');
  return result.status === 0;
}

export function encodeRow(row, index) {
  return `${index}\t${safeText(row.label)}\t${safeText(row.machine.label)}${row.machine.local ? '' : ' [remote]'}\n`;
}

export function loadedHeader(statuses, count) {
  const unavailable = statuses.filter((status) => status.error).length;
  return `${count} workspaces · ${unavailable ? `${unavailable} connection(s) unavailable; Ctrl+E for details` : 'Workspace names only'}\n${controls}`;
}

export async function choose(herdr, {query = '', inventory, signal} = {}) {
  const controller = new AbortController();
  const abort = () => controller.abort(signal.reason);
  signal?.addEventListener('abort', abort, {once: true});
  const directory = await mkdtemp(join(tmpdir(), 'herdr-picker-'));
  const statusFile = join(directory, 'status');
  const rows = [];
  let child;
  let loading;
  try {
    if (signal?.aborted) throw signal.reason;
    // Personal fzf defaults can add previews, commands, or fields outside this picker.
    const env = {...process.env, FZF_DEFAULT_OPTS: '', FZF_DEFAULT_OPTS_FILE: ''};
    child = spawn('fzf', fzfArgs(query, statusFile), {env, stdio: ['pipe', 'pipe', 'inherit']});
    let output = '';
    child.stdout.setEncoding('utf8');
    child.stdout.on('data', (chunk) => { output += chunk; });
    child.stdin.on('error', () => {});
    const exited = new Promise((resolve, reject) => {
      child.once('error', reject);
      child.once('close', (code) => resolve(code));
    });
    const stop = () => child.kill('SIGTERM');
    controller.signal.addEventListener('abort', stop, {once: true});
    const onRows = (found) => {
      if (controller.signal.aborted) return;
      for (const row of found) {
        child.stdin.write(encodeRow(row, rows.length));
        rows.push(row);
      }
    };
    loading = (async () => {
      const data = inventory || await herdr.load({signal: controller.signal, onRows});
      if (inventory) onRows(inventory.rows);
      if (!controller.signal.aborted) {
        await writeFile(statusFile, loadedHeader(data.statuses, rows.length));
        child.stdin.end();
      }
      return data;
    })();
    // Observe a loader failure immediately even while fzf is waiting for input.
    loading.catch(() => child.kill('SIGTERM'));
    const code = await exited;
    controller.signal.removeEventListener('abort', stop);
    controller.abort();
    const data = await loading;
    if (signal?.aborted) throw signal.reason;
    if (code === 130 || code === 1) return {cancelled: true};
    if (code !== 0) throw new Error(`fzf exited with status ${code}`);
    const [nextQuery, key, line] = output.split('\n');
    const index = line?.split('\t')[0];
    let row = /^\d+$/.test(index ?? '') ? rows[Number(index)] : undefined;
    // Enter can arrive before fzf finishes applying the latest keystroke.
    if (row && !matchesQuery(row, nextQuery)) row = undefined;
    return {query: nextQuery, key, row, inventory: data};
  } finally {
    controller.abort();
    child?.kill('SIGTERM');
    await loading?.catch(() => {});
    signal?.removeEventListener('abort', abort);
    await rm(directory, {recursive: true, force: true});
  }
}

export function message(text, signal) {
  return new Promise((resolve) => {
    if (signal?.aborted) return resolve('close');
    const wasRaw = process.stdin.isRaw;
    emitKeypressEvents(process.stdin);
    process.stdin.setRawMode(true);
    process.stdin.resume();
    process.stdout.write(`\x1b[2J\x1b[H${text.replaceAll('\n', '\r\n')}\r\n\r\nEnter: close picker · Esc: back to search\r\n`);
    const finish = (action) => {
      process.stdin.removeListener('keypress', onKey);
      signal?.removeEventListener('abort', onAbort);
      process.stdin.setRawMode(wasRaw);
      process.stdin.pause();
      resolve(action);
    };
    const onAbort = () => finish('close');
    const onKey = (_, key) => {
      if (key?.name === 'escape') finish('back');
      else if (key?.name === 'return' || key?.ctrl && key?.name === 'c') finish('close');
    };
    process.stdin.on('keypress', onKey);
    signal?.addEventListener('abort', onAbort, {once: true});
  });
}

export function connectionMessage(statuses) {
  return ['Connections', '', ...statuses.map(({machine, count, error, pending}) =>
    `${safeText(machine.label)}: ${pending ? 'not finished; Ctrl+R to retry' : error ? safeText(error) : `${count} workspaces`}`), '',
  'Remote queries use batch SSH with your existing credentials.',
  'Disabled saved machines are omitted. Press Esc, then Ctrl+R to retry.'].join('\n');
}

export async function browse(herdr, signal) {
  let query = '';
  let inventory;
  while (!signal?.aborted) {
    const selection = await choose(herdr, {query, inventory, signal});
    if (selection.cancelled) return;
    query = selection.query;
    inventory = selection.inventory?.complete ? selection.inventory : undefined;
    if (selection.key === 'ctrl-r') { inventory = undefined; continue; }
    let text;
    if (selection.key === 'ctrl-e') text = connectionMessage(selection.inventory.statuses);
    else if (selection.row) {
      try {
        const result = await herdr.select(selection.row);
        if (result.focused) return;
        text = result.message;
      } catch (error) { text = `Could not open workspace: ${safeText(error.message)}\n\nPress Esc, then Ctrl+R to refresh.`; }
    } else continue;
    if (await message(text, signal) === 'close') return;
  }
}
