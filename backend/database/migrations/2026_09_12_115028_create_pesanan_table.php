<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('pesanan', function (Blueprint $table) {
            $table->id();

            $table->foreignId('customer_id')
                ->constrained('users')
                ->cascadeOnDelete();

            $table->foreignId('mitra_id')
                ->constrained('mitra')
                ->cascadeOnDelete();

            $table->decimal('total_harga', 12, 2);

            $table->string('kode_pengambilan', 20)
                ->unique();

            $table->timestamp('waktu_pengambilan')
                ->nullable();

            $table->enum('order_status', [
                'menunggu_pembayaran',
                'dibayar',
                'diproses',
                'siap_diambil',
                'selesai',
                'dibatalkan'
            ])->default('menunggu_pembayaran');

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('pesanan');
    }
};