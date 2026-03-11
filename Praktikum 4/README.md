# README Praktikum 4 - Query Spasial dan Relasi Topologi

## Identitas

* **Mata Kuliah:** Sistem Informasi Geografis
* **Pertemuan:** 4
* **Topik:** Query Spasial dan Relasi Topologi
* **Nama:** `Awi Septian Prasetyo`
* **NIM:** `123140201`
* **Dosen Pengampu:** Muhammad Habib Algifari, S.Kom., M.T.I. dan Alya Khairunnisa Rizkita, S.Kom., M.Kom.

---

## Deskripsi Tugas

Pada praktikum ini dilakukan **analisis spasial menggunakan data dari praktikum sebelumnya**. Analisis dilakukan dengan memanfaatkan fungsi pengukuran dan relasi topologi pada PostGIS untuk menjawab pertanyaan-pertanyaan analitis terhadap data fasilitas, jalan, dan wilayah yang telah dibuat pada Praktikum 1, 2, dan 3.

---

## Tujuan Praktikum

Tujuan dari praktikum ini adalah:

1. Memahami penggunaan fungsi pengukuran spasial pada PostGIS.
2. Menerapkan relasi topologi untuk menganalisis hubungan antar geometri.
3. Melakukan pencarian fasilitas terdekat dengan metode **K-Nearest Neighbor (K-NN)**.
4. Membuat query agregasi spasial menggunakan `GROUP BY`.
5. Menginterpretasikan hasil query spasial menjadi informasi yang bermakna.

---

## Ketentuan Tugas

Sesuai instruksi praktikum, tugas ini harus memenuhi syarat berikut:

* Membuat **minimal 5 query spasial** dengan fungsi yang berbeda.
* Wajib menggunakan:

  * `ST_Distance`
  * `ST_Intersects`
  * `ST_Contains` **atau** `ST_Within`
* Mengimplementasikan **K-NN** untuk mencari fasilitas terdekat.
* Membuat **query agregasi** dengan `GROUP BY` dan fungsi spasial.
* Menyertakan **screenshot hasil query** dan **interpretasi hasil**.

---

## Struktur Data yang Digunakan

Praktikum ini menggunakan data dari praktikum sebelumnya, yaitu:

### 1. Tabel `fasilitas`

Menyimpan data fasilitas publik dalam bentuk **Point**.

Contoh kolom:

* `id`
* `nama`
* `jenis`
* `alamat`
* `geom`

### 2. Tabel `jalan`

Menyimpan data jalan dalam bentuk **LineString**.

Contoh kolom:

* `id`
* `nama`
* `geom`

### 3. Tabel `kecamatan` / `wilayah` / `kelurahan`

Menyimpan data wilayah administrasi dalam bentuk **Polygon**.

Contoh kolom:

* `id`
* `nama`
* `geom`

> Catatan: Sesuaikan nama tabel dengan database milik Anda. Jika pada database Anda nama tabel wilayah adalah `wilayah`, maka pada query cukup ganti `kecamatan` atau `kelurahan` menjadi `wilayah`.

---

## Persiapan

Sebelum menjalankan query, pastikan:

1. PostgreSQL dan PostGIS sudah aktif.
2. Database praktikum sudah berhasil dibuat.
3. Seluruh tabel dari praktikum sebelumnya sudah tersedia.
4. Semua data geometri menggunakan SRID yang benar.
5. Untuk perhitungan jarak dan luas, gunakan `::geography` atau transformasi koordinat yang sesuai.

Query pengecekan awal:

```sql
SELECT PostGIS_Version();

SELECT f_table_name, f_geometry_column, srid, type
FROM geometry_columns;
```

---

## Implementasi Query Spasial

Di bawah ini disajikan contoh implementasi query yang dapat langsung digunakan atau disesuaikan dengan data Anda.

### Query 1 - Menghitung Jarak Antar Dua Fasilitas (`ST_Distance`)

Tujuan: mengetahui jarak antara dua fasilitas tertentu.

```sql
SELECT 
    a.nama AS fasilitas_asal,
    b.nama AS fasilitas_tujuan,
    ROUND(
        ST_Distance(a.geom::geography, b.geom::geography)::numeric,
        2
    ) AS jarak_meter
FROM fasilitas a, fasilitas b
WHERE a.nama = 'RS Abdul Moeloek'
  AND b.nama = 'SMAN 1 Bandar Lampung';
```

