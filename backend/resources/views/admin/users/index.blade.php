
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manajemen Pengguna | CFood</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

    <style>
        :root {
            --green: #198754;
            --green-dark: #145c38;
            --green-light: #eaf5ee;
            --background: #f5f8f6;
            --text: #26372d;
            --muted: #849188;
            --sidebar-width: 255px;
        }

        * { box-sizing: border-box; }

        body {
            margin: 0;
            background: var(--background);
            color: var(--text);
            font-family: Inter, "Segoe UI", Arial, sans-serif;
        }

        .sidebar {
            position: fixed;
            inset: 0 auto 0 0;
            z-index: 1050;
            display: flex;
            flex-direction: column;
            width: var(--sidebar-width);
            padding: 25px 18px;
            background: #fff;
            border-right: 1px solid #e9efea;
            transition: transform .25s ease;
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 2px 10px 32px;
        }

        .brand-icon {
            width: 42px;
            height: 42px;
            display: grid;
            place-items: center;
            border-radius: 13px;
            background: var(--green);
            color: white;
            font-size: 21px;
        }

        .brand-name {
            margin: 0;
            color: var(--green-dark);
            font-size: 21px;
            font-weight: 800;
        }

        .brand-subtitle {
            color: var(--muted);
            font-size: 10px;
            letter-spacing: .7px;
        }

        .menu-label {
            padding: 0 12px;
            margin: 10px 0 12px;
            color: #a1aca4;
            font-size: 10px;
            font-weight: 700;
            letter-spacing: 1.2px;
        }

        .nav-item-cfood {
            display: flex;
            align-items: center;
            gap: 13px;
            padding: 12px 14px;
            margin-bottom: 5px;
            border-radius: 10px;
            color: #748178;
            font-size: 13px;
            font-weight: 550;
            text-decoration: none;
            transition: .2s ease;
        }

        .nav-item-cfood i { font-size: 17px; }

        .nav-item-cfood:hover,
        .nav-item-cfood.active {
            background: var(--green-light);
            color: var(--green-dark);
            font-weight: 700;
        }

        .sidebar-bottom {
            margin-top: auto;
            padding: 15px 10px 0;
            border-top: 1px solid #edf1ee;
        }

        .sidebar-note {
            padding: 14px;
            border-radius: 12px;
            background: #f1f7f2;
        }

        .sidebar-note i { color: var(--green); }

        .sidebar-note p {
            margin: 8px 0 0;
            color: #708077;
            font-size: 11px;
            line-height: 1.6;
        }

        .logout-button {
            width: 100%;
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 11px 14px;
            border: 0;
            border-radius: 10px;
            background: transparent;
            color: #ba5555;
            font-size: 13px;
            text-align: left;
        }

        .logout-button:hover { background: #fff1f1; }

        .main-content {
            min-height: 100vh;
            margin-left: var(--sidebar-width);
        }

        .topbar {
            height: 76px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 35px;
            background: white;
            border-bottom: 1px solid #e9efea;
        }

        .mobile-menu-button {
            display: none;
            border: 0;
            background: transparent;
            color: var(--green-dark);
            font-size: 23px;
        }

        .breadcrumb-text {
            color: var(--muted);
            font-size: 12px;
        }

        .breadcrumb-text strong { color: var(--text); }

        .admin-profile {
            display: flex;
            align-items: center;
            gap: 11px;
        }

        .profile-avatar {
            width: 38px;
            height: 38px;
            display: grid;
            place-items: center;
            border-radius: 50%;
            background: var(--green-light);
            color: var(--green);
            font-weight: 750;
        }

        .profile-name { font-size: 12px; font-weight: 700; }
        .profile-role { color: var(--muted); font-size: 10px; }

        .content-wrapper {
            max-width: 1500px;
            padding: 34px 35px;
            margin: auto;
        }

        .page-heading {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 20px;
            margin-bottom: 27px;
        }

        .page-title {
            margin: 0 0 7px;
            font-size: 25px;
            font-weight: 750;
        }

        .page-description {
            margin: 0;
            color: var(--muted);
            font-size: 13px;
        }

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

        .toolbar-title { margin: 0; font-size: 14px; font-weight: 750; }

        .toolbar-caption {
            margin-top: 5px;
            color: var(--muted);
            font-size: 11px;
        }

        .search-input,
        .filter-select {
            min-height: 42px;
            border: 1px solid #e4ebe6;
            border-radius: 9px;
            font-size: 12px;
        }

        .search-input:focus,
        .filter-select:focus {
            border-color: var(--green);
            box-shadow: 0 0 0 .2rem rgba(25, 135, 84, .1);
        }

        .btn-search {
            min-height: 42px;
            padding: 0 16px;
            border-radius: 9px;
            background: var(--green);
            color: white;
            font-size: 12px;
        }

        .btn-search:hover { background: var(--green-dark); color: white; }

        .table { margin: 0; }

        .table thead th {
            padding: 15px 18px;
            background: #f8faf8;
            color: #78867c;
            font-size: 11px;
            font-weight: 700;
            white-space: nowrap;
        }

        .table tbody td {
            padding: 15px 18px;
            color: #526157;
            font-size: 12px;
            vertical-align: middle;
        }

        .user-name { color: var(--text); font-weight: 700; }
        .user-email { margin-top: 3px; color: var(--muted); font-size: 11px; }

        .user-avatar {
            width: 35px;
            height: 35px;
            display: grid;
            place-items: center;
            border-radius: 10px;
            background: var(--green-light);
            color: var(--green-dark);
            font-weight: 700;
        }

        .role-badge,
        .status-badge {
            display: inline-block;
            padding: 6px 10px;
            border-radius: 20px;
            font-size: 10px;
            font-weight: 700;
        }

        .role-customer { background: #eaf2ff; color: #3767a8; }
        .role-mitra { background: #fff3df; color: #a56a13; }
        .role-admin { background: #f0eaff; color: #7045a5; }
        .status-active { background: #e7f6ec; color: #198754; }
        .status-suspended { background: #fff0f0; color: #bd4c4c; }

        .pagination-wrapper { padding: 18px 20px; }
        .pagination { margin: 0; }
        .page-link { color: var(--green-dark); font-size: 12px; }
        .page-item.active .page-link {
            background: var(--green);
            border-color: var(--green);
        }

        .empty-state {
            padding: 45px 20px;
            text-align: center;
            color: var(--muted);
        }

        .empty-state i {
            display: block;
            margin-bottom: 12px;
            color: var(--green);
            font-size: 30px;
        }

        .footer-text {
            padding: 22px 0 5px;
            color: #9aa69d;
            font-size: 11px;
        }

        .sidebar-backdrop {
            display: none;
        }

        @media (max-width: 991px) {
            .sidebar { transform: translateX(-100%); }
            .sidebar.show { transform: translateX(0); }

            .sidebar-backdrop {
                position: fixed;
                inset: 0;
                z-index: 1040;
                display: block;
                background: rgba(20, 40, 27, .35);
                opacity: 0;
                visibility: hidden;
                transition: opacity .25s ease, visibility .25s ease;
            }

            .sidebar-backdrop.show {
                opacity: 1;
                visibility: visible;
            }

            .main-content { margin-left: 0; }
            .mobile-menu-button { display: inline-block; }
            .topbar { padding: 0 20px; }
            .content-wrapper { padding: 27px 20px; }
        }

        @media (max-width: 575px) {
            .page-heading { flex-direction: column; }
            .page-title { font-size: 22px; }
            .profile-details { display: none; }
            .content-wrapper { padding: 23px 15px; }
            .toolbar { align-items: flex-start; flex-direction: column; }
            .toolbar form { width: 100%; }
            .toolbar .search-group { flex-wrap: wrap; }
        }
    </style>
</head>

<body>

<aside class="sidebar" id="sidebar">
    <div class="brand">
        <div class="brand-icon"><i class="bi bi-leaf-fill"></i></div>
        <div>
            <h1 class="brand-name">CFood</h1>
            <div class="brand-subtitle">ADMINISTRATOR PANEL</div>
        </div>
    </div>

    <div class="menu-label">MENU UTAMA</div>

    <a href="{{ route('admin.dashboard') }}" class="nav-item-cfood">
        <i class="bi bi-grid-1x2-fill"></i>
        <span>Dashboard</span>
    </a>

    <div class="menu-label mt-4">MANAJEMEN DATA</div>

    <a href="{{ route('admin.users.index') }}" class="nav-item-cfood active">
        <i class="bi bi-people"></i>
        <span>Manajemen Pengguna</span>
    </a>

    <span class="nav-item-cfood">
        <i class="bi bi-shop"></i>
        <span>Verifikasi Mitra</span>
    </span>

    <span class="nav-item-cfood">
        <i class="bi bi-basket"></i>
        <span>Manajemen Produk</span>
    </span>

    <span class="nav-item-cfood">
        <i class="bi bi-receipt"></i>
        <span>Manajemen Pesanan</span>
    </span>

    <div class="sidebar-bottom">
        <div class="sidebar-note">
            <i class="bi bi-recycle"></i>
            <p>Bersama CFood, selamatkan makanan berlebih dan kurangi food waste.</p>
        </div>

        <form action="{{ route('admin.logout') }}" method="POST" class="mt-3">
            @csrf
            <button type="submit" class="logout-button">
                <i class="bi bi-box-arrow-left"></i>
                <span>Keluar dari Dashboard</span>
            </button>
        </form>
    </div>
</aside>

<div class="sidebar-backdrop" id="sidebarBackdrop"></div>

<main class="main-content">
    <header class="topbar">
        <div class="d-flex align-items-center gap-3">
            <button class="mobile-menu-button" id="menuToggle"
                    type="button" aria-label="Buka menu"
                    aria-expanded="false">
                <i class="bi bi-list"></i>
            </button>

            <div class="breadcrumb-text">
                Halaman / <strong>Manajemen Pengguna</strong>
            </div>
        </div>

        <div class="admin-profile">
            <div class="profile-avatar">
                {{ strtoupper(substr(Auth::user()->nama ?? 'A', 0, 1)) }}
            </div>
            <div class="profile-details">
                <div class="profile-name">{{ Auth::user()->nama }}</div>
                <div class="profile-role">Administrator</div>
            </div>
        </div>
    </header>

    <div class="content-wrapper">
        <section class="page-heading">
            <div>
                <h2 class="page-title">Manajemen Pengguna</h2>
                <p class="page-description">
                    Kelola dan pantau akun pengguna yang terdaftar di platform CFood.
                </p>
            </div>
        </section>

        @if (session('success'))
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                {{ session('success') }}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        @endif

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
                            <i class="bi bi-search me-1"></i> Cari
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
                        </tr>
                    </thead>

                    <tbody>
                        @forelse ($users as $user)
                            <tr>
                                <td>{{ $users->firstItem() + $loop->index }}</td>

                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="user-avatar">
                                            {{ strtoupper(substr($user->nama, 0, 1)) }}
                                        </div>
                                        <div>
                                            <div class="user-name">{{ $user->nama }}</div>
                                            <div class="user-email">{{ $user->email }}</div>
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
                                        <span class="status-badge status-active">Aktif</span>
                                    @else
                                        <span class="status-badge status-suspended">Ditangguhkan</span>
                                    @endif
                                </td>

                                <td>{{ $user->created_at?->format('d M Y') ?? '-' }}</td>
                            </tr>
                        @empty
                            <tr>
                                <td colspan="6">
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

            @if ($users->hasPages())
                <div class="pagination-wrapper">
                    {{ $users->links('pagination::bootstrap-5') }}
                </div>
            @endif
        </section>

        <footer class="footer-text">
            © {{ date('Y') }} CFood Admin Panel. Platform Pengurangan Food Waste.
        </footer>
    </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    const menuToggle = document.getElementById('menuToggle');
    const sidebar = document.getElementById('sidebar');
    const sidebarBackdrop = document.getElementById('sidebarBackdrop');

    function openSidebar() {
        sidebar.classList.add('show');
        sidebarBackdrop.classList.add('show');
        menuToggle.setAttribute('aria-expanded', 'true');
    }

    function closeSidebar() {
        sidebar.classList.remove('show');
        sidebarBackdrop.classList.remove('show');
        menuToggle.setAttribute('aria-expanded', 'false');
    }

    menuToggle?.addEventListener('click', function (event) {
        event.stopPropagation();

        if (sidebar.classList.contains('show')) {
            closeSidebar();
        } else {
            openSidebar();
        }
    });

    // Klik area di luar sidebar akan menutup menu.
    document.addEventListener('click', function (event) {
        if (
            sidebar.classList.contains('show') &&
            !sidebar.contains(event.target) &&
            !menuToggle.contains(event.target)
        ) {
            closeSidebar();
        }
    });

    // Klik backdrop juga menutup sidebar.
    sidebarBackdrop.addEventListener('click', closeSidebar);

    // Tombol Escape menutup sidebar.
    document.addEventListener('keydown', function (event) {
        if (event.key === 'Escape') {
            closeSidebar();
        }
    });

    // Setelah memilih menu navigasi, sidebar ditutup pada layar kecil.
    sidebar.querySelectorAll('a').forEach(function (link) {
        link.addEventListener('click', function () {
            closeSidebar();
        });
    });
</script>

</body>
</html>
