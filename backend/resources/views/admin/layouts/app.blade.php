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
    <link href="{{ asset('css/admin/layouts/app.css') }}" rel="stylesheet">


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

        menuToggle?.addEventListener('click', function() {
            if (sidebar?.classList.contains('show')) {
                closeSidebar();
            } else {
                openSidebar();
            }
        });

        sidebarBackdrop?.addEventListener('click', closeSidebar);

        document.addEventListener('keydown', function(event) {
            if (event.key === 'Escape') {
                closeSidebar();
            }
        });

        sidebar?.querySelectorAll('a').forEach(function(link) {
            link.addEventListener('click', closeSidebar);
        });
    </script>

    @stack('scripts')

</body>

</html>