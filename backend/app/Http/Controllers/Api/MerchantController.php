<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Menu;
use App\Models\Pesanan;
use App\Models\Pembayaran;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

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

                'stocks' =>
                    Menu::where(
                        'mitra_id',
                        $mitra->id
                    )
                    ->latest()
                    ->take(10)
                    ->get(),
            ]
        ]);
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
        ->latest()
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