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
  ?DB_MODULE:replace(server, [{id, Sid}, {ip, Ip}, {port, Port}, {node, Node}, {num, 0}]).


%% 获取所有服务器集群
select_all_server() ->
  ?DB_MODULE:select_all(server, "*", []).

%%系统启动将所有玩家的在线改为0
init_player_online_flag() ->
  ?DB_MODULE:update(player, [{online_flag, 0}], [{online_flag, 1}]).


%%获取所有物品信息
get_base_goods_info() ->
  ?DB_MODULE:select_all(base_goods, "*", [{goods_id,">", 0}]).
