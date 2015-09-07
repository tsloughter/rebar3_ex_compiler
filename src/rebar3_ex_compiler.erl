-module(rebar3_ex_compiler).

-export([init/1]).

-spec init(rebar_state:t()) -> {ok, rebar_state:t()}.
init(State) ->
    {ok, State1} = rebar3_prv_ex_compiler:init(State),
    {ok, State1}.
