# PROMPT UNTUK CODEX — FIX SELARA TUMBLER
# Cara pakai: Copy semua isi file ini, paste ke Codex. Jangan diubah.

================================================================
PROMPT (COPY DARI SINI)
================================================================

Halo Codex, tolong benerin 2 file ini. Jangan ubah design / palet / font. Jangan tampilkan WA / HP / teks pre-order / COD.

1. index.html (HALAMAN TOKO) — ini yang paling penting:
- getConfig() harus baca window.SELARA_CONFIG.supabaseUrl / supabaseAnonKey DULU, baru fallback ke window.__SELARA_CONFIG__.SUPABASE_URL / SUPABASE_ANON_KEY. Ini penyebab halaman toko stuck di "Memuat produk" terus, karena config live di /runtime-config.js itu formatnya window.SELARA_CONFIG camelCase.
- Kalau config gagal / fetch products gagal, jangan stuck di "Memuat produk". Tampilkan pesan: "Gagal memuat produk: [pesan error]" + tombol Coba Lagi.
- Pilihan WARNA di popup detail produk: ganti jadi INPUT KETIK MANUAL. Bukan swatch bulat, bukan dropdown, bukan checkbox. Formatnya persis: Label "Warna — ketik manual" + <input type="text" placeholder="misal: Merah">. Pembeli ketik bebas: Merah, Hitam, Biru. Nilai yang diketik ini yang dikirim ke WhatsApp saat checkout.
- Jangan ubah palet: Deep Rose #9d174d, Magenta #db2777, Soft Pink #fbcfe8, Blush #fdf2f8. Judul Georgia serif, body system sans.

2. admin.html (PANEL ADMIN):
- Pilihan WARNA di form Tambah Produk: ganti juga jadi INPUT KETIK MANUAL, bukan checkbox / swatch / dropdown. Formatnya: Label "Warna — ketik manual, pisah koma" + <input id="npColors" placeholder="misal: Merah, Hitam, Biru">. Saat simpan, split pakai koma jadi array colors.
- Pilihan WARNA di Input Order Manual: juga jadi INPUT KETIK MANUAL: <input placeholder="misal: Merah">.
- Login admin: JANGAN blokir login karena cek tabel admin_users / RLS. Siapa pun yang email + password-nya benar di Supabase Auth boleh masuk. Kalau login gagal, TAMPILKAN pesan error-nya (jangan diem aja). Kalau admin_users gagal dibaca, log ke console saja, tetap izinkan masuk.
- Pastikan <script src="/runtime-config.js"> pakai slash di depan (root-absolute).

Setelah semua selesai, jalankan npm run build dan laporkan. Jangan minta token saya, jangan login GitHub / Netlify sendiri.

================================================================
SAMPAI SINI PROMPT-NYA
================================================================


================================================================
KODE YANG HARUS DIPERBAIKI — CODEX TINGGAL COPY-PASTE
================================================================

------------------------------------------------
A. index.html — GANTI FUNGSI getConfig() YANG LAMA DENGAN INI
------------------------------------------------

Ganti fungsi getConfig() yang lama di index.html dengan kode ini persis:

```js
// FIX: baca SEMUA format config yang mungkin ada di live
// Live saat ini: window.SELARA_CONFIG = {supabaseUrl, supabaseAnonKey, waNumber}
// Versi lama: window.__SELARA_CONFIG__ = {SUPABASE_URL, SUPABASE_ANON_KEY}
function getConfig(){
  var c1 = window.SELARA_CONFIG || null;
  var c2 = window.__SELARA_CONFIG__ || window.SELARA_CONFIG__ || null;
  var c = c1 || c2 || {};
  var url = c.supabaseUrl || c.SUPABASE_URL || c.supabase_url || "";
  var key = c.supabaseAnonKey || c.SUPABASE_ANON_KEY || c.supabase_anon_key || c.anonKey || "";
  var wa = c.waNumber || c.WA_NUMBER || c.wa_number || "";
  return { url: url, key: key, wa: wa };
}
```

Dan pastikan di <head> index.html sudah pakai path root-absolute:
```html
<script src="/runtime-config.js"></script>
```
Bukan "runtime-config.js" tanpa slash.

------------------------------------------------
B. index.html — GANTI PILIHAN WARNA DI POPUP DETAIL PRODUK
------------------------------------------------

CARI kode lama yang seperti ini (swatch / checkbox / dropdown warna):
```html
<!-- HAPUS yang lama: swatch / checkbox / select warna -->
<div class="colors"> ... </div>
<select id="colorSelect"> ... </select>
```

GANTI dengan ini persis:

```html
<label style="display:block;font-size:13px;font-weight:700;margin-top:12px">
  Warna — ketik manual
  <input id="detailColor" type="text" placeholder="misal: Merah"
    style="width:100%;padding:11px;border:1px solid #f3d1e3;border-radius:12px;margin-top:6px;font-size:16px">
</label>
```

Di fungsi checkout / kirim ke WhatsApp, ambil warnanya dari input ini:
```js
var warnaDipilih = document.getElementById("detailColor").value.trim() || "Tanpa keterangan warna";
```

Jangan pakai lagi variabel dari swatch / checkbox / dropdown lama.

------------------------------------------------
C. index.html — JANGAN STUCK DI "Memuat produk"
------------------------------------------------

Di fungsi loadProducts(), ganti bagian catch / gagal dengan ini:

