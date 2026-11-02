-- ============================================================
-- ITEM 3 — PEMISAHAN DATABASE ACCOUNT (Administrator vs Aplikasi)
-- Setelah file ini dijalankan, `root` TIDAK dipakai lagi dalam proyek.
-- Cara jalankan:  mysql -u root < database\01b_item03_admin_terpisah.sql
-- ============================================================

CREATE USER IF NOT EXISTS 'cfood_admin'@'localhost'
  IDENTIFIED WITH mysql_native_password BY 'CfoodAdmin2026';

-- CREATE USER IF NOT EXISTS tidak mengganti password akun yang sudah ada
ALTER USER 'cfood_admin'@'localhost'
  IDENTIFIED WITH mysql_native_password BY 'CfoodAdmin2026';

-- Kalau Laragon Anda MariaDB, ganti dua baris di atas dengan:
--   ALTER USER 'cfood_admin'@'localhost'
--     IDENTIFIED VIA mysql_native_password USING PASSWORD('CfoodAdmin2026');

GRANT SELECT, INSERT, UPDATE, DELETE,
      CREATE, ALTER, DROP, INDEX, REFERENCES,
      CREATE VIEW, SHOW VIEW, LOCK TABLES
  ON cfood.* TO 'cfood_admin'@'localhost';

FLUSH PRIVILEGES;

-- ===== EVIDENCE ITEM 3 =====
SHOW GRANTS FOR 'cfood_admin'@'localhost';
SHOW GRANTS FOR 'cfood_app'@'localhost';
SHOW GRANTS FOR 'cfood_backup'@'localhost';

SELECT user, host, plugin FROM mysql.user
WHERE user LIKE 'cfood%' ORDER BY user;