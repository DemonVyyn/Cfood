<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\BarangPesanan;
use App\Models\Menu;
use App\Models\Pesanan;
use App\Models\Pembayaran;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\DB;

class MerchantController extends Controller
{
    public function dashboard(Request $request)
    {
        $user = $request->user();

        $mitra = $user->mitra;

        if (!$mitra) {
            return response()->json([
                'success' => false,
                'message' => 'Data mitra tidak ditemukan'
            ], 404);
        }

        $activeProducts = Menu::where(
            'mitra_id',
            $mitra->id
        )
        ->where('status', 'aktif')
        ->count();

        $waitingOrders = Pesanan::where(
            'mitra_id',
            $mitra->id
        )
        ->whereIn('order_status', [
            'dibayar',
            'diproses',
            'siap_diambil'
        ])
        ->count();

        $todaySales = Pembayaran::whereHas(
            'pesanan',
            function ($query) use ($mitra) {
                $query->where(
                    'mitra_id',
                    $mitra->id
                );
            }
        )
        ->where(
            'status_pembayaran',
            'paid'
        )
        ->whereDate(
            'created_at',
            today()
        )
        ->sum('nominal');

        return response()->json([
            'success' => true,
            'data' => [
                'store_name' =>
                    $mitra->nama_toko,

                'active_products' =>
                    $activeProducts,

                'waiting_orders' =>
                    $waitingOrders,

                'today_sales' =>
                    $todaySales,

                'latest_orders' =>
                    Pesanan::with('customer')
                        ->where(
                            'mitra_id',
                            $mitra->id
                        )
                        ->latest()
                        ->take(5)
                        ->get(),

                'stocks' => Menu::where(
        'mitra_id',
        $mitra->id
    )
    ->orderByRaw(
        'CASE WHEN waktu_expired <= ? THEN 0 ELSE 1 END',
        [now()->toDateTimeString()]
    )
    ->orderBy(
        'waktu_expired',
        'asc'
    )
    ->get(),
            ]
        ]);
    }

    public function verifyPayment(Request $request, int $id)
{
    $mitra = $request->user()->mitra;

    if (!$mitra) {
        return response()->json([
            'success' => false,
            'message' => 'Data mitra tidak ditemukan.',
        ], 404);
    }

    return DB::transaction(function () use ($mitra, $id) {
        $order = Pesanan::where('mitra_id', $mitra->id)
            ->whereKey($id)
            ->lockForUpdate()
            ->first();

        if (!$order) {
            return response()->json([
                'success' => false,
                'message' => 'Pesanan tidak ditemukan atau bukan milik toko ini.',
            ], 404);
        }

        if ($order->order_status !== 'menunggu_pembayaran') {
            return response()->json([
                'success' => false,
                'message' => 'Pesanan tidak berada pada status menunggu pembayaran.',
            ], 422);
        }

        $payment = Pembayaran::where('pesanan_id', $order->id)
            ->lockForUpdate()
            ->first();

        if (!$payment) {
            return response()->json([
                'success' => false,
                'message' => 'Data pembayaran tidak ditemukan.',
            ], 422);
        }

        if ($payment->metode_pembayaran !== 'cash') {
            return response()->json([
                'success' => false,
                'message' => 'Metode pembayaran pesanan ini bukan tunai.',
            ], 422);
        }

        if ($payment->status_pembayaran !== 'pending') {
            return response()->json([
                'success' => false,
                'message' => 'Pembayaran tidak berstatus pending atau sudah diproses.',
            ], 422);
        }

        // Verifikasi manual: mitra harus memeriksa uang tunai terlebih dahulu.
        $payment->status_pembayaran = 'paid';
        $payment->waktu_pembayaran = now();
        $payment->save();

        $order->order_status = 'siap_diambil';
        $order->save();

        return response()->json([
            'success' => true,
            'message' => 'Pembayaran berhasil diverifikasi. Pesanan siap diambil.',
            'data' => [
                'id' => $order->id,
                'order_status' => $order->order_status,
                'status_pembayaran' => $payment->status_pembayaran,
                'waktu_pembayaran' => $payment->waktu_pembayaran,
            ],
        ]);
    });
}


    //confirm pesanan
    public function confirmPickup(Request $request)
{
    $validated = $request->validate([
        'kode_pengambilan' => [
            'required',
            'string',
            'max:20',
        ],
    ]);

    $mitra = $request->user()->mitra;

    if (!$mitra) {
        return response()->json([
            'success' => false,
            'message' => 'Data mitra tidak ditemukan.',
        ], 404);
    }

    return DB::transaction(function () use ($validated, $mitra) {
        $order = Pesanan::where('mitra_id', $mitra->id)
            ->where(
                'kode_pengambilan',
                $validated['kode_pengambilan']
            )
            ->lockForUpdate()
            ->first();

        if (!$order) {
            return response()->json([
                'success' => false,
                'message' => 'Kode QR tidak valid atau pesanan bukan milik toko ini.',
            ], 404);
        }

        if ($order->order_status !== 'siap_diambil') {
            return response()->json([
                'success' => false,
                'message' => $order->order_status === 'selesai'
                    ? 'Pesanan ini sudah pernah diambil.'
                    : 'Pesanan belum siap diambil atau sudah dibatalkan.',
            ], 422);
        }

        $order->order_status = 'selesai';
        $order->save();

        return response()->json([
            'success' => true,
            'message' => 'Pickup berhasil dikonfirmasi.',
            'data' => [
                'id' => $order->id,
                'order_status' => $order->order_status,
            ],
        ]);
    });
}

