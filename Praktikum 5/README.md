# Praktikum 5 - Sistem Informasi Geografis

## Identitas
- **Nama:** Awi Septian Prasetyo
- **NIM:** 123140201
- **Mata Kuliah:** Sistem Informasi Geografis
- **Dosen Pengampu:** Muhammad Habib Algifari, S.Kom., M.T.I. dan Alya Khairunnisa Rizkita, S.Kom., M.Kom.

## Deskripsi
Repositori ini berisi hasil **Tugas Praktikum 5 Sistem Informasi Geografis** dengan topik **Operasi Geometri** menggunakan **PostgreSQL/PostGIS** dan **QGIS**.

Analisis dilakukan untuk:
- membuat buffer dari dua jenis fasilitas berbeda,
- menggabungkan buffer sejenis dengan `ST_Union`,
- mencari area tumpang tindih dengan `ST_Intersection`,
- menghitung titik pusat wilayah dengan `ST_Centroid`,
- dan memvisualisasikan hasilnya pada QGIS.

Materi tugas mengacu pada **Pertemuan 5 - Operasi Geometri**. fileciteturn0file0

## Data yang Digunakan
Data yang digunakan berasal dari schema **transportasi**, yaitu:
- `halte`
- `parkir`
- `wilayah`

Tabel `halte` dan `parkir` menggunakan geometri **Point**, sedangkan `wilayah` menggunakan geometri **Polygon** dengan SRID 4326. Struktur ini konsisten dengan database praktikum SIG yang digunakan pada materi SQL. fileciteturn1file0

## Tools
- **PostgreSQL**
- **PostGIS**
- **QGIS**

## Langkah Pengerjaan
1. Mengaktifkan ekstensi **PostGIS** pada PostgreSQL.
2. Membuat schema `transportasi`.
3. Membuat tabel `halte`, `parkir`, dan `wilayah`.
4. Memasukkan data spasial secara manual.
5. Membuat spatial index pada kolom geometri.
6. Membuat buffer halte dan parkir menggunakan `ST_Buffer`.
7. Menggabungkan buffer sejenis menggunakan `ST_Union`.
8. Mencari overlap layanan menggunakan `ST_Intersection`.
9. Menghitung centroid wilayah menggunakan `ST_Centroid`.
10. Menampilkan hasil analisis di **QGIS**.

## Query Inti

### Buffer halte
```sql
CREATE OR REPLACE VIEW transportasi.v_buffer_halte AS
SELECT
    id,
    nama,
    jenis,
    ST_Buffer(geom::geography, 500)::geometry AS geom
FROM transportasi.halte;
```

### Buffer parkir
```sql
CREATE OR REPLACE VIEW transportasi.v_buffer_parkir AS
SELECT
    id,
    nama,
    jenis,
    ST_Buffer(geom::geography, 500)::geometry AS geom
FROM transportasi.parkir;
```

### Union buffer halte
```sql
SELECT ST_Union(geom)
FROM transportasi.v_buffer_halte;
```

### Union buffer parkir
```sql
SELECT ST_Union(geom)
FROM transportasi.v_buffer_parkir;
```

### Intersection overlap
```sql
SELECT ST_Intersection(h.geom, p.geom)
FROM transportasi.union_buffer_halte_qgis h,
     transportasi.union_buffer_parkir_qgis p;
```

### Centroid wilayah
```sql
SELECT
    id,
    nama,
    ST_Centroid(geom) AS geom
FROM transportasi.wilayah;
```

Fungsi-fungsi di atas sesuai dengan operasi geometri yang dipelajari pada Pertemuan 5, terutama `ST_Buffer`, `ST_Union`, `ST_Intersection`, dan `ST_Centroid`. fileciteturn0file0

## Hasil Visualisasi
Hasil analisis divisualisasikan di QGIS dengan beberapa layer utama:
- data awal (`halte`, `parkir`, `wilayah`)
- buffer halte
- buffer parkir
- union buffer halte
- union buffer parkir
- overlap halte dan parkir
- centroid wilayah
- peta final keseluruhan

## Struktur Repositori
```bash
.
├── README.md
├── laporan/
│   └── Praktikum5_SIG_123140201_Awi_Septian_Prasetyo.pdf
├── screenshots/
│   ├── data_awal.png
│   ├── buffer_halte.png
│   ├── buffer_parkir.png
│   ├── union_halte.png
│   ├── union_parkir.png
│   ├── overlap.png
│   ├── centroid.png
│   └── peta_final.png
└── sql/
    └── praktikum5_operasi_geometri.sql
```

## Kesimpulan
Dari praktikum ini dapat disimpulkan bahwa operasi geometri pada PostGIS sangat membantu dalam analisis spasial. `ST_Buffer` digunakan untuk membentuk zona layanan, `ST_Union` untuk menggabungkan area sejenis, `ST_Intersection` untuk mencari area overlap, dan `ST_Centroid` untuk menentukan titik label wilayah. Hasil visualisasi di QGIS membantu memperjelas distribusi fasilitas dan cakupan layanannya. fileciteturn0file0

## Referensi
- Modul **Pertemuan 5 - Operasi Geometri**. fileciteturn0file0
- SQL **Database Siap Import SIG**. fileciteturn1file0
- SQL **Materi SIG Pertemuan 1–10**. fileciteturn2file0

## Github
Repo ini dapat dikembangkan lebih lanjut dengan menambahkan:
- file SQL lengkap,
- screenshot hasil QGIS,
- laporan akhir PDF,
- dan dokumentasi langkah pengerjaan.

