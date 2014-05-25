%%%-------------------------------------------------------------------
%%% @author wanghe
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. 五月 2014 20:01
%%%-------------------------------------------------------------------
-module(ti_server_sup).
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

%% start_child(Mod) ->
%%   start_child(Mod, []).
%%
%% start_child(Mod, Args) ->
%%   {ok, _} = supervisor:start_child(?MODULE,
%%     {Mod, {Mod, start_link, Args},
%%       transient, 100, worker, [Mod]}),
%%   ok.


init([]) ->
  {ok, {
    {one_for_one, 3, 10},
    []
  }}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
