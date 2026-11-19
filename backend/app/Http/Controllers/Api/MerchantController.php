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
use Illuminate\Validation\Rule;
use App\Services\AuditTrail;
use App\Services\OrderCancellation;

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
            ->whereHas('items')
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
                Pesanan::with([
                    'customer',
                    'items.menu',
                ])
                    ->where(
                        'mitra_id',
                        $mitra->id
                    )
                    ->whereIn('order_status', [
                        'menunggu_pembayaran',
                        'dibayar',
                        'diproses',
                        'siap_diambil',
                    ])
                    ->whereHas('items')
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

    /**
     * Profil toko milik mitra yang sedang login.
     */
    public function profile(Request $request)
    {
        $mitra = $request->user()->mitra;

        if (!$mitra) {
            return response()->json([
                'success' => false,
                'message' => 'Data mitra tidak ditemukan',
            ], 404);
        }

        return response()->json([
            'success' => true,
            'data' => [
                'id' => $mitra->id,
                'store_name' => $mitra->nama_toko,
                'description' => $mitra->deskripsi_toko,
                'address' => $mitra->alamat,
                'phone' => $mitra->nomor_telepon,
                'status_verification' => $mitra->status_verifikasi,
            ],
        ]);
    }

    /**
     * Perbarui profil toko milik mitra yang sedang login.
     */
    public function updateProfile(Request $request)
    {
        $mitra = $request->user()->mitra;

        if (!$mitra) {
            return response()->json([
                'success' => false,
                'message' => 'Data mitra tidak ditemukan',
            ], 404);
        }

        $validated = $request->validate([
            'nama_toko' => [
                'required',
                'string',
                'max:255',
                Rule::unique('mitra', 'nama_toko')->ignore($mitra->id),
            ],
            'alamat' => [
                'required',
                'string',
                'max:1000',
            ],
            'nomor_telepon' => [
                'required',
                'string',
                'max:20',
            ],
            'deskripsi_toko' => [
                'nullable',
                'string',
                'max:2000',
            ],
        ], [
            'nama_toko.required' => 'Nama toko wajib diisi',
            'nama_toko.unique' => 'Nama toko sudah digunakan',
            'alamat.required' => 'Alamat toko wajib diisi',
            'nomor_telepon.required' => 'Nomor telepon wajib diisi',
        ]);

        $mitra->fill($validated)->save();

        AuditTrail::record(
            'update_store_profile',
            $mitra,
            'success',
            'Mitra memperbarui profil toko.'
        );

        return response()->json([
            'success' => true,
            'message' => 'Profil toko berhasil diperbarui.',
            'data' => [
                'id' => $mitra->id,
                'store_name' => $mitra->nama_toko,
                'description' => $mitra->deskripsi_toko,
                'address' => $mitra->alamat,
                'phone' => $mitra->nomor_telepon,
                'status_verification' => $mitra->status_verifikasi,
            ],
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

            // Catat aktivitas verifikasi pembayaran.
            AuditTrail::record(
                'verify_payment',
                $order,
                'success',
                'Mitra berhasil memverifikasi pembayaran pesanan.'
            );

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
        }, 5); // Retry 5 kali jika terjadi deadlock.
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

            // Catat aktivitas konfirmasi pengambilan pesanan.
            AuditTrail::record(
                'confirm_pickup',
                $order,
                'success',
                'Mitra berhasil mengonfirmasi pengambilan pesanan.'
            );

            return response()->json([
                'success' => true,
                'message' => 'Pickup berhasil dikonfirmasi.',
                'data' => [
                    'id' => $order->id,
                    'order_status' => $order->order_status,
                ],
            ]);
        }, 5); // Retry 5 kali jika terjadi deadlock.
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
        int $id
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
        int $id
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

    /**
     * Membatalkan pesanan milik toko mitra.
     */
    public function cancelOrder(Request $request, int $id)
    {
        $mitra = $request->user()->mitra;

        if (!$mitra) {
            return response()->json([
                'success' => false,
                'message' => 'Data mitra tidak ditemukan',
            ], 404);
        }

        $order = Pesanan::where('mitra_id', $mitra->id)
            ->findOrFail($id);

        try {
            $cancelled = app(OrderCancellation::class)->cancel(
                $order,
                'Mitra',
                $request->input('alasan')
            );
        } catch (\InvalidArgumentException $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage(),
            ], 422);
        }

        return response()->json([
            'success' => true,
            'message' => 'Pesanan berhasil dibatalkan.',
            'data' => $cancelled,
        ]);
    }

    public function deleteProduct(
        Request $request,
        int $id
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

            $order = Pesanan::find($orderId);

            if (!$order) {
                continue;
            }

            try {
                app(OrderCancellation::class)->cancel(
                    $order,
                    'Sistem',
                    'Produk dihapus oleh mitra',
                    false,
                    [
                        'menunggu_pembayaran',
                        'menunggu',
                        'dibayar',
                        'diproses',
                        'siap_diambil',
                    ]
                );
            } catch (\InvalidArgumentException $e) {
                continue;
            }
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
