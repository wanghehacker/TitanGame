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
-include("common.hrl").

%% API
-export([start_raw_server/3,
  stop/1,
  children/1
]).

%%开启  TCP_SERVER
%%Port: 端口
%%Fun： 回调函数
%%Max:  最大连接数
start_raw_server(Port, Fun, Max) ->
  Name = port_name(Port),
  case whereis(Name) of
    undefined ->
      Self = self(),
      io:format("Self~p~n", [Self]),
      Pid = spawn(fun() -> code_start(Self, Port, Fun, Max) end),
      receive
        {Pid, ok} ->
          io:format("register~p~n", [Name]),
          register(Name, Pid);
        {Pid, Error} ->
          Error
      end;
    _Pid ->
      {error, already_started}
  end.

%%停止TCP服务器
%%Port 端口
stop(Port) when is_integer(Port) ->
  Name = port_name(Port),
  case whereis(Name) of
    undefined ->
      not_started;
    Pid ->
      exit(Pid, kill),
      (catch unregister(Name)),
      stopped
  end.

%%获取所有子进程
%%Port 端口
children(Port) when is_integer(Port) ->
  port_name(Port) ! {children, self()},
  receive
    {session_server, Reply} -> Reply
  end.

%%组合主进程
%%Port 端口
port_name(Port) when is_integer(Port) ->
  list_to_atom("ti_game" ++ integer_to_list(Port)).

%%打开监听
%%Master：主进程
%%Port:端口
%%Fun:回调
%%Max:最大连接数
code_start(Master, Port, Fun, Max) ->
  process_flag(trap_exit, true),
  case gen_tcp:listen(Port, ?TCP_OPTIONS) of
    {ok, Listen} ->
      Master ! {self(), ok},
      New = start_accept(Listen, Fun),
      socket_loop(Listen, New, [], Fun, Max);
    Error ->
      Master ! {self(), Error}
  end.

%%循环接收外部连接
%%Listen：
%%New:当前外部连接子进程
%%Active:所有的子进程
%%Fun:回调
%%Max:最大连接数
socket_loop(Listen, New, Active, Fun, Max) ->
  receive
    {istarted, New} ->
      Active1 = [New | Active],
      possibly_start_another(false, Listen, Active1, Fun, Max);
    {'EXIT', New, _Why} ->
      possibly_start_another(false, Listen, Active, Fun, Max);
    {'EXIT', Pid, _Why} ->
      Active1 = lists:delete(Pid, Active),
      possibly_start_another(New, Listen, Active1, Fun, Max);
    {children, From} ->
      From ! {session_server, Active},
      socket_loop(Listen, New, Active, Fun, Max);
    Other ->
      ?DEBUG("Here in loop:~p~n", [Other])
  end.

%%开始一个新的子进程
possibly_start_another(New, Listen, Active, Fun, Max) when is_pid(New) ->
  socket_loop(Listen, New, Active, Fun, Max);

possibly_start_another(false, Listen, Active, Fun, Max) ->
  case length(Active) of
    N when N < Max ->
      New = start_accept(Listen, Fun),
      socket_loop(Listen, New, Active, Fun, Max);
    _ ->
      error_logger:warning_report(
        [{module, ?MODULE},
          {line, ?LINE},
          {message, "connections maxed out"},
          {maximum, Max},
          {connected, length(Active)},
          {now, now()}]),
      socket_loop(Listen, false, Active, Fun, Max)
  end.

start_accept(Listen, Fun) ->
  S = self(),
  spawn_link(fun() -> start_child(S, Listen, Fun) end).

start_child(Parent, Listen, Fun) ->
  case gen_tcp:accept(Listen) of
    {ok, Socket} ->
      io:format("accept a socket"),
      Parent ! {istarted, self()},
      Fun(Socket);
    _Other ->
      io:format("accept a socket false"),
      exit(oops)
  end.