**Penjelasan:**

* Fungsi `ST_Distance` digunakan untuk menghitung jarak antar dua geometri.
* `::geography` dipakai agar hasil jarak dalam satuan meter, bukan derajat.

**Interpretasi:**
Jika hasil query menunjukkan nilai, maka nilai tersebut adalah jarak lurus antar dua fasilitas dalam meter.

---

### Query 2 - Menentukan Jalan yang Memotong Wilayah (`ST_Intersects`)

Tujuan: mengetahui jalan mana saja yang berpotongan atau melewati suatu wilayah.

```sql
SELECT 
    j.nama AS nama_jalan,
    k.nama AS nama_kecamatan
FROM jalan j
JOIN kecamatan k
    ON ST_Intersects(j.geom, k.geom)
ORDER BY k.nama, j.nama;
```

**Penjelasan:**

* `ST_Intersects(A, B)` bernilai `TRUE` jika dua geometri memiliki setidaknya satu titik yang sama.
* Query ini cocok untuk mengecek jalan yang melintasi wilayah administrasi tertentu.

**Interpretasi:**
Hasil query menunjukkan daftar jalan yang berada atau memotong batas wilayah kecamatan.

---

### Query 3 - Menentukan Fasilitas yang Berada di Dalam Kecamatan (`ST_Within`)

Tujuan: mengetahui fasilitas apa saja yang berada di dalam suatu kecamatan.

```sql
SELECT 
    f.nama,
    f.jenis,
    k.nama AS kecamatan
FROM fasilitas f
JOIN kecamatan k
    ON ST_Within(f.geom, k.geom)
WHERE k.nama = 'Tanjung Karang Pusat'
ORDER BY f.nama;
```

**Alternatif menggunakan `ST_Contains`:**

```sql
SELECT 
    f.nama,
    f.jenis,
    k.nama AS kecamatan
FROM fasilitas f
JOIN kecamatan k
    ON ST_Contains(k.geom, f.geom)
WHERE k.nama = 'Tanjung Karang Pusat'
ORDER BY f.nama;
```

**Penjelasan:**

* `ST_Within(A, B)` digunakan untuk mengecek apakah geometri A berada di dalam geometri B.
* `ST_Contains(B, A)` adalah bentuk kebalikannya.

**Interpretasi:**
Hasil query menunjukkan daftar fasilitas yang berada di dalam wilayah kecamatan yang dipilih.

---

### Query 4 - Mencari 5 Fasilitas Terdekat dari Titik Tertentu (K-NN)

Tujuan: mencari fasilitas terdekat dari lokasi tertentu menggunakan operator K-NN.

```sql
SELECT 
    nama,
    jenis,
    ROUND(
        ST_Distance(
            geom::geography,
            ST_GeomFromText('POINT(105.26 -5.42)', 4326)::geography
        )::numeric,
        2
    ) AS jarak_meter
FROM fasilitas
ORDER BY geom <-> ST_GeomFromText('POINT(105.26 -5.42)', 4326)
LIMIT 5;
```

**Penjelasan:**

* Operator `<->` digunakan untuk K-NN (nearest neighbor).
* Query ini mengurutkan fasilitas berdasarkan kedekatan terhadap titik referensi.
* `LIMIT 5` digunakan untuk mengambil 5 fasilitas terdekat.

**Interpretasi:**
Daftar hasil menunjukkan fasilitas yang paling dekat dari lokasi acuan.

---

### Query 5 - Menghitung Jumlah Fasilitas per Kecamatan (`GROUP BY` + fungsi spasial)

Tujuan: mengetahui persebaran jumlah fasilitas di setiap kecamatan.

```sql
SELECT 
    k.nama AS kecamatan,
    COUNT(f.id) AS jumlah_fasilitas
FROM kecamatan k
LEFT JOIN fasilitas f
    ON ST_Contains(k.geom, f.geom)
GROUP BY k.id, k.nama
ORDER BY jumlah_fasilitas DESC;
```

**Penjelasan:**

