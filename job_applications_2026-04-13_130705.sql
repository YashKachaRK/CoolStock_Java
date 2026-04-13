CREATE TABLE `job_applications` (
  `id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(150) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `role` varchar(100) NOT NULL,
  `cover_letter` text,
  `status` enum('PENDING','REVIEWED','ACCEPTED','REJECTED') DEFAULT 'PENDING',
  `applied_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;insert into `job_applications` (`applied_at`, `cover_letter`, `email`, `full_name`, `id`, `phone`, `role`, `status`) values ('2026-04-07 10:30:04', 'I want job ', 'ykacha243@rku.ac.in', 'YASH KACHA', 1, '78630 69413', 'Manager', 'ACCEPTED');
insert into `job_applications` (`applied_at`, `cover_letter`, `email`, `full_name`, `id`, `phone`, `role`, `status`) values ('2026-04-13 10:30:33', 'Good', 'rutvik@gmail.com', 'Rutvik ', 2, '1212121212', 'Manager', 'REJECTED');
insert into `job_applications` (`applied_at`, `cover_letter`, `email`, `full_name`, `id`, `phone`, `role`, `status`) values ('2026-04-13 12:48:03', '', 'rutvik@gmail.com', 'Rutvik ', 3, '12121212', 'Manager', 'PENDING');
insert into `job_applications` (`applied_at`, `cover_letter`, `email`, `full_name`, `id`, `phone`, `role`, `status`) values ('2026-04-13 12:48:44', '', 'rutvik@gmailcom', 'Rutvik ', 4, '1212121212', 'Cashier / POS Operator', 'PENDING');
