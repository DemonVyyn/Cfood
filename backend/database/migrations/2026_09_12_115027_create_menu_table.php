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
        Schema::create('menu', function (Blueprint $table) {
            $table->id();

            $table->foreignId('mitra_id')
                ->constrained('mitra')
                ->cascadeOnDelete();

            $table->string('nama');

            $table->text('deskripsi')->nullable();

            $table->string('kategori')->nullable();

            $table->string('foto')->nullable();

            $table->decimal('harga_original', 12, 2);

            $table->decimal('harga_diskon', 12, 2);

            $table->integer('stok')->default(0);

            $table->timestamp('waktu_expired');

            $table->enum('status', [
                'aktif',
                'habis',
                'expired'
            ])->default('aktif');

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('menu');
    }
};