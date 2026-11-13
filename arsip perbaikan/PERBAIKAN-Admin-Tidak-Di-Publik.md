# PERBAIKAN — ADMIN JANGAN DI HALAMAN PUBLIK (UNTUK CODEX)

## INSTRUKSI UNTUK CODEX — WAJIB DIIKUTI, JANGAN UBAH DESIGN LAIN
1. Baca file ini sampai habis. Ini adalah satu-satunya tugas di turn ini. Jangan kerjakan tugas lain, jangan redesign, jangan ubah warna / layout / teks / perilaku lain.
2. Tujuan: Halaman Admin TIDAK BOLEH bisa diakses dari halaman publik. Tidak ada tombol, link, teks, atau menu apapun di `index.html` (atau halaman publik lain) yang mengarah ke Admin.
3. Akses Admin HANYA via URL langsung: `https://DOMAIN_SITUS/admin` (dan `https://DOMAIN_SITUS/admin.html` tetap boleh jalan sebagai fallback teknis, tapi JANGAN dipromosikan di UI).
4. Jangan hapus file `admin.html`. File-nya tetap ada, hanya link-nya yang dihapus dari publik.
5. Jangan ubah isi / tampilan `admin.html` itu sendiri. Hanya ubah cara aksesnya.
6. Setelah selesai, jalankan `npm run build` lagi untuk memastikan tidak ada error. Laporkan file apa saja yang diubah.

---
## §1 YANG HARUS DIHAPUS DI index.html
Cari dan HAPUS semua elemen berikut di `index.html` (dan di file publik lain jika ada):

- Tombol / link di tabs: `<a href="admin.html" ...>Admin</a>` — HAPUS TOTAL.
- Tombol / link lain yang mengandung kata `Admin`, `admin.html`, `/admin`, `Panel Admin`, `Lihat Admin`, `Masuk Admin` di halaman publik — HAPUS TOTAL.
- Jika ada di footer / header / menu mobile / dropdown — HAPUS juga.
- Jangan ganti dengan teks lain seperti "Login" / "Masuk" / ikon gembok / ikon user yang mengarah ke admin. HAPUS saja, jangan diganti dengan link tersembunyi.

Contoh yang HARUS HILANG (jangan cari persis string ini, cari polanya):
```html
<!-- HAPUS — contoh yang dilarang -->
<a href="admin.html">Admin</a>
<a href="/admin">Admin</a>
<button onclick="location.href='admin.html'">Admin</button>
```

Setelah dihapus, tabs di `index.html` hanya boleh berisi:
- Katalog
- Keranjang
- FAQ

Tidak ada lagi tab / tombol Admin.

---
## §2 YANG HARUS DITAMBAH / DIPASTIKAN DI netlify.toml
Pastikan `netlify.toml` punya redirect ini agar `/admin` membuka `admin.html` tanpa perlu ketik `.html`:

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

- Jika `netlify.toml` sudah punya redirect `/admin/*`, tambahkan juga yang `/admin` (tanpa `/*`) jika belum ada.
- Jangan ubah `publish` / `command` lain yang sudah jalan. Jika `command` sudah ada dan berbeda, pertahankan yang sudah jalan, jangan timpa.
- Jangan tambahkan redirect yang mengarahkan `/` ke admin, atau sebaliknya.

---
## §3 KEAMANAN ADMIN (JANGAN DITAMBAH FITUR BARU, HANYA PASTIKAN YANG SUDAH ADA)
- Pastikan `admin.html` tetap memakai Supabase Auth + cek `admin_users` via RPC seperti yang sudah jalan. Jangan kembalikan ke hardcode.
- Jangan tambahkan halaman login admin di `index.html`.
- Jangan tambahkan link "Lupa Password Admin" di halaman publik.
- Jika `admin.html` punya link "Lihat Toko" / "Kembali ke Katalog" — BOLEH dipertahankan, karena itu arahnya dari Admin ke Publik (aman), bukan sebaliknya.
- Jangan tambahkan `robots.txt` / `sitemap` yang mencantumkan `/admin` jika belum ada. Jika sudah ada, jangan ubah.

---
## §4 CHECKLIST SEBELUM SELESAI (Codex wajib centang)
- [ ] Di `index.html`, tidak ada lagi string `admin.html` di dalam tag `<a>`, `<button>`, `onclick`, atau `href` yang tampil di UI publik
- [ ] Di `index.html`, tidak ada lagi kata `Admin` yang bisa diklik di header / tabs / footer / menu
- [ ] `grep` / pencarian `admin.html` di `index.html` menghasilkan 0 hasil di bagian UI (kecuali mungkin di komentar kode, itupun hapus jika ada)
- [ ] `netlify.toml` punya redirect `/admin` -> `/admin.html` (200) dan `/admin/*` -> `/admin.html` (200)
- [ ] `admin.html` masih bisa dibuka langsung via `/admin` dan `/admin.html` (setelah deploy)
- [ ] `npm run build` sukses, tidak ada error
- [ ] Tidak ada perubahan design / warna / layout / teks lain di halaman publik selain hilangnya link Admin
- [ ] Tidak ada commit / push / deploy yang dilakukan tanpa perintah user

---
## §5 PROMPT SIAP COPY-PASTE KE CODEX
> Halo Codex, kerjakan file PERBAIKAN ini saja. Hapus semua link / tombol Admin dari halaman publik index.html — Admin hanya boleh diakses via URL langsung DOMAIN/admin, bukan dari tombol di situs. Jangan hapus file admin.html, jangan ubah tampilan admin, jangan ubah design lain. Pastikan netlify.toml punya redirect /admin -> /admin.html. Setelah selesai, jalankan npm run build dan laporkan file yang diubah.

---
Dokumen ini adalah sumber kebenaran untuk perbaikan ini. Jika konflik dengan HANDOFF lama, ikuti dokumen ini untuk bagian Admin.
