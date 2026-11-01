@extends('admin.layouts.app')

@section('title', 'Manajemen Pesanan | CFood')
@section('breadcrumb', 'Manajemen Pesanan')

@push('styles')
<link href="{{ asset('css/admin/orders/orders.css') }}" rel="stylesheet">
@endpush

@section('content')

<div class="page-heading">
    <div>
        <h1 class="page-title">Manajemen Pesanan</h1>
        <p class="page-description">
            Pantau seluruh transaksi dan aktivitas pesanan Customer CFood.
        </p>
    </div>
</div>

{{-- Statistik --}}
<div class="stats-grid">

    <div class="stat-card">
        <div class="stat-label">Total Pesanan</div>
        <div class="stat-value">{{ number_format($statistics['total']) }}</div>
    </div>

    <div class="stat-card">
        <div class="stat-label">Menunggu Pembayaran</div>
        <div class="stat-value">
            {{ number_format($statistics['menunggu_pembayaran']) }}
        </div>
    </div>

    <div class="stat-card">
        <div class="stat-label">Sedang Diproses</div>
        <div class="stat-value">{{ number_format($statistics['diproses']) }}</div>
    </div>

    <div class="stat-card">
        <div class="stat-label">Siap Diambil</div>
        <div class="stat-value">
            {{ number_format($statistics['siap_diambil']) }}
        </div>
    </div>

    <div class="stat-card">
        <div class="stat-label">Pesanan Selesai</div>
        <div class="stat-value">{{ number_format($statistics['selesai']) }}</div>
    </div>

    <div class="stat-card">
        <div class="stat-label">Pesanan Dibatalkan</div>
        <div class="stat-value">{{ number_format($statistics['dibatalkan']) }}</div>
    </div>

</div>

{{-- Tabel pesanan --}}
<div class="section-card">

    <div class="section-header">
        <h5 class="section-title">Daftar Seluruh Pesanan</h5>
        <p class="section-caption">
            Data pesanan dari seluruh Customer dan Mitra.
        </p>

        <form action="{{ route('admin.orders.index') }}"
              method="GET"
              class="filter-form">

            <input
                type="text"
                name="search"
                class="form-control"
                placeholder="Cari kode, Customer, toko..."
                value="{{ request('search') }}"
            >

            <select name="order_status" class="form-select">
                <option value="">Semua Status Pesanan</option>
                <option value="menunggu_pembayaran"
                    @selected(request('order_status') === 'menunggu_pembayaran')>
                    Menunggu Pembayaran
                </option>
                <option value="dibayar"
                    @selected(request('order_status') === 'dibayar')>
                    Dibayar
                </option>
                <option value="diproses"
                    @selected(request('order_status') === 'diproses')>
                    Diproses
                </option>
                <option value="siap_diambil"
                    @selected(request('order_status') === 'siap_diambil')>
                    Siap Diambil
                </option>
                <option value="selesai"
                    @selected(request('order_status') === 'selesai')>
                    Selesai
                </option>
                <option value="dibatalkan"
                    @selected(request('order_status') === 'dibatalkan')>
                    Dibatalkan
                </option>
            </select>

            <select name="payment_status" class="form-select">
                <option value="">Semua Pembayaran</option>
                <option value="pending"
                    @selected(request('payment_status') === 'pending')>
                    Pending
                </option>
                <option value="paid"
                    @selected(request('payment_status') === 'paid')>
                    Paid
                </option>
                <option value="failed"
                    @selected(request('payment_status') === 'failed')>
                    Failed
                </option>
                <option value="refunded"
                    @selected(request('payment_status') === 'refunded')>
                    Refunded
                </option>
            </select>

            <input
                type="date"
                name="date"
                class="form-control"
                value="{{ request('date') }}"
            >

            <button type="submit" class="btn-filter">
                <i class="bi bi-search"></i> Filter
            </button>
        </form>

        @if(request()->hasAny(['search', 'order_status', 'payment_status', 'date']))
            <div class="mt-3">
                <a href="{{ route('admin.orders.index') }}"
                   class="text-decoration-none small text-success">
                    <i class="bi bi-x-circle"></i> Reset filter
                </a>
            </div>
        @endif
    </div>

    <div class="table-responsive">
        <table class="table">
            <thead>
                <tr>
                    <th>Kode Pesanan</th>
                    <th>Customer</th>
                    <th>Mitra</th>
                    <th>Tanggal</th>
                    <th>Total</th>
                    <th>Status Pesanan</th>
                    <th>Pembayaran</th>
                    <th>Aksi</th>
                </tr>
            </thead>

            <tbody>
                @forelse($orders as $order)
                    <tr>
                        <td>
                            <span class="order-code">
                                #{{ $order->kode_pengambilan }}
                            </span>
                        </td>

                        <td>
                            <span class="customer-name">
                                {{ $order->customer->nama ?? 'Customer tidak tersedia' }}
                            </span>
                            <span class="secondary-text">
                                {{ $order->customer->email ?? '-' }}
                            </span>
                        </td>

                        <td>
                            <span class="customer-name">
                                {{ $order->mitra->nama_toko ?? 'Mitra tidak tersedia' }}
                            </span>
                        </td>

                        <td>
                            {{ $order->created_at?->format('d M Y') ?? '-' }}
                            <span class="secondary-text">
                                {{ $order->created_at?->format('H:i') ?? '' }}
                            </span>
                        </td>

                        <td>
                            <span class="price-text">
                                Rp{{ number_format((float) $order->total_harga, 0, ',', '.') }}
                            </span>
                        </td>

                        <td>
                            @php
                                $orderLabels = [
                                    'menunggu_pembayaran' => 'Menunggu Pembayaran',
                                    'dibayar' => 'Dibayar',
                                    'diproses' => 'Diproses',
                                    'siap_diambil' => 'Siap Diambil',
                                    'selesai' => 'Selesai',
                                    'dibatalkan' => 'Dibatalkan',
                                ];

                                $orderStatus = $order->order_status;
                            @endphp

                            <span class="status-badge status-{{ $orderStatus }}">
                                {{ $orderLabels[$orderStatus] ?? $orderStatus }}
                            </span>
                        </td>

                        <td>
                            @if($order->pembayaran)
                                @php
                                    $paymentLabels = [
                                        'pending' => 'Pending',
                                        'paid' => 'Paid',
                                        'failed' => 'Failed',
                                        'refunded' => 'Refunded',
                                    ];

                                    $paymentStatus = $order->pembayaran->status_pembayaran;
                                @endphp

                                <span class="status-badge status-{{ $paymentStatus }}">
                                    {{ $paymentLabels[$paymentStatus] ?? $paymentStatus }}
                                </span>

                                <span class="secondary-text">
                                    {{ strtoupper($order->pembayaran->metode_pembayaran) }}
                                </span>
                            @else
                                <span class="secondary-text">Belum ada pembayaran</span>
                            @endif
                        </td>

                        <td>
                            <a href="{{ route('admin.orders.show', $order->id) }}"
                               class="btn-detail">
                                <i class="bi bi-eye"></i> Detail
                            </a>
                        </td>
                    </tr>
                @empty
                    <tr>
                        <td colspan="8">
                            <div class="empty-state">
                                <i class="bi bi-receipt"></i>
                                <strong>Belum ada pesanan</strong>
                                <p class="mb-0 mt-1">
                                    Data pesanan tidak ditemukan.
                                </p>
                            </div>
                        </td>
                    </tr>
                @endforelse
            </tbody>
        </table>
    </div>

    <div class="pagination-wrapper">
        {{ $orders->links('pagination::bootstrap-5') }}
    </div>

</div>

@endsection