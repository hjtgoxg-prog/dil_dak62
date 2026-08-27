local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local LP = Players.LocalPlayer

--========================
-- KEY SYSTEM
--========================

local KEY_URL =
    "https://raw.githubusercontent.com/hjtgoxg-prog/dil_dak62/main/keys.txt"

local function checkKey(key)
    local ok, data = pcall(function()
        return game:HttpGet(KEY_URL)
    end)

    if not ok then
        return false
    end

    for line in string.gmatch(data, "[^\r\n]+") do
        if key == line:gsub("%s+", "") then
            return true
        end
    end

    return false
end

--========================
-- GUI
--========================

local Parent = gethui and gethui() or game:GetService("CoreGui")

local old = Parent:FindFirstChild("dil_dak62_hub")
if old then
    old:Destroy()
end

local Gui = Instance.new("ScreenGui")
Gui.Name = "dil_dak62_hub"
Gui.ResetOnSpawn = false
Gui.Parent = Parent

-- KEY WINDOW

local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.fromOffset(270,160)
KeyFrame.Position = UDim2.new(.5,-135,.5,-80)
KeyFrame.BackgroundColor3 = Color3.fromRGB(25,25,30)
KeyFrame.BorderSizePixel = 0
KeyFrame.Parent = Gui

Instance.new("UICorner",KeyFrame).CornerRadius = UDim.new(0,12)

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1,0,0,40)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "dil_dak62 key system"
KeyTitle.TextColor3 = Color3.new(1,1,1)
KeyTitle.TextSize = 19
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.Parent = KeyFrame

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(1,-30,0,40)
KeyBox.Position = UDim2.fromOffset(15,50)
KeyBox.PlaceholderText = "Enter key..."
KeyBox.Text = ""
KeyBox.TextSize = 16
KeyBox.BackgroundColor3 = Color3.fromRGB(45,45,52)
KeyBox.TextColor3 = Color3.new(1,1,1)
KeyBox.Parent = KeyFrame

Instance.new("UICorner",KeyBox).CornerRadius = UDim.new(0,8)

local KeyButton = Instance.new("TextButton")
KeyButton.Size = UDim2.new(1,-30,0,40)
KeyButton.Position = UDim2.fromOffset(15,105)
KeyButton.Text = "CHECK KEY"
KeyButton.TextSize = 16
KeyButton.Font = Enum.Font.GothamBold
KeyButton.TextColor3 = Color3.new(1,1,1)
KeyButton.BackgroundColor3 = Color3.fromRGB(45,130,70)
KeyButton.Parent = KeyFrame

Instance.new("UICorner",KeyButton).CornerRadius = UDim.new(0,8)

--========================
-- MAIN HUB
--========================

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(280,250)
Main.Position = UDim2.new(.5,-140,.5,-125)
Main.BackgroundColor3 = Color3.fromRGB(22,22,28)
Main.BorderSizePixel = 0
Main.Visible = false
Main.Active = true
Main.Parent = Gui

Instance.new("UICorner",Main).CornerRadius = UDim.new(0,13)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,-50,0,45)
Title.Position = UDim2.fromOffset(12,3)
Title.BackgroundTransparency = 1
Title.Text = "dil_dak62 hub"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextSize = 21
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(40,40)
Close.Position = UDim2.new(1,-45,0,3)
Close.BackgroundTransparency = 1
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(255,70,70)
Close.TextSize = 28
Close.Parent = Main

local function makeButton(text,y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,-24,0,45)
    b.Position = UDim2.fromOffset(12,y)
    b.BackgroundColor3 = Color3.fromRGB(45,45,53)
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = Color3.new(1,1,1)
    b.TextSize = 16
    b.Font = Enum.Font.GothamBold
    b.Parent = Main
    Instance.new("UICorner",b).CornerRadius = UDim.new(0,9)
    return b
end

local ESPButton = makeButton("ESP  •  OFF",55)
local AimButton = makeButton("AIM  •  OFF",108)
local FOVButton = makeButton("FOV  •  120",161)

--========================
-- ICON
--========================

local Icon = Instance.new("TextButton")
Icon.Size = UDim2.fromOffset(58,58)
Icon.Position = UDim2.new(0,20,.5,-29)
Icon.BackgroundColor3 = Color3.fromRGB(22,22,28)
Icon.Text = "D"
Icon.TextColor3 = Color3.new(1,1,1)
Icon.TextSize = 25
Icon.Font = Enum.Font.GothamBold
Icon.Visible = false
Icon.Parent = Gui

Instance.new("UICorner",Icon).CornerRadius = UDim.new(1,0)

--========================
-- ESP
--========================

local ESPEnabled = false
local ESPObjects = {}

