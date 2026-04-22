# exter-gruppe6job

Script pekerjaan **Gruppe 6** untuk FiveM dengan dukungan multi-framework, multi-inventory, dan multi-fuel melalui sistem bridge modular.

## Fitur Utama

- Kontrak pengantaran uang bank & isi ulang ATM.
- Sistem group play (`exter-groupsystem`) untuk kerja tim.
- Routing pickup dinamis dengan jumlah stop acak yang tervalidasi.
- Support framework:
  - **QBCore**
  - **Qbox**
  - **ESX**
  - **Standalone** (fitur terbatas/fallback)
- Support inventory:
  - **qb-inventory**
  - **ox_inventory**
  - **esx_inventory** (via fallback event bridge)
  - **qs-inventory** (via fallback event bridge)
  - **codem-inventory** (via fallback event bridge)
- Support fuel:
  - **LegacyFuel**
  - **CDN-Fuel**
  - **ox_fuel**
  - **qb-fuel**
  - **ps-fuel**
- Auto-detection framework/inventory/fuel melalui konfigurasi.

---

## Dependensi

### Wajib

- `oxmysql`
- `interact`
- `PolyZone`
- `exter-groupsystem`

### Opsional (disarankan)

- `exter-tablet`
- `exter-status`
- `exter-contacts`

---

## Instalasi

1. Letakkan folder resource ke server Anda, misalnya:
   ```
   resources/[jobs]/exter-gruppe6job
   ```
2. Pastikan dependensi sudah berjalan lebih dulu di `server.cfg`.
3. Tambahkan ke `server.cfg`:
   ```cfg
   ensure exter-gruppe6job
   ```
4. Konfigurasi file `shared/config.lua` sesuai ekosistem server.
5. Restart server.

---

## Konfigurasi

Semua konfigurasi utama ada di:

- `shared/config.lua`

### 1) Framework

```lua
Config.Framework = 'auto' -- auto | qbcore | esx | qbox | standalone
Config.FrameworkFolder = 'qb-core'
```

### 2) Inventory

```lua
Config.Inventory = 'auto' -- auto | qb-inventory | ox_inventory | esx_inventory | qs-inventory | codem-inventory | standalone
```

### 3) Fuel

```lua
Config.FuelSystem = 'auto' -- auto | LegacyFuel | cdn-fuel | ox_fuel | qb-fuel | ps-fuel | standalone
```

### 4) Debug

```lua
Config.DebugPrint = false
```

---

## Menambahkan Item

## QBCore (`qb-core/shared/items.lua`)

```lua
g6cashbag = { name = 'g6cashbag', label = 'Gruppe6 Cash Bag', weight = 50000, type = 'item', image = 'g6bag.png', unique = true, useable = true, shouldClose = true, description = 'Bag filled with money from banks' },
g6markedcash = { name = 'g6markedcash', label = 'Marked Gruppe6 Cash', weight = 500, type = 'item', image = 'np_cash-roll.png', unique = false, useable = true, shouldClose = true, description = 'Marked Cash obtained from Gruppe6 shipments' },
g6badge = { name = 'g6badge', label = 'Gruppe6 Badge', weight = 50000, type = 'item', image = 'g6badge.png', unique = true, useable = true, shouldClose = true, description = 'This is a Gruppe6 Badge' },
g6pallet = { name = 'g6pallet', label = 'Gruppe6 Pallet', weight = 50000, type = 'item', image = 'g6pallet_2.png', unique = true, useable = true, shouldClose = true, description = 'Pallets filled with money from banks' },
```

## Qbox

Qbox kompatibel dengan item structure QBCore. Tambahkan item di lokasi item definition Qbox Anda dengan field setara (`name`, `label`, `weight`, `image`, `unique`, dll).

## ESX

Tambahkan item ke tabel `items` database atau mekanisme inventory ESX yang Anda gunakan.

Minimal item yang harus tersedia:

- `g6cashbag`
- `g6markedcash`
- `g6badge`
- `g6pallet`

Contoh SQL (struktur dapat berbeda tergantung fork inventory):

```sql
INSERT INTO items (name, label, weight) VALUES
('g6cashbag', 'Gruppe6 Cash Bag', 50000),
('g6markedcash', 'Marked Gruppe6 Cash', 500),
('g6badge', 'Gruppe6 Badge', 50000),
('g6pallet', 'Gruppe6 Pallet', 50000);
```

## ox_inventory

Tambahkan ke `data/items.lua`:

```lua
['g6cashbag'] = { label = 'Gruppe6 Cash Bag', weight = 50000, stack = false, close = true },
['g6markedcash'] = { label = 'Marked Gruppe6 Cash', weight = 500, stack = true, close = true },
['g6badge'] = { label = 'Gruppe6 Badge', weight = 50000, stack = false, close = true },
['g6pallet'] = { label = 'Gruppe6 Pallet', weight = 50000, stack = false, close = true },
```

## qs-inventory / inventory lain

Tambahkan item setara sesuai format resource inventory Anda. Jika resource tidak memiliki API stash yang sama, gunakan event bridge fallback:

- `exter-gruppe6job:inventory:setStashItems`

Anda bisa membuat handler di resource inventory custom untuk sinkronisasi stash.

---

## Alur Penggunaan

1. Pemain masuk grup.
2. Leader mengambil kontrak dari UI.
3. Ambil kendaraan sesuai kontrak.
4. Jalankan route pickup/ATM sesuai task.
5. Deposit di central bank.
6. Return kendaraan untuk menutup flow kontrak.

---

## Catatan Kompatibilitas

- Mode `auto` mendeteksi resource yang aktif (`started/starting`).
- Jika ada beberapa framework/inventory aktif bersamaan, urutan deteksi mengikuti list di `Config.AutoDetect`.
- Untuk inventory selain `qb-inventory` dan `ox_inventory`, sistem memakai fallback event agar tetap bisa diintegrasikan tanpa hard dependency.

---

## Troubleshooting

- **Gagal detect framework**: set `Config.Framework` manual (`qbcore/esx/qbox`).
- **Fuel tidak terisi**: set `Config.FuelSystem` manual sesuai resource fuel yang dipakai.
- **Stash tidak terbuka**: pastikan inventory mendukung stash API atau implement bridge event fallback.
- **Reputasi tidak terbaca**: pastikan tabel `reputation` tersedia dan `oxmysql` berjalan.

---

## Lisensi

Mengikuti lisensi pada file `LICENSE` resource ini.
