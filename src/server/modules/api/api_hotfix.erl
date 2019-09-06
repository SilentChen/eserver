%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 02. 九月 2019 12:37
%%%-------------------------------------------------------------------
-module(api_hotfix).
-author("Administrator").

%% API
-export([]).

%%test('POST', Req)->
%%  PostData = Req:parse_post(),
%%  Json=util:tuplelist_to_json(PostData),
%%  util:printf(Json),
%%  Jdatalist = mochijson2:decode(Json),
%%  [ util:printf(list) || {struct, Item} <- Jdatalist],
%%  mochiweb_request:respond({200, [{"Content-Type", "text/plain"}], "test"}, Req).

hot_files('POST', Req)->
  case Req:parse_post() of
    []->
      http_router:render_error(500, Req, "bad parameters");
    Pdata->
      try
        Jdata = mochijson2:decode(Pdata)
      catch
        State : Reason ->
        http_router:render_error(500, Req, "not validate json post data.")
      end
  end.
