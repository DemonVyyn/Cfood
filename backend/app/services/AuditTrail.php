<?php

namespace App\Services;

use App\Models\AuditLog;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Log;

class AuditTrail
{
    public static function record(
        string $action,
        ?Model $object = null,
        string $result = 'success',
        ?string $description = null
    ): void {
        try {
            $actor = request()->user();

            AuditLog::create([
                'actor_id' => $actor?->getAuthIdentifier(),
                'actor_role' => $actor?->role,
                'action' => $action,
                'object_type' => $object
                    ? class_basename($object)
                    : null,
                'object_id' => $object
                    ? (string) $object->getKey()
                    : null,
                'result' => $result,
                'description' => $description,
                'ip_address' => request()->ip(),
                'event_at' => now(),
            ]);
        } catch (\Throwable $e) {
            Log::error('Audit Trail gagal dicatat.', [
                'action' => $action,
                'error' => $e->getMessage(),
            ]);

            throw $e;
        }
    }
}
