@extends('admin.layouts.app')

@section('title', 'Manajemen Produk | CFood')
@section('breadcrumb', 'Manajemen Produk')

@push('styles')
<link href="{{ asset('css/admin/products/products.css') }}" rel="stylesheet">
@endpush

@section('content')

<div class="page-heading mb-4">
    <div>
        <h2 class="page-title">Manajemen Produk</h2>
        <p class="page-description">
            Pantau dan kelola seluruh produk yang terdaftar dari Mitra CFood.
        </p>
    </div>
</div>

{{-- Statistik --}}
<div class="row g-3 mb-4">

    <div class="col-6 col-xl-3">
        <div class="product-stat">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <div class="product-stat-label">Total Produk</div>
                <div class="product-stat-icon">
                    <i class="bi bi-box-seam"></i>
                </div>
            </div>
            <div class="product-stat-value">
                {{ number_format($statistics['total']) }}
            </div>
        </div>
    </div>

    <div class="col-6 col-xl-3">
        <div class="product-stat">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <div class="product-stat-label">Produk Aktif</div>
                <div class="product-stat-icon">
                    <i class="bi bi-check-circle"></i>
                </div>
            </div>
            <div class="product-stat-value">
                {{ number_format($statistics['aktif']) }}
            </div>
        </div>
    </div>

    <div class="col-6 col-xl-3">
        <div class="product-stat">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <div class="product-stat-label">Stok Habis</div>
                <div class="product-stat-icon">
                    <i class="bi bi-box2"></i>
                </div>
            </div>
            <div class="product-stat-value">
                {{ number_format($statistics['habis']) }}
            </div>
        </div>
    </div>

    <div class="col-6 col-xl-3">
        <div class="product-stat">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <div class="product-stat-label">Kedaluwarsa</div>
                <div class="product-stat-icon">
                    <i class="bi bi-clock-history"></i>
                </div>
            </div>
            <div class="product-stat-value">
                {{ number_format($statistics['expired']) }}
            </div>
        </div>
    </div>

</div>

{{-- Notifikasi --}}
@if(session('success'))
<div class="alert alert-success alert-dismissible fade show" role="alert">
    <i class="bi bi-check-circle me-2"></i>
    {{ session('success') }}
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
</div>
@endif

@if(session('error'))
<div class="alert alert-danger alert-dismissible fade show" role="alert">
    <i class="bi bi-exclamation-circle me-2"></i>
    {{ session('error') }}
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
</div>
@endif

@if(session('info'))
<div class="alert alert-info alert-dismissible fade show" role="alert">
    {{ session('info') }}
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
</div>
@endif

