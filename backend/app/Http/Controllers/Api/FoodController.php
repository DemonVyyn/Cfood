<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Menu;
use Illuminate\Http\Request;

class FoodController extends Controller
{
    /**
     * GET /api/foods
     */
    public function index()
    {
        $foods = Menu::with('mitra')
            ->where('status', 'aktif')
            ->where('stok', '>', 0)
            ->where('waktu_expired', '>', now())
            ->latest()
            ->get();

        return response()->json([
            'success' => true,
            'data' => $foods,
        ]);
    }

    /**
     * GET /api/foods/{id}
     */
    public function show($id)
    {
        $food = Menu::with('mitra')
            ->findOrFail($id);

        return response()->json([
            'success' => true,
            'data' => $food,
        ]);
    }
}