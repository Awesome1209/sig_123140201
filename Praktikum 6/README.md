# Tugas Pertemuan 6 - Indexing Spasial dan Optimasi Query

## Deskripsi
Tugas ini bertujuan untuk melakukan analisis performa query spasial pada PostgreSQL/PostGIS dengan menggunakan **spatial index GiST**, **EXPLAIN ANALYZE**, dan teknik optimasi query. Pengerjaan tugas ini merupakan kelanjutan dari materi sebelumnya, khususnya:
- **Pertemuan 4**: Query spasial dan relasi topologi
- **Pertemuan 5**: Operasi geometri
- **Pertemuan 6**: Indexing spasial dan optimasi query

Fokus utama pada tugas ini adalah membandingkan performa query **sebelum** dan **sesudah** pembuatan spatial index, kemudian mengidentifikasi query lambat dan melakukan optimasi.

## Tujuan
Tujuan pengerjaan tugas ini adalah:
1. Membuat minimal **3 spatial index** pada tabel yang berbeda.
2. Menjalankan **EXPLAIN ANALYZE** untuk melihat performa query sebelum dan sesudah index dibuat.
3. Menghitung **speedup** atau peningkatan performa query.
4. Mengidentifikasi **minimal 1 query lambat** lalu mengoptimasinya.
5. Menyusun kesimpulan mengenai pentingnya indexing pada query spasial.

## Tabel yang Digunakan
Tabel yang digunakan pada pengerjaan tugas ini berasal dari schema `transportasi` dan `pertanian`, yaitu:
- `transportasi.halte`
- `transportasi.rute`
- `transportasi.wilayah`
- `pertanian.lahan`
- `pertanian.hama_penyakit`

Semua tabel tersebut memiliki kolom `geom` yang dapat digunakan untuk analisis spasial.

## Langkah Pengerjaan

### 1. Memastikan tabel tersedia
Langkah pertama dilakukan untuk memastikan bahwa tabel-tabel yang akan digunakan benar-benar tersedia di dalam database.

```sql
SELECT table_schema, table_name
FROM information_schema.tables
WHERE table_schema IN ('transportasi', 'pertanian')
ORDER BY table_schema, table_name;
```

### 2. Mengecek index yang sudah ada
Sebelum membuat index baru, perlu dilakukan pengecekan apakah sebelumnya sudah ada index yang dibuat pada tabel-tabel tersebut.

```sql
SELECT schemaname, tablename, indexname
FROM pg_indexes
WHERE schemaname IN ('transportasi', 'pertanian')
ORDER BY schemaname, tablename, indexname;
```

### 3. Menjalankan benchmark awal sebelum pembuatan index
Benchmark awal dilakukan untuk memperoleh kondisi performa query sebelum optimasi.

#### Query 1 - ST_Within
```sql
EXPLAIN ANALYZE
SELECT h.nama, w.nama
FROM transportasi.halte h
JOIN transportasi.wilayah w
ON ST_Within(h.geom, w.geom);
```

#### Query 2 - ST_Intersects
```sql
EXPLAIN ANALYZE
SELECT r.nama_rute, w.nama
FROM transportasi.rute r
JOIN transportasi.wilayah w
ON ST_Intersects(r.geom, w.geom);
```

#### Query 3 - ST_Buffer + ST_Intersects
```sql
EXPLAIN ANALYZE
SELECT l.nama_pemilik, hp.nama_hama_penyakit
FROM pertanian.lahan l
JOIN pertanian.hama_penyakit hp
ON ST_Intersects(
    l.geom,
    ST_Buffer(hp.geom::geography, 500)::geometry
);
```

Hasil dari tahap ini dicatat, terutama:
- `Execution Time`
- jenis scan yang muncul
- apakah masih menggunakan `Seq Scan`

### 4. Membuat spatial index GiST
Setelah benchmark awal selesai, spatial index dibuat pada tabel-tabel yang digunakan.

```sql
CREATE INDEX idx_halte_geom_p6
ON transportasi.halte
USING GIST (geom);

CREATE INDEX idx_wilayah_geom_p6
ON transportasi.wilayah
USING GIST (geom);

CREATE INDEX idx_rute_geom_p6
ON transportasi.rute
USING GIST (geom);

CREATE INDEX idx_lahan_geom_p6
ON pertanian.lahan
USING GIST (geom);

CREATE INDEX idx_hama_geom_p6
ON pertanian.hama_penyakit
USING GIST (geom);
```

### 5. Membuat index geography untuk query radius
Index geography dibuat untuk mendukung optimasi query berbasis jarak.

```sql
CREATE INDEX idx_halte_geog_p6
ON transportasi.halte
USING GIST ((geom::geography));
```

