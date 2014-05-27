%%%-------------------------------------------------------------------
%%% @author wanghe
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. 五月 2014 22:33
%%%-------------------------------------------------------------------
-module(ti_tcp_listener_sup).
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
  supervisor:start_link(?MODULE, ?MODULE, []).

%%%===================================================================
%%% Supervisor callbacks
%%%===================================================================


init([{AcceptorCount, Port}]) ->
  {ok,
    {{one_for_all, 10, 10},
      [
        {
          ti_tcp_acceptor_sup,
          {ti_tcp_acceptor_sup, start_link, []},
          transient,
          infinity,
          supervisor,
          [ti_tcp_acceptor_sup]
        },
        {
          lists:concat([ti_tcp_listener_, Port]),
          {ti_tcp_listener, start_link, [AcceptorCount, Port]},
          transient,
          100,
          worker,
          [ti_tcp_listener]
        },
        {
          lists:concat([ti_tcp_listener_, Port - 100]),
          {ti_tcp_listener, start_link, [AcceptorCount, Port - 100]},
          transient,
          100,
          worker,
          [ti_tcp_listener]
        },
        {
          lists:concat([ti_tcp_listener_, Port - 200]),
          {ti_tcp_listener, start_link, [AcceptorCount, Port - 200]},
          transient,
          100,
          worker,
          [ti_tcp_listener]
        }

      ]
    }}.
%%%===================================================================
%%% Internal functions
%%%===================================================================
