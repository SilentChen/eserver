%%%-----------------------------------
%%% @Module  : server_reader
%%% @Author  : ygzj
%%% @Created : 2010.10.05
%%% @Description: 读取客户端
%%%-----------------------------------
-module(tcp_reader).
-export([start_link/0, init/0]).
-include("common.hrl").
-define(TCP_TIMEOUT, 1000). % 解析协议超时时间
-define(HEART_TIMEOUT, 60*1000). % 心跳包超时时间
-define(HEART_TIMEOUT_TIME, 1).  % 心跳包超时次数
-define(HEADER_LENGTH, 6). % 消息头长度

%% 记录客户端进程
-record(client, {
  player_pid = undefined,
  player_id = 0,
  login  = 0,
  accid  = 0,
  accname = undefined,
  timeout = 0,				% 超时次数
  sn = 0,						% 服务器号
  socketN = 0
}).

start_link() ->
  {ok, proc_lib:spawn_link(?MODULE, init, [])}.

%% gen_server init
%% Host:主机IP
%% Port:端口
init() ->
  process_flag(trap_exit, true),
  Client = #client{},
  receive
    {go, Socket} ->
      %% login_parse_packet(Socket, Client);
      ok;
    _ ->
      skip
  end.