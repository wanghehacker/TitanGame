/*
Navicat MySQL Data Transfer

Source Server         : game
Source Server Version : 50612
Source Host           : localhost:3306
Source Database       : titangate

Target Server Type    : MYSQL
Target Server Version : 50612
File Encoding         : 65001

Date: 2014-05-25 16:58:24
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `player`
-- ----------------------------
DROP TABLE IF EXISTS `player`;
CREATE TABLE `player` (
`id`  int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '用户ID' ,
`accid`  int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '平台账号ID' ,
`accname`  varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '平台账号' ,
`nickname`  varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '玩家名' ,
`status`  tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '玩家状态（0正常 1禁止)' ,
`reg_time`  int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '注册时间' ,
`last_login_time`  int(11) NOT NULL DEFAULT 0 COMMENT '最后登陆时间' ,
`last_login_ip`  varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '最后登陆IP' ,
`sex`  tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '性别 1男 2女' ,
`career`  tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '职业 1，2，3，4（分别是玄武--战士、白虎--刺客、青龙--法师、朱雀--牧师）' ,
`prestige`  smallint(5) UNSIGNED NOT NULL DEFAULT 0 COMMENT '声望' ,
`spirit`  int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '灵力' ,
`jobs`  tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '职位' ,
`gold`  int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '元宝' ,
`cash`  int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '礼金' ,
`coin`  int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '铜钱' ,
`bcoin`  int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '绑定的铜钱' ,
`lv`  smallint(5) UNSIGNED NOT NULL DEFAULT 1 COMMENT '等级' ,
`exp`  int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '经验' ,
`hp`  int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '气血' ,
`hp_lim`  int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '气血上限' ,
`forza`  decimal(5,2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '力量' ,
`agile`  decimal(5,2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '敏捷' ,
`wit`  decimal(5,2) UNSIGNED NOT NULL DEFAULT 0.00 COMMENT '智力' ,
`att`  smallint(5) UNSIGNED NOT NULL DEFAULT 0 COMMENT '攻击' ,
`def`  smallint(5) UNSIGNED NOT NULL DEFAULT 0 COMMENT '防御' ,
`hit`  smallint(5) UNSIGNED NOT NULL DEFAULT 0 COMMENT '命中率' ,
`dodge`  smallint(5) UNSIGNED NOT NULL DEFAULT 0 COMMENT '躲避' ,
`crit`  smallint(5) UNSIGNED NOT NULL DEFAULT 0 COMMENT '暴击' ,
`ten`  smallint(5) UNSIGNED NOT NULL DEFAULT 0 COMMENT '坚韧' ,
`title`  varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '称号' ,
`cell_num`  smallint(5) UNSIGNED NOT NULL DEFAULT 100 COMMENT '背包格子数' ,
`online_flag`  int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '在线标记，0不在线 1在线' ,
`pet_upgrade_que_num`  int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '宠物升级队列个数' ,
`other`  smallint(5) NULL DEFAULT NULL COMMENT '其他附加数据集' ,
PRIMARY KEY (`id`),
UNIQUE INDEX `nickname` (`nickname`) USING BTREE ,
UNIQUE INDEX `accname` (`accname`) USING BTREE ,
INDEX `lv` (`lv`) USING BTREE ,
INDEX `prestige` (`prestige`) USING BTREE ,
INDEX `coin` (`coin`) USING BTREE 
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci
COMMENT='角色基本信息'
AUTO_INCREMENT=1

;

-- ----------------------------
-- Records of player
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for `server`
-- ----------------------------
DROP TABLE IF EXISTS `server`;
CREATE TABLE `server` (
`id`  int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '编号Id' ,
`ip`  varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT 'ip地址' ,
`port`  int(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '端口号' ,
`node`  varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '节点' ,
`num`  int(11) NULL DEFAULT 0 COMMENT '节点用户数' ,
PRIMARY KEY (`id`)
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci
COMMENT='服务器列表'

;

-- ----------------------------
-- Records of server
-- ----------------------------
BEGIN;
INSERT INTO `server` VALUES ('0', '127.0.0.1', '8777', 'nonode@nohost', '0');
COMMIT;

-- ----------------------------
-- Table structure for `test`
-- ----------------------------
DROP TABLE IF EXISTS `test`;
CREATE TABLE `test` (
`id`  int(11) NOT NULL AUTO_INCREMENT COMMENT 'Ҡۅ' ,
`row`  varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ,
`r`  int(11) NULL DEFAULT NULL ,
PRIMARY KEY (`id`)
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci
AUTO_INCREMENT=1

;

-- ----------------------------
-- Records of test
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Auto increment value for `player`
-- ----------------------------
ALTER TABLE `player` AUTO_INCREMENT=1;

-- ----------------------------
-- Auto increment value for `test`
-- ----------------------------
ALTER TABLE `test` AUTO_INCREMENT=1;
