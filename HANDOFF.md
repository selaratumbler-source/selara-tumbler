# SELARA TUMBLER — HANDOFF V2 (KODE LENGKAP) UNTUK CODEX
# BACA DULU SEBELUM NGODING

## INSTRUKSI UNTUK CODEX — WAJIB DIIKUTI 100%
1. File di bawah ini adalah KODE FINAL yang sudah ACC. JANGAN ubah design, warna, layout, teks, atau perilaku. JANGAN redesign ulang.
2. Tugas Codex HANYA pekerjaan teknis:
   - Pecah / rapikan kode di bawah ke struktur folder di §1 jika perlu, TAPI tampilannya harus 100% sama.
   - Sambungkan data produk ke Supabase (project: selara-tumbler) sesuai schema di §4. Ganti data dummy lokal dengan fetch Supabase, tapi tampilannya tetap sama.
   - Sambungkan upload foto produk ke Supabase Storage bucket `product-images`.
   - Sambungkan login admin ke Supabase Auth. Hapus login hardcode setelah Auth jalan.
   - Buat `.env.example`, `.gitignore`, `netlify.toml`, `README.md`.
   - Deploy ke Netlify (login via GitHub, repo `selara-tumbler`, domain gratis).
3. JANGAN tampilkan nomor WA / HP di UI. Nomor WA HANYA di file `.env` / Netlify Env Vars sebagai `WA_NUMBER`, dan di JS hanya dipakai untuk membangun link `https://wa.me/...` saat klik Pesan Sekarang. JANGAN render sebagai teks.
4. JANGAN tambahkan kembali teks yang dilarang: pre-order, PO, "Bayar saat barang siap", "COD / Transfer", "PO 3-7 hari kerja", badge itu, kalimat hero panjang, tombol "Lihat Katalog", preview pesan WA, form checkout, kategori "Bisa Custom", highlight foto gede.
5. Jika ada yang ambigu, TANYA user dulu, jangan nebak dan jangan ubah design.
6. Setelah selesai, uji checklist di §6 dan laporkan.

---
## §1 STRUKTUR FOLDER (di repo `selara-tumbler/`, saat ini masih kosong)
```
selara-tumbler/
├── HANDOFF.md (file ini)
├── index.html  <-- COPY-PASTE kode di §2 ke sini, JANGAN ubah tampilannya
├── admin.html  <-- COPY-PASTE kode di §3 ke sini, JANGAN ubah tampilannya
├── supabase/
│   ├── schema.sql (lihat §4)
│   └── seed.sql (lihat §5)
├── .env.example (lihat §7)
├── .gitignore
├── netlify.toml (lihat §8)
└── README.md
```
Catatan: Untuk Fase 1, `index.html` + `admin.html` sebagai 2 file sudah cukup. Jangan buat framework berat. Vanilla HTML/CSS/JS saja agar mudah di-maintain user.

---
## §2 FILE: index.html — COPY-PASTE PERSIS, JANGAN UBAH TAMPILAN
### Aturan tampilannya (sudah ACC):
- Header STICKY: hanya Logo + Keranjang yang freeze. Search TIDAK sticky.
- Atas ramping: headline 1 baris, tanpa tombol Lihat Katalog, tanpa foto besar/banner besar.
- Search di bagian katalog (STATIC, bukan sticky) + chips Semua/Tumbler/Tempat Makan.
- Infinite scroll beneran via IntersectionObserver, tanpa tombol Muat Lebih Banyak.
- Klik kartu -> modal tengah (max-height 88vh, bisa scroll di dalam, header X sticky, footer total sticky, backdrop transparan + blur, belakang masih kelihatan).
- Detail: slider foto, ukuran, WARNA (swatch), toggle Custom Nama +Rp15.000, qty, total live.
- Keranjang: tanpa form, tanpa preview pesan. Di bawah Total langsung tombol "Pesan Sekarang" -> WA dengan pesan otomatis isi keranjang.
- Footer profesional, tanpa nomor HP.
- Palet: #9d174d, #db2777, #fbcfe8, #fdf2f8. Judul Georgia serif, body system sans-serif.

