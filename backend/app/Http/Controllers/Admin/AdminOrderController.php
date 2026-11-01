<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Pesanan;
use Illuminate\Http\Request;

class AdminOrderController extends Controller
{
    public function index(Request $request)
    {
        $query = Pesanan::with([
            'customer',
            'mitra.user',
            'pembayaran',
        ]);

        // Pencarian kode pengambilan, Customer, toko, dan kode transaksi.
        if ($request->filled('search')) {
            $search = $request->search;

            $query->where(function ($builder) use ($search) {
                $builder->where('kode_pengambilan', 'like', "%{$search}%")
                    ->orWhereHas('customer', function ($customerQuery) use ($search) {
                        $customerQuery->where('nama', 'like', "%{$search}%")
                            ->orWhere('email', 'like', "%{$search}%");
                    })
                    ->orWhereHas('mitra', function ($mitraQuery) use ($search) {
                        $mitraQuery->where('nama_toko', 'like', "%{$search}%");
                    })
                    ->orWhereHas('pembayaran', function ($paymentQuery) use ($search) {
                        $paymentQuery->where('kode_transaksi', 'like', "%{$search}%");
                    });
            });
        }

        // Filter status pesanan.
        $allowedOrderStatuses = [
            'menunggu_pembayaran',
            'dibayar',
            'diproses',
            'siap_diambil',
            'selesai',
            'dibatalkan',
        ];

        if (in_array($request->order_status, $allowedOrderStatuses, true)) {
            $query->where('order_status', $request->order_status);
        }

        // Filter status pembayaran.
        $allowedPaymentStatuses = [
            'pending',
            'paid',
            'failed',
            'refunded',
        ];

        if (in_array($request->payment_status, $allowedPaymentStatuses, true)) {
            $query->whereHas('pembayaran', function ($paymentQuery) use ($request) {
                $paymentQuery->where('status_pembayaran', $request->payment_status);
            });
        }

        // Filter tanggal pesanan.
        if ($request->filled('date')) {
            $query->whereDate('created_at', $request->date);
        }

        $orders = $query->latest()->paginate(10)->withQueryString();

        // Statistik seluruh pesanan.
        $statistics = [
            'total' => Pesanan::count(),

            'menunggu_pembayaran' => Pesanan::where(
                'order_status',
                'menunggu_pembayaran'
            )->count(),

            'diproses' => Pesanan::whereIn('order_status', [
                'dibayar',
                'diproses',
            ])->count(),

            'siap_diambil' => Pesanan::where(
                'order_status',
                'siap_diambil'
            )->count(),

            'selesai' => Pesanan::where(
                'order_status',
                'selesai'
            )->count(),

            'dibatalkan' => Pesanan::where(
                'order_status',
                'dibatalkan'
            )->count(),
        ];

        return view('admin.orders.index', compact(
            'orders',
            'statistics'
        ));
    }

    public function show(Pesanan $order)
    {
        $order->load([
            'customer',
            'mitra.user',
            'items.menu',
            'pembayaran',
        ]);

        return view('admin.orders.show', compact('order'));
    }
}