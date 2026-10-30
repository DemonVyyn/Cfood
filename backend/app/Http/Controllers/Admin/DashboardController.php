<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\Mitra;
use App\Models\Menu;
use App\Models\Pesanan;

class DashboardController extends Controller
{
    public function index()
    {
        $totalUsers = User::count();

        $totalMitra = Mitra::count();

        $totalProduk = Menu::count();

        $totalPesanan = Pesanan::count();

        return view('admin.dashboard', compact(
            'totalUsers',
            'totalMitra',
            'totalProduk',
            'totalPesanan'
        ));
    }
}
