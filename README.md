# FinalTask_Rakamin_IDX_Partners
# ID/X Partners - Data Engineer Final Task (Rakamin Academy)

Repository ini berisi dokumentasi lengkap dan hasil pengerjaan *Final Task* untuk program *Project-Based Internship Data Engineer* di ID/X Partners.

---

## Latar Belakang Proyek (Project Background)
Salah satu klien ID/X Partners yang bergerak di industri perbankan menghadapi kendala operasional akibat sistem penyimpanan data yang terfragmentasi. Sumber data tersebar di berbagai platform, mulai dari file Excel (`transaction_excel`), file CSV (`transaction_csv`), hingga Database SQL Server (`transaction_db`, `account`, `customer`, `branch`, `city`, dan `state`). 

Akibatnya, perusahaan kesulitan melakukan ekstraksi data secara bersamaan, yang berujung pada keterlambatan dalam proses pelaporan dan analisis data bisnis . Proyek ini dikerjakan untuk membangun solusi berupa *Data Warehouse* (DWH) terpusat dan otomatisasi alur *Extract, Transform, Load* (ETL) .

---

## Sumber Data (Data Sources)
Sumber data yang digunakan dalam pengerjaan proyek ini meliputi:
* `transaction_excel` (File Excel transaksi)
* `transaction_csv` (File CSV transaksi)
* `transaction_db` (Tabel transaksi di SQL Server)
* `account` (Tabel rekening di SQL Server) 
* `customer` (Tabel pelanggan di SQL Server) 
* `branch` (Tabel kantor cabang di SQL Server) 
* `city` (Tabel kelurahan/wilayah di SQL Server) 
* `state` (Tabel kota di SQL Server) 

---

## Desain & Struktur Data Warehouse (DWH)
Sebuah database baru bernama **`DWH`** dirancang dengan menerapkan struktur relasional yang mencakup *Primary Key* (PK) dan *Foreign Key* (FK) pada setiap tabelnya .

### 1. Tabel Dimensi (Dimension Tables)
* **`DimAccount`**: Menyimpan data terkait informasi rekening.
* **`DimCustomer`**: Dibentuk dari hasil penggabungan (*join*) tabel `customer`, `city`, dan `state` untuk mengambil kolom `CityName` dan `StateName` . 
  * Aturan transformasi: Seluruh data kolom diubah menjadi huruf kapital (UPPERCASE), **kecuali** untuk kolom `CustomerID`, `Age`, dan `Email` .
  * Standar penamaan: Mengikuti kaidah *PascalCase* (contoh: `account_id` diubah menjadi `AccountID`).
* **`DimBranch`**: Menyimpan data informasi cabang bank.

### 2. Tabel Fakta (Fact Table)
* **`FactTransaction`**: Menggabungkan data transaksi mentah dari berbagai sumber (`transaction_excel`, `transaction_csv`, dan `transaction_db`) dengan memastikan tidak ada duplikasi data (*no duplicate rows*) di dalam tabel.

---

## Implementasi ETL Menggunakan Talend
Proses pemindahan dan transformasi data dari *source* ke dalam *Data Warehouse* dikonfigurasi menggunakan aplikasi Talend :
* **`tUnite` & `tUniqRow`**: Digunakan untuk menggabungkan multi-sumber data transaksi serta membersihkan data yang terduplikasi .
* **`tMap`**: Digunakan untuk memetakan kolom, mengatur format huruf kapital pada tabel dimensi, dan menghubungkan relasi antar tabel .

---

## Stored Procedures (SPs)
Dua *Stored Procedure* berbasis parameter telah dikembangkan di SQL Server untuk menghasilkan ringkasan data secara cepat dan efisien :

### 1. `DailyTransaction`
* **Fungsi**: Menghitung jumlah transaksi (`TotalTransactions`) beserta total nominal (`TotalAmount`) setiap harinya .
* **Parameter**: Menggunakan `start_date` dan `end_date` untuk memfilter data berdasarkan rentang tanggal tertentu .
* **Kolom Output**: `Date`, `TotalTransactions`, `TotalAmount` .

### 2. `BalancePerCustomer`
* **Fungsi**: Mengetahui sisa saldo terkini (`CurrentBalance`) per nasabah . 
* **Logika Kalkulasi**: `CurrentBalance` dihitung dari kolom `balance` pada tabel `account` dikurangi/ditambah total amount transaksi berdasarkan `account_id` . Jika `transaction_type` bernilai *Deposit*, maka saldo bertambah; selain itu, saldo akan berkurang .
* **Parameter**: `name` (untuk mencari data berdasarkan nama nasabah) .
* **Filter Khusus**: Hanya memproses akun yang berstatus *active* .
* **Kolom Output**: `CustomerName`, `AccountType`, `Balance`, `CurrentBalance` .

