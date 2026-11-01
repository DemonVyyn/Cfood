
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Admin | CFood</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="{{ asset('css/admin/auth/login.css') }}" rel="stylesheet">

<body>

<div class="login-wrapper">

    <section class="login-brand">
        <div class="brand-content">
            <div class="brand-logo">
                <i class="bi bi-leaf-fill"></i>
            </div>

            <h1 class="brand-title">
                Selamat Datang di<br>
                CFood Admin.
            </h1>

            <p class="brand-description">
                Kelola platform distribusi makanan berlebih dengan lebih
                mudah, terstruktur, dan efisien.
            </p>

            <div class="brand-highlight">
                <i class="bi bi-recycle"></i>
                <span>Bersama mengurangi food waste</span>
            </div>
        </div>

        <div class="brand-footer">
            CFood — Platform Pengurangan Food Waste
        </div>
    </section>

    <section class="login-form-section">
        <div class="login-form">

            <div class="mb-4">
                <span class="text-uppercase fw-bold"
                      style="color: #198754; font-size: 11px; letter-spacing: 1.5px;">
                    Administrator Access
                </span>

                <h2 class="form-heading mt-2">Login Admin</h2>

                <p class="form-subheading">
                    Masukkan akun administrator untuk melanjutkan
                    ke dashboard CFood.
                </p>
            </div>

            @if (session('success'))
                <div class="alert alert-success small">
                    {{ session('success') }}
                </div>
            @endif

            @if ($errors->any())
                <div class="alert alert-danger small">
                    {{ $errors->first() }}
                </div>
            @endif

            <form action="{{ route('admin.login.process') }}" method="POST">
                @csrf

                <div class="mb-3">
                    <label for="email" class="form-label">Email Admin</label>

                    <div class="input-group">
                        <span class="input-group-text">
                            <i class="bi bi-envelope"></i>
                        </span>

                        <input
                            type="email"
                            id="email"
                            name="email"
                            class="form-control"
                            placeholder="admin@example.com"
                            value="{{ old('email') }}"
                            autocomplete="username"
                            required
                            autofocus
                        >
                    </div>
                </div>

                <div class="mb-4">
                    <label for="password" class="form-label">Password</label>

                    <div class="input-group">
                        <span class="input-group-text">
                            <i class="bi bi-lock"></i>
                        </span>

                        <input
                            type="password"
                            id="password"
                            name="password"
                            class="form-control"
                            placeholder="Masukkan password"
                            autocomplete="current-password"
                            required
                        >
                    </div>
                </div>

                <button type="submit" class="btn btn-login w-100">
                    Masuk ke Dashboard
                    <i class="bi bi-arrow-right ms-2"></i>
                </button>
            </form>

            <div class="login-note">
                <i class="bi bi-shield-check me-1"></i>
                Halaman khusus administrator CFood
            </div>

        </div>
    </section>

</div>

</body>
</html>
