<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\Menu;
use App\Models\Notifikasi;

class CheckExpiredProducts extends Command
{
    protected $signature = 'products:check-expired';

    protected $description =
        'Cek produk yang akan expired dan sudah expired';

    public function handle(): int
    {
        $this->checkWillExpire();

        $this->checkExpired();

        $this->info(
            'Expired products checked successfully'
        );

        return Command::SUCCESS;
    }

    private function checkWillExpire(): void
    {
        $products = Menu::with('mitra.user')
            ->where('status', 'aktif')
            ->whereBetween(
                'waktu_expired',
                [
                    now(),
                    now()->copy()->addDay(),
                ]
            )
            ->get();

        foreach ($products as $product) {

            if (
                !$product->mitra ||
                !$product->mitra->user
            ) {
                continue;
            }

            $exists = Notifikasi::where(
                'user_id',
                $product->mitra->user->id
            )
                ->where(
                    'judul',
                    'Produk Akan Expired'
                )
                ->where(
                    'pesan',
                    $product->nama .
                    ' akan expired dalam 24 jam'
                )
                ->exists();

            if (!$exists) {
                Notifikasi::create([
                    'user_id' =>
                        $product->mitra->user->id,

                    'judul' =>
                        'Produk Akan Expired',

                    'pesan' =>
                        $product->nama .
                        ' akan expired dalam 24 jam',
                ]);
            }
        }
    }

    private function checkExpired(): void
    {
        $products = Menu::with('mitra.user')
            ->where(
                'waktu_expired',
                '<=',
                now()
            )
            ->where(
                'status',
                '!=',
                'expired'
            )
            ->get();

        foreach ($products as $product) {

            $product->update([
                'status' => 'expired',
            ]);

            if (
                !$product->mitra ||
                !$product->mitra->user
            ) {
                continue;
            }

            Notifikasi::create([
                'user_id' =>
                    $product->mitra->user->id,

                'judul' =>
                    'Produk Expired',

                'pesan' =>
                    $product->nama .
                    ' telah expired',
            ]);
        }
    }
}