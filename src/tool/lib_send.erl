%%%-----------------------------------
%%% @Module  : lib_send
%%% @Author  : ygzj
%%% @Created : 2010.10.05
%%% @Description: 发送消息
%%%-----------------------------------
-module(lib_send).
-include_lib("stdlib/include/ms_transform.hrl").
-compile(export_all).

%%发送信息给指定socket玩家.
%%Socket:游戏Socket
%%Bin:二进制数据
send_one(Socket, Bin) ->
  gen_tcp:send(Socket, Bin).
