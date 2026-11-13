# PERINTAH PASTI UNTUK CODEX — FIX WARNA: ADMIN KETIK MANUAL, PEMBELI TINGGAL PILIH
# Cara pakai: Copy SEMUA isi file ini, paste ke Codex. Codex WAJIB ikuti kode di bawah persis.

================================================================
PERINTAH (COPY DARI SINI)
================================================================

Halo Codex, kerjakan perintah ini persis. Jangan ubah design / palet / font. Jangan tampilkan WA / HP / teks pre-order / COD.

ATURAN WARNA YANG BENAR — JANGAN SAMPAI TERTUKAR LAGI:

1. ADMIN (admin.html) — KETIK MANUAL, JANGAN DIUBAH:
- Form Tambah Produk: Warna tetap INPUT KETIK MANUAL, pisah koma.
- Input Order Manual: Warna tetap INPUT KETIK MANUAL.
- Jangan ganti jadi tombol / dropdown / swatch di admin.

2. PUBLIK (index.html) — TINGGAL PILIH, JANGAN KETIK:
- HAPUS input ketik manual warna di popup detail produk.
- GANTI jadi TOMBOL PILIH yang bisa di-klik, dari data product.colors dari Supabase.
- Pembeli TINGGAL KLIK 1 tombol warna, tidak ketik.
- Warna yang dipilih itulah yang dikirim ke WhatsApp saat checkout.
- Kalau product.colors kosong, tampilkan 1 tombol "Warna Standar" saja.

Pasang kode di Bagian A, B, C di bawah ini persis. Setelah itu npm run build dan laporkan. Jangan minta token saya.

================================================================
SAMPAI SINI PERINTAHNYA
================================================================


================================================================
KODE YANG HARUS DIPASANG — CODEX COPY-PASTE PERSIS
================================================================

------------------------------------------------
BAGIAN A — index.html: CSS UNTUK TOMBOL WARNA (taruh di <style>)
------------------------------------------------

Tambahkan CSS ini di dalam <style> di index.html, jangan hapus CSS lama:

```css
/* Tombol pilih warna di publik — pembeli tinggal klik */
.color-pick { display:flex; gap:8px; flex-wrap:wrap; margin-top:8px; }
.color-pick button {
  border:1px solid #f3d1e3;
  background:#fff;
  color:#2b1220;
  border-radius:999px;
  padding:10px 16px;
  cursor:pointer;
  min-height:44px;
  font-size:14px;
  font-weight:600;
}
.color-pick button.active {
  background:#9d174d;
  border-color:#9d174d;
  color:#fff;
}
.color-pick button:focus { outline:2px solid #db2777; outline-offset:2px; }
```

------------------------------------------------
BAGIAN B — index.html: HTML POPUP DETAIL PRODUK
------------------------------------------------

CARI kode lama di popup detail produk yang seperti ini (HAPUS SEMUA):

```html
<!-- HAPUS YANG INI — JANGAN ADA LAGI DI PUBLIK -->
<label>Warna — ketik manual<input id="detailColor" type="text" placeholder="misal: Merah"></label>
<input id="detailColor" ...>
<select id="detailColor">...</select>
```

GANTI dengan ini persis:

```html
<div>
  <label style="display:block;font-size:13px;font-weight:700;margin-top:12px">Warna — pilih salah satu</label>
  <div id="detailColors" class="color-pick"></div>
  <p id="detailColorNote" class="muted" style="font-size:12px;margin:6px 0 0">Pilih warna yang tersedia.</p>
</div>
```

JANGAN ADA LAGI <input> warna di popup detail produk publik.

------------------------------------------------
BAGIAN C — index.html: JAVASCRIPT POPUP + CHECKOUT
------------------------------------------------

CARI fungsi yang membuka popup detail produk (misal openProduct / showDetail / openModal).
Di dalam fungsi itu, SETELAH data produk didapat, tambahkan kode ini persis:

