@extends('admin.layouts.app')

@section('title', 'Detail Produk | CFood')
@section('breadcrumb', 'Detail Produk')

@push('styles')
<style>
    .detail-card {
        background: #fff;
        border: 1px solid #e9eee9;
        border-radius: 14px;
        padding: 24px;
    }

    .detail-image {
        width: 100%;
        max-height: 300px;
        object-fit: cover;
        border-radius: 13px;
        background: #edf2ed;
    }

    .detail-label {
        color: #87938a;
        font-size: 12px;
        margin-bottom: 5px;
    }

    .detail-value {
        color: #263e2e;
        font-weight: 600;
        font-size: 14px;
        margin-bottom: 20px;
        overflow-wrap: anywhere;
    }

    .detail-price {
        color: #23814a;
        font-size: 22px;
        font-weight: 700;
    }

    .detail-old-price {
        color: #929c95;
        text-decoration: line-through;
        font-size: 13px;
    }
</style>
@endpush

@section('content')

<div class="page-heading mb-4">
    <div>
        <h2 class="page-title">Detail Produk</h2>
        <p class="page-description">
            Informasi lengkap produk yang terdaftar di CFood.
        </p>
    </div>
</div>

<div class="detail-card">

    <div class="row g-4">

        <div class="col-lg-4">
            @if($product->foto)
                <img
                    src="{{ asset('storage/' . $product->foto) }}"
                    alt="{{ $product->nama }}"
                    class="detail-image"
                >
            @else
                <div
                    class="detail-image d-flex align-items-center justify-content-center"
                    style="height: 230px;"
                >
                    <i class="bi bi-image text-muted fs-1"></i>
                </div>
            @endif
        </div>

        <div class="col-lg-8">

            <div class="d-flex justify-content-between align-items-start flex-wrap gap-2 mb-3">
                <div>
                    <h3 class="fw-bold mb-1">{{ $product->nama }}</h3>
                    <div class="text-muted small">
                        {{ $product->kategori ?: 'Tanpa kategori' }}
                    </div>
                </div>

                <span class="product-status status-{{ $product->status }}">
                    {{ ucfirst($product->status) }}
                </span>
            </div>

            <div class="detail-price">
                Rp{{ number_format((float) $product->harga_diskon, 0, ',', '.') }}
            </div>

            <div class="detail-old-price mb-4">
                Rp{{ number_format((float) $product->harga_original, 0, ',', '.') }}
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="detail-label">Nama Toko</div>
                    <div class="detail-value">
                        {{ $product->mitra->nama_toko ?? '-' }}
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="detail-label">Pemilik Toko</div>
                    <div class="detail-value">
                        {{ $product->mitra->user->nama ?? '-' }}
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="detail-label">Stok</div>
                    <div class="detail-value">
                        {{ $product->stok }} unit
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="detail-label">Waktu Kedaluwarsa</div>
                    <div class="detail-value">
                        {{ $product->waktu_expired?->format('d M Y H:i') ?? '-' }}
                    </div>
                </div>

                <div class="col-12">
                    <div class="detail-label">Deskripsi Produk</div>
                    <div class="detail-value" style="font-weight: 400; line-height: 1.7;">
                        {{ $product->deskripsi ?: 'Tidak ada deskripsi produk.' }}
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="detail-label">Tanggal Dibuat</div>
                    <div class="detail-value">
                        {{ $product->created_at?->format('d M Y H:i') ?? '-' }}
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="detail-label">Terakhir Diperbarui</div>
                    <div class="detail-value">
                        {{ $product->updated_at?->format('d M Y H:i') ?? '-' }}
                    </div>
                </div>
            </div>

            <hr>

            <div class="d-flex justify-content-end gap-2">
                <a
                    href="{{ route('admin.products.index') }}"
                    class="btn btn-light border px-4"
                >
                    Kembali
                </a>

                <a
                    href="{{ route('admin.products.edit', $product) }}"
                    class="btn btn-success px-4"
                >
                    <i class="bi bi-pencil-square me-1"></i>
                    Edit Produk
                </a>
            </div>

        </div>
    </div>
</div>

@endsection