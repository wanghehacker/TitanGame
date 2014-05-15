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
    {ok,Emongo_config} ->
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
    {ok,Emongo_config} ->
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
    {ok,Emongo_config} ->
      {_, PoolId} = lists:keyfind(poolId, 1, Emongo_config),
      {_, EmongoSize} = lists:keyfind(emongoSize, 1, Emongo_config),
      {_, EmongoHost} = lists:keyfind(emongoHost, 1, Emongo_config),
      {_, EmongoPort} = lists:keyfind(emongoPort, 1, Emongo_config),
      {_, EmongoDatabase} = lists:keyfind(emongoDatabase, 1, Emongo_config),
      [PoolId, EmongoHost, EmongoPort, EmongoDatabase, EmongoSize];
    undefined -> get_mongo_config(App)
  end.