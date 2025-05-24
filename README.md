**`script_truker_faldi`** adalah skrip pekerjaan truker yang dikembangkan khusus untuk server **FiveM** berbasis **[ox_core](https://github.com/overextended/ox_core)**. Skrip ini menghadirkan sistem misi pengiriman logistik yang interaktif dan dapat dikembangkan lebih lanjut sesuai kebutuhan server roleplay Anda.

---

## 📦 Fitur Utama

- 🔄 Penerimaan dan penyelesaian misi pengiriman barang
- 🚚 Spawn dan penyimpanan kendaraan truk
- 📍 Navigasi tujuan dengan sistem waypoint
- 💼 Pembayaran otomatis berdasarkan rute yang dipilih
- 🔒 Validasi role/job sebelum mengakses fitur
- 🧩 Kompatibel dengan `ox_lib` dan `ox_inventory`

---

## ⚙️ dependency

Skrip ini membutuhkan resource berikut agar dapat berfungsi dengan baik:

- [`ox_core`](https://github.com/overextended/ox_core)
- [`ox_inventory`](https://github.com/overextended/ox_inventory)
- [`ox_lib`](https://github.com/overextended/ox_lib)
- [`ox_target`](https://github.com/overextended/ox_target?tab=readme-ov-file)
 


---

## 🛠️ Instalasi

1. Tempatkan folder `script_truker_faldi` di dalam direktori `resources` server Anda.

2. Tambahkan baris berikut ke `server.cfg`:
   ```
   ensure script_truker_faldi
   ```

3. Buka `config.lua` dan sesuaikan pengaturan rute, pembayaran, kendaraan, dan lainnya sesuai kebutuhan server Anda.

---

## 🧾 Struktur File

| File            | Deskripsi                                                  |
|-----------------|------------------------------------------------------------|
| `client.lua`    | Logika sisi klien untuk interaksi, waypoint, dan UI        |
| `server.lua`    | Pengelolaan pembayaran dan validasi pekerjaan              |
| `config.lua`    | Pengaturan truk, rute, dan harga pengiriman                |
| `fxmanifest.lua`| Metadata resource FiveM                                    |

---

## 📌 Contoh Konfigurasi

```lua
Config.Routes = {
    {
        label = "Antar Muatan ke Pelabuhan",
        start = vector3(102.4, -1002.6, 29.4),
        finish = vector3(1500.0, 3500.0, 30.0),
        payment = 500
    }
}
```

---

## 🤝 Kontribusi

Kontribusi sangat terbuka! Silakan sesuaikan atau kembangkan skrip ini untuk server Anda.  
Laporkan bug atau saran melalui GitHub Issues.

---

## 📄 Lisensi

Proyek ini bersifat open-source dan dapat digunakan secara bebas untuk keperluan server FiveM pribadi atau komunitas. Mohon tetap mencantumkan kredit jika menggunakan ulang atau memodifikasi skrip ini.

---

## 📬 Kontak

**Pengembang:** Muhammad Rifaldi  
**GitHub:** [rifaldi0406](https://github.com/rifaldi0406)
