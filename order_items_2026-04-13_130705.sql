CREATE TABLE `order_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int NOT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  `total_price` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;insert into `order_items` (`id`, `order_id`, `product_id`, `quantity`, `total_price`, `unit_price`) values (1, 1, 1, 30, '3600.00', '120.00');
insert into `order_items` (`id`, `order_id`, `product_id`, `quantity`, `total_price`, `unit_price`) values (2, 1, 2, 60, '900.00', '15.00');
insert into `order_items` (`id`, `order_id`, `product_id`, `quantity`, `total_price`, `unit_price`) values (3, 2, 2, 40, '1600.00', '40.00');
insert into `order_items` (`id`, `order_id`, `product_id`, `quantity`, `total_price`, `unit_price`) values (4, 3, 1, 24, '2880.00', '120.00');
insert into `order_items` (`id`, `order_id`, `product_id`, `quantity`, `total_price`, `unit_price`) values (5, 3, 2, 50, '2000.00', '40.00');
insert into `order_items` (`id`, `order_id`, `product_id`, `quantity`, `total_price`, `unit_price`) values (6, 4, 3, 2, '50.00', '25.00');
insert into `order_items` (`id`, `order_id`, `product_id`, `quantity`, `total_price`, `unit_price`) values (7, 5, 1, 5, '600.00', '120.00');
insert into `order_items` (`id`, `order_id`, `product_id`, `quantity`, `total_price`, `unit_price`) values (8, 5, 2, 10, '400.00', '40.00');
insert into `order_items` (`id`, `order_id`, `product_id`, `quantity`, `total_price`, `unit_price`) values (9, 5, 3, 10, '250.00', '25.00');
insert into `order_items` (`id`, `order_id`, `product_id`, `quantity`, `total_price`, `unit_price`) values (10, 6, 3, 3, '90.00', '30.00');
insert into `order_items` (`id`, `order_id`, `product_id`, `quantity`, `total_price`, `unit_price`) values (11, 7, 3, 10, '300.00', '30.00');
insert into `order_items` (`id`, `order_id`, `product_id`, `quantity`, `total_price`, `unit_price`) values (12, 8, 1, 1, '120.00', '120.00');
insert into `order_items` (`id`, `order_id`, `product_id`, `quantity`, `total_price`, `unit_price`) values (13, 8, 3, 1, '30.00', '30.00');
insert into `order_items` (`id`, `order_id`, `product_id`, `quantity`, `total_price`, `unit_price`) values (14, 9, 3, 1, '30.00', '30.00');
insert into `order_items` (`id`, `order_id`, `product_id`, `quantity`, `total_price`, `unit_price`) values (15, 10, 3, 20, '600.00', '30.00');
insert into `order_items` (`id`, `order_id`, `product_id`, `quantity`, `total_price`, `unit_price`) values (16, 11, 3, 1, '30.00', '30.00');
insert into `order_items` (`id`, `order_id`, `product_id`, `quantity`, `total_price`, `unit_price`) values (17, 12, 2, 2, '80.00', '40.00');
insert into `order_items` (`id`, `order_id`, `product_id`, `quantity`, `total_price`, `unit_price`) values (18, 12, 3, 5, '150.00', '30.00');
insert into `order_items` (`id`, `order_id`, `product_id`, `quantity`, `total_price`, `unit_price`) values (19, 13, 1, 2, '240.00', '120.00');
insert into `order_items` (`id`, `order_id`, `product_id`, `quantity`, `total_price`, `unit_price`) values (20, 13, 2, 3, '120.00', '40.00');
insert into `order_items` (`id`, `order_id`, `product_id`, `quantity`, `total_price`, `unit_price`) values (21, 13, 3, 3, '90.00', '30.00');
