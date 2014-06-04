%%%-------------------------------------------------------------------
%%% @author wanghe
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%% 核心服务
%%% @end
%%% Created : 25. 五月 2014 13:19
%%%-------------------------------------------------------------------
-module(mod_kernel).
-author("wanghe").

-behaviour(gen_server).

-include("common.hrl").
-include("record.hrl").

%% API
-export([start_link/0,
  load_base_data/0,
  load_base_data/1,
  reload_base_data/0,
  reload_base_data/1
]).

%% gen_server callbacks
-export([init/1,
  handle_call/3,
  handle_cast/2,
  handle_info/2,
  terminate/2,
  code_change/3]).

%%%===================================================================
%%% API
%%%===================================================================

start_link() ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

init([]) ->
  misc:write_monitor_pid(self(), ?MODULE, {0}),
  %%初始化ets表
  ok = init_ets(),
  %%初始化数据库
  ok = titan:init_db(server),
  %%加载基础数据
  ok = load_base_data(),
  {ok, 1}.

handle_call(_Request, _From, State) ->
  {reply, ok, State}.

handle_cast(_Request, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

%%加载基础数据
load_base_data() ->
  load_base_data(goods),
  load_base_data(skill),
  load_base_data(card),
  ok.
%%道具数据
load_base_data(goods) ->
  goods_util:init_goods(),
  ok;
%%技能数据
load_base_data(skill) ->
%%   TODO 技能数据
  ok;
%%卡牌基础数据
load_base_data(card) ->
%%   TODO 卡牌数据
  ok.

%%重新加载基础数据
reload_base_data() ->
  reload_base_data(goods),
  ok.

reload_base_data(goods) ->
  goods_util:reload_goods(),
  ok.

%% 初始化ETS表
init_ets() ->
  ets:new(?ETS_BASE_GOODS,[{keypos, #base_goods.goods_id}, named_table, public, set ,?ETSRC, ?ETSWC]),
  ok.