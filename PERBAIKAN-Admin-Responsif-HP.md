# PERBAIKAN — ADMIN RESPONSIF HP + ADMIN TIDAK DI HALAMAN PUBLIK (UNTUK CODEX)

## INSTRUKSI UNTUK CODEX — WAJIB DIIKUTI, JANGAN KELUAR JALUR
1. Baca file ini sampai habis. Ini satu-satunya tugas di turn ini. Jangan kerjakan tugas lain, jangan redesign total, jangan ubah palet / font / teks / fitur yang sudah jalan.
2. Palet tetap: Deep Rose #9d174d, Magenta #db2777, Soft Pink #fbcfe8, Blush #fdf2f8. Judul Georgia serif, body system sans-serif.
3. Jangan minta token / key / isi .env. Jangan hubungkan GitHub / Supabase / Netlify CLI. Jangan buat remote git. Jangan commit / push / deploy tanpa perintah user. Kerjakan lokal saja di C:\Users\Hype GLK\Documents\Projects\selara-tumbler
4. Setelah selesai, jalankan `npm run build` dan laporkan file yang diubah + hasil build.

---
## §1 ADMIN TIDAK BOLEH DI HALAMAN PUBLIK
- HAPUS TOTAL semua link / tombol / teks yang bisa diklik dan mengarah ke Admin dari `index.html` dan halaman publik lain: `<a href="admin.html">Admin</a>`, `<a href="/admin">Admin</a>`, `onclick` ke admin, kata `Admin` di header / tabs / footer / menu.
- Jangan ganti dengan "Login" / ikon gembok / ikon user yang mengarah ke admin. HAPUS saja.
- Setelah dihapus, tabs di index.html hanya: Katalog, Keranjang, FAQ.
- File `admin.html` TETAP ADA, hanya link-nya yang dihapus dari publik.
- Link "Lihat Toko" di dalam admin BOLEH dipertahankan (arah Admin -> Publik itu aman).
- `admin.html` tetap pakai Supabase Auth + cek `admin_users` via RPC. Jangan kembalikan ke hardcode.

## §2 NETLIFY — AKSES ADMIN HANYA VIA /admin
Pastikan `netlify.toml` punya ini (pertahankan `publish` dan `command` yang sudah jalan, jangan timpa jika sudah benar):
```toml
[build]
  publish = "."
  command = "npm run build"

[[redirects]]
  from = "/admin"
  to = "/admin.html"
  status = 200

[[redirects]]
  from = "/admin/*"
  to = "/admin.html"
  status = 200
```

---
## §3 ADMIN.HTML HARUS LEBIH RESPONSIF HP (PRIORITAS UTAMA)
Tujuan: di HP 360px-430px tidak ada horizontal scroll / overflow, semua bisa dipencet jempol, tidak ada yang terpotong. Di desktop tampilannya tetap sama seperti sekarang.

### 3a. Header
- Di HP: header wrap rapi 2 baris jika perlu, logo mengecil, tombol Lihat Toko + Keluar tetap bisa diklik, tidak terpotong.
- Gunakan `flex-wrap: wrap`, `max-width: 100%`, `box-sizing: border-box` di semua kontainer.

### 3b. Tabs (Dashboard / Produk / Pesanan / Input Order Manual / Pengaturan)
- Di HP: tabs bisa di-scroll horizontal dengan jari, pakai `overflow-x: auto`, `scroll-snap-type: x mandatory`, `scrollbar-width: none` + `::-webkit-scrollbar { display: none }`.
- Tab tidak boleh bikin halaman melebar. Tab aktif tetap jelas (background Rose).
- Di desktop: tabs tetap tampil normal seperti sekarang.

### 3c. 4 Kartu Statistik Dashboard
- Desktop: 4 kolom. HP: 2 kolom (grid 2x2).
- CSS contoh pola (sesuaikan dengan kode yang sudah ada, jangan ganti nama class sembarangan):
```css
.grid4 { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
@media (min-width: 800px) { .grid4 { grid-template-columns: repeat(4, 1fr); } }
.stat b { font-size: 22px; }
@media (min-width: 800px) { .stat b { font-size: 26px; } }
```
- Padding kartu di HP lebih ramping (12px-14px).

