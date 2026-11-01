<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tambah Pengguna | CFood Admin</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="{{ asset('css/admin/users/users_create.css') }}" rel="stylesheet">

</head>
<body>

<div class="page-wrapper">
    <div class="topbar">
        <div class="brand">CFood <span>Admin</span></div>

        <a href="{{ route('admin.users.index') }}" class="btn btn-light">
            <i class="bi bi-arrow-left me-1"></i>
            Kembali
        </a>
    </div>

    <div class="form-card">
        <h1 class="form-title">Tambah Akun Pengguna</h1>
        <p class="form-subtitle">
            Masukkan informasi untuk membuat akun pengguna CFood yang baru.
        </p>

        @if ($errors->any())
            <div class="alert alert-danger">
                <strong>Periksa kembali data yang dimasukkan.</strong>
                <ul class="mb-0 mt-2">
                    @foreach ($errors->all() as $error)
                        <li>{{ $error }}</li>
                    @endforeach
                </ul>
            </div>
        @endif

        <form action="{{ route('admin.users.store') }}" method="POST">
            @csrf

            <div class="row g-4">
                <div class="col-md-6">
                    <label for="nama" class="form-label">
                        Nama Lengkap <span class="required">*</span>
                    </label>
                    <input
                        type="text"
                        class="form-control @error('nama') is-invalid @enderror"
                        id="nama"
                        name="nama"
                        value="{{ old('nama') }}"
                        placeholder="Masukkan nama lengkap"
                        required
                    >
                    @error('nama')
                        <div class="invalid-feedback">{{ $message }}</div>
                    @enderror
                </div>

                <div class="col-md-6">
                    <label for="email" class="form-label">
                        Email <span class="required">*</span>
                    </label>
                    <input
                        type="email"
                        class="form-control @error('email') is-invalid @enderror"
                        id="email"
                        name="email"
                        value="{{ old('email') }}"
                        placeholder="contoh@email.com"
                        required
                    >
                    @error('email')
                        <div class="invalid-feedback">{{ $message }}</div>
                    @enderror
                </div>

                <div class="col-md-6">
                    <label for="phone" class="form-label">
                        Nomor HP <span class="required">*</span>
                    </label>
                    <input
                        type="text"
                        class="form-control @error('phone') is-invalid @enderror"
                        id="phone"
                        name="phone"
                        value="{{ old('phone') }}"
                        placeholder="Masukkan nomor HP"
                        required
                    >
                    @error('phone')
                        <div class="invalid-feedback">{{ $message }}</div>
                    @enderror
                </div>

                <div class="col-md-6">
                    <label for="role" class="form-label">
                        Role Pengguna <span class="required">*</span>
                    </label>
                    <select
                        class="form-select @error('role') is-invalid @enderror"
                        id="role"
                        name="role"
                        required
                    >
                        <option value="">Pilih role pengguna</option>
                        <option value="customer" {{ old('role') === 'customer' ? 'selected' : '' }}>
                            Customer
                        </option>
                        <option value="mitra" {{ old('role') === 'mitra' ? 'selected' : '' }}>
                            Mitra
                        </option>
                        <option value="admin" {{ old('role') === 'admin' ? 'selected' : '' }}>
                            Admin
                        </option>
                    </select>
                    @error('role')
                        <div class="invalid-feedback">{{ $message }}</div>
                    @enderror
                </div>

                <div class="col-md-6">
                    <label for="password" class="form-label">
                        Password <span class="required">*</span>
                    </label>
                    <input
                        type="password"
                        class="form-control @error('password') is-invalid @enderror"
                        id="password"
                        name="password"
                        placeholder="Minimal 8 karakter"
                        required
                    >
                    @error('password')
                        <div class="invalid-feedback">{{ $message }}</div>
                    @enderror
                </div>

                <div class="col-md-6">
                    <label for="password_confirmation" class="form-label">
                        Konfirmasi Password <span class="required">*</span>
                    </label>
                    <input
                        type="password"
                        class="form-control"
                        id="password_confirmation"
                        name="password_confirmation"
                        placeholder="Ulangi password"
                        required
                    >
                </div>

                <div class="col-md-6">
                    <label for="status" class="form-label">
                        Status Akun <span class="required">*</span>
                    </label>
                    <select
                        class="form-select @error('status') is-invalid @enderror"
                        id="status"
                        name="status"
                        required
                    >
                        <option value="active" {{ old('status', 'active') === 'active' ? 'selected' : '' }}>
                            Aktif
                        </option>
                        <option value="suspended" {{ old('status') === 'suspended' ? 'selected' : '' }}>
                            Ditangguhkan
                        </option>
                    </select>
                    @error('status')
                        <div class="invalid-feedback">{{ $message }}</div>
                    @enderror
                </div>
            </div>

            <hr class="my-4">

            <div class="d-flex justify-content-end gap-2 form-actions">
                <a href="{{ route('admin.users.index') }}" class="btn btn-light">
                    Batal
                </a>
                <button type="submit" class="btn btn-success">
                    <i class="bi bi-person-plus me-1"></i>
                    Simpan Pengguna
                </button>
            </div>
        </form>
    </div>
</div>

</body>
</html>