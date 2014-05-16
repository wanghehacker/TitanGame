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
-export([start_link/1]).

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
  stop_server_access_self/1
]).
-define(SERVER, ?MODULE).

-include("common.hrl").
-include("record.hrl").

-define(TIMER,1000*5).
-record(state,{
  id,
  ip,
  port,
  node,
  stop_access=0
}).

%%查询当前分区id
%%返回int
server_id()->
  gen_server:call(?MODULE,gen_server_id).

%%分区列表
server_list()->
  ets:tab2list(?ETS_SERVER).

%%接收其他分区加入的消息
rpc_server_add(Id,Node,Ip,Port)->
  gen_server:cast(?MODULE,{rpc_server_add,Id,Node,Ip,Port}).

%%接收其他分区状态更新
rpc_server_update(Id,Num)->
  gen_server:cast(?MODULE,{rpc_server_update,Id,Num}).

rpc_server_update_sc(Id)->
  gen_server:cast(?MODULE,{rpc_server_update_sc,Id}).

stop_server_access(Val)->
  lists:foreach(fun(N)->rpc:cast(N,mod_disperse,stop_server_access_self,[Val]) end,nodes()).

stop_server_access_self(Val)->
  gen_server:cast(?MODULE,{stop_server_access,Val}).





start_link([Ip,Port,Node_id]) ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [Ip,Port,Node_id], []).

%%
%%
init([Ip,Port,Node_id]) ->
  net_kernel:monitor_nodes(true),
  %%服务器列表
  ets:new(?ETS_SERVER,[{keypos,#server.id},named_table,public,set,?ETSRC,?ETSWC]),
  State = #state{id=Node_id,ip=Ip,port=Port,node=node(),stop_access = 0},
  add_server_db([State#state.ip,State#state.port,State#state.id,State#state.node]),
  %%存储连接的服务器
  ets:new(?ETS_GET_SERVER,[named_table,public,set,?ETSRC,?ETSWC]),
  erlang:send_after(100,self(),{event,get_and_call_server}),
  misc:write_monitor_pid(self(),?MODULE,{}),
  %%获取系统负载
  erlang:send_after(1000,self(),{fetch_node_load}),
  {ok, State}.




%%新线加入
handle_cast({rpc_server_add,Id,Node,Ip,Port}, State) ->
  case Id of
    0 -> skip;
    _ ->
      ets:insert(?ETS_SERVER,#server{id=Id,node=Node,ip=Ip,port=Port,stop_access = 0})
  end,
  {noreply, State};

%% 关闭节点访问
handle_cast({stop_server_access,Val},State)->
  io:format("stop_server_access__/~p/~n",[[Val,State#state.node,State#state.ip]]),
  [ValAtom,ValStr] =
    case Val of
      _ when is_atom(Val)->
        [Val,tool:to_list(Val)];
      _ when is_list(Val)->
        [tool:to_atom(Val),Val];
      _ ->
        [Val,Val]
    end,
  if
    State#state.node =:= ValAtom orelse State#state.ip =:= ValStr->
      Num = ets:info(?ETS_ONLINE,size),
      NewServer =
        #server{
          id=State#state.id,
          node = State#state.node,
          ip = State#state.ip,
          port = State#state.port,
          num = Num,
          stop_access = 1
        },
      ets:insert(?ETS_SERVER,NewServer),
      %%broadcast_server_state_sc(State#state.id),
      {noreply,State#state{stop_access = 1}};
    true ->
      {noreply,State}
  end;

handle_cast({rpc_server_update,Id,Num},State)->
  case ets:lookup(?ETS_SERVER,Id) of
    [S] -> ets:insert(?ETS_SERVER,S#server.num=Num);
    _   -> skip
  end,
  {noreply,State};

handle_cast({rpc_server_update_sc,Id},State)->
  case ets:lookup(?ETS_SERVER,Id) of
    [S] -> ets:insert(?ETS_SERVER,S#server{stop_access = 1});
    _ -> skip
  end,
  {noreply,State}.


%%获取战区ID号
%%
handle_call(get_server_id, _From, State) ->
  {reply, State#state.id, State};

%%获取服务器列表
handle_call(get_server_list,_From,State)->
  {reply,ok,State};

%%
handle_call(_R,_FROM,State)->
  {reply,ok,State}.


handle_info(_Info, State) ->
  {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%%
%% @spec terminate(Reason, State) -> void()
%% @end
%%--------------------------------------------------------------------
-spec(terminate(Reason :: (normal | shutdown | {shutdown, term()} | term()),
    State :: #state{}) -> term()).
terminate(_Reason, _State) ->
  ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% @end
%%--------------------------------------------------------------------
-spec(code_change(OldVsn :: term() | {down, term()}, State :: #state{},
    Extra :: term()) ->
  {ok, NewState :: #state{}} | {error, Reason :: term()}).
code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