### 3d. Tabel -> Kartu di HP (WAJIB)
- Tabel Pesanan Terbaru, Daftar Produk, Semua Pesanan: di DESKTOP tetap tabel.
- Di HP (max-width 719px): sembunyikan `thead`, ubah setiap `tr` jadi kartu vertikal: `display: block`, `background: #fff`, `border: 1px solid var(--line)`, `border-radius: 14px`, `padding: 12px`, `margin-bottom: 10px`.
- Setiap `td` di HP jadi `display: flex; justify-content: space-between;` dengan label di kiri (gunakan `data-label` atau `::before` dari header) agar terbaca: Nama / Produk / Total / Status.
- Tombol status / aksi di HP harus full-width atau minimal tinggi 44px, mudah dipencet.
- JANGAN biarkan tabel memaksa scroll horizontal di HP.

### 3e. Form (Tambah Produk, Input Order Manual, Pengaturan)
- Di HP: semua form jadi 1 kolom penuh, `input, select, textarea { width: 100%; }`, label di atas input.
- Tombol Simpan di HP: `width: 100%`, `padding: 13px`, `min-height: 44px`.
- Checkbox warna: di HP wrap dengan gap 10px, ukuran sentuh minimal 44px.
- Semua `input` di HP: `font-size: 16px` agar tidak auto-zoom di iOS.

### 3f. Grafik 7 Hari
- Pastikan 7 batang muat di HP, label Sen-Ming tidak terpotong. Gunakan `min-height` dan `flex: 1` yang sudah ada, kurangi gap di HP jika perlu.

### 3g. Global Anti-Overflow
Tambahkan di atas CSS admin.html jika belum ada:
```css
* { box-sizing: border-box; }
html, body { overflow-x: hidden; max-width: 100%; }
img, table, input, select, textarea { max-width: 100%; }
```

---
## §4 YANG TIDAK BOLEH DIUBAH
- Jangan tampilkan nomor WA / HP di mana pun.
- Jangan tambahkan teks pre-order / PO / COD / Bayar saat barang siap.
- Jangan tambahkan tombol print / PDF.
- Jangan ubah logika Supabase: katalog dari `products_public`, admin Auth + `admin_users`, order / produk dari Supabase, upload foto ke Storage.
- Jangan ubah `HANDOFF.md` kecuali diminta.

---
## §5 CHECKLIST SEBELUM SELESAI (Codex wajib centang)
- [ ] Di `index.html` tidak ada lagi link / tombol Admin yang bisa diklik
- [ ] `netlify.toml` punya redirect `/admin` dan `/admin/*` -> `/admin.html` (200)
- [ ] Di HP 360px-430px: tidak ada horizontal scroll di semua tab admin
- [ ] Di HP: tabs bisa digeser jari, kartu statistik 2x2, tabel berubah jadi kartu, form 1 kolom full-width
- [ ] Di desktop: tampilan admin tetap sama seperti sebelum perbaikan
- [ ] `npm run build` sukses, tidak ada error SUPABASE_URL / SUPABASE_ANON_KEY
- [ ] Tidak ada commit / push / deploy yang dilakukan

---
## §6 PROMPT SIAP COPY-PASTE KE CODEX
> Halo Codex, kerjakan file PERBAIKAN ini saja. 1) Hapus semua link Admin dari halaman publik index.html, Admin hanya via /admin. 2) Buat admin.html jauh lebih responsif HP: header wrap, tabs bisa digeser, kartu statistik 2x2 di HP, tabel jadi kartu di HP, form 1 kolom full-width, tidak ada horizontal scroll di 360px-430px. Jangan ubah palet / font / logika Supabase / design desktop. Setelah selesai jalankan npm run build dan laporkan.
