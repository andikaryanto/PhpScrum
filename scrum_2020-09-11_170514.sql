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

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: m_enumdetails
# ------------------------------------------------------------

INSERT INTO `m_enumdetails` (`Id`,`M_Enum_Id`,`Value`,`EnumName`,`Ordering`,`Resource`) VALUES (1,1,1,'New',1,NULL),(2,1,2,'In Progress',2,NULL),(3,1,3,'Suspended',3,NULL),(4,1,4,'Done',4,NULL),(5,2,1,'Back Log',1,NULL),(6,2,2,'Plan',2,NULL),(7,2,3,'Doing',3,NULL),(8,2,4,'Check',4,NULL),(9,2,5,'Done',5,NULL);

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: m_enums
# ------------------------------------------------------------

INSERT INTO `m_enums` (`Id`,`Name`) VALUES (1,'ProjectStatus'),(2,'TaskType');

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: m_positions
# ------------------------------------------------------------

INSERT INTO `m_positions` (`Id`,`Position`,`Description`) VALUES (1,'Project Manager','Project Manager'),(2,'Back End Developer','Back End Developer'),(3,'Front End Developer','Front End Developer'),(4,'Database Administrator','Database Administrator');

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: m_profiles
# ------------------------------------------------------------

INSERT INTO `m_profiles` (`Id`,`M_User_Id`,`M_Position_Id`,`About`,`Photo`) VALUES (3,2,3,'I am more full stack I started out in front end but after having to build a server I have become good at both, if I had to choose I would say fronted, because I like playing with UIs.','/assets/profiles/inklolly.jpg'),(4,1,2,'I like to use the JVM for backend, but I can use Node or .net if I must. For frontend, I love just vanilla android and flutter, but I have experience with asp.net and vue, also','/assets/profiles/andik.jpeg'),(5,3,1,'I am passionate about solving challenging problems and loved programming for that reason. started out learning C and Java in college but eventually had to learn JavaScript to build a website and instantly fell in love with how much of an art building UI is and ever since I have been doing a lot of Frontend work and occasional Backend (I like both but UI touches my heart)','/assets/profiles/hologram.jpg'),(6,4,4,'Currently I\'m a front-end dev working on a small 3 man team. If I had to choose I\'d do mainly full-stack but I\'m where I am needed at the moment. I don\'t think I\'d want to be constrained to just the front or the back. I like the freedom of designing API\'s one day in c# and designing dynamic front-ends in JavaScript the next','/assets/profiles/fuckoff.jpeg');

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: m_projects
# ------------------------------------------------------------

INSERT INTO `m_projects` (`Id`,`Name`,`Description`,`StartDate`,`EndDate`,`Status`,`M_User_Id`,`Created`,`CreatedBy`,`Updated`,`UpdatedBy`) VALUES (1,'My Own Desktop','Desktop Application to support My Own Desktop solution, usage for internal production and employee productivity','2020-09-02','2020-12-03',1,1,NULL,NULL,NULL,NULL),(2,'Dummy Bank Website Profile','Desktop Application to support Dummy Bank Website Profile solution, usage for internal production and employee productivity','2020-09-02','2020-10-30',1,1,NULL,NULL,NULL,NULL),(3,'Wordpress Commerse Rabbani HIjab','Wordpress Commerse Rabbani HIjab for selling item, including cart and shipping price, promo master and discount master','2020-09-02','2020-11-13',2,NULL,NULL,NULL,NULL,NULL),(4,'A Capita Company Profile','Create Company profile for A Capita company for trading overview','2020-09-02','2020-09-30',3,NULL,NULL,NULL,NULL,NULL),(5,'ERP Project Syncore','ERP Project Syncore Consulatnt to get their client accounting management, selling product, pruchasing product, stock opname','2020-09-04','2020-09-30',1,NULL,NULL,NULL,NULL,NULL),(6,'HR Project','Create HR Project for our company, employee day off, employee data, employee presence, employee task','2020-09-24','2020-11-19',4,1,NULL,NULL,NULL,NULL),(31,'OJK dashboard','cretae OJK dashboard using dundash dashboard and SQLServer. BI project will be lead by Project Manager on site',NULL,NULL,1,3,'2020-09-07 14:17:46','hologram',NULL,NULL),(43,'Compamy profile Insurance','Company profile Insurance. show insurance product , admin preference, debt','2020-09-11','2020-09-19',1,3,'2020-09-08 10:42:52','hologram',NULL,NULL),(44,'POS Nothing cafe','POS Nothing cafe. daily selling, daily purchase, member, discount, promo, voucher, product','2020-09-08','2020-09-08',1,3,'2020-09-08 10:44:47','hologram',NULL,NULL),(49,'ERP project syncores','wowksindidndksmidbsjsndn','2020-09-08','2020-12-05',1,3,'2020-09-09 14:56:07','hologram',NULL,NULL),(51,'SCRUM 2020 - SYSDEV Internal System Section','SCRUM 2020 - SYSDEV Internal System Section','2020-09-18','2021-07-20',1,3,'2020-09-10 16:40:35','hologram',NULL,NULL),(56,'test  anjing','test anjing','2020-09-11','2020-09-30',1,3,'2020-09-11 16:17:14','hologram',NULL,NULL);

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: m_users
# ------------------------------------------------------------

