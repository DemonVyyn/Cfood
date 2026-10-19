<?php

use App\Http\Controllers\Api\AuthController;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\FoodController;
use App\Http\Controllers\Api\MerchantController;
use App\Http\Controllers\Api\OrderController;

/*
|--------------------------------------------------------------------------
| Public Routes
|--------------------------------------------------------------------------
*/

Route::post(
    '/register',
    [AuthController::class, 'register']
);

Route::post(
    '/login',
    [AuthController::class, 'login']
);

/*
|--------------------------------------------------------------------------
| Protected Routes
|--------------------------------------------------------------------------
*/

Route::middleware('auth:sanctum')
    ->group(function () {


    // Customer: membuat dan melihat pesanan.
Route::post('/orders', [OrderController::class, 'store']);
Route::get('/orders', [OrderController::class, 'index']);
Route::get('/orders/{id}', [OrderController::class, 'show']);

Route::post(
    '/merchant/orders/{id}/verify-payment',
    [MerchantController::class, 'verifyPayment']
);

        Route::get(
            '/merchant/dashboard',
            [MerchantController::class, 'dashboard']
        );

        Route::get(
            '/merchant/products',
            [MerchantController::class, 'products'] 
        );

        Route::get(
            '/profile',
            [AuthController::class, 'profile']
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
            '/logout',
            [AuthController::class, 'logout']
        );

        Route::get(
    '/foods',
    [FoodController::class, 'index']
);

Route::get(
    '/foods/{id}',
    [FoodController::class, 'show']
);

Route::post(
    '/merchant/orders/confirm-pickup',
    [MerchantController::class, 'confirmPickup']
);
    });

    