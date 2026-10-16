<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Pesanan extends Model
{
    use HasFactory;

    protected $table = 'pesanan';

    protected $fillable = [
        'customer_id',
        'mitra_id',
        'total_harga',
        'kode_pengambilan',
        'waktu_pengambilan',
        'order_status',
    ];

    protected $casts = [
        'waktu_pengambilan' => 'datetime',
    ];

    public function customer()
    {
        return $this->belongsTo(User::class, 'customer_id');
    }

    public function mitra()
    {
        return $this->belongsTo(Mitra::class);
    }

    public function items()
    {
        return $this->hasMany(BarangPesanan::class, 'pesanan_id');
    }

    public function pembayaran()
    {
        return $this->hasOne(Pembayaran::class);
    }

    public function review()
    {
        return $this->hasOne(Review::class);
    }
}