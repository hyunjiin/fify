-- MariaDB dump 10.19  Distrib 10.5.10-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: fify
-- ------------------------------------------------------
-- Server version	10.5.10-MariaDB-1:10.5.10+maria~bionic

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add user',4,'add_user'),(14,'Can change user',4,'change_user'),(15,'Can delete user',4,'delete_user'),(16,'Can view user',4,'view_user'),(17,'Can add content type',5,'add_contenttype'),(18,'Can change content type',5,'change_contenttype'),(19,'Can delete content type',5,'delete_contenttype'),(20,'Can view content type',5,'view_contenttype'),(21,'Can add session',6,'add_session'),(22,'Can change session',6,'change_session'),(23,'Can delete session',6,'delete_session'),(24,'Can view session',6,'view_session'),(25,'Can add yolo',7,'add_yolo'),(26,'Can change yolo',7,'change_yolo'),(27,'Can delete yolo',7,'delete_yolo'),(28,'Can view yolo',7,'view_yolo'),(29,'Can add nutrition',8,'add_nutrition'),(30,'Can change nutrition',8,'change_nutrition'),(31,'Can delete nutrition',8,'delete_nutrition'),(32,'Can view nutrition',8,'view_nutrition');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user_groups` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_user_permissions`
--

LOCK TABLES `auth_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext DEFAULT NULL,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) unsigned NOT NULL CHECK (`action_flag` >= 0),
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(3,'auth','group'),(2,'auth','permission'),(4,'auth','user'),(5,'contenttypes','contenttype'),(8,'nutrition','nutrition'),(7,'nutrition','yolo'),(6,'sessions','session');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_migrations` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2021-12-08 02:10:36.003624'),(2,'auth','0001_initial','2021-12-08 02:10:39.883667'),(3,'admin','0001_initial','2021-12-08 02:10:40.989408'),(4,'admin','0002_logentry_remove_auto_add','2021-12-08 02:10:41.152202'),(5,'admin','0003_logentry_add_action_flag_choices','2021-12-08 02:10:41.314015'),(6,'contenttypes','0002_remove_content_type_name','2021-12-08 02:10:41.903610'),(7,'auth','0002_alter_permission_name_max_length','2021-12-08 02:10:42.174326'),(8,'auth','0003_alter_user_email_max_length','2021-12-08 02:10:42.446824'),(9,'auth','0004_alter_user_username_opts','2021-12-08 02:10:42.608616'),(10,'auth','0005_alter_user_last_login_null','2021-12-08 02:10:42.867590'),(11,'auth','0006_require_contenttypes_0002','2021-12-08 02:10:43.026248'),(12,'auth','0007_alter_validators_add_error_messages','2021-12-08 02:10:43.187591'),(13,'auth','0008_alter_user_username_max_length','2021-12-08 02:10:43.432165'),(14,'auth','0009_alter_user_last_name_max_length','2021-12-08 02:10:43.677617'),(15,'auth','0010_alter_group_name_max_length','2021-12-08 02:10:43.950232'),(16,'auth','0011_update_proxy_permissions','2021-12-08 02:10:44.355186'),(17,'auth','0012_alter_user_first_name_max_length','2021-12-08 02:10:44.599618'),(18,'nutrition','0001_initial','2021-12-08 02:10:46.855349'),(19,'sessions','0001_initial','2021-12-08 02:10:47.422614');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nutrition_nutrition`
--

DROP TABLE IF EXISTS `nutrition_nutrition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nutrition_nutrition` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `product_name` varchar(50) NOT NULL,
  `serving_size` varchar(30) NOT NULL,
  `calorie_kJ` varchar(10) NOT NULL,
  `calorie_kcal` varchar(10) NOT NULL,
  `carbohydrate` varchar(10) NOT NULL,
  `sugar` varchar(10) NOT NULL,
  `protein` varchar(10) NOT NULL,
  `fat` varchar(10) NOT NULL,
  `fat_2` varchar(10) NOT NULL,
  `fat_3` varchar(10) NOT NULL,
  `fat_4` varchar(10) DEFAULT NULL,
  `fat_5` varchar(10) DEFAULT NULL,
  `dietary_fiber` varchar(10) DEFAULT NULL,
  `potassium` varchar(10) DEFAULT NULL,
  `cholesterol` varchar(10) NOT NULL,
  `salt` varchar(10) DEFAULT NULL,
  `voice1` varchar(255) NOT NULL,
  `voice2` varchar(255) NOT NULL,
  `class_name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `nutrition_nutrition_class_name_e2e59229_fk_nutrition` (`class_name`),
  CONSTRAINT `nutrition_nutrition_class_name_e2e59229_fk_nutrition` FOREIGN KEY (`class_name`) REFERENCES `nutrition_yolo` (`class_name`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nutrition_nutrition`
