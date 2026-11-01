<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Mitra;
use Illuminate\Http\Request;

class AdminMitraController extends Controller
{
    /**
     * Menampilkan daftar mitra dan filter status verifikasi.
     */
    public function index(Request $request)
    {
        $query = Mitra::with('user');

        if ($request->filled('search')) {
            $search = $request->search;

            $query->where(function ($builder) use ($search) {
                $builder->where('nama_toko', 'like', "%{$search}%")
                    ->orWhereHas('user', function ($userQuery) use ($search) {
                        $userQuery->where('nama', 'like', "%{$search}%")
                            ->orWhere('email', 'like', "%{$search}%");
                    });
            });
        }

        if ($request->filled('status')) {
            $query->where(
                'status_verifikasi',
                $request->status
            );
        }

        $mitras = $query
            ->latest()
            ->paginate(10)
            ->withQueryString();

        $statistics = [
            'total' => Mitra::count(),
            'pending' => Mitra::where(
                'status_verifikasi',
                'pending'
            )->count(),
            'verified' => Mitra::where(
                'status_verifikasi',
                'verified'
            )->count(),
            'rejected' => Mitra::where(
                'status_verifikasi',
                'rejected'
            )->count(),
        ];

        return view(
            'admin.mitra.index',
            compact('mitras', 'statistics')
        );
    }

    /**
     * Menampilkan detail mitra.
     */
    public function show(Mitra $mitra)
    {
        $mitra->load('user');

        return view('admin.mitra.show', compact('mitra'));
    }

    /**
     * Menyetujui pendaftaran mitra.
     */
    public function verify(Mitra $mitra)
    {
        if ($mitra->status_verifikasi === 'verified') {
            return redirect()
                ->route('admin.mitra.index')
                ->with('info', 'Mitra ini sudah diverifikasi.');
        }

        $mitra->update([
            'status_verifikasi' => 'verified',
        ]);

        return redirect()
            ->route('admin.mitra.index')
            ->with('success', 'Mitra berhasil diverifikasi.');
    }

    /**
     * Menolak pendaftaran mitra.
     */
    public function reject(Mitra $mitra)
    {
        if ($mitra->status_verifikasi === 'rejected') {
            return redirect()
                ->route('admin.mitra.index')
                ->with('info', 'Pendaftaran mitra sudah ditolak.');
        }

        $mitra->update([
            'status_verifikasi' => 'rejected',
        ]);

        return redirect()
            ->route('admin.mitra.index')
            ->with('success', 'Pendaftaran mitra berhasil ditolak.');
    }
}
