
@extends('admin.layouts.app')

@section('title', 'Manajemen Pengguna | CFood')
@section('breadcrumb', 'Manajemen Pengguna')

@push('styles')
@push('styles')
<link href="{{ asset('css/admin/users/users.css') }}" rel="stylesheet">
@endpush

@endpush

@section('content')

    {{-- PAGE HEADING --}}
    <section class="page-heading">
        <div>
            <h2 class="page-title">Manajemen Pengguna</h2>
            <p class="page-description">
                Kelola dan pantau akun pengguna yang terdaftar di platform CFood.
            </p>
        </div>

        <a href="{{ route('admin.users.create') }}" class="btn-add-user">
            <i class="bi bi-person-plus-fill"></i>
            Tambah Pengguna
        </a>
    </section>

    {{-- NOTIFICATION --}}
    @if (session('success'))
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i>
            {{ session('success') }}

            <button type="button" class="btn-close"
                data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    @endif

    @if (session('error'))
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            {{ session('error') }}

            <button type="button" class="btn-close"
                data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    @endif

    {{-- USER TABLE --}}
    <section class="section-card">

        <div class="toolbar">
            <div>
                <h5 class="toolbar-title">Daftar Pengguna</h5>
                <div class="toolbar-caption">
                    Menampilkan {{ $users->total() }} akun terdaftar
                </div>
            </div>

            <form action="{{ route('admin.users.index') }}" method="GET">
                <div class="d-flex align-items-center gap-2 search-group">

                    <input
                        type="text"
                        name="search"
                        class="form-control search-input"
                        placeholder="Cari nama, email, atau telepon..."
                        value="{{ request('search') }}"
                    >

                    <select name="role" class="form-select filter-select">
                        <option value="">Semua Role</option>
                        <option value="customer" @selected(request('role') === 'customer')>
                            Customer
                        </option>
                        <option value="mitra" @selected(request('role') === 'mitra')>
                            Mitra
                        </option>
                        <option value="admin" @selected(request('role') === 'admin')>
                            Admin
                        </option>
                    </select>

                    <button type="submit" class="btn btn-search">
                        <i class="bi bi-search me-1"></i>
                        Cari
                    </button>

                </div>
            </form>
        </div>

        <div class="table-responsive">
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>NO.</th>
                        <th>PENGGUNA</th>
                        <th>NOMOR TELEPON</th>
                        <th>ROLE</th>
                        <th>STATUS</th>
                        <th>TANGGAL DAFTAR</th>
                        <th>AKSI</th>
                    </tr>
                </thead>

                <tbody>
                    @forelse ($users as $user)
                        <tr>
                            <td>
                                {{ $users->firstItem() + $loop->index }}
                            </td>

                            <td>
                                <div class="d-flex align-items-center gap-2">
                                    <div class="user-avatar">
                                        {{ strtoupper(substr($user->nama, 0, 1)) }}
                                    </div>

                                    <div>
                                        <div class="user-name">
                                            {{ $user->nama }}
                                        </div>

                                        <div class="user-email">
                                            {{ $user->email }}
                                        </div>
                                    </div>
                                </div>
                            </td>

                            <td>{{ $user->phone }}</td>

                            <td>
                                <span class="role-badge role-{{ $user->role }}">
                                    {{ ucfirst($user->role) }}
                                </span>
                            </td>

                            <td>
                                @if ($user->status === 'active')
                                    <span class="status-badge status-active">
                                        Aktif
                                    </span>
                                @else
                                    <span class="status-badge status-suspended">
                                        Ditangguhkan
                                    </span>
                                @endif
                            </td>

                            <td>
                                {{ $user->created_at?->format('d M Y') ?? '-' }}
                            </td>

                            <td>
                                <a
                                    href="{{ route('admin.users.edit', $user->id) }}"
                                    class="btn-edit"
                                >
                                    <i class="bi bi-pencil-square"></i>
                                    Edit
                                </a>
                            </td>
                        </tr>
                    @empty
                        <tr>
                            <td colspan="7">
                                <div class="empty-state">
                                    <i class="bi bi-people"></i>
                                    <strong>Pengguna tidak ditemukan</strong>
                                    <div class="small mt-1">
                                        Coba ubah kata kunci pencarian atau filter role.
                                    </div>
                                </div>
                            </td>
                        </tr>
                    @endforelse
                </tbody>
            </table>
        </div>

        {{-- PAGINATION --}}
        @if ($users->hasPages())
            <div class="pagination-wrapper">
                {{ $users->withQueryString()->links('pagination::bootstrap-5') }}
            </div>
        @endif

    </section>

@endsection
