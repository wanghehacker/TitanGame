%%%-------------------------------------------------------------------
%%% @author wanghe
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%% 客户端服务监控树
%%% @end
%%% Created : 26. 五月 2014 16:51
%%%-------------------------------------------------------------------
-module(ti_tcp_client_sup).
-author("wanghe").

-behaviour(supervisor).

%% API
-export([start_link/0]).
%% Supervisor callbacks
-export([init/1]).

%%%===================================================================
%%% API functions
%%%===================================================================

start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%%%===================================================================
%%% Supervisor callbacks
%%%===================================================================

init([]) ->
  {ok,{{simple_one_for_one,10,10},
    [{ti_server_reader,{ti_server_reader,start_link,[]},
      temporary,brutal_kill,worker,[ti_server_reader]}]}}.
