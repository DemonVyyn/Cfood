<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Mitra extends Model
{
    use HasFactory;

    protected $table = 'mitra';

    protected $fillable = [
        'user_id',
        'nama_toko',
        'deskripsi_toko',
        'alamat',
        'latitude',
        'longitude',
        'nomor_telepon',
        'foto_toko',
        'status_verifikasi',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function menu()
    {
        return $this->hasMany(Menu::class);
    }

    public function pesanan()
    {
        return $this->hasMany(Pesanan::class);
    }
}