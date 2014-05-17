%%%-------------------------------------------------------------------
%%% @author wanghe
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%% 从mysql表生成的record
%%% 待开发生成工具
%%% @end
%%% Created : 16. 五月 2014 14:32
%%%-------------------------------------------------------------------
-author("wanghe").

%%服务器列表
-record(server,{
  id=0,         %%编号ID
  ip="",        %%IP地址
  port=0,       %%端口号
  node="",      %%节点
  num=0,        %%节点用户数
  stop_access=0 %%是否停止登录该节点，0为可以登录，1为停止登录
}).

%% 角色基本信息
%% player ==> player
-record(player, {
  id,                                     %% 用户ID
  accid = 0,                              %% 平台账号ID
  accname = "",                           %% 平台账号
  nickname = "",                          %% 玩家名
  status = 0,                             %% 玩家状态（0正常、1禁止、2战斗中、3死亡、4蓝名、5挂机、6打坐、7凝神修炼8采矿,9答题）,
  reg_time = 0,                           %% 注册时间
  last_login_time = 0,                    %% 最后登陆时间
  last_login_ip = "",                     %% 最后登陆IP
  sex = 1,                                %% 性别 1男 2女
  career = 0,                             %% 职业 1，2，3，4，5（分别是玄武--战士、白虎--刺客、青龙--弓手、朱雀--牧师、麒麟--武尊）
  realm = 0,                              %% 落部  1女娲族、2神农族、3伏羲族、100新手
  prestige = 0,                           %% 声望
  spirit = 0,                             %% 灵力
  jobs = 0,                               %% 职位
  gold = 0,                               %% 元宝
  cash = 0,                               %% 礼金
  coin = 0,                               %% 铜钱
  bcoin = 0,                              %% 绑定的铜钱
  coin_sum = 0,                           %% 币铜总和
  scene = 0,                              %% 场景ID
  x = 0,                                  %% X坐标
  y = 0,                                  %% Y坐标
  lv = 1,                                 %% 等级
  exp = 0,                                %% 经验
  hp = 0,                                 %% 气血
  mp = 0,                                 %% 内息
  hp_lim = 0,                             %% 气血上限
  mp_lim = 0,                             %% 内息上限
  forza = 0.00,                           %% 力量
  agile = 0.00,                           %% 敏捷
  wit = 0.00,                             %% 智力
  max_attack = 0,                         %% 最大攻击力
  min_attack = 0,                         %% 最小攻击力
  def = 0,                                %% 防御
  hit = 0,                                %% 命中率
  dodge = 0,                              %% 躲避
  crit = 0,                               %% 暴击
  att_area = 0,                           %% 攻击距离
  pk_mode = 1,                            %% pk模式(1.和平模式;2.部落模式;3.帮派模式;4.组队模式;5.自由模式)
  pk_time = 0,                            %% 上一次切换PK和平模式的时间
  title = "",                             %% 称号
  couple_name = "",                       %% 配偶
  position = "",                          %% 官职
  evil = 0,                               %% 罪恶
  honor = 0,                              %% 荣誉
  culture = 0,                            %% 修为
  state = 1,                              %% 玩家身份 1普通玩家 2指导员3gm
  physique = 0,                           %% 体质
  anti_wind = 0,                          %% 风抗
  anti_fire = 0,                          %% 火抗
  anti_water = 0,                         %% 水抗
  anti_thunder = 0,                       %% 雷抗
  anti_soil = 0,                          %% 土抗
  anti_rift = 0,                          %% 抗性穿透
  cell_num = 100,                         %% 背包格子数
  mount = 0,                              %% 坐骑ID
  guild_id = 0,                           %% 帮派ID
  guild_name = "",                        %% 帮派名称
  sn = 0                                  %% 服务器标识
}).



