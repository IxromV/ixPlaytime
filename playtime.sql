
CREATE TABLE `playtime` (
  `identifier` varchar(80) NOT NULL,
  `value` int(80) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

ALTER TABLE `playtime`
  ADD PRIMARY KEY (`identifier`);
COMMIT;

ALTER TABLE `users` ADD  `playtime` int(11) NOT NULL DEFAULT 0;