%%%-------------------------------------------------------------------
%%% @author wanghe
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%% 游戏服务器
%%% @end
%%% Created : 25. 五月 2014 12:56
%%%-------------------------------------------------------------------
-module(ti_server).
-author("wanghe").

%% API
-export([start/1]).
-compile([export_all]).

start([Ip, Port, Node_id]) ->
  io:format("init start ...\n"),
  misc:write_system_info(self(), tcp_listener, {Ip, Port, now()}),

  inets:start(),

  timer:sleep(1000),
  io:format("the global Pro ok! Please start the next node.. \n"),
  ok.

start_kernel() ->
  {ok, _} = supervisor:start_child(
    ti_server_sup,
    {mod_kernel,
      {
        mod_kernel, start_link, []
      },
      permanent, 10000, supervisor, [mod_kernel]
    }),
  ok.