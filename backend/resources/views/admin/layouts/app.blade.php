<!DOCTYPE html>
<html lang="id">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>@yield('title', 'Dashboard Admin | CFood')</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
        rel="stylesheet">

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
            overflow-y: auto;
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

        /* PAGE HEADING */
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

    @stack('styles')
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
            class="nav-item-cfood {{ request()->routeIs('admin.dashboard') ? 'active' : '' }}">
            <i class="bi bi-grid-1x2-fill"></i>
            <span>Dashboard</span>
        </a>

        <div class="menu-label mt-4">MANAJEMEN DATA</div>

        <a href="{{ route('admin.users.index') }}"
            class="nav-item-cfood {{ request()->routeIs('admin.users.*') ? 'active' : '' }}">
            <i class="bi bi-people"></i>
            <span>Manajemen Pengguna</span>
        </a>

        <a href="{{ route('admin.mitra.index') }}"
            class="nav-item-cfood {{ request()->routeIs('admin.mitra.*') ? 'active' : '' }}">
            <i class="bi bi-shop"></i>
            <span>Verifikasi Mitra</span>
        </a>

        <a href="{{ route('admin.products.index') }}"
            class="nav-item-cfood {{ request()->routeIs('admin.products.*') ? 'active' : '' }}">
            <i class="bi bi-box-seam"></i>
            <span>Manajemen Produk</span>
        </a>

        <a href="{{ route('admin.orders.index') }}"
            class="nav-item-cfood {{ request()->routeIs('admin.orders.*') ? 'active' : '' }}">
            <i class="bi bi-receipt"></i>
            <span>Manajemen Pesanan</span>
        </a>

        <a href="{{ route('admin.notifications.index') }}"
            class="nav-item-cfood {{ request()->routeIs('admin.notifications.*') ? 'active' : '' }}">
            <i class="bi bi-bell"></i>
            <span>Manajemen Notifikasi</span>
        </a>

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

    <!-- BACKDROP -->
    <div class="sidebar-backdrop" id="sidebarBackdrop"></div>

    <!-- MAIN CONTENT -->
    <main class="main-content">

        <!-- TOPBAR -->
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
                    Halaman / <strong>@yield('breadcrumb', 'Dashboard')</strong>
                </div>

            </div>

            <div class="admin-profile">

                <div class="profile-avatar">
                    {{ strtoupper(substr(Auth::user()->nama ?? 'A', 0, 1)) }}
                </div>

                <div class="profile-details">

                    <div class="profile-name">
                        {{ Auth::user()->nama ?? 'Administrator' }}
                    </div>

                    <div class="profile-role">
                        Administrator
                    </div>

                </div>

            </div>

        </header>

        <!-- PAGE CONTENT -->
        <div class="content-wrapper">

            @yield('content')

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

    @stack('scripts')

</body>
</html>