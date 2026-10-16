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
        User::create([
            'nama' => 'Admin Mealio',
            'email' => 'admin@mealio.com',
            'phone' => '081111111111',
            'password' => Hash::make('password'),
            'role' => 'admin',
            'status' => 'active',
        ]);

        User::create([
            'nama' => 'Avnes Pratama',
            'email' => 'avnes@mail.com',
            'phone' => '082222222222',
            'password' => Hash::make('password'),
            'role' => 'customer',
            'status' => 'active',
        ]);

        User::create([
            'nama' => 'Raisya Putri',
            'email' => 'raisya@mail.com',
            'phone' => '083333333333',
            'password' => Hash::make('password'),
            'role' => 'customer',
            'status' => 'active',
        ]);

        $mitra1 = User::create([
            'nama' => 'Bakery Bahagia',
            'email' => 'bakery@mail.com',
            'phone' => '084444444444',
            'password' => Hash::make('password'),
            'role' => 'mitra',
            'status' => 'active',
        ]);

        $mitra2 = User::create([
            'nama' => 'Coffee Corner',
            'email' => 'coffee@mail.com',
            'phone' => '085555555555',
            'password' => Hash::make('password'),
            'role' => 'mitra',
            'status' => 'active',
        ]);

        $mitra3 = User::create([
            'nama' => 'Hotel Harmoni',
            'email' => 'hotel@mail.com',
            'phone' => '086666666666',
            'password' => Hash::make('password'),
            'role' => 'mitra',
            'status' => 'active',
        ]);

        Mitra::create([
            'user_id' => $mitra1->id,
            'nama_toko' => 'Bakery Bahagia',
            'deskripsi_toko' =>
                'Menjual roti, pastry, dan bakery surplus berkualitas.',
            'alamat' => 'Batam Center',
            'latitude' => 1.1300000,
            'longitude' => 104.0500000,
            'nomor_telepon' => '084444444444',
            'status_verifikasi' => 'verified',
        ]);

        Mitra::create([
            'user_id' => $mitra2->id,
            'nama_toko' => 'Coffee Corner',
            'deskripsi_toko' =>
                'Menyediakan kopi, snack, dan makanan ringan surplus.',
            'alamat' => 'Nagoya',
            'latitude' => 1.1450000,
            'longitude' => 104.0120000,
            'nomor_telepon' => '085555555555',
            'status_verifikasi' => 'verified',
        ]);

        Mitra::create([
            'user_id' => $mitra3->id,
            'nama_toko' => 'Hotel Harmoni',
            'deskripsi_toko' =>
                'Buffet hotel dan makanan siap saji surplus.',
            'alamat' => 'Batam Kota',
            'latitude' => 1.1100000,
            'longitude' => 104.0600000,
            'nomor_telepon' => '086666666666',
            'status_verifikasi' => 'verified',
        ]);
    }
}