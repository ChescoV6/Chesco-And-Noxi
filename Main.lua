-- Chesco & Noxi V6.0.0 (Advanced Rayfield GUI Version)
-- Credits to Chesco
-- Made for Me and Noxi
-- Enhanced with advanced features, modern aesthetics, and user-friendly design

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Camera = workspace.CurrentCamera
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

-- Load Rayfield Library with error handling
local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)
if not success then
    error("Failed to load Rayfield library. Please check your internet connection or executor compatibility.")
end

-- Create Rayfield Window
local Window = Rayfield:CreateWindow({
    Name = "Chesco & Noxi - v6.0.0",
    LoadingTitle = "Chesco & Noxi Ultimate Hub",
    LoadingSubtitle = "by Chesco",
    ShowText = "ChescoNoxi",
    Theme = "DarkBlue",
    ToggleUIKeybind = "F1",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "ChescoNoxiV6",
        FileName = "Config"
    },
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false
})

-- Settings Tables
local AimbotSettings = {
    Enabled = false,
    SilentAim = false,
    AimLock = false,
    DynamicSmoothing = false,
    Smoothing = 1,
    FOV = 100,
    TriggerKey = Enum.UserInputType.MouseButton2,
    TeamCheck = true,
    Wallbang = false,
    AimPart = "Head",
    Prediction = false,
    PredictionFactor = 0.1
}
local ESPSettings = {
    Enabled = false,
    Names = true,
    Health = true,
    Distance = true,
    Chams = false,
    Boxes3D = true,
    Tracers = false,
    Skeleton = false,
    TeamColors = true,
    VisibleOnly = false,
    MaxDistance = 1000,
    TextColor = Color3.fromRGB(108, 59, 170),
    ChamsColor = Color3.fromRGB(0, 255, 0),
    Rainbow = false,
    Glow = false,
    GlowIntensity = 0.5
}
local RageSettings = {
    KillAura = false,
    KillAuraRange = 10,
    Noclip = false,
    FlyHack = false,
    FlySpeed = 50,
    AutoFarm = false,
    HitboxExpander = false,
    HitboxSize = 10,
    TriggerBot = false,
    TriggerDelay = 0.1,
    TriggerHumanoidCheck = true,
    BunnyHop = false,
    RapidFire = false,
    RapidFireRate = 0.05
}
local VisualSettings = {
    Crosshair = false,
    FOVCircle = false,
    FOVCircleRadius = 100,
    FOVCircleColor = Color3.fromRGB(108, 59, 170),
    NoFog = false,
    Fullbright = false
}
local MiscSettings = {
    SpinBot = false,
    AntiAim = false,
    KillSound = false,
    Notifications = true,
    FPSBoost = false,
    AutoReload = false
}
local AutomationSettings = {
    AutoFarmEnabled = false,
    AutoQuest = false,
    AutoCollect = false,
    FarmRadius = 50
}
local StatsSettings = {
    LockOnTime = 0,
    TargetSwitches = 0,
    LastTargetSwitch = tick(),
    Kills = 0,
    FPS = 0
}

-- Connections and Cleanup
local Connections = {}
local ESPInstances = {}
local CrosshairH, CrosshairV, FOVCircle
local Target, IsAiming = nil, false
local Hue, LastLockOnTime, LastTriggerTime = 0, tick(), 0
local NotificationCooldown = {}
local LastFrameTime = tick()

local function cleanup()
    AimbotSettings.Enabled = false
    ESPSettings.Enabled = false
    RageSettings.KillAura = false
    RageSettings.Noclip = false
    RageSettings.FlyHack = false
    RageSettings.HitboxExpander = false
    RageSettings.TriggerBot = false
    RageSettings.BunnyHop = false
    RageSettings.RapidFire = false
    VisualSettings.Crosshair = false
    VisualSettings.FOVCircle = false
    VisualSettings.NoFog = false
    VisualSettings.Fullbright = false
    MiscSettings.SpinBot = false
    MiscSettings.AntiAim = false
    MiscSettings.FPSBoost = false
    MiscSettings.AutoReload = false
    AutomationSettings.AutoFarmEnabled = false
    AutomationSettings.AutoQuest = false
    AutomationSettings.AutoCollect = false
    for _, conn in pairs(Connections) do
        if conn then conn:Disconnect() end
    end
    for _, ESP in pairs(ESPInstances) do
        if ESP.Gui then ESP.Gui:Destroy() end
        if ESP.Chams then ESP.Chams:Destroy() end
        for _, line in pairs(ESP.BoxLines or {}) do if line then line:Remove() end end
        if ESP.Tracer then ESP.Tracer:Remove() end
        for _, line in pairs(ESP.Skeleton or {}) do if line then line:Remove() end end
    end
    for _, Player in pairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local Root = Player.Character.HumanoidRootPart
            Root.Size = Vector3.new(2, 5, 1)
            Root.Transparency = 0
            Root.CanCollide = true
        end
    end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local Root = LocalPlayer.Character.HumanoidRootPart
        if Root:FindFirstChild("FlyVelocity") then Root.FlyVelocity:Destroy() end
        if Root:FindFirstChild("FlyGyro") then Root.FlyGyro:Destroy() end
    end
    if CrosshairH then CrosshairH:Destroy() end
    if CrosshairV then CrosshairV:Destroy() end
    if FOVCircle then FOVCircle:Destroy() end
    Rayfield:Destroy()
end

-- Notification Function with Cooldown
local function showNotification(title, content, color, duration)
    if not MiscSettings.Notifications then return end
    local now = tick()
    local key = title .. content
    if NotificationCooldown[key] and now - NotificationCooldown[key] < 5 then return end
    NotificationCooldown[key] = now
    Rayfield:Notify({
        Title = title,
        Content = content,
        Duration = duration or 3,
        Image = "alert-circle"
    })
end

