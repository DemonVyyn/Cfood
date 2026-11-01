@extends('admin.layouts.app')

@section('title', 'Detail Pesanan | CFood')
@section('breadcrumb', 'Detail Pesanan')

@push('styles')
<style>
    .page-heading {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 22px;
    }

    .page-title {
        font-size: 24px;
        font-weight: 750;
        color: var(--text, #172b24);
        margin-bottom: 5px;
    }

    .page-description {
        font-size: 13px;
        color: #849087;
        margin: 0;
    }

    .btn-back {
        background: #e9f5ed;
        color: #16804e;
        padding: 9px 14px;
        border-radius: 8px;
        text-decoration: none;
        font-size: 12px;
        font-weight: 650;
    }

    .detail-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 18px;
        margin-bottom: 18px;
    }

    .detail-card {
        background: #fff;
        border: 1px solid #e8eee9;
        border-radius: 14px;
        padding: 21px;
        margin-bottom: 18px;
    }

    .detail-title {
        font-size: 15px;
        font-weight: 750;
        color: #263b30;
        margin-bottom: 17px;
    }

    .detail-row {
        display: flex;
        justify-content: space-between;
        gap: 15px;
        padding: 11px 0;
        border-bottom: 1px solid #f0f3f0;
        font-size: 12px;
    }

    .detail-row:last-child {
        border-bottom: none;
    }

    .detail-label {
        color: #849087;
    }

    .detail-value {
        color: #263b30;
        font-weight: 650;
        text-align: right;
        overflow-wrap: anywhere;
    }

    .status-badge {
        display: inline-block;
        padding: 6px 10px;
        border-radius: 20px;
        font-size: 10px;
        font-weight: 650;
    }

    .status-menunggu_pembayaran,
    .status-pending {
        background: #fff4d9;
        color: #a66b00;
    }

    .status-dibayar,
    .status-paid {
        background: #e5f2ff;
        color: #2468a7;
    }

    .status-diproses {
        background: #eee9ff;
        color: #7251b5;
    }

    .status-siap_diambil,
    .status-selesai {
        background: #e2f5eb;
        color: #16804e;
    }

    .status-dibatalkan,
    .status-failed {
        background: #ffe7e7;
        color: #c13d3d;
    }

    .status-refunded {
        background: #f0e9ff;
        color: #7651a8;
    }

    .table {
        vertical-align: middle;
        margin: 0;
    }

    .table th {
        background: #f8faf8;
        color: #78857d;
        font-size: 10px;
        text-transform: uppercase;
        padding: 13px;
    }

    .table td {
        padding: 14px 13px;
        font-size: 12px;
        color: #46564d;
    }

    .total-row {
        display: flex;
        justify-content: space-between;
        padding-top: 17px;
        margin-top: 10px;
        border-top: 1px solid #e9efea;
        font-weight: 750;
        color: #16804e;
        font-size: 16px;
    }

    .information-note {
        padding: 13px 15px;
        border-radius: 9px;
        background: #f0f7f2;
        color: #567361;
        font-size: 11px;
        line-height: 1.6;
    }

    @media (max-width: 700px) {
        .detail-grid {
            grid-template-columns: 1fr;
        }

        .page-heading {
            align-items: flex-start;
            gap: 12px;
            flex-direction: column;
        }
    }
</style>
@endpush

@section('content')

@php
    $orderLabels = [
        'menunggu_pembayaran' => 'Menunggu Pembayaran',
        'dibayar' => 'Dibayar',
        'diproses' => 'Diproses',
        'siap_diambil' => 'Siap Diambil',
        'selesai' => 'Selesai',
        'dibatalkan' => 'Dibatalkan',
    ];

    $paymentLabels = [
        'pending' => 'Pending',
        'paid' => 'Paid',
        'failed' => 'Failed',
        'refunded' => 'Refunded',
    ];
@endphp

<div class="page-heading">
    <div>
        <h1 class="page-title">Detail Pesanan</h1>
        <p class="page-description">
            Informasi lengkap transaksi #{{ $order->kode_pengambilan }}.
        </p>
    </div>

    <a href="{{ route('admin.orders.index') }}" class="btn-back">
        <i class="bi bi-arrow-left"></i> Kembali
    </a>
</div>

<div class="detail-grid">

    {{-- Informasi Customer --}}
    <div class="detail-card">
        <h5 class="detail-title">
            <i class="bi bi-person text-success"></i>
            Informasi Customer
        </h5>

        <div class="detail-row">
            <span class="detail-label">Nama</span>
            <span class="detail-value">
                {{ $order->customer->nama ?? '-' }}
            </span>
        </div>

        <div class="detail-row">
            <span class="detail-label">Email</span>
            <span class="detail-value">
                {{ $order->customer->email ?? '-' }}
            </span>
        </div>

        <div class="detail-row">
            <span class="detail-label">Nomor Telepon</span>
            <span class="detail-value">
                {{ $order->customer->phone ?? '-' }}
            </span>
        </div>
    </div>

    {{-- Informasi Mitra --}}
    <div class="detail-card">
        <h5 class="detail-title">
            <i class="bi bi-shop text-success"></i>
            Informasi Mitra
        </h5>

        <div class="detail-row">
            <span class="detail-label">Nama Toko</span>
            <span class="detail-value">
                {{ $order->mitra->nama_toko ?? '-' }}
            </span>
        </div>

        <div class="detail-row">
            <span class="detail-label">Pemilik</span>
            <span class="detail-value">
                {{ $order->mitra->user->nama ?? '-' }}
            </span>
        </div>

        <div class="detail-row">
            <span class="detail-label">Nomor Telepon Toko</span>
            <span class="detail-value">
                {{ $order->mitra->nomor_telepon ?? '-' }}
            </span>
        </div>
    </div>

