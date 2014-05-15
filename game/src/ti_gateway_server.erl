%%%-------------------------------------------------------------------
%%% @author wanghe
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%% 网关TCP服务器
%%% @end
%%% Created : 14. 五月 2014 9:53
%%%-------------------------------------------------------------------
-module(ti_gateway_server).
-author("wanghe").

%% API
-export([start_raw_server/3,
        stop/1
     ]).

%%开启  TCP_SERVER
%%Port: 端口
%%Fun： 回调函数
%%Max:  最大连接数
start_raw_server(Port,Fun,Max)->
  Name = port_name(Port),
  case whereis(name) of
    undefined ->
      Self=self(),
      Pid = spawn(fun() -> code_start(Self,Port,Fun,Max) end),
      receive
        {Pid,ok}->
          register(Name,Pid);
        {Pid,Error}->
          Error
      end;
    _Pid ->
      {error,already_started}
  end.

%%停止TCP服务器
%%Port 端口
stop(Port) when is_integer(Port)->
  Name = port_name(Port),
  case whereis(Name) of
    undefined ->
      not_started;
    Pid->
      exit(Pid,kill),
      (catch unregister(Name)),
      stopped
  end.

%%获取所有子进程
%%Port 端口
children(Port) when is_integer(Port)->
  port_name(Port)!{children,self()},
  receive
    {session_server,Reply}->Reply
  end.

%%组合主进程
%%Port 端口
port_name(Port) when is_integer(Port)->
    list_to_atom("ti_game"++integer_to_list(Port)).

code_start(Master,Port,Fun,Max)


