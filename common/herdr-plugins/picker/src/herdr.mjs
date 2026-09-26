import {command, shellQuote} from './process.mjs';

export function safeText(value) {
  return String(value ?? '').replace(/[\p{Cc}\p{Cf}\p{Zl}\p{Zp}]/gu, ' ');
}

function result(output) {
  const response = JSON.parse(output);
  if (response.error) throw new Error(response.error.message || response.error.code);
  return response.result;
}

export function remoteCommand(machine, args) {
  // SSH passes a command string to the login shell, which may be fish.
  const script = `unset HERDR_SOCKET_PATH HERDR_SESSION HERDR_CONFIG_PATH
if command -v herdr >/dev/null 2>&1; then
  exec herdr --session "$@"
elif test -x "$HOME/.local/bin/herdr"; then
  exec "$HOME/.local/bin/herdr" --session "$@"
elif test -x "$HOME/.cargo/bin/herdr"; then
  exec "$HOME/.cargo/bin/herdr" --session "$@"
else
  echo 'Herdr is not installed on this machine' >&2
  exit 127
fi`;
  return ['-o', 'BatchMode=yes', '-o', 'ConnectTimeout=4', '-o', 'ConnectionAttempts=1',
    '-o', 'ServerAliveInterval=5', '-o', 'ServerAliveCountMax=1', '--', machine.target,
    ['sh', '-c', script, 'picker', machine.session || 'default', ...args].map(shellQuote).join(' ')];
}

export class Herdr {
  constructor({run = command, env = process.env} = {}) {
    this.run = run;
    this.env = env;
    this.bin = env.HERDR_BIN_PATH || 'herdr';
  }

  async open() {
    if (this.env.HERDR_ENV !== '1') throw new Error('Open this plugin from inside Herdr');
    await this.run(this.bin, ['plugin', 'pane', 'open', '--plugin', 'shorrock.picker', '--entrypoint', 'picker'], {env: this.env});
  }

  async machines(signal) {
    const profiles = JSON.parse(await this.run(this.bin, ['machine', 'list', '--json'], {signal, env: this.env}));
    if (!Array.isArray(profiles)) throw new Error('Herdr returned an invalid machine list');
    return profiles.filter((machine) => machine.enabled).map((machine) => {
      if (typeof machine.id !== 'string' || typeof machine.target !== 'string' || !machine.target) {
        throw new Error('Herdr returned an invalid machine profile');
      }
      return {...machine, label: machine.label || machine.target, local: false};
    });
  }

  async workspaces(machine, signal) {
    const output = machine.local
      ? await this.run(this.bin, ['workspace', 'list'], {signal, env: this.env})
      : await this.run('ssh', remoteCommand(machine, ['workspace', 'list']), {signal, env: this.env});
    const workspaces = result(output)?.workspaces;
    if (!Array.isArray(workspaces)) throw new Error('Herdr returned an invalid workspace list');
    return workspaces.map((workspace) => {
      if (typeof workspace.workspace_id !== 'string' || typeof workspace.label !== 'string') {
        throw new Error('Herdr returned an invalid workspace');
      }
      return {...workspace, machine};
    });
  }

  async load({signal, onRows = () => {}, onStatus = () => {}} = {}) {
    const rows = [];
    const statuses = [];
    const local = {id: 'local', label: 'Local', local: true};
    const report = (status) => {
      const index = statuses.findIndex((item) => item.machine === status.machine);
      if (index < 0) statuses.push(status);
      else statuses[index] = status;
      onStatus(status);
    };
    const loadMachine = async (machine) => {
      report({machine, pending: true});
      try {
        const found = await this.workspaces(machine, signal);
        if (signal?.aborted) return;
        rows.push(...found);
        onRows(found);
        report({machine, count: found.length});
      } catch (error) {
        if (!signal?.aborted) report({machine, error: error.message});
      }
    };
    await Promise.all([
      loadMachine(local),
      (async () => {
        let machines;
        try { machines = await this.machines(signal); }
        catch (error) {
          if (!signal?.aborted) report({machine: {label: 'Saved machines'}, error: error.message});
          return;
        }
        for (const machine of machines) report({machine, pending: true});
        const queue = [...machines];
        await Promise.all(Array.from({length: Math.min(4, queue.length)}, async () => {
          while (queue.length && !signal?.aborted) await loadMachine(queue.shift());
        }));
      })(),
    ]);
    return {rows, statuses, complete: !signal?.aborted};
  }

  async select(workspace) {
    if (!workspace.machine.local) return {focused: false, message: remoteMessage(workspace)};
    await this.run(this.bin, ['workspace', 'focus', workspace.workspace_id], {env: this.env});
    return {focused: true};
  }
}

export function remoteMessage(workspace) {
  return [
    `Workspace: ${safeText(workspace.label)}`,
    `Machine:   ${safeText(workspace.machine.label)}`,
    `Session:   ${safeText(workspace.machine.session || 'default')}`,
    '',
    'Herdr 0.9.0 does not let plugins switch the displayed machine.',
    'Close this picker, then choose this workspace in the sidebar',
    'or use Herdr\'s global navigator.',
    '',
    'No remote focus was changed.',
  ].join('\n');
}
