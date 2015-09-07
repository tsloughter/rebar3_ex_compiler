-module(rebar3_prv_ex_compiler).

-export([init/1, do/1, format_error/1]).

-define(PROVIDER, compile).
-define(NAMESPACE, exc).
-define(DEPS, [{default, app_discovery}]).

%% ===================================================================
%% Public API
%% ===================================================================
-spec init(rebar_state:t()) -> {ok, rebar_state:t()}.
init(State) ->
    Provider = providers:create([
            {name, ?PROVIDER},
            {namespace, ?NAMESPACE},
            {module, ?MODULE},
            {bare, true},
            {deps, ?DEPS},
            {example, "rebar3 exc compile"},
            {opts, []},
            {short_desc, "An example rebar compile plugin"},
            {desc, ""}
    ]),
    {ok, rebar_state:add_provider(State, Provider)}.


-spec do(rebar_state:t()) -> {ok, rebar_state:t()} | {error, string()}.
do(State) ->
    Apps = case rebar_state:current_app(State) of
                  undefined ->
                      rebar_state:project_apps(State);
                  AppInfo ->
                      [AppInfo]
              end,
    [begin
         Opts = rebar_app_info:opts(AppInfo),
         OutDir = rebar_app_info:out_dir(AppInfo),
         SourceDir = filename:join(rebar_app_info:dir(AppInfo), "exc_files"),
         FoundFiles = rebar_utils:find_files(SourceDir, ".*\\.exc\$"),

         CompileFun = fun(Source, Opts1) ->
                              exc_compile(Opts1, Source, OutDir)
                      end,

         rebar_base_compiler:run(Opts, [], FoundFiles, CompileFun)
     end || AppInfo <- Apps],

    {ok, State}.

-spec format_error(any()) ->  iolist().
format_error(Reason) ->
    io_lib:format("~p", [Reason]).

exc_compile(_Opts, Source, OutDir) ->
    {ok, Binary} = file:read_file(Source),
    OutFile = filename:join([OutDir, "priv", filename:basename(Source)]),
    filelib:ensure_dir(OutFile),
    rebar_api:info("Writing out ~s", [OutFile]),
    file:write_file(OutFile, Binary).
