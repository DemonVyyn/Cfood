-- ============================================================
-- ITEM 9 (Pembatasan Data dengan VIEW)
-- Jalankan sebagai root:
--   mysql -u root -p cfood < database/03_pembatasan_data_view.sql
-- ============================================================

-- VIEW publik: hanya kolom yang dibutuhkan pembeli.
-- Kolom sensitif yang disembunyikan: harga_original (strategi harga internal)
CREATE OR REPLACE VIEW v_menu_publik AS
SELECT
    m.id,
    m.nama,
    m.deskripsi,
    m.kategori,
    m.harga_diskon,
    m.stok,
    m.waktu_expired,
    m.status,
    m.mitra_id,
    t.nama_toko
FROM menu m
LEFT JOIN mitra t ON t.id = m.mitra_id
WHERE m.status = 'aktif';

-- VIEW ringkas pesanan untuk mitra: menyembunyikan data pribadi customer
-- (email dan phone tidak ikut, hanya nama)
CREATE OR REPLACE VIEW v_pesanan_mitra AS
SELECT
    p.id,
    p.mitra_id,
    u.nama      AS nama_customer,
    p.total_harga,
    p.kode_pengambilan,
    p.order_status,
    p.created_at
FROM pesanan p
JOIN users u ON u.id = p.customer_id;

-- ===================== BUKTI =====================
-- 1. Struktur view
SHOW CREATE VIEW v_menu_publik;
SHOW CREATE VIEW v_pesanan_mitra;

-- 2. Akses lewat view: kolom sensitif TIDAK muncul
SELECT * FROM v_menu_publik LIMIT 5;

-- 3. Pembuktian pembatasan: kolom ini TIDAK ADA di view
--    (harus gagal dengan ERROR 1054 Unknown column)
-- SELECT harga_original FROM v_menu_publik;   -- jalankan manual

-- 4. Bandingkan dengan tabel asal (semua kolom tampil)
SELECT * FROM menu LIMIT 5;
