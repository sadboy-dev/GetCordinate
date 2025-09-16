--========================================================
-- Script Maker V1 - Paling Stabil
--========================================================

-- Variabel utama
local player = game.Players.LocalPlayer
local lastPosition = nil
local is_logging = false
local RunService = game:GetService("RunService")

-- Fungsi utama untuk membuat GUI
local function createAndStartGUI()
    print("Membuat GUI...") -- Debug

    -- Menghancurkan GUI lama jika ada
    if player.PlayerGui:FindFirstChild("ScriptMakerV1Gui") then
        player.PlayerGui.ScriptMakerV1Gui:Destroy()
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ScriptMakerV1Gui"
    screenGui.Parent = player:WaitForChild("PlayerGui")

    -- Membuat Frame, Tombol, dan Kontainer Log
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.4, 0, 0.45, 0)
    frame.Position = UDim2.new(0.3, 0, 0.3, 0)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
    frame.BorderSizePixel = 2
    frame.Active = true
    frame.Draggable = true
    frame.Parent = screenGui

    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.8, 0, 0.1, 0)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.Text = "Script Maker V1"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundTransparency = 1
    title.TextScaled = true
    title.Font = Enum.Font.SourceSansBold
    title.Parent = frame

    -- Close Button
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
        is_logging = false
        frame:Destroy()
        print("GUI dihancurkan.")
    end)

    -- Scrolling Frame (Kontainer Log)
    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Size = UDim2.new(0.9, 0, 0.4, 0)
    scrollingFrame.Position = UDim2.new(0.05, 0, 0.55, 0)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.BorderSizePixel = 0
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollingFrame.Parent = frame
    
    local logArea = Instance.new("TextBox")
    logArea.Size = UDim2.new(1, -20, 1, 0)
    logArea.Text = "Tekan 'Start' untuk merekam koordinat."
    logArea.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    logArea.TextColor3 = Color3.fromRGB(255, 255, 255)
    logArea.MultiLine = true
    logArea.TextWrapped = true
    logArea.TextScaled = false
    logArea.Font = Enum.Font.SourceSans
    logArea.TextSize = 14
    logArea.ClearTextOnFocus = false
    logArea.TextSelectable = false
    logArea.Parent = scrollingFrame

    -- Tombol-tombol
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
        logArea.Text = "Mulai logging..."
        print("Tombol Start ditekan. Logging aktif.") -- Debug
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
        logArea.Text = logArea.Text .. "\nLogging dihentikan."
        print("Tombol Stop ditekan. Logging nonaktif.") -- Debug
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
        logArea.TextSelectable = true
        logArea.PlaceholderText = "Sekarang Anda dapat menyalin teks ini."
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
        logArea.Text = ""
    end)

    -- Logika logging utama
    RunService.Heartbeat:Connect(function()
        if is_logging then
            local character = player.Character
            if character then
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart and humanoidRootPart.Position then
                    local currentPosition = humanoidRootPart.Position
                    if not lastPosition or (currentPosition - lastPosition).Magnitude > 0.1 then
                        local formattedCoord = string.format("%.2f, %.2f, %.2f", currentPosition.X, currentPosition.Y, currentPosition.Z)
                        logArea.Text = logArea.Text .. "\n" .. formattedCoord
                        lastPosition = currentPosition
    
                        -- Auto-scroll
                        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, logArea.TextBounds.Y)
                        scrollingFrame.CanvasPosition = Vector2.new(0, scrollingFrame.CanvasSize.Y.Offset)
                    end
                end
            end
        end
    end)
end

-- Memulai skrip setelah karakter pemain dimuat
player.CharacterAdded:Wait()
createAndStartGUI()
