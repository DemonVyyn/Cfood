@extends('admin.layouts.app')

@section('title', 'Edit Produk | CFood')
@section('breadcrumb', 'Edit Produk')

@push('styles')
<link href="{{ asset('css/admin/products/products_edit.css') }}" rel="stylesheet">
@endpush

@section('content')
<div class="page-heading mb-4">
    <div>
        <h2 class="page-title">Edit Produk</h2>
        <p class="page-description">
            Perbarui informasi produk yang terdaftar di CFood.
        </p>
    </div>
</div>

@if($errors->any())
    <div class="alert alert-danger">
        <strong>Periksa kembali data yang dimasukkan:</strong>
        <ul class="mb-0 mt-2">
            @foreach($errors->all() as $error)
                <li>{{ $error }}</li>
            @endforeach
        </ul>
    </div>
@endif

<div class="form-card">

    <div class="mb-4">
        <div class="form-section-title">Informasi Produk</div>

        <div class="row g-3">

            <div class="col-md-6">
                <label class="form-label">Nama Toko</label>
                <input
                    type="text"
                    class="form-control"
                    value="{{ $product->mitra->nama_toko ?? 'Mitra tidak ditemukan' }}"
                    disabled
                >
                <div class="form-hint">
                    Produk tetap menjadi milik Mitra yang terdaftar.
                </div>
            </div>

            <div class="col-md-6">
                <label class="form-label">Nama Pemilik</label>
                <input
                    type="text"
                    class="form-control"
                    value="{{ $product->mitra->user->nama ?? '-' }}"
                    disabled
                >
            </div>

        </div>
    </div>

    <hr class="my-4">

    <form
        action="{{ route('admin.products.update', $product) }}"
        method="POST"
        enctype="multipart/form-data"
    >
        @csrf
        @method('PUT')

        <div class="form-section-title">Data Produk</div>

        <div class="row g-3">

            <div class="col-md-6">
                <label class="form-label">Nama Produk <span class="text-danger">*</span></label>
                <input
                    type="text"
                    name="nama"
                    class="form-control"
                    value="{{ old('nama', $product->nama) }}"
                    required
                >
            </div>

            <div class="col-md-6">
                <label class="form-label">Kategori</label>
                <input
                    type="text"
                    name="kategori"
                    class="form-control"
                    value="{{ old('kategori', $product->kategori) }}"
                    placeholder="Contoh: Makanan, Minuman"
                >
            </div>

            <div class="col-12">
                <label class="form-label">Deskripsi Produk</label>
                <textarea
                    name="deskripsi"
                    class="form-control"
                    placeholder="Masukkan deskripsi produk..."
                >{{ old('deskripsi', $product->deskripsi) }}</textarea>
            </div>

            <div class="col-md-6">
                <label class="form-label">Harga Normal (Rp) <span class="text-danger">*</span></label>
                <input
                    type="number"
                    name="harga_original"
                    class="form-control"
                    min="0"
                    step="0.01"
                    value="{{ old('harga_original', $product->harga_original) }}"
                    required
                >
            </div>

            <div class="col-md-6">
                <label class="form-label">Harga Diskon (Rp) <span class="text-danger">*</span></label>
                <input
                    type="number"
                    name="harga_diskon"
                    class="form-control"
                    min="0"
                    step="0.01"
                    value="{{ old('harga_diskon', $product->harga_diskon) }}"
                    required
                >
                <div class="form-hint">
                    Harga diskon tidak boleh melebihi harga normal.
                </div>
            </div>

            <div class="col-md-6">
                <label class="form-label">Stok <span class="text-danger">*</span></label>
                <input
                    type="number"
                    name="stok"
                    class="form-control"
                    min="0"
                    value="{{ old('stok', $product->stok) }}"
                    required
                >
            </div>

            <div class="col-md-6">
                <label class="form-label">Waktu Kedaluwarsa <span class="text-danger">*</span></label>
                <input
                    type="datetime-local"
                    name="waktu_expired"
                    class="form-control"
                    value="{{ old('waktu_expired', $product->waktu_expired?->format('Y-m-d\TH:i')) }}"
                    required
                >
            </div>

            <div class="col-md-6">
                <label class="form-label">Status Produk <span class="text-danger">*</span></label>
                <select name="status" class="form-select" required>
                    <option value="aktif" @selected(old('status', $product->status) === 'aktif')>
                        Aktif
                    </option>
                    <option value="habis" @selected(old('status', $product->status) === 'habis')>
                        Habis
                    </option>
                    <option value="expired" @selected(old('status', $product->status) === 'expired')>
                        Expired
                    </option>
                </select>
            </div>

            <div class="col-md-6">
                <label class="form-label">Foto Produk</label>
                <input
                    type="file"
                    name="foto"
                    class="form-control"
                    accept=".jpg,.jpeg,.png,.webp"
                >
                <div class="form-hint">
                    Format JPG, JPEG, PNG, WEBP. Maksimal 2 MB.
                </div>
            </div>

            @if($product->foto)
                <div class="col-12">
                    <label class="form-label d-block">Foto Saat Ini</label>
                    <img
                        src="{{ asset('storage/' . $product->foto) }}"
                        alt="{{ $product->nama }}"
                        class="current-product-image"
                    >
                </div>
            @endif

        </div>

        <hr class="my-4">

        <div class="d-flex justify-content-end gap-2">
            <a
                href="{{ route('admin.products.index') }}"
                class="btn btn-light border px-4"
            >
                Batal
            </a>

            <button type="submit" class="btn btn-success px-4">
                <i class="bi bi-save me-1"></i>
                Simpan Perubahan
            </button>
        </div>

    </form>
</div>

@endsection