<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use App\Models\User;
use App\Models\Mitra;

/**
 * Seeder to create dummy accounts for development / testing.
 *
 * It creates:
 *   - a customer account (username: customer@example.com, password: customer123)
 *   - a mitra (merchant) account (username: mitra@example.com, password: mitra123)
 *
 * The passwords are hashed using Laravel's default bcrypt hasher.
 */
class DummyUserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Create a dummy customer
        $customer = User::create([
            'nama'     => 'Customer Dummy',
            'email'    => 'customer@example.com',
            'phone'    => '1111111111',
            'password' => Hash::make('customer123'),
            'role'     => 'customer',
            'status'   => 'active',
        ]);

        // Create a dummy mitra (merchant) user
        $mitraUser = User::create([
            'nama'     => 'Mitra Dummy',
            'email'    => 'mitra@example.com',
            'phone'    => '2222222222',
            'password' => Hash::make('mitra123'),
            'role'     => 'mitra',
            'status'   => 'active',
        ]);

        // Link the mitra user to the mitra table with minimal required fields
        Mitra::create([
            'user_id'        => $mitraUser->id,
            'nama_toko'      => 'Toko Dummy',
            'alamat'         => 'Jl. Contoh No.1',
            // optional fields left null / default
        ]);
    }
}
