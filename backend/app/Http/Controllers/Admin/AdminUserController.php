<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class AdminUserController extends Controller
{
    /**
     * Menampilkan daftar pengguna.
     */
    public function index(Request $request)
    {
        $query = User::query();

        // Pencarian berdasarkan nama, email, dan nomor telepon.
        if ($request->filled('search')) {
            $search = $request->search;

            $query->where(function ($builder) use ($search) {
                $builder->where('nama', 'like', "%{$search}%")
                    ->orWhere('email', 'like', "%{$search}%")
                    ->orWhere('phone', 'like', "%{$search}%");
            });
        }

        // Filter berdasarkan role pengguna.
        if ($request->filled('role')) {
            $query->where('role', $request->role);
        }

        // Mengambil data pengguna dengan pagination.
        $users = $query
            ->latest()
            ->paginate(10)
            ->withQueryString();

        return view('admin.users.index', compact('users'));
    }

    /**
     * Menampilkan halaman tambah pengguna.
     */
    public function create()
    {
        return view('admin.users.create');
    }

    /**
     * Menyimpan akun pengguna baru.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'nama' => [
                'required',
                'string',
                'max:255',
            ],
            'email' => [
                'required',
                'email',
                'max:255',
                'unique:users,email',
            ],
            'phone' => [
                'required',
                'string',
                'max:255',
                'unique:users,phone',
            ],
            'password' => [
                'required',
                'string',
                'min:8',
                'confirmed',
            ],
            'role' => [
                'required',
                Rule::in(['customer', 'mitra', 'admin']),
            ],
            'status' => [
                'required',
                Rule::in(['active', 'suspended']),
            ],
        ], [
            'nama.required' => 'Nama wajib diisi.',
            'email.required' => 'Email wajib diisi.',
            'email.email' => 'Format email tidak valid.',
            'email.unique' => 'Email sudah digunakan.',
            'phone.required' => 'Nomor HP wajib diisi.',
            'phone.unique' => 'Nomor HP sudah digunakan.',
            'password.required' => 'Password wajib diisi.',
            'password.min' => 'Password minimal 8 karakter.',
            'password.confirmed' => 'Konfirmasi password tidak sesuai.',
            'role.required' => 'Role wajib dipilih.',
            'role.in' => 'Role pengguna tidak valid.',
            'status.required' => 'Status akun wajib dipilih.',
            'status.in' => 'Status akun tidak valid.',
        ]);

        User::create($validated);

        return redirect()
            ->route('admin.users.index')
            ->with('success', 'Akun pengguna berhasil ditambahkan.');
    }

    /**
     * Menampilkan halaman edit pengguna.
     */
    public function edit(User $user)
    {
        return view('admin.users.edit', compact('user'));
    }

    /**
     * Memperbarui data akun pengguna.
     */
    public function update(Request $request, User $user)
    {
        $validated = $request->validate([
            'nama' => [
                'required',
                'string',
                'max:255',
            ],
            'email' => [
                'required',
                'email',
                'max:255',
                Rule::unique('users', 'email')->ignore($user->id),
            ],
            'phone' => [
                'required',
                'string',
                'max:255',
                Rule::unique('users', 'phone')->ignore($user->id),
            ],
            'password' => [
                'nullable',
                'string',
                'min:8',
                'confirmed',
            ],
            'role' => [
                'required',
                Rule::in(['customer', 'mitra', 'admin']),
            ],
            'status' => [
                'required',
                Rule::in(['active', 'suspended']),
            ],
        ], [
            'nama.required' => 'Nama wajib diisi.',
            'email.required' => 'Email wajib diisi.',
            'email.email' => 'Format email tidak valid.',
            'email.unique' => 'Email sudah digunakan.',
            'phone.required' => 'Nomor HP wajib diisi.',
            'phone.unique' => 'Nomor HP sudah digunakan.',
            'password.min' => 'Password minimal 8 karakter.',
            'password.confirmed' => 'Konfirmasi password tidak sesuai.',
            'role.required' => 'Role wajib dipilih.',
            'role.in' => 'Role pengguna tidak valid.',
            'status.required' => 'Status akun wajib dipilih.',
            'status.in' => 'Status akun tidak valid.',
        ]);

        // Jika password kosong, password lama tetap digunakan.
        if (empty($validated['password'])) {
            unset($validated['password']);
        }

        $user->update($validated);

        return redirect()
            ->route('admin.users.index')
            ->with('success', 'Data pengguna berhasil diperbarui.');
    }
}