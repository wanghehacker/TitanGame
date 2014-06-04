%%%------------------------------------------------
%%%	File    : table_to_record.erl	
%%%	Author  : whe	
%%%	Created :	2014-06-04 03:32:11	
%%%	Description: 从mysql表生成的record			
%%%	Warning:  由程序自动生成，请不要随意修改！			
%%%------------------------------------------------


%%%	物品基础表
%%%	base_goods==>base_goods
-record(base_goods,{
      goods_id=0,             %%%物品类型编号
      goods_name="",          %%%物品名称
      icon="",                %%%物品图标
      intro="",               %%%物品描述信息
      type=0,                 %%%物品类型, 1 装备类， 2 增益类，3 任务类 4 坐骑类
      subtype=0,              %%%物品子类型。装备子类型：1 武器，2 衣服，3 头盗，4 手套，5 鞋子，6 项链，7 戒指。增益子类型：1 药品，2 经验。 坐骑子类型：1 一人坐骑 2 二人坐骑 3 三人坐骑
      equip_type=0,           %%%装备类型：0为无，1为武器，2为防具，3为饰品
      bind=0,                 %%%是否绑定，0为不可绑定，1为可绑定还未绑定，2为可绑定已绑定
      price_type=0,           %%%价格类型：1 铜钱, 2 银两，3 金币，4 绑定的铜钱
      price=0,                %%%物品购买价格
      trade=0,                %%%是否交易，1为不可交易，0为可交易
      sell_price=0,           %%%物品出售价格
      sell=0,                 %%%是否出售，0可出售，1不可出售
      isdrop=0,               %%%是否丢弃，0可丢弃，1不可丢弃
      level=0,                %%%等级限制，0为不限
      career=0,               %%%职业限制，0为不限
      sex=0,                  %%%性别限制，0为不限，1为男，2为女
      job=0,                  %%%职位限制，0为不限
      forza_limit=0,          %%%力量需求，0为不限
      wit_limit=0,            %%%智力需求，0为不限
      agile_limit=0,          %%%敏捷需求，0为不限
      realm=0,                %%%阵营限制，0为不限
      vitality=0,             %%%体力
      spirit=0,               %%%灵力
      hp=0,                   %%%气血
      mp=0,                   %%%内力
      forza=0,                %%%力量
      wit=0,                  %%%智力
      agile=0,                %%%敏捷
      att=0,                  %%%攻击
      def=0,                  %%%防御
      hit=0,                  %%%命中
      dodge=0,                %%%躲避
      crit=0,                 %%%暴击
      ten=0,                  %%%坚韧
      speed=0,                %%%速度
      attrition=0             %%%耐久度，0为永不磨损
}).

%%%	角色基本信息
%%%	player==>player
-record(player,{
      id=0,                   %%%用户ID
      accid=0,                %%%平台账号ID
      accname="",             %%%平台账号
      nickname="",            %%%玩家名
      status=0,               %%%玩家状态（0正常 1禁止)
      reg_time=0,             %%%注册时间
      last_login_time=0,      %%%最后登陆时间
      last_login_ip="",       %%%最后登陆IP
      sex=1,                  %%%性别 1男 2女
      career=0,               %%%职业 1，2，3，4（分别是玄武--战士、白虎--刺客、青龙--法师、朱雀--牧师）
      prestige=0,             %%%声望
      spirit=0,               %%%灵力
      jobs=0,                 %%%职位
      gold=0,                 %%%元宝
      cash=0,                 %%%礼金
      coin=0,                 %%%铜钱
      bcoin=0,                %%%绑定的铜钱
      lv=1,                   %%%等级
      exp=0,                  %%%经验
      hp=0,                   %%%气血
      hp_lim=0,               %%%气血上限
      forza=0.00,             %%%力量
      agile=0.00,             %%%敏捷
      wit=0.00,               %%%智力
      att=0,                  %%%攻击
      def=0,                  %%%防御
      hit=0,                  %%%命中率
      dodge=0,                %%%躲避
      crit=0,                 %%%暴击
      ten=0,                  %%%坚韧
      title="",               %%%称号
      cell_num=100,           %%%背包格子数
      online_flag=0,          %%%在线标记，0不在线 1在线
      pet_upgrade_que_num=0,  %%%宠物升级队列个数
      other=0                 %%%其他附加数据集
}).

%%%	服务器列表
%%%	server==>server
-record(server,{
      id=0,                   %%%编号Id
      ip="",                  %%%ip地址
      port=0,                 %%%端口号
      node="",                %%%节点
      num=0,                  %%%节点用户数
      stop_access=0           %%%是否允许访问
}).

%%%	测试用表
%%%	test==>test
-record(test,{
      id=0,                   %%%
      content="hello",        %%%
      code=0                  %%%
}).

