# 🗺️ Praktikum 2 - Tipe Data Spasial (PostGIS & QGIS)

## 👤 Identitas
- Nama  : Awi Septian Prasetyo  
- NIM   : 123140201  
- Mata Kuliah : Sistem Informasi Geografis (SIG)  
- Praktikum : Pertemuan 2 – Tipe Data Spasial  

---

## 📌 Deskripsi Project

Project ini merupakan tugas Praktikum 2 mata kuliah Sistem Informasi Geografis (SIG).  
Pada praktikum ini dilakukan pembuatan dan pengelolaan data spasial menggunakan:

- PostgreSQL
- PostGIS
- QGIS

Data spasial yang dibuat terdiri dari:

- LineString → Data Jalan  
- Polygon → Data Wilayah  
- Point → Data Fasilitas Publik  

Selain itu dilakukan validasi geometri menggunakan fungsi PostGIS.

---

## 🛠️ Tools yang Digunakan

- PostgreSQL
- PostGIS Extension
- QGIS
- GitHub

---

## 🗂️ Struktur Database

### 1️⃣ Tabel Jalan (LineString)

| Kolom | Tipe Data |
|--------|-----------|
| id | SERIAL (Primary Key) |
| nama | VARCHAR(100) |
| geom | GEOMETRY(LineString, 4326) |

---

### 2️⃣ Tabel Wilayah (Polygon)

| Kolom | Tipe Data |
|--------|-----------|
| id | SERIAL (Primary Key) |
| nama | VARCHAR(100) |
| geom | GEOMETRY(Polygon, 4326) |

---

### 3️⃣ Tabel Fasilitas_Publik (Point)

| Kolom | Tipe Data |
|--------|-----------|
| id | SERIAL (Primary Key) |
| nama | VARCHAR(100) |
| jenis | VARCHAR(100) |
| alamat | TEXT |
| geom | GEOMETRY(Point, 4326) |

---

## 📥 Proses Pengerjaan

### 1️⃣ Pembuatan Database
- Mengaktifkan ekstensi PostGIS
- Membuat tabel sesuai tipe geometry

### 2️⃣ Input Data Spasial
- Menggunakan `ST_GeomFromText()`
- Format koordinat: Longitude Latitude (SRID 4326)

Contoh:

```sql
ST_GeomFromText('LINESTRING(105.xxx -5.xxx, ...)', 4326)
```

3️⃣ Validasi Data Spasial

Dilakukan pengujian menggunakan:

ST_AsText()

ST_AsGeoJSON()

ST_IsValid()

Contoh query:

SELECT 
    id,
    nama,
    ST_AsText(geom),
    ST_AsGeoJSON(geom),
    ST_IsValid(geom)
FROM wilayah;


Hasil menunjukkan seluruh geometri bernilai true, sehingga data dinyatakan valid.

4️⃣ Visualisasi di QGIS

Menghubungkan PostgreSQL ke QGIS

Menambahkan layer:

jalan

wilayah

fasilitas_publik

Menampilkan dalam layer berbeda

Mengatur simbologi (warna & ketebalan garis)

📊 Hasil

Data jalan berhasil dibuat dalam bentuk LineString

Data wilayah berhasil dibuat dalam bentuk Polygon

Data fasilitas publik dalam bentuk Point

Semua data berhasil divalidasi dan divisualisasikan

Seluruh geometri valid (ST_IsValid = true)

📂 Struktur Repository
praktikum2-postgis/
│
├── README.md
├── sql/
│   └── praktikum2.sql
│
├── laporan/
│   └── Praktikum2_SIG_123140201_Awi.pdf
│
├── screenshots/
│   ├── jalan_qgis.png
│   ├── wilayah_qgis.png
│   ├── validasi_query.png
│
└── data/
    └── backup_database.sql
