--!strict
-- Mendapatkan Service Roblox untuk praktik terbaik
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local hrp: BasePart? = nil -- HumanoidRootPart

-- Variabel Status
local FRAME_RATE = 30 -- Target FPS untuk pergerakan
local FRAME_TIME = 1 / FRAME_RATE
local playbackRate = 1.0 -- Pengali kecepatan pergerakan
local isRunning = false -- Bendera status pergerakan aktif

-- Fungsi untuk mendapatkan dan memperbarui referensi HumanoidRootPart
local function refreshHRP(char: Model?)
    if not char then
        char = player.Character or player.CharacterAdded:Wait()
    end
    
    local newHRP = char:FindFirstChild("HumanoidRootPart") :: BasePart?
    
    if newHRP and newHRP:IsA("BasePart") then
        hrp = newHRP
        -- Pastikan HRP tidak di-anchored agar pergerakan CFrame berfungsi
        if hrp:GetAttribute("Anchored") == true then
             -- Atribut umum pada beberapa game, jika tidak ada, hiraukan
        end
    else
        warn("HumanoidRootPart tidak ditemukan.")
        hrp = nil
    end
end

-- Inisialisasi awal HRP
if player.Character then refreshHRP(player.Character) end
-- Hubungkan ke CharacterAdded untuk menangani respawn
player.CharacterAdded:Connect(refreshHRP)

-- Definisi Data Rute
type RouteData = {string, CFrame[]}
local routes: RouteData[] = {}

-- Rute CP1: Kumpulan CFrame waypoints
local CP1 = {
    CFrame.new(-5544.76, 645.73, -1089.08) * CFrame.Angles(0,0,0),
    CFrame.new(-5545.52, 645.73, -1089.21) * CFrame.Angles(0,0,0),
    CFrame.new(-5547.23, 645.73, -1089.44) * CFrame.Angles(0,0,0)
}

-- Mengisi tabel rute
routes = {
    {"CP0 → CP1", CP1}
}

-------------------------------------------------------------------------------
-- Fungsi Pembantu (Helper Functions)
-------------------------------------------------------------------------------

-- Interpolasi CFrame yang menunggu hingga selesai
local function lerpCF(fromCF: CFrame, toCF: CFrame)
    -- Hitung durasi efektif per segmen berdasarkan playbackRate
    local duration = FRAME_TIME / math.max(0.05, playbackRate)
    local t = 0
    
    -- Menggunakan task.wait() untuk yield (menunda) secara efisien
    while t < duration do
        if not isRunning then break end
        
        -- Menggunakan task.wait() (modern) daripada wait() (usang)
        local dt = task.wait() 
        t += dt
        
        local alpha = math.min(t / duration, 1)
        
        -- Pastikan HRP masih ada sebelum mengupdate CFrame
        if hrp and hrp.Parent and hrp:IsDescendantOf(workspace) then
            hrp.CFrame = fromCF:Lerp(toCF, alpha)
        end
    end
end

-- Menemukan indeks rute terdekat dari posisi pemain
local function getNearestRoute(): number
    local nearestIdx = 1
    local dist = math.huge

    if hrp then
        local pos = hrp.Position
        for i, data in ipairs(routes) do
            local _, frames = table.unpack(data)
            for _, cf in ipairs(frames) do
                local d = (cf.Position - pos).Magnitude
                if d < dist then
                    dist = d
                    nearestIdx = i
                end
            end
        end
    end
    return nearestIdx
end

