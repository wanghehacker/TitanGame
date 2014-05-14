%%%-------------------------------------------------------------------
%%% @author wanghe
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. 五月 2014 10:10
%%%-------------------------------------------------------------------
-module(titan).
-author("wanghe").
-include("common.hrl").


%% API
-export([gateway_start/0,
         gateway_stop/0,
         server_start/0,
         server_stop/0]).

-define(GATEWAY_APPS,[sasl,gateway]).
-define(SERVER_APPS,[sasl,server]).

%%启动网关
gateway_start()->
  try
    ok = start_applications(?GATEWAY_APPS)
  after
    timer:sleep(100)
  end.

%%关闭网关
gateway_stop()->
  ok = stop_applications(?GATEWAY_APPS).

%%启动游戏服务器
server_start()->
  try
    ok = start_applications(?SERVER_APPS)
  after
    timer:sleep(100)
  end.

%%停止游戏服务器
server_stop()->
  %%首先关闭外部接入，然后停止目前的连接，等全部连接正常退出后，再关闭应用
  catch gen_server:cast(mod_kernel,{set_load,99999999999}),
  %%TODO 登录模块
%%   ok = mod_login:stop_all(),
  timer:sleep(30*1000),
  ok = stop_applications(?SERVER_APPS),
  erlang:halt().


manage_applications(Iterate,Do,Undo,SkipError,ErrorTag,Apps)->
  Iterate(fun(App,Acc)->
            case Do(App) of
              ok -> [App|Acc];
              {error,{SkipError,_}}->Acc;
              {error,Reason}->
                lists:foreach(Undo,Acc),
                throw({error,{ErrorTag,App,Reason}})
            end
  end,[],Apps),
  ok.


start_applications(Apps)->
  manage_applications(fun lists:foldl/3,
                      fun application:start/1,
                      fun application:stop/1,
                      already_started,
                      cannot_start_application,
                      Apps).

stop_applications(Apps)->
  manage_applications(fun lists:foldl/3,
                      fun application:start/1,
                      fun application:stop/1,
                      not_started,
                      cannot_stop_application,
                      Apps).