```js
try {
  var cfg = getConfig();
  if(!cfg.url || !cfg.key){
    throw new Error("Config Supabase tidak terbaca. Cek /runtime-config.js");
  }
  // ... fetch products seperti biasa ...
} catch(e){
  console.error(e);
  var el = document.getElementById("productGrid") || document.getElementById("products") || document.body;
  // Tampilkan pesan error di halaman, jangan stuck di "Memuat produk"
  var msg = document.createElement("div");
  msg.style.cssText = "background:#fff3cd;border:1px solid #ffcc00;border-radius:12px;padding:14px;margin:14px;";
  msg.innerHTML = "<b>Gagal memuat produk:</b> " + (e.message || e) + "<br><button onclick='location.reload()' style='margin-top:8px;padding:10px 16px;border-radius:999px;border:0;background:#db2777;color:#fff;font-weight:700;cursor:pointer'>Coba Lagi</button>";
  if(el && el.parentNode){
    // Sisipkan di atas grid, jangan hapus seluruh halaman
    el.parentNode.insertBefore(msg, el);
  }
}
```

------------------------------------------------
D. admin.html — GANTI INPUT WARNA DI FORM TAMBAH PRODUK
------------------------------------------------

CARI kode lama:
```html
<label>Warna (centang yang tersedia)</label>
<div class="colors-row" id="npColors"> ... checkbox ... </div>
```

GANTI dengan ini persis:

```html
<label style="margin-top:10px">Warna — ketik manual, pisah koma
  <input id="npColors" placeholder="misal: Merah, Hitam, Biru" value="Merah, Hitam, Biru">
</label>
```

CARI kode JS lama:
```js
var colors = Array.from(document.querySelectorAll("#npColors input:checked")).map(c=>c.value);
```

GANTI dengan ini persis:

```js
var colors = document.getElementById("npColors").value.split(",").map(function(s){ return s.trim(); }).filter(Boolean);
// ketik manual: Merah, Hitam, Biru
```

------------------------------------------------
E. admin.html — GANTI INPUT WARNA DI INPUT ORDER MANUAL
------------------------------------------------

CARI:
```html
<label>Warna<input id="moColor" placeholder="Rose"></label>
```

GANTI dengan:
```html
<label>Warna — ketik manual<input id="moColor" placeholder="misal: Merah"></label>
```

------------------------------------------------
F. admin.html — FIX LOGIN JANGAN DIEM / JANGAN BLOKIR KARENA admin_users
------------------------------------------------

GANTI fungsi doLogin() yang lama dengan ini persis:

```js
async function doLogin(){
  var errEl = document.getElementById("loginErr");
  errEl.style.display = "none";
  document.getElementById("loginLoading").style.display = "block";
  document.getElementById("loginLoading").textContent = "Memeriksa login...";
  var email = document.getElementById("loginEmail").value.trim();
  var password = document.getElementById("loginPass").value;
  if(!email || !password){
    document.getElementById("loginLoading").style.display = "none";
    showLoginError("Isi email dan password dulu.");
    return;
  }
  var sb = initSupabase();
  if(!sb){
    document.getElementById("loginLoading").style.display = "none";
    showLoginError("Konfigurasi Supabase belum terbaca. Lihat kotak kuning di atas.");
    return;
  }
  try{
    var res = await sb.auth.signInWithPassword({ email: email, password: password });
    if(res.error) throw res.error;
    var user = res.data && res.data.user;
    if(!user) throw new Error("Login gagal - tidak ada user dari Supabase.");
    // FIX: Jangan blokir login karena cek admin_users / RLS.
    // Cek admin_users hanya untuk info, gagal pun tetap masuk.
    try{
      var rowRes = await sb.from("admin_users").select("user_id").eq("user_id", user.id).maybeSingle();
      console.log("cek admin_users:", rowRes);
    }catch(e){ console.warn("cek admin_users diabaikan:", e); }
    document.getElementById("loginLoading").style.display = "none";
    document.getElementById("loginView").classList.add("hidden");
    document.getElementById("adminView").classList.remove("hidden");
    await loadAll();
  }catch(err){
    console.error("LOGIN ERROR:", err);
    document.getElementById("loginLoading").style.display = "none";
    var msg = (err && err.message) ? err.message : String(err);
    if(msg.indexOf("Invalid login credentials") !== -1) msg = "Email / password salah. Coba lagi, atau reset password di Supabase Auth.";
    if(msg.indexOf("Email not confirmed") !== -1) msg = "Email belum dikonfirmasi. Buka Supabase > Auth > Users > klik user-nya > Confirm Email.";
    if(msg.indexOf("Too many requests") !== -1) msg = "Terlalu banyak percobaan. Tunggu 1 menit lalu coba lagi.";
    showLoginError(msg);
  }
}
```

Dan fungsi getConfig() di admin.html juga harus sama seperti di Bagian A (baca SELARA_CONFIG dulu, baru __SELARA_CONFIG__).

------------------------------------------------
G. CHECKLIST CODEX SETELAH BENERIN
------------------------------------------------
- [ ] index.html: getConfig() sudah baca SELARA_CONFIG camelCase
- [ ] index.html: <script src="/runtime-config.js"> pakai slash depan
- [ ] index.html: Warna di popup detail = input ketik manual, bukan swatch / dropdown
- [ ] index.html: Kalau gagal load, muncul pesan error + tombol Coba Lagi, tidak stuck "Memuat produk"
- [ ] admin.html: Warna Tambah Produk = input ketik manual pisah koma
- [ ] admin.html: Warna Order Manual = input ketik manual
- [ ] admin.html: Login tidak blokir karena admin_users / RLS, error ditampilkan
- [ ] npm run build sukses
- [ ] Jangan commit / push / deploy tanpa perintah user
