<?php

/**
 * Script untuk menampilkan daftar semua tabel di database SQLite.
 * Berguna untuk verifikasi sebelum/sesudah menghapus tabel.
 *
 * Cara pakai (dari folder backend):
 *   php cek_tabel.php
 */

$dbPath = __DIR__ . '/database/database.sqlite';

if (!file_exists($dbPath)) {
    fwrite(STDERR, "Database tidak ditemukan: {$dbPath}\n");
    exit(1);
}

$db = new PDO("sqlite:{$dbPath}");
$db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

$tables = $db->query(
    "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name"
)->fetchAll(PDO::FETCH_COLUMN);

echo "Tabel di SQLite (" . count($tables) . "):\n";
foreach ($tables as $table) {
    echo "  - {$table}\n";
}
