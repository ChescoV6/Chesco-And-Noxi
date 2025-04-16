-- Chesco & Noxi v4.6
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Camera = workspace.CurrentCamera
local Lighting = game:GetService("Lighting")

local function debugPrint(message)
    print("[Chesco & Noxi_CheatUI] " .. message)
end

local function saveConfig(settings)
    local success, err = pcall(function()
        writefile("Chesco & Noxi_Cheat_Config.json", HttpService:JSONEncode(settings))
    end)
    if not success then debugPrint("Failed to save config: " .. err) end
end

local function loadConfig()
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile("Chesco & Noxi_Cheat_Config.json"))
    end)
    if success then return data else debugPrint("Failed to load config: " .. tostring(data)) return nil end
end

-- UI Setup
local UI = Instance.new("ScreenGui")
UI.Name = "Chesco & Noxi_CheatUI_" .. tostring(math.random(1000, 9999))
UI.IgnoreGuiInset = true
UI.ResetOnSpawn = false
local parentSuccess, parentErr = pcall(function()
    UI.Parent = game.CoreGui
end)
if not parentSuccess then
    debugPrint("CoreGui parenting failed: " .. parentErr .. ". Falling back to PlayerGui.")
    UI.Parent = LocalPlayer.PlayerGui
end

local WelcomeFrame = Instance.new("Frame", UI)
WelcomeFrame.Size = UDim2.new(0, 250, 0, 120)
WelcomeFrame.Position = UDim2.new(0.5, -125, 0.5, -60)
WelcomeFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
WelcomeFrame.BackgroundTransparency = 0.1
WelcomeFrame.Visible = true

local WelcomeCorner = Instance.new("UICorner", WelcomeFrame)
WelcomeCorner.CornerRadius = UDim.new(0, 15)

local WelcomeLabel = Instance.new("TextLabel", WelcomeFrame)
WelcomeLabel.Size = UDim2.new(1, 0, 0, 40)
WelcomeLabel.Position = UDim2.new(0, 0, 0, 20)
WelcomeLabel.BackgroundTransparency = 1
WelcomeLabel.Text = "Welcome, " .. LocalPlayer.Name .. "!"
WelcomeLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
WelcomeLabel.TextSize = 20
WelcomeLabel.Font = Enum.Font.GothamBold

local OpenButton = Instance.new("TextButton", WelcomeFrame)
OpenButton.Size = UDim2.new(0, 80, 0, 30)
OpenButton.Position = UDim2.new(0.5, -40, 0.6, 0)
OpenButton.BackgroundColor3 = Color3.fromRGB(0, 200, 200)
OpenButton.Text = "Open Cheat"
OpenButton.TextColor3 = Color3.fromRGB(20, 20, 30)
OpenButton.TextSize = 14
OpenButton.Font = Enum.Font.GothamBold
local OpenCorner = Instance.new("UICorner", OpenButton)
OpenCorner.CornerRadius = UDim.new(0, 10)

local MainFrame = Instance.new("Frame", UI)
MainFrame.Size = UDim2.new(0, 450, 0, 350)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BackgroundTransparency = 0.1
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 15)