INSERT INTO `m_users` (`Id`,`Email`,`Name`,`Username`,`Password`,`Created`,`CreatedBy`,`Updated`,`UpdatedBy`) VALUES (1,'andik.aryantoo@gmail.com','Andik Aryanto','andikaryantoo','2ed16ae590422b5617b8cff01a6ccc8a',NULL,NULL,NULL,NULL),(2,'inklolly6@gmail.com','Ink lolly','inklolly','38058a85b3f0599abb64b79a62c86d72',NULL,NULL,NULL,NULL),(3,'hologram@gmail.com','Hologram','hologram','a9051c9e910d0477b9275760a8e546ea',NULL,NULL,NULL,NULL),(4,'fuckoff@gmail.com','Fuck Off','fuckoff','1660f88af58bf34d345d9a5c63c1f438',NULL,NULL,NULL,NULL);

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: t_projectinteracts
# ------------------------------------------------------------

INSERT INTO `t_projectinteracts` (`Id`,`M_Project_Id`,`M_User_Id`,`Created`,`CreatedBy`,`Updated`,`UpdatedBy`) VALUES (1,1,1,NULL,NULL,NULL,NULL),(2,2,1,NULL,NULL,NULL,NULL),(3,3,1,NULL,NULL,NULL,NULL),(4,4,3,NULL,NULL,NULL,NULL),(5,5,3,NULL,NULL,NULL,NULL),(6,6,3,NULL,NULL,NULL,NULL),(31,31,3,'2020-09-07 14:17:46','hologram',NULL,NULL),(64,43,3,'2020-09-08 10:42:52','hologram',NULL,NULL),(65,44,3,'2020-09-08 10:44:47','hologram',NULL,NULL),(73,49,3,'2020-09-09 14:56:08','hologram',NULL,NULL),(74,49,2,'2020-09-09 14:56:08','hologram',NULL,NULL),(75,49,4,'2020-09-09 14:56:08','hologram',NULL,NULL),(76,49,1,'2020-09-09 14:56:08','hologram',NULL,NULL),(80,51,3,'2020-09-10 16:40:35','hologram',NULL,NULL),(81,51,1,'2020-09-10 16:40:35','hologram',NULL,NULL),(82,51,2,'2020-09-10 16:40:35','hologram',NULL,NULL),(100,56,3,'2020-09-11 17:03:50','hologram',NULL,NULL),(101,56,1,'2020-09-11 17:03:50','hologram',NULL,NULL);

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: t_taskdetails
# ------------------------------------------------------------

