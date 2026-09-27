<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class BarangPesanan extends Model
{
    use HasFactory;

    protected $table = 'barang_pesanan';

    protected $fillable = [
        'pesanan_id',
        'menu_id',
        'jumlah',
        'harga',
        'subtotal',
    ];

    public function pesanan()
    {
        return $this->belongsTo(Pesanan::class);
    }

    public function menu()
    {
        return $this->belongsTo(Menu::class);
    }
}