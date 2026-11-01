<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Menu;
use App\Models\BarangPesanan;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Validation\Rule;
use Illuminate\Validation\ValidationException;
use Throwable;

class AdminProductController extends Controller
{
    /**
     * Menampilkan seluruh produk dari semua mitra.
     */
    public function index(Request $request)
    {
        $query = Menu::with('mitra.user');

        // Pencarian nama produk, toko, atau pemilik toko.
        if ($request->filled('search')) {
            $search = $request->search;

            $query->where(function ($builder) use ($search) {
                $builder->where('nama', 'like', "%{$search}%")
                    ->orWhereHas('mitra', function ($mitraQuery) use ($search) {
                        $mitraQuery->where('nama_toko', 'like', "%{$search}%")
                            ->orWhereHas('user', function ($userQuery) use ($search) {
                                $userQuery->where('nama', 'like', "%{$search}%");
                            });
                    });
            });
        }

        // Filter kategori.
        if ($request->filled('kategori')) {
            $query->where('kategori', $request->kategori);
        }

        // Filter status.
        if ($request->filled('status')) {
            $query->where('status', $request->status);
        }

        $products = $query
            ->latest()
            ->paginate(10)
            ->withQueryString();

        $statistics = [
            'total' => Menu::count(),
            'aktif' => Menu::where('status', 'aktif')->count(),
            'habis' => Menu::where('status', 'habis')->count(),
            'expired' => Menu::where('status', 'expired')->count(),
        ];

        $categories = Menu::query()
            ->whereNotNull('kategori')
            ->where('kategori', '!=', '')
            ->distinct()
            ->orderBy('kategori')
            ->pluck('kategori');

        return view('admin.products.index', compact(
            'products',
            'statistics',
            'categories'
        ));
    }

    /**
     * Menampilkan detail produk.
     */
    public function show(Menu $product)
    {
        $product->load('mitra.user');

        return view('admin.products.show', compact('product'));
    }

    /**
     * Menampilkan formulir edit produk.
     */
    public function edit(Menu $product)
    {
        $product->load('mitra.user');

        return view('admin.products.edit', compact('product'));
    }

    /**
     * Memperbarui data produk.
     */
    public function update(Request $request, Menu $product)
    {
        $validated = $request->validate([
            'nama' => ['required', 'string', 'max:255'],
            'deskripsi' => ['nullable', 'string'],
            'kategori' => ['nullable', 'string', 'max:255'],
            'foto' => ['nullable', 'image', 'mimes:jpg,jpeg,png,webp', 'max:2048'],
            'harga_original' => ['required', 'numeric', 'min:0'],
            'harga_diskon' => [
                'required',
                'numeric',
                'min:0',
                'lte:harga_original',
            ],
            'stok' => ['required', 'integer', 'min:0'],
            'waktu_expired' => ['required', 'date'],
            'status' => [
                'required',
                Rule::in(['aktif', 'habis', 'expired']),
            ],
        ], [
            'nama.required' => 'Nama produk wajib diisi.',
            'harga_original.required' => 'Harga normal wajib diisi.',
            'harga_diskon.required' => 'Harga diskon wajib diisi.',
            'harga_diskon.lte' => 'Harga diskon tidak boleh melebihi harga normal.',
            'stok.required' => 'Stok produk wajib diisi.',
            'stok.integer' => 'Stok harus berupa bilangan bulat.',
            'stok.min' => 'Stok tidak boleh kurang dari nol.',
            'waktu_expired.required' => 'Waktu kedaluwarsa wajib diisi.',
            'status.required' => 'Status produk wajib dipilih.',
            'foto.image' => 'File harus berupa gambar.',
            'foto.mimes' => 'Foto harus berformat JPG, JPEG, PNG, atau WEBP.',
            'foto.max' => 'Ukuran foto maksimal 2 MB.',
        ]);

        $oldPhoto = $product->foto;
        $newPhoto = null;

        if ($request->hasFile('foto')) {
            $newPhoto = $request->file('foto')
                ->store('products', 'public');

            $validated['foto'] = $newPhoto;
        }

        try {
            $product->update($validated);

            // Hapus foto lama hanya setelah data berhasil diperbarui.
            if ($newPhoto && $oldPhoto) {
                Storage::disk('public')->delete($oldPhoto);
            }
        } catch (Throwable $e) {
            // Bersihkan foto baru jika proses update gagal.
            if ($newPhoto) {
                Storage::disk('public')->delete($newPhoto);
            }

            throw $e;
        }

        return redirect()
            ->route('admin.products.index')
            ->with('success', 'Data produk berhasil diperbarui.');
    }

    /**
     * Menghapus produk.
     */
    public function destroy(Menu $product)
    {
        // Pertahankan detail transaksi yang sudah pernah menggunakan produk.
        if ($product->barangPesanan()->exists()) {
            return redirect()
                ->route('admin.products.index')
                ->with(
                    'error',
                    'Produk tidak dapat dihapus karena sudah tercatat dalam riwayat pesanan. Ubah status produk jika tidak ingin ditampilkan.'
                );
        }

        $photo = $product->foto;

        DB::transaction(function () use ($product) {
            $product->delete();
        });

        if ($photo) {
            Storage::disk('public')->delete($photo);
        }

        return redirect()
            ->route('admin.products.index')
            ->with('success', 'Produk berhasil dihapus.');
    }
}