-- Create Crosshair and FOV Circle with Tweening
local function createVisuals()
    CrosshairH = Instance.new("Frame", game.CoreGui:WaitForChild("RobloxGui"))
    CrosshairH.Size = UDim2.new(0, 20, 0, 2)
    CrosshairH.Position = UDim2.new(0.5, -10, 0.5, 0)
    CrosshairH.BackgroundColor3 = Color3.fromRGB(108, 59, 170)
    CrosshairH.Visible = false
    CrosshairH.BorderSizePixel = 0
    local tweenH = TweenService:Create(CrosshairH, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {BackgroundTransparency = 0})
    
    CrosshairV = Instance.new("Frame", game.CoreGui:WaitForChild("RobloxGui"))
    CrosshairV.Size = UDim2.new(0, 2, 0, 20)
    CrosshairV.Position = UDim2.new(0.5, 0, 0.5, -10)
    CrosshairV.BackgroundColor3 = Color3.fromRGB(108, 59, 170)
    CrosshairV.Visible = false
    CrosshairV.BorderSizePixel = 0
    local tweenV = TweenService:Create(CrosshairV, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {BackgroundTransparency = 0})
    
    FOVCircle = Instance.new("ImageLabel", game.CoreGui:WaitForChild("RobloxGui"))
    FOVCircle.Size = UDim2.new(0, VisualSettings.FOVCircleRadius * 2, 0, VisualSettings.FOVCircleRadius * 2)
    FOVCircle.Position = UDim2.new(0.5, -VisualSettings.FOVCircleRadius, 0.5, -VisualSettings.FOVCircleRadius)
    FOVCircle.BackgroundTransparency = 1
    FOVCircle.Image = "rbxassetid://494929581"
    FOVCircle.ImageColor3 = VisualSettings.FOVCircleColor
    FOVCircle.Visible = false
    local tweenFOV = TweenService:Create(FOVCircle, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {ImageTransparency = 0})
    
    VisualSettings.CrosshairChanged = function(state)
        CrosshairH.Visible = state
        CrosshairV.Visible = state
        if state then
            tweenH:Play()
            tweenV:Play()
        else
            CrosshairH.BackgroundTransparency = 1
            CrosshairV.BackgroundTransparency = 1
        end
    end
    VisualSettings.FOVCircleChanged = function(state)
        FOVCircle.Visible = state
        if state then
            tweenFOV:Play()
        else
            FOVCircle.ImageTransparency = 1
        end
    end
end
createVisuals()

-- Create ESP for Players
local function CreateESP(Player)
    if Player == LocalPlayer then return end
    local Character = Player.Character or Player.CharacterAdded:Wait()
    local RootPart = Character:FindFirstChild("HumanoidRootPart")
    local Humanoid = Character:FindFirstChild("Humanoid")
    if not RootPart or not Humanoid then return end
    local Billboard = Instance.new("BillboardGui")
    Billboard.Size = UDim2.new(5, 0, 5, 0)
    Billboard.Adornee = RootPart
    Billboard.StudsOffset = Vector3.new(0, 3, 0)
    Billboard.Parent = game.CoreGui
    local Frame = Instance.new("Frame", Billboard)
    Frame.Size = UDim2.new(1, 0, 1, 0)
    Frame.BackgroundTransparency = 1
    local NameLabel = Instance.new("TextLabel", Frame)
    NameLabel.Size = UDim2.new(1, 0, 0.2, 0)
    NameLabel.Position = UDim2.new(0, 0, -0.3, 0)
    NameLabel.BackgroundTransparency = 1
    NameLabel.TextColor3 = ESPSettings.TextColor
    NameLabel.TextSize = 12
    NameLabel.TextStrokeTransparency = 0.5
    local HealthLabel = Instance.new("TextLabel", Frame)
    HealthLabel.Size = UDim2.new(1, 0, 0.2, 0)
    HealthLabel.Position = UDim2.new(0, 0, -0.1, 0)
    HealthLabel.BackgroundTransparency = 1
    HealthLabel.TextColor3 = ESPSettings.TextColor
    HealthLabel.TextSize = 12
    HealthLabel.TextStrokeTransparency = 0.5
    local DistanceLabel = Instance.new("TextLabel", Frame)
    DistanceLabel.Size = UDim2.new(1, 0, 0, 0)
    DistanceLabel.Position = UDim2.new(0, 0, 0.1, 0)
    DistanceLabel.BackgroundTransparency = 1
    DistanceLabel.TextColor3 = ESPSettings.TextColor
    DistanceLabel.TextSize = 12
    DistanceLabel.TextStrokeTransparency = 0.5
    local Chams = Instance.new("Highlight")
    Chams.FillColor = ESPSettings.ChamsColor
    Chams.OutlineColor = ESPSettings.TextColor
    Chams.Adornee = Character
    Chams.Parent = Character
    Chams.DepthMode = ESPSettings.VisibleOnly and Enum.HighlightDepthMode.Occluded or Enum.HighlightDepthMode.AlwaysOnTop
    Chams.FillTransparency = 1 - ESPSettings.GlowIntensity
    local BoxLines = {}
    for i = 1, 12 do
        local Line = Drawing.new("Line")
        Line.Thickness = 2
        Line.Color = ESPSettings.TextColor
        Line.Visible = false
        BoxLines[i] = Line
    end
    local TracerLine = Drawing.new("Line")
    TracerLine.Thickness = 1
    TracerLine.Color = ESPSettings.TextColor
    TracerLine.Visible = false
    local SkeletonLines = {}
    for i = 1, 10 do
        local Line = Drawing.new("Line")
        Line.Thickness = 1
        Line.Color = ESPSettings.TextColor
        Line.Visible = false
        SkeletonLines[i] = Line
    end
    ESPInstances[Player] = {Gui = Billboard, Name = NameLabel, Health = HealthLabel, Distance = DistanceLabel, Chams = Chams, BoxLines = BoxLines, Tracer = TracerLine, Skeleton = SkeletonLines}
    Player.CharacterAdded:Connect(function(NewChar)
        Character = NewChar
        RootPart = NewChar:FindFirstChild("HumanoidRootPart")
        Humanoid = NewChar:FindFirstChild("Humanoid")
        if RootPart and Humanoid then
            Billboard.Adornee = RootPart
            Chams.Adornee = NewChar
        end
    end)
end

for _, Player in pairs(Players:GetPlayers()) do
    pcall(function() CreateESP(Player) end)
