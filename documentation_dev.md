# Dokumentasi Pengembangan (development documentation)

## Apa yang diubah

1. **`curved_bottom_nav.dart`**
    - Ditambahkan properti opsional `ValueChanged<int>? onTap`.
    - `onTap` dipanggil bila disediakan; bila tidak, widget tetap melakukan navigasi lama dengan `Navigator.pushNamed` (fallback).
    - Warna bar customer saat ini memakai latar transparan, warna bar hijau `Color.fromARGB(255, 20, 222, 50)`, dan warna tombol `Color.fromARGB(255, 61, 226, 61)`.

2. **Halaman‑halaman utama** (`home_page.dart`, `notification_page.dart`, `order_history_page.dart`, `profile_page.dart`)
    - Dihapus properti `bottomNavigationBar` yang memanggil `CurvedBottomNav` secara langsung.
    - Diganti dengan komentar placeholder: _"Bottom navigation is now handled by HomeShell (SPA)."_
    - Ini mencegah pembuatan `Scaffold` baru pada setiap tab sehingga UI tidak “reload”.

3. **`home_shell.dart`** (file baru di `lib/widgets/`)
    - Widget **Stateful** yang menampung keempat halaman utama dalam sebuah `IndexedStack`.
    - Menyimpan state tiap halaman (scroll, form, dll.) sehingga tidak hilang saat berpindah tab.
    - Menggunakan `CurvedBottomNav` dengan callback `onTap` untuk mengubah indeks yang aktif.
    - Menyediakan tampilan SPA‑like: hanya konten yang berubah, bar tetap di tempat dengan animasi mulus.

4. **`main.dart`**
    - Di‑import `home_shell.dart`.
    - Route `'/home'` mengembalikan `HomeShell`.
    - Splash tetap menjadi entry point; setelah login, aplikasi dapat menavigasi ke route `'/home'`.

5. **Navigasi mitra** (`curved_merchant_nav.dart`, `merchant_shell.dart`, `main.dart`)
    - `CurvedMerchantNav` menggunakan package dan pengaturan visual curved navigation yang sama dengan customer: latar transparan, warna hijau, dan durasi animasi 300 ms.
    - Ikon mitra yang sudah ada tetap dipakai: `Icons.dashboard`, `Icons.fastfood`, `Icons.receipt_long`, dan `Icons.store`. Labelnya Dashboard, Produk, Pesanan, dan Toko.
    - `MerchantShell` menjadi pemilik navbar dan menampung `MerchantDashboardPage`, `ProductListPage`, `OrderListPage`, serta `StoreProfilePage` di dalam `IndexedStack`.
    - Navbar yang sebelumnya berada pada masing-masing halaman tab dihapus agar tidak muncul dua kali. Halaman tambah produk, edit produk, dan scan QR tetap menjadi route tersendiri.
    - Route tab di `main.dart` membuka `MerchantShell` dengan indeks awal yang sesuai: `'/merchant'` = 0, `'/merchant-products'` = 1, `'/merchant-orders'` = 2, dan `'/merchant-store'` = 3.

## Alur Navigasi Mitra

1. Aplikasi membuka route mitra, misalnya `'/merchant'`. `MaterialApp` membuat `MerchantShell`; route tab lain memberikan `initialIndex` agar tab yang diminta langsung terpilih.
2. `MerchantShell` menyimpan `_selectedIndex`. Di dalam `Scaffold`, `IndexedStack` menampilkan halaman sesuai indeks dan `CurvedMerchantNav` selalu berada di bawah.
3. Saat pengguna menekan ikon, `CurvedMerchantNav` memanggil callback `onTap(index)` milik `MerchantShell`.
4. Callback menjalankan `setState` dan mengubah `_selectedIndex`. `IndexedStack` lalu menampilkan halaman mitra yang dipilih tanpa mengganti route atau membuat ulang shell.
5. Karena halaman tab tetap berada di `IndexedStack`, state widget seperti posisi scroll dapat dipertahankan ketika berpindah tab. Interaksi melalui navbar tidak memanggil `Navigator`.

Ringkasnya: **tap navbar → callback → `setState` → indeks `IndexedStack` berubah → konten berganti**. Ikon dan warna tidak perlu diubah untuk mendapatkan perilaku ini.

## Mengapa perubahan ini diperlukan

- **Masalah sebelumnya**: setiap kali pengguna menekan item pada `CurvedNavigationBar`, aplikasi memanggil `Navigator.pushReplacementNamed`. Itu mengganti seluruh halaman, sehingga seluruh widget dibangun ulang – terlihat seperti “flash” atau “reload”.
- **Solusi SPA**: dengan menempatkan semua halaman dalam satu `Scaffold` (melalui `HomeShell`) dan menggunakan `IndexedStack`, hanya konten yang berubah. Bar tetap berada di tempat, animasinya tidak terputus, dan state tiap halaman tetap terjaga.
- **Fallback**: `CurvedBottomNav` masih dapat dipakai secara terpisah (mis. pada halaman yang tidak berada dalam `HomeShell`) karena tetap memiliki logika navigasi lama bila `onTap` tidak diberikan.

## Cara menguji

1. Jalankan aplikasi (`flutter run`).
2. Setelah splash/login, pastikan aplikasi menavigasi ke `HomeShell` melalui route `'/home'`.
3. Tekan ikon‑ikon pada navigation bar. Konten halaman harus berubah tanpa flash, dan animasi bar tetap mulus.
4. Periksa bahwa scroll position atau data pada halaman tetap ketika berpindah tab (mis. scroll pada Home, kemudian kembali ke Home – posisi tetap).

## Catatan tambahan

- Jika Anda tidak ingin menggunakan `HomeShell` pada semua halaman, cukup panggil `CurvedBottomNav` dengan `onTap` yang mengubah indeks pada widget lain yang meng‑manage `IndexedStack`.
- Untuk mitra, gunakan `MerchantShell` dan `CurvedMerchantNav`; pertahankan ikon mitra yang sudah didefinisikan di `curved_merchant_nav.dart`.
- Warna customer dan mitra didefinisikan terpisah pada masing-masing widget navbar. Perubahan warnanya tidak diperlukan untuk mengubah cara pergantian tab bekerja.
- Dokumentasi ini berada di root proyek dengan nama **`documentation_dev.md`** sehingga mudah di‑akses untuk referensi selanjutnya.
