%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. 八月 2019 12:52
%%%-------------------------------------------------------------------
-module(tcp_accept_sup).
-author("Administrator").
-behavior(supervisor).

%% API
-export([start_link/0, init/1]).

start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
  {ok, {{simple_one_for_one, 10, 10}, [{tcp_accept, {tcp_accept, start_link, []}, transient, brutal_kill, worker,[tcp_accept]}]}}.
