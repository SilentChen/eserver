-module(admin_index).
-author("silent").

-export([index/2, sinfo/2]).

-record(system_info, {
  appVer    = "1.0.1"
  ,hostname = "undefind"
  ,erlVer   = "undefind"
  ,os       = "undefind"
  ,arch     = "undefind"
  ,cpuNum   = 0
  ,postNum  = 0
  ,tagNum   = 0
  ,userNum  = 0
}).

index('GET', Req) ->
  Sinfo = #system_info{},
  Ver  = Sinfo#system_info.appVer,
  Unam = "Silent",
  http_router:render_ok(Req, dtl_admin_index, [{version, Ver},{uname, Unam}]).

sinfo('GET', Req) ->
  Sinfo = #system_info{hostname = "localhost", appVer = "1.0.2"},
  L = db:get_rows(?MODULE, "select `name`, `value` from `config` where cate = 1"),
  F = fun(L) -> [Name, Val] = L, {erlang:binary_to_atom(Name, utf8), erlang:binary_to_list(Val)} end,
  TL = [ F(Item) || Item <- L],
  case lists:keyfind(appVera, 1, TL) of
    false -> AppVer = Sinfo#system_info.appVer;
    {_, Val1} -> AppVer = Val1
  end,
  case lists:keyfind(hostname, 1, TL) of
    false -> Hostname = Sinfo#system_info.hostname;
    {_, Val2} -> Hostname = Val2
  end,
  case lists:keyfind(erlVer, 1, TL) of
    false -> ErlVer = Sinfo#system_info.erlVer;
    {_, Val3} -> ErlVer = Val3
  end,
  case lists:keyfind(os, 1, TL) of
    false -> OS = Sinfo#system_info.os;
    {_, Val4} -> OS = Val4
  end,
  case lists:keyfind(arch, 1, TL) of
    false -> Arch = Sinfo#system_info.arch;
    {_, Val5} -> Arch = Val5
  end,
  case lists:keyfind(cpuNum, 1, TL) of
    false -> CpuNum = Sinfo#system_info.cpuNum;
    {_, Val6} -> CpuNum = Val6
  end,
  case lists:keyfind(tagNum, 1, TL) of
    false -> TagNum = Sinfo#system_info.tagNum;
    {_, Val7} -> TagNum = Val7
  end,
  case lists:keyfind(postNum, 1, TL) of
    false -> PostNum = Sinfo#system_info.postNum;
    {_, Val8} -> PostNum = Val8
  end,
  case lists:keyfind(userNum, 1, TL) of
    false -> UserNum = Sinfo#system_info.userNum;
    {_, Val9} -> UserNum = Val9
  end,

  %% SchedId      = erlang:system_info(scheduler_id),
  %% SchedNum     = erlang:system_info(schedulers),
  %% ProcCount    = erlang:system_info(process_count),
  %% ProcLimit    = erlang:system_info(process_limit),
  %% ProcMemUsed  = erlang:memory(processes_used),
  %% ProcMemAlloc = erlang:memory(processes),
  %% MemTot       = erlang:memory(total),

  Test = util:tuplelist_to_json([{"A", "AAA"}, {"B", "BBB"}]),
  util:mark(?MODULE, Test),
  http_router:render_ok(Req, dtl_admin_sinfo, [{app_ver, AppVer},{hostname, Hostname},{erl_ver, ErlVer},{os, OS},{arch, Arch},{cpu_num, CpuNum},{postnum, PostNum},{tagnum, TagNum},{usernum, UserNum},{test,Test}]).