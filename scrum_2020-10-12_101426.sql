/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


CREATE DATABASE /*!32312 IF NOT EXISTS*/ `scrum` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `scrum`;
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


DROP TABLE IF EXISTS `m_enums`;
CREATE TABLE `m_enums` (
  `Id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'primary key',
  `Name` varchar(100) DEFAULT NULL COMMENT 'Enum Name',
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `m_positions`;
CREATE TABLE `m_positions` (
  `Id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'primary key',
  `Position` varchar(100) NOT NULL,
  `Description` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;


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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;


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
) ENGINE=InnoDB AUTO_INCREMENT=87 DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `m_users`;
CREATE TABLE `m_users` (
  `Id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'primary key',
  `Email` varchar(100) NOT NULL,
  `Name` varchar(100) DEFAULT NULL,
  `Username` varchar(100) NOT NULL,
  `Password` varchar(50) NOT NULL,
  `FirebaseToken` text DEFAULT NULL,
  `Created` datetime DEFAULT NULL COMMENT 'created time',
  `CreatedBy` varchar(50) DEFAULT NULL COMMENT 'created by',
  `Updated` datetime DEFAULT NULL COMMENT 'updated time',
  `UpdatedBy` varchar(50) DEFAULT NULL COMMENT 'created by',
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `t_commentattachments`;
CREATE TABLE `t_commentattachments` (
  `Id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'primary key',
  `T_Comment_Id` int(11) NOT NULL,
  `FileName` varchar(100) DEFAULT NULL,
  `Type` varchar(20) DEFAULT NULL,
  `UrlFile` text DEFAULT NULL,
  `Created` datetime DEFAULT NULL,
  `CreatedBy` varchar(50) DEFAULT NULL,
  `Updated` datetime DEFAULT NULL,
  `UpdatedBy` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `FK_t_commentattachemnt_t_comment` (`T_Comment_Id`),
  CONSTRAINT `FK_t_commentattachemnt_t_comment` FOREIGN KEY (`T_Comment_Id`) REFERENCES `t_comments` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `t_comments`;
CREATE TABLE `t_comments` (
  `Id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'primary key',
  `M_User_Id` int(11) NOT NULL,
  `T_Taskdetail_Id` int(11) NOT NULL,
  `Comment` text DEFAULT NULL,
  `Created` datetime DEFAULT NULL,
  `CreatedBy` varchar(50) DEFAULT NULL,
  `Updated` datetime DEFAULT NULL,
  `UpdatedBy` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `t_comment_t_taskdetail` (`T_Taskdetail_Id`),
  KEY `FK_t_comment_m_user` (`M_User_Id`),
  CONSTRAINT `FK_t_comment_m_user` FOREIGN KEY (`M_User_Id`) REFERENCES `m_users` (`Id`),
  CONSTRAINT `t_comment_t_taskdetail` FOREIGN KEY (`T_Taskdetail_Id`) REFERENCES `t_taskdetails` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8;


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
) ENGINE=InnoDB AUTO_INCREMENT=188 DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `t_sprints`;
CREATE TABLE `t_sprints` (
  `Id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'primary key',
  `M_Project_Id` int(11) NOT NULL,
  `Name` varchar(50) NOT NULL,
  `Description` varchar(200) DEFAULT NULL,
  `DateStart` date NOT NULL,
  `DateEnd` date NOT NULL,
  `IsActive` smallint(1) NOT NULL,
  `Created` datetime DEFAULT NULL,
  `CreatedBy` varchar(50) DEFAULT NULL,
  `Updated` datetime DEFAULT NULL,
  `UpdatedBy` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `FK_t_sprint_m_project` (`M_Project_Id`),
  CONSTRAINT `FK_t_sprint_m_project` FOREIGN KEY (`M_Project_Id`) REFERENCES `m_projects` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8;


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
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8;


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
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;

INSERT INTO `m_enumdetails` (`Id`,`M_Enum_Id`,`Value`,`EnumName`,`Ordering`,`Resource`) VALUES (1,1,1,'New',1,NULL),(2,1,2,'In Progress',2,NULL),(3,1,3,'Suspended',3,NULL),(4,1,4,'Done',4,NULL),(5,2,1,'Back Log',1,NULL),(6,2,2,'Plan',2,NULL),(7,2,3,'Doing',3,NULL),(8,2,4,'Check',4,NULL),(9,2,5,'Done',5,NULL);

INSERT INTO `m_enums` (`Id`,`Name`) VALUES (1,'ProjectStatus'),(2,'TaskType');

INSERT INTO `m_positions` (`Id`,`Position`,`Description`) VALUES (1,'Project Manager','Project Manager'),(2,'Back End Developer','Back End Developer'),(3,'Front End Developer','Front End Developer'),(4,'Database Administrator','Database Administrator');

INSERT INTO `m_profiles` (`Id`,`M_User_Id`,`M_Position_Id`,`About`,`Photo`) VALUES (3,2,3,'I am more full stack I started out in front end but after having to build a server I have become good at both, if I had to choose I would say fronted, because I like playing with UIs.','assets/profiles/inklolly.jpg'),(4,1,2,'I like to use the JVM for backend, but I can use Node or .net if I must. For frontend, I love just vanilla android and flutter, but I have experience with asp.net and vue, also','assets/profiles/andik.jpeg'),(5,3,1,'I am passionate about solving challenging problems and loved programming for that reason. started out learning C and Java in college but eventually had to learn JavaScript to build a website and instantly fell in love with how much of an art building UI is and ever since I have been doing a lot of Frontend work and occasional Backend (I like both but UI touches my heart)','assets/profiles/hologram.jpg'),(6,4,4,'Currently I\'m a front-end dev working on a small 3 man team. If I had to choose I\'d do mainly full-stack but I\'m where I am needed at the moment. I don\'t think I\'d want to be constrained to just the front or the back. I like the freedom of designing API\'s one day in c# and designing dynamic front-ends in JavaScript the next','assets/profiles/fuckoff.jpeg'),(7,9,NULL,NULL,'assets/profiles/20201008_150027IMG-20201006-WA0007.jpg');

INSERT INTO `m_projects` (`Id`,`Name`,`Description`,`StartDate`,`EndDate`,`Status`,`M_User_Id`,`Created`,`CreatedBy`,`Updated`,`UpdatedBy`) VALUES (1,'My Own Desktop','Desktop Application to support My Own Desktop solution, usage for internal production and employee productivity','2020-09-02','2020-12-03',1,1,NULL,'andikaryanto',NULL,NULL),(2,'Dummy Bank Website Profile','Desktop Application to support Dummy Bank Website Profile solution, usage for internal production and employee productivity','2020-09-02','2020-10-30',1,1,NULL,'andikaryanto',NULL,NULL),(3,'Wordpress Commerse Rabbani HIjab','Wordpress Commerse Rabbani HIjab for selling item, including cart and shipping price, promo master and discount master','2020-09-02','2020-11-13',2,NULL,NULL,'inklolly',NULL,NULL),(4,'A Capita Company Profile','Create Company profile for A Capita company for trading overview','2020-09-02','2020-09-30',3,NULL,NULL,'hologram',NULL,NULL),(5,'ERP Project Syncore','ERP Project Syncore Consulatnt to get their client accounting management, selling product, pruchasing product, stock opname','2020-09-04','2020-09-30',1,NULL,NULL,'hologram',NULL,NULL),(6,'HR Project','Create HR Project for our company, employee day off, employee data, employee presence, employee task','2020-09-24','2020-11-19',4,1,NULL,'hologram',NULL,NULL),(31,'OJK dashboard','cretae OJK dashboard using dundash dashboard and SQLServer. BI project will be lead by Project Manager on site',NULL,NULL,1,3,'2020-09-07 14:17:46','hologram',NULL,NULL),(43,'Compamy profile Insurance','Company profile Insurance. show insurance product , admin preference, debt','2020-09-11','2020-09-19',1,3,'2020-09-08 10:42:52','hologram',NULL,NULL),(44,'POS Nothing cafe','POS Nothing cafe. daily selling, daily purchase, member, discount, promo, voucher, product','2020-09-08','2020-09-08',1,3,'2020-09-08 10:44:47','hologram',NULL,NULL),(49,'ERP project syncores','wowksindidndksmidbsjsndn','2020-09-08','2020-12-05',1,3,'2020-09-09 14:56:07','hologram',NULL,NULL),(51,'SCRUM 2020 - SYSDEV Internal System Section','SCRUM 2020 - SYSDEV Internal System Section','2020-09-18','2021-07-20',1,3,'2020-09-10 16:40:35','hologram',NULL,NULL),(57,'andik website','andik peofile website','2020-09-18','2021-07-30',1,1,'2020-09-18 16:54:35','andikaryanto',NULL,NULL),(82,'React JS Test','React JS Test','2020-09-05','2020-09-05',1,3,'2020-10-05 15:25:07','hologram',NULL,NULL),(83,'asdads','asdadsad','2020-09-05','2020-09-05',1,3,'2020-10-05 15:28:59','hologram',NULL,NULL),(84,'asdas','asdasdasdasd','2020-09-05','2020-09-05',1,3,'2020-10-05 15:29:49','hologram',NULL,NULL),(86,'SYSDEV Product Dev DEPARTMENT','Sysdev product dev department, cash machine unit to develope','2020-10-09','2021-04-29',1,9,'2020-10-08 13:01:25','andikeu',NULL,NULL);

INSERT INTO `m_users` (`Id`,`Email`,`Name`,`Username`,`Password`,`FirebaseToken`,`Created`,`CreatedBy`,`Updated`,`UpdatedBy`) VALUES (1,'andik.aryantoo@gmail.com','Andik Aryanto','andikaryanto','4a300e55cb5eeb278b2b9b74160c8ca1',NULL,NULL,NULL,NULL,NULL),(2,'inklolly6@gmail.com','Ink lolly','inklolly','38058a85b3f0599abb64b79a62c86d72',NULL,NULL,NULL,NULL,NULL),(3,'hologram@gmail.com','Hologram','hologram','a9051c9e910d0477b9275760a8e546ea','cK48fIzQQZGjx48PUYOvMx:APA91bFdDbS1uHDLPCWvpSSxBJD7nSNUplYtcr5IS5EgAmpU8eP8hdcI5QE3bSUM22I6VFuemV2p8Dlk8MHG8M94lYJX4HzDPsNZSNXQQyHwpqjKcmSuan-jp3U1xebRAVxW4jSq6ZlJ',NULL,NULL,'2020-10-08 16:58:46','hologram'),(4,'fuckoff@gmail.com','Fuck Off','fuckoff','1660f88af58bf34d345d9a5c63c1f438',NULL,NULL,NULL,NULL,NULL),(9,'andikeu@gmail.com','Andikeu','andikeu','f77ed5803561359189e8bd23895b47aa',NULL,NULL,NULL,NULL,NULL);

INSERT INTO `t_commentattachments` (`Id`,`T_Comment_Id`,`FileName`,`Type`,`UrlFile`,`Created`,`CreatedBy`,`Updated`,`UpdatedBy`) VALUES (21,10,'IMG-20200917-WA0002.jpg','jpg','assets/commentfiles/20200917_152745IMG-20200917-WA0002.jpg','2020-09-17 15:27:45','hologram',NULL,NULL),(22,10,'IMG-20200916-WA0002.jpg','jpg','assets/commentfiles/20200917_152745IMG-20200916-WA0002.jpg','2020-09-17 15:27:45','hologram',NULL,NULL),(23,11,'Timeline DE-100.xlsx','xslx','assets/commentfiles/20200917_153107Timeline-DE-100.xlsx','2020-09-17 15:31:07','hologram',NULL,NULL),(24,12,'[e-form] Catatan Kehadiran andi aryanto 19-03-2020.pdf','pdf','assets/commentfiles/20200917_153618[e-form]-Catatan-Kehadiran-andi-aryanto-19-03-2020.pdf','2020-09-17 15:36:18','hologram',NULL,NULL),(31,19,'IMG-20200917-WA0003.jpg','jpg','assets/commentfiles/20200917_160536IMG-20200917-WA0003.jpg','2020-09-17 16:05:36','hologram',NULL,NULL),(32,20,'IMG-20200917-WA0000.jpg','jpg','assets/commentfiles/20200917_161056IMG-20200917-WA0000.jpg','2020-09-17 16:10:56','hologram',NULL,NULL),(33,22,'IMG_20200912_154534.jpg','jpg','assets/commentfiles/20200917_162510IMG_20200912_154534.jpg','2020-09-17 16:25:10','hologram',NULL,NULL),(34,23,'Timeline DE-100.xlsx','xlsx','assets/commentfiles/20200917_163249Timeline-DE-100.xlsx','2020-09-17 16:32:49','hologram',NULL,NULL),(35,24,'SURAT.pdf','pdf','assets/commentfiles/20200917_163511SURAT.pdf','2020-09-17 16:35:11','hologram',NULL,NULL),(36,25,'IMG-20200917-WA0004.jpg','jpg','assets/commentfiles/20200917_163916IMG-20200917-WA0004.jpg','2020-09-17 16:39:16','hologram',NULL,NULL),(37,26,'IMG-20200916-WA0001.jpg','jpg','assets/commentfiles/20200917_164047IMG-20200916-WA0001.jpg','2020-09-17 16:40:47','hologram',NULL,NULL),(38,27,'IMG-20200917-WA0001.jpg','jpg','assets/commentfiles/20200917_164141IMG-20200917-WA0001.jpg','2020-09-17 16:41:41','hologram',NULL,NULL),(39,29,'IMG-20200917-WA0001.jpg','jpg','assets/commentfiles/20200918_090654IMG-20200917-WA0001.jpg','2020-09-18 09:06:54','hologram',NULL,NULL),(40,30,'IMG-20200918-WA0002.jpg','jpg','assets/commentfiles/20200918_140133IMG-20200918-WA0002.jpg','2020-09-18 14:01:33','hologram',NULL,NULL),(41,31,'IMG-20200918-WA0004.jpg','jpg','assets/commentfiles/20200918_164919IMG-20200918-WA0004.jpg','2020-09-18 16:49:19','hologram',NULL,NULL),(44,35,'IMG-20200921-WA0001.jpg','jpg','assets/commentfiles/20200922_131922IMG-20200921-WA0001.jpg','2020-09-22 13:19:22','hologram',NULL,NULL),(45,36,'IMG-20200925-WA0001.jpg','jpg','assets/commentfiles/20200925_163554IMG-20200925-WA0001.jpg','2020-09-25 16:35:54','hologram',NULL,NULL),(46,37,'IMG-20200925-WA0001.jpg','jpg','assets/commentfiles/20200925_163620IMG-20200925-WA0001.jpg','2020-09-25 16:36:20','hologram',NULL,NULL),(47,38,'IMG-20200925-WA0001.jpg','jpg','assets/commentfiles/20200925_163644IMG-20200925-WA0001.jpg','2020-09-25 16:36:44','hologram',NULL,NULL),(48,39,'IMG-20200925-WA0001.jpg','jpg','assets/commentfiles/20200925_163710IMG-20200925-WA0001.jpg','2020-09-25 16:37:10','hologram',NULL,NULL),(49,40,'IMG-20200923-WA0003.jpg','jpg','assets/commentfiles/20200925_163837IMG-20200923-WA0003.jpg','2020-09-25 16:38:37','hologram',NULL,NULL),(50,41,'Screenshot from 2020-09-25 14-38-36.png','png','assets/commentfiles/20200925_164242Screenshot-from-2020-09-25-14-38-36.png','2020-09-25 16:42:42','hologram',NULL,NULL),(51,42,'IMG_20200925_052322.jpg','jpg','assets/commentfiles/20200925_164701IMG_20200925_052322.jpg','2020-09-25 16:47:01','hologram',NULL,NULL),(52,43,'Screenshot from 2020-09-25 14-38-36.png','png','assets/commentfiles/20200925_164954Screenshot-from-2020-09-25-14-38-36.png','2020-09-25 16:49:54','hologram',NULL,NULL),(53,44,'IMG-20200925-WA0000.jpg','jpg','assets/commentfiles/20200925_165031IMG-20200925-WA0000.jpg','2020-09-25 16:50:31','hologram',NULL,NULL);

INSERT INTO `t_comments` (`Id`,`M_User_Id`,`T_Taskdetail_Id`,`Comment`,`Created`,`CreatedBy`,`Updated`,`UpdatedBy`) VALUES (2,3,19,'Data ambil dari camera failed','2020-09-16 11:41:28','hologram',NULL,NULL),(3,1,19,'what\'s an error?','2020-09-16 12:05:40','andikaryantoo',NULL,NULL),(4,1,19,'is there a way that you can produce, so i can fix it if its really an  error, im waiting for the reproduce','2020-09-16 12:07:59','andikaryantoo',NULL,NULL),(5,2,19,'there is a bug when uploadin picture from camera, name is not recognized, time and location of the photo. should be done soon for document','2020-09-16 12:47:27','inklolly',NULL,NULL),(6,3,37,'test','2020-09-16 13:18:25','hologram',NULL,NULL),(7,3,19,'i will reproduce and send it to you','2020-09-16 13:19:23','hologram',NULL,NULL),(10,3,19,'heres the files','2020-09-17 15:27:45','hologram',NULL,NULL),(11,3,19,'was left','2020-09-17 15:31:07','hologram',NULL,NULL),(12,3,19,'pdf files','2020-09-17 15:36:18','hologram',NULL,NULL),(19,3,20,'test file','2020-09-17 16:05:36','hologram',NULL,NULL),(20,3,21,'test files','2020-09-17 16:10:56','hologram',NULL,NULL),(21,3,22,'a','2020-09-17 16:16:36','hologram',NULL,NULL),(22,3,20,'a','2020-09-17 16:25:10','hologram',NULL,NULL),(23,3,23,'test','2020-09-17 16:32:49','hologram',NULL,NULL),(24,3,23,'pdf ','2020-09-17 16:35:11','hologram',NULL,NULL),(25,3,23,'photo','2020-09-17 16:39:16','hologram',NULL,NULL),(26,3,23,'h','2020-09-17 16:40:47','hologram',NULL,NULL),(27,3,23,'hv','2020-09-17 16:41:41','hologram',NULL,NULL),(28,3,19,'snagat banyak yang harus diubah jangan santai ya anjing','2020-09-17 16:58:47','hologram',NULL,NULL),(29,3,24,'teet','2020-09-18 09:06:53','hologram',NULL,NULL),(30,3,19,'v','2020-09-18 14:01:32','hologram',NULL,NULL),(31,3,19,'test','2020-09-18 16:49:19','hologram',NULL,NULL),(32,1,53,'is this good','2020-09-18 16:56:36','andikaryanto',NULL,NULL),(35,3,48,'test','2020-09-22 13:19:21','hologram',NULL,NULL),(36,3,57,'dek bayi','2020-09-25 16:35:54','hologram',NULL,NULL),(37,3,57,'dek bayig','2020-09-25 16:36:20','hologram',NULL,NULL),(38,3,57,'dek bayign','2020-09-25 16:36:44','hologram',NULL,NULL),(39,3,57,'dek bayignbb','2020-09-25 16:37:10','hologram',NULL,NULL),(40,3,58,'hai','2020-09-25 16:38:37','hologram',NULL,NULL),(41,3,13,'gas','2020-09-25 16:42:42','hologram',NULL,NULL),(42,3,13,'hshshsh','2020-09-25 16:47:01','hologram',NULL,NULL),(43,3,13,'nx','2020-09-25 16:49:54','hologram',NULL,NULL),(44,3,14,'ahahah','2020-09-25 16:50:31','hologram',NULL,NULL);

INSERT INTO `t_projectinteracts` (`Id`,`M_Project_Id`,`M_User_Id`,`Created`,`CreatedBy`,`Updated`,`UpdatedBy`) VALUES (1,1,1,NULL,NULL,NULL,NULL),(2,2,1,NULL,NULL,NULL,NULL),(3,3,1,NULL,NULL,NULL,NULL),(5,5,3,NULL,NULL,NULL,NULL),(6,6,3,NULL,NULL,NULL,NULL),(31,31,3,'2020-09-07 14:17:46','hologram',NULL,NULL),(64,43,3,'2020-09-08 10:42:52','hologram',NULL,NULL),(73,49,3,'2020-09-09 14:56:08','hologram',NULL,NULL),(74,49,2,'2020-09-09 14:56:08','hologram',NULL,NULL),(75,49,4,'2020-09-09 14:56:08','hologram',NULL,NULL),(76,49,1,'2020-09-09 14:56:08','hologram',NULL,NULL),(105,51,3,'2020-09-11 17:11:43','hologram',NULL,NULL),(106,51,1,'2020-09-11 17:11:43','hologram',NULL,NULL),(107,51,2,'2020-09-11 17:11:43','hologram',NULL,NULL),(108,51,4,'2020-09-11 17:11:43','hologram',NULL,NULL),(112,44,3,'2020-09-14 09:15:04','hologram',NULL,NULL),(113,44,2,'2020-09-14 09:15:04','hologram',NULL,NULL),(114,44,4,'2020-09-14 09:15:04','hologram',NULL,NULL),(115,4,3,'2020-09-15 12:36:27','hologram',NULL,NULL),(116,4,4,'2020-09-15 12:36:27','hologram',NULL,NULL),(117,57,1,'2020-09-18 16:54:35','andikaryanto',NULL,NULL),(118,57,2,'2020-09-18 16:54:35','andikaryanto',NULL,NULL),(175,82,3,'2020-10-05 15:25:07','hologram',NULL,NULL),(176,82,4,'2020-10-05 15:25:07','hologram',NULL,NULL),(177,83,3,'2020-10-05 15:28:59','hologram',NULL,NULL),(178,83,1,'2020-10-05 15:28:59','hologram',NULL,NULL),(179,84,3,'2020-10-05 15:29:49','hologram',NULL,NULL),(180,84,2,'2020-10-05 15:29:49','hologram',NULL,NULL),(181,84,4,'2020-10-05 15:29:49','hologram',NULL,NULL),(185,86,9,'2020-10-08 13:01:25','andikeu',NULL,NULL),(186,86,1,'2020-10-08 13:01:25','andikeu',NULL,NULL),(187,86,2,'2020-10-08 13:01:25','andikeu',NULL,NULL);

INSERT INTO `t_sprints` (`Id`,`M_Project_Id`,`Name`,`Description`,`DateStart`,`DateEnd`,`IsActive`,`Created`,`CreatedBy`,`Updated`,`UpdatedBy`) VALUES (4,51,'Sprint Q3-12','Sprint Q3-12','2020-09-14','2020-09-18',0,'2020-09-15 09:22:36','hologram','2020-09-15 09:26:40','hologram'),(5,51,'Sprint Q4-12','Sprint Q4-12','2020-09-14','2020-09-18',0,'2020-09-15 09:26:40','hologram','2020-09-15 14:34:22','hologram'),(6,49,'Sprint Q3-12','Sprint Q3-12','2020-09-14','2020-09-18',0,'2020-09-15 10:52:27','hologram','2020-09-15 11:57:54','hologram'),(12,49,'Sprint Q4-13','Sprint Q4-13','2020-09-14','2020-09-14',0,'2020-09-15 11:57:59','inklolly','2020-09-15 14:36:32','hologram'),(13,51,'Sprint Q4-14','Spront Q4-14','2020-09-14','2020-09-18',1,'2020-09-15 14:34:22','hologram',NULL,NULL),(14,49,'Sprint Q4-14','Sprint Q4-14','2020-09-14','2020-09-18',1,'2020-09-15 14:36:32','hologram',NULL,NULL),(15,57,'Sprint Q3-12','Sprint Q3-12','2020-09-21','2020-09-25',1,'2020-09-18 16:59:56','andikaryanto',NULL,NULL),(25,4,'Sprint Q3','Sprint Q3','2020-09-21','2020-09-22',0,'2020-09-22 13:37:30','hologram','2020-09-22 13:38:19','hologram'),(26,4,'Sprint Q4','Sprint Qr','2020-09-21','2020-09-26',0,'2020-09-22 13:38:19','hologram','2020-10-06 15:57:17','hologram'),(27,4,'Sprint A','Sprint A','2020-10-07','2020-10-22',0,'2020-10-06 15:57:17','hologram','2020-10-06 16:07:13','hologram'),(28,4,'Sprint v','Sprint v','2020-10-07','2020-10-23',1,'2020-10-06 16:07:13','hologram',NULL,NULL),(29,86,'Sprint Q4-1','Sprint Q4-1','2020-10-05','2020-10-09',1,'2020-10-08 13:11:47','andikeu',NULL,NULL);

INSERT INTO `t_taskdetails` (`Id`,`Name`,`Description`,`T_Task_Id`,`M_User_Id`,`Type`,`Status`,`Created`,`CreatedBy`,`Updated`,`UpdatedBy`) VALUES (1,'Front End dipelajari lebih lanjut / detail','Front End dipelajari lebih lanjut / detail',1,4,1,1,'2020-09-10 15:59:21','hologram',NULL,NULL),(2,'Update report \"Laporan History Pengiriman Data Cabang\" dfasdasdsdfsdf','Update report \"Laporan History Pengiriman Data Cabang\" dfasdasdsdfsdf',1,4,1,1,'2020-09-10 16:05:05','hologram','2020-09-15 09:26:40','hologram'),(3,'Terdapat bug setelah tampilan jamed','Terdapat bug setelah tampilan jamed',1,2,1,1,'2020-09-10 16:14:02','hologram',NULL,NULL),(4,'Update error message pada layar saat melakukan ganti kaset 5','Update error message pada layar saat melakukan ganti kaset 5',1,1,1,1,'2020-09-10 16:14:51','hologram',NULL,NULL),(5,'Update report \"Laporan Transaksi\"','Update report \"Laporan Transaksi\"',1,1,1,1,'2020-09-10 16:29:08','hologram','2020-09-15 14:36:32','hologram'),(6,'Handle status','Handle status',1,2,1,1,'2020-09-10 16:29:35','hologram',NULL,NULL),(7,'Pengiriman & penyesuaian data yang dikirim daei branch ke centralized','Pengiriman & penyesuaian data yang dikirim daei branch ke centralized',2,2,1,1,'2020-09-10 16:30:22','hologram',NULL,NULL),(8,'Explore TCR Mandiri','Explore TCR Mandiri',4,3,1,1,'2020-09-10 16:31:06','hologram',NULL,NULL),(9,'Dapatkan data dari WSDL & di cetak menggunakan printer','Dapatkan data dari WSDL & di cetak menggunakan printer',3,1,1,1,'2020-09-10 16:33:53','hologram',NULL,NULL),(10,'Update report \"Laporan Waktu Tunggu dan Layanan\"','Update report \"Laporan Waktu Tunggu dan Layanan\"',3,2,1,1,'2020-09-10 16:34:38','hologram',NULL,NULL),(11,'Task 02','Task 02',4,2,1,1,'2020-09-10 16:38:05','hologram',NULL,NULL),(12,'Penyesuaian Reschedule Part 1','Penyesuaian Reschedule Part 1, resechdule error saat load data, image, dan csr time login berbeda dari user yang input',6,1,2,1,'2020-09-10 16:42:42','hologram','2020-09-15 14:58:22','andikaryantoo'),(13,'Penyesuaian Reschedule Part 2','Penyesuaian Reschedule Part 2',6,1,2,1,'2020-09-10 16:49:51','hologram','2020-09-15 14:58:22','andikaryantoo'),(14,'Push Notification Android','Push Notification Android',6,1,5,1,'2020-09-10 16:50:15','hologram','2020-09-15 15:52:26','hologram'),(15,'Design business process','Design business process',5,3,5,1,'2020-09-10 16:50:34','hologram','2020-09-18 16:50:56','hologram'),(16,'Implementasi Exif photo','Implementasi Exif photo',7,3,2,1,'2020-09-10 16:51:59','hologram','2020-09-15 14:35:44','hologram'),(17,'Implementasi Exif photo pada web dan show pada detail grid, nama, poisisi, jam','Implementasi Exif photo pada web dan show pada detail grid, nama, poisisi, jam',7,1,1,1,'2020-09-10 16:52:45','hologram',NULL,NULL),(18,'Push Notification Android 7.0 Part 2','Push Notification Android 7.0 Part 2',8,2,1,1,'2020-09-10 16:54:49','hologram',NULL,NULL),(19,'Pengerjaan exif data upload','Pengerjaan exif data upload',8,1,1,1,'2020-09-10 16:55:09','hologram',NULL,NULL),(20,'Failed firebase store','Failed firebase store',8,1,1,1,'2020-09-10 17:02:05','hologram',NULL,NULL),(21,'login failed wrong information','login failed wrong information',8,1,1,1,'2020-09-10 17:02:53','hologram',NULL,NULL),(22,'rooted mobile can login','rooted mobile can login',8,1,1,1,'2020-09-10 17:03:04','hologram',NULL,NULL),(23,'create tab pm and cm schedule','create tab pm and cm schedule',8,1,1,1,'2020-09-10 17:03:28','hologram',NULL,NULL),(24,'upload photo tcr','upload photo tcr',8,1,5,1,'2020-09-10 17:04:04','hologram','2020-09-15 15:52:26','hologram'),(25,'test task management module','test task management module',7,2,1,1,'2020-09-10 17:04:28','hologram',NULL,NULL),(26,'pm schedule wrong date input','pm schedule wrong date input',7,2,1,1,'2020-09-10 17:05:12','hologram',NULL,NULL),(27,'design database procesa','design database procesa',5,3,5,1,'2020-09-10 17:05:40','hologram','2020-09-15 15:55:58','hologram'),(30,'asw','asw',2,2,1,1,'2020-09-11 14:59:28','hologram',NULL,NULL),(31,'anjeng','anjeng',2,2,1,1,'2020-09-11 14:59:43','hologram',NULL,NULL),(32,'test','test',2,2,1,1,'2020-09-11 15:16:05','hologram',NULL,NULL),(33,'anjing sua','anjing sua',2,1,1,1,'2020-09-11 15:17:12','hologram',NULL,NULL),(37,'trololololol','trololololol',11,4,1,1,'2020-09-11 15:32:08','hologram',NULL,NULL),(42,'design database relation','design database relation',12,3,1,1,'2020-09-11 15:42:08','hologram',NULL,NULL),(43,'test fuck of add task','test fuck of add task',5,4,5,1,'2020-09-11 17:12:05','hologram',NULL,NULL),(44,'anjing test ini bangsad','anjing test ini bangsad',5,4,5,1,'2020-09-14 09:17:11','hologram',NULL,NULL),(46,'Firebase notification can reply','Firebase notification can reply in notification shown, show drop down to get input reply. ',8,1,1,1,'2020-09-14 12:50:19','hologram',NULL,NULL),(48,'Create dynamic info','Creat dyanamic info of company that cant be loaded from database. ',14,4,1,1,'2020-09-15 12:38:05','fuckoff',NULL,NULL),(49,'Design system architect ','Design system architect for mobile apps. use react native / boiler plate',5,3,5,1,'2020-09-15 14:01:24','hologram','2020-09-18 14:06:14','hologram'),(50,'Design flow cart for mobile','Design flowchart for mobile business prosess to API',5,3,3,1,'2020-09-15 14:02:41','hologram','2020-10-06 14:52:43','hologram'),(51,'Design UI UX for mobile','Design mobile UI UX dor mobile. Can copy from previous project. ',5,3,5,1,'2020-09-15 14:04:34','hologram','2020-09-15 16:00:17','hologram'),(52,'testt','sstata',8,2,1,1,'2020-09-17 16:19:00','hologram',NULL,NULL),(53,'add photo, describe self','add photo describe self and any other field required',15,2,1,1,'2020-09-18 16:55:59','andikaryanto',NULL,NULL),(56,'test','tedt',14,3,5,1,'2020-09-22 13:22:19','hologram','2020-09-22 13:46:22','hologram'),(57,'company module','company module',14,3,1,1,'2020-09-25 16:22:48','inklolly',NULL,NULL),(58,'hhh','hhhh',14,3,1,1,'2020-09-25 16:35:33','hologram',NULL,NULL),(59,'testa','testa',6,2,1,1,'2020-09-25 16:52:30','hologram',NULL,NULL),(60,'FE - Explore FE TCR Mandiri','FE - Explore FE TCR Mandiri',20,1,1,1,'2020-10-08 13:10:55','andikeu',NULL,NULL);

INSERT INTO `t_tasks` (`Id`,`Name`,`Description`,`M_Project_Id`,`Created`,`CreatedBy`,`Updated`,`UpdatedBy`) VALUES (1,'F1. WAKWOAKWOAWK','Test backlog',49,'2020-09-09 16:54:57','inklolly',NULL,NULL),(2,'F2. TCR GGS India',NULL,49,'2020-09-10 13:11:52','hologram',NULL,NULL),(3,'F3. DE-100 New Platform',NULL,49,'2020-09-10 13:21:01','hologram',NULL,NULL),(4,'F4. TCR Bank Mandiri',NULL,49,'2020-09-10 16:30:47','hologram',NULL,NULL),(5,'A. Dsashboard schedule jadwal PM',NULL,51,'2020-09-10 16:41:15','hologram',NULL,NULL),(6,'B. List of Schedule PM',NULL,51,'2020-09-10 16:41:59','hologram',NULL,NULL),(7,'E. Task management module',NULL,51,'2020-09-10 16:51:22','hologram',NULL,NULL),(8,'F. Mobile Apps Development',NULL,51,'2020-09-10 16:53:30','hologram',NULL,NULL),(11,'F5. Test',NULL,49,'2020-09-11 15:18:02','hologram',NULL,NULL),(12,'A1. Purchase Order',NULL,44,'2020-09-11 15:41:34','hologram',NULL,NULL),(14,'Dashboard ',NULL,4,'2020-09-15 12:36:18','hologram',NULL,NULL),(15,'A. Welcome Page',NULL,57,'2020-09-18 16:55:18','andikaryanto',NULL,NULL),(17,'A1. Cash Pick Up BCA',NULL,86,'2020-10-08 13:09:15','andikeu',NULL,NULL),(18,'A2. TCR GGS India',NULL,86,'2020-10-08 13:09:34','andikeu',NULL,NULL),(19,'A3. DE-100 New Platform',NULL,86,'2020-10-08 13:10:00','andikeu',NULL,NULL),(20,'A4. TCR Bank Mandiri',NULL,86,'2020-10-08 13:10:13','andikeu',NULL,NULL);

/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
