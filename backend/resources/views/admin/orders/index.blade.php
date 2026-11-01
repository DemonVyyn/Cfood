@extends('admin.layouts.app')

@section('title', 'Manajemen Pesanan | CFood')
@section('breadcrumb', 'Manajemen Pesanan')

@push('styles')
<style>
    .page-heading {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 24px;
    }

    .page-title {
        font-size: 25px;
        font-weight: 750;
        color: var(--text, #172b24);
        margin-bottom: 5px;
    }

    .page-description {
        color: var(--muted, #75847d);
        font-size: 13px;
        margin: 0;
    }

    .stats-grid {
        display: grid;
        grid-template-columns: repeat(4, minmax(0, 1fr));
        gap: 15px;
        margin-bottom: 22px;
    }

    .stat-card {
        background: #fff;
        border: 1px solid #e8eee9;
        border-radius: 14px;
        padding: 19px;
    }

    .stat-label {
        color: #7b8981;
        font-size: 12px;
        margin-bottom: 9px;
    }

    .stat-value {
        color: #183b2c;
        font-size: 25px;
        font-weight: 750;
    }

    .section-card {
        background: #fff;
        border: 1px solid #e8eee9;
        border-radius: 15px;
        overflow: hidden;
    }

    .section-header {
        padding: 20px;
        border-bottom: 1px solid #edf1ee;
    }

    .section-title {
        font-size: 16px;
        font-weight: 700;
        margin-bottom: 5px;
    }

    .section-caption {
        font-size: 12px;
        color: #849087;
        margin: 0;
    }

    .filter-form {
        display: grid;
        grid-template-columns: 2fr 1fr 1fr 1fr auto;
        gap: 10px;
        margin-top: 17px;
    }

    .filter-form .form-control,
    .filter-form .form-select {
        min-height: 40px;
        border-color: #e1e9e3;
        font-size: 12px;
        border-radius: 8px;
    }

    .btn-filter {
        background: #188653;
        color: white;
        border: none;
        border-radius: 8px;
        padding: 0 17px;
        font-size: 12px;
        font-weight: 600;
    }

    .btn-filter:hover {
        background: #126c42;
        color: white;
    }

    .table {
        margin: 0;
        vertical-align: middle;
    }

    .table thead th {
        background: #f8faf8;
        color: #78857d;
        font-size: 10px;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: .4px;
        padding: 14px 15px;
        white-space: nowrap;
        border-bottom: 1px solid #e9efea;
    }

    .table tbody td {
        padding: 15px;
        font-size: 12px;
        border-bottom: 1px solid #f0f3f0;
        color: #46564d;
    }

    .order-code {
        font-weight: 700;
        color: #16804e;
    }

    .customer-name {
        font-weight: 650;
        color: #263b30;
    }

    .secondary-text {
        display: block;
        font-size: 11px;
        color: #89958d;
        margin-top: 3px;
    }

    .price-text {
        font-weight: 700;
        color: #263b30;
        white-space: nowrap;
    }

    .status-badge {
        display: inline-block;
        padding: 6px 9px;
        border-radius: 20px;
        font-size: 10px;
        font-weight: 650;
        white-space: nowrap;
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

    .status-siap_diambil {
        background: #e2f5eb;
        color: #16804e;
    }

    .status-selesai {
        background: #dff4e7;
        color: #137344;
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

    .btn-detail {
        display: inline-flex;
        align-items: center;
        gap: 5px;
        padding: 7px 11px;
        border-radius: 7px;
        background: #e9f5ed;
        color: #16804e;
        text-decoration: none;
        font-size: 11px;
        font-weight: 650;
    }

    .btn-detail:hover {
        background: #d8eddf;
        color: #126c42;
    }

    .empty-state {
        text-align: center;
        padding: 45px 20px;
        color: #89958d;
    }

    .empty-state i {
        font-size: 35px;
        display: block;
        margin-bottom: 12px;
    }

    .pagination-wrapper {
        padding: 17px 20px;
    }

    @media (max-width: 1100px) {
        .stats-grid {
            grid-template-columns: repeat(2, 1fr);
        }

        .filter-form {
            grid-template-columns: repeat(2, 1fr);
        }
    }

    @media (max-width: 600px) {
        .stats-grid {
            grid-template-columns: 1fr 1fr;
        }

        .filter-form {
            grid-template-columns: 1fr;
        }

        .page-title {
            font-size: 21px;
        }
    }
</style>
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