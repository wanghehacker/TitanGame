%%%-------------------------------------------------------------------
%%% @author wanghe
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. 五月 2014 13:36
%%%-------------------------------------------------------------------
-module(misc).
-author("wanghe").

-include("common.hrl").
-include("record.hrl").
%% API
-export([]).
-compile(export_all).

write_system_info(Pid, Module, Args) ->
  ets:insert(?ETS_SYSTEM_INFO, {Pid, Module, Args}).

delete_system_info(Pid) ->
  ets:delete(?ETS_SYSTEM_INFO, Pid).

write_monitor_pid(Pid, Module, Args) ->
  ets:insert(?ETS_MONITOR_PID, {Pid, Module, Args}).

delete_monitor_pid(Pid) ->
  catch ets:delete(?ETS_MONITOR_PID, Pid).