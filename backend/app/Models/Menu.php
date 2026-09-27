<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Menu extends Model
{
    use HasFactory;

    protected $appends = [
    'expired_formatted',
    ];

    protected $table = 'menu';

    protected $fillable = [
        'mitra_id',
        'nama',
        'deskripsi',
        'kategori',
        'foto',
        'harga_original',
        'harga_diskon',
        'stok',
        'waktu_expired',
        'status',
    ];

    protected $casts = [
        'harga_original' => 'decimal:2',
        'harga_diskon' => 'decimal:2',
        'waktu_expired' => 'datetime',
    ];

    public function mitra()
    {
        return $this->belongsTo(Mitra::class);
    }

    public function barangPesanan()
    {
        return $this->hasMany(BarangPesanan::class);
    }

    public function getExpiredFormattedAttribute()
{
    return $this->waktu_expired
        ? $this->waktu_expired->format('d M Y')
        : null;
}
}