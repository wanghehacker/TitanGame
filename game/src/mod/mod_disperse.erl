%%%-------------------------------------------------------------------
%%% @author wanghe
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%% 游戏服务器路由器
%%% @end
%%% Created : 16. 五月 2014 13:49
%%%-------------------------------------------------------------------
-module(mod_disperse).
-author("wanghe").
-behaviour(gen_server).
%% API
-export([start_link/3]).

%% gen_server callbacks
-export([init/1,
  handle_call/3,
  handle_cast/2,
  handle_info/2,
  terminate/2,
  code_change/3]).

-export([
  server_id/0,
  server_list/0,
  rpc_server_add/4,
  rpc_server_update/2,
  rpc_server_update_sc/1,
  stop_server_access/1,
  stop_server_access_self/1,
  broadcast_to_world/2,
  stop_game_server/1,
  load_base_data/2,
  online_state/0,
  broadcast_server_state_sc/1,
  reload_base_data/2,
  get_server_list/0
]).
-define(SERVER, ?MODULE).

-include("common.hrl").
-include("record.hrl").

-define(TIMER, 1000 * 5).
-record(state, {
  id,
  ip,
  port,
  node,
  stop_access = 0
}).

%%查询当前分区id
%%返回int
server_id() ->
  gen_server:call(?MODULE, gen_server_id).

%%分区列表
server_list() ->
  ets:tab2list(?ETS_SERVER).

%%接收其他分区加入的消息
rpc_server_add(Id, Node, Ip, Port) ->
  gen_server:cast(?MODULE, {rpc_server_add, Id, Node, Ip, Port}).

%%接收其他分区状态更新
rpc_server_update(Id, Num) ->
  gen_server:cast(?MODULE, {rpc_server_update, Id, Num}).

rpc_server_update_sc(Id) ->
  gen_server:cast(?MODULE, {rpc_server_update_sc, Id}).

stop_server_access(Val) ->
  lists:foreach(fun(N) -> rpc:cast(N, mod_disperse, stop_server_access_self, [Val]) end, nodes()).

stop_server_access_self(Val) ->
  gen_server:cast(?MODULE, {stop_server_access, Val}).

start_link(Ip, Port, Node_id) ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [Ip, Port, Node_id], []).