end
Connections[#Connections + 1] = Players.PlayerAdded:Connect(function(Player) pcall(function() CreateESP(Player) end) end)

-- Advanced Aimbot Prediction
local function GetClosestPlayer()
    local ClosestPlayer = nil
    local ClosestDistance = math.huge
    local MousePos = UserInputService:GetMouseLocation()
    for _, Player in pairs(Players:GetPlayers()) do
        if Player == LocalPlayer then continue end
        local Character = Player.Character
        if not Character then continue end
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        local Humanoid = Character:FindFirstChild("Humanoid")
        if not HumanoidRootPart or not Humanoid or Humanoid.Health <= 0 then continue end
        if RageSettings.TriggerHumanoidCheck and RageSettings.TriggerBot and not Humanoid then continue end
        if AimbotSettings.TeamCheck and Player.Team == LocalPlayer.Team and LocalPlayer.Team ~= nil then continue end
        local AimPart = Character:FindFirstChild(AimbotSettings.AimPart)
        if not AimPart then continue end
        local Velocity = HumanoidRootPart.Velocity
        local PredictedPos = AimPart.Position + Velocity * (AimbotSettings.Prediction and AimbotSettings.PredictionFactor or 0)
        local ScreenPos, OnScreen = Camera:WorldToViewportPoint(PredictedPos)
        local Distance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - MousePos).Magnitude
        local WorldDistance = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) and (HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude or math.huge
        if (OnScreen or AimbotSettings.Wallbang) and Distance < ClosestDistance and Distance <= AimbotSettings.FOV and WorldDistance <= 500 then
            ClosestDistance = Distance
            ClosestPlayer = Player
        end
    end
    return ClosestPlayer, ClosestDistance
end

-- Create Tabs
local AimbotTab = Window:CreateTab("Aimbot", "target")
local ESPTab = Window:CreateTab("ESP", "eye")
local RageTab = Window:CreateTab("Rage", "zap")
local VisualsTab = Window:CreateTab("Visuals", "image")
local AutomationTab = Window:CreateTab("Automation", "play")
local MiscTab = Window:CreateTab("Misc", "settings")
local StatsTab = Window:CreateTab("Stats", "bar-chart")
local ConfigTab = Window:CreateTab("Config", "save")

-- Aimbot Tab
AimbotTab:CreateSection("Aimbot Settings")
AimbotTab:CreateToggle({
    Name = "Aimbot Enabled",
    CurrentValue = AimbotSettings.Enabled,
    Flag = "Aimbot_Enabled",
    Callback = function(Value)
        AimbotSettings.Enabled = Value
        showNotification("Aimbot", Value and "Enabled" or "Disabled", Value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0), 2)
    end
})
AimbotTab:CreateToggle({
    Name = "Silent Aim",
    CurrentValue = AimbotSettings.SilentAim,
    Flag = "Aimbot_SilentAim",
    Callback = function(Value)
        AimbotSettings.SilentAim = Value
        showNotification("Silent Aim", Value and "Enabled" or "Disabled", Value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0), 2)
    end
})
AimbotTab:CreateToggle({
    Name = "Aim Lock",
    CurrentValue = AimbotSettings.AimLock,
    Flag = "Aimbot_AimLock",
    Callback = function(Value)
        AimbotSettings.AimLock = Value
        showNotification("Aim Lock", Value and "Enabled" or "Disabled", Value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0), 2)
    end
})
AimbotTab:CreateToggle({
    Name = "Dynamic Smoothing",
    CurrentValue = AimbotSettings.DynamicSmoothing,
    Flag = "Aimbot_DynamicSmoothing",
    Callback = function(Value)
        AimbotSettings.DynamicSmoothing = Value
        showNotification("Dynamic Smoothing", Value and "Enabled" or "Disabled", Value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0), 2)
    end
})
AimbotTab:CreateToggle({
    Name = "Prediction",
    CurrentValue = AimbotSettings.Prediction,
    Flag = "Aimbot_Prediction",
    Callback = function(Value)
        AimbotSettings.Prediction = Value
        showNotification("Prediction", Value and "Enabled" or "Disabled", Value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0), 2)
    end
})
AimbotTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = AimbotSettings.TeamCheck,
    Flag = "Aimbot_TeamCheck",
    Callback = function(Value)
        AimbotSettings.TeamCheck = Value
        showNotification("Team Check", Value and "Enabled" or "Disabled", Value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0), 2)
    end
})
AimbotTab:CreateToggle({
    Name = "Wallbang",
    CurrentValue = AimbotSettings.Wallbang,
    Flag = "Aimbot_Wallbang",
    Callback = function(Value)
        AimbotSettings.Wallbang = Value
        showNotification("Wallbang", Value and "Enabled" or "Disabled", Value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0), 2)
    end
})
AimbotTab:CreateSlider({
    Name = "Smoothing",
    Range = {0.5, 10},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = AimbotSettings.Smoothing,
    Flag = "Aimbot_Smoothing",
    Callback = function(Value)
        AimbotSettings.Smoothing = Value
        showNotification("Smoothing Set", "Value: " .. Value, Color3.fromRGB(108, 59, 170), 2)
    end
})
AimbotTab:CreateSlider({
    Name = "FOV",
    Range = {10, 300},
    Increment = 1,
    Suffix = "",
    CurrentValue = AimbotSettings.FOV,
    Flag = "Aimbot_FOV",
    Callback = function(Value)
        AimbotSettings.FOV = Value
        showNotification("FOV Set", "Value: " .. Value, Color3.fromRGB(108, 59, 170), 2)
    end
})
AimbotTab:CreateSlider({
    Name = "Prediction Factor",
    Range = {0.05, 0.5},
    Increment = 0.01,
    Suffix = "",
    CurrentValue = AimbotSettings.PredictionFactor,
    Flag = "Aimbot_PredictionFactor",
    Callback = function(Value)
        AimbotSettings.PredictionFactor = Value
        showNotification("Prediction Factor Set", "Value: " .. Value, Color3.fromRGB(108, 59, 170), 2)
    end
})
AimbotTab:CreateDropdown({
    Name = "Aim Part",
    Options = {"Head", "UpperTorso", "LowerTorso", "LeftArm", "RightArm", "LeftLeg", "RightLeg"},
    CurrentOption = {AimbotSettings.AimPart},
    MultipleOptions = false,
    Flag = "Aimbot_AimPart",
    Callback = function(Options)
        AimbotSettings.AimPart = Options[1]
        showNotification("Aim Part Set", Options[1], Color3.fromRGB(108, 59, 170), 2)
    end
})