### 6. Menjalankan ANALYZE
Setelah index dibuat, statistik tabel diperbarui dengan `ANALYZE`.

```sql
ANALYZE transportasi.halte;
ANALYZE transportasi.wilayah;
ANALYZE transportasi.rute;
ANALYZE pertanian.lahan;
ANALYZE pertanian.hama_penyakit;
```

### 7. Menjalankan benchmark ulang setelah index dibuat
Query benchmark yang sama dijalankan kembali untuk membandingkan hasil sebelum dan sesudah pembuatan index.

#### Query 1 - ST_Within
```sql
EXPLAIN ANALYZE
SELECT h.nama, w.nama
FROM transportasi.halte h
JOIN transportasi.wilayah w
ON ST_Within(h.geom, w.geom);
```

#### Query 2 - ST_Intersects
```sql
EXPLAIN ANALYZE
SELECT r.nama_rute, w.nama
FROM transportasi.rute r
JOIN transportasi.wilayah w
ON ST_Intersects(r.geom, w.geom);
```

#### Query 3 - ST_Buffer + ST_Intersects
```sql
EXPLAIN ANALYZE
SELECT l.nama_pemilik, hp.nama_hama_penyakit
FROM pertanian.lahan l
JOIN pertanian.hama_penyakit hp
ON ST_Intersects(
    l.geom,
    ST_Buffer(hp.geom::geography, 500)::geometry
);
```

### 8. Mengidentifikasi query lambat
Contoh query lambat yang digunakan adalah query radius dengan `ST_Distance < 1000`.

```sql
EXPLAIN ANALYZE
SELECT nama
FROM transportasi.halte
WHERE ST_Distance(
    geom::geography,
    ST_SetSRID(ST_Point(105.26, -5.43), 4326)::geography
) < 1000;
```

### 9. Mengoptimasi query lambat
Optimasi dilakukan dengan mengganti `ST_Distance < 1000` menjadi `ST_DWithin`.

```sql
EXPLAIN ANALYZE
SELECT nama
FROM transportasi.halte
WHERE ST_DWithin(
    geom::geography,
    ST_SetSRID(ST_Point(105.26, -5.43), 4326)::geography,
    1000
);
```

## Menghitung Speedup
Peningkatan performa dihitung dengan rumus berikut:

```text
Speedup (%) = ((waktu_sebelum - waktu_sesudah) / waktu_sebelum) * 100
```

Contoh:
- waktu sebelum = 200 ms
- waktu sesudah = 20 ms

```text
((200 - 20) / 200) * 100 = 90%
```

Artinya terjadi peningkatan performa sebesar **90%**.

## Format Tabel Hasil
Hasil benchmark dapat disusun dalam tabel seperti berikut:

| No | Query | Sebelum | Sesudah | Speedup | Keterangan |
|----|-------|---------:|--------:|--------:|------------|
| 1 | ST_Within halte-wilayah | ... ms | ... ms | ... % | Benchmark |
| 2 | ST_Intersects rute-wilayah | ... ms | ... ms | ... % | Benchmark |
| 3 | Buffer hama-lahan | ... ms | ... ms | ... % | Benchmark |
| 4 | ST_Distance < 1000 | ... ms | - | - | Query lambat |
| 5 | ST_DWithin 1000 m | - | ... ms | ... % | Query optimasi |

## Analisis Singkat
Setelah benchmark dilakukan, perlu diperhatikan perubahan query plan:
- `Seq Scan` menunjukkan bahwa tabel masih dibaca baris per baris.
- `Index Scan` atau `Bitmap Index Scan` menunjukkan bahwa spatial index sudah digunakan.
- Penurunan `Execution Time` menunjukkan bahwa query menjadi lebih efisien.

## Kesimpulan
Berdasarkan hasil benchmark dan optimasi yang dilakukan, spatial index GiST terbukti mampu meningkatkan performa query spasial secara signifikan. Query yang menggunakan `ST_Within`, `ST_Intersects`, dan kombinasi `ST_Buffer` dengan `ST_Intersects` menjadi lebih efisien setelah index dibuat. Selain itu, query radius juga lebih cepat ketika `ST_Distance < x` diganti dengan `ST_DWithin`.

Dengan demikian, indexing spasial dan pemilihan fungsi query yang tepat sangat berpengaruh terhadap efisiensi pengolahan data spasial pada PostGIS.

## Catatan
- Jika index dengan nama yang sama sudah pernah dibuat, gunakan `DROP INDEX IF EXISTS` sebelum membuat ulang.
- Untuk benchmark yang valid, kondisi sebelum index dan sesudah index harus dibedakan dengan jelas.
- Pastikan `ANALYZE` dijalankan setelah pembuatan index.
