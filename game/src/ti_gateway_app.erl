%%%-------------------------------------------------------------------
%%% @author wanghe
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. 五月 2014 9:52
%%%-------------------------------------------------------------------
-module(ti_gateway_app).
-author("wanghe").

-behaviour(application).

%% Application callbacks
-export([start/2,stop/1]).
-include("common.hrl").

start(_StartType, _StartArgs) ->
  ets:new(?ETS_SYSTEM_INFO,[set,public,named_table,?ETSRC,?ETSWC]),
  ets:new(?ETS_MONITOR_PID,[set,public,named_table,?ETSRC,?ETSWC]),
  ets:new(?ETS_STAT_SOCKET,[set,public,named_table,?ETSRC,?ETSWC]),
  ets:new(?ETS_STAT_DB,[set,public,named_table,?ETSRC,?ETSWC]),

  [Port,Node_id,_Acceptor_num,_Max_connections] = config:get_tcp_listener(gateway),
  [Ip] = config:get_tcp_listener_ip(gateway),
  Log_level = config:get_log_level(gateway),
 %% io:format("~p~n",[Log_level]),
  loglevel:set(tool:to_integer(Log_level)),

  titan:init_db(gateway),
  %%gateway 启动5秒后将所有的玩家在线标志为0
  timer:apply_after(5000,db_agent,init_player_online_flag,[]),
  ti_gateway_sup:start_link([Ip, tool:to_integer(Port), tool:to_integer(Node_id)]),
  ti_timer:start(ti_gateway_sup).


stop(_State) ->
  void.