local GlowEffect = Instance.new("UIStroke", MainFrame)
GlowEffect.Thickness = 2
GlowEffect.Color = Color3.fromRGB(0, 255, 255)
GlowEffect.Transparency = 0.5
GlowEffect.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local Gradient = Instance.new("UIGradient", MainFrame)
Gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 60))
}
Gradient.Rotation = 45

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, -60, 0, 25)
Title.Position = UDim2.new(0, 10, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "Chesco & Noxi - v4.6"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseButton = Instance.new("TextButton", MainFrame)
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(40, 60, 90)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(200, 210, 220)
CloseButton.TextSize = 14
CloseButton.Font = Enum.Font.GothamBold
local CloseCorner = Instance.new("UICorner", CloseButton)
CloseCorner.CornerRadius = UDim.new(0, 5)

local TabFrame = Instance.new("Frame", MainFrame)
TabFrame.Size = UDim2.new(1, -10, 0, 30)
TabFrame.Position = UDim2.new(0, 5, 0, 35)
TabFrame.BackgroundColor3 = Color3.fromRGB(40, 60, 90)
local TabCorner = Instance.new("UICorner", TabFrame)
TabCorner.CornerRadius = UDim.new(0, 8)

local Tabs = {"Aimbot", "ESP", "Rage", "Visuals", "Misc", "Config"}
local TabContainers = {}
local ActiveTab = nil

for i, tabName in ipairs(Tabs) do
    local TabButton = Instance.new("TextButton", TabFrame)
    TabButton.Size = UDim2.new(1/#Tabs, 0, 1, 0)
    TabButton.Position = UDim2.new((i-1)/#Tabs, 0, 0, 0)
    TabButton.BackgroundTransparency = 0.5
    TabButton.BackgroundColor3 = Color3.fromRGB(50, 70, 100)
    TabButton.Text = tabName
    TabButton.TextColor3 = Color3.fromRGB(160, 170, 190)
    TabButton.TextSize = 14
    TabButton.Font = Enum.Font.GothamMedium
    local ButtonCorner = Instance.new("UICorner", TabButton)
    ButtonCorner.CornerRadius = UDim.new(0, 5)

    local TabContainer = Instance.new("Frame", MainFrame)
    TabContainer.Size = UDim2.new(1, -20, 1, -80)
    TabContainer.Position = UDim2.new(0, 10, 0, 70)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Visible = false
    TabContainers[tabName] = TabContainer

    TabButton.MouseButton1Click:Connect(function()
        if ActiveTab == TabContainer then return end
        if ActiveTab then
            ActiveTab.Visible = false
            for _, child in pairs(TabFrame:GetChildren()) do
                if child:IsA("TextButton") and child.Text ~= tabName then
                    child.BackgroundTransparency = 0.5
                    child.TextColor3 = Color3.fromRGB(160, 170, 190)
                end
            end
        end
        ActiveTab = TabContainer
        ActiveTab.Visible = true
        TabButton.BackgroundTransparency = 0
        TabButton.TextColor3 = Color3.fromRGB(0, 255, 255)
    end)
end

local StatusLabel = Instance.new("TextLabel", MainFrame)
StatusLabel.Size = UDim2.new(0.5, -20, 0, 20)
StatusLabel.Position = UDim2.new(0, 10, 1, -30)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Inactive"
StatusLabel.TextColor3 = Color3.fromRGB(150, 160, 180)
StatusLabel.TextSize = 12
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

local FPSLabel = Instance.new("TextLabel", MainFrame)
FPSLabel.Size = UDim2.new(0.5, -20, 0, 20)
FPSLabel.Position = UDim2.new(0.5, 10, 1, -30)
FPSLabel.BackgroundTransparency = 1
FPSLabel.Text = "FPS: 0"
FPSLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
FPSLabel.TextSize = 12
FPSLabel.Font = Enum.Font.Gotham
FPSLabel.TextXAlignment = Enum.TextXAlignment.Right

-- Settings
local AimbotSettings = {Enabled = false, SilentAim = false, AimLock = false, Smoothing = 1, FOV = 100, TriggerKey = Enum.UserInputType.MouseButton2}
local ESPSettings = {Enabled = false, Names = true, Health = true, Distance = true, Chams = false, MaxDistance = 1000, TextColor = Color3.fromRGB(0, 255, 255), ChamsColor = Color3.fromRGB(0, 255, 0), Rainbow = false}
local RageSettings = {KillAura = false, KillAuraRange = 10, SpeedHack = false, SpeedMultiplier = 1, Noclip = false, RageMode = false, FlyHack = false, FlySpeed = 50}
local VisualSettings = {Crosshair = false, FOVCircle = false, FOVCircleRadius = 100, FOVCircleColor = Color3.fromRGB(0, 255, 255), Fullbright = false}
local MiscSettings = {SpinBot = false, AntiAim = false, KillSound = false, Notifications = true}

local ConfigSettings = {Aimbot = AimbotSettings, ESP = ESPSettings, Rage = RageSettings, Visuals = VisualSettings, Misc = MiscSettings}

local loadedConfig = loadConfig()
if loadedConfig then
    for key, settings in pairs(loadedConfig) do
        if ConfigSettings[key] then
            for setting, value in pairs(settings) do
                ConfigSettings[key][setting] = value
            end
        end
    end
    debugPrint("Config loaded successfully")
end

CloseButton.MouseButton1Click:Connect(function()
    UI:Destroy()
    debugPrint("GUI closed")
end)

OpenButton.MouseButton1Click:Connect(function()
    WelcomeFrame.Visible = false
    MainFrame.Visible = true
end)

local function showNotification(message, color)
    if not MiscSettings.Notifications then return end
    local NotifFrame = Instance.new("Frame", UI)
    NotifFrame.Size = UDim2.new(0, 150, 0, 40)
    NotifFrame.Position = UDim2.new(1, -170, 1, -50)
    NotifFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    NotifFrame.BackgroundTransparency = 0.2
    local NotifCorner = Instance.new("UICorner", NotifFrame)
    NotifCorner.CornerRadius = UDim.new(0, 8)
    local NotifLabel = Instance.new("TextLabel", NotifFrame)
    NotifLabel.Size = UDim2.new(1, 0, 1, 0)
    NotifLabel.BackgroundTransparency = 1
    NotifLabel.Text = message
    NotifLabel.TextColor3 = color or Color3.fromRGB(0, 255, 255)
    NotifLabel.TextSize = 12
    NotifLabel.Font = Enum.Font.Gotham
    wait(2)
    NotifFrame:Destroy()
end

local function createToggle(label, setting, callback, parent, yPos)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -20, 0, 25)
    Frame.Position = UDim2.new(0, 10, 0, yPos)
    Frame.BackgroundTransparency = 1

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = label
    Label.TextColor3 = Color3.fromRGB(200, 210, 220)
    Label.TextSize = 12
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local ToggleButton = Instance.new("TextButton", Frame)
    ToggleButton.Size = UDim2.new(0.15, 0, 0.7, 0)
    ToggleButton.Position = UDim2.new(0.85, 0, 0.15, 0)
    ToggleButton.BackgroundColor3 = setting and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(40, 60, 90)
    ToggleButton.Text = ""
    local Corner = Instance.new("UICorner", ToggleButton)
    Corner.CornerRadius = UDim.new(0, 5)

    ToggleButton.MouseButton1Click:Connect(function()
        setting = not setting
        callback(setting)
        ToggleButton.BackgroundColor3 = setting and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(40, 60, 90)
        StatusLabel.Text = "Status: " .. (setting and "Active" or "Inactive")
        showNotification(label .. " " .. (setting and "Enabled" or "Disabled"), setting and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
    end)
end

local function createSlider(label, min, max, current, callback, parent, yPos)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -20, 0, 40)
    Frame.Position = UDim2.new(0, 10, 0, yPos)
    Frame.BackgroundTransparency = 1

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, 0, 0, 15)
    Label.BackgroundTransparency = 1
    Label.Text = label .. ": " .. current
    Label.TextColor3 = Color3.fromRGB(200, 210, 220)
    Label.TextSize = 12
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Slider = Instance.new("TextButton", Frame)
    Slider.Size = UDim2.new(1, 0, 0, 5)
    Slider.Position = UDim2.new(0, 0, 0, 20)
    Slider.BackgroundColor3 = Color3.fromRGB(40, 60, 90)
    Slider.Text = ""
    local SliderCorner = Instance.new("UICorner", Slider)
    SliderCorner.CornerRadius = UDim.new(0, 3)

    local SliderFill = Instance.new("Frame", Slider)
    SliderFill.Size = UDim2.new((current - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    SliderFill.BorderSizePixel = 0
    local FillCorner = Instance.new("UICorner", SliderFill)
    FillCorner.CornerRadius = UDim.new(0, 3)

    local isDragging = false
    Slider.MouseButton1Down:Connect(function()
        isDragging = true
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouseX = UserInputService:GetMouseLocation().X
            local sliderX = Slider.AbsolutePosition.X
            local sliderWidth = Slider.AbsoluteSize.X
            local fraction = math.clamp((mouseX - sliderX) / sliderWidth, 0, 1)
            local value = math.floor(min + (max - min) * fraction)
            SliderFill.Size = UDim2.new(fraction, 0, 1, 0)
            Label.Text = label .. ": " .. value
            callback(value)
            showNotification(label .. " set to " .. value, Color3.fromRGB(0, 255, 255))
        end
    end)
end

createToggle("Aimbot", AimbotSettings.Enabled, function(value) AimbotSettings.Enabled = value end, TabContainers["Aimbot"], 0)
createToggle("Silent Aim", AimbotSettings.SilentAim, function(value) AimbotSettings.SilentAim = value end, TabContainers["Aimbot"], 30)
createToggle("Aim Lock", AimbotSettings.AimLock, function(value) AimbotSettings.AimLock = value end, TabContainers["Aimbot"], 60)
createSlider("Smoothing", 1, 10, AimbotSettings.Smoothing, function(value) AimbotSettings.Smoothing = value end, TabContainers["Aimbot"], 90)
createSlider("FOV", 10, 300, AimbotSettings.FOV, function(value) AimbotSettings.FOV = value end, TabContainers["Aimbot"], 135)

createToggle("ESP Enabled", ESPSettings.Enabled, function(value) ESPSettings.Enabled = value end, TabContainers["ESP"], 0)
createToggle("Names", ESPSettings.Names, function(value) ESPSettings.Names = value end, TabContainers["ESP"], 30)
createToggle("Health", ESPSettings.Health, function(value) ESPSettings.Health = value end, TabContainers["ESP"], 60)
createToggle("Distance", ESPSettings.Distance, function(value) ESPSettings.Distance = value end, TabContainers["ESP"], 90)
createToggle("Chams", ESPSettings.Chams, function(value) ESPSettings.Chams = value end, TabContainers["ESP"], 120)
createToggle("Rainbow", ESPSettings.Rainbow, function(value) ESPSettings.Rainbow = value end, TabContainers["ESP"], 150)

createToggle("Kill Aura", RageSettings.KillAura, function(value) RageSettings.KillAura = value end, TabContainers["Rage"], 0)
createSlider("Kill Aura Range", 5, 50, RageSettings.KillAuraRange, function(value) RageSettings.KillAuraRange = value end, TabContainers["Rage"], 30)
createToggle("Speed Hack", RageSettings.SpeedHack, function(value) RageSettings.SpeedHack = value end, TabContainers["Rage"], 75)
createSlider("Speed Multiplier", 1, 5, RageSettings.SpeedMultiplier, function(value) RageSettings.SpeedMultiplier = value end, TabContainers["Rage"], 105)
createToggle("Noclip", RageSettings.Noclip, function(value) RageSettings.Noclip = value end, TabContainers["Rage"], 150)
createToggle("Rage Mode", RageSettings.RageMode, function(value) RageSettings.RageMode = value end, TabContainers["Rage"], 180)
createToggle("Fly Hack", RageSettings.FlyHack, function(value) RageSettings.FlyHack = value end, TabContainers["Rage"], 210)
createSlider("Fly Speed", 10, 100, RageSettings.FlySpeed, function(value) RageSettings.FlySpeed = value end, TabContainers["Rage"], 240)

createToggle("Crosshair", VisualSettings.Crosshair, function(value) VisualSettings.Crosshair = value end, TabContainers["Visuals"], 0)
createToggle("FOV Circle", VisualSettings.FOVCircle, function(value) VisualSettings.FOVCircle = value end, TabContainers["Visuals"], 30)
createSlider("FOV Circle Radius", 50, 200, VisualSettings.FOVCircleRadius, function(value) VisualSettings.FOVCircleRadius = value end, TabContainers["Visuals"], 60)
createToggle("Fullbright", VisualSettings.Fullbright, function(value) VisualSettings.Fullbright = value end, TabContainers["Visuals"], 105)

createToggle("Spin Bot", MiscSettings.SpinBot, function(value) MiscSettings.SpinBot = value end, TabContainers["Misc"], 0)
createToggle("Anti-Aim", MiscSettings.AntiAim, function(value) MiscSettings.AntiAim = value end, TabContainers["Misc"], 30)
createToggle("Kill Sound", MiscSettings.KillSound, function(value) MiscSettings.KillSound = value end, TabContainers["Misc"], 60)
createToggle("Notifications", MiscSettings.Notifications, function(value) MiscSettings.Notifications = value end, TabContainers["Misc"], 90)

local SaveButton = Instance.new("TextButton", TabContainers["Config"])
SaveButton.Size = UDim2.new(1, -40, 0, 25)
SaveButton.Position = UDim2.new(0, 20, 0, 10)
SaveButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
SaveButton.Text = "Save Config"
SaveButton.TextColor3 = Color3.fromRGB(20, 20, 30)
SaveButton.TextSize = 12
SaveButton.Font = Enum.Font.GothamBold
local SaveCorner = Instance.new("UICorner", SaveButton)
SaveCorner.CornerRadius = UDim.new(0, 5)

local LoadButton = Instance.new("TextButton", TabContainers["Config"])
LoadButton.Size = UDim2.new(1, -40, 0, 25)
LoadButton.Position = UDim2.new(0, 20, 0, 40)
LoadButton.BackgroundColor3 = Color3.fromRGB(0, 200, 200)
LoadButton.Text = "Load Config"
LoadButton.TextColor3 = Color3.fromRGB(20, 20, 30)
LoadButton.TextSize = 12
LoadButton.Font = Enum.Font.GothamBold
local LoadCorner = Instance.new("UICorner", LoadButton)
LoadCorner.CornerRadius = UDim.new(0, 5)

SaveButton.MouseButton1Click:Connect(function()
    saveConfig({Aimbot = AimbotSettings, ESP = ESPSettings, Rage = RageSettings, Visuals = VisualSettings, Misc = MiscSettings})
    showNotification("Config Saved!", Color3.fromRGB(0, 255, 0))
end)

LoadButton.MouseButton1Click:Connect(function()
    local loaded = loadConfig()
    if loaded then
        for key, settings in pairs(loaded) do
            if ConfigSettings[key] then
                for setting, value in pairs(settings) do
                    ConfigSettings[key][setting] = value
                end
            end
        end
        showNotification("Config Loaded!", Color3.fromRGB(0, 255, 0))
    else
        showNotification("Failed to Load Config", Color3.fromRGB(255, 0, 0))
    end
end)

local lastFrame = tick()
local Target = nil
local IsAiming = false
local ESPInstances = {}
local Hue = 0
local isFlying = false

local CrosshairH = Drawing.new("Line")
CrosshairH.Thickness = 1
CrosshairH.Color = Color3.fromRGB(0, 255, 255)

local CrosshairV = Drawing.new("Line")
CrosshairV.Thickness = 1
CrosshairV.Color = Color3.fromRGB(0, 255, 255)

local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Color = VisualSettings.FOVCircleColor
FOVCircle.NumSides = 64

local function GetClosestPlayer()
    local ClosestPlayer = nil
    local ClosestDistance = AimbotSettings.FOV
    local MousePos = UserInputService:GetMouseLocation()

    for _, Player in pairs(Players:GetPlayers()) do
        if Player == LocalPlayer or not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") or not Player.Character:FindFirstChild("Humanoid") or Player.Character.Humanoid.Health <= 0 then continue end

        local AimPart = Player.Character.HumanoidRootPart
        local ScreenPos, OnScreen = Camera:WorldToViewportPoint(AimPart.Position)
        local Distance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - MousePos).Magnitude

        if OnScreen and Distance < ClosestDistance then
            ClosestDistance = Distance
            ClosestPlayer = Player
        end
    end
    return ClosestPlayer
end

local function CreateESP(Player)
    if Player == LocalPlayer then return end
    local success, _ = pcall(function()
        local Character = Player.Character or Player.CharacterAdded:Wait()
        local RootPart = Character:WaitForChild("HumanoidRootPart", 5)
        local Humanoid = Character:WaitForChild("Humanoid", 5)

        local Billboard = Instance.new("BillboardGui")
        Billboard.Size = UDim2.new(5, 0, 5, 0)
        Billboard.Adornee = RootPart
        Billboard.StudsOffset = Vector3.new(0, 3, 0)
        Billboard.Parent = UI

        local Frame = Instance.new("Frame", Billboard)
        Frame.Size = UDim2.new(1, 0, 1, 0)
        Frame.BackgroundTransparency = 1

        local NameLabel = Instance.new("TextLabel", Frame)
        NameLabel.Size = UDim2.new(1, 0, 0.2, 0)
        NameLabel.Position = UDim2.new(0, 0, -0.3, 0)
        NameLabel.BackgroundTransparency = 1
        NameLabel.TextColor3 = ESPSettings.TextColor
        NameLabel.TextSize = 12

        local HealthLabel = Instance.new("TextLabel", Frame)
        HealthLabel.Size = UDim2.new(1, 0, 0.2, 0)
        HealthLabel.Position = UDim2.new(0, 0, -0.1, 0)
        HealthLabel.BackgroundTransparency = 1
        HealthLabel.TextColor3 = ESPSettings.TextColor
        HealthLabel.TextSize = 12

        local DistanceLabel = Instance.new("TextLabel", Frame)
        DistanceLabel.Size = UDim2.new(1, 0, 0, 0)
        DistanceLabel.Position = UDim2.new(0, 0, 0.1, 0)
        DistanceLabel.BackgroundTransparency = 1
        DistanceLabel.TextColor3 = ESPSettings.TextColor
        DistanceLabel.TextSize = 12

        local Chams = Instance.new("Highlight")
        Chams.FillColor = ESPSettings.ChamsColor
        Chams.OutlineColor = ESPSettings.TextColor
        Chams.Adornee = Character
        Chams.Parent = Character

        ESPInstances[Player] = {Gui = Billboard, Name = NameLabel, Health = HealthLabel, Distance = DistanceLabel, Chams = Chams}

        Player.CharacterAdded:Connect(function(NewChar)
            Character = NewChar
            RootPart = NewChar:WaitForChild("HumanoidRootPart", 5)
            Humanoid = NewChar:WaitForChild("Humanoid", 5)
            Billboard.Adornee = RootPart
            Chams.Adornee = NewChar
        end)

        Humanoid.Died:Connect(function()
            if MiscSettings.KillSound then
                local Sound = Instance.new("Sound", UI)
                Sound.SoundId = "rbxassetid://9120386436"
                Sound:Play()
                Sound.Ended:Connect(function()
                    Sound:Destroy()
                end)
            end
        end)
    end)
    if not success then debugPrint("Failed to create ESP for " .. Player.Name) end
end

for _, Player in pairs(Players:GetPlayers()) do
    CreateESP(Player)
end
Players.PlayerAdded:Connect(CreateESP)

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == AimbotSettings.TriggerKey then
        IsAiming = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == AimbotSettings.TriggerKey then
        IsAiming = false
        if not AimbotSettings.AimLock then
            Target = nil
        end
    end
end)

RunService.RenderStepped:Connect(function()
    local current = tick()
    FPSLabel.Text = "FPS: " .. math.floor(1 / (current - lastFrame))
    lastFrame = current

    if ESPSettings.Rainbow then
        Hue = (Hue + 0.05) % 1
        ESPSettings.TextColor = Color3.fromHSV(Hue, 1, 1)
        ESPSettings.ChamsColor = Color3.fromHSV(Hue, 1, 1)
        VisualSettings.FOVCircleColor = Color3.fromHSV(Hue, 1, 1)
    end

    if AimbotSettings.Enabled then
        if not Target or not Target.Character or not Target.Character:FindFirstChild("HumanoidRootPart") then
            Target = GetClosestPlayer()
        end

        if Target then
            local AimPart = Target.Character.HumanoidRootPart
            local TargetPos = AimPart.Position

            if RageSettings.RageMode then
                AimbotSettings.SilentAim = true
                ESPSettings.Enabled = true
                ESPSettings.Names = true
                ESPSettings.Health = true
                ESPSettings.Chams = true
            end

            local ScreenPos, OnScreen = Camera:WorldToViewportPoint(TargetPos)
            if OnScreen then
                local MousePos = UserInputService:GetMouseLocation()
                local TargetScreenPos = Vector2.new(ScreenPos.X, ScreenPos.Y)
                local DeltaX = (TargetScreenPos.X - MousePos.X) / AimbotSettings.Smoothing
                local DeltaY = (TargetScreenPos.Y - MousePos.Y) / AimbotSettings.Smoothing

                if AimbotSettings.SilentAim then
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool") then
                        local Tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                        if Tool and Tool:FindFirstChild("Fire") then
                            Tool.Fire:FireServer(TargetPos)
                        end
                    end
                elseif IsAiming then
                    local success, _ = pcall(function()
                        mousemoverel(DeltaX, DeltaY)
                    end)
                    if not success then
                        Camera.CFrame = CFrame.new(Camera.CFrame.Position, TargetPos)
                    end
                end
            end
        end
    else
        Target = nil
    end

    for Player, ESP in pairs(ESPInstances) do
        if not ESPSettings.Enabled or not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") or not Player.Character:FindFirstChild("Humanoid") or Player.Character.Humanoid.Health <= 0 then
            ESP.Gui.Enabled = false
            ESP.Chams.Enabled = false
            continue
        end

        local RootPart = Player.Character.HumanoidRootPart
        local Humanoid = Player.Character.Humanoid
        local Distance = (LocalPlayer.Character and LocalPlayer.Character.HumanoidRootPart) and (RootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude or math.huge

        if Distance <= ESPSettings.MaxDistance then
            ESP.Gui.Enabled = true
            ESP.Name.TextColor3 = ESPSettings.TextColor
            ESP.Health.TextColor3 = ESPSettings.TextColor
            ESP.Distance.TextColor3 = ESPSettings.TextColor
            ESP.Chams.FillColor = ESPSettings.ChamsColor
            ESP.Chams.OutlineColor = ESPSettings.TextColor

            ESP.Name.Text = ESPSettings.Names and Player.Name or ""
            ESP.Name.Visible = ESPSettings.Names
            ESP.Health.Text = ESPSettings.Health and ("HP: " .. math.floor(Humanoid.Health)) or ""
            ESP.Health.Visible = ESPSettings.Health
            ESP.Distance.Text = ESPSettings.Distance and ("Dist: " .. math.floor(Distance)) or ""
            ESP.Distance.Visible = ESPSettings.Distance
            ESP.Chams.Enabled = ESPSettings.Chams
        else
            ESP.Gui.Enabled = false
            ESP.Chams.Enabled = false
        end
    end

    if VisualSettings.Crosshair then
        CrosshairH.From = Vector2.new(Camera.ViewportSize.X / 2 - 10, Camera.ViewportSize.Y / 2)
        CrosshairH.To = Vector2.new(Camera.ViewportSize.X / 2 + 10, Camera.ViewportSize.Y / 2)
        CrosshairH.Visible = true
        CrosshairV.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2 - 10)
        CrosshairV.To = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2 + 10)
        CrosshairV.Visible = true
    else
        CrosshairH.Visible = false
        CrosshairV.Visible = false
    end

    if VisualSettings.FOVCircle then
        FOVCircle.Radius = VisualSettings.FOVCircleRadius
        FOVCircle.Position = UserInputService:GetMouseLocation()
        FOVCircle.Color = VisualSettings.FOVCircleColor
        FOVCircle.Visible = true
    else
        FOVCircle.Visible = false
    end

    if VisualSettings.Fullbright then
        Lighting.Brightness = 2
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = 0
        Lighting.FogEnd = 100
        Lighting.GlobalShadows = true
    end
end)

