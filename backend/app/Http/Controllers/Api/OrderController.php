<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\BarangPesanan;
use App\Models\Menu;
use App\Models\Pesanan;
use App\Models\Pembayaran;
use App\Models\Notifikasi;
use App\Models\Mitra;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;

class OrderController extends Controller
{
    /**
     * Membuat pesanan baru, detail pesanan, pembayaran tunai,
     * dan notifikasi untuk Mitra.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'menu_id' => ['required', 'integer', 'exists:menu,id'],
            'jumlah' => ['required', 'integer', 'min:1', 'max:100'],
        ]);

        $customer = $request->user();

        // Hanya customer yang dapat membuat pesanan.
        if (!$customer || $customer->role !== 'customer') {
            return response()->json([
                'success' => false,
                'message' => 'Hanya akun customer yang dapat membuat pesanan.',
            ], 403);
        }

        $order = DB::transaction(function () use ($validated, $customer) {

            $menu = Menu::whereKey($validated['menu_id'])
                ->lockForUpdate()
                ->firstOrFail();

            if (
                $menu->status !== 'aktif' ||
                $menu->stok <= 0 ||
                !$menu->waktu_expired ||
                $menu->waktu_expired <= now()
            ) {
                throw ValidationException::withMessages([
                    'menu_id' => [
                        'Makanan sudah kedaluwarsa atau tidak tersedia.',
                    ],
                ]);
            }

            $jumlah = (int) $validated['jumlah'];

            if ($menu->stok < $jumlah) {
                throw ValidationException::withMessages([
                    'jumlah' => [
                        'Stok makanan tidak mencukupi. Stok tersedia: '
                        . $menu->stok,
                    ],
                ]);
            }

            $harga = (float) $menu->harga_diskon;
            $subtotal = round($harga * $jumlah, 2);

            // Token unik untuk kode QR pengambilan.
            $kodePengambilan = Str::random(20);

            // Simpan pesanan.
            $pesanan = Pesanan::create([
                'customer_id' => $customer->id,
                'mitra_id' => $menu->mitra_id,
                'total_harga' => $subtotal,
                'kode_pengambilan' => $kodePengambilan,
                'order_status' => 'menunggu_pembayaran',
            ]);

            // Simpan detail pesanan.
            BarangPesanan::create([
                'pesanan_id' => $pesanan->id,
                'menu_id' => $menu->id,
                'jumlah' => $jumlah,
                'harga' => $harga,
                'subtotal' => $subtotal,
            ]);

            // Buat record pembayaran tunai dengan status pending.
            Pembayaran::create([
                'pesanan_id' => $pesanan->id,
                'kode_transaksi' => 'TRX-' . strtoupper(Str::random(16)),
                'nominal' => $subtotal,
                'metode_pembayaran' => 'cash',
                'status_pembayaran' => 'pending',
                'waktu_pembayaran' => null,
                'waktu_refund' => null,
            ]);

            // Kurangi stok dalam transaksi yang sama.
            $stokBaru = $menu->stok - $jumlah;
            $menu->stok = $stokBaru;

            if ($stokBaru <= 0) {
                $menu->status = 'habis';
            }

            $menu->save();

            /*
             * Buat notifikasi untuk akun Mitra.
             * pesanan.mitra_id mengarah ke tabel mitra,
             * sedangkan notifikasi.user_id menggunakan ID users.
             */
            $mitra = Mitra::findOrFail($menu->mitra_id);

            Notifikasi::create([
                'user_id' => $mitra->user_id,
                'judul' => 'Pesanan Baru Masuk',
                'pesan' => 'Pesanan baru #' . $pesanan->id
                    . ' dari ' . $customer->nama
                    . ' telah masuk. Jumlah pesanan: '
                    . $jumlah
                    . '. Silakan periksa pesanan dan pembayaran.',
                'is_read' => false,
                'read_at' => null,
            ]);

            return $pesanan->load([
                'items.menu',
                'mitra',
                'pembayaran',
            ]);
        });

        return response()->json([
            'success' => true,
            'message' => 'Pesanan berhasil disimpan. Silakan lakukan pembayaran tunai kepada mitra.',
            'data' => $order,
        ], 201);
    }

    /**
     * Daftar pesanan milik customer yang sedang login.
     */
    public function index(Request $request)
    {
        $customer = $request->user();

        if (!$customer || $customer->role !== 'customer') {
            return response()->json([
                'success' => false,
                'message' => 'Hanya akun customer yang dapat melihat pesanan ini.',
            ], 403);
        }

        $orders = Pesanan::with([
            'items.menu',
            'mitra',
            'pembayaran',
        ])
            ->where('customer_id', $customer->id)
            ->latest()
            ->get();

        return response()->json([
            'success' => true,
            'data' => $orders,
        ]);
    }

    /**
     * Detail pesanan milik customer yang sedang login.
     */
    public function show(Request $request, int $id)
    {
        $customer = $request->user();

        if (!$customer || $customer->role !== 'customer') {
            return response()->json([
                'success' => false,
                'message' => 'Hanya akun customer yang dapat melihat pesanan ini.',
            ], 403);
        }

        $order = Pesanan::with([
            'items.menu',
            'mitra',
            'pembayaran',
        ])
            ->where('customer_id', $customer->id)
            ->findOrFail($id);

        return response()->json([
            'success' => true,
            'data' => $order,
        ]);
    }
}
