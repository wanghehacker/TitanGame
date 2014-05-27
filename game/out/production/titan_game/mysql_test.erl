%%%-------------------------------------------------------------------
%%% @author wanghe
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 五月 2014 12:35
%%%-------------------------------------------------------------------
-module(mysql_test).
-author("wanghe").

%% API
-compile([export_all]).

-define(DB, mysql_conn).
-define(DB_HOST, "localhost").
-define(DB_PORT, 3306).
-define(DB_USER, "root").
-define(DB_PASS, "888888").
-define(DB_NAME, "titangate").
-define(DB_ENCODE, utf8).

conn() ->
  mysql:start_link(?DB, ?DB_HOST, ?DB_PORT, ?DB_USER, ?DB_PASS, ?DB_NAME, fun(_, _, _, _) -> ok end, ?DB_ENCODE),
  mysql:connect(?DB, ?DB_HOST, ?DB_PORT, ?DB_USER, ?DB_PASS, ?DB_NAME, ?DB_ENCODE, true),
  mysql:fetch(?DB, <<"truncate table test">>),
  ok.

test() ->
  mysql:fetch(?DB, <<"truncate table test">>),
  mysql:fetch(?DB, <<"begin">>),
  F = fun() ->
    db_sql:execute(io_lib:format(<<"insert into `test` (`row`,`r`) values ('~s',~p)">>, ["老子是来测试性能的", 123])),
    db_sql:execute(io_lib:format(<<"update `test` set `row` = '~s' where id = ~p">>, ["老子是来测试性能的", 1]))
  end,
  prof:run(F, 10000),
  mysql:fetch(?DB, <<"commit">>),
  ok.