--

LOCK TABLES `nutrition_nutrition` WRITE;
/*!40000 ALTER TABLE `nutrition_nutrition` DISABLE KEYS */;
INSERT INTO `nutrition_nutrition` VALUES (1,'맥심 티오피 더블랙','1캔 (275 ml)','29 kJ','7 kcal','1.00g','0.00g','0.40g','0.10g','0.000g','0.000g','null','null','null','null','0mg','35mg','1캔 275 ml안에7 kcal가 있습니다.','설탕당은 0.00g 지방은 0.10g 나트륨은 35mg 이 포함되어있습니다.','TOP_black'),(2,'바리스타룰스에스프레소라떼','1컵 (250 g)','678 kJ','162 kcal','22.00g','20.00g','5.00g','6.00g','3.400g','0.000g','null','null','null','null','20mg','120mg','1컵 250 g안에162 kcal가 있습니다.','설탕당은 20.00g 지방은 6.00g 나트륨은 120mg 이 포함되어있습니다.','baristarules_espressolatte'),(3,'카프리썬 오렌지','1봉지 (200 ml)','251 kJ','60 kcal','15.00g','15.00g','0.00g','0.00g','0.000g','0.000g','null','null','null','null','0mg','0mg','1봉지 200 ml안에60 kcal가 있습니다.','설탕당은 15.00g 지방은 0.00g 나트륨은 0mg 이 포함되어있습니다.','cafrisun'),(4,'칠성사이다','1캔 (355ml)','649 kJ','155 kcal','39.00g','38.00g','0.00g','0.00g','0.000g','0.000g','null','null','null','null','0mg','10mg','1캔 355ml안에155 kcal가 있습니다.','설탕당은 38.00g 지방은 0.00g 나트륨은 10mg 이 포함되어있습니다.','chilsungcider'),(5,'칠성사이다 제로','1병 (500 ml)','0 kJ','0 kcal','8.00g','0.00g','0.00g','0.00g','0.000g','0.000g','null','null','0.0g','0mg','0mg','12mg','1병 500 ml안에0 kcal가 있습니다.','설탕당은 0.00g 지방은 0.00g 나트륨은 12mg 이 포함되어있습니다.','chilsungcider_zero'),(6,'코카콜라 355ml','1캔 (355 ml)','636 kJ','152 kcal','38.00g','38.00g','0.00g','0.00g','0.000g','0.000g','null','null','null','null','0mg','11mg','1캔 355 ml안에152 kcal가 있습니다.','설탕당은 38.00g 지방은 0.00g 나트륨은 11mg 이 포함되어있습니다.','cocacola'),(7,'코카콜라제로 250ml','1회 (250 ml)','0 kJ','0 kcal','0.00g','0.00g','0.00g','0.00g','0.000g','0.000g','null','null','null','null','0mg','19mg','1회 250 ml안에0 kcal가 있습니다.','설탕당은 0.00g 지방은 0.00g 나트륨은 19mg 이 포함되어있습니다.','cocacola_zero'),(8,'콘트라베이스 스위트 블랙','1인분 (500 ml)','335 kJ','80 kcal','19.00g','19.00g','1.00g','0.00g','0.000g','0.000g','null','null','null','null','0mg','123mg','1인분 500 ml안에80 kcal가 있습니다.','설탕당은 19.00g 지방은 0.00g 나트륨은 123mg 이 포함되어있습니다.','contrabass_sweetblack'),(9,'환타 오렌지 355ml','1인분 (355 ml)','653 kJ','156 kcal','39.00g','39.00g','0.00g','0.00g','0.000g','0.000g','null','null','null','null','0mg','11mg','1인분 355 ml안에156 kcal가 있습니다.','설탕당은 39.00g 지방은 0.00g 나트륨은 11mg 이 포함되어있습니다.','fanta_orange'),(10,'게토레이 레몬 600ml','1회 (600 ml)','669 kJ','160 kcal','40.00g','39.00g','0.00g','0.00g','0.000g','0.000g','null','null','null','null','0mg','300mg','1회 600 ml안에160 kcal가 있습니다.','설탕당은 39.00g 지방은 0.00g 나트륨은 300mg 이 포함되어있습니다.','gatorade_lemon'),(11,'크래프트 블랙','1병 (470 ml)','59 kJ','14 kcal','2.40g','0.00g','1.00g','0.00g','0.000g','0.000g','null','null','null','null','0mg','82mg','1병 470 ml안에14 kcal가 있습니다.','설탕당은 0.00g 지방은 0.00g 나트륨은 82mg 이 포함되어있습니다.','georgiacraft_black'),(12,'하늘보리 500ml','1병 (500 ml)','247 kJ','59 kcal','14.00g','0.00g','0.00g','0.00g','0.000g','0.000g','null','null','null','null','0mg','0mg','1병 500 ml안에59 kcal가 있습니다.','설탕당은 0.00g 지방은 0.00g 나트륨은 0mg 이 포함되어있습니다.','haneulbori'),(13,'광동 헛개차 500ml','1병 (500ml)','0 kJ','0 kcal','0.00g','0.00g','0.00g','0.00g','0.000g','0.000g','null','null','null','null','0mg','50mg','1병 500ml안에0 kcal가 있습니다.','설탕당은 0.00g 지방은 0.00g 나트륨은 50mg 이 포함되어있습니다.','heotgaecha'),(14,'허니유자 ','1회 (280 ml)','586 kJ','140 kcal','35.00g','34.00g','0.00g','0.00g','0.000g','0.000g','null','null','null','null','0mg','145mg','1회 280 ml안에140 kcal가 있습니다.','설탕당은 34.00g 지방은 0.00g 나트륨은 145mg 이 포함되어있습니다.','honeyyuja'),(15,'핫식스','1캔 (250 ml)','481 kJ','115 kcal','29.00g','29.00g','0.00g','0.00g','0.000g','0.000g','null','0.000g','null','null','0mg','75mg','1캔 250 ml안에115 kcal가 있습니다.','설탕당은 29.00g 지방은 0.00g 나트륨은 75mg 이 포함되어있습니다.','hotsix_org'),(16,'레쓰비 150ml','1캔 (150 ml)','188 kJ','45 kcal','10.00g','10.00g','1.00g','0.00g','0.000g','0.000g','null','null','null','null','0mg','75mg','1캔 150 ml안에45 kcal가 있습니다.','설탕당은 10.00g 지방은 0.00g 나트륨은 75mg 이 포함되어있습니다.','letsbe'),(17,'레쓰비 그란데 헤이즐넛','1인분 (500 ml)','502 kJ','120 kcal','29.00g','30.00g','1.00g','0.00g','0.000g','0.000g','null','null','null','null','0mg','105mg','1인분 500 ml안에120 kcal가 있습니다.','설탕당은 30.00g 지방은 0.00g 나트륨은 105mg 이 포함되어있습니다.','letsbe_grande_hazelnut'),(18,'미닛메이드 오리지널 오렌지','1병 (350ml)','552 kJ','132 kcal','31.00g','26.00g','2.00g','0.00g','0.000g','0.000g','null','null','null','null','0mg','95mg','1병 350ml안에132 kcal가 있습니다.','설탕당은 26.00g 지방은 0.00g 나트륨은 95mg 이 포함되어있습니다.','minutemaid_org_orange'),(19,'나랑드 사이다 제로 245ml','1인분 (245 ml)','0 kJ','0 kcal','0.00g','0.00g','0.00g','0.00g','0.000g','0.000g','null','null','null','null','0mg','45mg','1인분 245 ml안에0 kcal가 있습니다.','설탕당은 0.00g 지방은 0.00g 나트륨은 45mg 이 포함되어있습니다.','narangdcider'),(20,'광동 옥수수 수염차 500ml','1병 (500 ml)','0 kJ','0 kcal','0.00g','0.00g','0.00g','0.00g','0.000g','0.000g','null','null','null','null','0mg','50mg','1병 500 ml안에0 kcal가 있습니다.','설탕당은 0.00g 지방은 0.00g 나트륨은 50mg 이 포함되어있습니다.','oksususuyeomcha'),(21,'제로콜라 펩시','1인분 (355 ml)','0 kJ','0 kcal','0.00g','0.00g','0.00g','0.00g','0.000g','0.000g','0.000g','0.000g','0.0g','0mg','0mg','95mg','1인분 355 ml안에0 kcal가 있습니다.','설탕당은 0.00g 지방은 0.00g 나트륨은 95mg 이 포함되어있습니다.','pepsi_zero'),(22,'피크닉 사과','1회 (200 ml)','293 kJ','70 kcal','17.00g','16.00g','1.00g','0.00g','0.000g','0.000g','null','null','null','null','0mg','60mg','1회 200 ml안에70 kcal가 있습니다.','설탕당은 16.00g 지방은 0.00g 나트륨은 60mg 이 포함되어있습니다.','picnic_apple'),(23,'포카리스웨트 500ml','1병 (500 ml)','523 kJ','125 kcal','31.00g','30.00g','0.00g','0.00g','0.000g','0.000g','null','null','null','null','0mg','250mg','1병 500 ml안에125 kcal가 있습니다.','설탕당은 30.00g 지방은 0.00g 나트륨은 250mg 이 포함되어있습니다.','pocarisweat'),(24,'파워오투 오렌지','1인분 (500 ml)','372 kJ','89 kcal','21.00g','21.00g','0.00g','0.00g','0.000g','0.000g','null','null','null','null','0mg','6mg','1인분 500 ml안에89 kcal가 있습니다.','설탕당은 21.00g 지방은 0.00g 나트륨은 6mg 이 포함되어있습니다.','powerO2_orange'),(25,'파워에이드 마운틴블라스트 600ml','1페트 (355 ml)','151 kJ','36 kcal','9.00g','9.00g','0.00g','0.00g','0.000g','0.000g','null','null','null','null','0mg','188mg','1페트 355 ml안에36 kcal가 있습니다.','설탕당은 9.00g 지방은 0.00g 나트륨은 188mg 이 포함되어있습니다.','powerade_mountainblast'),(26,'스프라이트 355ml','1캔 (355 ml)','669 kJ','160 kcal','40.00g','40.00g','0.00g','0.00g','0.000g','0.000g','null','null','null','null','0mg','33mg','1캔 355 ml안에160 kcal가 있습니다.','설탕당은 40.00g 지방은 0.00g 나트륨은 33mg 이 포함되어있습니다.','sprite'),(27,'스프라이트 제로','1캔 (500 ml)','0 kJ','0 kcal','0.20g','0.00g','0.00g','0.00g','0.000g','0.000g','0.000g','0.000g','0.0g','0mg','0mg','3mg','1캔 500 ml안에0 kcal가 있습니다.','설탕당은 0.00g 지방은 0.00g 나트륨은 3mg 이 포함되어있습니다.','sprite_zero'),(28,'스타벅스 컵커피 카페라떼','1개 (270 ml)','900 kJ','215 kcal','23.00g','20.00g','6.10g','10.80g','0.500g','5.700g','null','null','null','null','33mg','154mg','1개 270 ml안에215 kcal가 있습니다.','설탕당은 20.00g 지방은 10.80g 나트륨은 154mg 이 포함되어있습니다.','starbucks_cafelatte'),(29,'토레타','1병 (500 ml)','347 kJ','83 kcal','20.00g','20.00g','0.80g','0.00g','0.000g','0.000g','null','null','null','null','0mg','291mg','1병 500 ml안에83 kcal가 있습니다.','설탕당은 20.00g 지방은 0.00g 나트륨은 291mg 이 포함되어있습니다.','toreta'),(30,'웰치스 그레이프맛','1캔 (355 ml)','803 kJ','192 kcal','48.00g','46.00g','0.00g','0.00g','0.000g','0.000g','null','null','null','null','0mg','0mg','1캔 355 ml안에192 kcal가 있습니다.','설탕당은 46.00g 지방은 0.00g 나트륨은 0mg 이 포함되어있습니다.','welchs_grape');
/*!40000 ALTER TABLE `nutrition_nutrition` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nutrition_yolo`
--

DROP TABLE IF EXISTS `nutrition_yolo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nutrition_yolo` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `index` int(11) NOT NULL,
  `class_name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index` (`index`),
  UNIQUE KEY `class_name` (`class_name`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nutrition_yolo`
--

LOCK TABLES `nutrition_yolo` WRITE;
/*!40000 ALTER TABLE `nutrition_yolo` DISABLE KEYS */;
INSERT INTO `nutrition_yolo` VALUES (1,0,'TOP_black'),(2,1,'baristarules_espressolatte'),(3,2,'cafrisun'),(4,3,'chilsungcider'),(5,4,'chilsungcider_zero'),(6,5,'cocacola'),(7,6,'cocacola_zero'),(8,7,'contrabass_sweetblack'),(9,8,'fanta_orange'),(10,9,'gatorade_lemon'),(11,10,'georgiacraft_black'),(12,11,'haneulbori'),(13,12,'heotgaecha'),(14,13,'honeyyuja'),(15,14,'hotsix_org'),(16,15,'letsbe'),(17,16,'letsbe_grande_hazelnut'),(18,17,'minutemaid_org_orange'),(19,18,'narangdcider'),(20,19,'oksususuyeomcha'),(21,20,'pepsi_zero'),(22,21,'picnic_apple'),(23,22,'pocarisweat'),(24,23,'powerO2_orange'),(25,24,'powerade_mountainblast'),(26,25,'sprite'),(27,26,'sprite_zero'),(28,27,'starbucks_cafelatte'),(29,28,'toreta'),(30,29,'welchs_grape');
/*!40000 ALTER TABLE `nutrition_yolo` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-12-08  2:19:36
