# 📚 Pustaka Mini

Aplikasi katalog dan peminjaman buku berbasis Flutter yang dikembangkan sebagai proyek UTS kelompok.

Pustaka Mini bertujuan membantu pengguna melihat katalog buku dan mengelola informasi peminjaman buku melalui aplikasi mobile.

## 📌 Teknologi yang Digunakan

| Teknologi | Keterangan |
|---|---|
| Flutter | Framework pengembangan aplikasi |
| Dart | Bahasa pemrograman |
| Material Design 3 | Sistem desain antarmuka |
| Google Fonts | Tipografi aplikasi |
| REST API | Integrasi backend (dikembangkan terpisah) |

## 📋 Persyaratan Instalasi

Pastikan perangkat sudah memiliki:

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Dart SDK](https://dart.dev/get-dart)
- [Android Studio](https://developer.android.com/studio) atau Visual Studio Code
- Android SDK untuk menjalankan aplikasi di Android
- Google Chrome (opsional, untuk menjalankan aplikasi di browser)
- Git

Periksa instalasi Flutter dengan perintah:

```bash
flutter doctor
```

## 📂 Struktur Repository

```text
Katalog-dan-Peminjaman-Buku/
│
├── app/
│   ├── lib/
│   │   ├── main.dart
│   │   ├── pages/
│   │   │   ├── halaman_utama.dart
│   │   │   ├── halaman_katalog.dart
│   │   │   ├── halaman_pinjaman.dart
│   │   │   └── halaman_profil.dart
│   │   ├── widgets/
│   │   ├── models/
│   │   ├── services/
│   │   └── theme/
│   │       └── app_theme.dart
│   │
│   ├── assets/
│   │   ├── images/
│   │   └── fonts/
│   │
│   ├── test/
│   └── pubspec.yaml
│
├── server/
│
├── screenshots/
│
└── README.md
```

## 🚀 Cara Menjalankan Project

### 1. Clone Repository

```bash
git clone <URL_REPOSITORY>
```

Masuk ke direktori repository:

```bash
cd Katalog-dan-Peminjaman-Buku
```

### 2. Masuk ke Folder Aplikasi

```bash
cd app
```

### 3. Install Dependencies

Jalankan perintah:

```bash
flutter pub get
```

Perintah ini akan mengunduh seluruh dependencies yang dibutuhkan berdasarkan konfigurasi `pubspec.yaml`.

### 4. Periksa Konfigurasi Flutter

```bash
flutter doctor
```

Pastikan kebutuhan pengembangan Flutter dan Android sudah terpenuhi.

### 5. Jalankan Aplikasi

Untuk menjalankan aplikasi melalui Chrome:

```bash
flutter run -d chrome
```

Untuk menjalankan aplikasi pada perangkat Android yang terhubung:

```bash
flutter devices
```

Kemudian:

```bash
flutter run
```

### 6. Jalankan Backend REST API

Backend Dart Shelf berada pada folder `server/`. Buka terminal di root repository,
lalu jalankan:

```bash
cd server
dart pub get
dart run bin/server.dart
```

Server berjalan di `http://localhost:8080` secara default. Port dapat diubah
dengan mengatur environment variable `PORT`. Data buku dimuat dari
`server/data/buku.json`.

Endpoint yang tersedia:

| Method | Path | Hasil |
|---|---|---|
| GET | `/buku` | Daftar seluruh buku |
| GET | `/buku/:id` | Detail satu buku berdasarkan ID |
| GET | `/kategori` | Daftar kategori unik |

Uji endpoint dengan membuka URL di browser atau menjalankan pengujian:

```bash
cd server
dart test
```

## 🧪 Pemeriksaan Kode

Untuk memeriksa apakah terdapat masalah pada kode, jalankan:

```bash
flutter analyze
```

Untuk menjalankan pengujian:

```bash
flutter test
```

## 🎨 Konfigurasi Tema

Pustaka Mini menggunakan Material Design 3 dengan dua konfigurasi tema:

- **Light Theme:** Tampilan terang.
- **Dark Theme:** Tampilan gelap.

Tema aplikasi dikonfigurasi pada:

```text
lib/theme/app_theme.dart
```

Aplikasi secara default mengikuti pengaturan tema perangkat menggunakan:

```dart
themeMode: ThemeMode.system
```

## 📱 Fitur Aplikasi

Fitur utama yang direncanakan dalam aplikasi:

1. **Katalog Buku** — Menampilkan daftar buku yang tersedia.
2. **Pencarian Buku** — Memudahkan pengguna mencari buku.
3. **Detail Buku** — Menampilkan informasi lengkap buku.
4. **Peminjaman Buku** — Mendukung proses peminjaman buku.
5. **Pengajuan Buku** — Memungkinkan pengguna mengajukan buku.
6. **Profil Pengguna** — Menampilkan informasi pengguna.

Beberapa halaman saat ini masih menggunakan placeholder dan akan diintegrasikan dengan implementasi masing-masing anggota kelompok.

## 👥 Pembagian Tugas Kelompok

| Anggota | Tanggung Jawab |
|---|---|
| Faris | Project Setup, Navigation, Theme, Initial Integration |
| Novi | Book Model, Katalog Buku, Book Card, Search |
| Andra | Backend Dart Shelf dan REST API |
| Alpi | Detail Buku dan Peminjaman |
| Dio | Form Pengajuan Buku, API Service, Testing, Dokumentasi |

## 📝 Catatan Pengembangan

- Aplikasi dikembangkan menggunakan Flutter dan Dart.
- Backend dikembangkan secara terpisah pada folder `server`.
- Integrasi API dilakukan setelah implementasi backend tersedia.
- Setiap anggota kelompok mengerjakan bagian sesuai pembagian tugas.
- Gunakan commit Git untuk mencatat setiap perubahan pekerjaan.

## 📄 Lisensi

Proyek ini dikembangkan untuk memenuhi tugas Ujian Tengah Semester (UTS) mata kuliah terkait pengembangan aplikasi.

---

**Pustaka Mini — Katalog dan Peminjaman Buku**
