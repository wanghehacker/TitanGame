%%%-------------------------------------------------------------------
%%% @author wanghe
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%% 游戏服务器应用启动
%%% @end
%%% Created : 24. 五月 2014 20:02
%%%-------------------------------------------------------------------
-module(ti_server_app).
-author("wanghe").
-include("common.hrl").

-behaviour(application).

%% Application callbacks
-export([start/2,
  stop/1]).

%%%===================================================================
%%% Application callbacks
%%%===================================================================


start(normal, []) ->
  io:format("oh fuck0 ~n"),
  ping_gateway(),
  io:format("oh fuck01 ~n"),
  titan:init_db(server),
  io:format("oh fuck02 ~n"),
  Tabs = [?ETS_SYSTEM_INFO, ?ETS_MONITOR_PID, ?ETS_STAT_SOCKET, ?ETS_STAT_DB],
  init_ets(Tabs),
  io:format("oh fuck 1 ~n"),
  [Port, Node_id, _Accept_num, _Max_connection] = config:get_tcp_listener(server),
  [Ip] = config:get_tcp_listener_ip(server),
  Log_level = config:get_log_level(server),
  loglevel:set(tool:to_integer(Log_level)),
  {ok, SupPid} = ti_server_sup:start_link(),
  ti_timer:start(ti_server_sup),
  ti_server:start(
    [Ip, tool:to_integer(Port), tool:to_integer(Node_id)]
  ),
%%
  io:format("oh fuck ~n"),
  {ok, SupPid}.


stop(_State) ->
  void.

%%%===================================================================
%%% Internal functions
%%%===================================================================

ping_gateway() ->
  case config:get_gateway_node(server) of
    undefine -> no_action;
    Gateway_node ->
      catch net_admin:ping(Gateway_node)
  end.

init_ets([]) ->
  ok;
init_ets([Tab | L]) ->
  ets:new(Tab, [set, public, named_table, ?ETSRC, ?ETSWC]),
  init_ets(L).