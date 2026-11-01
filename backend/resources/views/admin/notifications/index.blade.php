@extends('admin.layouts.app')

@section('title', 'Manajemen Notifikasi | CFood')
@section('breadcrumb', 'Manajemen Notifikasi')

@push('styles')
<style>
    .page-heading {
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: 15px;
        margin-bottom: 23px;
    }

    .page-title {
        font-size: 25px;
        font-weight: 750;
        color: var(--text, #172b24);
        margin-bottom: 5px;
    }

    .page-description {
        font-size: 13px;
        color: var(--muted, #75847d);
        margin: 0;
    }

    .btn-create {
        display: inline-flex;
        align-items: center;
        gap: 7px;
        background: #188653;
        color: white;
        text-decoration: none;
        padding: 11px 16px;
        border-radius: 9px;
        font-size: 12px;
        font-weight: 650;
    }

    .btn-create:hover {
        color: white;
        background: #126c42;
    }

    .section-card {
        background: white;
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
        color: #849087;
        font-size: 12px;
        margin: 0;
    }

    .notification-item {
        display: flex;
        gap: 15px;
        padding: 19px 20px;
        border-bottom: 1px solid #f0f3f0;
    }

    .notification-icon {
        flex-shrink: 0;
        width: 43px;
        height: 43px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        background: #e8f5ed;
        color: #16804e;
        font-size: 19px;
    }

    .notification-content {
        min-width: 0;
        flex: 1;
    }

    .notification-title {
        font-size: 14px;
        font-weight: 700;
        color: #263b30;
        margin-bottom: 5px;
    }

    .notification-message {
        font-size: 12px;
        color: #748179;
        line-height: 1.6;
        margin-bottom: 9px;
        white-space: pre-line;
        overflow-wrap: anywhere;
    }

    .notification-meta {
        display: flex;
        flex-wrap: wrap;
        gap: 13px;
        font-size: 11px;
        color: #8a968e;
    }

    .recipient-badge {
        display: inline-block;
        padding: 5px 9px;
        border-radius: 20px;
        background: #e8f5ed;
        color: #16804e;
        font-size: 10px;
        font-weight: 650;
    }

    .read-info {
        color: #6e7d73;
    }

    .empty-state {
        padding: 50px 20px;
        text-align: center;
        color: #89958d;
    }

    .empty-state i {
        display: block;
        font-size: 38px;
        margin-bottom: 12px;
    }

    .pagination-wrapper {
        padding: 17px 20px;
    }

    @media (max-width: 600px) {
        .page-heading {
            align-items: flex-start;
            flex-direction: column;
        }
    }
</style>
@endpush

@section('content')

<div class="page-heading">
    <div>
        <h1 class="page-title">Manajemen Notifikasi</h1>
        <p class="page-description">
            Buat dan pantau pengumuman untuk Customer dan Mitra CFood.
        </p>
    </div>

    <a href="{{ route('admin.notifications.create') }}" class="btn-create">
        <i class="bi bi-plus-lg"></i>
        Buat Notifikasi
    </a>
</div>

@if(session('success'))
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="bi bi-check-circle me-1"></i>
        {{ session('success') }}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
@endif

<div class="section-card">

    <div class="section-header">
        <h5 class="section-title">Riwayat Pengiriman</h5>
        <p class="section-caption">
            Daftar pengumuman yang pernah dikirim oleh Admin.
        </p>
    </div>

    @forelse($notifications as $notification)
        <div class="notification-item">

            <div class="notification-icon">
                <i class="bi bi-megaphone"></i>
            </div>

            <div class="notification-content">
                <h6 class="notification-title">
                    {{ $notification->judul }}
                </h6>

                <p class="notification-message">
                    {{ $notification->pesan }}
                </p>

                <div class="notification-meta">
                    <span>
                        <i class="bi bi-calendar3"></i>
                        {{ \Carbon\Carbon::parse($notification->created_at)->format('d M Y, H:i') }}
                    </span>

                    <span class="recipient-badge">
                        <i class="bi bi-people"></i>
                        {{ number_format($notification->recipient_count) }} penerima
                    </span>

                    <span class="read-info">
                        <i class="bi bi-check2-circle"></i>
                        {{ number_format($notification->read_count) }} sudah dibaca
                    </span>
                </div>
            </div>

        </div>
    @empty
        <div class="empty-state">
            <i class="bi bi-bell-slash"></i>
            <strong>Belum ada notifikasi</strong>
            <p class="mb-0 mt-1">
                Notifikasi yang dikirim Admin akan muncul di sini.
            </p>
        </div>
    @endforelse

    <div class="pagination-wrapper">
        {{ $notifications->links('pagination::bootstrap-5') }}
    </div>

</div>

@endsection