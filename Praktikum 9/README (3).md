# WebGIS Fasilitas Publik - Full Stack

Aplikasi **WebGIS full-stack** berbasis **React + Vite + React-Leaflet** pada frontend dan **FastAPI + PostgreSQL/PostGIS** pada backend.  
Project ini dikembangkan dari tugas sebelumnya (menampilkan peta dan GeoJSON) menjadi aplikasi yang memiliki **autentikasi JWT** dan **CRUD data fasilitas publik**.

## Fitur Utama

- Login user dengan **JWT Authentication**
- Menampilkan peta interaktif berbasis **OpenStreetMap**
- Menampilkan data fasilitas publik dari backend dalam format **GeoJSON**
- Menampilkan marker dengan **warna berbeda** berdasarkan kategori
- Menampilkan popup informasi:
  - nama
  - jenis
  - alamat
- Tambah data fasilitas dari form sidebar
- Edit data fasilitas dari marker/popup
- Hapus data fasilitas dari marker/popup
- Logout user
- Refresh data peta otomatis setelah tambah, edit, atau hapus data

## Teknologi yang Digunakan

### Backend
- FastAPI
- asyncpg
- PostgreSQL
- PostGIS
- python-dotenv
- python-jose
- passlib
- python-multipart

### Frontend
- React
- Vite
- Axios
- Leaflet
- React-Leaflet

## Struktur Project

```bash
webgis-fullstack/
├── webgis-backend/
│   ├── main.py
│   ├── database.py
│   ├── models.py
│   ├── routers/
│   │   ├── fasilitas.py
│   │   └── auth.py
│   ├── utils/
│   │   └── auth.py
│   ├── .env
│   └── requirements.txt
└── webgis-frontend/
    ├── src/
    │   ├── components/
    │   │   ├── MapView.jsx
    │   │   ├── Login.jsx
    │   │   ├── Sidebar.jsx
    │   │   └── Popup.jsx
    │   ├── config/
    │   │   └── api.js
    │   ├── context/
    │   │   └── AuthContext.jsx
    │   ├── hooks/
    │   │   └── useAuth.js
    │   ├── App.jsx
    │   ├── App.css
    │   ├── index.css
    │   └── main.jsx
    ├── package.json
    └── vite.config.js
```

## Deskripsi Data

Data yang digunakan berupa **fasilitas publik di wilayah Bandar Lampung**, misalnya:

- Pasar Way Halim
- Stadion Sumpah Pemuda
- SMAN 5 Bandar Lampung
- Mall Boemi Kedaton
- Rumah Awi
- Masjid Al-Falah
- Rumah Sakit Urip Sumoharjo

Setiap data memiliki atribut:
- `nama`
- `jenis`
- `alamat`
- `longitude`
- `latitude`

## Endpoint Backend

### Auth
- `POST /register` → registrasi user baru
- `POST /login` → login dan mendapatkan JWT token
- `GET /me` → melihat user yang sedang login

### Fasilitas
- `GET /api/fasilitas/` → ambil semua data fasilitas
- `GET /api/fasilitas/geojson` → ambil data dalam format GeoJSON
- `GET /api/fasilitas/nearby` → ambil data fasilitas terdekat
- `GET /api/fasilitas/{id}` → ambil detail fasilitas
- `POST /api/fasilitas/` → tambah fasilitas baru
- `PUT /api/fasilitas/{id}` → update fasilitas
- `DELETE /api/fasilitas/{id}` → hapus fasilitas

## Persiapan Database

Pastikan:
- PostgreSQL sudah terinstall
- ekstensi PostGIS aktif
- database sudah tersedia, misalnya: `tugas7_sig`

Contoh isi file `.env` di backend:

```env
DATABASE_URL=postgresql://postgres:1234@localhost:5433/tugas7_sig
SECRET_KEY=your-super-secret-key
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=60
```

## Cara Menjalankan Backend

Masuk ke folder backend:

```bash
cd webgis-backend
```

Aktifkan virtual environment (Windows):

```bash
.\venv\Scripts\activate
```

Install dependency:

```bash
pip install -r requirements.txt
```

Jalankan backend:

```bash
uvicorn main:app --reload
```

Backend akan berjalan di:

```text
http://127.0.0.1:8000
```

Swagger UI:

```text
http://127.0.0.1:8000/docs
```

## Cara Menjalankan Frontend

Masuk ke folder frontend:

```bash
cd webgis-frontend
```

Install dependency:

```bash
npm install
```

Jalankan frontend:

```bash
npm run dev
```

Frontend akan berjalan di:

```text
http://localhost:5173
```

## Alur Penggunaan Aplikasi

1. Jalankan backend dan frontend
2. Buka aplikasi frontend di browser
3. Login menggunakan akun yang sudah didaftarkan
4. Setelah login berhasil, user masuk ke dashboard WebGIS
5. Data fasilitas ditampilkan pada peta
6. User dapat:
   - menambah data dari form sidebar
   - mengedit data dari popup marker
   - menghapus data dari popup marker
7. Perubahan data akan langsung direfresh pada peta

## Contoh Akun untuk Uji Coba

Gunakan akun yang sudah diregister melalui Swagger atau aplikasi.

Contoh:
- Email: `awi12@example.com`
- Password: `secret123`

## Validasi dan Auth

- Endpoint `POST`, `PUT`, dan `DELETE` untuk fasilitas dilindungi token JWT
- Frontend menyimpan token di `localStorage`
- Axios interceptor akan otomatis menambahkan token pada request berikutnya
- Jika token tidak valid atau expired, user akan logout otomatis

## Tampilan Antarmuka

Aplikasi terdiri dari:
- **Halaman Login**
- **Dashboard utama**
  - Header
  - Sidebar form add/edit
  - Peta interaktif
  - Popup marker dengan tombol **Edit** dan **Hapus**

## Hasil Implementasi

Aplikasi ini telah berhasil memenuhi kebutuhan tugas full-stack:
- auth JWT berjalan
- CRUD fasilitas berjalan
- form add/edit berjalan
- marker edit/delete berjalan
- peta tetap menampilkan data GeoJSON dari backend

## Dokumentasi

Untuk pengumpulan tugas, sertakan:
- **GitHub repository**
- **PDF laporan**
- screenshot:
  - struktur project
  - Swagger register/login
  - halaman login
  - tampilan peta
  - popup marker
  - form add/edit
  - hasil CRUD

## Author

**Nama:** [Isi Nama Kamu]  
**NIM:** [Isi NIM Kamu]  
**Mata Kuliah:** Sistem Informasi Geografis  
**Praktikum:** Pertemuan 9 - WebGIS Full-Stack
