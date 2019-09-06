%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. 八月 2019 14:54
%%%-------------------------------------------------------------------
-module(db).
-author("Administrator").
-include("common.hrl").

-define(POOLNAME, mysql_pool).

%% API
-export([get_all/2, get_rows/2, get_row/2, get_one/2, get_one/3, exec/2]).

db_lists_to_tl(L) ->
  F = fun(L) -> [Name, Val] = L, {erlang:binary_to_atom(Name, utf8), erlang:binary_to_list(Val)} end,
  [ F(Item) || Item <- L].

%% @desc
%% @param Mod sql exec mod.
%% @param sql
%% @return {[column1, column2], [[row1&column1, row1&column2],[row2&column1, row2&column2]]} | default {[] , []}
get_all(Mod, Sql) ->
  case mysql_poolboy:query(?POOLNAME, Sql) of
    {error, TupleMsg} -> util:elog(Mod, tuple_to_list(TupleMsg)), {[],[]};
    {ok, Columns, Rows} -> {Columns, Rows};
    _ -> {[],[]}
  end.

%% @return [[row1&column1, row1&column2],[row2&column1, row2&column2]] || default []
get_rows(Mod, Sql) ->
  case mysql_poolboy:query(?POOLNAME, Sql) of
    {error, TupleMsg} -> util:elog(Mod, tuple_to_list(TupleMsg)), [];
    {ok, _, Rows} -> Rows;
    _ -> []
  end.

%% @return [row1&column1, row1&column2],[row2&column1, row2&column2] || default []
get_row(Mod, Sql) ->
  case mysql_poolboy:query(?POOLNAME, Sql) of
    {error, TupleMsg} -> util:elog(Mod, tuple_to_list(TupleMsg)), [];
    {ok, _, []} -> [];
    {ok, _, Rows} -> [Row | _ ] = Rows, Row;
    _ -> []
  end.

%% @return string | default false
get_one(Mod, Sql) ->
  case mysql_poolboy:query(?POOLNAME, Sql) of
    {error, TupleMsg} -> util:elog(Mod, tuple_to_list(TupleMsg)), false;
    {ok, _, []} -> false;
    {ok, _, Rows} -> [Row | _] = Rows, [Val | _ ] = Row, Val;
    _ -> false
  end.

get_one(Mod, Sql, Default) ->
  case mysql_poolboy:query(?POOLNAME, Sql) of
    {error, TupleMsg} -> util:elog(Mod, tuple_to_list(TupleMsg)), Default;
    {ok, _, []} -> Default;
    {ok, _, Rows} -> [Row | _] = Rows, [Val | _ ] = Row, Val;
    _ -> Default
  end.

exec(Mod, Sql) ->
  case mysql_poolboy:query(?POOLNAME, Sql) of
    {error, TupleMsg} -> util:elog(Mod, tuple_to_list(TupleMsg)), false;
    _ -> ok
  end.