local function removeESP(player)
    if ESPObjects[player] then
        ESPObjects[player]:Destroy()
        ESPObjects[player] = nil
    end
end

local function addESP(player)
    if player == LP or not ESPEnabled then
        return
    end

    local char = player.Character
    if not char then
        return
    end

    removeESP(player)

    local h = Instance.new("Highlight")
    h.Name = "dil_dak62_ESP"
    h.Adornee = char
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

    if player.Team == LP.Team then
        h.FillColor = Color3.fromRGB(40,100,255)
    else
        h.FillColor = Color3.fromRGB(255,50,50)
    end

    h.OutlineColor = Color3.new(1,1,1)
    h.FillTransparency = .45
    h.Parent = char

    ESPObjects[player] = h
end

local function refreshESP()
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LP then
            if ESPEnabled then
                addESP(p)
            else
                removeESP(p)
            end
        end
    end
end

--========================
-- FOV
--========================

local FOVRadius = 120

local FOV = Instance.new("Frame")
FOV.Size = UDim2.fromOffset(FOVRadius*2,FOVRadius*2)
FOV.AnchorPoint = Vector2.new(.5,.5)
FOV.Position = UDim2.fromScale(.5,.5)
FOV.BackgroundTransparency = 1
FOV.Visible = false
FOV.Parent = Gui

local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 2
Stroke.Color = Color3.new(1,1,1)
Stroke.Parent = FOV

Instance.new("UICorner",FOV).CornerRadius = UDim.new(1,0)

--========================
-- AIM TARGET
--========================

local AimEnabled = false
local CurrentTarget = nil

local function getEnemyTarget()

    local best = nil
    local bestDistance = FOVRadius

    local center = Camera.ViewportSize / 2

    for _,p in ipairs(Players:GetPlayers()) do

        if p ~= LP and p.Team ~= LP.Team then

            local char = p.Character
            local head = char and char:FindFirstChild("Head")

            if head then

                local pos, visible =
                    Camera:WorldToViewportPoint(head.Position)

                if visible then

                    local distance =
                        (Vector2.new(pos.X,pos.Y)-center).Magnitude

                    if distance < bestDistance then
                        bestDistance = distance
                        best = p
                    end
                end
            end
        end
    end

    return best
end

RunService.RenderStepped:Connect(function()

    FOV.Position = UDim2.fromScale(.5,.5)

    if AimEnabled then
        CurrentTarget = getEnemyTarget()
    else
        CurrentTarget = nil
    end

end)

--========================
-- BUTTONS
--========================

ESPButton.MouseButton1Click:Connect(function()

    ESPEnabled = not ESPEnabled

    ESPButton.Text =
        ESPEnabled and "ESP  •  ON" or "ESP  •  OFF"

    refreshESP()

end)

AimButton.MouseButton1Click:Connect(function()

    AimEnabled = not AimEnabled

    AimButton.Text =
        AimEnabled and "AIM  •  ON" or "AIM  •  OFF"

    FOV.Visible = AimEnabled

end)

FOVButton.MouseButton1Click:Connect(function()

    if FOVRadius == 120 then
        FOVRadius = 180
    elseif FOVRadius == 180 then
        FOVRadius = 250
    else
        FOVRadius = 120
    end

    FOV.Size =
        UDim2.fromOffset(FOVRadius*2,FOVRadius*2)

    FOVButton.Text =
        "FOV  •  "..FOVRadius

end)

--========================
-- TEAM UPDATE
--========================

for _,p in ipairs(Players:GetPlayers()) do
    if p ~= LP then
        p:GetPropertyChangedSignal("Team"):Connect(function()
            if ESPEnabled then
                addESP(p)
            end
        end)
    end
end

Players.PlayerAdded:Connect(function(p)

    p:GetPropertyChangedSignal("Team"):Connect(function()
        if ESPEnabled then
            addESP(p)
        end
    end)

    p.CharacterAdded:Connect(function()
        task.wait(.5)
        if ESPEnabled then
            addESP(p)
        end
    end)

end)

Players.PlayerRemoving:Connect(removeESP)

--========================
-- CLOSE / OPEN
--========================

Close.MouseButton1Click:Connect(function()
    Main.Visible = false
    FOV.Visible = false
    Icon.Visible = true
end)

Icon.MouseButton1Click:Connect(function()
    Icon.Visible = false
    Main.Visible = true
    FOV.Visible = AimEnabled
end)

--========================
-- KEY CHECK
--========================

KeyButton.MouseButton1Click:Connect(function()

    KeyButton.Text = "CHECKING..."

    if checkKey(KeyBox.Text) then

        KeyFrame.Visible = false
        Main.Visible = true

    else

        KeyButton.Text = "INVALID KEY"

        task.wait(1)

        KeyButton.Text = "CHECK KEY"

    end

end)