RunService.Heartbeat:Connect(function(delta)
    if (RageSettings.KillAura or RageSettings.RageMode) and LocalPlayer.Character then
        for _, Player in pairs(Players:GetPlayers()) do
            if Player == LocalPlayer or not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") or not Player.Character:FindFirstChild("Humanoid") or Player.Character.Humanoid.Health <= 0 then continue end
            local Distance = (LocalPlayer.Character and LocalPlayer.Character.HumanoidRootPart) and (Player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude or math.huge
            if Distance <= RageSettings.KillAuraRange then
                local success, _ = pcall(function()
                    Player.Character.Humanoid:TakeDamage(100)
                end)
                if not success then
                    if Player.Character.HumanoidRootPart then
                        Player.Character.HumanoidRootPart:Destroy()
                    end
                end
            end
        end
    end

    if RageSettings.SpeedHack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16 * RageSettings.SpeedMultiplier
    elseif LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end

    if RageSettings.FlyHack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local Root = LocalPlayer.Character.HumanoidRootPart
        local BodyVelocity = Root:FindFirstChild("FlyVelocity") or Instance.new("BodyVelocity")
        BodyVelocity.Name = "FlyVelocity"
        BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        BodyVelocity.Parent = Root

        local VerticalVelocity = 0
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            VerticalVelocity = RageSettings.FlySpeed
        elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            VerticalVelocity = -RageSettings.FlySpeed
        end

        local MoveDirection = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then MoveDirection = MoveDirection + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then MoveDirection = MoveDirection - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then MoveDirection = MoveDirection - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then MoveDirection = MoveDirection + Camera.CFrame.RightVector end

        local HorizontalVelocity = MoveDirection.Magnitude > 0 and (MoveDirection.Unit * RageSettings.FlySpeed) or Vector3.new(0, 0, 0)
        BodyVelocity.Velocity = HorizontalVelocity + Vector3.new(0, VerticalVelocity, 0)

        isFlying = true
    elseif isFlying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local Root = LocalPlayer.Character.HumanoidRootPart
        local BodyVelocity = Root:FindFirstChild("FlyVelocity")
        if BodyVelocity then BodyVelocity:Destroy() end
        isFlying = false
    end

    if MiscSettings.SpinBot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local Root = LocalPlayer.Character.HumanoidRootPart
        Root.CFrame = Root.CFrame * CFrame.Angles(0, math.rad(360 * delta * 5), 0)
    end

    if MiscSettings.AntiAim and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local Root = LocalPlayer.Character.HumanoidRootPart
        Root.CFrame = Root.CFrame * CFrame.Angles(math.rad(math.random(-180, 180)), math.rad(math.random(-180, 180)), 0)
    end
end)

RunService.Stepped:Connect(function()
    if RageSettings.Noclip and LocalPlayer.Character then
        for _, Part in pairs(LocalPlayer.Character:GetChildren()) do
            if Part:IsA("BasePart") then
                Part.CanCollide = false
            end
        end
    end
end)

TabContainers["Aimbot"].Visible = true
ActiveTab = TabContainers["Aimbot"]
TabFrame:GetChildren()[1].BackgroundTransparency = 0
TabFrame:GetChildren()[1].TextColor3 = Color3.fromRGB(0, 255, 255)

debugPrint("Chesco & Noxi v4.6 loaded!")