%%
%%
init([Ip, Port, Node_id]) ->
  net_kernel:monitor_nodes(true),
  %%服务器列表
  ets:new(?ETS_SERVER, [{keypos, #server.id}, named_table, public, set, ?ETSRC, ?ETSWC]),
  State = #state{id = Node_id, ip = Ip, port = Port, node = util:term_to_string(node()), stop_access = 0},
  add_server_db([State#state.ip, State#state.port, State#state.id, State#state.node]),
  %%存储连接的服务器
  ets:new(?ETS_GET_SERVER, [named_table, public, set, ?ETSRC, ?ETSWC]),
  erlang:send_after(100, self(), {event, get_and_call_server}),
  misc:write_monitor_pid(self(), ?MODULE, {}),
  %%获取系统负载
  erlang:send_after(1000, self(), {fetch_node_load}),
  {ok, State}.


%%新线加入
handle_cast({rpc_server_add, Id, Node, Ip, Port}, State) ->
  case Id of
    0 -> skip;
    _ ->
      ets:insert(?ETS_SERVER, #server{id = Id, node = Node, ip = Ip, port = Port, stop_access = 0})
  end,
  {noreply, State};

%% 关闭节点访问
handle_cast({stop_server_access, Val}, State) ->
  io:format("stop_server_access__/~p/~n", [[Val, State#state.node, State#state.ip]]),
  [ValAtom, ValStr] =
    case Val of
      _ when is_atom(Val) ->
        [Val, tool:to_list(Val)];
      _ when is_list(Val) ->
        [tool:to_atom(Val), Val];
      _ ->
        [Val, Val]
    end,
  if
    State#state.node =:= ValAtom orelse State#state.ip =:= ValStr ->
      Num = ets:info(?ETS_ONLINE, size),
      NewServer =
        #server{
          id = State#state.id,
          node = State#state.node,
          ip = State#state.ip,
          port = State#state.port,
          num = Num,
          stop_access = 1
        },
      ets:insert(?ETS_SERVER, NewServer),
      %%broadcast_server_state_sc(State#state.id),
      {noreply, State#state{stop_access = 1}};
    true ->
      {noreply, State}
  end;

handle_cast({rpc_server_update, Id, Num}, State) ->
  case ets:lookup(?ETS_SERVER, Id) of
    [S] -> ets:insert(?ETS_SERVER, S#server{num = Num});
    _ -> skip
  end,
  {noreply, State};

handle_cast({rpc_server_update_sc, Id}, State) ->
  case ets:lookup(?ETS_SERVER, Id) of
    [S] -> ets:insert(?ETS_SERVER, S#server{stop_access = 1});
    _ -> skip
  end,
  {noreply, State}.


%%获取战区ID号
%%
handle_call(get_server_id, _From, State) ->
  {reply, State#state.id, State};

%%获取服务器列表
handle_call(get_server_list, _From, State) ->
  {reply, ok, State};

%%
handle_call(_R, _FROM, State) ->
  {reply, ok, State}.

%%获取并通知当前所有线路
handle_info({event, get_and_call_server}, State) ->
  get_and_call_server(State),
  {noreply, State};
%%统计当前线路人数并广播给其他线路
handle_info(online_num_update, State) ->
  case State#state.id of
    0 -> skip;
    _ ->
      Num = ets:info(?ETS_ONLINE, size),
      ets:insert(?ETS_SERVER,
        #server{
          id = State#state.id,
          node = State#state.node,
          ip = State#state.ip,
          port = State#state.port,
          num = Num
        }),
      Server = server_list(),
      broadcast_server_state(Server, State#state.id, Num)
  end,
  {noreply, State};

%%获取最低负载节点
handle_info({fetch_node_load}, State) ->
  if State#state.id == 0 ->
    List =
      case server_list() of
        [] -> [];
        Server ->
          F = fun(S) ->
            [State0, Num, System_Status] =
              case S#server.stop_access of
                1 ->
                  [4, 0, 9999999999];
                _ ->
                  case rpc:call(S#server.node, mod_disperse, online_state, []) of
                    {badrpc, _} ->
                      [4, 0, 9999999999];
                    Ret ->
                      Ret
                  end
              end,
            [S#server.id, S#server.ip, S#server.port, State0, Num, System_Status]
          end,
          [F(S) || S <- Server]
      end,
    Server_member_list = lists:map(fun([_, _, _, _, Num, _]) -> Num end, List),
    Online_count = lists:sum(Server_member_list),
    List1 = lists:filter(fun([_, _, _, _, _, S1]) -> S1 < 900000000 end, List),
    Low = find_game_server_minimum(List1, Online_count),
    case length(Low) > 0 of
      true ->
        ets:insert(?ETS_GET_SERVER, {get_list, Low});
      false ->
        skip
    end;
    true ->
      skip
  end,
  erlang:send_after(?TIMER, self(), {fetch_node_load}),
  {noreply, State};

%%处理新节点加入事件
handle_info({node_up, Node}, State) ->
  try
    rpc:call(Node, mod_disperse, rpc_server_add, [State#state.id, State#state.node, State#state.ip, State#state.port]),
    ok
  catch
    _:_ ->
      skip
  end,
  {noreply, State};
%%处理节点关闭事件
handle_info({nodedown, Node}, State) ->
  case ets:match_object(?ETS_SERVER, #server{node = Node, _ = '_'}) of
    [_Z] ->
      ets:match_delete(?ETS_SERVER, #server{node = Node, _ = '_'});
    _ ->
      skip
  end,
  {noreply, State};

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  misc:delete_monitor_pid(self()),
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
%% 广播到其它节点的世界频道
broadcast_to_world([], _Data) -> ok;
broadcast_to_world([H | T], Data) ->
  rpc:cast(H#server.node, lib_send, send_to_local_all, [Data]),
  broadcast_to_world(T, Data).


%% 广播当前在线给其它线
broadcast_server_state([], _Id, _Num) -> ok;
broadcast_server_state([H | T], Id, Num) ->
  rpc:cast(H#server.node, mod_disperse, rpc_server_update, [Id, Num]),
  broadcast_server_state(T, Id, Num).

%% 广播当前在线给其它线
broadcast_server_state_sc(Id) ->
  lists:foreach(fun(N) -> rpc:cast(N, mod_disperse, rpc_server_update_sc, [Id]) end, nodes()).


%%加入服务器集群
add_server_db([Ip, Port, Sid, Node]) ->
  db_agent:add_server([Ip, Port, Sid, Node]).

%% 安全退出游戏服务器集群
stop_game_server([]) -> ok;
stop_game_server([H | T]) ->
%%     rpc:cast(H#server.node, mod_login, stop_all, []),
  rpc:cast(H#server.node, yg, server_stop, []),
  stop_game_server(T).

%% 请求节点加载基础数据
load_base_data([], _Parm) -> ok;
load_base_data([H | T], Parm) ->
  rpc:cast(H#server.node, mod_kernel, load_base_data, Parm),
  load_base_data(T, Parm).

%% 重新加载基础数据
reload_base_data([], _Parm) -> ok;
reload_base_data([H | T], Parm) ->
  rpc:cast(H#server.node, mod_kernel, reload_base_data, Parm),
  reload_base_data(T, Parm).

%%退出服务器集群
del_server_db(Sid) ->
  db_agent:del_server(Sid).

%%获取并通知所有线路信息
get_and_call_server(State) ->
  case db_agent:select_all_server() of
    [] ->
      [];
    Server ->
      F = fun([Id, Ip, Port, Node, _ ]) ->
        Node1 = list_to_atom(binary_to_list(Node)),
        Ip1 = binary_to_list(Ip),
        case Id /= State#state.id of  % 自己不写入和不通知
          true ->
            case net_adm:ping(Node1) of
              pong ->
                case Id /= 0 of
                  true ->
                    ets:insert(?ETS_SERVER,
                      #server{
                        id = Id,
                        node = Node1,
                        ip = Ip1,
                        port = Port
                      }
                    );
                  false ->
                    ok
                end,
                %% 通知已有的线路加入当前线路的节点，包括线路0网关
                try
                  rpc:cast(Node1, mod_disperse, rpc_server_add, [State#state.id, State#state.node, State#state.ip, State#state.port])
                catch
                  _:_ -> error
                end;
              pang ->
                del_server_db(Id)
            end;
          false ->
            ok
        end
      end,
      [F(S) || S <- Server]
  end.


%% 获取服务器列表
get_server_list() ->
  case ets:match(?ETS_GET_SERVER, {get_list, '$1'}) of
    [LS] ->
%% io:format("get_server_list__/~p/~n",[LS]),
      case length(LS) > 0 of
        true -> hd(LS);
        false -> LS
      end;
    [] -> []
  end.


find_game_server_minimum(L, Online_count) ->
%% io:format("Online_count__/~p/~n",[[L, Online_count]]),
  if length(L) == 0 -> [];
    true ->
      NL = lists:sort(fun([_, _, _, _, _, S1], [_, _, _, _, _, S2]) -> S1 < S2 end, L),
      [[Id, Ip, Port, State, _Num, System_Status] | _] = NL,
      [[Id, Ip, Port, State, Online_count, System_Status]]
  end.

%% 在线状况
online_state() ->
  System_load = get_system_load(),
  case ets:info(?ETS_ONLINE, size) of
    undefined ->
      [0, 0, 0];
    Num when Num < 200 -> %顺畅
      [1, Num, System_load];
    Num when Num > 200, Num < 500 -> %正常
      [2, Num, System_load];
    Num when Num > 500, Num < 800 -> %繁忙
      [3, Num, System_load];
    Num when Num > 800 -> %爆满
      [4, Num, System_load]
  end.


%% 获取系统负载
get_system_load() ->
  Load_fact = 10,  %% 全局进程负载权重
  Load_fact_more = 20,  %% 全局进程负载权重2
  If_mod_guild =
    case ets:match(?ETS_MONITOR_PID, {'$1', mod_guild, '$3'}) of
      [[_GuildPid, _]] -> Load_fact;
      _ -> 0
    end,

  If_mod_sale =
    case ets:match(?ETS_MONITOR_PID, {'$1', mod_sale, '$3'}) of
      [[_SalePid, _]] -> Load_fact;
      _ -> 0
    end,

  If_mod_rank =
    case ets:match(?ETS_MONITOR_PID, {'$1', mod_rank, '$3'}) of
      [[_RankPid, _]] -> Load_fact;
      _ -> 0
    end,

  If_mod_delayer =
    case ets:match(?ETS_MONITOR_PID, {'$1', mod_delayer, '$3'}) of
      [[_delayerPid, _]] -> Load_fact;
      _ -> 0
    end,

  If_mod_master_apprentice =
    case ets:match(?ETS_MONITOR_PID, {'$1', mod_master_apprentice, '$3'}) of
      [[_MasterPid, _]] -> Load_fact;
      _ -> 0
    end,

  If_mod_shop =
    case ets:match(?ETS_MONITOR_PID, {'$1', mod_shop, '$3'}) of
      [[_ShopPid, _]] -> Load_fact;
      _ -> 0
    end,

  If_mod_kernel =
    case ets:match(?ETS_MONITOR_PID, {'$1', mod_kernel, '$3'}) of
      [[_KernelPid, {Val}]] -> Val;
      _ -> 0
    end,

  If_mod_analytics =
    case ets:match(?ETS_MONITOR_PID, {'$1', dungeon_analytics, '$3'}) of
      [[_AnalyticsPid, _]] -> Load_fact;
      _ -> 0
    end,

  If_mod_vip =
    case ets:match(?ETS_MONITOR_PID, {'$1', vip, '$3'}) of
      [[_VipPid, _]] -> Load_fact;
      _ -> 0
    end,

  If_mod_consign =
    case ets:match(?ETS_MONITOR_PID, {'$1', consign, '$3'}) of
      [[_CconsignPid, _]] -> Load_fact;
      _ -> 0
    end,

  If_mod_carry =
    case ets:match(?ETS_MONITOR_PID, {'$1', carry, '$3'}) of
      [[_CcarryPid, _]] -> Load_fact_more;
      _ -> 0
    end,

  If_mod_arena =
    case ets:match(?ETS_MONITOR_PID, {'$1', arena, '$3'}) of
      [[_AarenaPid, _]] -> Load_fact_more;
      _ -> 0
    end,

  If_mod_ore_sup =
    case ets:match(?ETS_MONITOR_PID, {'$1', ore_sup, '$3'}) of
      [[_Oore_supPid, _]] -> Load_fact_more;
      _ -> 0
    end,

  If_mod_answer =
    case ets:match(?ETS_MONITOR_PID, {'$1', answer, '$3'}) of
      [[_AanswerPid, _]] -> Load_fact;
      _ -> 0
    end,

%%   ScenePlayerCount = ets:info(?ETS_ONLINE_SCENE, size),
  ConnectionCount = ets:info(?ETS_ONLINE, size),

  Mod_load = If_mod_guild + If_mod_sale + If_mod_rank + If_mod_delayer + If_mod_master_apprentice + If_mod_shop + If_mod_kernel + If_mod_analytics + If_mod_vip + If_mod_consign + If_mod_carry + If_mod_arena + If_mod_ore_sup + If_mod_answer,
%% 	yg_timer:cpu_time() + Mod_load + ScenePlayerCount/100.
  ti_timer:cpu_time() + Mod_load + ConnectionCount / 10.



