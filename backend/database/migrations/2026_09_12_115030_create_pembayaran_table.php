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
        Schema::create('pembayaran', function (Blueprint $table) {
            $table->id();

            $table->foreignId('pesanan_id')
                ->constrained('pesanan')
                ->cascadeOnDelete();

            $table->string('kode_transaksi')
                ->unique();

            $table->decimal('nominal', 12, 2);

            $table->enum('metode_pembayaran', [
                'qris',
                'gopay',
                'ovo',
                'dana',
                'bank_transfer',
                'cash'
            ]);

            $table->enum('status_pembayaran', [
                'pending',
                'paid',
                'failed',
                'refunded'
            ])->default('pending');

            $table->timestamp('waktu_pembayaran')
                ->nullable();

            $table->timestamp('waktu_refund')
                ->nullable();

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('pembayaran');
    }
};