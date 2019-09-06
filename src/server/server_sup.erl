%% @author Mochi Media <dev@mochimedia.com>
%% @copyright 2010 Mochi Media <dev@mochimedia.com>

%% @doc Supervisor for the server application.

-module(server_sup).
-author("Mochi Media <dev@mochimedia.com>").

-behaviour(supervisor).

%% External exports
-export([start_link/0, upgrade/0]).

%% supervisor callbacks
-export([init/1]).

%% @spec start_link() -> ServerRet
%% @doc API for starting the supervisor.
start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% @spec upgrade() -> ok
%% @doc Add processes if necessary.
upgrade() ->
    {ok, {_, Specs}} = init([]),

    Old = sets:from_list(
            [Name || {Name, _, _, _} <- supervisor:which_children(?MODULE)]),
    New = sets:from_list([Name || {Name, _, _, _, _, _} <- Specs]),
    Kill = sets:subtract(Old, New),

    sets:fold(fun (Id, ok) ->
                      supervisor:terminate_child(?MODULE, Id),
                      supervisor:delete_child(?MODULE, Id),
                      ok
              end, ok, Kill),

    [supervisor:start_child(?MODULE, Spec) || Spec <- Specs],
    ok.

%% @spec init([]) -> SupervisorTree
%% @doc supervisor callback.
init([]) ->
    Mysql = dbpool_specs(),
    Web = web_specs(),
    TCP = tcp_specs(),
    Reader = tread_specs(),
    Strategy = {one_for_one, 10, 10},
    {ok, {Strategy, [Web, Mysql,TCP, Reader]}}.

%% http sup spec
web_specs() ->
    Httpcfg = config:get_http_cfg(),
    Mod = proplists:get_value(mod, Httpcfg),
    Port = proplists:get_value(port, Httpcfg),
    %% {port=port, loop=loop, name=undefined, max=2048, ip=any,listen=null, nodelay=false, backlog=128,active_sockets=0,acceptor_pool_size=16,ssl=false,ssl_opts={ssl_imp, new}],acceptor_pool=sets:new()}
    WebConfig = [{ip, {0,0,0,0}}, {port, Port}, {docroot, server_deps:local_path(["priv", "www"])}],
    {Mod, {Mod, start, [WebConfig]}, permanent, 5000, worker, dynamic}.

%% mysql_pool sup spec
dbpool_specs() ->
    PoolName = config:get_poolName_cfg(),
    PoolArgs = config:get_poolBoy_cfg(),
    SqlArgs  = config:get_mysql_cfg(),
    poolboy:child_spec(PoolName, PoolArgs, SqlArgs).

%% tcp listen sup spec
tcp_specs() ->
    Tcpcfg = config:get_tcp_cfg(),
    Port = proplists:get_value(port, Tcpcfg),
    {tcp_listen_sup, {tcp_listen_sup, start_link, [Port]}, transient, infinity, supervisor, [tcp_listen_sup]}.

%% tcp reader sup spec
tread_specs() ->
    {tcp_reader_sup, {tcp_reader_sup, start_link, []}, transient, infinity, supervisor, [tcp_reader_sup]}.