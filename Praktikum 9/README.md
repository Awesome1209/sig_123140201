# 🌏 WebGIS Fasilitas Publik - Full Stack

Aplikasi **WebGIS Full-Stack** modern yang mengintegrasikan **React + Vite** pada sisi frontend dengan **FastAPI + PostgreSQL/PostGIS** pada sisi backend. Project ini merupakan implementasi sistem informasi geografis interaktif yang mendukung fitur keamanan **JWT Authentication** dan manajemen data **CRUD** secara *real-time*.

---

## 👨‍💻 Author

* **Nama:** Awi Septian Prasetyo
* **NIM:** [123140201]
* **Program Studi:** Teknik Informatika
* **Instansi:** Institut Teknologi Sumatera (ITERA)
* **Mata Kuliah:** Sistem Informasi Geografis

---

## 📸 Screenshoot

<img width="2560" height="1126" alt="image" src="https://github.com/user-attachments/assets/76e14589-d57e-44ee-8d7b-7f5d95c040ea" />
<img width="1254" height="850" alt="image" src="https://github.com/user-attachments/assets/f582c01c-66e5-4360-abde-1be517bbb504" />
<img width="1471" height="850" alt="image" src="https://github.com/user-attachments/assets/69356c5c-f216-4a3f-8f58-bb4fe31cd0fe" />

---

## 🚀 Fitur Utama

* **Autentikasi Keamanan:** Sistem Login dan Registrasi menggunakan *JSON Web Token* (JWT).
* **Peta Interaktif:** Integrasi **Leaflet.js** dengan *basemap* dari OpenStreetMap.
* **Visualisasi Data Spasial:** Menampilkan data fasilitas publik langsung dari database dalam format **GeoJSON**.
* **Simbologi Kategori:** Marker peta memiliki warna otomatis yang berbeda berdasarkan kategori fasilitas.
* **Manajemen Data (CRUD):** * Tambah data melalui *sidebar form*.
    * Edit dan Hapus data langsung dari *popup* marker.
* **Sinkronisasi Otomatis:** Peta melakukan *refresh* data secara otomatis setelah setiap perubahan (tambah/edit/hapus).

---

## 🛠️ Teknologi yang Digunakan

| Komponen | Teknologi |
| :--- | :--- |
| **Frontend** | React.js, Vite, Axios, Leaflet, React-Leaflet |
| **Backend** | FastAPI (Python), Uvicorn, SQLAlchemy/asyncpg |
| **Database** | PostgreSQL + PostGIS (Spasial Extension) |
| **Security** | JWT (python-jose), Passlib (bcrypt) |

---

## 📂 Struktur Project

```bash
webgis-fullstack/
├── webgis-backend/           # Sisi Server (FastAPI)
│   ├── routers/              # Endpoint API (Auth & Fasilitas)
│   ├── utils/                # Helper (Hashing & JWT Logic)
│   ├── database.py           # Koneksi SQLAlchemy/PostGIS
│   ├── models.py             # Definisi Tabel Database
│   └── main.py               # Entry Point Aplikasi
└── webgis-frontend/          # Sisi Klien (React)
    ├── src/
    │   ├── components/       # UI Components (Map, Sidebar, Popup)
    │   ├── context/          # State Management (AuthContext)
    │   ├── hooks/            # Custom Hooks (useAuth)
    │   └── config/           # Konfigurasi Axios & Base URL
    └── vite.config.js
```

---

## 📡 API Endpoints (Dokumentasi)

### 🔐 Authentication
| Method | Endpoint | Deskripsi |
| :--- | :--- | :--- |
| `POST` | `/register` | Registrasi akun user baru |
| `POST` | `/login` | Login dan mendapatkan Bearer Token |
| `GET` | `/me` | Mendapatkan informasi profil user aktif |

### 📍 Fasilitas Publik
| Method | Endpoint | Deskripsi |
| :--- | :--- | :--- |
| `GET` | `/api/fasilitas/` | List semua data fasilitas |
| `GET` | `/api/fasilitas/geojson` | Ambil data format GeoJSON (untuk Peta) |
| `POST` | `/api/fasilitas/` | Tambah titik fasilitas baru 🔒 |
| `PUT` | `/api/fasilitas/{id}` | Update data fasilitas 🔒 |
| `DELETE` | `/api/fasilitas/{id}` | Hapus data fasilitas 🔒 |

> 🔒 *Membutuhkan Header: `Authorization: Bearer <token>`*

---

## ⚙️ Persiapan & Instalasi

### 1. Database (PostgreSQL)
Pastikan ekstensi **PostGIS** sudah aktif di database Anda:
```sql
CREATE EXTENSION postgis;
```

### 2. Konfigurasi Backend
Buat file `.env` di dalam folder `webgis-backend/`:
```env
DATABASE_URL=postgresql://postgres:password_kamu@localhost:5432/tugas7_sig
SECRET_KEY=kunci_rahasia_bebas_diisi_apa_saja
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=60
```

### 3. Menjalankan Backend
```bash
cd webgis-backend
pip install -r requirements.txt
uvicorn main:app --reload
```

### 4. Menjalankan Frontend
```bash
cd webgis-frontend
npm install
npm run dev
```

---

## 📍 Data Wilayah (Bandar Lampung)
Aplikasi ini memuat data spasial fasilitas di wilayah Bandar Lampung, mencakup:
* **Pendidikan:** SMAN 5 Bandar Lampung
* **Kesehatan:** RS Urip Sumoharjo
* **Komersial:** Mall Boemi Kedaton, Pasar Way Halim
* **Religi:** Masjid Al-Falah
* **Olahraga:** Stadion Sumpah Pemuda
