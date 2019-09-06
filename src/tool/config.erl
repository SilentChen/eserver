%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. 八月 2019 17:23
%%%-------------------------------------------------------------------
-module(config).
-author("Administrator").

%% API
-compile(export_all).

get(App, Key, Default) ->
  case application:get_env(App, Key) of
    {ok, false} -> Default;
    {ok, Value} -> Value;
    undefined -> throw(undefined)
  end.

get(App, Key) ->
  case application:get_env(App, Key) of
    {ok, false} -> throw(undefined);
    {ok, Value} -> Value;
    undeined -> throw(undefined)
  end.

getServerCfg(Key, Default) ->
  get(server, Key, Default).

getServerCfg(Key) ->
  get(server, Key).

get_mysql_cfg() ->
  getServerCfg(mysql).

get_poolBoy_cfg() ->
  getServerCfg(poolBoy).

get_http_cfg() ->
  getServerCfg(http).

get_poolName_cfg() ->
  getServerCfg(poolName).

get_tcp_cfg() ->
  getServerCfg(tcp).

get_header_serverInfo() ->
  getServerCfg(headerServerInfo).