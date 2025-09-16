--========================================================
-- Script Maker V1 - Log Koordinat Real-time
--========================================================

-- Variabel utama
local player = game.Players.LocalPlayer
local is_logging = false

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
    is_logging = true
    textLabel.Text = "Mulai logging..."
    updateLog()
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
    is_logging = false
    textLabel.Text = textLabel.Text .. "\nLogging dihentikan."
    updateLog()
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
    -- Mengatur properti TextLabel agar dapat dipilih
    textLabel.TextSelectable = true
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
    if not is_logging then
        textLabel.Text = textLabel.Text .. "\n(Tambahkan koordinat secara manual)"
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            local position = humanoidRootPart.Position
            textLabel.Text = textLabel.Text .. "\n" .. string.format("%.2f, %.2f, %.2f", position.X, position.Y, position.Z)
        end
    else
        textLabel.Text = textLabel.Text .. "\n(Perekaman real-time sedang aktif)"
    end
    updateLog()
end)

local teleportBtn = Instance.new("TextButton")
teleportBtn.Size = UDim2.new(0.25, 0, 0.15, 0)
teleportBtn.Position = UDim2.new(0.65, 0, 0.35, 0)
teleportBtn.Text = "Teleport"
teleportBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
teleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportBtn.TextScaled = true
teleportBtn.Parent = frame
teleportBtn.MouseButton1Click:Connect(function()
    local x = tonumber(xInput.Text)
    local y = tonumber(yInput.Text)
    local z = tonumber(zInput.Text)
    if x and y and z then
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            humanoidRootPart.Position = Vector3.new(x, y, z)
            textLabel.Text = textLabel.Text .. "\nTeleported to: " .. string.format("%.2f, %.2f, %.2f", x, y, z)
            updateLog()
        else
            textLabel.Text = textLabel.Text .. "\nError: HumanoidRootPart not found"
            updateLog()
        end
    else
        textLabel.Text = textLabel.Text .. "\nError: Invalid coordinates"
        updateLog()
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
    textLabel.Text = "Log telah dihapus."
    updateLog()
end)

-- Input koordinat untuk teleport
local xInput = Instance.new("TextBox")
xInput.Size = UDim2.new(0.25, 0, 0.08, 0)
xInput.Position = UDim2.new(0.05, 0, 0.45, 0)
xInput.PlaceholderText = "X"
xInput.Text = ""
xInput.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
xInput.TextColor3 = Color3.fromRGB(0, 0, 0)
xInput.Font = Enum.Font.SourceSans
xInput.TextSize = 14
xInput.Parent = frame

local yInput = Instance.new("TextBox")
yInput.Size = UDim2.new(0.25, 0, 0.08, 0)
yInput.Position = UDim2.new(0.35, 0, 0.45, 0)
yInput.PlaceholderText = "Y"
yInput.Text = ""
yInput.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
yInput.TextColor3 = Color3.fromRGB(0, 0, 0)
yInput.Font = Enum.Font.SourceSans
yInput.TextSize = 14
yInput.Parent = frame

local zInput = Instance.new("TextBox")
zInput.Size = UDim2.new(0.25, 0, 0.08, 0)
zInput.Position = UDim2.new(0.65, 0, 0.45, 0)
zInput.PlaceholderText = "Z"
zInput.Text = ""
zInput.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
zInput.TextColor3 = Color3.fromRGB(0, 0, 0)
zInput.Font = Enum.Font.SourceSans
zInput.TextSize = 14
zInput.Parent = frame

-- Area log untuk menampilkan teks
local logArea = Instance.new("ScrollingFrame")
logArea.Size = UDim2.new(0.9, 0, 0.4, 0)
logArea.Position = UDim2.new(0.05, 0, 0.55, 0)
logArea.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
logArea.ScrollBarThickness = 8
logArea.Parent = frame

local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1, 0, 0, 0)
textLabel.Position = UDim2.new(0, 0, 0, 0)
textLabel.Text = ""
textLabel.BackgroundTransparency = 1
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.TextWrapped = true
textLabel.TextScaled = false
textLabel.Font = Enum.Font.SourceSans
textLabel.TextSize = 14
textLabel.TextXAlignment = Enum.TextXAlignment.Left
textLabel.TextYAlignment = Enum.TextYAlignment.Top
textLabel.AutomaticSize = Enum.AutomaticSize.Y
textLabel.Parent = logArea

logArea.AutomaticCanvasSize = Enum.AutomaticSize.Y
logArea.CanvasSize = UDim2.new(0, 0, 0, 0)

local function updateLog()
    logArea.CanvasPosition = Vector2.new(0, 999999)
end

-- Logika real-time: Memperbarui log saat posisi berubah
task.spawn(function()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    while task.wait(1) do
        if is_logging then
            local currentPosition = humanoidRootPart.Position
            local formattedCoord = string.format("%.2f, %.2f, %.2f", currentPosition.X, currentPosition.Y, currentPosition.Z)
            textLabel.Text = textLabel.Text .. "\n" .. formattedCoord
            updateLog()
            print("Coord logged:", formattedCoord)
        end
    end
end)
