<?php

namespace App\Services;

use App\Models\Notifikasi;
use App\Models\Pesanan;
use Illuminate\Support\Facades\DB;
use InvalidArgumentException;

class OrderCancellation
{
    private const CANCELLABLE_STATUSES = [
        'menunggu_pembayaran',
        'menunggu',
        'diproses',
    ];

    /**
     * Batalkan pesanan, kembalikan stok, sesuaikan pembayaran,
     * kirim notifikasi, dan catat audit trail.
     */
    public function cancel(
        Pesanan $order,
        string $actorLabel,
        ?string $reason = null,
        bool $restoreStock = true,
        ?array $allowedStatuses = null
    ): Pesanan {
        $statuses = $allowedStatuses
            ?? self::CANCELLABLE_STATUSES;

        return DB::transaction(function () use (
            $order,
            $actorLabel,
            $reason,
            $restoreStock,
            $statuses
        ) {
            $locked = Pesanan::whereKey($order->id)
                ->lockForUpdate()
                ->firstOrFail();

            if (
                !in_array(
                    $locked->order_status,
                    $statuses,
                    true
                )
            ) {
                throw new InvalidArgumentException(
                    'Pesanan tidak dapat dibatalkan pada status saat ini.'
                );
            }

            $locked->order_status = 'dibatalkan';
            $locked->save();

            if ($restoreStock) {
                $this->restoreStock($locked);
            }

            $this->updatePayment($locked);
            $this->createNotifications(
                $locked,
                $actorLabel,
                $reason
            );

            AuditTrail::record(
                'cancel_order',
                $locked,
                'success',
                'Pesanan dibatalkan oleh ' . $actorLabel
                    . ($reason ? '. Alasan: ' . $reason : '.')
            );

            return $locked->load([
                'items.menu',
                'mitra',
                'pembayaran',
            ]);
        }, 5);
    }

    private function restoreStock(Pesanan $order): void
    {
        foreach ($order->items as $item) {
            $menu = $item->menu;

            if (!$menu) {
                continue;
            }

            $menu->stok += $item->jumlah;

            if (
                $menu->status === 'habis' &&
                $menu->stok > 0
            ) {
                $menu->status = 'aktif';
            }

            $menu->save();
        }
    }

    private function updatePayment(Pesanan $order): void
    {
        $payment = $order->pembayaran;

        if (!$payment) {
            return;
        }

        if ($payment->status_pembayaran === 'paid') {
            $payment->status_pembayaran = 'refunded';
            $payment->waktu_refund = now();
        } elseif (
            $payment->status_pembayaran === 'pending'
        ) {
            $payment->status_pembayaran = 'failed';
        }

        $payment->save();
    }

    private function createNotifications(
        Pesanan $order,
        string $actorLabel,
        ?string $reason
    ): void {
        $reasonText = $reason
            ? ' Alasan: ' . $reason
            : '';

        Notifikasi::create([
            'user_id' => $order->customer_id,
            'judul' => 'Pesanan Dibatalkan',
            'pesan' => 'Pesanan #' . $order->id
                . ' telah dibatalkan oleh ' . $actorLabel
                . '.' . $reasonText,
            'is_read' => false,
            'read_at' => null,
        ]);

        if (
            $order->mitra &&
            $order->mitra->user_id
        ) {
            Notifikasi::create([
                'user_id' => $order->mitra->user_id,
                'judul' => 'Pesanan Dibatalkan',
                'pesan' => 'Pesanan #' . $order->id
                    . ' dari customer dibatalkan oleh '
                    . $actorLabel . '.' . $reasonText,
                'is_read' => false,
                'read_at' => null,
            ]);
        }
    }
}
