<?php

namespace Database\Seeders;

use App\Models\Menu;
use App\Models\Mitra;
use Illuminate\Database\Seeder;

class MenuSeeder extends Seeder
{
    public function run(): void
    {
        $mitra = Mitra::all();

        $products = [

            [
                'nama' => 'Mystery Bread Box',
                'harga_original' => 50000,
                'harga_diskon' => 25000,
            ],
            [
                'nama' => 'Mystery Pastry Box',
                'harga_original' => 60000,
                'harga_diskon' => 30000,
            ],
            [
                'nama' => 'Mystery Croissant Box',
                'harga_original' => 55000,
                'harga_diskon' => 28000,
            ],
            [
                'nama' => 'Mystery Cake Slice Box',
                'harga_original' => 70000,
                'harga_diskon' => 35000,
            ],
            [
                'nama' => 'Mystery Donut Box',
                'harga_original' => 45000,
                'harga_diskon' => 22000,
            ],
            [
                'nama' => 'Mystery Coffee Combo',
                'harga_original' => 50000,
                'harga_diskon' => 25000,
            ],
            [
                'nama' => 'Mystery Sandwich Box',
                'harga_original' => 65000,
                'harga_diskon' => 32000,
            ],
            [
                'nama' => 'Mystery Hotel Buffet Box',
                'harga_original' => 90000,
                'harga_diskon' => 45000,
            ],
            [
                'nama' => 'Mystery Rice Box',
                'harga_original' => 40000,
                'harga_diskon' => 20000,
            ],
            [
                'nama' => 'Mystery Dessert Box',
                'harga_original' => 80000,
                'harga_diskon' => 39000,
            ],
        ];

        foreach ($products as $index => $item) {

            Menu::create([
                'mitra_id' =>
                    $mitra[$index % 3]->id,

                'nama' =>
                    $item['nama'],

                'deskripsi' =>
                    'Paket makanan surplus berkualitas yang masih layak konsumsi.',

                'kategori' =>
                    'Mystery Box',

                'foto' =>
                    'https://picsum.photos/400/300',

                'harga_original' =>
                    $item['harga_original'],

                'harga_diskon' =>
                    $item['harga_diskon'],

                'stok' =>
                    rand(3, 15),

                'waktu_expired' =>
                    now()->addHours(
                        rand(6, 24)
                    ),

                'status' =>
                    'aktif',
            ]);
        }
    }
}