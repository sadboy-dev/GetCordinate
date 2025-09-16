local Players = game:GetService("Players")
local player = Players.LocalPlayer
local hrp = nil

local function refreshHRP(char)
    if not char then
        char = player.Character or player.CharacterAdded:Wait()
    end
    hrp = char:WaitForChild("HumanoidRootPart")
end
if player.Character then refreshHRP(player.Character) end
player.CharacterAdded:Connect(refreshHRP)

local frameTime = 1/30
local playbackRate = 1.0
local isRunning = false
local routes = {}


local CP0to1 = {
    CFrame.new(-5983.2978515625, -159.00198364257812, -37.90787887573242) * CFrame.Angles(-1.5840641021114266e-09, -1.5010087490081787, 3.731410203045016e-08),
    CFrame.new(-5982.4482421875, -159.00198364257812, -37.9171257019043) * CFrame.Angles(-1.4443778395545337e-09, -1.5227900743484497, 5.866696639600377e-08),
    CFrame.new(-5981.8818359375, -159.00198364257812, -37.9154052734375) * CFrame.Angles(-2.0622568097650174e-09, -1.5356884002685547, 1.0789484861106757e-07),
    CFrame.new(-5852.28759765625, -156.17877197265625, -36.87882995605469) * CFrame.Angles(7.424815207102142e-10, -1.5370142459869385, -6.748590664074072e-08),
    CFrame.new(-5851.58203125, -156.1330108642578, -36.91023254394531) * CFrame.Angles(1.6517304191054905e-09, -1.5336064100265503, -1.3406784660219273e-07),
    CFrame.new(-5851.017578125, -156.0957489013672, -36.94486618041992) * CFrame.Angles(3.684657023939053e-10, -1.5271729230880737, -2.8755900771670895e-08),
    CFrame.new(-5850.171875, -156.03463745117188, -37.00345230102539) * CFrame.Angles(-2.8406053065310743e-09, -1.5179646015167236, 1.3977499691009143e-07),
    CFrame.new(-5849.609375, -155.99041748046875, -37.05066680908203) * CFrame.Angles(-2.420885270026929e-09, -1.5102176666259766, 1.0051339671690585e-07),
    CFrame.new(-5848.765625, -155.92138671875, -37.13418960571289) * CFrame.Angles(2.084915573519197e-11, -1.4966356754302979, -2.0711441450771417e-08),
    CFrame.new(-5848.2041015625, -155.87457275390625, -37.196598052978516) * CFrame.Angles(1.5337363601375387e-09, -1.4873477220535278, -8.789525196561954e-08),
    CFrame.new(-5847.6435546875, -155.82708740234375, -37.26188278198242) * CFrame.Angles(2.6657740459512524e-09, -1.4786367416381836, -1.435347485312377e-07),
    CFrame.new(-5625.484375, -132.7161407470703, -186.77853393554688) * CFrame.Angles(9.439581338810399e-10, -1.466770887374878, -1.1730073801174967e-08),
    CFrame.new(-5624.54345703125, -132.43450927734375, -186.83221435546875) * CFrame.Angles(1.5161306654576379e-09, -1.4863474369049072, -2.413039013049456e-08),
    CFrame.new(-5623.46923828125, -132.09072875976562, -186.893310546875) * CFrame.Angles(-1.0215537443736267e-10, -1.501203179359436, 5.002460667924424e-09),
    CFrame.new(-5622.5, -131.85768127441406, -186.93817138671875) * CFrame.Angles(-1.9389783112444547e-09, -1.5122514963150024, 5.234322486558085e-08),
    CFrame.new(-5621.3828125, -131.6842041015625, -186.85531616210938) * CFrame.Angles(1.2696099727094179e-09, -1.582842469215393, 1.5857611401770555e-07),
    CFrame.new(-5620.46826171875, -131.43759155273438, -186.5828094482422) * CFrame.Angles(1.6909909916762444e-08, -1.7011629343032837, 1.931643680563866e-07),
    CFrame.new(5891.5634765625, 320.99798583984375, -18.78949737548828) * CFrame.Angles(5.4465242982359996e-08, -1.928057074546814, -1.406345440102541e-08),
    CFrame.new(5891.5634765625, 320.99798583984375, -18.78949737548828) * CFrame.Angles(5.4465242982359996e-08, -1.928057074546814, -1.406345440102541e-08),
    CFrame.new(5891.5634765625, 320.99798583984375, -18.78949737548828) * CFrame.Angles(-3.656801794704734e-08, -1.928057074546814, 9.442205239906798e-09),
    CFrame.new(5891.5634765625, 320.99798583984375, -18.78949737548828) * CFrame.Angles(-1.2736806809243717e-07, -1.928057074546814, 3.288764816034018e-08),
    CFrame.new(5891.5634765625, 320.99798583984375, -18.78949737548828) * CFrame.Angles(-3.8842323135668266e-08, -1.928057074546814, 1.0029464370120422e-08),
    CFrame.new(5891.5634765625, 320.99798583984375, -18.78949737548828) * CFrame.Angles(9.366276998434842e-08, -1.928057074546814, -2.418459388309202e-08),
    CFrame.new(5891.5634765625, 320.99798583984375, -18.78949737548828) * CFrame.Angles(8.9527274482748e-09, -1.928057074546814, -2.311685287637033e-09),
    CFrame.new(5893.08447265625, 320.99798583984375, -19.236204147338867) * CFrame.Angles(8.75626682272923e-09, -2.0051703453063965, 1.1224449281144189e-07),
    CFrame.new(7373.533203125, 325.3450012207031, 74.0564193725586) * CFrame.Angles(-2.5344532028626077e-10, -1.5310702323913574, -1.7542120644975512e-08),
    CFrame.new(7374.099609375, 324.33172607421875, 74.05099487304688) * CFrame.Angles(3.099218381930058e-10, -1.538954257965088, -9.158489433502837e-08),
    CFrame.new(7374.94921875, 322.4030456542969, 74.04402923583984) * CFrame.Angles(5.628970067839134e-10, -1.5476758480072021, -1.8922639810625697e-07),
    CFrame.new(7375.72802734375, 320.2041931152344, 74.04086303710938) * CFrame.Angles(1.1138181349457099e-10, -1.5542832612991333, -6.816083697458453e-08),
    CFrame.new(10974.453125, 549.1137084960938, 106.77307891845703) * CFrame.Angles(1.795494775080897e-08, -2.025233268737793, -3.361015243896759e-09),
    CFrame.new(10975.21484375, 549.1194458007812, 107.14590454101562) * CFrame.Angles(1.8029657766760465e-08, -2.0251173973083496, -3.6079974563563155e-09),
    CFrame.new(10975.849609375, 549.1251220703125, 107.45658874511719) * CFrame.Angles(1.762760604151481e-08, -2.0250537395477295, -3.759832001293262e-09),
    CFrame.new(10976.6748046875, 549.1334838867188, 107.8604965209961) * CFrame.Angles(1.684422556991194e-08, -2.0250024795532227, -3.928769309879954e-09),
    CFrame.new(10978.0078125, 549.1492309570312, 108.50983428955078) * CFrame.Angles(-6.036612631987737e-08, -2.0233874320983887, 5.048268469920458e-09)

}

