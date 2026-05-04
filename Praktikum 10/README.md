# 🌍 GeoAI Integrated Pipeline: YOLOv8 & WebGIS Visualization
### Proyek Deteksi Objek Spasial Otomatis - Wilayah Tanjung Agung, Lampung

Sistem ini merupakan implementasi *end-to-end* yang menggabungkan teknologi **Kecerdasan Buatan (Computer Vision)** dengan **Sistem Informasi Geografis (WebGIS)**. Proyek ini dirancang untuk mendeteksi objek secara otomatis pada citra satelit/udara resolusi tinggi menggunakan arsitektur **YOLOv8**.

---

## 👨‍💻 Kontributor
**[Awi Septian Prasetyo]**  
**NIM: [123140201]**  
Program Studi Teknik Informatika - Institut Teknologi Sumatera (ITERA)



## 🚀 Alur Kerja Sistem (Workflow)

Sistem ini bekerja melalui 5 tahapan utama sesuai dengan standar pengelolaan data geospasial:

1.  **Image Tiling:** Membagi citra GeoTIFF raksasa (20.000 x 19.000 px) menjadi ubin-ubin kecil berukuran 640x640 px menggunakan **OpenCV** dan **Rasterio** untuk efisiensi memori.
2.  **Object Detection:** Melakukan inferensi deteksi objek menggunakan model **YOLOv8n** (Nano) dari Ultralytics.
3.  **Spatial Georeferencing:** Mengonversi koordinat piksel hasil deteksi AI menjadi koordinat geografis bumi asli (**WGS84**) menggunakan metadata *Affine Transform*.
4.  **GeoJSON Export:** Mengekstraksi seluruh data deteksi ke dalam format standar geospasial `.geojson` yang mencakup kelas objek dan skor kepercayaan (*confidence score*).
5.  **WebGIS Integration:** Visualisasi data interaktif pada aplikasi berbasis **React** dan **Leaflet.js** dengan dukungan *Satellite Basemap*.

---

## 🛠️ Tech Stack

| Komponen | Teknologi |
| :--- | :--- |
| **AI Engine** | Python 3.10, Ultralytics YOLOv8 |
| **Image Processing** | OpenCV, NumPy |
| **Geospatial Library** | Rasterio, Shapely |
| **Frontend Web** | React.js, Vite, Leaflet.js |
| **Backend Web** | FastAPI / Python |

---

## ✨ Fitur Inovasi (Poin Tambahan)

Proyek ini dilengkapi dengan beberapa inovasi teknis di luar ketentuan dasar:

*   **📊 Automated Spatial Analytics:** Program backend secara otomatis menghasilkan tabel statistik jumlah objek yang ditemukan langsung di terminal (Dashboard Terminal).
*   **🟢 Neon Marker UI:** Visualisasi marker di peta menggunakan gaya hijau neon (`#39ff14`) untuk memberikan kesan modern dan membedakan data AI dengan data fasilitas umum manual.
*   **🛰️ Hybrid Basemap Control:** Integrasi kontrol layer yang memungkinkan pengguna berpindah antara peta satelit (Esri Imagery) dan peta jalan (OSM) untuk verifikasi akurasi visual.
*   **🛡️ Metadata Richness:** Penambahan properti `confidence_score` dan `timestamp` pada setiap objek GeoJSON untuk audit data yang lebih baik.

---

## 📂 Struktur Folder Proyek

```text
├── 📁 data                   # File citra mentah (.tif)
├── 📁 output                 # Hasil deteksi (GeoJSON & Laporan Teks)
├── 📁 webgis-frontend        # Proyek React (Vite)
│   ├── 📁 public/data        # Tempat menyimpan detections.geojson
│   └── 📁 src/components     # Komponen MapView.jsx
├── 📁 webgis-backend         # Proyek API (Database & Routers)
├── 📄 main.py                # Script Utama (AI & Georeferencing)
└── 📄 yolov8n.pt             # Model Weight YOLOv8
```

---

## ⚙️ Cara Menjalankan

### 1. Jalankan Deteksi AI (Backend)
Pastikan semua library terinstal (`pip install ultralytics rasterio opencv-python`), lalu jalankan:
```bash
python main.py
```
*Hasil akan muncul di folder `output/` dan tabel statistik akan muncul di terminal.*

### 2. Jalankan Visualisasi (Frontend)
Masuk ke folder frontend dan jalankan server pengembangan:
```bash
cd webgis-frontend
npm install
npm run dev
```
*Buka browser di `http://localhost:5173` untuk melihat hasil titik koordinat di atas peta satelit.*
