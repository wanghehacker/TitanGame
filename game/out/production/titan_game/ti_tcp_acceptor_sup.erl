%%%-------------------------------------------------------------------
%%% @author wanghe
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%% tcp acceptor 监控树
%%% @end
%%% Created : 26. 五月 2014 23:40
%%%-------------------------------------------------------------------
-module(ti_tcp_acceptor_sup).
-author("wanghe").

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% -define(SERVER, ?MODULE).

%%%===================================================================
%%% API functions
%%%===================================================================

start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%%%===================================================================
%%% Supervisor callbacks
%%%===================================================================

init([]) ->
  {ok, {{simple_one_for_one, 10, 10},
    [{
      ti_tcp_acceptor,
      {ti_tcp_acceptor,start_link,[]},
      transient,
      brutal_kill,
      worker,
      [ti_tcp_acceptor]
    }]}}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
