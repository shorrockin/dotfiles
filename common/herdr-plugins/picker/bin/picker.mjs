#!/usr/bin/env node
import {Herdr, safeText} from '../src/herdr.mjs';
import {browse, message} from '../src/picker.mjs';

const help = `Workspace picker for Herdr

  node bin/picker.mjs open     Open the plugin popup
  node bin/picker.mjs browse   Run the fuzzy picker in this terminal
  node bin/picker.mjs list     Print live workspace inventory and connection errors

Requires Node.js >=22, fzf >=0.60, and Herdr >=0.9.0.
Search matches workspace names only. Enter focuses a workspace on the current
server; remote results show the machine and workspace to select in Herdr.
`;

const controller = new AbortController();
for (const signal of ['SIGINT', 'SIGTERM', 'SIGHUP']) {
  process.once(signal, () => controller.abort(new Error('Cancelled')));
}

async function main() {
  const action = process.argv[2] || 'browse';
  if (['--help', '-h'].includes(action)) { process.stdout.write(help); return; }
  const herdr = new Herdr();
  if (action === 'open') return herdr.open();
  if (action === 'list') {
    const data = await herdr.load({signal: controller.signal});
    process.stdout.write(`${JSON.stringify(data, null, 2)}\n`);
    if (data.statuses.some((status) => status.error)) process.exitCode = 1;
    return;
  }
  if (action !== 'browse') throw new Error(`Unknown command: ${action}`);
  if (!process.stdin.isTTY) throw new Error('The picker needs an interactive terminal');
  try { await browse(herdr, controller.signal); }
  catch (error) {
    if (controller.signal.aborted) return;
    await message(`Workspace picker: ${safeText(error.message)}`, controller.signal);
    process.exitCode = 1;
  }
}

main().catch((error) => {
  if (!controller.signal.aborted) {
    process.stderr.write(`picker: ${error.message}\n`);
    process.exitCode = 1;
  }
});
