
@extends('admin.layouts.app')

@section('title', 'Detail Mitra')

@section('content')
<div class="container-fluid py-4">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h4 class="fw-bold mb-1">Detail Mitra</h4>
            <p class="text-muted mb-0">
                Periksa informasi usaha sebelum memberikan keputusan.
            </p>
        </div>

        <a href="{{ route('admin.mitra.index') }}"
           class="btn btn-outline-secondary">
            <i class="bi bi-arrow-left"></i> Kembali
        </a>
    </div>

    @if(session('success'))
        <div class="alert alert-success">
            {{ session('success') }}
        </div>
    @endif

    <div class="card border-0 shadow-sm">
        <div class="card-body p-4">

            @if($mitra->foto_toko)
                <div class="mb-4">
                    <img
                        src="{{ asset('storage/' . $mitra->foto_toko) }}"
                        alt="Foto toko {{ $mitra->nama_toko }}"
                        class="img-fluid rounded"
                        style="max-height: 250px; object-fit: cover;"
                    >
                </div>
            @endif

            <h5 class="fw-bold mb-3">Informasi Usaha</h5>

            <div class="row g-3 mb-4">
                <div class="col-md-6">
                    <small class="text-muted">Nama Toko</small>
                    <p class="fw-semibold">{{ $mitra->nama_toko }}</p>
                </div>

                <div class="col-md-6">
                    <small class="text-muted">Nomor Telepon Toko</small>
                    <p class="fw-semibold">
                        {{ $mitra->nomor_telepon ?? '-' }}
                    </p>
                </div>

                <div class="col-12">
                    <small class="text-muted">Deskripsi Toko</small>
                    <p>{{ $mitra->deskripsi_toko ?? '-' }}</p>
                </div>

                <div class="col-12">
                    <small class="text-muted">Alamat</small>
                    <p>{{ $mitra->alamat }}</p>
                </div>

                <div class="col-md-6">
                    <small class="text-muted">Latitude</small>
                    <p>{{ $mitra->latitude ?? '-' }}</p>
                </div>

                <div class="col-md-6">
                    <small class="text-muted">Longitude</small>
                    <p>{{ $mitra->longitude ?? '-' }}</p>
                </div>
            </div>

            <hr>

            <h5 class="fw-bold mb-3">Informasi Pemilik</h5>

            <div class="row g-3 mb-4">
                <div class="col-md-6">
                    <small class="text-muted">Nama Pemilik</small>
                    <p class="fw-semibold">
                        {{ $mitra->user?->nama ?? '-' }}
                    </p>
                </div>

                <div class="col-md-6">
                    <small class="text-muted">Email</small>
                    <p class="fw-semibold">
                        {{ $mitra->user?->email ?? '-' }}
                    </p>
                </div>

                <div class="col-md-6">
                    <small class="text-muted">Nomor HP Akun</small>
                    <p class="fw-semibold">
                        {{ $mitra->user?->phone ?? '-' }}
                    </p>
                </div>

                <div class="col-md-6">
                    <small class="text-muted">Tanggal Pendaftaran</small>
                    <p class="fw-semibold">
                        {{ $mitra->created_at?->format('d F Y H:i') ?? '-' }}
                    </p>
                </div>
            </div>

            <hr>

            <div class="mb-4">
                <small class="text-muted">Status Verifikasi</small>
                <div class="mt-2">
                    @if($mitra->status_verifikasi === 'pending')
                        <span class="badge bg-warning text-dark">
                            Menunggu Verifikasi
                        </span>
                    @elseif($mitra->status_verifikasi === 'verified')
                        <span class="badge bg-success">
                            Disetujui
                        </span>
                    @else
                        <span class="badge bg-danger">
                            Ditolak
                        </span>
                    @endif
                </div>
            </div>

            @if($mitra->status_verifikasi === 'pending')
                <div class="d-flex flex-wrap gap-2">

                    <form
                        action="{{ route('admin.mitra.verify', $mitra->id) }}"
                        method="POST"
                        onsubmit="return confirm('Apakah kamu yakin ingin menyetujui mitra ini?')"
                    >
                        @csrf
                        @method('PATCH')

                        <button type="submit" class="btn btn-success">
                            <i class="bi bi-check-circle"></i>
                            Setujui Mitra
                        </button>
                    </form>

                    <form
                        action="{{ route('admin.mitra.reject', $mitra->id) }}"
                        method="POST"
                        onsubmit="return confirm('Apakah kamu yakin ingin menolak pendaftaran mitra ini?')"
                    >
                        @csrf
                        @method('PATCH')

                        <button type="submit" class="btn btn-danger">
                            <i class="bi bi-x-circle"></i>
                            Tolak Mitra
                        </button>
                    </form>

                </div>
            @endif

        </div>
    </div>

</div>
@endsection
