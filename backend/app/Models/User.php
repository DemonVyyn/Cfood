<?php

namespace App\Models;

use Laravel\Sanctum\HasApiTokens;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    protected $table = 'users';

    protected $fillable = [
        'nama',
        'email',
        'phone',
        'password',
        'role',
        'status',
        'foto_profil',
        'last_login',
    ];

    /**
     * Menyembunyikan password dan remember_token
     * dari hasil serialisasi model ke JSON.
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected $appends = [
        'foto_profil_url',
    ];

    public function getFotoProfilUrlAttribute(): ?string
    {
        if (!$this->foto_profil) {
            return null;
        }

        if (filter_var($this->foto_profil, FILTER_VALIDATE_URL)) {
            return $this->foto_profil;
        }

        return url('storage/' . ltrim($this->foto_profil, '/'));
    }

    protected function casts(): array
    {
        return [
            'last_login' => 'datetime',
        ];
    }

    public function mitra()
    {
        return $this->hasOne(Mitra::class);
    }

    public function pesanan()
    {
        return $this->hasMany(Pesanan::class, 'customer_id');
    }

    public function notifikasi()
    {
        return $this->hasMany(Notifikasi::class);
    }
}