routes = {
    {"CP0 → CP1", CP0to1}
}

local function getNearestRoute()
    local nearestIdx, dist = 1, math.huge
    if hrp then
        local pos = hrp.Position
        for i,data in ipairs(routes) do
            for _,cf in ipairs(data[2]) do
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

local function getNearestFrameIndex(frames)
    local startIdx, dist = 1, math.huge
    if hrp then
        local pos = hrp.Position
        for i,cf in ipairs(frames) do
            local d = (cf.Position - pos).Magnitude
            if d < dist then
                dist = d
                startIdx = i
            end
        end
    end
    if startIdx >= #frames then
        startIdx = math.max(1, #frames - 1)
    end
    return startIdx
end

local function lerpCF(fromCF, toCF)
    local duration = frameTime / math.max(0.05, playbackRate)
    local t = 0
    while t < duration do
        if not isRunning then break end
        local dt = task.wait()
        t += dt
        local alpha = math.min(t / duration, 1)
        if hrp and hrp.Parent and hrp:IsDescendantOf(workspace) then
            hrp.CFrame = fromCF:Lerp(toCF, alpha)
        end
    end
end

local function runRouteOnce()
    if #routes == 0 then return end
    if not hrp then refreshHRP() end
    isRunning = true
    local idx = getNearestRoute()
    print("▶ Start CP:", routes[idx][1])
    local frames = routes[idx][2]
    if #frames < 2 then isRunning = false return end
    local startIdx = getNearestFrameIndex(frames)
    for i = startIdx, #frames - 1 do
        if not isRunning then break end
        lerpCF(frames[i], frames[i+1])
    end
    isRunning = false
end

local function runAllRoutes()
    if #routes == 0 then return end
    if not hrp then refreshHRP() end
    isRunning = true
    local idx = getNearestRoute()
    print("⏩ Start To End dari:", routes[idx][1])
    for r = idx, #routes do
        if not isRunning then break end
        local frames = routes[r][2]
        if #frames < 2 then continue end
        
        local startIdx = getNearestFrameIndex(frames)
        for i = startIdx, #frames - 1 do
            if not isRunning then break end
            lerpCF(frames[i], frames[i+1])
        end
    end
    isRunning = false
end

local function stopRoute()
    if isRunning then
        print("⏹ Stop ditekan")
    end
    isRunning = false
end


local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WataXReplay"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.CoreGui

local frame = Instance.new("Frame",screenGui)
frame.Size = UDim2.new(0,280,0,180)
frame.Position = UDim2.new(0.5,-140,0.5,-90)
frame.BackgroundColor3 = Color3.fromRGB(35,35,40)
frame.Active = true
frame.Draggable = true
frame.BackgroundTransparency = 0.05
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel",frame)
title.Size = UDim2.new(1,0,0,32)
title.Text = "WataX Menu"
title.BackgroundColor3 = Color3.fromRGB(55,55,65)
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
Instance.new("UICorner", title).CornerRadius = UDim.new(0,12)

local startCP = Instance.new("TextButton",frame)
startCP.Size = UDim2.new(0.5,-7,0,42)
startCP.Position = UDim2.new(0,5,0,44)
startCP.Text = "Start CP"
startCP.BackgroundColor3 = Color3.fromRGB(60,200,80)
startCP.TextColor3 = Color3.fromRGB(255,255,255)
startCP.Font = Enum.Font.GothamBold
startCP.TextScaled = true
Instance.new("UICorner", startCP).CornerRadius = UDim.new(0,10)
startCP.MouseButton1Click:Connect(runRouteOnce)

local stopBtn = Instance.new("TextButton",frame)
stopBtn.Size = UDim2.new(0.5,-7,0,42)
stopBtn.Position = UDim2.new(0.5,2,0,44)
stopBtn.Text = "Stop"
stopBtn.BackgroundColor3 = Color3.fromRGB(220,70,70)
stopBtn.TextColor3 = Color3.fromRGB(255,255,255)
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextScaled = true
Instance.new("UICorner", stopBtn).CornerRadius = UDim.new(0,10)
stopBtn.MouseButton1Click:Connect(stopRoute)

local startAll = Instance.new("TextButton",frame)
startAll.Size = UDim2.new(1,-10,0,42)
startAll.Position = UDim2.new(0,5,0,96)
startAll.Text = "Start To End"
startAll.BackgroundColor3 = Color3.fromRGB(70,120,220)
startAll.TextColor3 = Color3.fromRGB(255,255,255)
startAll.Font = Enum.Font.GothamBold
startAll.TextScaled = true
Instance.new("UICorner", startAll).CornerRadius = UDim.new(0,10)
startAll.MouseButton1Click:Connect(runAllRoutes)


local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0,30,0,30)
closeBtn.Position = UDim2.new(0,0,0,0)
closeBtn.Text = "✖"
closeBtn.BackgroundColor3 = Color3.fromRGB(220,60,60)
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextScaled = true
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,8)
closeBtn.MouseButton1Click:Connect(function()
    if screenGui then screenGui:Destroy() end
end)


