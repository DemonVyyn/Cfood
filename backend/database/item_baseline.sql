-- ============================================================
-- ITEM 8 — SECURITY BASELINE MYSQL
-- Checklist: "Checklist dengan status Comply / Partially Comply /
--             Not Comply / N/A."
--
-- SEMUA NILAI DIHITUNG DARI SISTEM (bukan diketik manual).
-- Dijalankan SATU KALI lewat mysql> sebagai root (Laragon: tanpa password),
-- karena membaca katalog mysql.db / mysql.user. Ini AUDIT SERVER, bukan
-- koneksi aplikasi -> .env tetap cfood_app (item 3 tidak dilanggar).
--
-- Cara: mysql -u root
--       mysql> source C:/.../database/item_baseline.sql
--
-- PENTING: ini BASELINE = kondisi SEBELUM item 9 (VIEW) dan item 16
-- (audit trail) dikerjakan. Munculnya "Not Comply" pada B09/B10 adalah
-- TEMUAN AWAL yang wajar, bukan kesalahan. Akan di-retest di ITEM 20.
-- ============================================================

SELECT kode, kontrol, temuan, status, catatan
FROM (
  SELECT 'B01' AS kode, 'Data Asset Inventory' AS kontrol,
    (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='cfood') AS temuan,
    CASE WHEN (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='cfood') >= 8
         THEN 'Comply' ELSE 'Not Comply' END AS status,
    'tabel terinventarisasi pada database cfood' AS catatan

  UNION ALL SELECT 'B02', 'Pemisahan Database Account',
    (SELECT COUNT(*) FROM mysql.user WHERE user LIKE 'cfood%'),
    CASE WHEN (SELECT COUNT(*) FROM mysql.user WHERE user LIKE 'cfood%') >= 3
         THEN 'Comply' ELSE 'Not Comply' END,
    'admin / app / backup harus terpisah'

  UNION ALL SELECT 'B03', 'Least Privilege akun aplikasi',
    (SELECT COUNT(*) FROM mysql.db WHERE db='cfood' AND user='cfood_app'
       AND create_priv='N' AND alter_priv='N' AND drop_priv='N' AND grant_priv='N'),
    CASE WHEN (SELECT COUNT(*) FROM mysql.db WHERE db='cfood' AND user='cfood_app'
       AND create_priv='N' AND alter_priv='N' AND drop_priv='N' AND grant_priv='N') = 1
         THEN 'Comply' ELSE 'Not Comply' END,
    'tanpa CREATE / ALTER / DROP / GRANT'

  UNION ALL SELECT 'B04', 'Password tidak plaintext',
    (SELECT COUNT(*) FROM cfood.users WHERE password NOT LIKE '$2y$%'),
    CASE WHEN (SELECT COUNT(*) FROM cfood.users) = 0 THEN 'N/A'
         WHEN (SELECT COUNT(*) FROM cfood.users WHERE password NOT LIKE '$2y$%') = 0
         THEN 'Comply' ELSE 'Not Comply' END,
    'seluruh password berawalan $2y$ (bcrypt)'

  UNION ALL SELECT 'B05', 'Unique constraint identitas',
    (SELECT COUNT(DISTINCT index_name) FROM information_schema.statistics
      WHERE table_schema='cfood' AND table_name='users' AND non_unique=0),
    CASE WHEN (SELECT COUNT(DISTINCT index_name) FROM information_schema.statistics
      WHERE table_schema='cfood' AND table_name='users' AND non_unique=0) >= 2
         THEN 'Comply' ELSE 'Not Comply' END,
    'PRIMARY + unique email / phone'

  UNION ALL SELECT 'B06', 'Autentikasi token',
    (SELECT COUNT(*) FROM cfood.personal_access_tokens),
    CASE WHEN (SELECT COUNT(*) FROM cfood.personal_access_tokens) = 0 THEN 'N/A'
         WHEN (SELECT MIN(LENGTH(token)) FROM cfood.personal_access_tokens) = 64
         THEN 'Comply' ELSE 'Not Comply' END,
    'token tersimpan sebagai hash 64 karakter'

  UNION ALL SELECT 'B07', 'Kode pengambilan unik',
    (SELECT COUNT(*) FROM cfood.pesanan),
    CASE WHEN (SELECT COUNT(*) FROM cfood.pesanan) = 0 THEN 'N/A'
         WHEN (SELECT COUNT(*) FROM (SELECT kode_pengambilan FROM cfood.pesanan
               GROUP BY kode_pengambilan HAVING COUNT(*)>1) AS d) = 0
         THEN 'Comply' ELSE 'Not Comply' END,
    'N/A bila belum ada transaksi'

  UNION ALL SELECT 'B08', 'Enkripsi data sensitif',
    (SELECT COUNT(*) FROM cfood.mitra),
    CASE WHEN (SELECT COUNT(*) FROM cfood.mitra) = 0 THEN 'N/A'
         WHEN (SELECT SUM(CASE WHEN alamat LIKE 'eyJpdiI6%' THEN 1 ELSE 0 END)
               FROM cfood.mitra) = (SELECT COUNT(*) FROM cfood.mitra)
         THEN 'Comply' ELSE 'Not Comply' END,
    'alamat mitra tersimpan sebagai ciphertext'

  UNION ALL SELECT 'B09', 'Audit trail tersedia',
    (SELECT COUNT(*) FROM information_schema.tables
      WHERE table_schema='cfood' AND table_name='activity_log'),
    CASE WHEN (SELECT COUNT(*) FROM information_schema.tables
      WHERE table_schema='cfood' AND table_name='activity_log') = 1
         THEN 'Comply' ELSE 'Not Comply' END,
    'TEMUAN AWAL -> direncanakan pada ITEM 16'

  UNION ALL SELECT 'B10', 'View pembatasan data',
    (SELECT COUNT(*) FROM information_schema.views WHERE table_schema='cfood'),
    CASE WHEN (SELECT COUNT(*) FROM information_schema.views WHERE table_schema='cfood') >= 1
         THEN 'Comply' ELSE 'Not Comply' END,
    'TEMUAN AWAL -> direncanakan pada ITEM 9'
) AS baseline
ORDER BY kode;

-- ---------- REKAP STATUS ----------
-- Ulangi blok di atas bila ingin rekap terpisah, atau cukup hitung manual
-- dari 10 baris yang tampil: Comply / N/A / Not Comply.
SELECT 'REKAP' AS keterangan,
       'Tulis jumlah per status dari tabel di atas ke BAB II item 8.' AS catatan,
       'Not Comply pada B09/B10 = temuan awal, diretest pada ITEM 20.' AS catatan2;
