%% @author Mochi Media <dev@mochimedia.com>
%% @copyright server Mochi Media <dev@mochimedia.com>

%% @doc Callbacks for the server application.

-module(server_app).
-author("Mochi Media <dev@mochimedia.com>").

-behaviour(application).
-export([start/2,stop/1]).
-include("common.hrl").


%% @spec start(_Type, _StartArgs) -> ServerRet
%% @doc application start callback for server.
start(_Type, _StartArgs) ->
    init(),
    server_deps:ensure(),
    server_sup:start_link().

%% @spec stop(_State) -> ServerRet
%% @doc application stop callback for server.
stop(_State) ->
    ok.

init() ->
    ets:new(?ETS_MONITOR_PID, [set, public, named_table,?ETSRC, ?ETSWC]).