-- Menemukan indeks frame terdekat dalam rute
local function getNearestFrameIndex(frames: CFrame[]): number
    local startIdx = 1
    local dist = math.huge

    if hrp then
        local pos = hrp.Position
        for i, cf in ipairs(frames) do
            local d = (cf.Position - pos).Magnitude
            if d < dist then
                dist = d
                startIdx = i
            end
        end
    end

    -- Pastikan startIdx minimal 1 dan tidak melebihi #frames - 1
    -- Karena kita selalu melakukan interpolasi dari [i] ke [i+1]
    return math.min(startIdx, math.max(1, #frames - 1))
end

-------------------------------------------------------------------------------
-- Fungsi Eksekusi Rute
-------------------------------------------------------------------------------

-- Menjalankan rute terdekat sekali saja
local function runRouteOnce()
    if #routes == 0 or isRunning then return end -- Cegah dijalankan ganda
    if not hrp then refreshHRP() end
    if not hrp then warn("Tidak dapat memulai rute: HumanoidRootPart hilang.") return end

    isRunning = true
    local idx = getNearestRoute()
    local routeName, frames = table.unpack(routes[idx])
    
    print("▶ Start CP:", routeName)
    
    if #frames < 2 then isRunning = false return end
    
    local startIdx = getNearestFrameIndex(frames)
    
    for i = startIdx, #frames - 1 do
        if not isRunning then break end
        
        -- Panggil lerpCF dan TUNGGU hingga selesai (ini perbaikan utama!)
        lerpCF(frames[i], frames[i+1])
    end
    
    isRunning = false
end

-- Menjalankan semua rute berurutan dari rute terdekat
local function runAllRoutes()
    if #routes == 0 or isRunning then return end
    if not hrp then refreshHRP() end
    if not hrp then warn("Tidak dapat memulai semua rute: HumanoidRootPart hilang.") return end
    
    isRunning = true
    local idx = getNearestRoute()
    print("⏩ Start To End dari:", routes[idx][1])
    
    for r = idx, #routes do
        if not isRunning then break end
        local _, frames = table.unpack(routes[r])

        if #frames < 2 then continue end
        
        -- Mulai dari frame terdekat HANYA pada rute pertama (r == idx), 
        -- rute selanjutnya selalu mulai dari frame ke-1.
        local startIdx = (r == idx) and getNearestFrameIndex(frames) or 1
        
        for i = startIdx, #frames - 1 do
            if not isRunning then break end
            
            -- Panggil lerpCF dan TUNGGU hingga selesai (perbaikan utama!)
            lerpCF(frames[i], frames[i+1])
        end
    end
    
    isRunning = false
end

-- Menghentikan pergerakan
local function stopRoute()
    if isRunning then
        print("⏹ Stop ditekan")
    end
    isRunning = false
end

-------------------------------------------------------------------------------
-- Setup GUI (Antarmuka Pengguna)
-------------------------------------------------------------------------------

-- Definisi warna yang disederhanakan
local WHITE = Color3.new(1, 1, 1)
local CORNER_RADIUS_8 = UDim.new(0,8)
local CORNER_RADIUS_10 = UDim.new(0,10)
local CORNER_RADIUS_12 = UDim.new(0,12)
local CORNER_RADIUS_14 = UDim.new(0,14)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WataXReplay"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui -- Memastikan GUI berada di CoreGui

local frame = Instance.new("Frame",screenGui)
frame.Size = UDim2.new(0,280,0,180)
frame.Position = UDim2.new(0.5,-140,0.5,-90)
frame.BackgroundColor3 = Color3.fromRGB(35,35,40)
frame.Active = true
frame.Draggable = true
frame.BackgroundTransparency = 0.05
Instance.new("UICorner", frame).CornerRadius = CORNER_RADIUS_12

local title = Instance.new("TextLabel",frame)
title.Size = UDim2.new(1,0,0,32)
title.Text = "WataX Menu"
title.BackgroundColor3 = Color3.fromRGB(55,55,65)
title.TextColor3 = WHITE
title.Font = Enum.Font.GothamBold
title.TextScaled = true
Instance.new("UICorner", title).CornerRadius = CORNER_RADIUS_12

local startCP = Instance.new("TextButton",frame)
startCP.Size = UDim2.new(0.5,-7,0,42)
startCP.Position = UDim2.new(0,5,0,44)
startCP.Text = "Start CP"
startCP.BackgroundColor3 = Color3.fromRGB(60,200,80)
startCP.TextColor3 = WHITE
startCP.Font = Enum.Font.GothamBold
startCP.TextScaled = true
Instance.new("UICorner", startCP).CornerRadius = CORNER_RADIUS_10
startCP.MouseButton1Click:Connect(runRouteOnce)

local stopBtn = Instance.new("TextButton",frame)
stopBtn.Size = UDim2.new(0.5,-7,0,42)
stopBtn.Position = UDim2.new(0.5,2,0,44)
stopBtn.Text = "Stop"
stopBtn.BackgroundColor3 = Color3.fromRGB(220,70,70)
stopBtn.TextColor3 = WHITE
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextScaled = true
Instance.new("UICorner", stopBtn).CornerRadius = CORNER_RADIUS_10
stopBtn.MouseButton1Click:Connect(stopRoute)

local startAll = Instance.new("TextButton",frame)
startAll.Size = UDim2.new(1,-10,0,42)
startAll.Position = UDim2.new(0,5,0,96)
startAll.Text = "Start To End"
startAll.BackgroundColor3 = Color3.fromRGB(70,120,220)
startAll.TextColor3 = WHITE
startAll.Font = Enum.Font.GothamBold
startAll.TextScaled = true
Instance.new("UICorner", startAll).CornerRadius = CORNER_RADIUS_10
startAll.MouseButton1Click:Connect(runAllRoutes)


local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0,30,0,30)
closeBtn.Position = UDim2.new(0,0,0,0)
closeBtn.Text = "✖"
closeBtn.BackgroundColor3 = Color3.fromRGB(220,60,60)
closeBtn.TextColor3 = WHITE
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextScaled = true
Instance.new("UICorner", closeBtn).CornerRadius = CORNER_RADIUS_8
closeBtn.MouseButton1Click:Connect(function()
    stopRoute() -- Hentikan rute sebelum menutup GUI
    if screenGui then screenGui:Destroy() end
end)


local miniBtn = Instance.new("TextButton", frame)
miniBtn.Size = UDim2.new(0,30,0,30)
miniBtn.Position = UDim2.new(1,-30,0,0)
miniBtn.Text = "—"
miniBtn.BackgroundColor3 = Color3.fromRGB(80,80,200)
miniBtn.TextColor3 = WHITE
miniBtn.Font = Enum.Font.GothamBold
miniBtn.TextScaled = true
Instance.new("UICorner", miniBtn).CornerRadius = CORNER_RADIUS_8

local bubbleBtn = Instance.new("TextButton", screenGui)
bubbleBtn.Size = UDim2.new(0,80,0,46)
bubbleBtn.Position = UDim2.new(0,20,0.7,0)
bubbleBtn.Text = "WataX"
bubbleBtn.BackgroundColor3 = Color3.fromRGB(0,140,220)
bubbleBtn.TextColor3 = WHITE
bubbleBtn.Font = Enum.Font.GothamBold
bubbleBtn.TextScaled = true
bubbleBtn.Visible = false
bubbleBtn.Active = true
bubbleBtn.Draggable = true
Instance.new("UICorner", bubbleBtn).CornerRadius = CORNER_RADIUS_14

miniBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
    bubbleBtn.Visible = true
end)
bubbleBtn.MouseButton1Click:Connect(function()
    frame.Visible = true
    bubbleBtn.Visible = false
end)


