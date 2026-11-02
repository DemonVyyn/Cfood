<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('audit_logs', function (Blueprint $table) {
            $table->id();

            // Actor: pengguna yang melakukan aktivitas
            $table->unsignedBigInteger('actor_id')->nullable();
            $table->string('actor_role')->nullable();

            // Action: aktivitas yang dilakukan
            $table->string('action');

            // Object: data yang menjadi sasaran aktivitas
            $table->string('object_type')->nullable();
            $table->string('object_id')->nullable();

            // Result: hasil aktivitas
            $table->string('result');

            // Informasi pendukung
            $table->text('description')->nullable();
            $table->string('ip_address', 45)->nullable();

            // Timestamp: waktu aktivitas
            $table->timestamp('event_at')->useCurrent();

            $table->timestamps();

            $table->index(['actor_id', 'event_at']);
            $table->index(['action', 'event_at']);
            $table->index(['object_type', 'object_id']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('audit_logs');
    }
};
