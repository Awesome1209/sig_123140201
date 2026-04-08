# WebGIS API - Tugas Praktikum 7 SIG

Repositori ini berisi implementasi REST API untuk Sistem Informasi Geografis (WebGIS) menggunakan **FastAPI** dan **PostGIS**. API ini dirancang untuk mengelola data spasial fasilitas umum, termasuk operasi CRUD dan analisis query spasial (pencarian radius terdekat), serta mengembalikan data dalam format standar **GeoJSON**.

**Disusun oleh:**
* **Nama:** Awi Septian Prasetyo
* **NIM:** 123140201
* **Mata Kuliah:** Sistem Informasi Geografis

---

## 🚀 Fitur Utama
1. **CRUD Data Spasial**: Menambahkan, melihat, dan mengelola data titik lokasi fasilitas.
2. **Validasi Pydantic**: Memastikan input koordinat (longitude/latitude) berada dalam rentang geografis yang valid.
3. **GeoJSON Export**: Mengonversi geometri PostGIS (WKB) menjadi format `FeatureCollection` yang siap divisualisasikan pada *frontend* pemetaan (seperti Leaflet.js).
4. **Proximity Search (Nearby)**: Pencarian fasilitas terdekat berdasarkan titik koordinat pengguna dan radius tertentu dalam satuan meter.

## 🛠️ Teknologi yang Digunakan
* **Bahasa**: Python 3.x
* **Web Framework**: FastAPI
* **Database**: PostgreSQL dengan ekstensi PostGIS
* **Driver Async**: `asyncpg`
* **Validasi**: Pydantic
* **Environment**: `python-dotenv`
* **Server ASGI**: Uvicorn

---

## ⚙️ Panduan Instalasi dan Penggunaan

Ikuti langkah-langkah berikut untuk menjalankan project ini di komputer lokal (Windows).

### 1. Persiapan Database
1. Buka **pgAdmin 4** dan buat database baru bernama `tugas7_sig`.
2. Buka *Query Tool* pada database tersebut dan jalankan perintah berikut untuk mengaktifkan fungsi spasial:
   ```sql
   CREATE EXTENSION IF NOT EXISTS postgis;
   ```

### 2. Setup Lingkungan (Virtual Environment)
Buka terminal/Command Prompt di dalam folder project ini, lalu jalankan perintah:
```bash
# Membuat virtual environment
python -m venv venv

# Mengaktifkan virtual environment (Windows)
.\venv\Scripts\activate
```

### 3. Instalasi Dependensi
Setelah `(venv)` aktif, instal semua pustaka (library) yang dibutuhkan:
```bash
pip install fastapi uvicorn asyncpg python-dotenv pydantic
```

### 4. Konfigurasi Environment (`.env`)
Buat sebuah file bernama `.env` di folder utama proyek, lalu isi dengan alamat koneksi database sesuai dengan pengaturan PostgreSQL di komputermu:
```text
# Format: postgresql://[user]:[password]@[host]:[port]/[nama_database]
DATABASE_URL=postgresql://postgres:1234@127.0.0.1:5432/tugas7_sig
```
*(Catatan: Sesuaikan `1234` dengan password pgAdmin kamu)*

### 5. Menjalankan Server
Jalankan perintah ini untuk menyalakan server aplikasi:
```bash
uvicorn main:app --reload
```
Jika berhasil, terminal akan menampilkan pesan `Application startup complete`.

---

## 📡 Dokumentasi API (Endpoints)

Setelah server berjalan, kamu bisa membuka antarmuka pengujian (Swagger UI) melalui browser di alamat:
👉 **`http://127.0.0.1:8000/docs`**

Berikut adalah daftar endpoint yang tersedia:

| Metode | Endpoint | Deskripsi |
| :--- | :--- | :--- |
| `POST` | `/api/fasilitas/` | Menambahkan data fasilitas spasial baru. |
| `GET` | `/api/fasilitas/` | Mengambil semua daftar data fasilitas. |
| `GET` | `/api/fasilitas/{id}` | Mengambil detail satu fasilitas berdasarkan ID. |
| `GET` | `/api/fasilitas/geojson`| Mengambil seluruh data spasial dalam format **GeoJSON**. |
| `GET` | `/api/fasilitas/nearby` | Mencari fasilitas di sekitar titik berdasarkan koordinat (lat/lon) dan batas radius. |
