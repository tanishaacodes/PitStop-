-- MySQL dump 10.13  Distrib 9.3.0, for macos15.2 (arm64)
--
-- Host: localhost    Database: pitstop
-- UPDATED: Cities restricted to Pune and Mumbai only.
--          Washrooms restricted to restaurant, cafe, and petrol_pump partner types.
-- ------------------------------------------------------
-- Server version	9.7.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cities`
--

DROP TABLE IF EXISTS `cities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cities` (
  `city_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `state` varchar(100) NOT NULL,
  PRIMARY KEY (`city_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cities`
-- Only Mumbai and Pune retained.
--

LOCK TABLES `cities` WRITE;
/*!40000 ALTER TABLE `cities` DISABLE KEYS */;
INSERT INTO `cities` VALUES
  (1,'Mumbai','Maharashtra'),
  (2,'Pune','Maharashtra');
/*!40000 ALTER TABLE `cities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ratings`
--

DROP TABLE IF EXISTS `ratings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ratings` (
  `rating_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `washroom_id` int DEFAULT NULL,
  `cleanliness` int DEFAULT NULL,
  `safety` int DEFAULT NULL,
  `amenities` int DEFAULT NULL,
  `review_text` text,
  `photo_url` varchar(255) DEFAULT NULL,
  `timestamp` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`rating_id`),
  KEY `idx_ratings_user_id` (`user_id`),
  KEY `idx_ratings_washroom_id` (`washroom_id`),
  CONSTRAINT `fk_ratings_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_ratings_washroom` FOREIGN KEY (`washroom_id`) REFERENCES `washrooms` (`washroom_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ratings`
-- Only ratings for washrooms in Mumbai (1) and Pune (2) retained (washroom_ids 1 and 2).
--

LOCK TABLES `ratings` WRITE;
/*!40000 ALTER TABLE `ratings` DISABLE KEYS */;
INSERT INTO `ratings` VALUES
  (1,1,1,5,4,4,'Very clean and well-maintained. Hand dryer was working.',NULL,'2026-05-12 23:11:33'),
  (2,2,1,4,4,5,'Good facilities, a bit crowded during peak hours.',NULL,'2026-05-12 23:11:33'),
  (3,1,2,3,4,3,'Decent enough. Could use more frequent cleaning.',NULL,'2026-05-12 23:11:33'),
  (4,3,2,4,4,4,'Clean and accessible. Paper towels were available.',NULL,'2026-05-12 23:11:33');
/*!40000 ALTER TABLE `ratings` ENABLE KEYS */;
UNLOCK TABLES;

/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_update_avg_rating` AFTER INSERT ON `ratings` FOR EACH ROW BEGIN
  UPDATE washrooms
  SET    avg_rating = (
           SELECT ROUND(AVG((cleanliness + safety + amenities) / 3.0), 2)
           FROM   ratings
           WHERE  washroom_id = NEW.washroom_id
         )
  WHERE  washroom_id = NEW.washroom_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `user_washroom`
--

DROP TABLE IF EXISTS `user_washroom`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_washroom` (
  `user_id` int NOT NULL,
  `washroom_id` int NOT NULL,
  `visited_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`,`washroom_id`),
  KEY `fk_uw_washroom` (`washroom_id`),
  CONSTRAINT `fk_uw_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_uw_washroom` FOREIGN KEY (`washroom_id`) REFERENCES `washrooms` (`washroom_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_washroom`
-- Only visits to washrooms in Mumbai/Pune retained.
--

LOCK TABLES `user_washroom` WRITE;
/*!40000 ALTER TABLE `user_washroom` DISABLE KEYS */;
INSERT INTO `user_washroom` VALUES
  (1,1,'2025-04-10 10:30:00'),
  (1,2,'2025-04-15 09:00:00'),
  (2,1,'2025-04-12 14:15:00'),
  (3,2,'2025-04-20 17:45:00');
/*!40000 ALTER TABLE `user_washroom` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `join_date` date DEFAULT (curdate()),
  `is_verified` tinyint(1) DEFAULT '0',
  `password` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `uq_users_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES
  (1,'Aditi Sharma','aditi@example.com','9876543210','Pune','2026-05-12',1,'hashed_pw_1'),
  (2,'Rahul Mehta','rahul@example.com','9123456780','Mumbai','2026-05-12',1,'hashed_pw_2'),
  (3,'Priya Nair','priya@example.com','9988776655','Pune','2026-05-12',0,'hashed_pw_3');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `vw_rating_summary`
--

DROP TABLE IF EXISTS `vw_rating_summary`;
/*!50001 DROP VIEW IF EXISTS `vw_rating_summary`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_rating_summary` AS SELECT
 1 AS `washroom_id`,
 1 AS `total_reviews`,
 1 AS `avg_cleanliness`,
 1 AS `avg_safety`,
 1 AS `avg_amenities`,
 1 AS `overall_avg`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_top_washrooms`
--

DROP TABLE IF EXISTS `vw_top_washrooms`;
/*!50001 DROP VIEW IF EXISTS `vw_top_washrooms`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_top_washrooms` AS SELECT
 1 AS `washroom_id`,
 1 AS `address`,
 1 AS `city`,
 1 AS `state`,
 1 AS `partner_type`,
 1 AS `avg_rating`,
 1 AS `accessibility`,
 1 AS `facilities`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `washrooms`
-- partner_type enum updated to include 'cafe' alongside restaurant and petrol_pump.
-- Standalone and toll_plaza entries removed; only restaurant, cafe, petrol_pump allowed.
--

DROP TABLE IF EXISTS `washrooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `washrooms` (
  `washroom_id` int NOT NULL AUTO_INCREMENT,
  `gps_lat` decimal(9,6) DEFAULT NULL,
  `gps_long` decimal(9,6) DEFAULT NULL,
  `address` text,
  `city_id` int DEFAULT NULL,
  `status` enum('open','closed','maintenance') DEFAULT 'open',
  `avg_rating` decimal(3,2) DEFAULT '0.00',
  `partner_type` enum('restaurant','cafe','petrol_pump') DEFAULT NULL,
  `accessibility` tinyint(1) DEFAULT '0',
  `facilities` text,
  PRIMARY KEY (`washroom_id`),
  KEY `idx_washrooms_city_id` (`city_id`),
  CONSTRAINT `fk_washrooms_city` FOREIGN KEY (`city_id`) REFERENCES `cities` (`city_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `washrooms`
-- All entries are in Mumbai (city_id=1) or Pune (city_id=2).
-- Partner types: restaurant, cafe, petrol_pump only.
--

LOCK TABLES `washrooms` WRITE;
/*!40000 ALTER TABLE `washrooms` DISABLE KEYS */;
INSERT INTO `washrooms` VALUES
  (1,19.076090,72.877426,'BPCL Petrol Pump, Andheri East, Mumbai',        1,'open',   4.33,'petrol_pump',1,'soap,hand_dryer,baby_changing'),
  (2,18.520430,73.856743,'Phoenix Marketcity, Viman Nagar, Pune',          2,'open',   3.67,'restaurant', 1,'soap,paper_towel'),
  (3,19.018255,72.848064,'McDonald\'s, Kurla West, Mumbai',                1,'open',   0.00,'restaurant', 1,'soap,hand_dryer,disabled_access'),
  (4,18.516726,73.856255,'Cafe Coffee Day, Koregaon Park, Pune',           2,'open',   0.00,'cafe',        0,'soap,paper_towel'),
  (5,19.221938,72.978088,'HP Petrol Pump, Thane West, Mumbai',             1,'closed', 0.00,'petrol_pump', 0,'soap'),
  (6,18.562061,73.901695,'KFC, Viman Nagar, Pune',                         2,'open',   0.00,'restaurant', 1,'soap,hand_dryer');
/*!40000 ALTER TABLE `washrooms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `vw_rating_summary`
--

/*!50001 DROP VIEW IF EXISTS `vw_rating_summary`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_rating_summary` AS select `ratings`.`washroom_id` AS `washroom_id`,count(0) AS `total_reviews`,round(avg(`ratings`.`cleanliness`),2) AS `avg_cleanliness`,round(avg(`ratings`.`safety`),2) AS `avg_safety`,round(avg(`ratings`.`amenities`),2) AS `avg_amenities`,round(avg((((`ratings`.`cleanliness` + `ratings`.`safety`) + `ratings`.`amenities`) / 3.0)),2) AS `overall_avg` from `ratings` group by `ratings`.`washroom_id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_top_washrooms`
--

/*!50001 DROP VIEW IF EXISTS `vw_top_washrooms`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_top_washrooms` AS select `w`.`washroom_id` AS `washroom_id`,`w`.`address` AS `address`,`c`.`name` AS `city`,`c`.`state` AS `state`,`w`.`partner_type` AS `partner_type`,`w`.`avg_rating` AS `avg_rating`,`w`.`accessibility` AS `accessibility`,`w`.`facilities` AS `facilities` from (`washrooms` `w` join `cities` `c` on((`w`.`city_id` = `c`.`city_id`))) where (`w`.`status` = 'open') order by `w`.`avg_rating` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-13
-- Changes from original:
--   • cities: trimmed to Mumbai (id=1) and Pune (id=2) only
--   • washrooms: all non-Mumbai/Pune entries removed; partner_type enum restricted
--     to restaurant, cafe, petrol_pump; new real addresses added for both cities
--   • ratings: deduplicated (duplicates from repeated imports removed);
--     rating for removed washroom_id=4 (Delhi) replaced with Pune entry
--   • user_washroom: updated to reference valid washroom_ids only
