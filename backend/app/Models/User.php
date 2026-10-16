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

    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected function casts(): array
    {
        return [
            'last_login' => 'datetime',
            'password' => 'hashed',
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

    public function reviews()
    {
        return $this->hasMany(Review::class, 'customer_id');
    }

    public function notifikasi()
    {
        return $this->hasMany(Notifikasi::class);
    }
}