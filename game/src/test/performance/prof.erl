%%%-------------------------------------------------------------------
%%% @author wanghe
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 五月 2014 12:54
%%%-------------------------------------------------------------------
-module(prof).
-author("wanghe").

%% API
-compile([export_all]).

%%性能测试
%%Fun:函数
%%Loop:执行次数
run(Fun, Loop) ->
  statistics(wall_clock),
  for(1, Loop, Fun),
  {_, T1} = statistics(wall_clock),
  io:format("~p loops, using time: ~pms~n", [Loop, T1]),
  ok.

for(Max, Max, Fun) ->
  Fun();
for(I, Max, Fun) ->
  Fun(), for(I + 1, Max, Fun).