{{-- Daftar produk --}}
<div class="product-table-card">

    <div class="product-toolbar">
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-3">
            <div>
                <h5 class="fw-bold mb-1">Daftar Produk</h5>
                <small class="text-muted">
                    Seluruh produk dari Mitra yang terdaftar.
                </small>
            </div>
            <span class="badge text-bg-light">
                {{ $products->total() }} Produk
            </span>
        </div>

        <form method="GET" action="{{ route('admin.products.index') }}">
            <div class="row g-2">

                <div class="col-lg-5 col-md-12 search-group">
                    <input
                        type="text"
                        name="search"
                        class="form-control"
                        placeholder="Cari nama produk, toko, atau pemilik..."
                        value="{{ request('search') }}">
                </div>

                <div class="col-lg-3 col-md-4 col-6">
                    <select name="kategori" class="form-select">
                        <option value="">Semua Kategori</option>
                        @foreach($categories as $category)
                        <option
                            value="{{ $category }}"
                            @selected(request('kategori')===$category)>
                            {{ $category }}
                        </option>
                        @endforeach
                    </select>
                </div>

                <div class="col-lg-2 col-md-4 col-6">
                    <select name="status" class="form-select">
                        <option value="">Semua Status</option>
                        <option value="aktif" @selected(request('status')==='aktif' )>
                            Aktif
                        </option>
                        <option value="habis" @selected(request('status')==='habis' )>
                            Habis
                        </option>
                        <option value="expired" @selected(request('status')==='expired' )>
                            Expired
                        </option>
                    </select>
                </div>

                <div class="col-lg-2 col-md-4 d-flex gap-2">
                    <button type="submit" class="btn btn-success flex-grow-1" title="Cari produk">
                        <i class="bi bi-search"></i> Cari
                    </button>

                    <a
                        href="{{ route('admin.products.index') }}"
                        class="btn btn-light border"
                        title="Reset filter">
                        <i class="bi bi-arrow-counterclockwise"></i>
                    </a>
                </div>

            </div>
        </form>
    </div>

    <div class="table-responsive">
        <table class="table product-table">
            <thead>
                <tr>
                    <th>Produk</th>
                    <th>Kategori</th>
                    <th>Harga</th>
                    <th>Stok</th>
                    <th>Kedaluwarsa</th>
                    <th>Status</th>
                    <th class="text-center">Aksi</th>
                </tr>
            </thead>

            <tbody>
                @forelse($products as $product)
                <tr>
                    <td>
                        <div class="d-flex align-items-center gap-3">
                            @if($product->foto)
                            <img
                                src="{{ asset('storage/' . $product->foto) }}"
                                alt="{{ $product->nama }}"
                                class="product-image">
                            @else
                            <div class="product-image d-grid place-items-center d-flex align-items-center justify-content-center">
                                <i class="bi bi-image text-muted fs-4"></i>
                            </div>
                            @endif

                            <div>
                                <div class="product-name">
                                    {{ $product->nama }}
                                </div>
                                <div class="product-store">
                                    {{ $product->mitra->nama_toko ?? 'Mitra tidak ditemukan' }}
                                </div>
                            </div>
                        </div>
                    </td>

                    <td>
                        {{ $product->kategori ?: '-' }}
                    </td>

                    <td>
                        <div class="product-price">
                            Rp{{ number_format((float) $product->harga_diskon, 0, ',', '.') }}
                        </div>
                        <div class="product-old-price">
                            Rp{{ number_format((float) $product->harga_original, 0, ',', '.') }}
                        </div>
                    </td>

                    <td>{{ $product->stok }}</td>

                    <td>
                        {{ $product->expired_formatted ?? '-' }}
                    </td>

                    <td>
                        <span class="product-status status-{{ $product->status }}">
                            {{ ucfirst($product->status) }}
                        </span>

                        @if($product->is_expired && $product->status !== 'expired')
                        <div class="text-danger mt-1" style="font-size: 10px;">
                            Melewati waktu kedaluwarsa
                        </div>
                        @endif
                    </td>

                    <td class="text-center">
                        <div class="d-flex justify-content-center gap-1">

                            <a
                                href="{{ route('admin.products.show', $product) }}"
                                class="product-action"
                                title="Detail">
                                <i class="bi bi-eye"></i>
                            </a>

                            <a
                                href="{{ route('admin.products.edit', $product) }}"
                                class="product-action"
                                title="Edit">
                                <i class="bi bi-pencil-square"></i>
                            </a>

                            <form
                                action="{{ route('admin.products.destroy', $product) }}"
                                method="POST"
                                onsubmit="return confirm('Apakah Anda yakin ingin menghapus produk {{ addslashes($product->nama) }}?')">
                                @csrf
                                @method('DELETE')

                                <button
                                    type="submit"
                                    class="product-action delete"
                                    title="Hapus">
                                    <i class="bi bi-trash"></i>
                                </button>
                            </form>

                        </div>
                    </td>
                </tr>
                @empty
                <tr>
                    <td colspan="7">
                        <div class="empty-product">
                            <i class="bi bi-box-seam"></i>
                            <strong>Produk tidak ditemukan</strong>
                            <div class="mt-1">
                                Belum ada produk yang sesuai dengan pencarian.
                            </div>
                        </div>
                    </td>
                </tr>
                @endforelse
            </tbody>
        </table>
    </div>

    @if($products->hasPages())
    <div class="pagination-wrapper">
        {{ $products->links('pagination::bootstrap-5') }}
    </div>
    @endif

</div>

@endsection