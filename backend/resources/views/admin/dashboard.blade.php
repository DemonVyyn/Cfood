@extends('admin.layouts.app')

@section('title', 'Dashboard Admin | CFood')

@section('breadcrumb', 'Dashboard')

@section('content')

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

        <!-- TOTAL PENGGUNA -->
        <div class="col-12 col-sm-6 col-xl-3">
            <div class="stat-card">

                <div class="stat-top">
                    <div class="stat-icon">
                        <i class="bi bi-people"></i>
                    </div>
                </div>

                <div class="stat-label">
                    Total Pengguna
                </div>

                <div class="stat-value">
                    {{ number_format($totalUsers ?? 0) }}
                </div>

            </div>
        </div>


        <!-- TOTAL MITRA -->
        <div class="col-12 col-sm-6 col-xl-3">
            <div class="stat-card">

                <div class="stat-top">
                    <div class="stat-icon">
                        <i class="bi bi-shop"></i>
                    </div>
                </div>

                <div class="stat-label">
                    Total Mitra
                </div>

                <div class="stat-value">
                    {{ number_format($totalMitra ?? 0) }}
                </div>

            </div>
        </div>


        <!-- TOTAL PRODUK -->
        <div class="col-12 col-sm-6 col-xl-3">
            <div class="stat-card">

                <div class="stat-top">
                    <div class="stat-icon">
                        <i class="bi bi-basket"></i>
                    </div>
                </div>

                <div class="stat-label">
                    Total Produk
                </div>

                <div class="stat-value">
                    {{ number_format($totalProduk ?? 0) }}
                </div>

            </div>
        </div>


        <!-- TOTAL PESANAN -->
        <div class="col-12 col-sm-6 col-xl-3">
            <div class="stat-card">

                <div class="stat-top">
                    <div class="stat-icon">
                        <i class="bi bi-receipt"></i>
                    </div>
                </div>

                <div class="stat-label">
                    Total Pesanan
                </div>

                <div class="stat-value">
                    {{ number_format($totalPesanan ?? 0) }}
                </div>

            </div>
        </div>

    </section>


    <!-- DASHBOARD INFORMATION -->
    <section class="row g-3">

        <!-- AKTIVITAS TERBARU -->
        <div class="col-12 col-lg-7">

            <div class="section-card">

                <div class="section-header">

                    <div>
                        <h5 class="section-title">
                            Aktivitas Terbaru
                        </h5>

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

                    <h6>
                        Aktivitas akan ditampilkan di sini
                    </h6>

                    <p>
                        Riwayat aktivitas akan tersedia setelah
                        modul aktivitas diintegrasikan.
                    </p>

                </div>

            </div>

        </div>


        <!-- INFORMASI SISTEM -->
        <div class="col-12 col-lg-5">

            <div class="section-card">

                <div class="section-header">

                    <div>
                        <h5 class="section-title">
                            Informasi Sistem
                        </h5>

                        <div class="section-caption">
                            Informasi aplikasi CFood
                        </div>
                    </div>

                    <i class="bi bi-info-circle text-success"></i>

                </div>


                <div class="p-4">

                    <!-- NAMA APLIKASI -->
                    <div class="d-flex align-items-center justify-content-between mb-3">

                        <span class="text-secondary small">
                            Nama Aplikasi
                        </span>

                        <strong class="small">
                            CFood
                        </strong>

                    </div>


                    <hr class="border-light">


                    <!-- PANEL -->
                    <div class="d-flex align-items-center justify-content-between mb-3">

                        <span class="text-secondary small">
                            Panel
                        </span>

                        <strong class="small">
                            Administrator
                        </strong>

                    </div>


                    <hr class="border-light">


                    <!-- STATUS LOGIN -->
                    <div class="d-flex align-items-center justify-content-between mb-3">

                        <span class="text-secondary small">
                            Status Login
                        </span>

                        <span class="badge rounded-pill text-bg-success">
                            Aktif
                        </span>

                    </div>


                    <hr class="border-light">


                    <!-- PENGGUNA LOGIN -->
                    <div class="d-flex align-items-center justify-content-between">

                        <span class="text-secondary small">
                            Pengguna Login
                        </span>

                        <strong class="small">
                            {{ Auth::user()->email }}
                        </strong>

                    </div>

                </div>

            </div>

        </div>

    </section>

@endsection