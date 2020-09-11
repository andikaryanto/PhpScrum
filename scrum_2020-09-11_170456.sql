/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: m_enumdetails
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_enumdetails`;
CREATE TABLE `m_enumdetails` (
  `Id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'primary key',
  `M_Enum_Id` int(11) DEFAULT NULL COMMENT 'Enum Id',
  `Value` int(11) DEFAULT NULL COMMENT 'Value',
  `EnumName` varchar(100) DEFAULT NULL COMMENT 'Enum Name',
  `Ordering` int(11) DEFAULT NULL COMMENT 'Order',
  `Resource` varchar(100) DEFAULT NULL COMMENT 'Resource',
  PRIMARY KEY (`Id`),
  KEY `FK_M_enum_M_enumdetail` (`M_Enum_Id`),
  CONSTRAINT `FK_M_enum_M_enumdetail` FOREIGN KEY (`M_Enum_Id`) REFERENCES `m_enums` (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: m_enums
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_enums`;
CREATE TABLE `m_enums` (
  `Id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'primary key',
  `Name` varchar(100) DEFAULT NULL COMMENT 'Enum Name',
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: m_positions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_positions`;
CREATE TABLE `m_positions` (
  `Id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'primary key',
  `Position` varchar(100) NOT NULL,
  `Description` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: m_profiles
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_profiles`;
CREATE TABLE `m_profiles` (
  `Id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'primary key',
  `M_User_Id` int(11) NOT NULL,
  `M_Position_Id` int(11) DEFAULT NULL,
  `About` text DEFAULT NULL,
  `Photo` text DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `FK_m_profile_m_user` (`M_User_Id`),
  KEY `FK_m_profile_m_position` (`M_Position_Id`),
  CONSTRAINT `FK_m_profile_m_position` FOREIGN KEY (`M_Position_Id`) REFERENCES `m_positions` (`Id`) ON UPDATE CASCADE,
  CONSTRAINT `FK_m_profile_m_user` FOREIGN KEY (`M_User_Id`) REFERENCES `m_users` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: m_projects
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_projects`;
CREATE TABLE `m_projects` (
  `Id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'primary key',
  `Name` varchar(100) DEFAULT NULL COMMENT 'Project Name',
  `Description` varchar(1000) NOT NULL,
  `StartDate` date DEFAULT NULL COMMENT 'StartDate',
  `EndDate` date DEFAULT NULL COMMENT 'EndDate',
  `Status` int(11) DEFAULT NULL COMMENT 'project status from enum',
  `M_User_Id` int(11) DEFAULT NULL COMMENT 'User Creator',
  `Created` datetime DEFAULT NULL COMMENT 'created time',
  `CreatedBy` varchar(50) DEFAULT NULL,
  `Updated` datetime DEFAULT NULL,
  `UpdatedBy` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `FK_m_projects_m_user` (`M_User_Id`),
  CONSTRAINT `FK_m_projects_m_user` FOREIGN KEY (`M_User_Id`) REFERENCES `m_users` (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: m_users
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_users`;
CREATE TABLE `m_users` (
  `Id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'primary key',
  `Email` varchar(100) NOT NULL,
  `Name` varchar(100) DEFAULT NULL,
  `Username` varchar(100) NOT NULL,
  `Password` varchar(50) NOT NULL,
  `Created` datetime DEFAULT NULL COMMENT 'created time',
  `CreatedBy` varchar(50) DEFAULT NULL COMMENT 'created by',
  `Updated` datetime DEFAULT NULL COMMENT 'updated time',
  `UpdatedBy` varchar(50) DEFAULT NULL COMMENT 'created by',
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: t_projectinteracts
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_projectinteracts`;
CREATE TABLE `t_projectinteracts` (
  `Id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'primary key',
  `M_Project_Id` int(11) NOT NULL COMMENT 'Project Id',
  `M_User_Id` int(11) NOT NULL COMMENT 'User Interacted',
  `Created` datetime DEFAULT NULL,
  `CreatedBy` varchar(50) DEFAULT NULL,
  `Updated` datetime DEFAULT NULL,
  `UpdatedBy` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `FK_t_projectinteract_m_user` (`M_User_Id`),
  KEY `FK_t_projectinteract_m_project` (`M_Project_Id`),
  CONSTRAINT `FK_t_projectinteract_m_project` FOREIGN KEY (`M_Project_Id`) REFERENCES `m_projects` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `FK_t_projectinteract_m_user` FOREIGN KEY (`M_User_Id`) REFERENCES `m_users` (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=102 DEFAULT CHARSET=utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: t_taskdetails
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_taskdetails`;
CREATE TABLE `t_taskdetails` (
  `Id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'primary key',
  `Name` varchar(100) NOT NULL,
  `Description` varchar(300) DEFAULT NULL,
  `T_Task_Id` int(11) NOT NULL,
  `M_User_Id` int(11) NOT NULL,
  `Type` int(11) NOT NULL,
  `Status` int(11) NOT NULL,
  `Created` datetime DEFAULT NULL,
  `CreatedBy` varchar(50) DEFAULT NULL,
  `Updated` datetime DEFAULT NULL,
  `UpdatedBy` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `FK_t_taskdetail_t_task` (`T_Task_Id`),
  KEY `FK_FK_t_taskdetail_m_user` (`M_User_Id`),
  CONSTRAINT `FK_FK_t_taskdetail_m_user` FOREIGN KEY (`M_User_Id`) REFERENCES `m_users` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_t_taskdetail_t_task` FOREIGN KEY (`T_Task_Id`) REFERENCES `t_tasks` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8;

# ------------------------------------------------------------
# SCHEMA DUMP FOR TABLE: t_tasks
# ------------------------------------------------------------

DROP TABLE IF EXISTS `t_tasks`;
CREATE TABLE `t_tasks` (
  `Id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'primary key',
  `Name` varchar(100) NOT NULL,
  `Description` varchar(300) DEFAULT NULL,
  `M_Project_Id` int(11) NOT NULL,
  `Created` datetime DEFAULT NULL,
  `CreatedBy` varchar(50) DEFAULT NULL,
  `Updated` datetime DEFAULT NULL,
  `UpdatedBy` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `FK_t_task_m_project` (`M_Project_Id`),
  CONSTRAINT `FK_t_task_m_project` FOREIGN KEY (`M_Project_Id`) REFERENCES `m_projects` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
