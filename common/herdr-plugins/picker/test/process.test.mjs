import test from 'node:test';
import assert from 'node:assert/strict';
import {command} from '../src/process.mjs';

test('times out an unresponsive command', async () => {
  await assert.rejects(command(process.execPath, ['-e', 'setInterval(() => {}, 1000)'], {timeout: 100}), /Timed out/);
});

test('cancels outstanding requests when the picker closes', async () => {
  const controller = new AbortController();
  const promise = command(process.execPath, ['-e', 'setInterval(() => {}, 1000)'], {signal: controller.signal});
  controller.abort(new Error('Picker closed'));
  await assert.rejects(promise, /Picker closed/);
});

test('reports a missing executable', async () => {
  await assert.rejects(command('/nonexistent/herdr-picker-test', []), {code: 'ENOENT'});
});