```js
// === WARNA PUBLIK: TINGGAL PILIH DARI product.colors ===
var selectedColor = "";
var colorsBox = document.getElementById("detailColors");
var colorNote = document.getElementById("detailColorNote");
if(colorsBox){
  colorsBox.innerHTML = "";
  var colors = (product.colors || product.warna || []);
  // Kalau colors masih string "Merah, Hitam, Biru", split jadi array
  if(typeof colors === "string"){
    colors = colors.split(",").map(function(s){ return s.trim(); }).filter(Boolean);
  }
  if(!colors || colors.length === 0){
    colors = ["Warna Standar"];
  }
  selectedColor = colors[0];
  colors.forEach(function(c, idx){
    var b = document.createElement("button");
    b.type = "button";
    b.textContent = c;
    if(idx === 0) b.classList.add("active");
    b.onclick = function(){
      selectedColor = c;
      var all = colorsBox.querySelectorAll("button");
      all.forEach(function(x){ x.classList.remove("active"); });
      b.classList.add("active");
      // Simpan ke variabel global biar checkout bisa pakai
      window.__SELECTED_COLOR__ = c;
    };
    colorsBox.appendChild(b);
  });
  window.__SELECTED_COLOR__ = selectedColor;
  if(colorNote) colorNote.textContent = "Dipilih: " + selectedColor;
}
```

Di fungsi checkout / kirim ke WhatsApp (misal checkout() / addToCart() / orderViaWA()),
GANTI pengambilan warna yang lama:

```js
// HAPUS YANG LAMA:
// var warnaDipilih = document.getElementById("detailColor").value.trim();
```

GANTI dengan ini persis:

```js
// WARNA PUBLIK: pakai yang dipilih dari tombol, BUKAN ketik manual
var warnaDipilih = window.__SELECTED_COLOR__ || selectedColor || "Warna Standar";
```

Pastikan pesan WhatsApp memakai warnaDipilih ini, misal:
```js
// Contoh format pesan WA (sesuaikan dengan format yang sudah ada):
// "Halo Selara, saya mau pesan [Nama Produk] - Warna: " + warnaDipilih
```

------------------------------------------------
BAGIAN D — admin.html: PASTIKAN TETAP KETIK MANUAL (JANGAN DIUBAH JADI TOMBOL)
------------------------------------------------

Di admin.html, PASTIKAN tetap seperti ini, JANGAN diganti jadi tombol / dropdown / swatch:

```html
<label style="margin-top:10px">Warna — ketik manual, pisah koma
  <input id="npColors" placeholder="misal: Merah, Hitam, Biru" value="Merah, Hitam, Biru">
</label>
```

Dan JS-nya tetap:

```js
var colors = document.getElementById("npColors").value.split(",").map(function(s){ return s.trim(); }).filter(Boolean);
// ketik manual: Merah, Hitam, Biru
```

Di Input Order Manual admin, tetap:

```html
<label>Warna — ketik manual<input id="moColor" placeholder="misal: Merah"></label>
```

JANGAN ubah admin jadi tombol pilih.

------------------------------------------------
BAGIAN E — CHECKLIST CODEX (WAJIB DICEK SEBELUM LAPOR SELESAI)
------------------------------------------------
- [ ] index.html: TIDAK ADA LAGI <input id="detailColor"> di popup publik
- [ ] index.html: ADA <div id="detailColors" class="color-pick"> di popup
- [ ] index.html: Klik tombol warna mengganti .active + window.__SELECTED_COLOR__
- [ ] index.html: Checkout WA memakai window.__SELECTED_COLOR__, bukan .value dari input
- [ ] admin.html: Tambah Produk masih <input id="npColors"> ketik manual pisah koma
- [ ] admin.html: Order Manual masih <input id="moColor"> ketik manual
- [ ] npm run build sukses
- [ ] Jangan commit / push / deploy tanpa perintah user