</div>

{{-- Informasi Pesanan --}}
<div class="detail-card">
    <h5 class="detail-title">
        <i class="bi bi-receipt text-success"></i>
        Informasi Pesanan
    </h5>

    <div class="detail-grid mb-0">

        <div>
            <div class="detail-row">
                <span class="detail-label">Kode Pengambilan</span>
                <span class="detail-value">
                    {{ $order->kode_pengambilan }}
                </span>
            </div>

            <div class="detail-row">
                <span class="detail-label">Tanggal Pesanan</span>
                <span class="detail-value">
                    {{ $order->created_at?->format('d M Y, H:i') ?? '-' }}
                </span>
            </div>

            <div class="detail-row">
                <span class="detail-label">Waktu Pengambilan</span>
                <span class="detail-value">
                    {{ $order->waktu_pengambilan?->format('d M Y, H:i') ?? 'Belum ditentukan' }}
                </span>
            </div>
        </div>

        <div>
            <div class="detail-row">
                <span class="detail-label">Status Pesanan</span>
                <span class="detail-value">
                    <span class="status-badge status-{{ $order->order_status }}">
                        {{ $orderLabels[$order->order_status] ?? $order->order_status }}
                    </span>
                </span>
            </div>

            <div class="detail-row">
                <span class="detail-label">Total Harga</span>
                <span class="detail-value">
                    Rp{{ number_format((float) $order->total_harga, 0, ',', '.') }}
                </span>
            </div>
        </div>

    </div>
</div>

{{-- Daftar Produk --}}
<div class="detail-card">
    <h5 class="detail-title">
        <i class="bi bi-bag text-success"></i>
        Produk yang Dipesan
    </h5>

    <div class="table-responsive">
        <table class="table">
            <thead>
                <tr>
                    <th>Nama Produk</th>
                    <th>Harga Satuan</th>
                    <th>Jumlah</th>
                    <th>Subtotal</th>
                </tr>
            </thead>

            <tbody>
                @forelse($order->items as $item)
                    <tr>
                        <td>
                            <strong>
                                {{ $item->menu->nama ?? 'Produk tidak tersedia' }}
                            </strong>
                        </td>

                        <td>
                            Rp{{ number_format((float) $item->harga, 0, ',', '.') }}
                        </td>

                        <td>{{ $item->jumlah }}</td>

                        <td>
                            <strong>
                                Rp{{ number_format((float) $item->subtotal, 0, ',', '.') }}
                            </strong>
                        </td>
                    </tr>
                @empty
                    <tr>
                        <td colspan="4" class="text-center text-muted py-4">
                            Tidak ada detail produk pada pesanan ini.
                        </td>
                    </tr>
                @endforelse
            </tbody>
        </table>
    </div>

    <div class="total-row">
        <span>Total Pesanan</span>
        <span>
            Rp{{ number_format((float) $order->total_harga, 0, ',', '.') }}
        </span>
    </div>
</div>

{{-- Informasi Pembayaran --}}
<div class="detail-card">
    <h5 class="detail-title">
        <i class="bi bi-credit-card text-success"></i>
        Informasi Pembayaran
    </h5>

    @if($order->pembayaran)

        <div class="detail-row">
            <span class="detail-label">Kode Transaksi</span>
            <span class="detail-value">
                {{ $order->pembayaran->kode_transaksi }}
            </span>
        </div>

        <div class="detail-row">
            <span class="detail-label">Metode Pembayaran</span>
            <span class="detail-value">
                {{ strtoupper(str_replace('_', ' ', $order->pembayaran->metode_pembayaran)) }}
            </span>
        </div>

        <div class="detail-row">
            <span class="detail-label">Nominal</span>
            <span class="detail-value">
                Rp{{ number_format((float) $order->pembayaran->nominal, 0, ',', '.') }}
            </span>
        </div>

        <div class="detail-row">
            <span class="detail-label">Status Pembayaran</span>
            <span class="detail-value">
                <span class="status-badge status-{{ $order->pembayaran->status_pembayaran }}">
                    {{ $paymentLabels[$order->pembayaran->status_pembayaran] ?? $order->pembayaran->status_pembayaran }}
                </span>
            </span>
        </div>

        <div class="detail-row">
            <span class="detail-label">Waktu Pembayaran</span>
            <span class="detail-value">
                {{ $order->pembayaran->waktu_pembayaran?->format('d M Y, H:i') ?? '-' }}
            </span>
        </div>

        <div class="detail-row">
            <span class="detail-label">Waktu Refund</span>
            <span class="detail-value">
                {{ $order->pembayaran->waktu_refund?->format('d M Y, H:i') ?? '-' }}
            </span>
        </div>

    @else

        <div class="text-center py-3 text-muted">
            <i class="bi bi-exclamation-circle fs-3"></i>
            <p class="mb-0 mt-2">Belum terdapat data pembayaran.</p>
        </div>

    @endif
</div>

<div class="information-note">
    <i class="bi bi-shield-check"></i>
    Halaman ini digunakan untuk monitoring transaksi oleh Admin.
    Informasi pembayaran ditampilkan sebagai catatan transaksi dan tidak dapat
    diubah melalui halaman ini.
</div>

@endsection