-- ESP Tab
ESPTab:CreateSection("ESP Settings")
ESPTab:CreateToggle({
    Name = "ESP Enabled",
    CurrentValue = ESPSettings.Enabled,
    Flag = "ESP_Enabled",
    Callback = function(Value)
        ESPSettings.Enabled = Value
        showNotification("ESP", Value and "Enabled" or "Disabled", Value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0), 2)
    end
})
ESPTab:CreateToggle({
    Name = "Names",
    CurrentValue = ESPSettings.Names,
    Flag = "ESP_Names",
    Callback = function(Value)
        ESPSettings.Names = Value
        showNotification("Names", Value and "Enabled" or "Disabled", Value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0), 2)
    end
})
ESPTab:CreateToggle({
    Name = "Health",
    CurrentValue = ESPSettings.Health,
    Flag = "ESP_Health",
    Callback = function(Value)
        ESPSettings.Health = Value
        showNotification("Health", Value and "Enabled" or "Disabled", Value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0), 2)
    end
})
ESPTab:CreateToggle({
    Name = "Distance",
    CurrentValue = ESPSettings.Distance,
    Flag = "ESP_Distance",
    Callback = function(Value)
        ESPSettings.Distance = Value
        showNotification("Distance", Value and "Enabled" or "Disabled", Value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0), 2)
    end
})
ESPTab:CreateToggle({
    Name = "Chams",
    CurrentValue = ESPSettings.Chams,
    Flag = "ESP_Chams",
    Callback = function(Value)
        ESPSettings.Chams = Value
        showNotification("Chams", Value and "Enabled" or "Disabled", Value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0), 2)
    end
})
ESPTab:CreateToggle({
    Name = "Chams Glow",
    CurrentValue = ESPSettings.Glow,
    Flag = "ESP_Glow",
    Callback = function(Value)
        ESPSettings.Glow = Value
        showNotification("Chams Glow", Value and "Enabled" or "Disabled", Value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0), 2)
    end
})
ESPTab:CreateToggle({
    Name = "3D Boxes",
    CurrentValue = ESPSettings.Boxes3D,
    Flag = "ESP_Boxes3D",
    Callback = function(Value)
        ESPSettings.Boxes3D = Value
        showNotification("3D Boxes", Value and "Enabled" or "Disabled", Value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0), 2)
    end
})
ESPTab:CreateToggle({
    Name = "Tracers",
    CurrentValue = ESPSettings.Tracers,
    Flag = "ESP_Tracers",
    Callback = function(Value)
        ESPSettings.Tracers = Value
        showNotification("Tracers", Value and "Enabled" or "Disabled", Value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0), 2)
    end
})
ESPTab:CreateToggle({
    Name = "Skeleton",
    CurrentValue = ESPSettings.Skeleton,
    Flag = "ESP_Skeleton",
    Callback = function(Value)
        ESPSettings.Skeleton = Value
        showNotification("Skeleton", Value and "Enabled" or "Disabled", Value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0), 2)
    end
})
ESPTab:CreateToggle({
    Name = "Team Colors",
    CurrentValue = ESPSettings.TeamColors,
    Flag = "ESP_TeamColors",
    Callback = function(Value)
        ESPSettings.TeamColors = Value
        showNotification("Team Colors", Value and "Enabled" or "Disabled", Value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0), 2)
    end
})
ESPTab:CreateToggle({
    Name = "Visible Only",
    CurrentValue = ESPSettings.VisibleOnly,
    Flag = "ESP_VisibleOnly",
    Callback = function(Value)
        ESPSettings.VisibleOnly = Value
        showNotification("Visible Only", Value and "Enabled" or "Disabled", Value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0), 2)
    end
})
ESPTab:CreateToggle({
    Name = "Rainbow",
    CurrentValue = ESPSettings.Rainbow,
    Flag = "ESP_Rainbow",
    Callback = function(Value)
        ESPSettings.Rainbow = Value
        showNotification("Rainbow", Value and "Enabled" or "Disabled", Value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0), 2)
    end
})
ESPTab:CreateSlider({
    Name = "Max Distance",
    Range = {100, 5000},
    Increment = 100,
    Suffix = "",
    CurrentValue = ESPSettings.MaxDistance,
    Flag = "ESP_MaxDistance",
    Callback = function(Value)
        ESPSettings.MaxDistance = Value
        showNotification("Max Distance Set", "Value: " .. Value, Color3.fromRGB(108, 59, 170), 2)
    end
})
ESPTab:CreateSlider({
    Name = "Glow Intensity",
    Range = {0.1, 1},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = ESPSettings.GlowIntensity,
    Flag = "ESP_GlowIntensity",
    Callback = function(Value)
        ESPSettings.GlowIntensity = Value
        showNotification("Glow Intensity Set", "Value: " .. Value, Color3.fromRGB(108, 59, 170), 2)
    end
})
ESPTab:CreateColorPicker({
    Name = "Text Color",
    Color = ESPSettings.TextColor,
    Flag = "ESP_TextColor",
    Callback = function(Value)
        ESPSettings.TextColor = Value
        showNotification("Text Color Set", "Changed", Color3.fromRGB(108, 59, 170), 2)
    end
})
ESPTab:CreateColorPicker({
    Name = "Chams Color",
    Color = ESPSettings.ChamsColor,
    Flag = "ESP_ChamsColor",
    Callback = function(Value)
        ESPSettings.ChamsColor = Value
        showNotification("Chams Color Set", "Changed", Color3.fromRGB(108, 59, 170), 2)
    end
})

