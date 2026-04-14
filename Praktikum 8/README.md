# WebGIS Fasilitas Bandar Lampung

Aplikasi **WebGIS frontend** berbasis **React**, **Vite**, dan **React-Leaflet** yang terintegrasi dengan **backend FastAPI** untuk menampilkan data lokasi fasilitas di wilayah Bandar Lampung dalam format **GeoJSON**.

Project ini dibuat untuk memenuhi **Tugas Praktikum 8 - Integrasi ReactJS** pada mata kuliah **Sistem Informasi Geografis**.

---
## Author

**Nama:** [Awi Septian Prasetyo]
**NIM:** [123140201]
**Mata Kuliah:** Sistem Informasi Geografis
**Praktikum:** Pertemuan 8 - Integrasi ReactJS

---
## Deskripsi Singkat

Aplikasi ini menampilkan peta interaktif menggunakan **OpenStreetMap** dan **Leaflet**, kemudian mengambil data lokasi dari backend FastAPI melalui endpoint GeoJSON. Setiap titik lokasi memiliki:

- **popup informasi**
- **warna berbeda berdasarkan kategori**
- **interaksi hover**
- **zoom ke lokasi saat titik diklik**

Data yang ditampilkan pada project ini meliputi beberapa lokasi di wilayah Way Halim dan Kedaton, Bandar Lampung, seperti pasar, stadion, sekolah, mall, rumah, masjid, dan rumah sakit.

---

## Fitur Utama

- Menampilkan peta interaktif berbasis OpenStreetMap
- Mengambil data dari backend FastAPI
- Menampilkan data dalam format **GeoJSON**
- Menampilkan **popup** berisi nama, jenis, dan alamat lokasi
- Menampilkan **warna berbeda** untuk setiap kategori data
- Mendukung **hover highlight**
- Mendukung **zoom to feature** saat marker diklik

---

## Teknologi yang Digunakan

### Backend
- FastAPI
- PostgreSQL
- PostGIS
- asyncpg
- python-dotenv

### Frontend
- React
- Vite
- Leaflet
- React-Leaflet
- Axios

---

## Data Lokasi

Data yang digunakan pada project ini terdiri dari 7 titik lokasi:

1. Pasar Way Halim
2. Stadion Sumpah Pemuda
3. SMAN 5 Bandar Lampung
4. Mall Boemi Kedaton
5. Rumah Awi
6. Masjid Al-Falah
7. Rumah Sakit Urip Sumoharjo

Setiap data memiliki atribut:
- `nama`
- `jenis`
- `alamat`
- `longitude`
- `latitude`

---

## Struktur Project

### Backend (`tugas7sig`) / (`webgis-backend`)
```bash
tugas7sig/ atau (`webgis-backend`)/
├── main.py
├── database.py
├── models.py
├── routers/
│   └── fasilitas.py
└── venv/
````

### Frontend (`webgis-frontend`)

```bash
webgis-frontend/
├── src/
│   ├── components/
│   │   └── MapView.jsx
│   ├── config/
│   │   └── api.js
│   ├── App.jsx
│   ├── App.css
│   ├── index.css
│   └── main.jsx
├── package.json
└── vite.config.js
```

---

## Endpoint Backend

Beberapa endpoint utama yang digunakan:

* `GET /api/fasilitas/`
* `GET /api/fasilitas/geojson`
* `GET /api/fasilitas/nearby`
* `GET /api/fasilitas/{id}`
* `POST /api/fasilitas/`

Endpoint utama untuk frontend adalah:

```bash
GET /api/fasilitas/geojson
```

Endpoint ini mengembalikan data dalam bentuk:

```json
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "geometry": {
        "type": "Point",
        "coordinates": [105.274965, -5.376959]
      },
      "properties": {
        "id": 1,
        "nama": "Pasar Way Halim",
        "jenis": "Pasar",
        "alamat": "..."
      }
    }
  ]
}
```

---

## Cara Menjalankan Backend

1. Buka folder backend:

```bash
cd tugas7sig
```

2. Aktifkan virtual environment:

```bash
.\venv\Scripts\activate
```

3. Jalankan backend:

```bash
uvicorn main:app --reload
```

4. Akses Swagger UI:

```bash
http://127.0.0.1:8000/docs
```

---

## Cara Menjalankan Frontend

1. Buka folder frontend:

```bash
cd webgis-frontend
```

2. Install dependency:

```bash
npm install
npm install leaflet react-leaflet axios
```

3. Jalankan frontend:

```bash
npm run dev
```

4. Buka di browser:

```bash
http://localhost:5173
```

---

## Konfigurasi API Frontend

File:

```bash
src/config/api.js
```

Contoh isi:

```javascript
import axios from 'axios'

const api = axios.create({
  baseURL: 'http://localhost:8000/api',
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json'
  }
})

export default api
```

---

## Komponen Utama Frontend

### `MapView.jsx`

Komponen ini bertugas untuk:

* membuat peta utama dengan `MapContainer`
* menampilkan `TileLayer`
* mengambil data GeoJSON dari backend
* menampilkan titik menggunakan `GeoJSON`
* memberikan warna marker berdasarkan kategori
* menampilkan popup
* menangani event hover dan click

### `main.jsx`

File ini mengimpor:

* React
* App
* CSS utama
* CSS Leaflet

### `App.jsx`

File utama untuk menampilkan header dan komponen peta.

---

## Styling Kategori

Setiap kategori diberikan warna yang berbeda:

* Pasar → Hijau
* Olahraga → Oranye
* Sekolah → Biru
* Pusat Perbelanjaan → Ungu
* Rumah → Cokelat
* Tempat Ibadah → Turkis
* Rumah Sakit → Merah

---

## Interaksi pada Peta

Interaksi yang diterapkan:

* **mouseover** → marker membesar
* **mouseout** → marker kembali seperti semula
* **click** → peta melakukan zoom ke lokasi yang dipilih

---

## Hasil Implementasi

Aplikasi yang dibuat telah memenuhi aspek utama tugas Praktikum 8, yaitu:

* peta tampil dengan center di wilayah data
* data GeoJSON berhasil diambil dari API
* popup menampilkan informasi lengkap
* styling berbeda untuk setiap kategori
* terdapat interaksi pada peta

---

## Dokumentasi Pengumpulan

Untuk pengumpulan tugas, disiapkan:

* **ZIP source code**
* **PDF screenshot**

Screenshot yang digunakan meliputi:

* tampilan halaman utama
* hasil endpoint GeoJSON
* popup lokasi
* styling warna kategori
* interaksi peta

---
