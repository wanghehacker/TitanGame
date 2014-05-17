%%%-------------------------------------------------------------------
%%% @author wanghe
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%% 网关监控树
%%% @end
%%% Created : 14. 五月 2014 9:53
%%%-------------------------------------------------------------------
-module(ti_gateway_sup).
-author("wanghe").

-behaviour(supervisor).
%% API
-export([start_link/1]).
%% Supervisor callbacks
-export([init/1]).

start_link([Ip,Port,Node_id]) ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, [Ip,Port,Node_id]).

init([Ip,Port,Node_id]) ->
  {ok,
    {
      {one_for_one,3,10},
      [
        {
          ti_gateway,
          {ti_gateway, start_link, [Port]},
          permanent,
          10000,
          supervisor,
          [ti_gateway]
        },
        {
          mod_disperse,
          {mod_disperse, start_link,[Ip, Port, Node_id]},
          permanent,
          10000,
          supervisor,
          [mod_disperse]
        }
      ]
    }
  }.
