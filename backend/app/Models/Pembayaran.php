<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Pembayaran extends Model
{
    use HasFactory;

    protected $table = 'pembayaran';

    protected $fillable = [
        'pesanan_id',
        'kode_transaksi',
        'nominal',
        'metode_pembayaran',
        'status_pembayaran',
        'waktu_pembayaran',
        'waktu_refund',
    ];

    protected $casts = [
        'waktu_pembayaran' => 'datetime',
        'waktu_refund' => 'datetime',
    ];

    public function pesanan()
    {
        return $this->belongsTo(Pesanan::class);
    }
}