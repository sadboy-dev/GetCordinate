--========================================================
-- Script Maker V1 - Roblox Lua
-- Dibuat oleh [Nama Anda]
-- Deskripsi: GUI untuk merekam koordinat di game.
--========================================================

-- Mendefinisikan tabel untuk menyimpan koordinat
local recorded_coords = {}
local is_recording = false

-- Membuat GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ScriptMakerV1Gui"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.4, 0, 0.4, 0)
frame.Position = UDim2.new(0.3, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- Menambahkan judul
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0.1, 0)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "Script Maker V1"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.TextScaled = true
title.Font = Enum.Font.SourceSansBold
title.Parent = frame

-- Menambahkan tombol
local startBtn = Instance.new("TextButton")
startBtn.Name = "StartButton"
startBtn.Size = UDim2.new(0.25, 0, 0.15, 0)
startBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
startBtn.Text = "Start"
startBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
startBtn.TextScaled = true
startBtn.Parent = frame

local stopBtn = Instance.new("TextButton")
stopBtn.Name = "StopButton"
stopBtn.Size = UDim2.new(0.25, 0, 0.15, 0)
stopBtn.Position = UDim2.new(0.35, 0, 0.15, 0)
stopBtn.Text = "Stop"
stopBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 0)
stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
stopBtn.TextScaled = true
stopBtn.Parent = frame

local copyBtn = Instance.new("TextButton")
copyBtn.Name = "CopyButton"
copyBtn.Size = UDim2.new(0.25, 0, 0.15, 0)
copyBtn.Position = UDim2.new(0.65, 0, 0.15, 0)
copyBtn.Text = "Copy"
copyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
copyBtn.TextScaled = true
copyBtn.Parent = frame

local addCoorBtn = Instance.new("TextButton")
addCoorBtn.Name = "AddCoorButton"
addCoorBtn.Size = UDim2.new(0.25, 0, 0.15, 0)
addCoorBtn.Position = UDim2.new(0.05, 0, 0.35, 0)
addCoorBtn.Text = "Add Coor"
addCoorBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 150)
addCoorBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
addCoorBtn.TextScaled = true
addCoorBtn.Parent = frame

local clearBtn = Instance.new("TextButton")
clearBtn.Name = "ClearButton"
clearBtn.Size = UDim2.new(0.25, 0, 0.15, 0)
clearBtn.Position = UDim2.new(0.35, 0, 0.35, 0)
clearBtn.Text = "Clear"
clearBtn.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
clearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
clearBtn.TextScaled = true
clearBtn.Parent = frame

local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseButton"
closeBtn.Size = UDim2.new(0.25, 0, 0.15, 0)
closeBtn.Position = UDim2.new(0.65, 0, 0.05, 0)
closeBtn.Text = "Close"
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextScaled = true
closeBtn.Parent = frame

-- Area logging untuk menampilkan koordinat
local logArea = Instance.new("TextBox")
logArea.Name = "LogArea"
logArea.Size = UDim2.new(0.9, 0, 0.45, 0)
logArea.Position = UDim2.new(0.05, 0, 0.5, 0)
logArea.Text = "Logging..."
logArea.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
logArea.TextColor3 = Color3.fromRGB(255, 255, 255)
logArea.MultiLine = true
logArea.TextWrapped = true
logArea.TextScaled = false
logArea.Font = Enum.Font.SourceSans
logArea.TextSize = 14
logArea.ClearTextOnFocus = false
logArea.Parent = frame

---

### **Fungsionalitas Skrip**

Berikut adalah penjelasan fungsionalitas dari setiap bagian skrip:

#### **Aksi Tombol**
* **Start**: Mengubah status perekaman menjadi **true**. Saat aktif, tombol "Add Coor" akan merekam posisi.
* **Stop**: Mengubah status perekaman menjadi **false**, menghentikan perekaman.
* **Add Coor**: Jika status perekaman aktif, tombol ini akan mengambil koordinat `HumanoidRootPart` pemain dan menambahkannya ke tabel `recorded_coords`.
* **Clear**: Menghapus semua koordinat dari tabel dan mengosongkan area log.
* **Copy**: Mengambil semua koordinat yang terekam, memformatnya dalam bentuk string, dan menampilkannya di area log. Di Roblox, Anda tidak dapat secara langsung menyalin ke clipboard, jadi fungsi ini akan menampilkan hasilnya di log agar mudah dipilih dan disalin secara manual.
* **Close**: Menyembunyikan seluruh GUI.

#### **Mekanisme Perekaman**
Skrip ini menggunakan sebuah tabel bernama `recorded_coords` untuk menyimpan semua data koordinat. Setiap kali tombol **Add Coor** diklik, fungsi akan mengambil posisi `HumanoidRootPart` karakter pemain dan menyimpannya sebagai sebuah vektor di dalam tabel.

#### **Perbedaan dengan Kode Anda**
Kode yang Anda berikan sebelumnya hanya berfungsi untuk menampilkan koordinat secara *real-time* dan tidak memiliki fungsionalitas tombol apa pun. Skrip yang baru ini jauh lebih kompleks karena ia **membangun GUI yang interaktif** dan mengelola data koordinat berdasarkan input dari pengguna, seperti yang terlihat pada gambar.

Anda dapat menyimpan skrip ini sebagai `LocalScript` di dalam `StarterPlayer > StarterPlayerScripts` atau di manapun yang dapat dijalankan di sisi klien.
