
@extends('admin.layouts.app')

@section('title', 'Manajemen Pengguna | CFood')
@section('breadcrumb', 'Manajemen Pengguna')

@push('styles')
<style>
    /* PAGE HEADING */
    .page-heading {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 20px;
        margin-bottom: 27px;
    }

    .page-title {
        margin: 0 0 7px;
        font-size: 25px;
        font-weight: 750;
        color: var(--text, #26372d);
    }

    .page-description {
        margin: 0;
        color: var(--muted, #849188);
        font-size: 13px;
    }

    .btn-add-user {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        padding: 11px 17px;
        border: 0;
        border-radius: 9px;
        background: var(--green, #198754);
        color: white;
        font-size: 12px;
        font-weight: 650;
        text-decoration: none;
        white-space: nowrap;
        transition: .2s ease;
    }

    .btn-add-user:hover {
        background: var(--green-dark, #145c38);
        color: white;
    }

    /* TABLE CARD */
    .section-card {
        overflow: hidden;
        border: 1px solid #eaf0eb;
        border-radius: 15px;
        background: white;
        box-shadow: 0 3px 12px rgba(35, 65, 45, .025);
    }

    .toolbar {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 12px;
        padding: 20px 22px;
        border-bottom: 1px solid #edf1ee;
    }

    .toolbar-title {
        margin: 0;
        font-size: 14px;
        font-weight: 750;
        color: var(--text, #26372d);
    }

    .toolbar-caption {
        margin-top: 5px;
        color: var(--muted, #849188);
        font-size: 11px;
    }

    /* SEARCH */
    .search-input,
    .filter-select {
        min-height: 42px;
        border: 1px solid #e4ebe6;
        border-radius: 9px;
        font-size: 12px;
    }

    .search-input:focus,
    .filter-select:focus {
        border-color: var(--green, #198754);
        box-shadow: 0 0 0 .2rem rgba(25, 135, 84, .1);
    }

    .btn-search {
        min-height: 42px;
        padding: 0 16px;
        border: 0;
        border-radius: 9px;
        background: var(--green, #198754);
        color: white;
        font-size: 12px;
    }

    .btn-search:hover {
        background: var(--green-dark, #145c38);
        color: white;
    }

    /* TABLE */
    .section-card .table {
        margin: 0;
    }

    .section-card .table thead th {
        padding: 15px 18px;
        background: #f8faf8;
        color: #78867c;
        font-size: 11px;
        font-weight: 700;
        white-space: nowrap;
    }

    .section-card .table tbody td {
        padding: 15px 18px;
        color: #526157;
        font-size: 12px;
        vertical-align: middle;
    }

    .user-name {
        color: var(--text, #26372d);
        font-weight: 700;
    }

    .user-email {
        margin-top: 3px;
        color: var(--muted, #849188);
        font-size: 11px;
    }

    .user-avatar {
        width: 35px;
        height: 35px;
        display: grid;
        place-items: center;
        flex-shrink: 0;
        border-radius: 10px;
        background: var(--green-light, #eaf5ee);
        color: var(--green-dark, #145c38);
        font-weight: 700;
    }

    /* ROLE AND STATUS */
    .role-badge,
    .status-badge {
        display: inline-block;
        padding: 6px 10px;
        border-radius: 20px;
        font-size: 10px;
        font-weight: 700;
    }

    .role-customer {
        background: #eaf2ff;
        color: #3767a8;
    }

    .role-mitra {
        background: #fff3df;
        color: #a56a13;
    }

    .role-admin {
        background: #f0eaff;
        color: #7045a5;
    }

    .status-active {
        background: #e7f6ec;
        color: #198754;
    }

    .status-suspended {
        background: #fff0f0;
        color: #bd4c4c;
    }

    /* EDIT BUTTON */
    .btn-edit {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 7px 11px;
        border: 1px solid #cfe6d7;
        border-radius: 7px;
        background: #f1f8f3;
        color: var(--green-dark, #145c38);
        font-size: 11px;
        font-weight: 650;
        text-decoration: none;
        white-space: nowrap;
    }

    .btn-edit:hover {
        background: var(--green, #198754);
        border-color: var(--green, #198754);
        color: white;
    }

    /* PAGINATION */
    .pagination-wrapper {
        padding: 18px 20px;
    }

    .pagination {
        margin: 0;
    }

    .pagination .page-link {
        color: var(--green-dark, #145c38);
        font-size: 12px;
    }

    .pagination .page-item.active .page-link {
        background: var(--green, #198754);
        border-color: var(--green, #198754);
        color: white;
    }

    /* EMPTY STATE */
    .empty-state {
        padding: 45px 20px;
        text-align: center;
        color: var(--muted, #849188);
    }

    .empty-state i {
        display: block;
        margin-bottom: 12px;
        color: var(--green, #198754);
        font-size: 30px;
    }

    /* RESPONSIVE */
    @media (max-width: 575px) {
        .page-heading {
            align-items: flex-start;
            flex-direction: column;
        }

        .page-title {
            font-size: 22px;
        }

        .toolbar {
            align-items: flex-start;
            flex-direction: column;
        }

        .toolbar form {
            width: 100%;
        }

        .search-group {
            flex-wrap: wrap;
        }

        .search-group input {
            width: 100%;
        }

        .search-group select {
            flex: 1;
        }
    }
</style>
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
