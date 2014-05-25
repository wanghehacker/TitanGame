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



%% 物品基础表
%% base_goods ==> ets_base_goods
-record(ets_base_goods, {
  goods_id = 0,                           %% 物品类型编号
  goods_name = "",                        %% 物品名称
  icon = "",                              %% 物品图标
  intro,                                  %% 物品描述信息
  type = 0,                               %% 物品类型：10装备类，15宝石类，20护符类，25丹药类，30增益类，35灵兽类，40帮派类，45任务类，50其他类；参照base_goods_type表
  subtype = 0,                            %% 物品子类型。装备子类型：1 武器，2 衣服，3 头盗，4 手套，5 鞋子，6 项链，7 戒指。增益子类型：1 药品，2 经验。 坐骑子类型：1 一人坐骑 2 二人坐骑 3 三人坐骑；参照base_goods_subtype表
  equip_type = 0,                         %% 装备类型：0为个人的物品，不为0时，记录的是氏族id表示物品在该氏族仓库,
  bind = 0,                               %% 是否绑定，0没绑定，1使用后绑定，2已绑定
  price_type = 0,                         %% 价格类型：1 铜钱 2 银两，3 金币，4 绑定的铜钱,
  price = 0,                              %% 物品购买价格
  trade = 0,                              %% 是否交易，1为不可交易，0为可交易
  sell_price = 0,                         %% 物品出售价格
  sell = 0,                               %% 是否出售，0可出售，1不可出售
  isdrop = 0,                             %% 是否丢弃，0可丢弃，1不可丢弃
  level = 0,                              %% 等级限制，0为不限
  career = 0,                             %% 职业限制，0为不限
  sex = 0,                                %% 性别限制，0为不限，1为男，2为女
  job = 0,                                %% 职位限制，0为不限
  forza_limit = 0,                        %% 力量需求，0为不限
  physique_limit = 0,                     %% 体质需求，0为不限
  wit_limit = 0,                          %% 智力需求，0为不限
  agile_limit = 0,                        %% 敏捷需求，0为不限
  realm = 0,                              %% 部落限制，0为不限
  spirit = 0,                             %% 灵力
  hp = 0,                                 %% 气血
  mp = 0,                                 %% 内力
  forza = 0,                              %% 力量
  physique = 0,                           %% 体质
  wit = 0,                                %% 智力
  agile = 0,                              %% 敏捷
  max_attack = 0,                         %% 最大攻击力
  min_attack = 0,                         %% 最小攻击力
  def = 0,                                %% 防御
  hit = 0,                                %% 命中
  dodge = 0,                              %% 躲避
  crit = 0,                               %% 暴击
  ten = 0,                                %% 坚韧
  anti_wind = 0,                          %% 风抗
  anti_fire = 0,                          %% 火抗
  anti_water = 0,                         %% 水抗
  anti_thunder = 0,                       %% 雷抗
  anti_soil = 0,                          %% 土抗
  anti_rift = 0,                          %% 抗性穿透
  speed = 0,                              %% 速度
  attrition = 0,                          %% 耐久度，0为永不磨损
  suit_id = 0,                            %% 套装ID，0为不是套装
  max_hole = 0,                           %% 可镶嵌孔数，0为不可打孔
  max_stren = 0,                          %% 最大强化等级，0为不可强化
  max_overlap = 0,                        %% 可叠加数，0为不可叠加
  grade = 0,                              %% 修炼等级
  step = 0,                               %% 物品阶
  color = 0,                              %% 物品颜色，0 白色，1 绿色，2 蓝色，3 金色，4 紫色
  other_data,                             %% 用于保存额外的数据，比如灵兽粮食的快乐值，礼包中的一些赠送物品ID，金币数据\r\n
  expire_time = 0                         %% 有效期，0为不限，单位为秒
}).