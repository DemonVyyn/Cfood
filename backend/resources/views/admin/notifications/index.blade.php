@extends('admin.layouts.app')

@section('title', 'Manajemen Notifikasi | CFood')
@section('breadcrumb', 'Manajemen Notifikasi')

@push('styles')
<link href="{{ asset('css/admin/notifications/notifications.css') }}" rel="stylesheet">
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