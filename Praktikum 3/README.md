# Praktikum 3 SIG — Sistem Referensi Koordinat (CRS) & Analisis Jarak/Luas (PostGIS)

## Ringkasan
Praktikum ini membahas penggunaan **Sistem Referensi Koordinat (CRS)** pada data spasial di PostGIS, khususnya:
1. Transformasi data dari **EPSG:4326 (WGS84, derajat)** ke **EPSG:32748 (WGS84 / UTM Zone 48S, meter)**.
2. Perhitungan **jarak antar fasilitas** dengan 3 metode:  
   - Tanpa konversi (geometry 4326 → derajat)  
   - Menggunakan `geography` (meter)  
   - Transform ke UTM 32748 (meter)
3. Perhitungan **luas wilayah** menggunakan `ST_Area()` dengan UTM 32748 (m² dan ha).
4. Eksplorasi sederhana: **nearest neighbor** dan **jumlah fasilitas dalam radius 500m**.

## Data
Database berisi tabel pada schema `public`:

- `fasilitas_publik`  
  - Kolom: `id`, `nama`, `geom`  
  - Geometry: **POINT**  
  - SRID: **4326**
- `jalan` (opsional)  
  - Kolom: `id`, `nama`, `geom`  
  - Geometry: **LINESTRING**  
  - SRID: **4326**
- `wilayah`  
  - Kolom: `id`, `nama`, `geom`  
  - Geometry: **POLYGON**  
  - SRID: **4326**
- `spatial_ref_sys` (bawaan PostGIS)

Target CRS untuk analisis: **EPSG:32748 (UTM 48S)**.

## Perangkat / Requirement
- PostgreSQL 16
- PostGIS 3.4.x
- pgAdmin 4 (atau psql)
- (Opsional) Spreadsheet/Word untuk merapikan tabel ke laporan PDF

Cek versi:
```sql
SELECT version();
SELECT PostGIS_Full_Version();
