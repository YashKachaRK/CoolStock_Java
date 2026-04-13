CREATE TABLE `customers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `customer_key` varchar(50) NOT NULL,
  `shop_name` varchar(100) NOT NULL,
  `owner_name` varchar(100) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `city` varchar(50) NOT NULL,
  `area` varchar(100) DEFAULT NULL,
  `password_hash` varchar(255) NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `joined_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `total_spend` decimal(12,2) DEFAULT '0.00',
  PRIMARY KEY (`id`),
  UNIQUE KEY `customer_key` (`customer_key`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;insert into `customers` (`area`, `city`, `customer_key`, `email`, `id`, `is_active`, `joined_date`, `owner_name`, `password_hash`, `phone`, `shop_name`, `total_spend`) values ('Kalawad Road', 'Rajkot', 'CUST-1', 'krishna@retail.com', 1, 1, '2026-04-10 13:26:03', 'Rajesh Bhai', '$2a$10$8.UnVuG9HHgffUDAlk8KnO2yfGUuU.A9/y.uN/qP1yZ.y.y.y.y.y', '9900112233', 'Krishna Dairy', '0.00');
insert into `customers` (`area`, `city`, `customer_key`, `email`, `id`, `is_active`, `joined_date`, `owner_name`, `password_hash`, `phone`, `shop_name`, `total_spend`) values ('SG Highway', 'Ahmedabad', 'CUST-2', 'shreeji@retail.com', 2, 1, '2026-04-10 13:26:03', 'Suresh Patel', '$2a$10$8.UnVuG9HHgffUDAlk8KnO2yfGUuU.A9/y.uN/qP1yZ.y.y.y.y.y', '9900445566', 'Shreeji Icecream', '0.00');
insert into `customers` (`area`, `city`, `customer_key`, `email`, `id`, `is_active`, `joined_date`, `owner_name`, `password_hash`, `phone`, `shop_name`, `total_spend`) values ('Adajan', 'Surat', 'CUST-3', 'modern@retail.com', 3, 1, '2026-04-10 13:26:03', 'Anjali Shah', '$2a$10$8.UnVuG9HHgffUDAlk8KnO2yfGUuU.A9/y.uN/qP1yZ.y.y.y.y.y', '9900778899', 'Modern Mart', '0.00');
insert into `customers` (`area`, `city`, `customer_key`, `email`, `id`, `is_active`, `joined_date`, `owner_name`, `password_hash`, `phone`, `shop_name`, `total_spend`) values ('Alkapuri', 'Vadodara', 'CUST-4', 'quality@retail.com', 4, 1, '2026-04-10 13:26:03', 'Vijay Mehta', '$2a$10$8.UnVuG9HHgffUDAlk8KnO2yfGUuU.A9/y.uN/qP1yZ.y.y.y.y.y', '9900223344', 'Quality Sweets', '0.00');
insert into `customers` (`area`, `city`, `customer_key`, `email`, `id`, `is_active`, `joined_date`, `owner_name`, `password_hash`, `phone`, `shop_name`, `total_spend`) values ('Naroda', 'Ahmedabad', 'CUST-1775808970690', 'ykacha@gamil.com', 5, 1, '2026-04-10 13:46:10', 'Yash ', '$2a$10$0f5TRvlcv.m0OaN.tlI8Oeklqz9sry2dSpmoZxR3epFhqKVpSVrDG', '7866069413', 'Shree', '260.00');
