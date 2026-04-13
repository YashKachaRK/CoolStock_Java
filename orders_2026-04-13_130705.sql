CREATE TABLE `orders` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_number` varchar(50) NOT NULL,
  `customer_id` int NOT NULL,
  `delivery_boy_id` int DEFAULT NULL,
  `order_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `total_amount` decimal(12,2) NOT NULL,
  `status` varchar(50) DEFAULT 'Processing',
  `delivery_priority` varchar(50) DEFAULT 'Regular',
  `payment_status` varchar(50) DEFAULT 'Unpaid',
  `cashier_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `order_number` (`order_number`),
  KEY `customer_id` (`customer_id`),
  KEY `delivery_boy_id` (`delivery_boy_id`),
  KEY `fk_cashier` (`cashier_id`),
  CONSTRAINT `fk_cashier` FOREIGN KEY (`cashier_id`) REFERENCES `staff` (`id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`),
  CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`delivery_boy_id`) REFERENCES `staff` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;insert into `orders` (`cashier_id`, `customer_id`, `delivery_boy_id`, `delivery_priority`, `id`, `order_date`, `order_number`, `payment_status`, `status`, `total_amount`) values (NULL, 1, 3, 'Regular', 1, '2026-03-01 10:30:00', 'ORD-10001', 'Unpaid', 'Delivered', '4500.00');
insert into `orders` (`cashier_id`, `customer_id`, `delivery_boy_id`, `delivery_priority`, `id`, `order_date`, `order_number`, `payment_status`, `status`, `total_amount`) values (NULL, 2, 4, 'Regular', 2, '2026-03-05 14:15:00', 'ORD-10002', 'Unpaid', 'Shipped', '1600.00');
insert into `orders` (`cashier_id`, `customer_id`, `delivery_boy_id`, `delivery_priority`, `id`, `order_date`, `order_number`, `payment_status`, `status`, `total_amount`) values (NULL, 1, 3, 'Regular', 3, '2026-03-08 09:45:00', 'ORD-10003', 'Unpaid', 'Shipped', '8400.00');
insert into `orders` (`cashier_id`, `customer_id`, `delivery_boy_id`, `delivery_priority`, `id`, `order_date`, `order_number`, `payment_status`, `status`, `total_amount`) values (NULL, 5, 4, 'Regular', 4, '2026-04-10 14:06:33', 'ORD-1775810193250', 'Unpaid', 'Shipped', '50.00');
insert into `orders` (`cashier_id`, `customer_id`, `delivery_boy_id`, `delivery_priority`, `id`, `order_date`, `order_number`, `payment_status`, `status`, `total_amount`) values (NULL, 5, 5, 'Very Urgent', 5, '2026-04-10 14:07:57', 'ORD-1775810277518', 'Unpaid', 'Shipped', '1250.00');
insert into `orders` (`cashier_id`, `customer_id`, `delivery_boy_id`, `delivery_priority`, `id`, `order_date`, `order_number`, `payment_status`, `status`, `total_amount`) values (NULL, 5, 10, 'Regular', 6, '2026-04-10 15:58:47', 'ORD-1775816927810', 'Unpaid', 'Delivered', '90.00');
insert into `orders` (`cashier_id`, `customer_id`, `delivery_boy_id`, `delivery_priority`, `id`, `order_date`, `order_number`, `payment_status`, `status`, `total_amount`) values (NULL, 5, 10, 'Regular', 7, '2026-04-11 11:44:25', 'ORD-1775888065277', 'Pending Deposit', 'Delivered', '300.00');
insert into `orders` (`cashier_id`, `customer_id`, `delivery_boy_id`, `delivery_priority`, `id`, `order_date`, `order_number`, `payment_status`, `status`, `total_amount`) values (11, 5, 10, 'Regular', 8, '2026-04-11 11:59:04', 'ORD-1775888944222', 'Paid', 'Delivered', '150.00');
insert into `orders` (`cashier_id`, `customer_id`, `delivery_boy_id`, `delivery_priority`, `id`, `order_date`, `order_number`, `payment_status`, `status`, `total_amount`) values (11, 5, 10, 'Regular', 9, '2026-04-11 12:00:22', 'ORD-1775889022967', 'Paid', 'Delivered', '30.00');
insert into `orders` (`cashier_id`, `customer_id`, `delivery_boy_id`, `delivery_priority`, `id`, `order_date`, `order_number`, `payment_status`, `status`, `total_amount`) values (11, 5, 10, 'Regular', 10, '2026-04-11 12:04:23', 'ORD-1775889263377', 'Paid', 'Delivered', '600.00');
insert into `orders` (`cashier_id`, `customer_id`, `delivery_boy_id`, `delivery_priority`, `id`, `order_date`, `order_number`, `payment_status`, `status`, `total_amount`) values (11, 5, 10, 'Regular', 11, '2026-04-11 12:18:12', 'ORD-1775890092831', 'Paid', 'Delivered', '30.00');
insert into `orders` (`cashier_id`, `customer_id`, `delivery_boy_id`, `delivery_priority`, `id`, `order_date`, `order_number`, `payment_status`, `status`, `total_amount`) values (11, 5, 10, 'Urgent', 12, '2026-04-13 10:25:38', 'ORD-1776056138621', 'Paid', 'Delivered', '230.00');
insert into `orders` (`cashier_id`, `customer_id`, `delivery_boy_id`, `delivery_priority`, `id`, `order_date`, `order_number`, `payment_status`, `status`, `total_amount`) values (NULL, 5, NULL, 'Urgent', 13, '2026-04-13 10:40:49', 'ORD-1776057049921', 'Unpaid', 'Processing', '450.00');
