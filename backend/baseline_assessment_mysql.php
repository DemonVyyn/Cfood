<?php

require __DIR__ . '/vendor/autoload.php';
$app = require_once __DIR__ . '/bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

use Illuminate\Support\Facades\DB;

$line = str_repeat("=", 72);
$statusList = [];
$findings   = [];

function setStatus(&$statusList, &$findings, $kode, $nama, $status, $catatan = '') {
    $statusList[$kode] = $status;
    $findings[] = ['kode' => $kode, 'nama' => $nama, 'status' => $status, 'catatan' => $catatan];
}

echo "{$line}\n";
echo "  BASELINE ASSESSMENT - KEAMANAN BASIS DATA CFOOD (MySQL)\n";
echo "{$line}\n";
echo "Koneksi : " . config('database.default') . "\n";
echo "Database: " . DB::connection()->getDatabaseName() . "\n";
echo "Waktu   : " . date('Y-m-d H:i:s') . "\n";
echo "{$line}\n\n";

// [1] Data Asset Inventory
echo "[1] DATA ASSET INVENTORY - TABEL & JUMLAH RECORD\n";
$tables = DB::select("SHOW TABLES");
$key = "Tables_in_" . DB::connection()->getDatabaseName();
$total = 0; $n = 0;
foreach ($tables as $t) {
    $name = $t->$key;
    $c = DB::table($name)->count();
    $total += $c; $n++;
    printf("    %-28s %6d record\n", $name, $c);
}
printf("    ------------------------------------------------\n");
printf("    TOTAL: %d tabel, %d record\n\n", $n, $total);
setStatus($statusList, $findings, 'B1', 'Data Asset Inventory', 'Comply', "{$n} tabel terinventarisasi");

// [2] Account aplikasi bukan root
echo "[2] PEMISAHAN DATABASE ACCOUNT (bukan root)\n";
$user = config('database.connections.mysql.username');
$notRoot = ($user !== 'root');
echo "    Username aplikasi : {$user}\n";
echo "    Status: " . ($notRoot ? 'Comply' : 'Not Comply') . "\n\n";
setStatus($statusList, $findings, 'B2', 'Pemisahan Database Account',
    $notRoot ? 'Comply' : 'Not Comply', "user = {$user}");

// [3] Least privilege
echo "[3] LEAST PRIVILEGE (SHOW GRANTS)\n";
try {
    $grants = DB::select("SHOW GRANTS FOR CURRENT_USER()");
    $grantText = '';
    foreach ($grants as $g) { $grantText .= array_values((array)$g)[0] . "\n    "; }
    echo "    " . trim($grantText) . "\n";
    $hasAll = stripos($grantText, 'ALL PRIVILEGES') !== false;
    $status = $hasAll ? 'Partially Comply' : 'Comply';
    echo "    ALL PRIVILEGES ditemukan: " . ($hasAll ? 'YA' : 'TIDAK') . "\n";
    echo "    Status: {$status}\n\n";
    setStatus($statusList, $findings, 'B3', 'Least Privilege', $status,
        $hasAll ? 'masih ada ALL PRIVILEGES' : 'privilege terbatas DML');
} catch (\Throwable $e) {
    echo "    Tidak bisa membaca grants: {$e->getMessage()}\n\n";
    setStatus($statusList, $findings, 'B3', 'Least Privilege', 'N/A', $e->getMessage());
}

// [4] Kebijakan password tidak plaintext
echo "[4] KEBIJAKAN PASSWORD (bcrypt, bukan plaintext)\n";
$pwd = DB::table('users')->value('password');
$pwdOk = $pwd && str_starts_with($pwd, '$2y$');
echo "    Contoh nilai: " . substr((string)$pwd, 0, 20) . "...\n";
echo "    Status: " . ($pwdOk ? 'Comply' : 'Not Comply') . "\n\n";
setStatus($statusList, $findings, 'B4', 'Perlindungan Password',
    $pwdOk ? 'Comply' : 'Not Comply', $pwdOk ? 'bcrypt $2y$ terdeteksi' : 'tidak ter-hash');

// [5] Unique constraint identitas
echo "[5] CONSTRAINT UNIQUE DATA IDENTITAS (users)\n";
$idx = DB::select("SHOW INDEX FROM users");
$emailOk = $phoneOk = false;
foreach ($idx as $i) {
    if ($i->Non_unique == 0 && $i->Column_name === 'email') $emailOk = true;
    if ($i->Non_unique == 0 && $i->Column_name === 'phone') $phoneOk = true;
}
echo "    users.email UNIQUE : " . ($emailOk ? 'YA' : 'TIDAK') . "\n";
echo "    users.phone UNIQUE : " . ($phoneOk ? 'YA' : 'TIDAK') . "\n";
$s = ($emailOk && $phoneOk) ? 'Comply' : 'Partially Comply';
echo "    Status: {$s}\n\n";
setStatus($statusList, $findings, 'B5', 'Unique Constraint Identitas', $s);

