
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Admin | CFood</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

    <style>
        :root {
            --cfood-green: #198754;
            --cfood-dark: #145c38;
            --cfood-light: #eaf5ee;
            --cfood-text: #24352b;
        }

        * {
            box-sizing: border-box;
        }

        body {
            min-height: 100vh;
            margin: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px;
            background:
                radial-gradient(circle at 12% 15%, rgba(25, 135, 84, .12), transparent 28%),
                radial-gradient(circle at 90% 85%, rgba(25, 135, 84, .10), transparent 28%),
                #f4f8f5;
            color: var(--cfood-text);
            font-family: Inter, "Segoe UI", Arial, sans-serif;
        }

        .login-wrapper {
            width: 100%;
            max-width: 1000px;
            min-height: 590px;
            display: grid;
            grid-template-columns: 1fr 1fr;
            overflow: hidden;
            background: #fff;
            border: 1px solid #e8eee9;
            border-radius: 26px;
            box-shadow: 0 24px 70px rgba(31, 72, 47, .10);
        }

        .login-brand {
            position: relative;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            overflow: hidden;
            padding: 48px;
            color: white;
            background: linear-gradient(145deg, #198754, #11643e);
        }

        .login-brand::before,
        .login-brand::after {
            position: absolute;
            content: "";
            border: 1px solid rgba(255,255,255,.13);
            border-radius: 50%;
        }

        .login-brand::before {
            width: 420px;
            height: 420px;
            right: -190px;
            top: -120px;
        }

        .login-brand::after {
            width: 320px;
            height: 320px;
            right: -120px;
            bottom: -130px;
        }

        .brand-content,
        .brand-footer {
            position: relative;
            z-index: 1;
        }

        .brand-logo {
            width: 54px;
            height: 54px;
            display: grid;
            place-items: center;
            border-radius: 17px;
            background: white;
            color: var(--cfood-green);
            font-size: 28px;
            font-weight: 800;
        }

        .brand-title {
            margin-top: 65px;
            font-size: 36px;
            line-height: 1.2;
            font-weight: 750;
            letter-spacing: -.8px;
        }

        .brand-description {
            max-width: 340px;
            margin-top: 18px;
            color: rgba(255,255,255,.82);
            line-height: 1.8;
        }

        .brand-highlight {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            margin-top: 30px;
            padding: 11px 15px;
            border: 1px solid rgba(255,255,255,.22);
            border-radius: 30px;
            background: rgba(255,255,255,.10);
            font-size: 13px;
        }

        .brand-footer {
            color: rgba(255,255,255,.7);
            font-size: 12px;
        }

        .login-form-section {
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 55px 48px;
        }

        .login-form {
            width: 100%;
            max-width: 360px;
        }

        .form-heading {
            margin-bottom: 9px;
            font-size: 27px;
            font-weight: 750;
            letter-spacing: -.5px;
        }

        .form-subheading {
            margin-bottom: 32px;
            color: #7b8980;
            font-size: 14px;
            line-height: 1.6;
        }

        .form-label {
            margin-bottom: 9px;
            color: #34463a;
            font-size: 13px;
            font-weight: 650;
        }

        .input-group {
            overflow: hidden;
            border: 1px solid #e1e9e3;
            border-radius: 11px;
            background: #fbfdfb;
        }

        .input-group:focus-within {
            border-color: var(--cfood-green);
            box-shadow: 0 0 0 3px rgba(25,135,84,.10);
        }

        .input-group-text {
            border: 0;
            background: transparent;
            color: #849389;
            padding-left: 14px;
        }

        .form-control {
            min-height: 48px;
            border: 0;
            background: transparent;
            box-shadow: none !important;
            font-size: 14px;
        }

        .form-control:focus {
            background: transparent;
        }

        .btn-login {
            min-height: 49px;
            margin-top: 12px;
            border: 0;
            border-radius: 11px;
            background: var(--cfood-green);
            color: white;
            font-size: 14px;
            font-weight: 700;
            transition: .2s ease;
        }

        .btn-login:hover {
            background: var(--cfood-dark);
            color: white;
            transform: translateY(-1px);
        }

        .login-note {
            margin-top: 25px;
            color: #929e95;
            font-size: 12px;
            text-align: center;
        }

        @media (max-width: 767px) {
            .login-wrapper {
                max-width: 470px;
                grid-template-columns: 1fr;
            }

            .login-brand {
                min-height: 240px;
                padding: 28px;
            }

            .brand-title {
                margin-top: 25px;
                font-size: 27px;
            }

            .brand-description,
            .brand-highlight,
            .brand-footer {
                display: none;
            }

            .login-form-section {
                padding: 38px 28px;
            }
        }
    </style>
</head>

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
