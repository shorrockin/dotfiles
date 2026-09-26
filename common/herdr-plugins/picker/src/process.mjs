import {spawn} from 'node:child_process';

export function command(file, args, {signal, timeout = 8000, env = process.env} = {}) {
  return new Promise((resolve, reject) => {
    if (signal?.aborted) return reject(signal.reason);
    const child = spawn(file, args, {env, detached: true, stdio: ['ignore', 'pipe', 'pipe']});
    let stdout = '';
    let stderr = '';
    let failure;
    let killTimer;
    const kill = (kind) => {
      if (!child.pid) return;
      try { process.kill(-child.pid, kind); }
      catch (error) { if (error.code !== 'ESRCH') failure ??= error; }
    };
    const stop = (reason) => {
      if (failure) return;
      failure = reason;
      kill('SIGTERM');
      killTimer = setTimeout(() => kill('SIGKILL'), 300);
      killTimer.unref();
    };
    const abort = () => stop(signal.reason ?? new Error('Cancelled'));
    const timer = setTimeout(() => stop(new Error(`Timed out after ${timeout / 1000}s`)), timeout);
    signal?.addEventListener('abort', abort, {once: true});
    child.stdout.setEncoding('utf8');
    child.stderr.setEncoding('utf8');
    child.stdout.on('data', (chunk) => {
      stdout += chunk;
      if (stdout.length > 4 * 1024 * 1024) stop(new Error('Response exceeds 4 MiB'));
    });
    child.stderr.on('data', (chunk) => { stderr = (stderr + chunk).slice(-4000); });
    child.on('error', (error) => { failure = error; });
    child.on('close', (code) => {
      clearTimeout(timer);
      clearTimeout(killTimer);
      signal?.removeEventListener('abort', abort);
      if (failure) reject(failure);
      else if (code !== 0) reject(new Error(stderr.trim() || `${file} exited with status ${code}`));
      else resolve(stdout);
    });
  });
}

export function shellQuote(value) {
  return `'${String(value).replaceAll("'", "'\\''")}'`;
}
