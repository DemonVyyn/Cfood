
@extends('admin.layouts.app')

@section('title', 'Detail Pesanan | CFood')
@section('breadcrumb', 'Detail Pesanan')

@push('styles')
<link href="{{ asset('css/admin/orders/orders_show.css') }}" rel="stylesheet">
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

    $actionLabels = [
        'create_order' => 'Membuat Pesanan',
        'verify_payment' => 'Verifikasi Pembayaran',
        'confirm_pickup' => 'Konfirmasi Pengambilan',
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

{{-- Audit Trail --}}
<div class="detail-card">
    <h5 class="detail-title">
        <i class="bi bi-shield-check text-success"></i>
        Riwayat Aktivitas Pesanan (Audit Trail)
    </h5>

    @if($auditLogs->isNotEmpty())

        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>Waktu Aktivitas</th>
                        <th>Pelaku</th>
                        <th>Aktivitas</th>
                        <th>Objek</th>
                        <th>Hasil</th>
                        <th>Deskripsi</th>
                    </tr>
                </thead>

                <tbody>
                    @foreach($auditLogs as $log)
                        <tr>
                            <td>
                                {{ $log->event_at?->format('d M Y, H:i:s') ?? '-' }}
                            </td>

                            <td>
                                <strong>
                                    {{ $log->actor?->nama ?? 'Tidak diketahui' }}
                                </strong>
                                <br>
                                <small class="text-muted">
                                    {{ ucfirst($log->actor_role ?? '-') }}
                                    (ID: {{ $log->actor_id ?? '-' }})
                                </small>
                            </td>

                            <td>
                                {{ $actionLabels[$log->action] ?? $log->action }}
                            </td>

                            <td>
                                {{ $log->object_type ?? '-' }}
                                #{{ $log->object_id ?? '-' }}
                            </td>

                            <td>
                                @if($log->result === 'success')
                                    <span class="badge bg-success">Berhasil</span>
                                @elseif($log->result === 'failed')
                                    <span class="badge bg-danger">Gagal</span>
                                @else
                                    <span class="badge bg-secondary">
                                        {{ ucfirst($log->result) }}
                                    </span>
                                @endif
                            </td>

                            <td>
                                {{ $log->description ?? '-' }}
                                <br>
                                <small class="text-muted">
                                    IP: {{ $log->ip_address ?? '-' }}
                                </small>
                            </td>
                        </tr>
                    @endforeach
                </tbody>
            </table>
        </div>

    @else

        <div class="text-center py-4 text-muted">
            <i class="bi bi-clock-history fs-3"></i>
            <p class="mb-0 mt-2">
                Belum terdapat riwayat aktivitas untuk pesanan ini.
            </p>
        </div>

    @endif
</div>

<div class="information-note">
    <i class="bi bi-shield-check"></i>
    Halaman ini digunakan untuk monitoring transaksi dan riwayat aktivitas
    oleh Admin. Informasi pembayaran dan Audit Trail ditampilkan sebagai
    catatan transaksi dan tidak dapat diubah melalui halaman ini.
</div>

@endsection
