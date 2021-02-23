function! denops#debug(...) abort
  let msg = join(a:000)
  echohl Comment
  for line in split(msg, '\n')
    echomsg printf('[denops] %s', line)
  endfor
  echohl None
endfunction

function! denops#info(...) abort
  let msg = join(a:000)
  for line in split(msg, '\n')
    echomsg printf('[denops] %s', line)
  endfor
endfunction

function! denops#error(...) abort
  let msg = join(a:000)
  echohl ErrorMsg
  for line in split(msg, '\n')
    echomsg printf('[denops] %s', line)
  endfor
  echohl None
endfunction

function! denops#notify(plugin, method, params) abort
  return denops#server#notify('dispatch', [a:plugin, a:method, a:params])
endfunction

function! denops#request(plugin, method, params) abort
  return denops#server#request('dispatch', [a:plugin, a:method, a:params])
endfunction

function! denops#promise(plugin, method, params) abort
  return denops#promise#new(funcref('s:promise_start', [a:plugin, a:method, a:params]))
endfunction

function! s:promise_start(plugin, method, params, resolve, reject) abort
  let success = denops#callback#add(a:resolve)
  let failure = denops#callback#add(a:reject)
  return denops#server#request('dispatchAsync', [a:plugin, a:method, a:params, success, failure])
endfunction

" DEPRECATED
function! denops#register(plugin, script) abort
  call denops#error(join([
        \ "The denops#register() is deprecated.\n",
        \ "Create 'mod.ts' file on an arbitrary directory under 'denops' in 'runtimepath'.\n",
        \ printf("In your case, move '%s' to 'denops/%s/mod.ts' under 'runtimepath'.", a:script, a:plugin),
        \], ''))
endfunction
