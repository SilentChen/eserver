%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. 八月 2019 13:00
%%%-------------------------------------------------------------------
-module(tcp_reader_sup).
-author("Administrator").
-behavior(supervisor).

%% API
-export([start_link/0, init/1]).

start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
  {ok, {{simple_one_for_one, 10, 10}, [{tcp_reader, {tcp_reader, start_link, []}, temporary, brutal_kill, worker, [tcp_reader]}]}}.
