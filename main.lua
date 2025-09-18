--========================================================
-- Fitur Teleport ke Pemain Lain
-- Dibuat untuk ditempatkan di StarterPlayer > StarterPlayerScripts
--========================================================

-- Layanan yang dibutuhkan
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Mengatur GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportGui"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 300)
mainFrame.Position = UDim2.new(1, -210, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
mainFrame.BorderSizePixel = 2
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Teleport Player"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true
title.Parent = mainFrame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 20, 0, 20)
closeBtn.Position = UDim2.new(1, -22, 0, 2)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.Parent = mainFrame
closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, -10, 1, -40)
scrollingFrame.Position = UDim2.new(0, 5, 0, 35)
scrollingFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
scrollingFrame.BorderColor3 = Color3.fromRGB(150, 150, 150)
scrollingFrame.BorderSizePixel = 1
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.Parent = mainFrame
scrollingFrame.VerticalScrollBarInset = Enum.ScrollBarInset.Always

-- Template untuk tombol pemain
local playerButtonTemplate = Instance.new("TextButton")
playerButtonTemplate.Size = UDim2.new(1, 0, 0, 25)
playerButtonTemplate.Text = "PlayerName"
playerButtonTemplate.TextColor3 = Color3.fromRGB(255, 255, 255)
playerButtonTemplate.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
playerButtonTemplate.Font = Enum.Font.SourceSansBold
playerButtonTemplate.TextScaled = true
playerButtonTemplate.Parent = scrollingFrame

local layout = Instance.new("UIListLayout")
layout.FillDirection = Enum.FillDirection.Vertical
layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
layout.VerticalAlignment = Enum.VerticalAlignment.Top
layout.Padding = UDim.new(0, 5)
layout.Parent = scrollingFrame

-- Fungsi untuk melakukan teleportasi
local function teleportToPlayer(targetPlayer)
    local localCharacter = LocalPlayer.Character
    local targetCharacter = targetPlayer.Character
    if not localCharacter or not targetCharacter then
        warn("Karakter tidak ditemukan. Tidak bisa melakukan teleport.")
        return
    end

    local localRoot = localCharacter:WaitForChild("HumanoidRootPart", 5)
    local targetRoot = targetCharacter:WaitForChild("HumanoidRootPart", 5)
    if localRoot and targetRoot then
        -- Teleportasi dengan CFrame untuk posisi dan orientasi yang tepat
        localRoot.CFrame = targetRoot.CFrame + Vector3.new(0, 3, 0) -- Menambahkan offset agar tidak terjebak
    else
        warn("Bagian tubuh karakter tidak ditemukan. Tidak bisa melakukan teleport.")
    end
end

-- Fungsi untuk memperbarui daftar pemain
local function updatePlayerList()
    -- Hapus tombol lama
    for _, button in pairs(scrollingFrame:GetChildren()) do
        if button:IsA("TextButton") then
            button:Destroy()
        end
    end

    local playersInGame = Players:GetPlayers()
    for _, targetPlayer in ipairs(playersInGame) do
        if targetPlayer ~= LocalPlayer then
            local newButton = playerButtonTemplate:Clone()
            newButton.Name = targetPlayer.Name
            newButton.Text = targetPlayer.Name
            newButton.Visible = true
            newButton.Parent = scrollingFrame

            -- Menghubungkan tombol ke fungsi teleport
            newButton.MouseButton1Click:Connect(function()
                teleportToPlayer(targetPlayer)
            end)
        end
    end

    -- Mengatur ukuran kanvas (scroll) agar sesuai dengan jumlah pemain
    local numPlayers = #playersInGame - 1
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, numPlayers * 30)
end

-- Memperbarui daftar pemain saat skrip pertama kali berjalan
updatePlayerList()

-- Memperbarui daftar pemain secara otomatis saat pemain bergabung atau keluar
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)