    public function products(Request $request)
    {
        $user = $request->user();

        $mitra = $user->mitra;

        if (!$mitra) {
            return response()->json([
                'success' => false,
                'message' => 'Data mitra tidak ditemukan'
            ], 404);
        }

       $products = Menu::where(
        'mitra_id',
        $mitra->id
    )
    ->orderByRaw(
        'CASE WHEN waktu_expired <= ? THEN 0 ELSE 1 END',
        [now()->toDateTimeString()]
    )
    ->orderBy(
        'waktu_expired',
        'asc'
    )
    ->get();

        return response()->json([
            'success' => true,
            'data' => $products
        ]);
    }

    public function storeProduct(Request $request)
{
    try {

        $user = $request->user();

        $mitra = $user->mitra;

        $request->validate([
            'nama' => 'required',
            'harga_original' => 'required',
            'harga_diskon' => 'required',
            'stok' => 'required',
            'waktu_expired' => 'required',
        ]);

        $foto = null;

        if ($request->hasFile('foto')) {

            $foto = $request
                ->file('foto')
                ->store(
                    'products',
                    'public'
                );
        }

        $product = Menu::create([
            'mitra_id' => $mitra->id,
            'nama' => $request->nama,
            'deskripsi' => $request->deskripsi,
            'kategori' => $request->kategori,
            'foto' => $foto,
            'harga_original' => $request->harga_original,
            'harga_diskon' => $request->harga_diskon,
            'stok' => $request->stok,
            'waktu_expired' => $request->waktu_expired,
            'status' => 'aktif',
        ]);

        return response()->json([
            'success' => true,
            'data' => $product,
        ]);

    } catch (\Throwable $e) {

        return response()->json([
            'success' => false,
            'message' => $e->getMessage(),
            'line' => $e->getLine(),
            'file' => $e->getFile(),
        ], 500);
    }
}

    public function updateProduct(
        Request $request,
        $id
    ) {
        $user = $request->user();

        $mitra = $user->mitra;

        $product = Menu::where(
            'mitra_id',
            $mitra->id
        )->findOrFail($id);

        if ($request->hasFile('foto')) {

            if ($product->foto) {
                Storage::disk('public')
                    ->delete(
                        $product->foto
                    );
            }

            $product->foto =
                $request->file('foto')
                    ->store(
                        'products',
                        'public'
                    );
        }

        $product->nama =
            $request->nama;

        $product->deskripsi =
            $request->deskripsi;

        $product->kategori =
            $request->kategori;

        $product->harga_original =
            $request->harga_original;

        $product->harga_diskon =
            $request->harga_diskon;

        $product->stok =
            $request->stok;

        $product->waktu_expired =
            $request->waktu_expired;

        if ($request->status) {
            $product->status =
                $request->status;
        }

        $product->save();

        return response()->json([
            'success' => true,
            'message' => 'Produk berhasil diperbarui'
        ]);
    }

    public function orders(Request $request)
{
    $user = $request->user();

    $mitra = $user->mitra;

    if (!$mitra) {
        return response()->json([
            'success' => false,
            'message' => 'Data mitra tidak ditemukan'
        ], 404);
    }

    $orders = Pesanan::with([
    'customer',
    'items.menu',
    'pembayaran',
    ])
    ->where(
        'mitra_id',
        $mitra->id
    )
    ->latest()
    ->get();

    return response()->json([
        'success' => true,
        'data' => $orders,
    ]);
}

    public function showProduct(
    Request $request,
    $id
) {
    $user = $request->user();

    $mitra = $user->mitra;

    $product = Menu::where(
        'mitra_id',
        $mitra->id
    )->findOrFail($id);

    return response()->json([
        'success' => true,
        'data' => $product,
    ]);
}

    public function deleteProduct(
        Request $request,
        $id
    ) {
        $user = $request->user();

        $mitra = $user->mitra;

        $product = Menu::where(
            'mitra_id',
            $mitra->id
        )->findOrFail($id);

        // Barang pesanan ikut terhapus otomatis (ON DELETE CASCADE) saat
        // produk dihapus. Batalkan pesanan yang masih aktif dan hanya berisi
        // produk ini, supaya tidak tersisa sebagai pesanan "terkunci" tanpa item.
        $affectedOrderIds = BarangPesanan::where(
            'menu_id',
            $product->id
        )
            ->pluck('pesanan_id')
            ->unique();

        foreach ($affectedOrderIds as $orderId) {
            $otherItems = BarangPesanan::where(
                'pesanan_id',
                $orderId
            )
                ->where('menu_id', '!=', $product->id)
                ->count();

            if ($otherItems > 0) {
                continue;
            }

            Pesanan::where('id', $orderId)
                ->whereIn('order_status', [
                    'menunggu_pembayaran',
                    'menunggu',
                    'diproses',
                ])
                ->update([
                    'order_status' => 'dibatalkan',
                ]);
        }

        if ($product->foto) {
            Storage::disk('public')
                ->delete(
                    $product->foto
                );
        }

        $product->delete();

        return response()->json([
            'success' => true,
            'message' => 'Produk berhasil dihapus'
        ]);
    }
}