-- Rage Tab
RageTab:CreateSection("Rage Settings")
RageTab:CreateToggle({
    Name = "Kill Aura",
    CurrentValue = RageSettings.KillAura,
    Flag = "Rage_KillAura",
    Callback = function(Value)
        RageSettings.KillAura = Value
        showNotification("Kill Aura", Value and "Enabled" or "Disabled", Value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0), 2)
    end
})
RageTab:CreateSlider({
    Name = "Kill Aura Range",
    Range = {5, 50},
    Increment = 1,
    Suffix = "",
    CurrentValue = RageSettings.KillAuraRange,
    Flag = "Rage_KillAuraRange",
    Callback = function(Value)
        RageSettings.KillAuraRange = Value
        showNotification("Kill Aura Range Set", "Value: " .. Value, Color3.fromRGB(108, 59, 170), 2)
    end
})
RageTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = RageSettings.Noclip,
    Flag = "Rage_Noclip",
    Callback = function(Value)
        RageSettings.Noclip = Value
        showNotification("Noclip", Value and "Enabled" or "Disabled", Value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0), 2)
    end
})
RageTab:CreateToggle({
    Name = "Fly Hack",
    CurrentValue = RageSettings.FlyHack,
    Flag = "Rage_FlyHack",
    Callback = function(Value)
        RageSettings.FlyHack = Value
        showNotification("Fly Hack", Value and "Enabled" or "Disabled", Value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0), 2)
    end
})
RageTab:CreateSlider({
    Name = "Fly Speed",
    Range = {10, 100},
    Increment = 1,
    Suffix = "",
    CurrentValue = RageSettings.FlySpeed,
    Flag = "Rage_FlySpeed",
    Callback = function(Value)
        RageSettings.FlySpeed = Value
        showNotification("Fly Speed Set", "Value: " .. Value, Color3.fromRGB(108, 59, 170), 2)
    end
})
RageTab:CreateToggle({
    Name = "Rapid Fire",
    CurrentValue = RageSettings.RapidFire,
    Flag = "Rage_RapidFire",
    Callback = function(Value)
        RageSettings.RapidFire = Value
        showNotification("Rapid Fire", Value and "Enabled" or "Disabled", Value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0), 2)
    end
})
RageTab:CreateSlider({
    Name = "Rapid Fire Rate",
    Range = {0.01, 0.5},
    Increment = 0.01,
    Suffix = "s",
    CurrentValue = RageSettings.RapidFireRate,
    Flag = "Rage_RapidFireRate",
    Callback = function(Value)
        RageSettings.RapidFireRate = Value
        showNotification("Rapid Fire Rate Set", "Value: " .. Value, Color3.fromRGB(108, 59, 170), 2)
    end
})
RageTab:CreateToggle({
    Name = "Hitbox Expander",
    CurrentValue = RageSettings.HitboxExpander,
    Flag = "Rage_HitboxExpander",
    Callback = function(Value)
        RageSettings.HitboxExpander = Value
        showNotification("Hitbox Expander", Value and "Enabled" or "Disabled", Value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0), 2)
    end
})
RageTab:CreateSlider({
    Name = "Hitbox Size",
    Range = {5, 20},
    Increment = 1,
    Suffix = "",
    CurrentValue = RageSettings.HitboxSize,
    Flag = "Rage_HitboxSize",
    Callback = function(Value)
        RageSettings.HitboxSize = Value
        showNotification("Hitbox Size Set", "Value: " .. Value, Color3.fromRGB(108, 59, 170), 2)
    end
})
RageTab:CreateToggle({
    Name = "TriggerBot",
    CurrentValue = RageSettings.TriggerBot,
    Flag = "Rage_TriggerBot",
    Callback = function(Value)
        RageSettings.TriggerBot = Value
        showNotification("TriggerBot", Value and "Enabled" or "Disabled", Value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0), 2)
    end
})
RageTab:CreateSlider({
    Name = "Trigger Delay",
    Range = {0.05, 1},
    Increment = 0.01,
    Suffix = "s",
    CurrentValue = RageSettings.TriggerDelay,
    Flag = "Rage_TriggerDelay",
    Callback = function(Value)
        RageSettings.TriggerDelay = Value
        showNotification("Trigger Delay Set", "Value: " .. Value, Color3.fromRGB(108, 59, 170), 2)
    end
})
RageTab:CreateToggle({
    Name = "Trigger Humanoid Check",
    CurrentValue = RageSettings.TriggerHumanoidCheck,
    Flag = "Rage_TriggerHumanoidCheck",
    Callback = function(Value)
        RageSettings.TriggerHumanoidCheck = Value
        showNotification("Trigger Humanoid Check", Value and "Enabled" or "Disabled", Value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0), 2)
    end
})
RageTab:CreateToggle({
    Name = "Bunny Hop",
    CurrentValue = RageSettings.BunnyHop,
    Flag = "Rage_BunnyHop",
    Callback = function(Value)
        RageSettings.BunnyHop = Value
        showNotification("Bunny Hop", Value and "Enabled" or "Disabled", Value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0), 2)
    end
})

-- Visuals Tab
VisualsTab:CreateSection("Visual Settings")
VisualsTab:CreateToggle({
    Name = "Crosshair",
    CurrentValue = VisualSettings.Crosshair,
    Flag = "Visuals_Crosshair",
    Callback = function(Value)
        VisualSettings.Crosshair = Value
        VisualSettings.CrosshairChanged(Value)
        showNotification("Crosshair", Value and "Enabled" or "Disabled", Value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0), 2)
    end
})
VisualsTab:CreateToggle({
    Name = "FOV Circle",
    CurrentValue = VisualSettings.FOVCircle,
    Flag = "Visuals_FOVCircle",
    Callback = function(Value)
        VisualSettings.FOVCircle = Value
        VisualSettings.FOVCircleChanged(Value)
        showNotification("FOV Circle", Value and "Enabled" or "Disabled", Value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0), 2)
    end
})
VisualsTab:CreateSlider({
    Name = "FOV Circle Radius",
    Range = {50, 200},
    Increment = 1,
    Suffix = "",
    CurrentValue = VisualSettings.FOVCircleRadius,
    Flag = "Visuals_FOVCircleRadius",
    Callback = function(Value)
        VisualSettings.FOVCircleRadius = Value
        showNotification("FOV Circle Radius Set", "Value: " .. Value, Color3.fromRGB(108, 59, 170), 2)
    end
})
VisualsTab:CreateColorPicker({
    Name = "FOV Circle Color",
    Color = VisualSettings.FOVCircleColor,
    Flag = "Visuals_FOVCircleColor",
    Callback = function(Value)
        VisualSettings.FOVCircleColor = Value
        showNotification("FOV Circle Color Set", "Changed", Color3.fromRGB(108, 59, 170), 2)
    end
})
VisualsTab:CreateToggle({
    Name = "No Fog",
    CurrentValue = VisualSettings.NoFog,
    Flag = "Visuals_NoFog",
    Callback = function(Value)
        VisualSettings.NoFog = Value
        showNotification("No Fog", Value and "Enabled" or "Disabled", Value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0), 2)
    end
})
VisualsTab:CreateToggle({
    Name = "Fullbright",
    CurrentValue = VisualSettings.Fullbright,
    Flag = "Visuals_Fullbright",
    Callback = function(Value)
        VisualSettings.Fullbright = Value
        showNotification("Fullbright", Value and "Enabled" or "Disabled", Value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0), 2)
    end
})

-- Automation Tab
AutomationTab:CreateSection("Automation Settings")
AutomationTab:CreateToggle({
    Name = "Auto-Farm",
    CurrentValue = AutomationSettings.AutoFarmEnabled,
    Flag = "Automation_AutoFarm",
    Callback = function(Value)
        AutomationSettings.AutoFarmEnabled = Value
        showNotification("Auto-Farm", Value and "Enabled" or "Disabled", Value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0), 2)
    end
})
AutomationTab:CreateToggle({
    Name = "Auto-Quest",
    CurrentValue = AutomationSettings.AutoQuest,
    Flag = "Automation_AutoQuest",
    Callback = function(Value)
        AutomationSettings.AutoQuest = Value
        showNotification("Auto-Quest", Value and "Enabled" or "Disabled", Value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0), 2)
    end
})
AutomationTab:CreateToggle({
    Name = "Auto-Collect",
    CurrentValue = AutomationSettings.AutoCollect,
    Flag = "Automation_AutoCollect",
    Callback = function(Value)
        AutomationSettings.AutoCollect = Value
        showNotification("Auto-Collect", Value and "Enabled" or "Disabled", Value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0), 2)
    end
})
AutomationTab:CreateSlider({
    Name = "Farm Radius",
    Range = {10, 100},
    Increment = 1,
    Suffix = "",
    CurrentValue = AutomationSettings.FarmRadius,
    Flag = "Automation_FarmRadius",
    Callback = function(Value)
        AutomationSettings.FarmRadius = Value
        showNotification("Farm Radius Set", "Value: " .. Value, Color3.fromRGB(108, 59, 170), 2)
    end
})

