import test from 'node:test';
import assert from 'node:assert/strict';
import {mkdtemp, writeFile, rm} from 'node:fs/promises';
import {tmpdir} from 'node:os';
import {join} from 'node:path';
import {Herdr, remoteCommand, safeText} from '../src/herdr.mjs';
import {command} from '../src/process.mjs';

const workspaceList = (label, id = 'w1') => JSON.stringify({result: {
  workspaces: [{workspace_id: id, label, focused: false}],
}});
const remote = {id: 'machine-one', label: 'Build', target: 'build', session: 'agents', enabled: true};

test('streams local results before a slow remote and keeps identical server IDs distinct', async () => {
  let release;
  const gate = new Promise((resolve) => { release = resolve; });
  const batches = [];
  const herdr = new Herdr({run: async (bin, args) => {
    if (args[0] === 'machine') return JSON.stringify([remote, {...remote, id: 'disabled', enabled: false}]);
    if (bin === 'ssh') { await gate; return workspaceList('remote work'); }
    return workspaceList('local work');
  }});
  const loading = herdr.load({onRows: (rows) => batches.push(rows)});
  await new Promise(setImmediate);
  assert.equal(batches.length, 1);
  assert.equal(batches[0][0].label, 'local work');
  release();
  const {rows, statuses} = await loading;
  assert.deepEqual(rows.map((row) => [row.machine.id, row.workspace_id]), [['local', 'w1'], ['machine-one', 'w1']]);
  assert.equal(statuses.length, 2);
});

test('one failed SSH connection does not hide other workspaces', async () => {
  const herdr = new Herdr({run: async (bin, args) => {
    if (args[0] === 'machine') return JSON.stringify([remote, {...remote, id: 'bad', target: 'bad'}]);
    if (bin === 'ssh' && args.includes('bad')) throw new Error('Authentication failed');
    return workspaceList(bin === 'ssh' ? 'remote' : 'local');
  }});
  const {rows, statuses} = await herdr.load();
  assert.equal(rows.length, 2);
  assert.equal(statuses.find((status) => status.machine.id === 'bad').error, 'Authentication failed');
});

test('saved-machine catalog failure still allows local navigation', async () => {
  const herdr = new Herdr({run: async (_, args) => {
    if (args[0] === 'machine') throw new Error('Invalid catalog');
    return workspaceList('local');
  }});
  const {rows, statuses} = await herdr.load();
  assert.equal(rows[0].label, 'local');
  assert.equal(statuses.find((status) => status.error).error, 'Invalid catalog');
});

test('focuses the local server using the inherited socket context', async () => {
  const calls = [];
  const env = {HERDR_BIN_PATH: '/opt/herdr', HERDR_SOCKET_PATH: '/tmp/session.sock'};
  const herdr = new Herdr({env, run: async (...args) => { calls.push(args); return '{}'; }});
  assert.deepEqual(await herdr.select({workspace_id: 'w7', machine: {local: true}}), {focused: true});
  assert.deepEqual(calls, [['/opt/herdr', ['workspace', 'focus', 'w7'], {env}]]);
});

test('remote selection explains the manual step without focusing any server', async () => {
  const herdr = new Herdr({run: () => { throw new Error('Unexpected command'); }});
  const selection = await herdr.select({workspace_id: 'w1', label: 'test workspace', machine: remote});
  assert.equal(selection.focused, false);
  assert.match(selection.message, /test workspace/);
  assert.match(selection.message, /Build/);
  assert.match(selection.message, /does not let plugins switch/);
});

test('quotes remote session and arguments without shell expansion', async () => {
  const session = "task 'quoted'; $(printf injected)";
  const args = remoteCommand({...remote, session}, ['workspace', 'list']);
  const invocation = args.at(-1);
  const directory = await mkdtemp(join(tmpdir(), 'picker-test-'));
  try {
    await writeFile(join(directory, 'herdr'), '#!/usr/bin/env node\nconsole.log(JSON.stringify({args: process.argv.slice(2), socket: process.env.HERDR_SOCKET_PATH}));\n', {mode: 0o755});
    const output = await command('sh', ['-c', invocation], {env: {
      ...process.env, PATH: `${directory}:${process.env.PATH}`, HERDR_SOCKET_PATH: '/wrong/local/socket',
    }});
    assert.deepEqual(JSON.parse(output), {args: ['--session', session, 'workspace', 'list']});
  } finally { await rm(directory, {recursive: true, force: true}); }
});

test('early cancellation marks discovery incomplete so reopening can retry', async () => {
  const controller = new AbortController();
  const herdr = new Herdr({run: async (bin, args, {signal}) => {
    if (args[0] === 'machine') return JSON.stringify([remote]);
    if (bin !== 'ssh') return workspaceList('local');
    return new Promise((_, reject) => signal.addEventListener('abort', () => reject(signal.reason), {once: true}));
  }});
  const loading = herdr.load({signal: controller.signal});
  await new Promise(setImmediate);
  controller.abort();
  const data = await loading;
  assert.equal(data.complete, false);
  assert.equal(data.rows.length, 1);
  assert.equal(data.statuses.find((status) => status.machine.id === remote.id).pending, true);
});

test('removes terminal control characters from display text', () => {
  assert.equal(safeText('work\x1b]52;c;abc\x07\n\t\u202e'), 'work ]52;c;abc    ');
});

test('reports a server error instead of treating it as an empty workspace list', async () => {
  const herdr = new Herdr({run: async () => JSON.stringify({error: {message: 'Server unavailable'}})});
  await assert.rejects(herdr.workspaces({local: true}), /Server unavailable/);
});
