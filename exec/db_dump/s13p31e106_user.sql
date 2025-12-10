-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: ssafy-mysql-db.mysql.database.azure.com    Database: s13p31e106
-- ------------------------------------------------------
-- Server version	8.0.42-azure

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `user_uuid` varchar(36) NOT NULL,
  `user_village_id` bigint DEFAULT NULL,
  `username` varchar(16) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('ADMIN','LEADER','USER') NOT NULL,
  `kakao_user_id` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES ('0cc3b5b8-55ab-4b86-9070-6e7e4f697e47',1,'박주민','orangepark@orange.com','$2a$10$bK9CYzKR6iMkOdw5zDpJ1.0oCfuxjpO2y3l.4g1HYSLDyxuGge7fe','USER',NULL,'2025-10-29 14:12:14','2025-10-29 05:13:41'),('18e493ed-6920-4abc-9d04-71e5671a938b',3,'테스트이장','test456@test.com','$2a$10$jKnBZaMzUn6q39clCsuz7OaagDvH8dklJdW9GED.tOCIAt1IeQjD6','LEADER',NULL,'2025-10-29 15:09:40','2025-10-29 15:09:40'),('2368e4b7-b53c-11f0-972a-002248f7ec11',NULL,'관리자','admin@example.com','12341234','ADMIN',NULL,'2025-10-30 02:57:14','2025-10-30 02:57:14'),('870c0d3b-2dd8-456c-84ac-8b434c36e54f',1,'김이장','leaderkim@leader.com','$2a$10$fCW42LtCRUBUpxYI4J/2OuEjDMxwJVCkLPOhaZ42mKFwCv1.1jHpS','LEADER',NULL,'2025-10-29 14:12:40','2025-10-29 05:14:24'),('f229bd00-6c7c-44bd-b35e-9647d51d3947',3,'김테스트','test123@test.com','$2a$10$WO8kIl.hwILDUdyv6RMfJez58ju6aWuMm98oyXbk1iI/3CCnlTSua','USER',NULL,'2025-10-29 12:02:52','2025-10-31 16:27:34');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-11-18 17:14:09
