SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for application
-- ----------------------------
DROP TABLE IF EXISTS `application`;
CREATE TABLE `application` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `website` varchar(256) NOT NULL,
  `apikey` varchar(64) NOT NULL,
  `owner` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `apikey` (`apikey`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of application
-- ----------------------------
INSERT INTO `application` VALUES ('1', '插入订单数据 API 接口', 'http://pay.qiyichao.cn/', 'input_you_API_KEY', '1');

-- ----------------------------
-- Table structure for member
-- ----------------------------
DROP TABLE IF EXISTS `member`;
CREATE TABLE `member` (
  `uid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL,
  `password` varchar(32) NOT NULL,
  `salt` varchar(6) NOT NULL,
  `email` varchar(128) DEFAULT NULL,
  `register_time` int(11) unsigned NOT NULL,
  `money` double unsigned DEFAULT NULL,
  PRIMARY KEY (`uid`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of member
-- ----------------------------
INSERT INTO `member` VALUES ('1', 'test', '9ae0147d65724f72f74804af4aac6f13', 'asd', '', '0', null);

-- ----------------------------
-- Table structure for member_online
-- ----------------------------
DROP TABLE IF EXISTS `member_online`;
CREATE TABLE `member_online` (
  `token` varchar(255) NOT NULL,
  `uid` int(10) unsigned NOT NULL,
  `name` varchar(32) NOT NULL,
  `register_time` int(11) unsigned NOT NULL,
  `login_time` int(11) unsigned NOT NULL,
  `expired_time` int(11) unsigned NOT NULL,
  PRIMARY KEY (`token`),
  UNIQUE KEY `token` (`token`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of member_online
-- ----------------------------

-- ----------------------------
-- Table structure for order
-- ----------------------------
DROP TABLE IF EXISTS `order`;
CREATE TABLE `order` (
  `tradeNo` varchar(128) NOT NULL,
  `payname` varchar(128) DEFAULT NULL,
  `time` varchar(128) DEFAULT NULL,
  `username` varchar(128) DEFAULT NULL,
  `userid` varchar(128) DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `status` varchar(128) DEFAULT NULL,
  `use_timestamp` varchar(12) DEFAULT NULL,
  `use_appid` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`tradeNo`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of order
-- ----------------------------
