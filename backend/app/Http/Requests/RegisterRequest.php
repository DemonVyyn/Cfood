<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class RegisterRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'role' => [
                'required',
                'in:customer,mitra',
            ],

            'nama' => [
                'required',
                'string',
                'max:255',
            ],

            'email' => [
                'required',
                'email',
                'unique:users,email',
            ],

            'phone' => [
                'required',
                'string',
                'unique:users,phone',
            ],

            'password' => [
                'required',
                'string',
                'min:8',
                'confirmed',
            ],

            'nama_toko' => [
                'required_if:role,mitra',
                'nullable',
                'string',
            ],

            'alamat' => [
                'required_if:role,mitra',
                'nullable',
                'string',
            ],

            'nomor_telepon_toko' => [
                'required_if:role,mitra',
                'nullable',
                'string',
            ],

            'deskripsi_toko' => [
                'nullable',
                'string',
            ],
        ];
    }

    public function messages(): array
    {
        return [
            'role.required' => 'Role wajib dipilih',
            'role.in' => 'Role tidak valid',

            'nama.required' => 'Nama wajib diisi',

            'email.required' => 'Email wajib diisi',
            'email.email' => 'Format email tidak valid',
            'email.unique' => 'Email sudah terdaftar',

            'phone.required' => 'Nomor telepon wajib diisi',
            'phone.unique' => 'Nomor telepon sudah terdaftar',

            'password.required' => 'Password wajib diisi',
            'password.min' => 'Password minimal 8 karakter',
            'password.confirmed' => 'Konfirmasi password tidak cocok',

            'nama_toko.required_if' => 'Nama toko wajib diisi',
            'alamat.required_if' => 'Alamat toko wajib diisi',
            'nomor_telepon_toko.required_if' => 'Nomor telepon toko wajib diisi',
        ];
    }
}
