vital-pubsub [![Build Status](https://travis-ci.org/kamichidu/vital-pubsub.svg?branch=master)](https://travis-ci.org/kamichidu/vital-pubsub)
====================================================================================================
This is a publish/subscribe framework for vim plugin.
This is intended to use in plugin-inside.

Requires
----------------------------------------------------------------------------------------------------
1. [vital.vim](https://github.com/vim-jp/vital.vim)

Hot to Use
----------------------------------------------------------------------------------------------------
* Plugin-side

    For using publish/subscribe framework, several steps below:

    1. Execute `:Vitalize` command with module names in your plugin's root directory.

        `Vitalize --name=xxx . Event.Publisher Event.Subscriber`

    1. Write delegation functions in your plugin source below:

        ```vim:
        let s:V= vital#of('xxx')
        let s:Pub= s:V.import('Event.Publisher').new()
        let s:Sub= s:V.import('Event.Subscriber')
        unlet s:V

        ...

        function! xxx#do_something()

            ...

            call s:Pub.publish('xxx/hoge', 'pass', 'some', 'args')

            ...

        endfunction

        ...

        function! xxx#subscribe(event, expr)
            call s:Pub.subscribe(a:event, s:Sub.wrap(a:expr))
        endfunction

        function! xxx#unsubscribe(event, expr)
            call s:Pub.unsubscribe(a:event, s:Sub.wrap(a:expr))
        endfunction
        ```
