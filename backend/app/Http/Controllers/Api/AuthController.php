<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\LoginRequest;
use App\Http\Requests\RegisterRequest;
use App\Models\User;
use App\Models\Mitra;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    public function register(
        RegisterRequest $request
    ) {
        $user = User::create([
            'nama' => $request->nama,
            'email' => $request->email,
            'phone' => $request->phone,
            'password' => $request->password,
            'role' => $request->role,
            'status' => 'active',
        ]);

        if ($request->role === 'mitra') {

            Mitra::create([
                'user_id' => $user->id,

                'nama_toko'
                    => $request->nama_toko,

                'deskripsi_toko'
                    => $request->deskripsi_toko,

                'alamat'
                    => $request->alamat,

                'nomor_telepon'
                    => $request->nomor_telepon_toko,

                'status_verifikasi'
                    => 'pending',
            ]);
        }

        return response()->json([
            'success' => true,
            'message'
                => 'Registrasi berhasil',
            'user' => $user,
        ], 201);
    }

    public function login(
        LoginRequest $request
    ) {
        $user = User::where(
            'email',
            $request->email
        )->first();

        if (
            !$user ||
            !Hash::check(
                $request->password,
                $user->password
            )
        ) {
            return response()->json([
                'success' => false,
                'message'
                    => 'Email atau password salah',
            ], 401);
        }

        $user->update([
            'last_login' => now(),
        ]);

        $token = $user
            ->createToken(
                'mobile-token'
            )
            ->plainTextToken;

        return response()->json([
            'success' => true,
            'message'
                => 'Login berhasil',
            'token' => $token,
            'user' => $user,
        ]);
    }

    public function profile(
        Request $request
    ) {
        return response()->json([
            'success' => true,
            'user' => $request->user(),
        ]);
    }

    public function logout(
        Request $request
    ) {
        $request
            ->user()
            ->currentAccessToken()
            ->delete();

        return response()->json([
            'success' => true,
            'message'
                => 'Logout berhasil',
        ]);
    }
}