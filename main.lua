--========================================================
-- Script Maker V1 - Roblox Lua (Versi Diperbaiki)
--========================================================

-- Variabel utama
local recorded_coords = {}
local is_recording = false
local player = game.Players.LocalPlayer

-- Membuat GUI di layar
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ScriptMakerV1Gui"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.4, 0, 0.45, 0)
frame.Position = UDim2.new(0.3, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- Menambahkan judul dan tombol tutup
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.8, 0, 0.1, 0)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "Script Maker V1"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.TextScaled = true
title.Font = Enum.Font.SourceSansBold
title.Parent = frame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0.2, 0, 0.1, 0)
closeBtn.Position = UDim2.new(0.8, 0, 0, 0)
closeBtn.Text = "Close"
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.Parent = frame
closeBtn.MouseButton1Click:Connect(function()
    frame:Destroy()
end)

-- Menambahkan tombol fungsional
local startBtn = Instance.new("TextButton")
startBtn.Size = UDim2.new(0.25, 0, 0.15, 0)
startBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
startBtn.Text = "Start"
startBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
startBtn.TextScaled = true
startBtn.Parent = frame
startBtn.MouseButton1Click:Connect(function()
    is_recording = true
end)

local stopBtn = Instance.new("TextButton")
stopBtn.Size = UDim2.new(0.25, 0, 0.15, 0)
stopBtn.Position = UDim2.new(0.35, 0, 0.15, 0)
stopBtn.Text = "Stop"
stopBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 0)
stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
stopBtn.TextScaled = true
stopBtn.Parent = frame
stopBtn.MouseButton1Click:Connect(function()
    is_recording = false
end)

local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(0.25, 0, 0.15, 0)
copyBtn.Position = UDim2.new(0.65, 0, 0.15, 0)
copyBtn.Text = "Copy"
copyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
copyBtn.TextScaled = true
copyBtn.Parent = frame
copyBtn.MouseButton1Click:Connect(function()
    local output = ""
    for i, coord in ipairs(recorded_coords) do
        output = output .. string.format("%.2f, %.2f, %.2f\n", coord.X, coord.Y, coord.Z)
    end
    logArea.Text = output
end)

local addCoorBtn = Instance.new("TextButton")
addCoorBtn.Size = UDim2.new(0.25, 0, 0.15, 0)
addCoorBtn.Position = UDim2.new(0.05, 0, 0.35, 0)
addCoorBtn.Text = "Add Coor"
addCoorBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 150)
addCoorBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
addCoorBtn.TextScaled = true
addCoorBtn.Parent = frame
addCoorBtn.MouseButton1Click:Connect(function()
    if is_recording then
        local character = player.Character
        if character then
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local position = humanoidRootPart.Position
                table.insert(recorded_coords, position)
            end
        end
    else
        logArea.Text = "Tekan 'Start' terlebih dahulu!"
    end
end)

local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim2.new(0.25, 0, 0.15, 0)
clearBtn.Position = UDim2.new(0.35, 0, 0.35, 0)
clearBtn.Text = "Clear"
clearBtn.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
clearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
clearBtn.TextScaled = true
clearBtn.Parent = frame
clearBtn.MouseButton1Click:Connect(function()
    recorded_coords = {}
    logArea.Text = "Semua koordinat telah dihapus."
end)

-- Area log untuk menampilkan teks
local logArea = Instance.new("TextBox")
logArea.Size = UDim2.new(0.9, 0, 0.4, 0)
logArea.Position = UDim2.new(0.05, 0, 0.55, 0)
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

-- Loop untuk memperbarui koordinat secara real-time
spawn(function()
    while wait() do
        local character = player.Character
        if character then
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                if not is_recording then
                    local position = humanoidRootPart.Position
                    logArea.Text = "Logging...\n" .. string.format("%.2f, %.2f, %.2f", position.X, position.Y, position.Z)
                else
                    logArea.Text = "Merekam...\n(Tekan 'Add Coor' untuk menyimpan)"
                end
            end
        end
    end
end)