```html
<!DOCTYPE html>
<html lang="id">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Selara Tumbler — Tumbler Pilihan, Dibuat Khusus Untukmu</title>
<style>
:root{--rose:#9d174d;--magenta:#db2777;--pink:#fbcfe8;--blush:#fdf2f8;--ink:#2b1220;--muted:#7a5a6b;--line:#f3d1e3;--white:#fff;--radius:18px}
*{box-sizing:border-box} body{margin:0;font-family:system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif;background:var(--blush);color:var(--ink)}
h1,h2,h3,.serif{font-family:Georgia,'Times New Roman',serif}
a{color:inherit;text-decoration:none} button{font:inherit;cursor:pointer}
/* HEADER — HANYA LOGO + KERANJANG YANG STICKY */
header{position:sticky;top:0;z-index:50;background:rgba(255,255,255,.92);backdrop-filter:blur(8px);border-bottom:1px solid var(--line)}
.header-inner{max-width:1120px;margin:0 auto;padding:12px 16px;display:flex;align-items:center;justify-content:space-between;gap:12px}
.logo{display:flex;align-items:center;gap:10px}
.logo-mark{width:40px;height:40px;border-radius:999px;border:2px solid var(--rose);display:grid;place-items:center;position:relative;background:#fff}
.logo-mark::after{content:"";position:absolute;inset:4px;border:1px solid var(--pink);border-radius:999px}
.logo-mark span{font-family:Georgia,serif;font-weight:700;color:var(--rose);font-size:20px}
.logo-text{line-height:1}.logo-text b{font-family:Georgia,serif;letter-spacing:.14em;font-size:18px;color:var(--rose)}
.logo-text small{display:block;letter-spacing:.32em;font-size:10px;color:var(--muted);margin-top:2px}
.cart-btn{position:relative;border:1px solid var(--line);background:#fff;border-radius:999px;padding:10px 16px;display:flex;gap:8px;align-items:center;font-weight:600}
.cart-btn .badge{position:absolute;top:-6px;right:-4px;background:var(--magenta);color:#fff;min-width:20px;height:20px;border-radius:999px;display:grid;place-items:center;font-size:12px;padding:0 5px}
main{max-width:1120px;margin:0 auto;padding:0 16px 40px}
.hero{padding:22px 4px 10px}.hero h1{font-size:30px;line-height:1.15;margin:0;color:var(--rose)}
.hero p{color:var(--muted);margin:8px 0 0}
/* SEARCH + FILTER — STATIC, TIDAK STICKY */
.catalog-bar{display:flex;gap:10px;margin:18px 0 10px}
.search-box{flex:1;display:flex;align-items:center;gap:8px;background:#fff;border:1px solid var(--line);border-radius:999px;padding:12px 16px}
.search-box input{border:0;outline:0;width:100%;font-size:15px;background:transparent}
.filter-btn{border:1px solid var(--line);background:#fff;border-radius:999px;padding:12px 16px;font-weight:600}
.chips{display:flex;gap:8px;flex-wrap:wrap;margin:0 0 16px}
.chip{border:1px solid var(--line);background:#fff;border-radius:999px;padding:8px 14px;font-size:14px}
.chip.active{background:var(--rose);color:#fff;border-color:var(--rose)}
/* GRID */
.grid{display:grid;grid-template-columns:1fr 1fr;gap:14px}
@media(min-width:860px){.grid{grid-template-columns:repeat(4,1fr)} .hero h1{font-size:38px}}
.card{background:#fff;border:1px solid var(--line);border-radius:var(--radius);overflow:hidden;text-align:left;padding:0;display:flex;flex-direction:column}
.card img{width:100%;aspect-ratio:1/1;object-fit:cover;display:block;background:#fbeaf3}
.card-body{padding:12px}.card-body h3{margin:0;font-size:15px;line-height:1.35}
.card-body .meta{color:var(--muted);font-size:12px;margin:6px 0}
.price{font-weight:800;color:var(--rose);margin-top:6px}
.hint{font-size:11px;color:var(--magenta);margin-top:6px}
.sentinel{padding:22px;text-align:center;color:var(--muted)}
.skeleton{height:180px;background:linear-gradient(90deg,#fbeaf3,#fff,#fbeaf3);background-size:200% 100%;animation:sh 1s infinite;border-radius:var(--radius)}
@keyframes sh{to{background-position:-200% 0}}
/* MODAL — TENGAH, TIDAK KEPOTONG */
.overlay{position:fixed;inset:0;background:rgba(0,0,0,.35);backdrop-filter:blur(3px);display:none;align-items:center;justify-content:center;padding:16px;z-index:100;overflow-y:auto}
.overlay.open{display:flex}
.modal{background:#fff;width:100%;max-width:760px;max-height:88vh;max-height:calc(100vh - 48px);overflow-y:auto;overflow-x:hidden;border-radius:20px;position:relative;padding-bottom:24px}
.modal-head{position:sticky;top:0;background:#fff;z-index:2;display:flex;justify-content:flex-end;padding:10px 10px 0}
.close{width:36px;height:36px;border-radius:999px;border:1px solid var(--line);background:#fff;font-size:18px;box-shadow:0 2px 10px rgba(0,0,0,.08)}
.modal-grid{display:grid;gap:16px;padding:4px 18px 10px}
@media(min-width:720px){.modal-grid{grid-template-columns:1fr 1fr}}
.gallery img{width:100%;max-height:320px;object-fit:cover;border-radius:14px;background:#fbeaf3;aspect-ratio:1/1}
@media(max-width:719px){.gallery img{max-height:240px}}
.gallery-nav{display:flex;justify-content:space-between;margin-top:8px}
.gallery-nav button{border:1px solid var(--line);background:#fff;border-radius:999px;padding:8px 12px}
.opt-label{font-weight:700;font-size:13px;margin:14px 0 8px}
.sizes,.swatches{display:flex;gap:8px;flex-wrap:wrap}
.size-btn,.swatch{border:1px solid var(--line);background:#fff;border-radius:999px;padding:8px 12px}
.size-btn.active{background:var(--rose);color:#fff;border-color:var(--rose)}
.swatch{width:34px;height:34px;border-radius:999px;padding:0;border:2px solid #fff;box-shadow:0 0 0 1px var(--line)}
.swatch.active{box-shadow:0 0 0 2px var(--magenta)}
.toggle{display:flex;justify-content:space-between;align-items:center;background:#fdf2f8;border:1px solid var(--line);border-radius:12px;padding:12px;margin-top:14px}
.toggle input{width:44px;height:24px;accent-color:var(--magenta)}
#customNameInput{width:100%;margin-top:10px;padding:12px;border:1px solid var(--line);border-radius:12px;display:none}
.qty{display:flex;align-items:center;gap:12px;margin-top:14px}
.qty button{width:36px;height:36px;border-radius:999px;border:1px solid var(--line);background:#fff;font-size:18px}
.modal-foot{position:sticky;bottom:0;background:#fff;border-top:1px solid var(--line);padding:14px 18px;display:flex;justify-content:space-between;align-items:center;gap:12px}
.btn-primary{background:var(--magenta);color:#fff;border:0;border-radius:999px;padding:13px 20px;font-weight:700;width:100%}
.btn-primary:disabled{opacity:.6}
/* CART */
.cart-wrap{max-width:720px;margin:0 auto}
.cart-item{display:flex;gap:12px;background:#fff;border:1px solid var(--line);border-radius:16px;padding:12px;margin-bottom:10px}
.cart-item img{width:72px;height:72px;object-fit:cover;border-radius:12px;background:#fbeaf3}
.cart-item .grow{flex:1}.cart-item h4{margin:0;font-size:15px}.cart-item p{margin:4px 0;color:var(--muted);font-size:13px}
.row{display:flex;justify-content:space-between;padding:8px 0}.total{font-weight:800;font-size:18px;color:var(--rose);border-top:1px solid var(--line)}
.empty{padding:40px;text-align:center;color:var(--muted)}
footer{border-top:1px solid var(--line);background:#fff;margin-top:40px}
.foot{max-width:1120px;margin:0 auto;padding:28px 16px;display:grid;gap:20px}
@media(min-width:720px){.foot{grid-template-columns:1.4fr 1fr 1fr}}
.foot h4{margin:0 0 10px;color:var(--rose)}.foot a{display:block;padding:4px 0;color:var(--muted);font-size:14px}
.copy{max-width:1120px;margin:0 auto;padding:14px 16px;border-top:1px solid var(--line);color:var(--muted);font-size:13px}
.faq{max-width:720px;margin:0 auto}.faq details{background:#fff;border:1px solid var(--line);border-radius:14px;padding:14px 16px;margin-bottom:10px}
.faq summary{cursor:pointer;font-weight:700}.faq p{color:var(--muted)}
.tabs{display:flex;gap:8px;justify-content:center;margin:16px 0}
.tabs button{border:1px solid var(--line);background:#fff;border-radius:999px;padding:9px 16px}
.tabs button.active{background:var(--rose);color:#fff;border-color:var(--rose)}
.hidden{display:none!important}
</style>
</head>
<body>
<header><div class="header-inner">
  <a class="logo" href="#" onclick="showView('shop')"><span class="logo-mark"><span>S</span></span><span class="logo-text"><b>SELARA</b><small>TUMBLER</small></span></a>
  <button class="cart-btn" onclick="showView('cart')">🛒 Keranjang <span class="badge" id="cartBadge">0</span></button>
</div></header>

<main>
  <div class="tabs"><button id="tab-shop" class="active" onclick="showView('shop')">Katalog</button><button id="tab-cart" onclick="showView('cart')">Keranjang</button><button id="tab-faq" onclick="showView('faq')">FAQ</button><a href="admin.html" style="border:1px solid var(--line);background:#fff;border-radius:999px;padding:9px 16px">Admin</a></div>

  <!-- SHOP -->
  <section id="view-shop">
    <div class="hero"><h1>Tumbler pilihan, dibuat khusus untukmu.</h1><p>Temukan tumbler dan tempat makan favoritmu, lalu pesan dengan mudah.</p></div>
    <div class="catalog-bar">
      <label class="search-box">🔍 <input id="searchInput" placeholder="Cari tumbler..." oninput="applyFilters()"></label>
      <button class="filter-btn" onclick="toggleFilter()">⚙ Filter</button>
    </div>
    <div id="filterPanel" class="hidden" style="background:#fff;border:1px solid var(--line);border-radius:16px;padding:14px;margin-bottom:12px">
      <b>Filter</b><div style="display:flex;gap:8px;flex-wrap:wrap;margin-top:10px">
        <label>Harga max: <input type="range" id="maxPrice" min="80000" max="250000" step="5000" value="250000" oninput="document.getElementById('maxPriceLabel').textContent='Rp '+Number(this.value).toLocaleString('id-ID');applyFilters()"> <span id="maxPriceLabel">Rp 250.000</span></label>
      </div>
      <div style="margin-top:10px;display:flex;gap:8px"><button class="chip" onclick="applyFilters()">Terapkan</button><button class="chip" onclick="resetFilters()">Reset</button></div>
    </div>
    <div class="chips" id="chips">
      <button class="chip active" data-cat="Semua" onclick="setCat('Semua',this)">Semua</button>
      <button class="chip" data-cat="Tumbler" onclick="setCat('Tumbler',this)">Tumbler</button>
      <button class="chip" data-cat="Tempat Makan" onclick="setCat('Tempat Makan',this)">Tempat Makan</button>
    </div>
    <div class="grid" id="grid"></div>
    <div id="sentinel" class="sentinel">Memuat produk...</div>
  </section>

  <!-- CART -->
  <section id="view-cart" class="hidden"><div class="cart-wrap"><h2 class="serif" style="color:var(--rose)">Keranjang</h2><div id="cartList"></div><div id="cartSummary"></div></div></section>

  <!-- FAQ -->
  <section id="view-faq" class="hidden"><div class="faq"><h2 class="serif" style="color:var(--rose)">FAQ</h2>
    <details open><summary>Bagaimana cara memesan?</summary><p>Pilih produk, atur warna, ukuran, dan jumlah, lalu klik Pesan Sekarang.</p></details>
    <details><summary>Apakah bisa tambah nama?</summary><p>Ya, aktifkan Custom Nama di detail produk. Biaya tambahan Rp15.000 per item.</p></details>
    <details><summary>Bagaimana cara membayar?</summary><p>Pembayaran akan dikonfirmasi melalui chat setelah kamu menekan Pesan Sekarang.</p></details>
    <details><summary>Bagaimana merawat tumbler?</summary><p>Cuci dengan sabun lembut, hindari sikat kasar, dan keringkan sebelum disimpan.</p></details>
  </div></section>
</main>

<footer><div class="foot">
  <div><div class="logo"><span class="logo-mark"><span>S</span></span><span class="logo-text"><b>SELARA</b><small>TUMBLER</small></span></div><p style="color:var(--muted)">Tumbler pilihan, dibuat khusus untukmu.</p></div>
  <div><h4>Navigasi</h4><a href="#" onclick="showView('shop')">Katalog</a><a href="#" onclick="showView('faq')">FAQ</a><a href="#" onclick="showView('cart')">Keranjang</a></div>
  <div><h4>Kategori</h4><a href="#" onclick="setCat('Tumbler',null);showView('shop')">Tumbler</a><a href="#" onclick="setCat('Tempat Makan',null);showView('shop')">Tempat Makan</a></div>
</div><div class="copy">© 2026 Selara Tumbler. All rights reserved.</div></footer>

<!-- MODAL DETAIL -->
<div class="overlay" id="overlay" onclick="if(event.target===this)closeModal()"><div class="modal" role="dialog" aria-modal="true">
  <div class="modal-head"><button class="close" onclick="closeModal()">×</button></div>
  <div class="modal-grid">
    <div><div class="gallery"><img id="mImg" src="" alt=""><div class="gallery-nav"><button onclick="prevImg()">‹ Sebelumnya</button><button onclick="nextImg()">Berikutnya ›</button></div></div></div>
    <div>
      <h2 id="mName" class="serif" style="margin:0;color:var(--rose)"></h2>
      <div id="mPrice" class="price" style="font-size:20px"></div>
      <p id="mDesc" style="color:var(--muted)"></p>
      <div class="opt-label">Ukuran</div><div class="sizes" id="mSizes"></div>
      <div class="opt-label">Warna: <span id="mColorName"></span></div><div class="swatches" id="mColors"></div>
      <label class="toggle"><span><b>Custom Nama</b><br><small>+Rp15.000 per item</small></span><input type="checkbox" id="mCustom" onchange="toggleCustom()"></label>
      <input id="customNameInput" placeholder="Tulis nama untuk custom, contoh: NADIA" maxlength="20">
      <div class="qty"><button onclick="changeQty(-1)">−</button><b id="mQty">1</b><button onclick="changeQty(1)">+</button><span style="color:var(--muted)">item</span></div>
    </div>
  </div>
  <div class="modal-foot"><div><small>Total</small><div id="mTotal" style="font-weight:800;color:var(--rose);font-size:18px"></div></div><button class="btn-primary" style="max-width:260px" onclick="addToCart()">Tambah ke Keranjang</button></div>
</div></div>

<script>
// ===== CONFIG — CODEX: isi dari ENV, JANGAN tampilkan di UI =====
const WA_NUMBER = ""; // <-- Codex: isi dari env Netlify WA_NUMBER saat build / runtime. JANGAN hardcode tampil di UI. Contoh pemakaian: `https://wa.me/${WA_NUMBER}?text=...`
const CUSTOM_FEE = 15000;
const COLORS = { "Rose":"#e8a0b8", "Blush Pink":"#fbcfe8", "Putih":"#ffffff", "Sage":"#a8b8a0", "Hitam":"#222222", "Cream":"#f5e8d5" };
// ===== DATA DUMMY — CODEX: ganti dengan fetch Supabase, tampilannya tetap sama =====
const IMGS = ["https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=800&q=80","https://images.unsplash.com/photo-1543163521-1bf539c55dd2?w=800&q=80","https://images.unsplash.com/photo-1570222094114-d054a817e56b?w=800&q=80","https://images.unsplash.com/photo-1595231712320-1e9d4e8d0e8f?w=800&q=80"];
function mk(i,name,cat,price,size,colors,desc){return {id:i,name,cat,price,desc:desc||"Desain elegan, nyaman dibawa setiap hari, dan mudah dibersihkan.",sizes:size,colors,image:IMGS[i%IMGS.length],images:[IMGS[i%IMGS.length],IMGS[(i+1)%IMGS.length]]}}
const ALL = [
 mk(1,"Aurora Tumbler 750ml","Tumbler",150000,["500ml","750ml","1000ml"],["Rose","Blush Pink","Putih"]),
 mk(2,"Selara Tumbler Classic 500ml","Tumbler",125000,["350ml","500ml"],["Rose","Cream","Hitam"]),
 mk(3,"Rose Tumbler Pro 750ml","Tumbler",175000,["500ml","750ml"],["Rose","Sage","Hitam"]),
 mk(4,"Blush Tumbler Mini 350ml","Tumbler",95000,["350ml"],["Blush Pink","Putih","Cream"]),
 mk(5,"Tumbler Handle Gradient 1000ml","Tumbler",195000,["750ml","1000ml"],["Rose","Sage"]),
 mk(6,"Tumbler Straw Pink 600ml","Tumbler",135000,["500ml","750ml"],["Blush Pink","Rose","Putih"]),
 mk(7,"Tumbler Gold Lid 500ml","Tumbler",145000,["500ml"],["Cream","Hitam","Rose"]),
 mk(8,"Tumbler Sage Office 750ml","Tumbler",155000,["500ml","750ml"],["Sage","Cream","Putih"]),
 mk(9,"Tumbler Hitam Elegan 750ml","Tumbler",140000,["500ml","750ml"],["Hitam","Cream"]),
 mk(10,"Tumbler Duo Tone 500ml","Tumbler",165000,["500ml"],["Rose","Blush Pink","Sage"]),
 mk(11,"Bento Box Sage 1000ml","Tempat Makan",120000,["800ml","1000ml"],["Sage","Cream","Blush Pink"]),
 mk(12,"Bento Box Blush 800ml","Tempat Makan",110000,["800ml"],["Blush Pink","Putih","Rose"]),
 mk(13,"Lunch Box Duo 1200ml","Tempat Makan",145000,["1000ml","1200ml"],["Sage","Cream"]),
 mk(14,"Tempat Makan Classic 1000ml","Tempat Makan",115000,["1000ml"],["Putih","Sage","Hitam"]),
 mk(15,"Bento Box Rose 1000ml","Tempat Makan",125000,["1000ml"],["Rose","Blush Pink"]),
 mk(16,"Lunch Box Mini 800ml","Tempat Makan",85000,["800ml"],["Cream","Blush Pink","Putih"]),
 mk(17,"Tumbler Travel 1000ml","Tumbler",185000,["1000ml"],["Hitam","Sage","Rose"]),
 mk(18,"Tumbler Kids Pink 350ml","Tumbler",90000,["350ml"],["Blush Pink","Rose"]),
 mk(19,"Tempat Makan Duo Sekat 1200ml","Tempat Makan",155000,["1200ml"],["Sage","Putih"]),
 mk(20,"Selara Set Tumbler + Bento","Tumbler",245000,["500ml","750ml"],["Rose","Sage","Cream"]),
];
let cat="Semua", shown=0, cart=JSON.parse(localStorage.getItem("selara_cart")||"[]");
let cur=null, curImg=0, curSize="", curColor="", curQty=1;
const rupiah=n=>"Rp "+Number(n).toLocaleString("id-ID");
function filtered(){const q=(document.getElementById("searchInput").value||"").toLowerCase();const mx=Number(document.getElementById("maxPrice").value||250000);return ALL.filter(p=>(cat==="Semua"||p.cat===cat)&&p.price<=mx&&(p.name.toLowerCase().includes(q)||p.cat.toLowerCase().includes(q)))}
function render(reset){if(reset){shown=0;document.getElementById("grid").innerHTML=""}const list=filtered();const batch=list.slice(shown,shown+8);const grid=document.getElementById("grid");batch.forEach(p=>{const d=document.createElement("button");d.className="card";d.onclick=()=>openModal(p.id);d.innerHTML=`<img src="${p.image}" alt="${p.name}"><div class="card-body"><h3>${p.name}</h3><div class="meta">${p.cat} • ${p.sizes.join(" / ")}</div><div class="price">${rupiah(p.price)}</div><div class="hint">Klik untuk lihat detail</div></div>`;grid.appendChild(d)});shown+=batch.length;document.getElementById("sentinel").textContent=shown>=list.length?"Semua produk sudah tampil":"Memuat produk...";updateBadge()}
function applyFilters(){render(true)} function resetFilters(){document.getElementById("searchInput").value="";document.getElementById("maxPrice").value=250000;document.getElementById("maxPriceLabel").textContent="Rp 250.000";applyFilters()}
function setCat(c,el){cat=c;document.querySelectorAll("#chips .chip").forEach(b=>b.classList.toggle("active",b.dataset.cat===c));if(el)el.classList.add("active");render(true)}
function toggleFilter(){document.getElementById("filterPanel").classList.toggle("hidden")}
function showView(v){["shop","cart","faq"].forEach(x=>document.getElementById("view-"+x).classList.toggle("hidden",x!==v));["shop","cart","faq"].forEach(x=>document.getElementById("tab-"+x).classList.toggle("active",x===v));if(v==="cart")renderCart();window.scrollTo({top:0})}
function openModal(id){cur=ALL.find(p=>p.id===id);curImg=0;curSize=cur.sizes[0];curColor=cur.colors[0];curQty=1;document.getElementById("mQty").textContent="1";document.getElementById("mCustom").checked=false;document.getElementById("customNameInput").style.display="none";document.getElementById("customNameInput").value="";paintModal();document.getElementById("overlay").classList.add("open");document.body.style.overflow="hidden"}
function paintModal(){document.getElementById("mImg").src=cur.images[curImg];document.getElementById("mName").textContent=cur.name;document.getElementById("mPrice").textContent=rupiah(cur.price);document.getElementById("mDesc").textContent=cur.desc;document.getElementById("mSizes").innerHTML=cur.sizes.map(s=>`<button class="size-btn ${s===curSize?"active":""}" onclick="curSize='${s}';paintModal()">${s}</button>`).join("");document.getElementById("mColors").innerHTML=cur.colors.map(c=>`<button class="swatch ${c===curColor?"active":""}" title="${c}" style="background:${COLORS[c]||"#ddd"}" onclick="curColor='${c}';paintModal()"></button>`).join("");document.getElementById("mColorName").textContent=curColor;const fee=document.getElementById("mCustom").checked?CUSTOM_FEE:0;document.getElementById("mTotal").textContent=rupiah((cur.price+fee)*curQty)}
function prevImg(){curImg=(curImg-1+cur.images.length)%cur.images.length;paintModal()} function nextImg(){curImg=(curImg+1)%cur.images.length;paintModal()}
function toggleCustom(){document.getElementById("customNameInput").style.display=document.getElementById("mCustom").checked?"block":"none";paintModal()}
function changeQty(d){curQty=Math.max(1,curQty+d);document.getElementById("mQty").textContent=curQty;paintModal()}
function closeModal(){document.getElementById("overlay").classList.remove("open");document.body.style.overflow=""}
document.addEventListener("keydown",e=>{if(e.key==="Escape")closeModal()});
function addToCart(){const fee=document.getElementById("mCustom").checked?CUSTOM_FEE:0;const cname=document.getElementById("mCustom").checked?(document.getElementById("customNameInput").value.trim()||"-"):"";cart.push({id:cur.id,name:cur.name,price:cur.price,image:cur.image,color:curColor,size:curSize,qty:curQty,custom:cname,fee});localStorage.setItem("selara_cart",JSON.stringify(cart));updateBadge();closeModal();showView("cart")}
function updateBadge(){document.getElementById("cartBadge").textContent=cart.reduce((a,b)=>a+b.qty,0)}
function renderCart(){const el=document.getElementById("cartList");if(!cart.length){el.innerHTML=`<div class="empty">Keranjang masih kosong.<br><button class="chip" onclick="showView('shop')" style="margin-top:12px">Lihat Katalog</button></div>`;document.getElementById("cartSummary").innerHTML="";return}el.innerHTML=cart.map((it,i)=>`<div class="cart-item"><img src="${it.image}"><div class="grow"><h4>${it.name}</h4><p>Warna: ${it.color} • Ukuran: ${it.size}${it.custom?` • Custom Nama: ${it.custom}`:""}</p><div class="qty"><button onclick="chg(${i},-1)">−</button><b>${it.qty}</b><button onclick="chg(${i},1)">+</button></div></div><div style="text-align:right"><b>${rupiah((it.price+it.fee)*it.qty)}</b><br><button onclick="del(${i})" style="border:0;background:none;color:var(--magenta);margin-top:8px">Hapus</button></div></div>`).join("");const sub=cart.reduce((a,b)=>a+b.price*b.qty,0);const cf=cart.reduce((a,b)=>a+b.fee*b.qty,0);document.getElementById("cartSummary").innerHTML=`<div style="background:#fff;border:1px solid var(--line);border-radius:16px;padding:16px"><div class="row"><span>Subtotal</span><b>${rupiah(sub)}</b></div><div class="row"><span>Biaya Custom</span><b>${rupiah(cf)}</b></div><div class="row total"><span>Total</span><span>${rupiah(sub+cf)}</span></div><button class="btn-primary" style="margin-top:12px" onclick="checkout()">Pesan Sekarang</button></div>`}
function chg(i,d){cart[i].qty=Math.max(1,cart[i].qty+d);localStorage.setItem("selara_cart",JSON.stringify(cart));updateBadge();renderCart()}
function del(i){cart.splice(i,1);localStorage.setItem("selara_cart",JSON.stringify(cart));updateBadge();renderCart()}
function checkout(){if(!cart.length)return;let lines=["Halo Selara Tumbler, saya mau pesan:",""];cart.forEach((it,i)=>{lines.push(`${i+1}. ${it.name}`);lines.push(`   Warna: ${it.color} | Ukuran: ${it.size} | Qty: ${it.qty}`);if(it.custom)lines.push(`   Custom Nama: ${it.custom} (+${rupiah(it.fee)})`);lines.push(`   Subtotal: ${rupiah((it.price+it.fee)*it.qty)}`);lines.push("")});const total=cart.reduce((a,b)=>a+(b.price+b.fee)*b.qty,0);lines.push(`Total: ${rupiah(total)}`);lines.push("Mohon konfirmasi ya, terima kasih.");const msg=encodeURIComponent(lines.join("\n"));const num=(typeof WA_NUMBER!=="undefined"&&WA_NUMBER)?WA_NUMBER:"";if(!num){alert("Nomor WA Admin belum diatur di ENV (WA_NUMBER). Codex: isi dari Netlify Env Vars.");return}window.open(`https://wa.me/${num}?text=${msg}`,"_blank")}
const obs=new IntersectionObserver(es=>{if(es[0].isIntersecting){const list=filtered();if(shown<list.length){document.getElementById("sentinel").innerHTML=`<div class="skeleton"></div>`;setTimeout(()=>render(false),400)}}},{rootMargin:"200px"});
obs.observe(document.getElementById("sentinel"));
render(true);updateBadge();
</script>
</body>
</html>
```

---
## §3 FILE: admin.html — COPY-PASTE PERSIS, JANGAN UBAH TAMPILAN
- Login username + password (sementara `admin` / `selara123` — Codex WAJIB ganti ke Supabase Auth sebelum go-live, hapus hardcode ini).
- Sidebar: Dashboard, Produk, Pesanan, Input Order Manual, Pengaturan.
- Dashboard: 4 kartu + grafik batang 7 hari + tabel pesanan (status bisa diklik ganti).
- Produk: tabel + form tambah (harga modal PRIVATE, warna multi, custom toggle, upload foto).
- Pesanan: tabel + filter status + Input Order Manual.
- Fase 2 tampil sebagai "Coming Soon" grey disabled.

```html
<!DOCTYPE html>
<html lang="id"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Admin — Selara Tumbler</title>
<style>:root{--rose:#9d174d;--magenta:#db2777;--pink:#fbcfe8;--blush:#fdf2f8;--line:#f3d1e3;--muted:#7a5a6b}*{box-sizing:border-box}body{margin:0;font-family:system-ui,Arial,sans-serif;background:var(--blush);color:#2b1220}h1,h2{font-family:Georgia,serif;color:var(--rose)}.wrap{max-width:1120px;margin:0 auto;padding:18px}.card{background:#fff;border:1px solid var(--line);border-radius:16px;padding:16px;margin-bottom:14px}input,select,textarea{width:100%;padding:11px;border:1px solid var(--line);border-radius:12px;margin-top:6px}label{font-size:13px;font-weight:700}.btn{background:var(--magenta);color:#fff;border:0;border-radius:999px;padding:12px 18px;font-weight:700;cursor:pointer}.btn2{border:1px solid var(--line);background:#fff;border-radius:999px;padding:9px 14px;cursor:pointer}.grid4{display:grid;grid-template-columns:1fr 1fr;gap:12px}@media(min-width:800px){.grid4{grid-template-columns:repeat(4,1fr)}}.stat b{font-size:26px;color:var(--rose);display:block}.pill{border-radius:999px;padding:5px 10px;font-size:12px;background:#fbeaf3;color:var(--rose);border:0;cursor:pointer}table{width:100%;border-collapse:collapse;font-size:14px}th,td{padding:10px;border-bottom:1px solid var(--line);text-align:left}.tabs{display:flex;gap:8px;flex-wrap:wrap;margin-bottom:14px}.tabs button{border:1px solid var(--line);background:#fff;border-radius:999px;padding:9px 14px;cursor:pointer}.tabs button.active{background:var(--rose);color:#fff}.hidden{display:none!important}.bars{display:flex;align-items:flex-end;gap:10px;height:110px}.bars div{flex:1;background:var(--magenta);border-radius:8px 8px 0 0;min-height:8px}.grey{opacity:.55;filter:grayscale(.3)}</style></head>
<body><div class="wrap">
<div id="loginView" class="card" style="max-width:420px;margin:40px auto"><h1>Admin Selara Tumbler</h1><p style="color:var(--muted)">Masuk untuk mengelola toko.</p><label>Username<input id="u" value="admin"></label><label>Password<input id="p" type="password" value="selara123"><span style="font-weight:400"><input type="checkbox" style="width:auto" onclick="document.getElementById('p').type=this.checked?'text':'password'"> Tampilkan</span></label><p id="loginErr" style="color:#c00;display:none">Username / password salah.</p><button class="btn" style="width:100%;margin-top:12px" onclick="login()">Masuk</button><p style="font-size:12px;color:var(--muted)">Demo: admin / selara123 — Codex: ganti ke Supabase Auth sebelum go-live, hapus hardcode ini.</p></div>
<div id="adminView" class="hidden">
<div style="display:flex;justify-content:space-between;align-items:center"><h1>Panel Admin</h1><div><a href="index.html" class="btn2">Lihat Toko</a> <button class="btn2" onclick="logout()">Keluar</button></div></div>
<div class="tabs"><button class="active" onclick="atab('dash',this)">Dashboard</button><button onclick="atab('prod',this)">Produk</button><button onclick="atab('order',this)">Pesanan</button><button onclick="atab('manual',this)">Input Order Manual</button><button onclick="atab('set',this)">Pengaturan</button></div>
<div id="tab-dash"><div class="grid4"><div class="card stat"><span>Total Order</span><b id="sTotal">12</b></div><div class="card stat"><span>Estimasi Profit</span><b id="sProfit">Rp 640.000</b></div><div class="card stat"><span>Belum Dibelanjakan</span><b>5</b></div><div class="card stat"><span>Selesai</span><b>7</b></div></div>
<div class="card"><b>Pesanan 7 Hari Terakhir</b><div class="bars"><div style="height:30%"></div><div style="height:55%"></div><div style="height:40%"></div><div style="height:80%"></div><div style="height:60%"></div><div style="height:95%"></div><div style="height:70%"></div></div><div style="display:flex;justify-content:space-between;font-size:12px;color:var(--muted)"><span>Sen</span><span>Sel</span><span>Rab</span><span>Kam</span><span>Jum</span><span>Sab</span><span>Min</span></div></div>
<div class="card"><b>Pesanan Terbaru</b><table><thead><tr><th>Pembeli</th><th>Produk</th><th>Total</th><th>Status</th></tr></thead><tbody id="orderBody"></tbody></table></div>
<div class="card grey"><b>Fase 2 — Coming Soon</b><p style="color:var(--muted)">Supplier Management • Shopping List Otomatis • Laporan Profit Lengkap — jangan dibangun dulu sebelum Fase 1 ACC.</p></div></div>
<div id="tab-prod" class="hidden"><div class="card"><b>Tambah Produk</b><div style="display:grid;gap:10px;margin-top:10px"><label>Nama Produk<input id="npName" placeholder="Contoh: Aurora Tumbler 750ml"></label><label>Kategori<select id="npCat"><option>Tumbler</option><option>Tempat Makan</option></select></label><label>Harga Jual (Rp)<input id="npPrice" type="number" placeholder="150000"></label><label>Harga Modal — PRIVATE, hanya admin<input id="npCost" type="number" placeholder="95000"></label><label>Ukuran (pisah koma)<input id="npSizes" value="500ml, 750ml"></label><label>Warna (centang yang tersedia)</label><div id="npColors" style="display:flex;gap:10px;flex-wrap:wrap"><label><input type="checkbox" value="Rose" checked> Rose</label><label><input type="checkbox" value="Blush Pink"> Blush Pink</label><label><input type="checkbox" value="Putih"> Putih</label><label><input type="checkbox" value="Sage"> Sage</label><label><input type="checkbox" value="Hitam"> Hitam</label><label><input type="checkbox" value="Cream"> Cream</label></div><label><input type="checkbox" id="npCustom" checked> Bisa Custom Nama (+Rp15.000)</label><label>Foto Produk<input type="file" id="npFile" accept="image/*"></label><button class="btn" onclick="addProduct()">Simpan Produk</button><p id="npMsg" style="color:var(--rose)"></p></div></div>
<div class="card"><b>Daftar Produk</b><table><thead><tr><th>Nama</th><th>Kategori</th><th>Harga Jual</th><th>Harga Modal (PRIVATE)</th><th>Status</th><th>Aksi</th></tr></thead><tbody id="prodBody"></tbody></table></div></div>
<div id="tab-order" class="hidden"><div class="card"><b>Semua Pesanan</b><div style="margin:10px 0"><button class="btn2" onclick="filterOrder('Semua')">Semua</button> <button class="btn2" onclick="filterOrder('Menunggu Konfirmasi')">Menunggu</button> <button class="btn2" onclick="filterOrder('Dibelanjakan')">Dibelanjakan</button> <button class="btn2" onclick="filterOrder('Barang Datang')">Barang Datang</button> <button class="btn2" onclick="filterOrder('Selesai')">Selesai</button></div><table><thead><tr><th>Pembeli</th><th>Produk</th><th>Total</th><th>Status</th></tr></thead><tbody id="orderBody2"></tbody></table></div></div>
<div id="tab-manual" class="hidden"><div class="card"><b>Input Order Manual</b><p style="color:var(--muted)">Untuk pesanan yang masuk via chat. Isi lalu Simpan Order.</p><label>Nama Pembeli<input id="moName" placeholder="Nama pembeli"></label><label>Pilih Produk<select id="moProd"></select></label><label>Warna<input id="moColor" placeholder="Rose"></label><label>Ukuran<input id="moSize" placeholder="750ml"></label><label>Qty<input id="moQty" type="number" value="1"></label><label>Custom Nama (opsional)<input id="moCustom" placeholder="Kosongkan jika tidak custom"></label><button class="btn" style="margin-top:12px" onclick="addManualOrder()">Simpan Order</button><p id="moMsg" style="color:var(--rose)"></p></div></div>
<div id="tab-set" class="hidden"><div class="card"><b>Pengaturan</b><label>Nama Toko<input value="Selara Tumbler"></label><label>Biaya Custom Nama Default (Rp)<input type="number" value="15000"></label><label>Catatan Admin<textarea rows="3" placeholder="Catatan internal..."></textarea></label><button class="btn" style="margin-top:12px" onclick="alert('Pengaturan tersimpan (demo). Codex: simpan ke tabel settings di Supabase.')">Simpan Pengaturan</button><p style="font-size:12px;color:var(--muted)">Nomor WA Admin diatur via ENV (WA_NUMBER), tidak ditampilkan di UI.</p></div></div>
</div></div>
<script>
let orders=[{name:"Nadia",prod:"Aurora Tumbler 750ml",total:165000,status:"Menunggu Konfirmasi"},{name:"Sari",prod:"Bento Box Sage",total:120000,status:"Dibelanjakan"},{name:"Dewi",prod:"Rose Tumbler Pro",total:190000,status:"Barang Datang"},{name:"Rina",prod:"Blush Tumbler Mini",total:95000,status:"Selesai"}];
let products=[{name:"Aurora Tumbler 750ml",cat:"Tumbler",price:150000,cost:95000,active:true},{name:"Bento Box Sage",cat:"Tempat Makan",price:120000,cost:78000,active:true}];
let ofilter="Semua";const STS=["Menunggu Konfirmasi","Dibelanjakan","Barang Datang","Selesai"];
function login(){if(document.getElementById("u").value==="admin"&&document.getElementById("p").value==="selara123"){document.getElementById("loginView").classList.add("hidden");document.getElementById("adminView").classList.remove("hidden");renderAll()}else{document.getElementById("loginErr").style.display="block"}}
function logout(){document.getElementById("adminView").classList.add("hidden");document.getElementById("loginView").classList.remove("hidden")}
function atab(id,el){["dash","prod","order","manual","set"].forEach(x=>document.getElementById("tab-"+x).classList.toggle("hidden",x!==id));document.querySelectorAll(".tabs button").forEach(b=>b.classList.remove("active"));el.classList.add("active")}
function cycleStatus(i){orders[i].status=STS[(STS.indexOf(orders[i].status)+1)%STS.length];renderAll()}
function renderOrders(){const rows=o=>o.map((x,i)=>`<tr><td>${x.name}</td><td>${x.prod}</td><td>Rp ${x.total.toLocaleString("id-ID")}</td><td><button class="pill" onclick="cycleStatus(${orders.indexOf(x)})">${x.status} ↻</button></td></tr>`).join("");document.getElementById("orderBody").innerHTML=rows(orders.slice(0,4));const f=ofilter==="Semua"?orders:orders.filter(x=>x.status===ofilter);document.getElementById("orderBody2").innerHTML=rows(f);document.getElementById("sTotal").textContent=orders.length}
function renderProducts(){document.getElementById("prodBody").innerHTML=products.map((p,i)=>`<tr><td>${p.name}</td><td>${p.cat}</td><td>Rp ${p.price.toLocaleString("id-ID")}</td><td>Rp ${p.cost.toLocaleString("id-ID")} <small>(PRIVATE)</small></td><td>${p.active?"Aktif":"Nonaktif"}</td><td><button class="btn2" onclick="products[${i}].active=!products[${i}].active;renderProducts()">${p.active?"Nonaktifkan":"Aktifkan"}</button></td></tr>`).join("");document.getElementById("moProd").innerHTML=products.map(p=>`<option>${p.name}</option>`).join("")}
function addProduct(){const n=document.getElementById("npName").value.trim();if(!n)return alert("Isi nama produk dulu");products.unshift({name:n,cat:document.getElementById("npCat").value,price:Number(document.getElementById("npPrice").value||0),cost:Number(document.getElementById("npCost").value||0),active:true});document.getElementById("npMsg").textContent="Produk tersimpan (demo). Codex: simpan ke Supabase + upload foto ke Storage.";renderProducts()}
function addManualOrder(){const n=document.getElementById("moName").value.trim();if(!n)return alert("Isi nama pembeli dulu");orders.unshift({name:n,prod:document.getElementById("moProd").value,total:0,status:"Menunggu Konfirmasi"});document.getElementById("moMsg").textContent="Order tersimpan (demo). Codex: simpan ke tabel orders + order_items di Supabase.";renderAll()}
function filterOrder(s){ofilter=s;renderOrders()}
function renderAll(){renderOrders();renderProducts()}
</script></body></html>
```

---
## §4 SUPABASE — schema.sql (project: selara-tumbler, masih kosong)
Codex: jalankan di Supabase SQL Editor, aktifkan RLS. JANGAN expose cost_price ke publik.

```sql
create extension if not exists "pgcrypto";
create table if not exists categories (id uuid primary key default gen_random_uuid(), name text not null unique, slug text not null unique, created_at timestamptz default now());
create table if not exists products (id uuid primary key default gen_random_uuid(), name text not null, category_id uuid references categories(id), description text, price int not null, cost_price int not null, sizes text[] default '{}', colors text[] default '{}', can_custom boolean default true, custom_fee int default 15000, image_url text, is_active boolean default true, created_at timestamptz default now(), updated_at timestamptz default now());
create table if not exists suppliers (id uuid primary key default gen_random_uuid(), name text not null, contact text, address text, shipping_cost int default 0, can_custom boolean default false, created_at timestamptz default now());
create table if not exists orders (id uuid primary key default gen_random_uuid(), buyer_name text, buyer_wa text, status text not null default 'Menunggu Konfirmasi' check (status in ('Menunggu Konfirmasi','Dibelanjakan','Barang Datang','Selesai')), total int not null default 0, source text default 'WA', created_at timestamptz default now(), updated_at timestamptz default now());
create table if not exists order_items (id uuid primary key default gen_random_uuid(), order_id uuid references orders(id) on delete cascade, product_id uuid references products(id), product_name text not null, color text, size text, qty int not null default 1, price int not null, custom_name text, custom_fee int default 0, subtotal int not null);
create table if not exists settings (id int primary key default 1, store_name text default 'Selara Tumbler', wa_number text, custom_fee_default int default 15000, check (id=1));
alter table categories enable row level security; alter table products enable row level security; alter table orders enable row level security; alter table order_items enable row level security; alter table suppliers enable row level security; alter table settings enable row level security;
create policy "public read categories" on categories for select using (true);
create policy "public read active products" on products for select using (is_active = true);
-- Codex: tambahkan policy admin (authenticated) untuk semua tabel. Buat VIEW publik products_public tanpa cost_price, dan frontend publik HANYA boleh query view itu.
-- Storage: buat bucket `product-images` (public read, upload hanya authenticated/admin).
```

---
## §5 SUPABASE — seed.sql (20 produk dummy, kategori hanya Tumbler / Tempat Makan)
Codex: jalankan setelah schema.sql. Harga jual Rp85.000–Rp245.000, modal 60-70% dari jual.

```sql
insert into categories (name, slug) values ('Tumbler','tumbler'), ('Tempat Makan','tempat-makan') on conflict do nothing;
-- Contoh insert (Codex lengkapi sampai 20 produk, variasikan nama/warna/ukuran):
-- insert into products (name, category_id, description, price, cost_price, sizes, colors, can_custom, image_url) values ('Aurora Tumbler 750ml', (select id from categories where slug='tumbler'), 'Desain elegan, nyaman dibawa setiap hari.', 150000, 95000, array['500ml','750ml','1000ml'], array['Rose','Blush Pink','Putih'], true, '');
-- ... ulangi sampai 20 produk: Selara Tumbler Classic, Rose Tumbler Pro, Blush Tumbler Mini, Tumbler Handle Gradient, Tumbler Straw Pink, Tumbler Gold Lid, Tumbler Sage Office, Tumbler Hitam Elegan, Tumbler Duo Tone, Tumbler Travel, Tumbler Kids Pink, Bento Box Sage, Bento Box Blush, Lunch Box Duo, Tempat Makan Classic, Bento Box Rose, Lunch Box Mini, Tempat Makan Duo Sekat, Selara Set Tumbler + Bento, dll.
```

---
## §6 CHECKLIST FASE 1 (Definition of Done) — Codex wajib centang satu per satu
- [ ] index.html + admin.html ter-copy persis, tampilan 100% sama dengan kode di HANDOFF ini
- [ ] Katalog load dari Supabase (bukan hardcode lagi), 20 produk tampil
- [ ] Search + filter + infinite scroll (IntersectionObserver, tanpa tombol Muat Lebih Banyak) jalan
- [ ] Klik produk -> modal tengah, tidak kepotong, X sticky, footer sticky, tutup via X / backdrop / Esc
- [ ] Warna + ukuran + custom nama (+Rp15.000) + qty + total live jalan
- [ ] Keranjang tambah/ubah/hapus/total jalan, tanpa form, tanpa preview pesan, tombol Pesan Sekarang -> WA dengan pesan format di kode (produk, warna, ukuran, qty, custom, total)
- [ ] FAQ accordion jalan, header sticky hanya logo + keranjang, search tidak sticky
- [ ] Footer profesional, tanpa nomor HP, tanpa teks terlarang
- [ ] Admin: login via Supabase Auth (hardcode dihapus), dashboard, CRUD produk, order manual, ubah status jalan
- [ ] cost_price TIDAK PERNAH muncul di response publik / Network tab publik
- [ ] Deploy Netlify jalan, domain gratis aktif, Supabase terhubung, .env TIDAK ter-commit
- [ ] README + .env.example + schema.sql + seed.sql ada di repo

---
## §7 .env.example — JANGAN isi nilai rahasia, hanya nama variabel
```
SUPABASE_URL=
SUPABASE_ANON_KEY=
WA_NUMBER=
# WA_NUMBER = nomor WA Admin, HANYA di .env / Netlify Env Vars. JANGAN tampilkan di UI, JANGAN commit .env.
```

---
## §8 netlify.toml
```toml
[build]
  publish = "."
[[redirects]]
  from = "/admin/*"
  to = "/admin.html"
  status = 200
```

---
## §9 PROMPT SIAP COPY-PASTE KE CODEX (paste ini + file HANDOFF ini)
> Halo Codex, baca file HANDOFF ini sampai habis. Kode di §2 dan §3 adalah kode FINAL yang sudah ACC — COPY-PASTE persis ke index.html dan admin.html, JANGAN ubah design/tampilan/teks/perilakunya. Tugas kamu HANYA pekerjaan teknis: sambungkan ke Supabase (project selara-tumbler, schema di §4, seed di §5), ganti data dummy dengan fetch Supabase tapi tampilannya tetap sama, sambungkan upload foto ke Storage, ganti login hardcode dengan Supabase Auth, buat .env.example + .gitignore + netlify.toml + README, lalu deploy ke Netlify (repo selara-tumbler, domain gratis). Jika ada yang ambigu, tanya saya dulu, jangan nebak dan jangan redesign. Kerjakan langkah demi langkah sesuai checklist §6 dan laporkan progress.

---
Dokumen ini adalah sumber kebenaran tunggal. Jika ada konflik dengan mockup lama, ikuti dokumen ini.
