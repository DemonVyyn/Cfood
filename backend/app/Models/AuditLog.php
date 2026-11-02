<?php

namespace App\Models;

use App\Models\User;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class AuditLog extends Model
{
    protected $fillable = [
        'actor_id',
        'actor_role',
        'action',
        'object_type',
        'object_id',
        'result',
        'description',
        'ip_address',
        'event_at',
    ];

    protected function casts(): array
    {
        return [
            'event_at' => 'datetime',
        ];
    }

    public function actor(): BelongsTo
    {
        return $this->belongsTo(User::class, 'actor_id');
    }
}