local miniBtn = Instance.new("TextButton", frame)
miniBtn.Size = UDim2.new(0,30,0,30)
miniBtn.Position = UDim2.new(1,-30,0,0)
miniBtn.Text = "—"
miniBtn.BackgroundColor3 = Color3.fromRGB(80,80,200)
miniBtn.TextColor3 = Color3.fromRGB(255,255,255)
miniBtn.Font = Enum.Font.GothamBold
miniBtn.TextScaled = true
Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(0,8)

local bubbleBtn = Instance.new("TextButton", screenGui)
bubbleBtn.Size = UDim2.new(0,80,0,46)
bubbleBtn.Position = UDim2.new(0,20,0.7,0)
bubbleBtn.Text = "WataX"
bubbleBtn.BackgroundColor3 = Color3.fromRGB(0,140,220)
bubbleBtn.TextColor3 = Color3.fromRGB(255,255,255)
bubbleBtn.Font = Enum.Font.GothamBold
bubbleBtn.TextScaled = true
bubbleBtn.Visible = false
bubbleBtn.Active = true
bubbleBtn.Draggable = true
Instance.new("UICorner", bubbleBtn).CornerRadius = UDim.new(0,14)

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
discordBtn.TextColor3 = Color3.fromRGB(255,255,255)
discordBtn.Font = Enum.Font.GothamBold
discordBtn.TextScaled = true
Instance.new("UICorner", discordBtn).CornerRadius = UDim.new(0,8)


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
speedDown.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", speedDown).CornerRadius = UDim.new(0,8)

local speedUp = Instance.new("TextButton", speedRow)
speedUp.Size = UDim2.new(0,40,1,0)
speedUp.Position = UDim2.new(0,110,0,0)
speedUp.Text = "+"
speedUp.BackgroundColor3 = Color3.fromRGB(60,60,100)
speedUp.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", speedUp).CornerRadius = UDim.new(0,8)

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
    end
end)

