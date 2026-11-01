@extends('admin.layouts.app')

@section('title', 'Buat Notifikasi | CFood')
@section('breadcrumb', 'Buat Notifikasi')

@push('styles')
<link href="{{ asset('css/admin/notifications/notifications_create.css') }}" rel="stylesheet">
@endpush

@section('content')

<div class="page-heading">
    <h1 class="page-title">Buat Notifikasi</h1>
    <p class="page-description">
        Buat pengumuman yang akan diterima pengguna melalui aplikasi CFood.
    </p>
</div>

<div class="form-card">

    <form action="{{ route('admin.notifications.store') }}" method="POST">
        @csrf

        <div class="mb-4">
            <label for="judul" class="form-label">
                Judul Notifikasi
            </label>

            <input
                type="text"
                name="judul"
                id="judul"
                class="form-control @error('judul') is-invalid @enderror"
                placeholder="Contoh: Informasi Pemeliharaan Sistem"
                value="{{ old('judul') }}"
                maxlength="255"
                required
            >

            @error('judul')
                <div class="invalid-feedback">{{ $message }}</div>
            @enderror
        </div>

        <div class="mb-4">
            <label for="pesan" class="form-label">
                Isi Notifikasi
            </label>

            <textarea
                name="pesan"
                id="pesan"
                class="form-control @error('pesan') is-invalid @enderror"
                placeholder="Tuliskan informasi yang ingin disampaikan kepada pengguna..."
                maxlength="5000"
                required
            >{{ old('pesan') }}</textarea>

            @error('pesan')
                <div class="invalid-feedback">{{ $message }}</div>
            @enderror

            <div class="form-text">
                Maksimal 5.000 karakter.
            </div>
        </div>

        <div class="mb-3">
            <label class="form-label">
                Target Penerima
            </label>

            <div class="recipient-options">

                <div class="recipient-option">
                    <input
                        type="radio"
                        name="target"
                        id="target_customer"
                        value="customer"
                        @checked(old('target', 'customer') === 'customer')
                    >

                    <label for="target_customer" class="recipient-label">
                        <i class="bi bi-person"></i>
                        <span class="recipient-name">Customer</span>
                        <span class="recipient-count">
                            {{ number_format($recipientCounts['customer']) }} akun aktif
                        </span>
                    </label>
                </div>

                <div class="recipient-option">
                    <input
                        type="radio"
                        name="target"
                        id="target_mitra"
                        value="mitra"
                        @checked(old('target') === 'mitra')
                    >

                    <label for="target_mitra" class="recipient-label">
                        <i class="bi bi-shop"></i>
                        <span class="recipient-name">Mitra</span>
                        <span class="recipient-count">
                            {{ number_format($recipientCounts['mitra']) }} akun aktif
                        </span>
                    </label>
                </div>

                <div class="recipient-option">
                    <input
                        type="radio"
                        name="target"
                        id="target_all"
                        value="all"
                        @checked(old('target') === 'all')
                    >

                    <label for="target_all" class="recipient-label">
                        <i class="bi bi-people"></i>
                        <span class="recipient-name">Semua Pengguna</span>
                        <span class="recipient-count">
                            {{ number_format($recipientCounts['customer'] + $recipientCounts['mitra']) }} akun aktif
                        </span>
                    </label>
                </div>

            </div>

            @error('target')
                <div class="text-danger small mt-2">{{ $message }}</div>
            @enderror
        </div>

        <div class="info-note">
            <i class="bi bi-info-circle"></i>
            Notifikasi akan dikirim kepada seluruh akun aktif sesuai target yang dipilih.
            Setiap penerima memiliki status baca masing-masing.
        </div>

        <div class="form-actions">
            <a href="{{ route('admin.notifications.index') }}" class="btn-cancel">
                Batal
            </a>

            <button type="submit" class="btn-send">
                <i class="bi bi-send me-1"></i>
                Kirim Notifikasi
            </button>
        </div>

    </form>
</div>

@endsection