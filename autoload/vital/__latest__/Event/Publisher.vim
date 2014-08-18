let s:save_cpo= &cpo
set cpo&vim

let s:publisher= {
\ '__subscribers': {},
\}

function! s:publisher.subscribe(event, subscriber)
  let subscribers= get(self.__subscribers, a:event, [])

  let subscribers+= [a:subscriber]

  let self.__subscribers[a:event]= subscribers
endfunction

function! s:publisher.unsubscribe(event, subscriber)
  let subscribers= get(self.__subscribers, a:event, [])

  let self.__subscribers[a:event]= filter(subscribers, '!v:val.equals(a:subscriber)')
endfunction

function! s:publisher.publish(event, ...)
  let subscribers= get(self.__subscribers, a:event, [])

  for subscriber in subscribers
      call subscriber.invoke({'event': a:event, 'data': a:000})
  endfor
endfunction

function! s:new()
  return deepcopy(s:publisher)
endfunction

let &cpo= s:save_cpo
unlet s:save_cpo
" vim: tabstop=2 shiftwidth=2 expandtab