local discordBtn = Instance.new("TextButton", frame)
discordBtn.Size = UDim2.new(0,100,0,30)
discordBtn.AnchorPoint = Vector2.new(0,1)
discordBtn.Position = UDim2.new(0,5,1,-5)
discordBtn.Text = "Discord"
discordBtn.BackgroundColor3 = Color3.fromRGB(90,90,220)
discordBtn.TextColor3 = WHITE
discordBtn.Font = Enum.Font.GothamBold
discordBtn.TextScaled = true
Instance.new("UICorner", discordBtn).CornerRadius = CORNER_RADIUS_8


discordBtn.Size = UDim2.new(0,100,0,30)
discordBtn.AnchorPoint = Vector2.new(0,1)
discordBtn.Position = UDim2.new(0,5,1,-5)

local speedRow = Instance.new("Frame", frame)
speedRow.Size = UDim2.new(0,160,0,30)
speedRow.AnchorPoint = Vector2.new(0,1)
speedRow.Position = UDim2.new(0,110,1,-5)
speedRow.BackgroundTransparency = 1

local speedValue = Instance.new("TextLabel", speedRow)
speedValue.Size = UDim2.new(0,60,1,0)
speedValue.Position = UDim2.new(0,0,0,0)
speedValue.BackgroundTransparency = 1
speedValue.TextColor3 = Color3.fromRGB(220,220,220)
speedValue.Font = Enum.Font.GothamBold
speedValue.TextScaled = true
speedValue.Text = string.format("%.2fx", playbackRate)

local speedDown = Instance.new("TextButton", speedRow)
speedDown.Size = UDim2.new(0,40,1,0)
speedDown.Position = UDim2.new(0,65,0,0)
speedDown.Text = "–"
speedDown.BackgroundColor3 = Color3.fromRGB(60,60,100)
speedDown.TextColor3 = WHITE
Instance.new("UICorner", speedDown).CornerRadius = CORNER_RADIUS_8

local speedUp = Instance.new("TextButton", speedRow)
speedUp.Size = UDim2.new(0,40,1,0)
speedUp.Position = UDim2.new(0,110,0,0)
speedUp.Text = "+"
speedUp.BackgroundColor3 = Color3.fromRGB(60,60,100)
speedUp.TextColor3 = WHITE
Instance.new("UICorner", speedUp).CornerRadius = CORNER_RADIUS_8

speedDown.MouseButton1Click:Connect(function()
    playbackRate = math.max(0.25, playbackRate - 0.25)
    if speedValue and speedValue:IsDescendantOf(game) then
        speedValue.Text = string.format("%.2fx", playbackRate)
    end
end)
speedUp.MouseButton1Click:Connect(function()
    playbackRate = math.min(3, playbackRate + 0.25)
    if speedValue and speedValue:IsDescendantOf(game) then
        speedValue.Text = string.format("%.2fx", playbackRate)
    end
end)

discordBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard("https://discord.gg/tfNqRQsqHK")
    else
        warn("setclipboard tidak tersedia.")
    end
end)
