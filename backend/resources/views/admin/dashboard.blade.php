
<!DOCTYPE html>
<html lang="id">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Admin | CFood</title>

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

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            background: var(--background);
            color: var(--text);
            font-family: Inter, "Segoe UI", Arial, sans-serif;
        }

        /* SIDEBAR */
        .sidebar {
            position: fixed;
            top: 0;
            bottom: 0;
            left: 0;
            z-index: 1000;
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
            letter-spacing: -.6px;
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

        .nav-item-cfood i {
            font-size: 17px;
        }

        .nav-item-cfood:hover {
            background: #f4f8f5;
            color: var(--green-dark);
        }

        .nav-item-cfood.active {
            background: var(--green-light);
            color: var(--green-dark);
            font-weight: 700;
        }

        .nav-item-cfood.disabled {
            opacity: .55;
            cursor: default;
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

        .sidebar-note i {
            color: var(--green);
        }

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

        .logout-button:hover {
            background: #fff1f1;
        }

        /* MOBILE BACKDROP */
        .sidebar-backdrop {
            display: none;
        }

        /* MAIN CONTENT */
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

        .breadcrumb-text {
            color: var(--muted);
            font-size: 12px;
        }

        .breadcrumb-text strong {
            color: var(--text);
        }

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

        .profile-name {
            font-size: 12px;
            font-weight: 700;
        }

        .profile-role {
            color: var(--muted);
            font-size: 10px;
        }

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
            letter-spacing: -.6px;
        }

        .page-description {
            margin: 0;
            color: var(--muted);
            font-size: 13px;
        }

        .date-label {
            padding: 10px 14px;
            border: 1px solid #e6ede8;
            border-radius: 9px;
            background: white;
            color: #66766b;
            font-size: 12px;
            white-space: nowrap;
        }

        /* STATISTICS */
        .stat-card {
            height: 100%;
            padding: 21px;
            border: 1px solid #eaf0eb;
            border-radius: 15px;
            background: white;
            box-shadow: 0 3px 12px rgba(35, 65, 45, .025);
            transition: .2s ease;
        }

        .stat-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 22px rgba(35, 65, 45, .06);
        }

        .stat-top {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .stat-icon {
            width: 43px;
            height: 43px;
            display: grid;
            place-items: center;
            border-radius: 12px;
            background: var(--green-light);
            color: var(--green);
            font-size: 20px;
        }

        .stat-label {
            margin-top: 19px;
            color: var(--muted);
            font-size: 12px;
        }

        .stat-value {
            margin-top: 5px;
            color: var(--text);
            font-size: 27px;
            font-weight: 750;
        }

        /* CONTENT CARDS */
        .section-card {
            height: 100%;
            overflow: hidden;
            border: 1px solid #eaf0eb;
            border-radius: 15px;
            background: white;
        }

        .section-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 20px 22px;
            border-bottom: 1px solid #edf1ee;
        }

        .section-title {
            margin: 0;
            font-size: 14px;
            font-weight: 750;
        }

        .section-caption {
            margin-top: 5px;
            color: var(--muted);
            font-size: 11px;
        }

        .empty-state {
            padding: 45px 20px;
            text-align: center;
        }

        .empty-icon {
            width: 52px;
            height: 52px;
            display: grid;
            place-items: center;
            margin: 0 auto 13px;
            border-radius: 15px;
            background: #f0f6f1;
            color: var(--green);
            font-size: 22px;
        }

        .empty-state h6 {
            font-size: 13px;
            font-weight: 700;
        }

        .empty-state p {
            margin: 5px 0 0;
            color: var(--muted);
            font-size: 11px;
        }

        .footer-text {
            padding: 22px 0 5px;
            color: #9aa69d;
            font-size: 11px;
        }

        .mobile-menu-button {
            display: none;
            border: 0;
            background: transparent;
            color: var(--green-dark);
            font-size: 23px;
        }

        /* RESPONSIVE */
        @media (max-width: 991px) {
            .sidebar {
                transform: translateX(-100%);
            }

            .sidebar.show {
                transform: translateX(0);
            }

            .sidebar-backdrop {
                position: fixed;
                inset: 0;
                z-index: 999;
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

            .main-content {
                margin-left: 0;
            }

            .mobile-menu-button {
                display: inline-block;
            }

            .topbar {
                padding: 0 20px;
            }

            .content-wrapper {
                padding: 27px 20px;
            }
        }

        @media (max-width: 575px) {
            .page-heading {
                flex-direction: column;
            }

            .page-title {
                font-size: 22px;
            }

            .profile-details {
                display: none;
            }

            .content-wrapper {
                padding: 23px 15px;
            }
        }
    </style>
</head>

<body>

    <!-- SIDEBAR -->
    <aside class="sidebar" id="sidebar">

        <div class="brand">
            <div class="brand-icon">
                <i class="bi bi-leaf-fill"></i>
            </div>

            <div>
                <h1 class="brand-name">CFood</h1>
                <div class="brand-subtitle">ADMINISTRATOR PANEL</div>
            </div>
        </div>

        <div class="menu-label">MENU UTAMA</div>

        <a href="{{ route('admin.dashboard') }}"
           class="nav-item-cfood active">
            <i class="bi bi-grid-1x2-fill"></i>
            <span>Dashboard</span>
        </a>

        <div class="menu-label mt-4">MANAJEMEN DATA</div>

        <a href="{{ route('admin.users.index') }}"
           class="nav-item-cfood">
            <i class="bi bi-people"></i>
            <span>Manajemen Pengguna</span>
        </a>

        <span class="nav-item-cfood disabled">
            <i class="bi bi-shop"></i>
            <span>Verifikasi Mitra</span>
        </span>

        <span class="nav-item-cfood disabled">
            <i class="bi bi-basket"></i>
            <span>Manajemen Produk</span>
        </span>

        <span class="nav-item-cfood disabled">
            <i class="bi bi-receipt"></i>
            <span>Manajemen Pesanan</span>
        </span>

        <div class="sidebar-bottom">
            <div class="sidebar-note">
                <i class="bi bi-recycle"></i>
                <p>
                    Bersama CFood, selamatkan makanan berlebih
                    dan kurangi food waste.
                </p>
            </div>

            <form action="{{ route('admin.logout') }}"
                  method="POST"
                  class="mt-3">
                @csrf

                <button type="submit" class="logout-button">
                    <i class="bi bi-box-arrow-left"></i>
                    <span>Keluar dari Dashboard</span>
                </button>
            </form>
        </div>

    </aside>

    <!-- BACKDROP DILETAKKAN DI LUAR SIDEBAR -->
    <div class="sidebar-backdrop" id="sidebarBackdrop"></div>

    <!-- MAIN CONTENT -->
    <main class="main-content">

        <header class="topbar">

            <div class="d-flex align-items-center gap-3">

                <button class="mobile-menu-button"
                        id="menuToggle"
                        type="button"
                        aria-label="Buka menu"
                        aria-expanded="false">
                    <i class="bi bi-list"></i>
                </button>

                <div class="breadcrumb-text">
                    Halaman / <strong>Dashboard</strong>
                </div>

            </div>

            <div class="admin-profile">

                <div class="profile-avatar">
                    {{ strtoupper(substr(Auth::user()->nama ?? 'A', 0, 1)) }}
                </div>

                <div class="profile-details">
                    <div class="profile-name">
                        {{ Auth::user()->nama }}
                    </div>

                    <div class="profile-role">
                        Administrator
                    </div>
                </div>

            </div>

        </header>

        <div class="content-wrapper">

            <!-- PAGE HEADING -->
            <section class="page-heading">

                <div>
                    <h2 class="page-title">Dashboard Overview</h2>

                    <p class="page-description">
                        Selamat datang kembali!
                        Berikut ringkasan aktivitas platform CFood.
                    </p>
                </div>

                <div class="date-label">
                    <i class="bi bi-calendar3 me-2"></i>
                    {{ now()->translatedFormat('d F Y') }}
                </div>

            </section>

            <!-- STATISTICS -->
            <section class="row g-3 mb-4">

                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="stat-card">
                        <div class="stat-top">
                            <div class="stat-icon">
                                <i class="bi bi-people"></i>
                            </div>
                        </div>

                        <div class="stat-label">Total Pengguna</div>

                        <div class="stat-value">
                            {{ number_format($totalUsers ?? 0) }}
                        </div>
                    </div>
                </div>

                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="stat-card">
                        <div class="stat-top">
                            <div class="stat-icon">
                                <i class="bi bi-shop"></i>
                            </div>
                        </div>

                        <div class="stat-label">Total Mitra</div>

                        <div class="stat-value">
                            {{ number_format($totalMitra ?? 0) }}
                        </div>
                    </div>
                </div>

                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="stat-card">
                        <div class="stat-top">
                            <div class="stat-icon">
                                <i class="bi bi-basket"></i>
                            </div>
                        </div>

                        <div class="stat-label">Total Produk</div>

                        <div class="stat-value">
                            {{ number_format($totalProduk ?? 0) }}
                        </div>
                    </div>
                </div>

                <div class="col-12 col-sm-6 col-xl-3">
                    <div class="stat-card">
                        <div class="stat-top">
                            <div class="stat-icon">
                                <i class="bi bi-receipt"></i>
                            </div>
                        </div>

                        <div class="stat-label">Total Pesanan</div>

                        <div class="stat-value">
                            {{ number_format($totalPesanan ?? 0) }}
                        </div>
                    </div>
                </div>

            </section>

            <!-- DASHBOARD INFORMATION -->
            <section class="row g-3">

                <div class="col-12 col-lg-7">

                    <div class="section-card">

                        <div class="section-header">

                            <div>
                                <h5 class="section-title">Aktivitas Terbaru</h5>

                                <div class="section-caption">
                                    Informasi aktivitas pada platform CFood
                                </div>
                            </div>

                            <i class="bi bi-clock-history text-success"></i>

                        </div>

                        <div class="empty-state">

                            <div class="empty-icon">
                                <i class="bi bi-activity"></i>
                            </div>

                            <h6>Aktivitas akan ditampilkan di sini</h6>

                            <p>
                                Riwayat aktivitas akan tersedia setelah
                                modul aktivitas diintegrasikan.
                            </p>

                        </div>

                    </div>

                </div>

                <div class="col-12 col-lg-5">

                    <div class="section-card">

                        <div class="section-header">

                            <div>
                                <h5 class="section-title">Informasi Sistem</h5>

                                <div class="section-caption">
                                    Informasi aplikasi CFood
                                </div>
                            </div>

                            <i class="bi bi-info-circle text-success"></i>

                        </div>

                        <div class="p-4">

                            <div class="d-flex align-items-center justify-content-between mb-3">
                                <span class="text-secondary small">Nama Aplikasi</span>
                                <strong class="small">CFood</strong>
                            </div>

                            <hr class="border-light">

                            <div class="d-flex align-items-center justify-content-between mb-3">
                                <span class="text-secondary small">Panel</span>
                                <strong class="small">Administrator</strong>
                            </div>

                            <hr class="border-light">

                            <div class="d-flex align-items-center justify-content-between mb-3">
                                <span class="text-secondary small">Status Login</span>

                                <span class="badge rounded-pill text-bg-success">
                                    Aktif
                                </span>
                            </div>

                            <hr class="border-light">

                            <div class="d-flex align-items-center justify-content-between">
                                <span class="text-secondary small">Pengguna Login</span>

                                <strong class="small">
                                    {{ Auth::user()->email }}
                                </strong>
                            </div>

                        </div>

                    </div>

                </div>

            </section>

            <!-- FOOTER -->
            <footer class="footer-text">
                © {{ date('Y') }} CFood Admin Panel.
                Platform Pengurangan Food Waste.
            </footer>

        </div>

    </main>

    <script>
        const menuToggle = document.getElementById('menuToggle');
        const sidebar = document.getElementById('sidebar');
        const sidebarBackdrop = document.getElementById('sidebarBackdrop');

        function openSidebar() {
            if (!sidebar || !sidebarBackdrop || !menuToggle) return;

            sidebar.classList.add('show');
            sidebarBackdrop.classList.add('show');
            menuToggle.setAttribute('aria-expanded', 'true');
        }

        function closeSidebar() {
            if (!sidebar || !sidebarBackdrop || !menuToggle) return;

            sidebar.classList.remove('show');
            sidebarBackdrop.classList.remove('show');
            menuToggle.setAttribute('aria-expanded', 'false');
        }

        menuToggle?.addEventListener('click', function () {
            if (sidebar?.classList.contains('show')) {
                closeSidebar();
            } else {
                openSidebar();
            }
        });

        sidebarBackdrop?.addEventListener('click', closeSidebar);

        document.addEventListener('keydown', function (event) {
            if (event.key === 'Escape') {
                closeSidebar();
            }
        });

        sidebar?.querySelectorAll('a').forEach(function (link) {
            link.addEventListener('click', closeSidebar);
        });
    </script>

</body>
</html>