-- Misc Tab
MiscTab:CreateSection("Misc Settings")
MiscTab:CreateToggle({
    Name = "Spin Bot",
    CurrentValue = MiscSettings.SpinBot,
    Flag = "Misc_SpinBot",
    Callback = function(Value)
        MiscSettings.SpinBot = Value
        showNotification("Spin Bot", Value and "Enabled" or "Disabled", Value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0), 2)
    end
})
MiscTab:CreateToggle({
    Name = "Anti-Aim",
    CurrentValue = MiscSettings.AntiAim,
    Flag = "Misc_AntiAim",
    Callback = function(Value)
        MiscSettings.AntiAim = Value
        showNotification("Anti-Aim", Value and "Enabled" or "Disabled", Value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0), 2)
    end
})
MiscTab:CreateToggle({
    Name = "Kill Sound",
    CurrentValue = MiscSettings.KillSound,
    Flag = "Misc_KillSound",
    Callback = function(Value)
        MiscSettings.KillSound = Value
        showNotification("Kill Sound", Value and "Enabled" or "Disabled", Value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0), 2)
    end
})
MiscTab:CreateToggle({
    Name = "Auto Reload",
    CurrentValue = MiscSettings.AutoReload,
    Flag = "Misc_AutoReload",
    Callback = function(Value)
        MiscSettings.AutoReload = Value
        showNotification("Auto Reload", Value and "Enabled" or "Disabled", Value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0), 2)
    end
})
MiscTab:CreateToggle({
    Name = "Notifications",
    CurrentValue = MiscSettings.Notifications,
    Flag = "Misc_Notifications",
    Callback = function(Value)
        MiscSettings.Notifications = Value
        showNotification("Notifications", Value and "Enabled" or "Disabled", Value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0), 2)
    end
})
MiscTab:CreateToggle({
    Name = "FPS Boost",
    CurrentValue = MiscSettings.FPSBoost,
    Flag = "Misc_FPSBoost",
    Callback = function(Value)
        MiscSettings.FPSBoost = Value
        showNotification("FPS Boost", Value and "Enabled" or "Disabled", Value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0), 2)
    end
})

-- Stats Tab
StatsTab:CreateSection("Stats")
local StatsLockOnLabel = StatsTab:CreateLabel("Avg Lock-On Time: 0 ms")
local StatsTargetSwitchesLabel = StatsTab:CreateLabel("Target Switches: 0")
local StatsKillsLabel = StatsTab:CreateLabel("Kills: 0")
local StatsFPSLabel = StatsTab:CreateLabel("FPS: 0")

-- Config Tab
ConfigTab:CreateSection("Configuration")
ConfigTab:CreateButton({
    Name = "Save Config",
    Callback = function()
        Rayfield:SaveConfiguration()
        showNotification("Config Saved", "Settings saved successfully", Color3.fromRGB(0, 255, 0), 2)
    end
})
ConfigTab:CreateButton({
    Name = "Load Config",
    Callback = function()
        Rayfield:LoadConfiguration()
        showNotification("Config Loaded", "Settings loaded successfully", Color3.fromRGB(0, 255, 0), 2)
    end
})
ConfigTab:CreateButton({
    Name = "Reset Config",
    Callback = function()
        Rayfield:ResetConfiguration()
        showNotification("Config Reset", "Settings reset to default", Color3.fromRGB(255, 165, 0), 2)
    end
})
ConfigTab:CreateButton({
    Name = "Destroy UI",
    Callback = function()
        cleanup()
        showNotification("UI Destroyed", "Cheat interface terminated", Color3.fromRGB(255, 0, 0), 2)
    end
})

-- Input Connections
Connections[#Connections + 1] = UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == AimbotSettings.TriggerKey then IsAiming = true end
end)
Connections[#Connections + 1] = UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == AimbotSettings.TriggerKey then
        IsAiming = false
        if not AimbotSettings.AimLock then Target = nil end
    end
end)

-- Auto-Farm and Auto-Collect Logic
local function AutoFarm()
    if not AutomationSettings.AutoFarmEnabled then return end
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= AutomationSettings.FarmRadius then
            if AutomationSettings.AutoCollect and obj.Name:lower():match("coin|gem|item") then
                pcall(function() firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj, 0) end)
                wait(0.05)
                pcall(function() firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj, 1) end)
            end
        end
    end
end

local function AutoQuest()
    if not AutomationSettings.AutoQuest then return end
    -- Placeholder for quest logic; requires game-specific implementation
    showNotification("Auto-Quest", "Quest logic not implemented for this game", Color3.fromRGB(255, 165, 0), 2)
end

-- Main Loops
Connections[#Connections + 1] = RunService.Stepped:Connect(function()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    if RageSettings.HitboxExpander then
        for _, Player in pairs(Players:GetPlayers()) do
            if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                local Root = Player.Character.HumanoidRootPart
                Root.Size = Vector3.new(RageSettings.HitboxSize, RageSettings.HitboxSize, RageSettings.HitboxSize)
                Root.Transparency = 0.9
                Root.CanCollide = false
            end
        end
    else
        for _, Player in pairs(Players:GetPlayers()) do
            if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                local Root = Player.Character.HumanoidRootPart
                Root.Size = Vector3.new(2, 5, 1)
                Root.Transparency = 0
                Root.CanCollide = true
            end
        end
    end
    if MiscSettings.AutoReload then
        local Tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if Tool and Tool:FindFirstChild("Ammo") and Tool.Ammo.Value <= 0 then
            pcall(function() Tool:FindFirstChild("Reload"):FireServer() end)
        end
    end
end)

