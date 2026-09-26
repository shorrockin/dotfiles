import test from 'node:test';
import assert from 'node:assert/strict';
import {spawnSync} from 'node:child_process';
import {encodeRow, fzfArgs, loadedHeader, matchesQuery} from '../src/picker.mjs';

function search(query, rows) {
  const args = fzfArgs('', '/tmp/unused-status');
  const result = spawnSync('fzf', [...args, '--filter', query], {
    input: rows.map(encodeRow).join(''), encoding: 'utf8',
    env: {...process.env, FZF_DEFAULT_OPTS: '', FZF_DEFAULT_OPTS_FILE: ''},
  });
  assert.ifError(result.error);
  assert.ok([0, 1].includes(result.status), result.stderr);
  return result.stdout.trim().split('\n').filter((line) => /^\d+\t/.test(line)).map((line) => Number(line.split('\t')[0]));
}

const rows = [
  {workspace_id: 'w1', label: 'dotfiles', machine: {label: 'Local', local: true}},
  {workspace_id: 'w1', label: 'payments server', machine: {label: 'Build machine'}},
  {workspace_id: 'w2', label: 'dotfiles', machine: {label: 'Another machine'}},
];

test('matches noncontiguous characters in workspace names', () => {
  assert.deepEqual(search('dtfls', rows), [0, 2]);
  assert.deepEqual(search('pymsv', rows), [1]);
});

test('does not match machine labels, IDs, or the remote marker', () => {
  for (const query of ['Local', 'Build', 'w1', 'remote']) assert.deepEqual(search(query, rows), []);
});

test('preserves duplicate workspace names on different machines', () => {
  assert.deepEqual(search('dotfiles', rows), [0, 2]);
});

test('rejects a stale selection that does not match the typed query', () => {
  assert.equal(matchesQuery(rows[0], 'pymsv'), false);
  assert.equal(matchesQuery(rows[1], 'pymsv'), true);
});

test('labels containing tabs and control sequences stay one selectable row', () => {
  const encoded = encodeRow({label: 'a\tb\nc\x1b', machine: {label: 'host\nother'}}, 5);
  assert.equal(encoded, '5\ta b c \thost other [remote]\n');
});

test('surfaces partial discovery failures in the picker header', () => {
  assert.match(loadedHeader([{count: 2}, {error: 'offline'}], 2), /1 connection\(s\) unavailable/);
  assert.match(loadedHeader([{count: 2}], 2), /2 workspaces/);
});
