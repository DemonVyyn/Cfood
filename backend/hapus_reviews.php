<?php

/**
 * Script untuk menghapus tabel `reviews` dari database SQLite.
 *
 * Tabel reviews tidak digunakan oleh aplikasi (tidak ada controller/seeder
 * yang memakainya), jadi aman dihapus. Data pada tabel lain tidak tersentuh.
 *
 * Cara pakai (dari folder backend):
 *   php hapus_reviews.php
 *
 * PENTING: backup dulu file database/database.sqlite sebelum menjalankan.
 */

$dbPath = __DIR__ . '/database/database.sqlite';

if (!file_exists($dbPath)) {
    fwrite(STDERR, "Database tidak ditemukan: {$dbPath}\n");
    exit(1);
}

$db = new PDO("sqlite:{$dbPath}");
$db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

// Cek apakah tabel reviews ada
$exists = $db->query(
    "SELECT name FROM sqlite_master WHERE type='table' AND name='reviews'"
)->fetchColumn();

if (!$exists) {
    echo "Tabel reviews tidak ada di database (mungkin sudah dihapus).\n";
    exit(0);
}

// Tampilkan jumlah baris sebelum dihapus sebagai informasi
$count = $db->query("SELECT COUNT(*) FROM reviews")->fetchColumn();
echo "Tabel reviews ditemukan dengan {$count} baris.\n";

// Hapus tabel
$db->exec('DROP TABLE "reviews"');

echo "Tabel reviews berhasil dihapus.\n";
