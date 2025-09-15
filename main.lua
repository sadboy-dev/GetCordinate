local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CoordinatesGui"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.2, 0, 0.15, 0)
frame.Position = UDim2.new(0.4, 0, 0.8, 0)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, 0, 0.5, 0)
label.Position = UDim2.new(0, 0, 0, 0)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.TextScaled = true
label.Parent = frame

local savedLabel = Instance.new("TextLabel")
savedLabel.Size = UDim2.new(1, 0, 0.5, 0)
savedLabel.Position = UDim2.new(0, 0, 0.5, 0)
savedLabel.BackgroundTransparency = 1
savedLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
savedLabel.TextScaled = true
savedLabel.Text = "Saved: 0"
savedLabel.Parent = frame

-- Array untuk menyimpan koordinat
local savedCoords = {}
local lastSavedPos = nil

local function savePosition(pos)
    table.insert(savedCoords, {X = pos.X, Y = pos.Y, Z = pos.Z})
    savedLabel.Text = "Saved: " .. tostring(#savedCoords)
    print("Saved Coordinate:", pos)
end

local function updateCoordinates()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    while true do
        if humanoidRootPart then
            local position = humanoidRootPart.Position
            label.Text = string.format("X: %.2f, Y: %.2f, Z: %.2f", position.X, position.Y, position.Z)

            -- Simpan koordinat hanya kalau bergerak lebih dari 10 stud
            if not lastSavedPos or (position - lastSavedPos).Magnitude > 10 then
                savePosition(position)
                lastSavedPos = position
            end
        end
        task.wait(0.5)
    end
end

task.spawn(updateCoordinates)
