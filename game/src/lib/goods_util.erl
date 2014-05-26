%%%-------------------------------------------------------------------
%%% @author wanghe
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 五月 2014 17:24
%%%-------------------------------------------------------------------
-module(goods_util).
-author("wanghe").

-include("common.hrl").
-include("record.hrl").

%% API
-compile([export_all]).

reload_goods() ->
  ok = init_goods_type(),
  ok.

init_goods_type() ->
  ets:delete_all_objects(ets_base_goods),
  F = fun(GoodsType) ->
    GoodsInfo = list_to_tuple([ets_base_goods] ++ GoodsType),
    ets:insert(?ETS_BASE_GOODS, GoodsInfo)
  end,
  case db_agent:get_base_goods_info() of
    [] -> skip;
    GoodsTypeList when is_list(GoodsTypeList) ->
      lists:foreach(F, GoodsTypeList);
    _ -> skip
  end,
  ok.

init_goods()->
%%初始化物品表
  ok = init_goods_type(),
%%后续追加各种表
  ok.
