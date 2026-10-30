<?php

use App\Http\Controllers\Api\AuthController;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\FoodController;
use App\Http\Controllers\Api\MerchantController;
use App\Http\Controllers\Api\OrderController;

<<<<<<< HEAD
/* Public Routes */
=======
/*
|--------------------------------------------------------------------------
| Public Routes (dengan rate limiting anti brute-force)
|--------------------------------------------------------------------------
*/
>>>>>>> 7a3d41155f5a2b7d7dae84d23b00afebb2676bbc

Route::post(
    '/register',
    [AuthController::class, 'register']
)->middleware('throttle:5,1');

Route::post(
    '/login',
    [AuthController::class, 'login']
)->middleware('throttle:5,1');

<<<<<<< HEAD
/* Protected Routes */
=======
/*
|--------------------------------------------------------------------------
| Customer Routes
|--------------------------------------------------------------------------
*/
>>>>>>> 7a3d41155f5a2b7d7dae84d23b00afebb2676bbc

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
*/

Route::middleware(['auth:sanctum', 'role:mitra'])
    ->group(function () {
        Route::get(
            '/merchant/dashboard',
            [MerchantController::class, 'dashboard']
        );

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

        Route::get(
            '/merchant/orders',
            [MerchantController::class, 'orders']
        );

        Route::post(
            '/merchant/orders/{id}/verify-payment',
            [MerchantController::class, 'verifyPayment']
        );

        Route::post(
            '/merchant/orders/confirm-pickup',
            [MerchantController::class, 'confirmPickup']
        );
    });

/*
|--------------------------------------------------------------------------
| Shared Authenticated Routes (Customer & Mitra)
|--------------------------------------------------------------------------
*/

Route::middleware('auth:sanctum')
    ->group(function () {
        Route::get(
            '/foods',
            [FoodController::class, 'index']
        );

        Route::get(
            '/foods/{id}',
            [FoodController::class, 'show']
        );

        Route::get(
            '/profile',
            [AuthController::class, 'profile']
        );

        Route::post(
            '/logout',
            [AuthController::class, 'logout']
        );
    });