INSERT INTO `t_taskdetails` (`Id`,`Name`,`Description`,`T_Task_Id`,`M_User_Id`,`Type`,`Status`,`Created`,`CreatedBy`,`Updated`,`UpdatedBy`) VALUES (1,'Front End dipelajari lebih lanjut / detail',NULL,1,4,1,1,'2020-09-10 15:59:21','hologram',NULL,NULL),(2,'Update report \"Laporan History Pengiriman Data Cabang\" dfasdasdsdfsdf',NULL,1,4,1,1,'2020-09-10 16:05:05','hologram',NULL,NULL),(3,'Terdapat bug setelah tampilan jamed',NULL,1,2,1,1,'2020-09-10 16:14:02','hologram',NULL,NULL),(4,'Update error message pada layar saat melakukan ganti kaset 5',NULL,1,1,1,1,'2020-09-10 16:14:51','hologram',NULL,NULL),(5,'Update report \"Laporan Transaksi\"',NULL,1,1,1,1,'2020-09-10 16:29:08','hologram',NULL,NULL),(6,'Handle status',NULL,1,2,1,1,'2020-09-10 16:29:35','hologram',NULL,NULL),(7,'Pengiriman & penyesuaian data yang dikirim daei branch ke centralized',NULL,2,2,1,1,'2020-09-10 16:30:22','hologram',NULL,NULL),(8,'Explore TCR Mandiri',NULL,4,3,1,1,'2020-09-10 16:31:06','hologram',NULL,NULL),(9,'Dapatkan data dari WSDL & di cetak menggunakan printer',NULL,3,1,1,1,'2020-09-10 16:33:53','hologram',NULL,NULL),(10,'Update report \"Laporan Waktu Tunggu dan Layanan\"',NULL,3,2,1,1,'2020-09-10 16:34:38','hologram',NULL,NULL),(11,'Task 02',NULL,4,2,1,1,'2020-09-10 16:38:05','hologram',NULL,NULL),(12,'Penyesuaian Reschedule Part 1',NULL,6,1,1,1,'2020-09-10 16:42:42','hologram',NULL,NULL),(13,'Penyesuaian Reschedule Part 2',NULL,6,1,1,1,'2020-09-10 16:49:51','hologram',NULL,NULL),(14,'Push Notification Android',NULL,6,1,1,1,'2020-09-10 16:50:15','hologram',NULL,NULL),(15,'Design business process',NULL,5,3,1,1,'2020-09-10 16:50:34','hologram',NULL,NULL),(16,'Implementasi Exif photo',NULL,7,3,1,1,'2020-09-10 16:51:59','hologram',NULL,NULL),(17,'Implementasi Exif photo pada web',NULL,7,1,1,1,'2020-09-10 16:52:45','hologram',NULL,NULL),(18,'Push Notification Android 7.0 Part 2',NULL,8,2,1,1,'2020-09-10 16:54:49','hologram',NULL,NULL),(19,'Pengerjaan exif data upload',NULL,8,1,1,1,'2020-09-10 16:55:09','hologram',NULL,NULL),(20,'Failed firebase store',NULL,8,1,1,1,'2020-09-10 17:02:05','hologram',NULL,NULL),(21,'login failed wrong information',NULL,8,1,1,1,'2020-09-10 17:02:53','hologram',NULL,NULL),(22,'rooted mobile can login',NULL,8,1,1,1,'2020-09-10 17:03:04','hologram',NULL,NULL),(23,'create tab pm and cm schedule',NULL,8,1,1,1,'2020-09-10 17:03:28','hologram',NULL,NULL),(24,'upload photo tcr',NULL,8,1,1,1,'2020-09-10 17:04:04','hologram',NULL,NULL),(25,'test task management module',NULL,7,2,1,1,'2020-09-10 17:04:28','hologram',NULL,NULL),(26,'pm schedule wrong date input',NULL,7,2,1,1,'2020-09-10 17:05:12','hologram',NULL,NULL),(27,'design database procesa',NULL,5,3,1,1,'2020-09-10 17:05:40','hologram',NULL,NULL),(30,'asw',NULL,2,2,1,1,'2020-09-11 14:59:28','hologram',NULL,NULL),(31,'anjeng',NULL,2,2,1,1,'2020-09-11 14:59:43','hologram',NULL,NULL),(32,'test',NULL,2,2,1,1,'2020-09-11 15:16:05','hologram',NULL,NULL),(33,'anjing sua',NULL,2,1,1,1,'2020-09-11 15:17:12','hologram',NULL,NULL),(37,'trololololol',NULL,11,4,1,1,'2020-09-11 15:32:08','hologram',NULL,NULL),(42,'design database relation',NULL,12,3,1,1,'2020-09-11 15:42:08','hologram',NULL,NULL);

# ------------------------------------------------------------
# DATA DUMP FOR TABLE: t_tasks
# ------------------------------------------------------------

INSERT INTO `t_tasks` (`Id`,`Name`,`Description`,`M_Project_Id`,`Created`,`CreatedBy`,`Updated`,`UpdatedBy`) VALUES (1,'F1. WAKWOAKWOAWK','Test backlog',49,'2020-09-09 16:54:57','inklolly',NULL,NULL),(2,'F2. TCR GGS India',NULL,49,'2020-09-10 13:11:52','hologram',NULL,NULL),(3,'F3. DE-100 New Platform',NULL,49,'2020-09-10 13:21:01','hologram',NULL,NULL),(4,'F4. TCR Bank Mandiri',NULL,49,'2020-09-10 16:30:47','hologram',NULL,NULL),(5,'A. Dsashboard schedule jadwal PM',NULL,51,'2020-09-10 16:41:15','hologram',NULL,NULL),(6,'B. List of Schedule PM',NULL,51,'2020-09-10 16:41:59','hologram',NULL,NULL),(7,'E. Task management module',NULL,51,'2020-09-10 16:51:22','hologram',NULL,NULL),(8,'F. Mobile Apps Development',NULL,51,'2020-09-10 16:53:30','hologram',NULL,NULL),(11,'F5. Test',NULL,49,'2020-09-11 15:18:02','hologram',NULL,NULL),(12,'A1. Purchase Order',NULL,44,'2020-09-11 15:41:34','hologram',NULL,NULL);

/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
