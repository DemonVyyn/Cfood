@extends('admin.layouts.app')

@section('title', 'Buat Notifikasi | CFood')
@section('breadcrumb', 'Buat Notifikasi')

@push('styles')
<style>
    .page-heading {
        margin-bottom: 22px;
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

    .form-card {
        max-width: 850px;
        background: white;
        border: 1px solid #e8eee9;
        border-radius: 15px;
        padding: 25px;
    }

    .form-label {
        font-size: 12px;
        font-weight: 700;
        color: #35483c;
        margin-bottom: 8px;
    }

    .form-control,
    .form-select {
        border-color: #e1e9e3;
        border-radius: 9px;
        min-height: 43px;
        font-size: 13px;
    }

    textarea.form-control {
        min-height: 150px;
        resize: vertical;
    }

    .form-control:focus,
    .form-select:focus {
        border-color: #198754;
        box-shadow: 0 0 0 3px rgba(25, 135, 84, .10);
    }

    .form-text {
        color: #8a968e;
        font-size: 11px;
    }

    .recipient-options {
        display: grid;
        grid-template-columns: repeat(3, minmax(0, 1fr));
        gap: 12px;
    }

    .recipient-option {
        position: relative;
    }

    .recipient-option input {
        position: absolute;
        opacity: 0;
        pointer-events: none;
    }

    .recipient-label {
        display: block;
        height: 100%;
        border: 1px solid #e1e9e3;
        border-radius: 11px;
        padding: 15px;
        cursor: pointer;
        transition: .2s ease;
    }

    .recipient-option input:checked + .recipient-label {
        border-color: #198754;
        background: #f0f8f3;
        box-shadow: 0 0 0 2px rgba(25, 135, 84, .08);
    }

    .recipient-label i {
        display: block;
        font-size: 22px;
        color: #198754;
        margin-bottom: 9px;
    }

    .recipient-name {
        display: block;
        font-size: 13px;
        font-weight: 700;
        color: #304337;
    }

    .recipient-count {
        display: block;
        margin-top: 5px;
        font-size: 11px;
        color: #849087;
    }

    .form-actions {
        display: flex;
        justify-content: flex-end;
        gap: 10px;
        border-top: 1px solid #edf1ee;
        padding-top: 20px;
        margin-top: 24px;
    }

    .btn-cancel {
        padding: 10px 16px;
        border: 1px solid #e1e9e3;
        color: #66756b;
        text-decoration: none;
        border-radius: 8px;
        font-size: 12px;
        font-weight: 650;
    }

    .btn-send {
        border: none;
        background: #188653;
        color: white;
        padding: 10px 17px;
        border-radius: 8px;
        font-size: 12px;
        font-weight: 650;
    }

    .btn-send:hover {
        background: #126c42;
    }

    .info-note {
        background: #f0f7f2;
        color: #567361;
        padding: 13px 15px;
        border-radius: 9px;
        font-size: 11px;
        line-height: 1.6;
        margin-top: 20px;
    }

    @media (max-width: 650px) {
        .recipient-options {
            grid-template-columns: 1fr;
        }

        .form-card {
            padding: 18px;
        }
    }
</style>
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