rebar3_ex_compiler
=====

A rebar3 example plugin for a [tutorial](http://www.rebar3.org/v3.0/docs/custom-compiler-plugins).

Build
-----

    $ rebar3 compile

Use
---

Add the plugin to your rebar config:

    {plugins, [
        { rebar3_ex_compiler, ".*", {git, "https://github.com/tsloughter/rebar3_ex_compiler.git", {branch, "master"}}}
    ]}.

Then just call your plugin directly in an existing application:


    $ rebar3 exc compile
    ===> Fetching rebar3_ex_compiler
    ===> Compiling rebar3_ex_compiler
    <Plugin Output>

Or add it as a compile hook:

    {provider_hooks, [{pre, [{compile, {exc, compile}}]}]}.
