<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Notifikasi;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\Rule;

class AdminNotificationController extends Controller
{
    public function index()
    {
        // Kelompokkan baris notifikasi yang dikirim dalam satu waktu
        // agar riwayat pengumuman tidak tampil berulang untuk setiap penerima.
        $notifications = Notifikasi::query()
            ->select(
                'judul',
                'pesan',
                'created_at',
                DB::raw('COUNT(*) as recipient_count'),
                DB::raw('SUM(CASE WHEN is_read = 1 THEN 1 ELSE 0 END) as read_count')
            )
            ->groupBy('judul', 'pesan', 'created_at')
            ->latest('created_at')
            ->paginate(10);

        return view('admin.notifications.index', compact('notifications'));
    }

    public function create()
    {
        $recipientCounts = [
            'customer' => User::where('role', 'customer')
                ->where('status', 'active')
                ->count(),

            'mitra' => User::where('role', 'mitra')
                ->where('status', 'active')
                ->count(),
        ];

        return view('admin.notifications.create', compact('recipientCounts'));
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'judul' => ['required', 'string', 'max:255'],
            'pesan' => ['required', 'string', 'max:5000'],
            'target' => [
                'required',
                Rule::in(['customer', 'mitra', 'all']),
            ],
        ], [
            'judul.required' => 'Judul notifikasi wajib diisi.',
            'judul.max' => 'Judul maksimal 255 karakter.',
            'pesan.required' => 'Isi notifikasi wajib diisi.',
            'pesan.max' => 'Isi notifikasi maksimal 5000 karakter.',
            'target.required' => 'Target penerima wajib dipilih.',
            'target.in' => 'Target penerima tidak valid.',
        ]);

        $roles = match ($validated['target']) {
            'customer' => ['customer'],
            'mitra' => ['mitra'],
            'all' => ['customer', 'mitra'],
        };

        $recipientIds = User::query()
            ->whereIn('role', $roles)
            ->where('status', 'active')
            ->pluck('id');

        if ($recipientIds->isEmpty()) {
            return back()
                ->withInput()
                ->withErrors([
                    'target' => 'Tidak ada pengguna aktif pada target yang dipilih.',
                ]);
        }

        $now = now();

        $rows = $recipientIds->map(fn ($userId) => [
            'user_id' => $userId,
            'judul' => $validated['judul'],
            'pesan' => $validated['pesan'],
            'is_read' => false,
            'read_at' => null,
            'created_at' => $now,
            'updated_at' => $now,
        ])->all();

        DB::transaction(function () use ($rows) {
            DB::table('notifikasi')->insert($rows);
        });

        $targetLabel = match ($validated['target']) {
            'customer' => 'Customer',
            'mitra' => 'Mitra',
            'all' => 'Customer dan Mitra',
        };

        return redirect()
            ->route('admin.notifications.index')
            ->with(
                'success',
                'Notifikasi berhasil dikirim kepada '
                . number_format(count($rows))
                . ' pengguna (' . $targetLabel . ').'
            );
    }
}