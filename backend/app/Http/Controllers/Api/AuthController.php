<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\ChangePasswordRequest;
use App\Http\Requests\LoginRequest;
use App\Http\Requests\RegisterRequest;
use App\Http\Requests\UpdateProfileRequest;
use App\Models\User;
use App\Models\Mitra;
use App\Services\AuditTrail;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Storage;

class AuthController extends Controller
{
    /**
     * Registrasi pengguna.
     * Password di-hash sebelum disimpan ke database.
     */
    public function register(RegisterRequest $request)
    {
        $user = DB::transaction(function () use ($request) {
            $user = User::create([
                'nama' => $request->nama,
                'email' => $request->email,
                'phone' => $request->phone,

                // Hashing dan salting otomatis oleh Laravel.
                'password' => Hash::make($request->password),

                'role' => $request->role,
                'status' => 'active',
            ]);

            if ($request->role === 'mitra') {
                Mitra::create([
                    'user_id' => $user->id,
                    'nama_toko' => $request->nama_toko,
                    'deskripsi_toko' => $request->deskripsi_toko,
                    'alamat' => $request->alamat,
                    'nomor_telepon' => $request->nomor_telepon_toko,
                    'status_verifikasi' => 'pending',
                ]);
            }

            return $user;
        });

        return response()->json([
            'success' => true,
            'message' => 'Registrasi berhasil',
            'user' => $user,
        ], 201);
    }

    /**
     * Login pengguna.
     * Password diverifikasi menggunakan Hash::check().
     */
    public function login(LoginRequest $request)
    {
        $user = User::where('email', $request->email)->first();

        if (
            !$user ||
            !Hash::check($request->password, $user->password)
        ) {
            return response()->json([
                'success' => false,
                'message' => 'Email atau password salah',
            ], 401);
        }

        $user->update([
            'last_login' => now(),
        ]);

        $token = $user
            ->createToken('mobile-token')
            ->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'Login berhasil',
            'token' => $token,
            'user' => $user,
        ]);
    }

    /**
     * Menampilkan profil pengguna yang sedang login.
     */
    public function profile(Request $request)
    {
        return response()->json([
            'success' => true,
            'user' => $request->user(),
        ]);
    }

    /**
     * Memperbarui nama, email, dan nomor HP pengguna.
     */
    public function update(UpdateProfileRequest $request)
    {
        $user = $request->user();

        $user->fill(
            $request->only(['nama', 'email', 'phone'])
        )->save();

        AuditTrail::record(
            'update_profile',
            $user,
            'success',
            'Customer memperbarui data profil.'
        );

        return response()->json([
            'success' => true,
            'message' => 'Profil berhasil diperbarui.',
            'user' => $user->fresh(),
        ]);
    }

    /**
     * Mengunggah foto profil baru ke storage publik.
     */
    public function updatePhoto(Request $request)
    {
        $request->validate([
            'foto_profil' => [
                'required',
                'image',
                'mimes:jpg,jpeg,png',
                'max:2048',
            ],
        ]);

        $user = $request->user();

        if (
            $user->foto_profil &&
            Storage::disk('public')->exists($user->foto_profil)
        ) {
            Storage::disk('public')->delete($user->foto_profil);
        }

        $path = $request->file('foto_profil')
            ->store('profil', 'public');

        $user->foto_profil = $path;
        $user->save();

        AuditTrail::record(
            'update_profile_photo',
            $user,
            'success',
            'Customer memperbarui foto profil.'
        );

        return response()->json([
            'success' => true,
            'message' => 'Foto profil berhasil diperbarui.',
            'user' => $user->fresh(),
        ]);
    }

    /**
     * Mengubah kata sandi pengguna.
     */
    public function changePassword(ChangePasswordRequest $request)
    {
        $user = $request->user();

        if (
            !Hash::check(
                $request->current_password,
                $user->password
            )
        ) {
            return response()->json([
                'success' => false,
                'message' => 'Kata sandi saat ini tidak sesuai.',
            ], 422);
        }

        if (Hash::check($request->password, $user->password)) {
            return response()->json([
                'success' => false,
                'message' => 'Kata sandi baru tidak boleh sama dengan kata sandi saat ini.',
            ], 422);
        }

        $currentTokenId = $user->currentAccessToken()?->id;

        DB::transaction(function () use ($user, $request, $currentTokenId) {
            $user->update([
                'password' => Hash::make($request->password),
            ]);

            // Cabut token perangkat lain, biarkan perangkat ini tetap login.
            if ($currentTokenId) {
                $user->tokens()
                    ->where('id', '!=', $currentTokenId)
                    ->delete();
            }

            AuditTrail::record(
                'change_password',
                $user,
                'success',
                'Customer mengubah kata sandi akun.'
            );
        });

        return response()->json([
            'success' => true,
            'message' => 'Kata sandi berhasil diubah.',
        ]);
    }

    /**
     * Logout pengguna.
     */
    public function logout(Request $request)
    {
        $request->user()
            ->currentAccessToken()
            ->delete();

        return response()->json([
            'success' => true,
            'message' => 'Logout berhasil',
        ]);
    }
}
