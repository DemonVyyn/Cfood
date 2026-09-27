<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Review extends Model
{
    use HasFactory;

    protected $table = 'reviews';

    protected $fillable = [
        'pesanan_id',
        'customer_id',
        'rating',
        'comment',
    ];

    public function pesanan()
    {
        return $this->belongsTo(Pesanan::class);
    }

    public function customer()
    {
        return $this->belongsTo(User::class, 'customer_id');
    }
}