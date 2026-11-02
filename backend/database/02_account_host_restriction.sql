-- ============================================================
-- ITEM 7 (Account dan Host Restriction)
-- Jalankan sebagai root:
--   mysql -u root -p < database/02_account_host_restriction.sql
-- ============================================================

-- 1. Inventarisasi account dan host asalnya  --> BUKTI
SELECT user, host, account_locked, plugin
FROM mysql.user
ORDER BY user, host;

-- 2. Temuan: account anonymous / tanpa password  --> BUKTI
SELECT user, host FROM mysql.user
WHERE user = '' OR (plugin = '' AND authentication_string = '');

-- 3. Hapus account anonymous (jika ada)
DELETE FROM mysql.user WHERE user = '';

-- 4. Hapus account 'root' yang boleh diakses dari host jauh
DELETE FROM mysql.user WHERE user = 'root' AND host NOT IN ('localhost','127.0.0.1','::1');

-- 5. Batasi host account aplikasi HANYA localhost
--    (hapus varian wildcard '%' bila pernah dibuat)
DELETE FROM mysql.user WHERE user = 'cfood_app' AND host NOT IN ('localhost');

-- 6. Kunci account yang tidak dipakai  --> tindakan mitigasi
-- ALTER USER 'cfood_old'@'%' ACCOUNT LOCK;

FLUSH PRIVILEGES;

-- 7. Hasil akhir setelah peninjauan  --> BUKTI
SELECT user, host FROM mysql.user ORDER BY user, host;
