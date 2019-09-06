%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. 八月 2019 13:09
%%%-------------------------------------------------------------------
-module(tcp_listen_sup).
-author("Administrator").
-behavior(supervisor).

%% API
-export([start_link/1, init/1]).

start_link(Port) ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, [10, Port]).

init([AcceptCount, Port]) ->
  {ok, {
          {one_for_one, 10, 10},
          [
                {
                  tcp_accept_sup,
                  {tcp_accept_sup, start_link, []},
                  transient,
                  infinity,
                  supervisor,
                  [tcp_accept_sup]
                },
                {
                  lists:concat([tcp_listen, Port]),
                  {tcp_listen, start_link, [AcceptCount, Port]},
                  transient,
                  100,
                  worker,
                  [tcp_listen]
                },
                {
                  lists:concat([tcp_listen, Port - 100]),
                  {tcp_listen, start_link, [AcceptCount, Port - 100]},
                  transient,
                  100,
                  worker,
                  [tcp_listen]
                },
                {
                  lists:concat([tcp_listen, Port - 200]),
                  {tcp_listen, start_link, [AcceptCount, Port - 200]},
                  transient,
                  100,
                  worker,
                  [tcp_listen]
                }
          ]
      }
  }.