* Query ini menggabungkan relasi spasial dengan agregasi `GROUP BY`.
* Setiap fasilitas dihitung berdasarkan kecamatan yang mengandung titik fasilitas tersebut.

**Interpretasi:**
Hasil query menunjukkan kecamatan mana yang memiliki jumlah fasilitas paling banyak.


---

### Query 6 - Menghitung Kepadatan Fasilitas per Kecamatan (`ST_Area` + `GROUP BY`)

Tujuan: mengetahui kepadatan fasilitas berdasarkan luas wilayah.

```sql
SELECT 
    k.nama,
    COUNT(f.id) AS jumlah_fasilitas,
    ROUND((ST_Area(k.geom::geography) / 1000000)::numeric, 2) AS luas_km2,
    ROUND(
        (COUNT(f.id)::numeric / NULLIF(ST_Area(k.geom::geography) / 1000000, 0)),
        2
    ) AS fasilitas_per_km2
FROM kecamatan k
LEFT JOIN fasilitas f
    ON ST_Contains(k.geom, f.geom)
GROUP BY k.id, k.nama, k.geom
ORDER BY fasilitas_per_km2 DESC;
```

**Penjelasan:**

* `ST_Area` digunakan untuk menghitung luas polygon.
* Nilai luas dikonversi ke kilometer persegi.
* Kepadatan dihitung dengan membagi jumlah fasilitas terhadap luas wilayah.

**Interpretasi:**
Semakin tinggi nilai `fasilitas_per_km2`, semakin padat sebaran fasilitas pada wilayah tersebut.

---

### Query 7 - Mencari Wilayah yang Tidak Memiliki Puskesmas dalam Radius 2 km (`ST_DWithin`)

Tujuan: mengidentifikasi wilayah yang belum terlayani fasilitas kesehatan tertentu.

```sql
SELECT k.nama AS kelurahan
FROM kelurahan k
WHERE NOT EXISTS (
    SELECT 1
    FROM fasilitas f
    WHERE f.jenis = 'Puskesmas'
      AND ST_DWithin(
          k.geom::geography,
          f.geom::geography,
          2000
      )
)
ORDER BY k.nama;
```

**Penjelasan:**

* `ST_DWithin` digunakan untuk mengecek apakah dua geometri berada dalam radius tertentu.
* Query ini mencari kelurahan yang **tidak** memiliki puskesmas dalam radius 2 km.

**Interpretasi:**
Hasil query dapat digunakan sebagai dasar rekomendasi pemerataan layanan kesehatan.

---

## Ringkasan Hasil Analisis

Contoh ringkasan yang bisa ditulis:

1. Jarak antara dua fasilitas dapat dihitung secara akurat dengan `ST_Distance` menggunakan `::geography`.
2. Relasi topologi seperti `ST_Intersects` berguna untuk mengetahui objek yang saling berpotongan.
3. `ST_Within` dan `ST_Contains` membantu menentukan lokasi fasilitas berdasarkan wilayah administrasi.
4. K-NN sangat efektif untuk mencari fasilitas terdekat dari lokasi tertentu.
5. Agregasi spasial dengan `GROUP BY` memudahkan analisis persebaran fasilitas.
6. `ST_DWithin` dapat dipakai untuk analisis cakupan layanan dalam radius tertentu.

---

## Kesimpulan

Praktikum 4 menunjukkan bahwa PostGIS tidak hanya digunakan untuk menyimpan data spasial, tetapi juga sangat kuat untuk melakukan analisis geografis. Dengan memanfaatkan fungsi pengukuran, relasi topologi, K-NN, dan agregasi spasial, pengguna dapat menjawab berbagai pertanyaan analitis seperti:

* seberapa jauh jarak antar lokasi,
* fasilitas apa saja yang berada dalam suatu wilayah,
* jalan mana yang melewati wilayah tertentu,
* wilayah mana yang memiliki fasilitas paling padat,
* serta area mana yang belum terlayani dengan baik.

Melalui praktikum ini, kemampuan analisis spasial menjadi lebih terstruktur dan dapat digunakan sebagai dasar pengambilan keputusan berbasis lokasi.

---

aporan dengan lebih cepat, rapi, dan lengkap.
