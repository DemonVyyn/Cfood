
@extends('admin.layouts.app')

@section('title', 'Verifikasi Mitra')

@section('content')
<div class="container-fluid py-4">

    <div class="mb-4">
        <h4 class="fw-bold mb-1">Verifikasi Mitra</h4>
        <p class="text-muted mb-0">
            Kelola dan periksa pendaftaran mitra CFood.
        </p>
    </div>

    @if(session('success'))
        <div class="alert alert-success">
            {{ session('success') }}
        </div>
    @endif

    @if(session('info'))
        <div class="alert alert-info">
            {{ session('info') }}
        </div>
    @endif

    @if($errors->any())
        <div class="alert alert-danger">
            {{ $errors->first() }}
        </div>
    @endif

    {{-- Statistik --}}
    <div class="row g-3 mb-4">
        <div class="col-md-3 col-6">
            <div class="card border-0 shadow-sm h-100">
                <div class="card-body">
                    <small class="text-muted">Total Mitra</small>
                    <h3 class="fw-bold mb-0">
                        {{ $statistics['total'] }}
                    </h3>
                </div>
            </div>
        </div>

        <div class="col-md-3 col-6">
            <div class="card border-0 shadow-sm h-100">
                <div class="card-body">
                    <small class="text-muted">Menunggu</small>
                    <h3 class="fw-bold text-warning mb-0">
                        {{ $statistics['pending'] }}
                    </h3>
                </div>
            </div>
        </div>

        <div class="col-md-3 col-6">
            <div class="card border-0 shadow-sm h-100">
                <div class="card-body">
                    <small class="text-muted">Disetujui</small>
                    <h3 class="fw-bold text-success mb-0">
                        {{ $statistics['verified'] }}
                    </h3>
                </div>
            </div>
        </div>

        <div class="col-md-3 col-6">
            <div class="card border-0 shadow-sm h-100">
                <div class="card-body">
                    <small class="text-muted">Ditolak</small>
                    <h3 class="fw-bold text-danger mb-0">
                        {{ $statistics['rejected'] }}
                    </h3>
                </div>
            </div>
        </div>
    </div>

    {{-- Filter dan pencarian --}}
    <div class="card border-0 shadow-sm mb-4">
        <div class="card-body">
            <form method="GET"
                  action="{{ route('admin.mitra.index') }}"
                  class="row g-2">

                <div class="col-md-6">
                    <input
                        type="text"
                        name="search"
                        class="form-control"
                        placeholder="Cari nama toko, pemilik, atau email..."
                        value="{{ request('search') }}"
                    >
                </div>

                <div class="col-md-3">
                    <select name="status" class="form-select">
                        <option value="">Semua Status</option>
                        <option value="pending"
                            @selected(request('status') === 'pending')>
                            Menunggu
                        </option>
                        <option value="verified"
                            @selected(request('status') === 'verified')>
                            Disetujui
                        </option>
                        <option value="rejected"
                            @selected(request('status') === 'rejected')>
                            Ditolak
                        </option>
                    </select>
                </div>

                <div class="col-md-3 d-flex gap-2">
                    <button type="submit" class="btn btn-success flex-fill">
                        <i class="bi bi-search"></i> Cari
                    </button>

                    <a href="{{ route('admin.mitra.index') }}"
                       class="btn btn-outline-secondary">
                        Reset
                    </a>
                </div>
            </form>
        </div>
    </div>

    {{-- Tabel mitra --}}
    <div class="card border-0 shadow-sm">
        <div class="card-header bg-white py-3">
            <h6 class="fw-bold mb-0">Daftar Pendaftaran Mitra</h6>
        </div>

        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th class="px-3">No.</th>
                        <th>Nama Toko</th>
                        <th>Pemilik</th>
                        <th>Email</th>
                        <th>Status</th>
                        <th>Tanggal Daftar</th>
                        <th>Aksi</th>
                    </tr>
                </thead>

                <tbody>
                    @forelse($mitras as $index => $mitra)
                        <tr>
                            <td class="px-3">
                                {{ $mitras->firstItem() + $index }}
                            </td>

                            <td class="fw-semibold">
                                {{ $mitra->nama_toko }}
                            </td>

                            <td>
                                {{ $mitra->user?->nama ?? '-' }}
                            </td>

                            <td>
                                {{ $mitra->user?->email ?? '-' }}
                            </td>

                            <td>
                                @if($mitra->status_verifikasi === 'pending')
                                    <span class="badge bg-warning text-dark">
                                        Menunggu
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
                            </td>

                            <td>
                                {{ $mitra->created_at?->format('d/m/Y') ?? '-' }}
                            </td>

                            <td>
                                <a href="{{ route('admin.mitra.show', $mitra->id) }}"
                                   class="btn btn-sm btn-outline-primary">
                                    <i class="bi bi-eye"></i> Detail
                                </a>
                            </td>
                        </tr>
                    @empty
                        <tr>
                            <td colspan="7"
                                class="text-center py-5 text-muted">
                                Belum ada data mitra.
                            </td>
                        </tr>
                    @endforelse
                </tbody>
            </table>
        </div>

        <div class="card-body">
            {{ $mitras->links() }}
        </div>
    </div>

</div>
@endsection
