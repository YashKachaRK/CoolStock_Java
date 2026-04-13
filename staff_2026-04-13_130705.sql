CREATE TABLE `staff` (
  `id` int NOT NULL AUTO_INCREMENT,
  `staff_key` varchar(50) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `role` varchar(50) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `joined_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `staff_key` (`staff_key`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;insert into `staff` (`email`, `full_name`, `id`, `is_active`, `joined_date`, `password_hash`, `phone`, `role`, `staff_key`) values ('amit@coolstock.in', 'Amit Sharma', 1, 1, '2026-04-10 13:26:03', '$2a$10$8.UnVuG9HHgffUDAlk8KnO2yfGUuU.A9/y.uN/qP1yZ.y.y.y.y.y', '9800111111', 'Manager', 'STAFF-1');
insert into `staff` (`email`, `full_name`, `id`, `is_active`, `joined_date`, `password_hash`, `phone`, `role`, `staff_key`) values ('priya@coolstock.in', 'Priya Patel', 2, 1, '2026-04-10 13:26:03', '$2a$10$8.UnVuG9HHgffUDAlk8KnO2yfGUuU.A9/y.uN/qP1yZ.y.y.y.y.y', '9800133333', 'Cashier', 'STAFF-2');
insert into `staff` (`email`, `full_name`, `id`, `is_active`, `joined_date`, `password_hash`, `phone`, `role`, `staff_key`) values ('neha@coolstock.in', 'Neha Singh', 3, 1, '2026-04-10 13:26:03', '$2a$10$8.UnVuG9HHgffUDAlk8KnO2yfGUuU.A9/y.uN/qP1yZ.y.y.y.y.y', '9800122222', 'Delivery', 'STAFF-3');
insert into `staff` (`email`, `full_name`, `id`, `is_active`, `joined_date`, `password_hash`, `phone`, `role`, `staff_key`) values ('rohit@coolstock.in', 'Rohit Das', 4, 1, '2026-04-10 13:26:03', '$2a$10$8.UnVuG9HHgffUDAlk8KnO2yfGUuU.A9/y.uN/qP1yZ.y.y.y.y.y', '9800144444', 'Delivery', 'STAFF-4');
insert into `staff` (`email`, `full_name`, `id`, `is_active`, `joined_date`, `password_hash`, `phone`, `role`, `staff_key`) values ('arjun@coolstock.in', 'Arjun Mehta', 5, 1, '2026-04-10 13:26:03', '$2a$10$8.UnVuG9HHgffUDAlk8KnO2yfGUuU.A9/y.uN/qP1yZ.y.y.y.y.y', '9800155555', 'Delivery', 'STAFF-5');
insert into `staff` (`email`, `full_name`, `id`, `is_active`, `joined_date`, `password_hash`, `phone`, `role`, `staff_key`) values ('ykacha243@rku.ac.in', 'Yash', 6, 1, '2026-04-10 13:26:51', '$2a$10$wtdB.tM90QYWdolNMYPVMOtuUt6ZXl81STyaJcqNgTW.CnTJmmmmS', '78630 69413', 'Manager', 'STAFF-1775807811082');
insert into `staff` (`email`, `full_name`, `id`, `is_active`, `joined_date`, `password_hash`, `phone`, `role`, `staff_key`) values ('admin@coolstock.in', 'Master Admin', 7, 1, '2026-04-10 15:52:18', '$2a$10$8.UnVuG9HHgffUDAlk8KnO2yfGUuU.A9/y.uN/qP1yZ.y.y.y.y.y', '9500000000', 'Admin', 'ADMIN-001');
insert into `staff` (`email`, `full_name`, `id`, `is_active`, `joined_date`, `password_hash`, `phone`, `role`, `staff_key`) values ('admin@gmail.in', 'System Admin', 9, 1, '2026-04-10 15:54:02', '$2a$10$8.UnVuG9HHgffUDAlk8KnO2yfGUuU.A9/y.uN/qP1yZ.y.y.y.y.y', '9998887776', 'Admin', 'ADMIN-MASTER');
insert into `staff` (`email`, `full_name`, `id`, `is_active`, `joined_date`, `password_hash`, `phone`, `role`, `staff_key`) values ('gracy@gmail.com', 'Gracy', 10, 1, '2026-04-10 15:58:25', '$2a$10$nFolis5JVUyZjup/s0jLeOF0OvSnL.QMOpajBzfhVV5jxhvyqLqWS', '7866069413', 'Delivery', 'STAFF-1775816905421');
insert into `staff` (`email`, `full_name`, `id`, `is_active`, `joined_date`, `password_hash`, `phone`, `role`, `staff_key`) values ('r@gmail.com', 'Rutvik', 11, 1, '2026-04-11 11:47:23', '$2a$10$Zn7xaY81/aUGKDqFeDC9wuE1XjqcKvmHm/DDkiJHl4sUw2kpPcyge', '78788 78788', 'Cashier', 'STAFF-1775888243256');
