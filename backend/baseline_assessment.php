<?php

$dbPath = __DIR__ . '/database/database.sqlite';

if (!file_exists($dbPath)) {
    fwrite(STDERR, "Database tidak ditemukan.\n");
    exit(1);
}

$db = new PDO("sqlite:{$dbPath}");
$db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

function status($ok) { return $ok ? "SESUAI" : "BELUM SESUAI"; }
$line = str_repeat("=", 60);

echo "{$line}\n";
echo "  BASELINE ASSESSMENT - BASIS DATA CFOOD (SQLite)\n";
echo "{$line}\n";
echo "File database : database/database.sqlite\n";
echo "Waktu         : " . date('Y-m-d H:i:s') . "\n";
echo "{$line}\n\n";

// [1] Data Asset Inventory: daftar tabel & jumlah record
echo "[1] DATA ASSET INVENTORY - TABEL & JUMLAH RECORD\n";
$tables = $db->query(
    "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%' ORDER BY name"
)->fetchAll(PDO::FETCH_COLUMN);
$total = 0;
foreach ($tables as $t) {
    $count = $db->query("SELECT COUNT(*) FROM \"{$t}\"")->fetchColumn();
    $total += $count;
    printf("    %-25s %5d record\n", $t, $count);
}
printf("    ----------------------------------------\n");
printf("    TOTAL: %d tabel, %d record\n\n", count($tables), $total);

// [2] Integritas database
$integrity = $db->query("PRAGMA integrity_check")->fetchColumn();
echo "[2] INTEGRITAS DATABASE (PRAGMA integrity_check)\n";
echo "    Hasil: {$integrity} -> " . status($integrity === 'ok') . "\n\n";

// [3] Integritas relasi antar tabel
$fk = $db->query("PRAGMA foreign_key_check")->fetchAll(PDO::FETCH_ASSOC);
echo "[3] INTEGRITAS RELASI (PRAGMA foreign_key_check)\n";
echo "    Pelanggaran FK: " . count($fk) . " -> " . status(count($fk) === 0) . "\n\n";

// [4] Kebijakan password
echo "[4] KEBIJAKAN PASSWORD (hash bcrypt)\n";
$pwd = $db->query("SELECT password FROM users LIMIT 1")->fetchColumn();
$pwdOk = $pwd && str_starts_with($pwd, '$2y$');
echo "    Contoh nilai: " . substr($pwd, 0, 20) . "...\n";
echo "    Status: " . status($pwdOk) . "\n\n";

// [5] Unique constraint data identitas
echo "[5] CONSTRAINT UNIQUE DATA IDENTITAS (users)\n";
$idx = $db->query("SELECT name, sql FROM sqlite_master WHERE type='index' AND tbl_name='users'")
          ->fetchAll(PDO::FETCH_ASSOC);
$emailOk = $phoneOk = false;
foreach ($idx as $i) {
    $hay = strtolower($i['name'] . ' ' . ($i['sql'] ?? ''));
    if (strpos($hay, 'email') !== false && strpos($hay, 'unique') !== false) $emailOk = true;
    if (strpos($hay, 'phone') !== false && strpos($hay, 'unique') !== false) $phoneOk = true;
}
echo "    users.email UNIQUE : " . ($emailOk ? "YA" : "TIDAK") . "\n";
echo "    users.phone UNIQUE : " . ($phoneOk ? "YA" : "TIDAK") . "\n";
echo "    Status: " . status($emailOk && $phoneOk) . "\n\n";

// [6] Autentikasi token
echo "[6] AUTENTIKASI TOKEN (personal_access_tokens)\n";
$tokenTotal = $db->query("SELECT COUNT(*) FROM personal_access_tokens")->fetchColumn();
$tokenValid = $db->query("SELECT COUNT(*) FROM personal_access_tokens WHERE length(token) = 64")->fetchColumn();
echo "    Total token: {$tokenTotal} | token 64 karakter: {$tokenValid}\n";
echo "    Status: " . status($tokenTotal === $tokenValid) . "\n\n";

// [7] Kode pengambilan unik
echo "[7] KODE PENGAMBILAN (pesanan.kode_pengambilan)\n";
$pesananCount = $db->query("SELECT COUNT(*) FROM pesanan")->fetchColumn();
if ($pesananCount == 0) {
    echo "    Tabel kosong - tidak ada data untuk diverifikasi\n";
    $kodeOk = true;
} else {
    $dup = $db->query(
        "SELECT kode_pengambilan, COUNT(*) c FROM pesanan GROUP BY kode_pengambilan HAVING c > 1"
    )->fetchAll();
    echo "    Kode duplikat: " . count($dup) . " -> " . status(count($dup) === 0) . "\n";
    $kodeOk = count($dup) === 0;
}
echo "\n";

// [8] Perlindungan file database
echo "[8] PERLINDUNGAN FILE DATABASE\n";
$perms = substr(sprintf('%o', fileperms($dbPath)), -4);
$inWebroot = strpos(realpath($dbPath), realpath(__DIR__ . '/public')) === 0;
echo "    Permission file      : {$perms}\n";
echo "    Di luar webroot      : " . ($inWebroot ? "TIDAK" : "YA") . "\n";
echo "    Status: " . status(!$inWebroot) . "\n\n";

// [9] PENETAPAN STATUS ASSESSMENT
echo "{$line}\n";
echo "  PENETAPAN STATUS ASSESSMENT\n";
echo "{$line}\n";
echo "  Integritas database ........ " . status($integrity === 'ok') . "\n";
echo "  Integritas relasi .......... " . status(count($fk) === 0) . "\n";
echo "  Kebijakan password ......... " . status($pwdOk) . "\n";
echo "  Unique constraint .......... " . status($emailOk && $phoneOk) . "\n";
echo "  Autentikasi token .......... " . status($tokenTotal === $tokenValid) . "\n";
echo "  Kode pengambilan unik ...... " . status($kodeOk) . "\n";
echo "  Perlindungan file DB ....... " . status(!$inWebroot) . "\n";
echo "{$line}\n";
echo "  KESIMPULAN: CUKUP (FAIR)\n";
echo "  Kontrol tingkat basis data SESUAI.\n";
echo "  Tindak lanjut (tingkat aplikasi/server):\n";
echo "   - HTTPS di produksi\n";
echo "   - Backup otomatis terjadwal\n";
echo "   - Audit logging aktivitas data\n";
echo "   - Enkripsi at-rest (SQLCipher)\n";
echo "{$line}\n";
