%%%-------------------------------------------------------------------
%%% @author wanghe
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. 五月 2014 15:14
%%%-------------------------------------------------------------------
-module(tt).
-author("wanghe").

-behaviour(gen_server).

%% API
-export([start_link/0]).

-compile(export_all).

%% gen_server callbacks
-export([init/1,
  handle_call/3,
  handle_cast/2,
  handle_info/2,
  terminate/2,
  code_change/3]).

-define(SERVER, ?MODULE).

-record(state, {socket}).

-include("common.hrl").
-include("record.hrl").

-define(CONFIG_FILE, "../config/gateway.config").
-define(GATEWAY_ADD,"127.0.0.1").
-define(GATEWAY_PORT,8777).
-define(HEADER_LENGTH, 6). % 消息头长度
-define(TCP_TIMEOUT, 1000). % 解析协议超时时间
-define(TCP_OPTS, [
  binary,
  {packet, 0}, % no packaging
  {reuseaddr, true}, % allow rebind without waiting
  {nodelay, false},
  {delay_send, true},
  {active, false},
  {exit_on_close, false}
]).

%%%===================================================================
%%% API
%%%===================================================================

start()->
  spawn(fun()->start_link() end).

start_link() ->
  case gen_server:start_link(?MODULE, [], []) of
    {ok,Pid}->
      case whereis(testtest) of
        Pid when is_pid(Pid)->
          unregister(testtest);
        undefined->
          register(testtest,Pid)
      end,
      case get_db_config(?CONFIG_FILE) of
        [Host, Port, User, Password, DB, Encode]->
          init_db(Host,Port,User,Password,DB,Encode),
          io:format("server ip ~p ,port ~p ~n",[Host,Port]),
          login(),
          rec();
        _->mysql_config_fail
      end,
     ok;
    {error,Reason}->
      io:format("error~p~n",[Reason])
  end.

rec()->
  receive
    {tcp, _Socket, Bin}->
      case Bin of
        <<_L:16,ProtoNum:16,Data/binary>>  ->
          io:format("~p/~p~n",[ProtoNum,Data]);
        B ->
          io:format("tcp receive:~p~n",[binary_to_list(B)])
      end;
    {tcp_closed,_Socket} ->
      io:format("socket closed!~n");
    BIN->
      io:format("no tcp BIN:~p~n",[BIN])
  end,
  rec().

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

init([]) ->
  io:format("init ok~n"),
  {ok, #state{}}.


handle_call({get_socket},_From,State)->
  {reply,State#state.socket,State};

handle_call({init_socket,Socket},_From,State)->
  S2=State#state{socket = Socket},
  {reply,ok,S2};

handle_call(_Request, _From, State) ->
  {reply, ok, State}.

handle_cast(_Request, State) ->
  {noreply, State}.

handle_info({cmd,Bin},State)->
  get_tcp:send(State#state.socket,Bin),
  {noreply,State};

handle_info({tcp,_Socket,Bin},State)->
  case Bin of
    <<_L:16,ProtoNum:16,Data/binary>>->
      io:format("~p/~p~n",[ProtoNum,Data]),
      ok;
    B->
      io:format("receive:~p~n",[binary_to_list(B)]),
      ok
  end,
  {noreply,State};

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.


code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

%%连接网关服务器
get_game_server()->
  io:format("server get_game_server~n"),
  case gen_tcp:connect(?GATEWAY_ADD,?GATEWAY_PORT, ?TCP_OPTS , 10000) of
    {ok, Socket}->
      Data = pt:pack(60000, <<>>),
      gen_tcp:send(Socket, Data),
%%       try
        case gen_tcp:recv(Socket, ?HEADER_LENGTH) of
          {ok, <<Len:32, 60000:16>>} ->
            io:format("get_game_server ok~n"),
%%        io:format("len: ~p ~n",[Len]),
            BodyLen = Len - ?HEADER_LENGTH,
            case gen_tcp:recv(Socket, BodyLen, 3000) of
              {ok, <<Bin/binary>>} ->
                <<Rlen:16, RB/binary>> = Bin,
                case Rlen of
                  1 ->
                    <<_Id:8, Bin1/binary>> = RB,
                    {IP, Bin2} = pt:read_string(Bin1),
                    <<Port:16, _State:8, _Num:16>> = Bin2,
                    io:format("IP, Port:  /~p/~p/~n",[IP, Port]),
                    {IP, Port};
                  _-> no_gameserver
                end;
              _ ->
                gen_tcp:close(Socket),
                error
            end;
          {error, Reason} ->
            io:format("error:~p~n",[Reason]),
            gen_tcp:close(Socket),
            error
        end;
%%       catch
%%         _:_ -> gen_tcp:close(Socket),
%%           io:format("catch error~n"),
%%           fail
%%       end;
    {error,_Reason}->
      error
  end.


%%登录游戏服务器
login()->
%% 	{Ip, Port} = {?SERVER_ADD, ?SERVER_PORT},
  case get_game_server() of
    {Ip, Port} ->
      case connect_server(Ip, Port) of
        {ok,_Socket}->
          io:format("server ip ~p ,port ~p ~n",[Ip,Port]),
%%           gen_server:call(whereis(testtest),{init_socket,Socket}),
%%           handle(login,{2012,integer_to_list(2012)},Socket),
%%           case get_player_id(2012) of
%%             0 ->
%%               handle(create_player, {1,1, 1,"2012"}, Socket),
%%               sleep(1000),
%%               PlayerId=get_player_id(2012),
%%               if
%%                 PlayerId /=0 ->
%%                   handle(enter_player, {PlayerId}, Socket);
%%                 true ->
%%                   io:format("player id error! ~n")
%%               end;
%%             PlayerId->
%%               handle(enter_player,{PlayerId},Socket)
%%           end,
          sleep(100);
        {error,_Reason}->
          error
      end;
    _-> error
  end.




init_db(Host, Port, User, Password, DB, Encode)->
  mysql:start_link(?DB_POOL, Host, Port, User, Password, DB, fun(_, _, _, _) -> ok end, Encode),
  mysql:connect(?DB_POOL, Host, Port, User, Password, DB, Encode, true),
  ok.


%%连接服务端
connect_server(Ip, Port)->
  gen_tcp:connect(Ip, Port,[binary,{packet,0}],10000).


get_db_config(Config_file)->
  try
    {ok,[L]} = file:consult(Config_file),
    {_, C} = lists:keyfind(gateway, 1, L),
    {_, Mysql_config} = lists:keyfind(mysql_config, 1, C),
    {_, Host} = lists:keyfind(host, 1, Mysql_config),
    {_, Port} = lists:keyfind(port, 1, Mysql_config),
    {_, User} = lists:keyfind(user, 1, Mysql_config),
    {_, Password} = lists:keyfind(password, 1, Mysql_config),
    {_, DB} = lists:keyfind(db, 1, Mysql_config),
    {_, Encode} = lists:keyfind(encode, 1, Mysql_config),
    [Host, Port, User, Password, DB, Encode]
  catch
    _:_ -> no_config
  end.

sleep(T) ->
  receive
  after T -> ok
  end.