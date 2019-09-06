%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. 七月 2019 19:50
%%%-------------------------------------------------------------------
-module(http_router).
-author("silent").

%% API
-compile(export_all).
-record(http_status,{
   unresolve_400      = 400
  ,unauth_401         = 401
  ,forbidden_403      = 403
  ,notfound_404       = 404
  ,reqtimeout_408     = 408   %%  服务器等候请求时发生超时
  ,srverror_500       = 500
  ,badgate_502        = 502
  ,srvunreachable_503 = 503
  ,gwtimeout_504      = 504   %%  （网关超时） 服务器作为网关或代理，但是没有及时从上游服务器收到请求
  ,badhttpver_505     = 505
  ,ok                 = 200
}).

dispatch(Req, Path)->
  Method = Req:get(method),
  P1 = string:sub_word(Path, 1, $/),
  P2 = string:sub_word(Path, 2, $/),
  P3 = string:sub_word(Path, 3, $/),
  %% case order should not be changed.
  case {P1, P2, P3} of
    {F, [], []} ->
      MaybeFun = list_to_atom(F),
      invoke(3, Method, Req, app_index, MaybeFun);

    {M, F, []} ->
      MaybeMod = list_to_atom(string:concat("app_", M)),
      MaybeFun = list_to_atom(F),
      invoke(2, Method, Req, MaybeMod, MaybeFun);

    {A, M, F} when A == "app" orelse A == "admin" orelse A == "rpc" orelse A == "api" ->
      MaybeMod = list_to_atom(A++"_"++M),
      MaybeFun = list_to_atom(F),
      invoke(1, Method, Req, MaybeMod, MaybeFun);
    _ ->
      none
  end.

%%  Flag: Condition Mark.
%%  Meth: POST / GET.
%%  MochiRequest: Req
%%  M: module
%%  F: Func
invoke(Flag, Meth, Req, Mod, Func) ->
  try
    apply(Mod, Func, [Meth, Req])
  catch
    State : Reason ->
      Body = io_lib:format("[~p] Fail To Invoke ~p:~p, [state] ~p, [reason] ~p [stacktrace] ~p", [Flag, Mod, Func, State, Reason, erlang:get_stacktrace()]),
      render_error(#http_status.srverror_500, Req, Body)
  end.

render_error(Code, Req, Body) ->
  mochiweb_request:respond({Code, [{"Content-Type", "text/plain"}], Body}, Req).

render_ok(Req, TemplateModule, Params) ->
  try
    case TemplateModule:render(Params) of
      {ok, Output} ->
        % Here we use mochiweb_request:ok/1 to render a reponse
        Req:ok({"text/html", Output})
    end
  catch
    State : Reason ->
      Body = io_lib:format("Fail to rander ~p , [state] ~p, [reason] ~p [stacktrace] ~p", [Params, State,Reason, erlang:get_stacktrace()]),
      render_error(#http_status.srverror_500, Req, Body)
  end.

