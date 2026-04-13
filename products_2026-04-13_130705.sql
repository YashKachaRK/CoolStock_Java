CREATE TABLE `products` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_code` varchar(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `category` varchar(50) NOT NULL,
  `flavor` varchar(50) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `stock` int NOT NULL DEFAULT '0',
  `pcs_per_box` int NOT NULL DEFAULT '1',
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `product_code` (`product_code`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;insert into `products` (`category`, `created_at`, `description`, `flavor`, `id`, `is_active`, `name`, `pcs_per_box`, `price`, `product_code`, `stock`) values ('Tubs', '2026-04-10 13:26:03', 'Classic creamy vanilla in wholesale 1kg tubs.', 'Vanilla', 1, 1, 'Vanilla Paradise Tub', 6, '120.00', 'PROD-101', 442);
insert into `products` (`category`, `created_at`, `description`, `flavor`, `id`, `is_active`, `name`, `pcs_per_box`, `price`, `product_code`, `stock`) values ('Cones', '2026-04-10 13:26:03', 'Dark chocolate cone - bestseller in retail shops.', 'Chocolate', 2, 1, 'Rich Chocolate Cone', 24, '40.00', 'PROD-102', 1185);
insert into `products` (`category`, `created_at`, `description`, `flavor`, `id`, `is_active`, `name`, `pcs_per_box`, `price`, `product_code`, `stock`) values ('Sticks', '2026-04-10 13:26:03', 'Seasonal real mango stick, kids favorite.', 'Mango', 3, 1, 'Mango Magic Stick', 30, '30.00', 'PROD-103', 169);
insert into `products` (`category`, `created_at`, `description`, `flavor`, `id`, `is_active`, `name`, `pcs_per_box`, `price`, `product_code`, `stock`) values ('Cones', '2026-04-10 15:32:15', 'Mango ', 'Mango', 4, 0, 'Mango Magic Stick', 1, '120.00', 'PROD-1775815335977', 1200);
