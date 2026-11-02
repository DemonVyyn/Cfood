-- ============================================================
-- ITEM 3 (Pemisahan Database Account)  +  ITEM 5 (Least Privilege)
-- Jalankan sebagai root MySQL:
--   mysql -u root -p < database/01_pemisahan_dan_least_privilege.sql
-- ============================================================

-- 1. Database terpisah untuk aplikasi
CREATE DATABASE IF NOT EXISTS cfood
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 2. Account khusus aplikasi (BUKAN root)
CREATE USER IF NOT EXISTS 'cfood_app'@'localhost'
  IDENTIFIED BY 'CfoodApp2026!';

-- 3. Account khusus backup (hanya butuh baca)
CREATE USER IF NOT EXISTS 'cfood_backup'@'localhost'
  IDENTIFIED BY 'cfoodBackup123!';

-- 4. Least privilege: aplikasi hanya boleh DML, tidak boleh DDL
GRANT SELECT, INSERT, UPDATE, DELETE
  ON cfood.* TO 'cfood_app'@'localhost';

-- 5. Backup hanya boleh SELECT + LOCK TABLES
GRANT SELECT, LOCK TABLES, SHOW VIEW
  ON cfood.* TO 'cfood_backup'@'localhost';

FLUSH PRIVILEGES;

-- 6. BUKTI untuk item 5
SHOW GRANTS FOR 'cfood_app'@'localhost';
SHOW GRANTS FOR 'cfood_backup'@'localhost';

-- 7. Bukti bahwa account aplikasi TIDAK punya hak DDL
--    (harus gagal dengan ERROR 1142)
-- CREATE TABLE cfood.test_ddl (id INT);   -- jalankan manual sbg cfood_app
