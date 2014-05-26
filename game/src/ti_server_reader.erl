%%%-------------------------------------------------------------------
%%% @author wanghe
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. 五月 2014 17:08
%%%-------------------------------------------------------------------
-module(ti_server_reader).
-author("wanghe").

%% API
-export([start_link/0,init/0]).

-define(TCP_TIMEOUT,1000).
-define(HEART_TIMEOUT, 60*1000). % 心跳包超时时间
-define(HEADER_LENGTH,6).

-record(client,{
  player_pid = undefined,
  player_id = 0,
  login = 0,
  accid=0,
  accname = undefined,
  timeout=0,
  sn = 0,
  socketN=0
}).


start_link()->
  {ok,proc_lib:spawn_link(?MODULE,init,[])}.

init()->
  process_flag(trap_exit,true),
  Client = #client,
  receive
    {go,Socket}->
      login_parse_socket(Socket,Client);
     _->
       skip
  end.

login_parse_socket(Socket,Client)->
  Ref = async_recv(Socket,?HEADER_LENGTH,?HEART_TIMEOUT),
  receive
    {inet_async,Socket,Ref,{ok,<<Len:32,Cmd:16>>}}->
      BodyLen = Len - ?HEADER_LENGTH,
      case BodyLen>0 of
        true->
          t;
        false->
          f
      end
  end,
  ok.


async_recv(Sock,Length,Timeout) when is_port(Sock)->
  case prim_inet:async_recv(Sock,Length,Timeout) of
    {error,Reason}-> throw({Reason});
    {ok,Res}      ->Res;
    Res           ->Res
  end.