// [6] Autentikasi token
echo "[6] AUTENTIKASI TOKEN (personal_access_tokens)\n";
$tt = DB::table('personal_access_tokens')->count();
$tv = DB::table('personal_access_tokens')->whereRaw('LENGTH(token) = 64')->count();
echo "    Total token: {$tt} | token 64 karakter: {$tv}\n";
$s = ($tt === $tv) ? 'Comply' : 'Not Comply';
echo "    Status: {$s}\n\n";
setStatus($statusList, $findings, 'B6', 'Autentikasi Token', $s, "{$tv}/{$tt} valid");

// [7] Kode pengambilan unik
echo "[7] KODE PENGAMBILAN UNIK (pesanan)\n";
$pc = DB::table('pesanan')->count();
if ($pc == 0) {
    echo "    Tabel kosong - N/A\n\n";
    setStatus($statusList, $findings, 'B7', 'Kode Pengambilan Unik', 'N/A', 'belum ada data');
} else {
    $dup = DB::select("SELECT kode_pengambilan, COUNT(*) c FROM pesanan GROUP BY kode_pengambilan HAVING c > 1");
    echo "    Kode duplikat: " . count($dup) . "\n";
    $s = count($dup) === 0 ? 'Comply' : 'Not Comply';
    echo "    Status: {$s}\n\n";
    setStatus($statusList, $findings, 'B7', 'Kode Pengambilan Unik', $s);
}

// [8] Enkripsi data sensitif
echo "[8] ENKRIPSI DATA SENSITIF (mitra.alamat, mitra.nomor_telepon)\n";
$raw = DB::table('mitra')->value('nomor_telepon');
$encrypted = $raw && !preg_match('/^[0-9+\-\s()]+$/', (string)$raw);
echo "    Nilai tersimpan: " . substr((string)$raw, 0, 30) . "...\n";
$s = DB::table('mitra')->count() === 0 ? 'N/A' : ($encrypted ? 'Comply' : 'Not Comply');
echo "    Terenkripsi: " . ($encrypted ? 'YA' : 'TIDAK') . "\n";
echo "    Status: {$s}\n\n";
setStatus($statusList, $findings, 'B8', 'Enkripsi Data Sensitif', $s);

// [9] Audit trail tersedia
echo "[9] AUDIT TRAIL (activity_log)\n";
$hasAudit = DB::getSchemaBuilder()->hasTable('activity_log');
echo "    Tabel activity_log: " . ($hasAudit ? 'ADA' : 'TIDAK ADA') . "\n";
$s = $hasAudit ? 'Comply' : 'Not Comply';
if ($hasAudit) {
    echo "    Jumlah entri: " . DB::table('activity_log')->count() . "\n";
}
echo "    Status: {$s}\n\n";
setStatus($statusList, $findings, 'B9', 'Audit Trail', $s);

// [10] View pembatasan data
echo "[10] PEMBATASAN DATA DENGAN VIEW\n";
$views = DB::select("SHOW FULL TABLES WHERE Table_type = 'VIEW'");
$vc = count($views);
echo "    Jumlah view: {$vc}\n";
$s = $vc > 0 ? 'Comply' : 'Not Comply';
echo "    Status: {$s}\n\n";
setStatus($statusList, $findings, 'B10', 'Pembatasan Data dengan View', $s, "{$vc} view");

// ================= REKAP 4 LEVEL =================
echo "\n{$line}\n";
echo "  REKAP STATUS (Comply / Partially Comply / Not Comply / N/A)\n";
echo "{$line}\n";
$hitung = ['Comply' => 0, 'Partially Comply' => 0, 'Not Comply' => 0, 'N/A' => 0];
foreach ($findings as $f) {
    printf("    %-34s %-16s %s\n", $f['nama'], $f['status'], $f['catatan']);
    $hitung[$f['status']]++;
}
echo "{$line}\n";
foreach ($hitung as $k => $v) {
    echo "    {$k}: {$v}\n";
}
$totalKontrol = count($findings);
$selain = $totalKontrol - $hitung['N/A'];
$persen = $selain > 0 ? round($hitung['Comply'] / $selain * 100) : 0;
echo "{$line}\n";
echo "  KESIMPULAN (dihitung otomatis):\n";
echo "    Comply {$hitung['Comply']} / {$selain} kontrol yang berlaku = {$persen}%\n";
if ($hitung['Not Comply'] === 0 && $hitung['Partially Comply'] === 0) {
    echo "    POSTUR: GOOD\n";
} elseif ($persen >= 70) {
    echo "    POSTUR: FAIR\n";
} else {
    echo "    POSTUR: POOR\n";
}
echo "{$line}\n";
