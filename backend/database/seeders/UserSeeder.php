<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\Mitra;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class UserSeeder extends Seeder
{
    public function run(): void
    {
        // CUSTOMER
        User::updateOrCreate(
            ['email' => 's@gmail.com'],
            [
                'nama' => 'S Customer',
                'phone' => '081111111111',
                'password' => Hash::make('tama1234'),
                'role' => 'customer',
                'status' => 'active',
            ]
        );

        // MITRA
        $mitra = User::updateOrCreate(
            ['email' => 'a@gmail.com'],
            [
                'nama' => 'A Mitra',
                'phone' => '082222222222',
                'password' => Hash::make('tama1234'),
                'role' => 'mitra',
                'status' => 'active',
            ]
        );

        // DATA PROFIL MITRA
        Mitra::updateOrCreate(
            ['user_id' => $mitra->id],
            [
                'nama_toko' => 'Mitra CFood',
                'deskripsi_toko' => 'Mitra penjual makanan surplus untuk mengurangi food waste.',
                'alamat' => 'Batam Center',
                'latitude' => 1.1300000,
                'longitude' => 104.0500000,
                'nomor_telepon' => '082222222222',
                'status_verifikasi' => 'verified',
            ]
        );

        // ADMIN
        User::updateOrCreate(
            ['email' => 'd@gmail.com'],
            [
                'nama' => 'D Admin',
                'phone' => '083333333333',
                'password' => Hash::make('tama1234'),
                'role' => 'admin',
                'status' => 'active',
            ]
        );
    }
}
