<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Notifikasi;
use Illuminate\Http\Request;

class NotificationController extends Controller
{
    /**
     * Mengambil seluruh notifikasi milik Mitra yang sedang login.
     */
    public function index(Request $request)
    {
        $notifications = Notifikasi::where(
            'user_id',
            $request->user()->id
        )
            ->orderByDesc('created_at')
            ->get();

        return response()->json([
            'success' => true,
            'message' => 'Berhasil mengambil notifikasi.',
            'data' => $notifications,
            'unread_count' => $notifications->where('is_read', false)->count(),
        ]);
    }

    /**
     * Menandai satu notifikasi sebagai sudah dibaca.
     */
    public function markAsRead(Request $request, $id)
    {
        $notification = Notifikasi::where('user_id', $request->user()->id)
            ->findOrFail($id);

        if (!$notification->is_read) {
            $notification->update([
                'is_read' => true,
                'read_at' => now(),
            ]);
        }

        return response()->json([
            'success' => true,
            'message' => 'Notifikasi berhasil ditandai sudah dibaca.',
            'data' => $notification,
        ]);
    }

    /**
     * Menandai seluruh notifikasi sebagai sudah dibaca.
     */
    public function markAllAsRead(Request $request)
    {
        Notifikasi::where('user_id', $request->user()->id)
            ->where('is_read', false)
            ->update([
                'is_read' => true,
                'read_at' => now(),
            ]);

        return response()->json([
            'success' => true,
            'message' => 'Seluruh notifikasi berhasil ditandai sudah dibaca.',
        ]);
    }
}
