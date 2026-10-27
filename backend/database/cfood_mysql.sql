-- ============================================================================
-- Skema MySQL/MariaDB untuk aplikasi Cfood
-- Dihasilkan dari migrasi Laravel (database/database.sqlite)
-- Charset: utf8mb4 | Engine: InnoDB
-- ============================================================================

SET FOREIGN_KEY_CHECKS = 0;
SET NAMES utf8mb4;
SET TIME_ZONE = '+00:00';

-- ----------------------------------------------------------------------------
-- users
-- ----------------------------------------------------------------------------
CREATE TABLE `users` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nama` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `phone` VARCHAR(255) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `role` ENUM('customer','mitra','admin') NOT NULL DEFAULT 'customer',
  `status` ENUM('active','suspended') NOT NULL DEFAULT 'active',
  `foto_profil` VARCHAR(255) NULL DEFAULT NULL,
  `last_login` TIMESTAMP NULL DEFAULT NULL,
  `remember_token` VARCHAR(100) NULL DEFAULT NULL,
  `created_at` TIMESTAMP NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`),
  UNIQUE KEY `users_phone_unique` (`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- mitra
-- ----------------------------------------------------------------------------
CREATE TABLE `mitra` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `nama_toko` VARCHAR(255) NOT NULL,
  `deskripsi_toko` TEXT NULL DEFAULT NULL,
  `alamat` VARCHAR(255) NOT NULL,
  `latitude` DECIMAL(10,7) NULL DEFAULT NULL,
  `longitude` DECIMAL(10,7) NULL DEFAULT NULL,
  `nomor_telepon` VARCHAR(255) NULL DEFAULT NULL,
  `foto_toko` VARCHAR(255) NULL DEFAULT NULL,
  `status_verifikasi` ENUM('pending','verified','rejected') NOT NULL DEFAULT 'pending',
  `created_at` TIMESTAMP NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `mitra_user_id_foreign` (`user_id`),
  CONSTRAINT `mitra_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- menu
-- ----------------------------------------------------------------------------
CREATE TABLE `menu` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `mitra_id` BIGINT UNSIGNED NOT NULL,
  `nama` VARCHAR(255) NOT NULL,
  `deskripsi` TEXT NULL DEFAULT NULL,
  `kategori` VARCHAR(255) NULL DEFAULT NULL,
  `foto` VARCHAR(255) NULL DEFAULT NULL,
  `harga_original` DECIMAL(12,2) NOT NULL,
  `harga_diskon` DECIMAL(12,2) NOT NULL,
  `stok` INT NOT NULL DEFAULT 0,
  `waktu_expired` TIMESTAMP NOT NULL,
  `status` ENUM('aktif','habis','expired') NOT NULL DEFAULT 'aktif',
  `created_at` TIMESTAMP NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `menu_mitra_id_foreign` (`mitra_id`),
  CONSTRAINT `menu_mitra_id_foreign` FOREIGN KEY (`mitra_id`) REFERENCES `mitra` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- pesanan
-- ----------------------------------------------------------------------------
CREATE TABLE `pesanan` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `customer_id` BIGINT UNSIGNED NOT NULL,
  `mitra_id` BIGINT UNSIGNED NOT NULL,
  `total_harga` DECIMAL(12,2) NOT NULL,
  `kode_pengambilan` VARCHAR(20) NOT NULL,
  `waktu_pengambilan` TIMESTAMP NULL DEFAULT NULL,
  `order_status` ENUM('menunggu_pembayaran','dibayar','diproses','siap_diambil','selesai','dibatalkan') NOT NULL DEFAULT 'menunggu_pembayaran',
  `created_at` TIMESTAMP NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `pesanan_kode_pengambilan_unique` (`kode_pengambilan`),
  KEY `pesanan_customer_id_foreign` (`customer_id`),
  KEY `pesanan_mitra_id_foreign` (`mitra_id`),
  CONSTRAINT `pesanan_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `pesanan_mitra_id_foreign` FOREIGN KEY (`mitra_id`) REFERENCES `mitra` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- barang_pesanan
-- ----------------------------------------------------------------------------
CREATE TABLE `barang_pesanan` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `pesanan_id` BIGINT UNSIGNED NOT NULL,
  `menu_id` BIGINT UNSIGNED NOT NULL,
  `jumlah` INT NOT NULL,
  `harga` DECIMAL(12,2) NOT NULL,
  `subtotal` DECIMAL(12,2) NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `barang_pesanan_pesanan_id_foreign` (`pesanan_id`),
  KEY `barang_pesanan_menu_id_foreign` (`menu_id`),
  CONSTRAINT `barang_pesanan_pesanan_id_foreign` FOREIGN KEY (`pesanan_id`) REFERENCES `pesanan` (`id`) ON DELETE CASCADE,
  CONSTRAINT `barang_pesanan_menu_id_foreign` FOREIGN KEY (`menu_id`) REFERENCES `menu` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- pembayaran
-- ----------------------------------------------------------------------------
CREATE TABLE `pembayaran` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `pesanan_id` BIGINT UNSIGNED NOT NULL,
  `kode_transaksi` VARCHAR(255) NOT NULL,
  `nominal` DECIMAL(12,2) NOT NULL,
  `metode_pembayaran` ENUM('qris','gopay','ovo','dana','bank_transfer','cash') NOT NULL,
  `status_pembayaran` ENUM('pending','paid','failed','refunded') NOT NULL DEFAULT 'pending',
  `waktu_pembayaran` TIMESTAMP NULL DEFAULT NULL,
  `waktu_refund` TIMESTAMP NULL DEFAULT NULL,
  `created_at` TIMESTAMP NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `pembayaran_kode_transaksi_unique` (`kode_transaksi`),
  KEY `pembayaran_pesanan_id_foreign` (`pesanan_id`),
  CONSTRAINT `pembayaran_pesanan_id_foreign` FOREIGN KEY (`pesanan_id`) REFERENCES `pesanan` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- notifikasi
-- ----------------------------------------------------------------------------
CREATE TABLE `notifikasi` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `judul` VARCHAR(255) NOT NULL,
  `pesan` TEXT NOT NULL,
  `is_read` TINYINT(1) NOT NULL DEFAULT 0,
  `read_at` TIMESTAMP NULL DEFAULT NULL,
  `created_at` TIMESTAMP NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `notifikasi_user_id_foreign` (`user_id`),
  CONSTRAINT `notifikasi_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- personal_access_tokens
-- ----------------------------------------------------------------------------
CREATE TABLE `personal_access_tokens` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `tokenable_type` VARCHAR(255) NOT NULL,
  `tokenable_id` BIGINT UNSIGNED NOT NULL,
  `name` TEXT NOT NULL,
  `token` VARCHAR(64) NOT NULL,
  `abilities` TEXT NULL DEFAULT NULL,
  `last_used_at` TIMESTAMP NULL DEFAULT NULL,
  `expires_at` TIMESTAMP NULL DEFAULT NULL,
  `created_at` TIMESTAMP NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- cache
-- ----------------------------------------------------------------------------
CREATE TABLE `cache` (
  `key` VARCHAR(255) NOT NULL,
  `value` MEDIUMTEXT NOT NULL,
  `expiration` BIGINT NOT NULL,
  PRIMARY KEY (`key`),
  KEY `cache_expiration_index` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- cache_locks
-- ----------------------------------------------------------------------------
CREATE TABLE `cache_locks` (
  `key` VARCHAR(255) NOT NULL,
  `owner` VARCHAR(255) NOT NULL,
  `expiration` BIGINT NOT NULL,
  PRIMARY KEY (`key`),
  KEY `cache_locks_expiration_index` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- jobs
-- ----------------------------------------------------------------------------
CREATE TABLE `jobs` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `queue` VARCHAR(255) NOT NULL,
  `payload` LONGTEXT NOT NULL,
  `attempts` SMALLINT UNSIGNED NOT NULL,
  `reserved_at` INT UNSIGNED NULL DEFAULT NULL,
  `available_at` INT UNSIGNED NOT NULL,
  `created_at` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- job_batches
-- ----------------------------------------------------------------------------
CREATE TABLE `job_batches` (
  `id` VARCHAR(255) NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `total_jobs` INT NOT NULL,
  `pending_jobs` INT NOT NULL,
  `failed_jobs` INT NOT NULL,
  `failed_job_ids` LONGTEXT NOT NULL,
  `options` MEDIUMTEXT NULL DEFAULT NULL,
  `cancelled_at` INT NULL DEFAULT NULL,
  `created_at` INT NOT NULL,
  `finished_at` INT NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------------------------------------------------------
-- failed_jobs
-- ----------------------------------------------------------------------------
CREATE TABLE `failed_jobs` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `uuid` VARCHAR(255) NOT NULL,
  `connection` VARCHAR(255) NOT NULL,
  `queue` VARCHAR(255) NOT NULL,
  `payload` LONGTEXT NOT NULL,
  `exception` LONGTEXT NOT NULL,
  `failed_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`),
  KEY `failed_jobs_connection_queue_failed_at_index` (`connection`,`queue`,`failed_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
-- Tabel `barang_pesanan`: kosong (0 baris)
-- Tabel `cache`: kosong (0 baris)
-- Tabel `cache_locks`: kosong (0 baris)
-- Tabel `failed_jobs`: kosong (0 baris)
-- Tabel `job_batches`: kosong (0 baris)
-- Tabel `jobs`: kosong (0 baris)
-- Tabel `menu`: kosong (0 baris)

-- Tabel `mitra`: 3 baris
INSERT INTO `mitra` (`id`, `user_id`, `nama_toko`, `deskripsi_toko`, `alamat`, `latitude`, `longitude`, `nomor_telepon`, `foto_toko`, `status_verifikasi`, `created_at`, `updated_at`) VALUES
(1, 8, 'Bakery Bahagia', 'Menjual roti, pastry, dan bakery surplus berkualitas.', 'eyJpdiI6ImpteXhESDBGTGxwQlFaRWZveTRtMmc9PSIsInZhbHVlIjoiS0tseVdob2dZelYxR0txbHZqUmFWdz09IiwibWFjIjoiZGNjOTk0ZTY0YjMzNWUyMTk4NDgxOTFhZGIzMzk1NzVkZmNiNGY1MjQwMzIwMDBmNTYyZDhmNjE5M2Y4MzEzNiIsInRhZyI6IiJ9', 1.13, 104.05, 'eyJpdiI6IkdLaHg4dlZ2cERyZGZMRUdCVEk4S0E9PSIsInZhbHVlIjoiZW1MaUVGL1NHOXVRNlkzWi9sTXpsdz09IiwibWFjIjoiMDJlNTFjZTk5ZjNjOWRkOWJkYzBjYzhkZjRiYzkxZjRlZjUzNDYxM2QxOWMyOWMyMjdjZWRmZjQ3YjAzMGVkNyIsInRhZyI6IiJ9', NULL, 'verified', '2026-10-16 07:34:20', '2026-10-16 07:34:20'),
(2, 9, 'Coffee Corner', 'Menyediakan kopi, snack, dan makanan ringan surplus.', 'eyJpdiI6ImFkL3llWnBCczB5SjlCME9idGNPY1E9PSIsInZhbHVlIjoiMHdpTUdxNU5qZjdGS2kvZ09VU1ByZz09IiwibWFjIjoiZGY5M2EzODc5Nzg1ZWZlMDkwZjA3N2UxMGNhOTkwYTkwNTgxODAxZDExMGE5ZmM0ZmQxYjFiZjc2MjE0YmM1NyIsInRhZyI6IiJ9', 1.145, 104.012, 'eyJpdiI6IkNkTFNsajErRFBYMzhOckRuNVI5TFE9PSIsInZhbHVlIjoiQzhTaHB5TWVOTExnSVlkSlZIb3FpZz09IiwibWFjIjoiZjk3NTM0MDNmOTBlMWZlNzMzYmQ1YmM1NGEwMTU2YzZmYzcyY2M3YjM4MDA0ZjNkNzI4MTNiMTYyZDMxNmE4NyIsInRhZyI6IiJ9', NULL, 'verified', '2026-10-16 07:34:20', '2026-10-16 07:34:20'),
(3, 10, 'Hotel Harmoni', 'Buffet hotel dan makanan siap saji surplus.', 'eyJpdiI6InRhSXJ5cVRrU3JrZ1hRYXhMc3J6Snc9PSIsInZhbHVlIjoiRlpabGc1QUNUTkJBZWdUcm1qTUNGdz09IiwibWFjIjoiOTcxMGEyOWFhNzliYjVjODM4YjcyYTMwNWQwNTE4ZDRmODdmNDVkMjBmYWViZmI4NDJjOGQ5YmM4M2Y1MGY0NCIsInRhZyI6IiJ9', 1.11, 104.06, 'eyJpdiI6ImdmU1pjeUU5RzJWUEdhbkdMbnUycnc9PSIsInZhbHVlIjoieDBiOEZtRTNYa0hwL2hIa0pIbGo3dz09IiwibWFjIjoiMzdhN2ViMzk3M2NiOWM4YjExMzMxNTg3MTE0MjIwN2M5OGQxNzBlZmQ3MzIyNDdjZjdhZTQ0ODA4ZjkxMDk1YiIsInRhZyI6IiJ9', NULL, 'verified', '2026-10-16 07:34:20', '2026-10-16 07:34:20');
-- Tabel `notifikasi`: kosong (0 baris)
-- Tabel `pembayaran`: kosong (0 baris)

-- Tabel `personal_access_tokens`: 8 baris
INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(1, 'App\\Models\\User', 1, 'mobile-token', '077225e0f7e465a4aa3c43c8897760dc9f8f8f51ca2f28caa62228806befddde', '[\"*\"]', NULL, NULL, '2026-10-03 11:24:59', '2026-10-03 11:24:59'),
(2, 'App\\Models\\User', 4, 'mobile-token', 'd62034ba7ff0233b28845a3eff27c7fcf3533a82ced658f45daff304c5827a50', '[\"*\"]', '2026-10-16 11:15:30', NULL, '2026-10-16 07:37:40', '2026-10-16 11:15:30'),
(3, 'App\\Models\\User', 4, 'mobile-token', 'a9248de9a4a403ec0e7314887131cad07b7e6ab001b8e9efb197181a441e3214', '[\"*\"]', '2026-10-16 11:27:08', NULL, '2026-10-16 11:17:51', '2026-10-16 11:27:08'),
(4, 'App\\Models\\User', 4, 'mobile-token', '2f21e4d62734440829e3f6028fa75d6a84e229f36eccf00920f86d481bbd1029', '[\"*\"]', NULL, NULL, '2026-10-16 11:29:29', '2026-10-16 11:29:29'),
(5, 'App\\Models\\User', 4, 'mobile-token', 'e46d8262aeb38b9c4ca9ac065e44381c41f6af0ad4c452d0ed7c8c527b7a5847', '[\"*\"]', '2026-10-16 12:14:54', NULL, '2026-10-16 11:32:18', '2026-10-16 12:14:54'),
(6, 'App\\Models\\User', 4, 'mobile-token', 'daed21bab659e72e2b3e153deffee3fb1cf9ab6bd76020c77b05ff06fad758ba', '[\"*\"]', '2026-10-16 12:50:01', NULL, '2026-10-16 12:18:38', '2026-10-16 12:50:01'),
(7, 'App\\Models\\User', 5, 'mobile-token', '000fa25cd94f64d5245b6d7aa29ae241ff512169ea24e33546f4076e122565f1', '[\"*\"]', '2026-10-16 13:26:33', NULL, '2026-10-16 12:52:18', '2026-10-16 13:26:33'),
(13, 'App\\Models\\User', 4, 'mobile-token', 'fb9f7c08586624f7890d7293d5c410b06b5a248dc3dac61bb41010f55cfe38ca', '[\"*\"]', NULL, NULL, '2026-10-17 09:46:33', '2026-10-17 09:46:33');
-- Tabel `pesanan`: kosong (0 baris)

-- Tabel `users`: 10 baris
INSERT INTO `users` (`id`, `nama`, `email`, `phone`, `password`, `role`, `status`, `foto_profil`, `last_login`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, '1', '1@gmail.com', '1', '$2y$12$aobEqB218D.B.BQCMHwmFOehB8DOyCAtDyAlecW4AtN0Q9dD.qKby', 'customer', 'active', NULL, '2026-10-03 11:24:59', NULL, '2026-10-03 11:24:49', '2026-10-03 11:24:59'),
(2, 'Admin Mealio', 'admin@mealio.com', '081111111111', '$2y$12$m1iuwwXMyLObsbmgglFV0.znaeDW2bVnNOJKowu7v5ei77/KIgz2W', 'admin', 'active', NULL, NULL, NULL, '2026-10-16 07:34:16', '2026-10-16 07:34:16'),
(3, 'Avnes Pratama', 'avnes@gmail.com', '082222222222', '$2y$12$y7SB0cYvlVjubtnpC4bg0.kfpuVK9Sc/2u/H/Te3w9.z098eCqP8G', 'customer', 'active', NULL, NULL, NULL, '2026-10-16 07:34:17', '2026-10-16 07:46:28'),
(4, 'Muhammad Arifin', 'arifin@gmail.com', '083333333333', '$2y$12$SyTBMJ/aodSRBGmBw9TW7urynIaIn9OOBjN9gZknvlyE8TM/Lqj7u', 'customer', 'active', NULL, '2026-10-17 09:46:33', NULL, '2026-10-16 07:34:18', '2026-10-17 09:46:33'),
(5, 'Muhammad Risky', 'risky@gmail.com', '088888888888', '$2y$12$Co35fQUEY3zhkN2NbyMsau9SjKn9UKI2ckZxaq8iJEVo7eshzKGaG', 'customer', 'active', NULL, '2026-10-16 12:52:18', NULL, '2026-10-16 07:34:18', '2026-10-16 12:52:18'),
(6, 'Muhammad Radja', 'radja@gmail.com', '089999999999', '$2y$12$yZZqj0QBv9WFn/mbMSXvBuRZ60k.jI4hmonzby7MewrfQ9wp7T/ea', 'customer', 'active', NULL, NULL, NULL, '2026-10-16 07:34:18', '2026-10-16 07:46:29'),
(7, 'Naila Putri', 'naila@gmail.com', '089999999990', '$2y$12$.0Fy52fpLkcZ/YQsLymHA.1u9N.iZGYGP41SLCeZKDkeSu/sG4Pxi', 'customer', 'active', NULL, NULL, NULL, '2026-10-16 07:34:19', '2026-10-16 07:46:29'),
(8, 'Bakery Bahagia', 'bakery@gmail.com', '084444444444', '$2y$12$gpSvPgJkLW32qfh2T/jSpuWyQeIUl/gUWREWsNfwHqnIXLVmLovs.', 'mitra', 'active', NULL, '2026-10-17 08:31:22', NULL, '2026-10-16 07:34:19', '2026-10-17 08:31:22'),
(9, 'Coffee Corner', 'coffee@gmail.com', '085555555555', '$2y$12$GT8SgF430jA9CjUWG2H6IOGlkVpWDvvi2GIMPnxzFOoznuzmh4Fsu', 'mitra', 'active', NULL, NULL, NULL, '2026-10-16 07:34:20', '2026-10-17 08:29:44'),
(10, 'Hotel Harmoni', 'hotel@gmail.com', '086666666666', '$2y$12$MhlOgonIQYRUuHYjk66CyuISl/HLty1rJjhdDEmFm/nzNx1VXSNT.', 'mitra', 'active', NULL, NULL, NULL, '2026-10-16 07:34:20', '2026-10-17 08:29:44');

-- Total baris diekspor: 21
SET FOREIGN_KEY_CHECKS = 1;
