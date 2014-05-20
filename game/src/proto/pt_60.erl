%%%-------------------------------------------------------------------
%%% @author wanghe
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. 五月 2014 11:14
%%%-------------------------------------------------------------------
-module(pt_60).
-author("wanghe").
-include("common.hrl").
%% API
-export([read/2,write/2]).


%%
%%客户端 -> 服务端 ----------------------------
%%

%%请求服务器列表
read(6000,_)->
  {ok,list};

read(_Cmd,_R)->
  {error,no_match}.

%%
%%服务端 -> 客户端 ------------------------------------
%%

%%服务器列表
write(60000,[])->
%%这里会返回空的服务器列表 客户端去处理
  {ok,pt:pack(60000,<<>>)};

write(60000,List)->
  Rlen = length(List),
  F = fun([Id,Ip,Port,State,Num,_System_status])->
      Ip1=tool:to_binary(Ip),
      Len = byte_size(Ip1),
      <<Id:8,Len:16,Ip1/binary,Port:16,State:8,Num:16>>
  end,
  RB = tool:to_binary([F(D)||D<-List]),
  {ok,pt:pack(60000,<<Rlen:16,RB/binary>>)};

%% -----------------------------------------------------------------
%% 错误处理
%% -----------------------------------------------------------------
write(Cmd, _R) ->
  ?INFO_MSG("~s_errorcmd_[~p] ",[misc:time_format(yg_timer:now()), Cmd]),
  {ok, pt:pack(0, <<>>)}.

