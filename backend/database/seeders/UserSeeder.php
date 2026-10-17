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
        User::firstOrCreate(
            ['email' => 'admin@mealio.com'],
            [
                'nama' => 'Admin Mealio',
                'phone' => '081111111111',
                'password' => Hash::make('password'),
                'role' => 'admin',
                'status' => 'active',
            ]
        );

        User::firstOrCreate(
            ['email' => 'avnes@gmail.com'],
            [
                'nama' => 'Avnes Pratama',
                'phone' => '082222222222',
                'password' => Hash::make('password'),
                'role' => 'customer',
                'status' => 'active',
            ]
        );

        User::firstOrCreate(
            ['email' => 'arifin@gmail.com'],
            [
                'nama' => 'Muhammad Arifin',
                'phone' => '083333333333',
                'password' => Hash::make('arifin123'),
                'role' => 'customer',
                'status' => 'active',
            ]
        );

        User::firstOrCreate(
            ['email' => 'risky@gmail.com'],
            [
                'nama' => 'Muhammad Risky',
                'phone' => '088888888888',
                'password' => Hash::make('risky123'),
                'role' => 'customer',
                'status' => 'active',
            ]
        );

        User::firstOrCreate(
            ['email' => 'radja@gmail.com'],
            [
                'nama' => 'Muhammad Radja',
                'phone' => '089999999999',
                'password' => Hash::make('radja123'),
                'role' => 'customer',
                'status' => 'active',
            ]
        );

        User::firstOrCreate(
            ['email' => 'naila@gmail.com'],
            [
                'nama' => 'Naila Putri',
                'phone' => '089999999990',
                'password' => Hash::make('naila123'),
                'role' => 'customer',
                'status' => 'active',
            ]
        );

        $mitra1 = User::firstOrCreate(
            ['email' => 'bakery@gmail.com'],
            [
                'nama' => 'Bakery Bahagia',
                'phone' => '084444444444',
                'password' => Hash::make('password'),
                'role' => 'mitra',
                'status' => 'active',
            ]
        );

        $mitra2 = User::firstOrCreate(
            ['email' => 'coffee@gmail.com'],
            [
                'nama' => 'Coffee Corner',
                'phone' => '085555555555',
                'password' => Hash::make('password'),
                'role' => 'mitra',
                'status' => 'active',
            ]
        );

        $mitra3 = User::firstOrCreate(
            ['email' => 'hotel@gmail.com'],
            [
                'nama' => 'Hotel Harmoni',
                'phone' => '086666666666',
                'password' => Hash::make('password'),
                'role' => 'mitra',
                'status' => 'active',
            ]
        );

        Mitra::firstOrCreate(
            ['user_id' => $mitra1->id],
            [
                'nama_toko' => 'Bakery Bahagia',
                'deskripsi_toko' =>
                    'Menjual roti, pastry, dan bakery surplus berkualitas.',
                'alamat' => 'Batam Center',
                'latitude' => 1.1300000,
                'longitude' => 104.0500000,
                'nomor_telepon' => '084444444444',
                'status_verifikasi' => 'verified',
            ]
        );

        Mitra::firstOrCreate(
            ['user_id' => $mitra2->id],
            [
                'nama_toko' => 'Coffee Corner',
                'deskripsi_toko' =>
                    'Menyediakan kopi, snack, dan makanan ringan surplus.',
                'alamat' => 'Nagoya',
                'latitude' => 1.1450000,
                'longitude' => 104.0120000,
                'nomor_telepon' => '085555555555',
                'status_verifikasi' => 'verified',
            ]
        );

        Mitra::firstOrCreate(
            ['user_id' => $mitra3->id],
            [
                'nama_toko' => 'Hotel Harmoni',
                'deskripsi_toko' =>
                    'Buffet hotel dan makanan siap saji surplus.',
                'alamat' => 'Batam Kota',
                'latitude' => 1.1100000,
                'longitude' => 104.0600000,
                'nomor_telepon' => '086666666666',
                'status_verifikasi' => 'verified',
            ]
        );
    }
}
