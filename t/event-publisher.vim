filetype plugin indent off
set runtimepath+=./.vim-test/vital.vim/
filetype plugin indent on

runtime plugin/*.vim

describe 'Event.Publisher'
  describe 'basic usage'
    it 'accepts string expression'
      let publisher= vital#of('vital').import('Event.Publisher').new()

      call publisher.subscribe('with/no-args',  'Expect v:val ==# []')
      call publisher.subscribe('with/one-args', 'Expect v:val ==# [1]')
      call publisher.subscribe('with/two-args', 'Expect v:val ==# [1, 2]')

      call publisher.publish('with/no-args')
      call publisher.publish('with/one-args', 1)
      call publisher.publish('with/two-args', 1, 2)
    end

    it 'accepts dictionary'
      let publisher= vital#of('vital').import('Event.Publisher').new()

      let handler= {}
      function! handler.do(...)
        Expect a:000 ==# []
      endfunction
      let handler['with/no-args']= handler.do

      function! handler.do(...)
        Expect a:000 ==# [1]
      endfunction
      let handler['with/one-args']= handler.do

      function! handler.do(...)
        Expect a:000 ==# [1, 2]
      endfunction
      let handler['with/two-args']= handler.do
      unlet handler.do

      call publisher.subscribe('with/no-args', handler)
      call publisher.subscribe('with/one-args', handler)
      call publisher.subscribe('with/two-args', handler)

      call publisher.publish('with/no-args')
      call publisher.publish('with/one-args', 1)
      call publisher.publish('with/two-args', 1, 2)
    end

    it 'accepts funcref'
      let publisher= vital#of('vital').import('Event.Publisher').new()

      function! s:first(...)
        Expect a:000 ==# []
      endfunction

      call publisher.subscribe('with/no-args', function('s:first'))

      function! s:second(...)
        Expect a:000 ==# [1]
      endfunction

      call publisher.subscribe('with/one-args', function('s:second'))

      function! s:third(...)
        Expect a:000 ==# [1, 2]
      endfunction

      call publisher.subscribe('with/two-args', function('s:third'))

      call publisher.publish('with/no-args')
      call publisher.publish('with/one-args', 1)
      call publisher.publish('with/two-args', 1, 2)
    end

    it 'unsubscribe'
      let publisher= vital#of('vital').import('Event.Publisher').new()

      function! s:fail()
        throw 'fail'
      endfunction

      function! s:success()
        throw 'success'
      endfunction

      call publisher.subscribe('test1', function('s:fail'))
      call publisher.subscribe('test1', function('s:success'))
      call publisher.subscribe('test2', function('s:fail'))
      call publisher.subscribe('test2', function('s:success'))

      call publisher.unsubscribe('test1', function('s:fail'))
      call publisher.unsubscribe('test2', function('s:fail'))

      Expect expr { publisher.publish('test1') } to_throw '^success$'
      Expect expr { publisher.publish('test2') } to_throw '^success$'
    end

    " it 'keep context'
    "   let publisher= vital#of('vital').import('Event.Publisher').new()
    "   let subscriber= vital#of('vital').import('Event.Subscriber')
    "
    "   call publisher.subscribe('hoge', subscriber.wrap('Expect hoge ==# "local"'))
    "
    "   let handler= {}
    "   function! handler.do()
    "     Expect hoge ==# 'local'
    "   endfunction
    "
    "   call publisher.subscribe('hoge', subscriber.wrap(handler))
    "
    "   function! s:handle()
    "     Expect hoge ==# 'local'
    "   endfunction
    "
    "   call publisher.subscribe('hoge', subscriber.wrap(function('s:handle')))
    "
    "   let hoge= 'local'
    "   call publisher.publish('hoge')
    " end
  end
end
" vim: tabstop=2 shiftwidth=2 expandtab