Connections[#Connections + 1] = RunService.RenderStepped:Connect(function()
    local current = tick()
    local deltaTime = current - LastFrameTime
    LastFrameTime = current
    StatsSettings.FPS = math.floor(1 / deltaTime)
    if AimbotSettings.Enabled or RageSettings.TriggerBot or RageSettings.RapidFire then
        local NewTarget, Distance = GetClosestPlayer()
        if NewTarget ~= Target then
            if Target then
                StatsSettings.TargetSwitches = StatsSettings.TargetSwitches + 1
                StatsSettings.LastTargetSwitch = tick()
            end
            Target = NewTarget
            LastLockOnTime = tick()
        end
        if Target and Target.Character and Target.Character:FindFirstChild(AimbotSettings.AimPart) then
            local AimPart = Target.Character:FindFirstChild(AimbotSettings.AimPart)
            local Velocity = Target.Character.HumanoidRootPart.Velocity
            local TargetPos = AimPart.Position + Velocity * (AimbotSettings.Prediction and AimbotSettings.PredictionFactor or 0)
            local ScreenPos, OnScreen = Camera:WorldToViewportPoint(TargetPos)
            if OnScreen or AimbotSettings.Wallbang then
                local MousePos = UserInputService:GetMouseLocation()
                local TargetScreenPos = Vector2.new(ScreenPos.X, ScreenPos.Y)
                local EffectiveSmoothing = AimbotSettings.DynamicSmoothing and (Distance / AimbotSettings.FOV * AimbotSettings.Smoothing) or AimbotSettings.Smoothing
                local Delta = (TargetScreenPos - MousePos) / EffectiveSmoothing
                if RageSettings.TriggerBot and (current - LastTriggerTime) >= RageSettings.TriggerDelay and LocalPlayer.Character then
                    pcall(function() mouse1press() wait() mouse1release() end)
                    LastTriggerTime = current
                end
                if RageSettings.RapidFire and (current - LastTriggerTime) >= RageSettings.RapidFireRate and LocalPlayer.Character then
                    pcall(function() mouse1press() wait() mouse1release() end)
                    LastTriggerTime = current
                end
                if AimbotSettings.Enabled and IsAiming then
                    if AimbotSettings.SilentAim and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool") then
                        local Tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                        if Tool and Tool:FindFirstChild("Fire") then
                            Tool.Fire:FireServer(TargetPos)
                        end
                    else
                        pcall(function() mousemoverel(Delta.X, Delta.Y) end)
                    end
                end
            end
        end
    else
        Target = nil
    end
    local lockOnTime = Target and (current - LastLockOnTime) * 1000 or 0
    StatsSettings.LockOnTime = (StatsSettings.LockOnTime * 0.9 + lockOnTime * 0.1)
    StatsLockOnLabel:Set("Avg Lock-On Time: " .. math.floor(StatsSettings.LockOnTime) .. " ms")
    StatsTargetSwitchesLabel:Set("Target Switches: " .. StatsSettings.TargetSwitches)
    StatsKillsLabel:Set("Kills: " .. StatsSettings.Kills)
    StatsFPSLabel:Set("FPS: " .. StatsSettings.FPS)
    if ESPSettings.Enabled then
        if ESPSettings.Rainbow then
            Hue = (Hue + 0.05) % 1
            ESPSettings.TextColor = Color3.fromHSV(Hue, 1, 1)
            ESPSettings.ChamsColor = Color3.fromHSV(Hue, 1, 1)
            VisualSettings.FOVCircleColor = Color3.fromHSV(Hue, 1, 1)
        end
        for Player, ESP in pairs(ESPInstances) do
            if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") or not Player.Character:FindFirstChild("Humanoid") or Player.Character.Humanoid.Health <= 0 then
                ESP.Gui.Enabled = false
                ESP.Chams.Enabled = false
                for _, line in pairs(ESP.BoxLines) do line.Visible = false end
                ESP.Tracer.Visible = false
                for _, line in pairs(ESP.Skeleton) do line.Visible = false end
                continue
            end
            local Character = Player.Character
            local RootPart = Character.HumanoidRootPart
            local Humanoid = Character.Humanoid
            local Distance = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) and (RootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude or math.huge
            if Distance > ESPSettings.MaxDistance then
                ESP.Gui.Enabled = false
                ESP.Chams.Enabled = false
                for _, line in pairs(ESP.BoxLines) do line.Visible = false end
                ESP.Tracer.Visible = false
                for _, line in pairs(ESP.Skeleton) do line.Visible = false end
                continue
            end
            local espColor = ESPSettings.TeamColors and Player.Team and Player.TeamColor.Color or ESPSettings.TextColor
            ESP.Gui.Enabled = true
            ESP.Chams.Enabled = ESPSettings.Chams
            ESP.Chams.FillTransparency = ESPSettings.Glow and (1 - ESPSettings.GlowIntensity) or 0.5
            ESP.Chams.DepthMode = ESPSettings.VisibleOnly and Enum.HighlightDepthMode.Occluded or Enum.HighlightDepthMode.AlwaysOnTop
            ESP.Name.Text = ESPSettings.Names and Player.Name or ""
            ESP.Health.Text = ESPSettings.Health and ("HP: " .. math.floor(Humanoid.Health)) or ""
            ESP.Distance.Text = ESPSettings.Distance and ("Dist: " .. math.floor(Distance)) or ""
            ESP.Name.TextColor3 = espColor
            ESP.Health.TextColor3 = espColor
            ESP.Distance.TextColor3 = espColor
            ESP.Chams.FillColor = ESPSettings.ChamsColor
            ESP.Chams.OutlineColor = espColor
            if ESPSettings.Boxes3D then
                local cframe, size = Character:GetBoundingBox()
                size = size * 0.5
                local corners = {
                    cframe * Vector3.new(-size.X, size.Y, -size.Z), cframe * Vector3.new(size.X, size.Y, -size.Z),
                    cframe * Vector3.new(size.X, -size.Y, -size.Z), cframe * Vector3.new(-size.X, -size.Y, -size.Z),
                    cframe * Vector3.new(-size.X, size.Y, size.Z), cframe * Vector3.new(size.X, size.Y, size.Z),
                    cframe * Vector3.new(size.X, -size.Y, size.Z), cframe * Vector3.new(-size.X, -size.Y, size.Z)
                }
                local screenCorners = {}
                local allOnScreen = true
                for i, corner in ipairs(corners) do
                    local screenPos, onScreen = Camera:WorldToViewportPoint(corner)
                    screenCorners[i] = Vector2.new(screenPos.X, screenPos.Y)
                    if not onScreen then allOnScreen = false end
                end
                if allOnScreen then
                    local lines = {{1,2},{2,3},{3,4},{4,1},{5,6},{6,7},{7,8},{8,5},{1,5},{2,6},{3,7},{4,8}}
                    for i, line in ipairs(lines) do
                        ESP.BoxLines[i].From = screenCorners[line[1]]
                        ESP.BoxLines[i].To = screenCorners[line[2]]
                        ESP.BoxLines[i].Color = espColor
                        ESP.BoxLines[i].Visible = true
                    end
                else
                    for _, line in pairs(ESP.BoxLines) do line.Visible = false end
                end
            else
                for _, line in pairs(ESP.BoxLines) do line.Visible = false end
            end
            if ESPSettings.Tracers then
                local screenPos, onScreen = Camera:WorldToViewportPoint(RootPart.Position)
                if onScreen then
                    ESP.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    ESP.Tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                    ESP.Tracer.Color = espColor
                    ESP.Tracer.Visible = true
                else
                    ESP.Tracer.Visible = false
                end
            else
                ESP.Tracer.Visible = false
            end
            if ESPSettings.Skeleton then


                local bones = {
                    {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"}, {"LowerTorso", "LeftUpperLeg"},
                    {"LowerTorso", "RightUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"RightUpperLeg", "RightLowerLeg"},
                    {"UpperTorso", "LeftUpperArm"}, {"UpperTorso", "RightUpperArm"}, {"LeftUpperArm", "LeftLowerArm"},
                    {"RightUpperArm", "RightLowerArm"}
                }
                for i, bone in ipairs(bones) do
                    local part1 = Character:FindFirstChild(bone[1])
                    local part2 = Character:FindFirstChild(bone[2])
                    if part1 and part2 then
                        local pos1, on1 = Camera:WorldToViewportPoint(part1.Position)
                        local pos2, on2 = Camera:WorldToViewportPoint(part2.Position)
                        if on1 and on2 then
                            ESP.Skeleton[i].From = Vector2.new(pos1.X, pos1.Y)
                            ESP.Skeleton[i].To = Vector2.new(pos2.X, pos2.Y)
                            ESP.Skeleton[i].Color = espColor
                            ESP.Skeleton[i].Visible = true
                        else
                            ESP.Skeleton[i].Visible = false
                        end
                    else
                        ESP.Skeleton[i].Visible = false
                    end
                end
            else
                for _, line in pairs(ESP.Skeleton) do line.Visible = false end
            end
        end
    else
        for _, ESP in pairs(ESPInstances) do
            ESP.Gui.Enabled = false
            ESP.Chams.Enabled = false
            for _, line in pairs(ESP.BoxLines) do line.Visible = false end
            ESP.Tracer.Visible = false
            for _, line in pairs(ESP.Skeleton) do line.Visible = false end
        end
    end
    CrosshairH.BackgroundColor3 = VisualSettings.FOVCircleColor
    CrosshairV.BackgroundColor3 = VisualSettings.FOVCircleColor
    FOVCircle.Size = UDim2.new(0, VisualSettings.FOVCircleRadius * 2, 0, VisualSettings.FOVCircleRadius * 2)
    FOVCircle.Position = UDim2.new(0.5, -VisualSettings.FOVCircleRadius, 0.5, -VisualSettings.FOVCircleRadius)
    FOVCircle.ImageColor3 = VisualSettings.FOVCircleColor
    if VisualSettings.NoFog then
        Lighting.FogEnd = 100000
    else
        Lighting.FogEnd = 100
    end
    if VisualSettings.Fullbright then
        Lighting.Brightness = 2
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
    end
    if MiscSettings.FPSBoost then
        pcall(function()
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and v ~= LocalPlayer.Character then
                    v.Material = Enum.Material.SmoothPlastic
                    v.Reflectance = 0
                end
            end
        end)
    end
    AutoFarm()
    AutoQuest()
end)

Connections[#Connections + 1] = RunService.Heartbeat:Connect(function()
    if not LocalPlayer.Character then return end
    if RageSettings.KillAura then
        for _, Player in pairs(Players:GetPlayers()) do
            if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character:FindFirstChild("Humanoid") and Player.Character.Humanoid.Health > 0 then
                local Distance = (Player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if Distance <= RageSettings.KillAuraRange then
                    pcall(function()
                        Player.Character.Humanoid:TakeDamage(100)
                        if MiscSettings.KillSound and Player.Character.Humanoid.Health <= 0 then
                            StatsSettings.Kills = StatsSettings.Kills + 1
                            showNotification("Killed " .. Player.Name, "Kill Sound", Color3.fromRGB(255, 0, 0), 2)
                        end
                    end)
                    wait(0.1)
                end
            end
        end
    end
    if RageSettings.Noclip then
        for _, Part in pairs(LocalPlayer.Character:GetChildren()) do
            if Part:IsA("BasePart") then Part.CanCollide = false end
        end
    end
    if RageSettings.FlyHack and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local Root = LocalPlayer.Character.HumanoidRootPart
        local BodyVelocity = Root:FindFirstChild("FlyVelocity") or Instance.new("BodyVelocity")
        BodyVelocity.Name = "FlyVelocity"
        BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        local BodyGyro = Root:FindFirstChild("FlyGyro") or Instance.new("BodyGyro")
        BodyGyro.Name = "FlyGyro"
        BodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        BodyGyro.CFrame = Camera.CFrame
        BodyGyro.Parent = Root
        local MoveDirection = Vector3.new(
            (UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.A) and 1 or 0),
            (UserInputService:IsKeyDown(Enum.KeyCode.Space) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and 1 or 0),
            (UserInputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0)
        )
        BodyVelocity.Velocity = Camera.CFrame:VectorToWorldSpace(MoveDirection * RageSettings.FlySpeed)
        BodyVelocity.Parent = Root
    elseif LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local Root = LocalPlayer.Character.HumanoidRootPart
        if Root:FindFirstChild("FlyVelocity") then Root.FlyVelocity:Destroy() end
        if Root:FindFirstChild("FlyGyro") then Root.FlyGyro:Destroy() end
    end
    if RageSettings.BunnyHop and LocalPlayer.Character:FindFirstChild("Humanoid") and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        local Humanoid = LocalPlayer.Character.Humanoid
        if Humanoid.FloorMaterial ~= Enum.Material.Air then
            Humanoid.Jump = true
        end
    end
    if MiscSettings.SpinBot and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(360 * 0.1), 0)
    end
    if MiscSettings.AntiAim and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(math.rad(math.random(-180, 180)), math.rad(math.random(-180, 180)), 0)
    end
end)

-- Initialize Configuration
Rayfield:LoadConfiguration()
showNotification("Chesco & Noxi Loaded", "Version 6.0.0 initialized successfully", Color3.fromRGB(0, 255, 0), 3)
