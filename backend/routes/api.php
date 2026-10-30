
<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\FoodController;
use App\Http\Controllers\Api\MerchantController;
use App\Http\Controllers\Api\OrderController;
use App\Http\Controllers\Api\NotificationController;

/*
|--------------------------------------------------------------------------
| Public Routes
|--------------------------------------------------------------------------
| Route yang dapat diakses tanpa login.
| Menggunakan rate limiting untuk mencegah brute-force attack.
*/

Route::post('/register', [AuthController::class, 'register'])
    ->middleware('throttle:5,1');

Route::post('/login', [AuthController::class, 'login'])
    ->middleware('throttle:5,1');


/*
|--------------------------------------------------------------------------
| Customer Routes
|--------------------------------------------------------------------------
| Hanya dapat diakses oleh pengguna dengan role customer.
*/

Route::middleware(['auth:sanctum', 'role:customer'])
    ->group(function () {

        Route::post('/orders', [OrderController::class, 'store']);

        Route::get('/orders', [OrderController::class, 'index']);

        Route::get('/orders/{id}', [OrderController::class, 'show']);

    });


/*
|--------------------------------------------------------------------------
| Merchant (Mitra) Routes
|--------------------------------------------------------------------------
| Hanya dapat diakses oleh pengguna dengan role mitra.
*/

Route::middleware(['auth:sanctum', 'role:mitra'])
    ->group(function () {

        // Dashboard Mitra
        Route::get(
            '/merchant/dashboard',
            [MerchantController::class, 'dashboard']
        );

        // Product Management (CRUD)
        Route::get(
            '/merchant/products',
            [MerchantController::class, 'products']
        );

        Route::post(
            '/merchant/products',
            [MerchantController::class, 'storeProduct']
        );

        Route::get(
            '/merchant/products/{id}',
            [MerchantController::class, 'showProduct']
        );

        Route::put(
            '/merchant/products/{id}',
            [MerchantController::class, 'updateProduct']
        );

        Route::delete(
            '/merchant/products/{id}',
            [MerchantController::class, 'deleteProduct']
        );

        // Order Management
        Route::get(
            '/merchant/orders',
            [MerchantController::class, 'orders']
        );

        // Verifikasi Pembayaran
        Route::post(
            '/merchant/orders/{id}/verify-payment',
            [MerchantController::class, 'verifyPayment']
        );

        // Konfirmasi Pengambilan Pesanan
        Route::post(
            '/merchant/orders/confirm-pickup',
            [MerchantController::class, 'confirmPickup']
        );

        // Notification Management
        Route::get(
            '/merchant/notifications',
            [NotificationController::class, 'index']
        );

        Route::patch(
            '/merchant/notifications/{id}/read',
            [NotificationController::class, 'markAsRead']
        );

        Route::patch(
            '/merchant/notifications/read-all',
            [NotificationController::class, 'markAllAsRead']
        );

    });


/*
|--------------------------------------------------------------------------
| Shared Authenticated Routes (Customer & Mitra)
|--------------------------------------------------------------------------
| Route yang hanya dapat diakses oleh pengguna yang sudah login.
*/

Route::middleware('auth:sanctum')
    ->group(function () {

        // Food List
        Route::get('/foods', [FoodController::class, 'index']);

        // Food Detail
        Route::get('/foods/{id}', [FoodController::class, 'show']);

        // User Profile
        Route::get('/profile', [AuthController::class, 'profile']);

        // Logout
        Route::post('/logout', [AuthController::class, 'logout']);

    });
