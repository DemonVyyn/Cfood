<?php

/**
 * Script enkripsi data sensitif mitra (nomor_telepon & alamat).
 * Jalankan SEKALI setelah menambahkan encrypted cast di model Mitra.
 * Aman dijalankan ulang (tidak akan dobel-enkripsi).
 *
 * Cara pakai (dari folder backend): php enkripsi_data_mitra.php
 */

require __DIR__ . '/vendor/autoload.php';

$app = require_once __DIR__ . '/bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;

function sudahTerenkripsi($nilai)
{
    try {
        Crypt::decryptString($nilai);
        return true;
    } catch (\Throwable $e) {
        return false;
    }
}

$rows = DB::table('mitra')->get();

if ($rows->isEmpty()) {
    echo "Tidak ada data mitra.\n";
    exit(0);
}

foreach ($rows as $row) {
    $update = [];

    if (! empty($row->nomor_telepon) && ! sudahTerenkripsi($row->nomor_telepon)) {
        $update['nomor_telepon'] = Crypt::encryptString($row->nomor_telepon);
    }

    if (! empty($row->alamat) && ! sudahTerenkripsi($row->alamat)) {
        $update['alamat'] = Crypt::encryptString($row->alamat);
    }

    if (empty($update)) {
        echo "Mitra ID {$row->id}: sudah terenkripsi, dilewati.\n";
        continue;
    }

    DB::table('mitra')->where('id', $row->id)->update($update);
    echo "Mitra ID {$row->id}: nomor_telepon & alamat berhasil dienkripsi.\n";
}

// Verifikasi: baca kembali via model (cast otomatis mendekripsi)
echo "\nVerifikasi dekripsi via model:\n";
foreach (App\Models\Mitra::all() as $mitra) {
    echo "Mitra ID {$mitra->id} | Toko: {$mitra->nama_toko} "
        . "| Telepon: {$mitra->nomor_telepon} | Alamat: {$mitra->alamat}\n";
}

echo "\nSelesai.\n";