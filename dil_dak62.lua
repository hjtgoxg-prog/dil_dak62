local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local function getParent()
    if gethui then
        return gethui()
    end
    return game:GetService("CoreGui")
end

local gui = Instance.new("ScreenGui")
gui.Name = "dil_dak62_hub"
gui.ResetOnSpawn = false
gui.Parent = getParent()

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(240, 130)
main.Position = UDim2.new(0.5, -120, 0.5, -65)
main.BackgroundColor3 = Color3.fromRGB(25,25,30)
main.BorderSizePixel = 0
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-50,0,40)
title.Position = UDim2.fromOffset(12,5)
title.BackgroundTransparency = 1
title.Text = "dil_dak62 hub"
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(35,35)
close.Position = UDim2.new(1,-40,0,5)
close.BackgroundTransparency = 1
close.Text = "×"
close.TextColor3 = Color3.fromRGB(255,70,70)
close.TextSize = 28
close.Parent = main

local espButton = Instance.new("TextButton")
espButton.Size = UDim2.new(1,-24,0,50)
espButton.Position = UDim2.fromOffset(12,65)
espButton.BackgroundColor3 = Color3.fromRGB(45,45,52)
espButton.Text = "ESP  •  OFF"
espButton.TextColor3 = Color3.new(1,1,1)
espButton.TextSize = 17
espButton.Font = Enum.Font.GothamBold
espButton.Parent = main

Instance.new("UICorner", espButton).CornerRadius = UDim.new(0,9)

-- Иконка
local icon = Instance.new("TextButton")
icon.Size = UDim2.fromOffset(55,55)
icon.Position = UDim2.new(0,20,0.5,-27)
icon.BackgroundColor3 = Color3.fromRGB(25,25,30)
icon.Text = "D"
icon.TextColor3 = Color3.new(1,1,1)
icon.TextSize = 24
icon.Font = Enum.Font.GothamBold
icon.Visible = false
icon.Parent = gui

Instance.new("UICorner", icon).CornerRadius = UDim.new(1,0)

-- ESP
local enabled = false
local esp = {}

local function removeESP(player)
    if esp[player] then
        esp[player]:Destroy()
        esp[player] = nil
    end
end

local function addESP(player)
    if player == LocalPlayer or not enabled then
        return
    end

    removeESP(player)

    local character = player.Character
    if not character then
        return
    end

    local highlight = Instance.new("Highlight")
    highlight.Name = "dil_dak62_ESP"
    highlight.Adornee = character
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillColor = Color3.fromRGB(255,0,0)
    highlight.OutlineColor = Color3.new(1,1,1)
    highlight.FillTransparency = 0.45
    highlight.Parent = character

    esp[player] = highlight
end

local function refresh()
    for _,player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if enabled then
                addESP(player)
            else
                removeESP(player)
            end
        end
    end
end

espButton.MouseButton1Click:Connect(function()
    enabled = not enabled

    if enabled then
        espButton.Text = "ESP  •  ON"
        espButton.BackgroundColor3 = Color3.fromRGB(35,145,75)
    else
        espButton.Text = "ESP  •  OFF"
        espButton.BackgroundColor3 = Color3.fromRGB(45,45,52)
    end

    refresh()
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        addESP(player)
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

-- Закрыть / открыть
close.MouseButton1Click:Connect(function()
    main.Visible = false
    icon.Visible = true
end)

icon.MouseButton1Click:Connect(function()
    icon.Visible = false
    main.Visible = true
end)
