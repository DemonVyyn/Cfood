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
                'in:customer,mitra'
            ],

            'nama' => [
                'required',
                'string',
                'max:255'
            ],

            'email' => [
                'required',
                'email',
                'unique:users,email'
            ],

            'phone' => [
                'required',
                'string',
                'unique:users,phone'
            ],

            'password' => [
                'required',
                'min:8',
                'confirmed'
            ],

            'nama_toko' => [
                'required_if:role,mitra'
            ],

            'alamat' => [
                'required_if:role,mitra'
            ],

            'nomor_telepon_toko' => [
                'required_if:role,mitra'
            ],

            'deskripsi_toko' => [
                'nullable'
            ],
        ];
    }

    public function messages(): array
    {
        return [
            'nama_toko.required_if'
                => 'Nama toko wajib diisi',

            'alamat.required_if'
                => 'Alamat toko wajib diisi',

            'nomor_telepon_toko.required_if'
                => 'Nomor telepon toko wajib diisi',
        ];
    }
}