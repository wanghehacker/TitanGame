%%%-------------------------------------------------------------------
%%% @author wanghe
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. 五月 2014 21:39
%%%-------------------------------------------------------------------
-module(db_agent).
-author("wanghe").

-include("common.hrl").
-include("record.hrl").
%% API
-compile(export_all).



%%加入服务器集群
add_server([Ip, Port, Sid, Node]) ->
  ?DB_MODULE:replace(server,[{id, Sid},  {ip, Ip}, {port, Port}, {node, Node}, {num,0}]).

