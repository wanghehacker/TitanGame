%%%-------------------------------------------------------------------
%%% @author wanghe
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. 五月 2014 11:17
%%%-------------------------------------------------------------------
-module(config).
-author("wanghe").

%% API
-export([]).

%%全部导出
-compile(export_all).

%% 获取 .config里的配置信息
get_log_level(App) ->
  case application:get_env(App, log_level) of
    {ok, Log_level} -> Log_level;
    _ -> 3
  end.

get_mysql_config(App) ->
  case application:get_env(App, mysql_config) of
    {ok, false} -> throw(undefined);
    {ok, Mysql_config} ->
      {_, Host} = lists:keyfind(host, 1, Mysql_config),
      {_, Port} = lists:keyfind(port, 1, Mysql_config),
      {_, User} = lists:keyfind(user, 1, Mysql_config),
      {_, Password} = lists:keyfind(password, 1, Mysql_config),
      {_, DB} = lists:keyfind(db, 1, Mysql_config),
      {_, Encode} = lists:keyfind(encode, 1, Mysql_config),
      [Host, Port, User, Password, DB, Encode];
    undefined -> throw(undefined)
  end.

get_mongo_config(App) ->
  case application:get_env(App, emongo_config) of
    {ok, false} -> throw(undefined);
    {ok, Emongo_config} ->
      {_, PoolId} = lists:keyfind(poolId, 1, Emongo_config),
      {_, EmongoSize} = lists:keyfind(emongoSize, 1, Emongo_config),
      {_, EmongoHost} = lists:keyfind(emongoHost, 1, Emongo_config),
      {_, EmongoPort} = lists:keyfind(emongoPort, 1, Emongo_config),
      {_, EmongoDatabase} = lists:keyfind(emongoDatabase, 1, Emongo_config),
      [PoolId, EmongoHost, EmongoPort, EmongoDatabase, EmongoSize];
    undefined -> throw(undefined)
  end.

get_log_mongo_config(App) ->
  case application:get_env(App, log_emongo_config) of
    {ok, false} -> throw(undefined);
    {ok, Emongo_config} ->
      {_, PoolId} = lists:keyfind(poolId, 1, Emongo_config),
      {_, EmongoSize} = lists:keyfind(emongoSize, 1, Emongo_config),
      {_, EmongoHost} = lists:keyfind(emongoHost, 1, Emongo_config),
      {_, EmongoPort} = lists:keyfind(emongoPort, 1, Emongo_config),
      {_, EmongoDatabase} = lists:keyfind(emongoDatabase, 1, Emongo_config),
      [PoolId, EmongoHost, EmongoPort, EmongoDatabase, EmongoSize];
    undefined -> throw(undefined)
  end.

get_slave_mongo_config(App) ->
  case application:get_env(App, slave_emongo_config) of
    {ok, false} -> throw(undefined);
    {ok, Emongo_config} ->
      {_, PoolId} = lists:keyfind(poolId, 1, Emongo_config),
      {_, EmongoSize} = lists:keyfind(emongoSize, 1, Emongo_config),
      {_, EmongoHost} = lists:keyfind(emongoHost, 1, Emongo_config),
      {_, EmongoPort} = lists:keyfind(emongoPort, 1, Emongo_config),
      {_, EmongoDatabase} = lists:keyfind(emongoDatabase, 1, Emongo_config),
      [PoolId, EmongoHost, EmongoPort, EmongoDatabase, EmongoSize];
    undefined -> get_mongo_config(App)
  end.


get_tcp_listener(App) ->
  case application:get_env(App, tcp_listener) of
    {ok, false} -> throw(undefined);
    {ok, Tcp_listener} ->
      try
        {_, Port} = lists:keyfind(port, 1, Tcp_listener),
        {_, Node_id} = lists:keyfind(node_id, 1, Tcp_listener),
        {_, Acceptor_num} = lists:keyfind(acceptor_num, 1, Tcp_listener),
        {_, Max_connections} = lists:keyfind(max_connections, 1, Tcp_listener),
        [Port, Node_id, Acceptor_num, Max_connections]
      catch
        _:_ -> exit({bad_config, {server, {tcp_listener, config_error}}})
      end;
    undefined -> throw(undefined)
  end.

get_tcp_listener_ip(App) ->
  case application:get_env(App, tcp_listener_ip) of
    {ok, false} -> throw(undefined);
    {ok, Tcp_listener_ip} ->
      try
        {_, Ip} = lists:keyfind(ip, 1, Tcp_listener_ip),
        [Ip]
      catch
        _:_ -> exit({bad_config, {server, {tcp_listener, config_error}}})
      end;
    undefined -> throw(undefined)
  end.


get_gateway_async_time() ->
  case application:get_env(gateway, gateway_async_time) of
    {ok, Async_time} -> Async_time;
    _ -> undefined
  end.