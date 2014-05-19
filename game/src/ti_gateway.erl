%%%-------------------------------------------------------------------
%%% @author wanghe
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. 五月 2014 9:52
%%%-------------------------------------------------------------------
-module(ti_gateway).
-author("wanghe").

-behaviour(gen_server).

-include("common.hrl").

%% API
-export([start_link/1,server_stop/0]).

%% gen_server callbacks
-export([init/1,
  handle_call/3,
  handle_cast/2,
  handle_info/2,
  terminate/2,
  code_change/3]).

%%消息头长度
-define(HEADER_LENGTH,6).

-record(gatewayinit,{
  id=1,
  init_time=0,
  async_time=0
}).


%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% 开启网关
%% @end
%%--------------------------------------------------------------------
start_link(Port) ->
  misc:write_system_info(self(),tcp_listener,{"",Port,now()}),
  gen_server:start_link(?MODULE, [Port], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

init([Port]) ->
  misc:write_monitor_pid(self(),?MODULE,{}),
  F = fun(Sock)->handoff(Sock) end,
  ti_gateway_server:stop(Port),
  ti_gateway_server:start_raw_server(Port,F,?ALL_SERVER_PLAYERS),
  Now = util:unixtime(),
  Async_time =
    case config:get_gateway_async_time() of
      undefined -> 0;
      Second -> Second
    end,
  ets:new(gatewayinit,[{keypos,#gatewayinit.id},named_table,public,set,?ETSRC,?ETSWC]),
  ets:insert(gatewayinit,#gatewayinit{id=1,init_time = Now,async_time = Async_time}),
  %%开始统计进程  TODO 用到的时候再加统计进程
  %%{ok,Pid} =  mod_s
  {ok, true}.
%%关闭服务器过程禁止刷进游戏
server_stop()->
  Now = util:unixtime(),
  ets:insert(gatewayinit,#gatewayinit{id = 1,init_time = Now,async_time = 100}).

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%%
%% @end
%%--------------------------------------------------------------------
handle_call(_Request, _From, State) ->
  {reply, ok, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%%
%% @end
%%--------------------------------------------------------------------
handle_cast(_Request, State) ->
  {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%%
%% @spec handle_info(Info, State) -> {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
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
terminate(_Reason, _State) ->
  io:format("stop ~p~n",[_Reason]),
  ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% @end
%%--------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

%%发送要连接的IP和port到客户端，并关闭连接
handoff(Socket) ->
  case gen_tcp:recv(Socket, ?HEADER_LENGTH) of
    {ok, <<_Len:32, 60000:16>>} ->
      %%延时允许客户端连接
      [{_,_,InitTime,AsyncTime}] = ets:match_object(gatewayinit,#gatewayinit{id =1 ,_='_'}),
      Now = util:unixtime(),
      if
        Now - AsyncTime > InitTime  ->
          List = mod_disperse:get_server_list(),
          {ok, Data} = pt_60:write(60000, List),
          gen_tcp:send(Socket, Data),
          gen_tcp:close(Socket);
        true ->
          gen_tcp:close(Socket)
      end;
    {ok, <<Len:32, 60001:16>>} ->
      BodyLen = Len - ?HEADER_LENGTH,
      case gen_tcp:recv(Socket, BodyLen, 3000) of
        {ok, <<Bin/binary>>} ->
          {Accname, _} = pt:read_string(Bin),
          {ok, Data} = pt_60:write(60001, is_create(Accname)),
          gen_tcp:send(Socket, Data),
          handoff(Socket);
        _ ->
          gen_tcp:close(Socket)
      end;
    {ok, Packet} ->
      P = tool:to_list(Packet),
      P1 = string:left(P, 4),
      if (P1 == "GET " orelse P1 == "POST") ->
        P2 = string:right(P, length(P) - 4),
        misc_admin:treat_http_request(Socket, P2),
        gen_tcp:close(Socket);
        true ->
          gen_tcp:close(Socket)
      end;
    _Reason ->
      gen_tcp:close(Socket)
  end.


%% 是否创建角色
is_create(Accname) ->
  case db_agent:is_create(Accname) of
    [] ->
      0;
    _R ->
      1
  end.