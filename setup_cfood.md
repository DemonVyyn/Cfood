# Menjalankan Aplikasi Cfood

Dokumen ini menjelaskan langkah‑langkah minimal untuk menyiapkan dan menjalankan **backend** (Laravel) serta **aplikasi mobile** (Flutter) pada mesin Windows.

---

## Prasyarat

- **PHP 8.2+** dan **Composer**
- **Node.js 18+** serta **npm** (untuk aset Vite)
- **MySQL** (atau MariaDB yang kompatibel)
- **Flutter SDK** (versi stabil terbaru) dengan Android SDK / Xcode terpasang untuk platform target
- **Git** (untuk meng‑clone repositori)
- **OpenSSL** (dibutuhkan Laravel untuk menghasilkan kunci aplikasi)

Pastikan semua alat di atas sudah berada di `PATH` sistem.

---

## 1. Backend (Laravel)

1. Buka terminal dan masuk ke folder `backend`:
   ```cmd
   cd backend
   ```
2. Salin file contoh environment dan sesuaikan kredensial basis data:
   ```cmd
   copy .env.example .env
   ```
   Buka `.env` 
   ```
   DB_CONNECTION=mysql
   DB_HOST=127.0.0.1
   DB_PORT=3306
   DB_DATABASE=cfood
   DB_USERNAME=nama_user_anda
   DB_PASSWORD=password_anda
   ```
3. Instal dependensi PHP:
   ```cmd
   composer install
   ```
4. Buat kunci aplikasi Laravel:
   ```cmd
   php artisan key:generate
   ```
5. Jalankan migrasi basis data (membuat tabel):
   ```cmd
   php artisan migrate
   ```
6. (Opsional) Isi basis data dengan data contoh:
   ```cmd
   php artisan db:seed
   ```
7. Instal aset front‑end (Vite) dan mulai server pengembangan:
   ```cmd
   npm install
   npm run dev
   ```
8. Mulai server HTTP Laravel:
   ```cmd
   php artisan serve
   ```
   API akan tersedia di `http://127.0.0.1:8000`.

---

## 2. Aplikasi Mobile (Flutter)

1. Buka terminal baru dan masuk ke folder `mobile`:
   ```cmd
   cd mobile
   ```
2. Unduh dependensi Dart/Flutter:
   ```cmd
   flutter pub get
   ```
3. Hubungkan perangkat atau jalankan emulator (Android Studio, VS Code, atau iOS Simulator).
4. Jalankan aplikasi:
   ```cmd
   flutter run
   ```
   Aplikasi akan dikompilasi dan diluncurkan pada perangkat yang dipilih.

### Catatan khusus Android
- Pastikan variabel `ANDROID_HOME` mengarah ke direktori Android SDK.
- Buat atau jalankan Android Virtual Device (AVD) lewat Android Studio atau perintah:
  ```cmd
  flutter emulators --launch <id_emulator>
  ```

### Catatan khusus iOS (hanya macOS)
- Buka `ios/Runner.xcworkspace` di Xcode dan pilih simulator.
- Jalankan `flutter run` dari terminal; Xcode akan menangani proses build.

---

## 3. Pemecahan Masalah Umum

- **Ekstensi PHP yang hilang** – instal `ext-pdo_mysql`, `ext-openssl`, `ext-json` melalui manajer paket PHP Anda.
- **Port bentrok** – bila port `8000` sudah dipakai, jalankan Laravel pada port lain: `php artisan serve --port=8080`.
- **Gagal build Flutter** – jalankan `flutter doctor` dan perbaiki masalah yang dilaporkan.
- **Kesalahan koneksi basis data** – pastikan MySQL berjalan dan kredensial di `.env` sudah benar.

---

