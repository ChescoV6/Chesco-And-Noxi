-- Chesco & Noxi v4.9.8

-- Services Setup
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
WelcomeFrame.BackgroundTransparency = 1
WelcomeFrame.Visible = true
local WelcomeCorner = Instance.new("UICorner", WelcomeFrame)
WelcomeCorner.CornerRadius = UDim.new(0, 15)

local WelcomeStroke = Instance.new("UIStroke", WelcomeFrame)
WelcomeStroke.Thickness = 2
WelcomeStroke.Color = Color3.fromRGB(108, 59, 170)
WelcomeStroke.Transparency = 0.5
local ParticleGradient = Instance.new("UIGradient", WelcomeFrame)
ParticleGradient.Transparency = NumberSequence.new{
    NumberSequenceKeypoint.new(0, 0.2),
    NumberSequenceKeypoint.new(0.5, 0.8),
    NumberSequenceKeypoint.new(1, 0.2)
}
ParticleGradient.Rotation = 0

local WelcomeLabel = Instance.new("TextLabel", WelcomeFrame)
WelcomeLabel.Size = UDim2.new(1, 0, 0, 40)
WelcomeLabel.Position = UDim2.new(0, 0, 0, 20)
WelcomeLabel.BackgroundTransparency = 1
WelcomeLabel.Text = "Welcome, " .. LocalPlayer.Name .. "!"
WelcomeLabel.TextColor3 = Color3.fromRGB(108, 59, 170)
WelcomeLabel.TextSize = 22
WelcomeLabel.Font = Enum.Font.GothamBold

local OpenButton = Instance.new("TextButton", WelcomeFrame)
OpenButton.Size = UDim2.new(0, 100, 0, 35)
OpenButton.Position = UDim2.new(0.5, -50, 0.6, 0)
OpenButton.BackgroundColor3 = Color3.fromRGB(0, 200, 200)
OpenButton.Text = "Open Cheat"
OpenButton.TextColor3 = Color3.fromRGB(20, 20, 30)
OpenButton.TextSize = 16
OpenButton.Font = Enum.Font.GothamBold
local OpenCorner = Instance.new("UICorner", OpenButton)
OpenCorner.CornerRadius = UDim.new(0, 10)

local welcomeFade = TweenService:Create(WelcomeFrame, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {BackgroundTransparency = 0.1})
local welcomeScale = TweenService:Create(WelcomeFrame, TweenInfo.new(1.5, Enum.EasingStyle.Elastic), {Size = UDim2.new(0, 260, 0, 130)})
local welcomeGlow = TweenService:Create(WelcomeStroke, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Transparency = 0})
local particleSpin = TweenService:Create(ParticleGradient, TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 360})
welcomeFade:Play()
welcomeScale:Play()
welcomeGlow:Play()
particleSpin:Play()

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
GlowEffect.Color = Color3.fromRGB(108, 59, 170)
GlowEffect.Transparency = 0.5
local glowPulse = TweenService:Create(GlowEffect, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Transparency = 0})

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
Title.Text = "Chesco & Noxi - v4.9.8"
Title.TextColor3 = Color3.fromRGB(108, 59, 170)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
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
TabFrame.Size = UDim2.new(1, -10, 0, 35)
TabFrame.Position = UDim2.new(0, 5, 0, 35)
TabFrame.BackgroundColor3 = Color3.fromRGB(40, 60, 90)
local TabCorner = Instance.new("UICorner", TabFrame)
TabCorner.CornerRadius = UDim.new(0, 8)

local Tabs = {"Aimbot", "ESP", "Rage", "Visuals", "Misc", "Stats", "Config"}
local TabContainers = {}
local ActiveTab = nil

for i, tabName in ipairs(Tabs) do
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1/#Tabs, 0, 1, 0)
    TabButton.Position = UDim2.new((i-1)/#Tabs, 0, 0, 0)
    TabButton.BackgroundTransparency = 0.5
    TabButton.BackgroundColor3 = Color3.fromRGB(50, 70, 100)
    TabButton.Text = tabName
    TabButton.TextColor3 = Color3.fromRGB(200, 210, 220)
    TabButton.TextSize = 16
    TabButton.Font = Enum.Font.GothamMedium
    TabButton.Parent = TabFrame

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 5)
    ButtonCorner.Parent = TabButton

    local ButtonStroke = Instance.new("UIStroke")
    ButtonStroke.Thickness = 1
    ButtonStroke.Color = Color3.fromRGB(108, 59, 170)
    ButtonStroke.Transparency = 0.8
    ButtonStroke.Parent = TabButton

    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Size = UDim2.new(1, -20, 1, -90)
    TabContainer.Position = UDim2.new(0, 10, 0, 80)
    TabContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    TabContainer.BackgroundTransparency = 0.1
    TabContainer.Visible = false
    TabContainer.ClipsDescendants = true
    TabContainer.Parent = MainFrame
    TabContainer.ScrollBarThickness = 5
    TabContainer.ScrollBarImageColor3 = Color3.fromRGB(108, 59, 170)
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0) -- Will be set dynamically
    local ContainerCorner = Instance.new("UICorner")
    ContainerCorner.CornerRadius = UDim.new(0, 10)
    ContainerCorner.Parent = TabContainer
    TabContainers[tabName] = TabContainer

    TabButton.MouseButton1Click:Connect(function()
        if ActiveTab == TabContainer then return end
        if ActiveTab then ActiveTab.Visible = false end
        for _, child in pairs(TabFrame:GetChildren()) do
            if child:IsA("TextButton") and child.Text ~= tabName then
                child.BackgroundTransparency = 0.5
                child.TextColor3 = Color3.fromRGB(200, 210, 220)
                child.UIStroke.Transparency = 0.8
                TweenService:Create(child, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(1/#Tabs, 0, 1, 0)}):Play()
            end
        end
        ActiveTab = TabContainer
        ActiveTab.Visible = true
        TabButton.BackgroundTransparency = 0
        TabButton.TextColor3 = Color3.fromRGB(108, 59, 170)
        TabButton.UIStroke.Transparency = 0
        TweenService:Create(TabButton, TweenInfo.new(0.5, Enum.EasingStyle.Elastic), {Size = UDim2.new(1/#Tabs + 0.02, 0, 1, 5)}):Play()
    end)

    TabButton.MouseEnter:Connect(function()
        if TabButton.BackgroundTransparency ~= 0 then
            TweenService:Create(TabButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.3, BackgroundColor3 = Color3.fromRGB(60, 80, 110)}):Play()
        end
    end)
    TabButton.MouseLeave:Connect(function()
        if TabButton.BackgroundTransparency ~= 0 then
            TweenService:Create(TabButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.5, BackgroundColor3 = Color3.fromRGB(50, 70, 100)}):Play()
        end
    end)
end

local StatusLabel = Instance.new("TextLabel", MainFrame)
StatusLabel.Size = UDim2.new(0.5, -20, 0, 20)
StatusLabel.Position = UDim2.new(0, 10, 1, -30)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Inactive"
StatusLabel.TextColor3 = Color3.fromRGB(150, 160, 180)
StatusLabel.TextSize = 14
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

local FPSLabel = Instance.new("TextLabel", MainFrame)
FPSLabel.Size = UDim2.new(0.5, -20, 0, 20)
FPSLabel.Position = UDim2.new(0.5, 10, 1, -30)
FPSLabel.BackgroundTransparency = 1
FPSLabel.Text = "FPS: 0"
FPSLabel.TextColor3 = Color3.fromRGB(108, 59, 170)
FPSLabel.TextSize = 14
FPSLabel.Font = Enum.Font.Gotham
FPSLabel.TextXAlignment = Enum.TextXAlignment.Right

local AimbotSettings = {
    Enabled = false,
    SilentAim = false,
    AimLock = false,
    Smoothing = 1,
    FOV = 100,
    TriggerKey = Enum.UserInputType.MouseButton2,
    TeamCheck = true
}
local ESPSettings = {
    Enabled = false,
    Names = true,
    Health = true,
    Distance = true,
    Chams = false,
    Boxes3D = true,
    TeamColors = true,
    MaxDistance = 1000,
    TextColor = Color3.fromRGB(108, 59, 170),
    ChamsColor = Color3.fromRGB(0, 255, 0),
    Rainbow = false
}
local RageSettings = {
    KillAura = false,
    KillAuraRange = 10,
    SpeedHack = false,
    SpeedMultiplier = 1,
    Noclip = false,
    RageMode = false,
    FlyHack = false,
    FlySpeed = 50
}
local VisualSettings = {
    Crosshair = false,
    FOVCircle = false,
    FOVCircleRadius = 100,
    FOVCircleColor = Color3.fromRGB(108, 59, 170),
    Fullbright = false
}
local MiscSettings = {
    SpinBot = false,
    AntiAim = false,
    KillSound = false,
    Notifications = true
}
local StatsSettings = {
    LockOnTime = 0,
    TargetSwitches = 0,
    LastTargetSwitch = tick()
}

local ConfigSettings = {
    Aimbot = AimbotSettings,
    ESP = ESPSettings,
    Rage = RageSettings,
    Visuals = VisualSettings,
    Misc = MiscSettings,
    Stats = StatsSettings
}

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
    glowPulse:Play()
    TweenService:Create(MainFrame, TweenInfo.new(0.8, Enum.EasingStyle.Sine), {BackgroundTransparency = 0.1}):Play()
end)

local function showNotification(message, color)
    if not MiscSettings.Notifications then return end
    local NotifFrame = Instance.new("Frame", UI)
    NotifFrame.Size = UDim2.new(0, 150, 0, 40)
    NotifFrame.Position = UDim2.new(1, -170, 1, -50)
    NotifFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    NotifFrame.BackgroundTransparency = 1
    local NotifCorner = Instance.new("UICorner", NotifFrame)
    NotifCorner.CornerRadius = UDim.new(0, 8)
    local NotifLabel = Instance.new("TextLabel", NotifFrame)
    NotifLabel.Size = UDim2.new(1, 0, 1, 0)
    NotifLabel.BackgroundTransparency = 1
    NotifLabel.Text = message
    NotifLabel.TextColor3 = color or Color3.fromRGB(108, 59, 170)
    NotifLabel.TextSize = 12
    NotifLabel.Font = Enum.Font.Gotham
    TweenService:Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {BackgroundTransparency = 0.2, Position = UDim2.new(1, -160, 1, -50)}):Play()
    wait(2)
    TweenService:Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {BackgroundTransparency = 1, Position = UDim2.new(1, -170, 1, -50)}):Play()
    wait(0.5)
    NotifFrame:Destroy()
end

local function createTooltip(parent, text)
    local Tooltip = Instance.new("TextLabel", UI)
    Tooltip.Size = UDim2.new(0, 150, 0, 40)
    Tooltip.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    Tooltip.BackgroundTransparency = 1
    Tooltip.Text = text
    Tooltip.TextColor3 = Color3.fromRGB(200, 210, 220)
    Tooltip.TextSize = 12
    Tooltip.Font = Enum.Font.Gotham
    Tooltip.TextWrapped = true
    Tooltip.Visible = false
    local TooltipCorner = Instance.new("UICorner", Tooltip)
    TooltipCorner.CornerRadius = UDim.new(0, 5)

    parent.MouseEnter:Connect(function()
        local mousePos = UserInputService:GetMouseLocation()
        Tooltip.Position = UDim2.new(0, mousePos.X + 10, 0, mousePos.Y + 10)
        Tooltip.Visible = true
        TweenService:Create(Tooltip, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {BackgroundTransparency = 0.2}):Play()
    end)

    parent.MouseLeave:Connect(function()
        TweenService:Create(Tooltip, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {BackgroundTransparency = 1}):Play()
        wait(0.3)
        Tooltip.Visible = false
    end)

    return Tooltip
end

local function createToggle(label, setting, callback, parent, yPos, tooltipText)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -10, 0, 30)
    Frame.Position = UDim2.new(0, 5, 0, yPos)
    Frame.BackgroundTransparency = 1

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = label
    Label.TextColor3 = Color3.fromRGB(200, 210, 220)
    Label.TextSize = 14
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local ToggleButton = Instance.new("TextButton", Frame)
    ToggleButton.Size = UDim2.new(0.15, 0, 0.7, 0)
    ToggleButton.Position = UDim2.new(0.85, 0, 0.15, 0)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 60, 90)
    ToggleButton.Text = ""
    local Corner = Instance.new("UICorner", ToggleButton)
    Corner.CornerRadius = UDim.new(0, 5)
    local ToggleStroke = Instance.new("UIStroke", ToggleButton)
    ToggleStroke.Thickness = 1
    ToggleStroke.Color = Color3.fromRGB(108, 59, 170)
    ToggleStroke.Transparency = setting and 0 or 0.8

    local ToggleIndicator = Instance.new("Frame", ToggleButton)
    ToggleIndicator.Size = UDim2.new(0.4, 0, 0.8, 0)
    ToggleIndicator.Position = setting and UDim2.new(0.55, 0, 0.1, 0) or UDim2.new(0.05, 0, 0.1, 0)
    ToggleIndicator.BackgroundColor3 = setting and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 200, 200)
    local IndicatorCorner = Instance.new("UICorner", ToggleIndicator)
    IndicatorCorner.CornerRadius = UDim.new(0, 5)

    createTooltip(ToggleButton, tooltipText)

    ToggleButton.MouseButton1Click:Connect(function()
        setting = not setting
        callback(setting)
        TweenService:Create(ToggleIndicator, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = setting and UDim2.new(0.55, 0, 0.1, 0) or UDim2.new(0.05, 0, 0.1, 0),
            BackgroundColor3 = setting and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 200, 200)
        }):Play()
        ToggleStroke.Transparency = setting and 0 or 0.8
        StatusLabel.Text = "Status: " .. (setting and "Active" or "Inactive")
        showNotification(label .. " " .. (setting and "Enabled" or "Disabled"), setting and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
    end)

    ToggleButton.MouseEnter:Connect(function()
        TweenService:Create(ToggleButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = setting and Color3.fromRGB(0, 220, 0) or Color3.fromRGB(50, 70, 100)}):Play()
    end)
    ToggleButton.MouseLeave:Connect(function()
        TweenService:Create(ToggleButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = setting and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(40, 60, 90)}):Play()
    end)
end

local function createSlider(label, min, max, current, callback, parent, yPos, tooltipText)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -10, 0, 45)
    Frame.Position = UDim2.new(0, 5, 0, yPos)
    Frame.BackgroundTransparency = 1

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.BackgroundTransparency = 1
    Label.Text = label .. ": " .. current
    Label.TextColor3 = Color3.fromRGB(200, 210, 220)
    Label.TextSize = 14
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Slider = Instance.new("TextButton", Frame)
    Slider.Size = UDim2.new(1, 0, 0, 8)
    Slider.Position = UDim2.new(0, 0, 0, 25)
    Slider.BackgroundColor3 = Color3.fromRGB(40, 60, 90)
    Slider.Text = ""
    local SliderCorner = Instance.new("UICorner", Slider)
    SliderCorner.CornerRadius = UDim.new(0, 4)

    local SliderFill = Instance.new("Frame", Slider)
    SliderFill.Size = UDim2.new((current - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    SliderFill.BorderSizePixel = 0
    local FillCorner = Instance.new("UICorner", SliderFill)
    FillCorner.CornerRadius = UDim.new(0, 4)
    local SliderGradient = Instance.new("UIGradient", SliderFill)
    SliderGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 100))
    }
    local gradientShift = TweenService:Create(SliderGradient, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Offset = Vector2.new(1, 0)})

    createTooltip(Slider, tooltipText)

    local isDragging = false
    Slider.MouseButton1Down:Connect(function()
        isDragging = true
        gradientShift:Play()
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
            gradientShift:Pause()
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
            showNotification(label .. " set to " .. value, Color3.fromRGB(108, 59, 170))
        end
    end)
end

createToggle("Aimbot", AimbotSettings.Enabled, function(value) AimbotSettings.Enabled = value end, TabContainers["Aimbot"], 0, "Toggles the aimbot feature")
createToggle("Silent Aim", AimbotSettings.SilentAim, function(value) AimbotSettings.SilentAim = value end, TabContainers["Aimbot"], 40, "Aims without moving your mouse")
createToggle("Aim Lock", AimbotSettings.AimLock, function(value) AimbotSettings.AimLock = value end, TabContainers["Aimbot"], 80, "Locks onto the target")
createToggle("Team Check", AimbotSettings.TeamCheck, function(value) AimbotSettings.TeamCheck = value end, TabContainers["Aimbot"], 120, "Avoids targeting teammates")
createSlider("Smoothing", 1, 10, AimbotSettings.Smoothing, function(value) AimbotSettings.Smoothing = value end, TabContainers["Aimbot"], 160, "Adjusts aim smoothness")
createSlider("FOV", 10, 300, AimbotSettings.FOV, function(value) AimbotSettings.FOV = value end, TabContainers["Aimbot"], 215, "Sets the aimbot's field of view")
TabContainers["Aimbot"].CanvasSize = UDim2.new(0, 0, 0, 270)

createToggle("ESP Enabled", ESPSettings.Enabled, function(value) ESPSettings.Enabled = value end, TabContainers["ESP"], 0, "Toggles ESP features")
createToggle("Names", ESPSettings.Names, function(value) ESPSettings.Names = value end, TabContainers["ESP"], 40, "Shows player names")
createToggle("Health", ESPSettings.Health, function(value) ESPSettings.Health = value end, TabContainers["ESP"], 80, "Displays health bars")
createToggle("Distance", ESPSettings.Distance, function(value) ESPSettings.Distance = value end, TabContainers["ESP"], 120, "Shows distance to players")
createToggle("Chams", ESPSettings.Chams, function(value) ESPSettings.Chams = value end, TabContainers["ESP"], 160, "Highlights players through walls")
createToggle("3D Boxes", ESPSettings.Boxes3D, function(value) ESPSettings.Boxes3D = value end, TabContainers["ESP"], 200, "Draws 3D boxes around players")
createToggle("Team Colors", ESPSettings.TeamColors, function(value) ESPSettings.TeamColors = value end, TabContainers["ESP"], 240, "Uses team colors for ESP")
createToggle("Rainbow", ESPSettings.Rainbow, function(value) ESPSettings.Rainbow = value end, TabContainers["ESP"], 280, "Cycles ESP colors")
TabContainers["ESP"].CanvasSize = UDim2.new(0, 0, 0, 330)

createToggle("Kill Aura", RageSettings.KillAura, function(value) RageSettings.KillAura = value end, TabContainers["Rage"], 0, "Attacks nearby players")
createSlider("Kill Aura Range", 5, 50, RageSettings.KillAuraRange, function(value) RageSettings.KillAuraRange = value end, TabContainers["Rage"], 40, "Sets kill aura range")
createToggle("Speed Hack", RageSettings.SpeedHack, function(value) RageSettings.SpeedHack = value end, TabContainers["Rage"], 95, "Increases movement speed")
createSlider("Speed Multiplier", 1, 5, RageSettings.SpeedMultiplier, function(value) RageSettings.SpeedMultiplier = value end, TabContainers["Rage"], 135, "Adjusts speed boost")
createToggle("Noclip", RageSettings.Noclip, function(value) RageSettings.Noclip = value end, TabContainers["Rage"], 190, "Walk through walls")
createToggle("Rage Mode", RageSettings.RageMode, function(value) RageSettings.RageMode = value end, TabContainers["Rage"], 230, "Enables all rage features")
createToggle("Fly Hack", RageSettings.FlyHack, function(value) RageSettings.FlyHack = value end, TabContainers["Rage"], 270, "Enables flying")
createSlider("Fly Speed", 10, 100, RageSettings.FlySpeed, function(value) RageSettings.FlySpeed = value end, TabContainers["Rage"], 310, "Sets flying speed")
TabContainers["Rage"].CanvasSize = UDim2.new(0, 0, 0, 365)

createToggle("Crosshair", VisualSettings.Crosshair, function(value) VisualSettings.Crosshair = value end, TabContainers["Visuals"], 0, "Shows a custom crosshair")
createToggle("FOV Circle", VisualSettings.FOVCircle, function(value) VisualSettings.FOVCircle = value end, TabContainers["Visuals"], 40, "Displays aimbot FOV")
createSlider("FOV Circle Radius", 50, 200, VisualSettings.FOVCircleRadius, function(value) VisualSettings.FOVCircleRadius = value end, TabContainers["Visuals"], 80, "Adjusts FOV circle size")
createToggle("Fullbright", VisualSettings.Fullbright, function(value) VisualSettings.Fullbright = value end, TabContainers["Visuals"], 135, "Brightens the game")
TabContainers["Visuals"].CanvasSize = UDim2.new(0, 0, 0, 175)

createToggle("Spin Bot", MiscSettings.SpinBot, function(value) MiscSettings.SpinBot = value end, TabContainers["Misc"], 0, "Spins your character")
createToggle("Anti-Aim", MiscSettings.AntiAim, function(value) MiscSettings.AntiAim = value end, TabContainers["Misc"], 40, "Randomizes aim direction")
createToggle("Kill Sound", MiscSettings.KillSound, function(value) MiscSettings.KillSound = value end, TabContainers["Misc"], 80, "Plays sound on kills")
createToggle("Notifications", MiscSettings.Notifications, function(value) MiscSettings.Notifications = value end, TabContainers["Misc"], 120, "Shows notifications")
TabContainers["Misc"].CanvasSize = UDim2.new(0, 0, 0, 160)

local StatsLockOnLabel = Instance.new("TextLabel", TabContainers["Stats"])
StatsLockOnLabel.Size = UDim2.new(1, -20, 0, 20)
StatsLockOnLabel.Position = UDim2.new(0, 10, 0, 10)
StatsLockOnLabel.BackgroundTransparency = 1
StatsLockOnLabel.Text = "Avg Lock-On Time: 0 ms"
StatsLockOnLabel.TextColor3 = Color3.fromRGB(200, 210, 220)
StatsLockOnLabel.TextSize = 14
StatsLockOnLabel.Font = Enum.Font.Gotham
StatsLockOnLabel.TextXAlignment = Enum.TextXAlignment.Left

local StatsTargetSwitchesLabel = Instance.new("TextLabel", TabContainers["Stats"])
StatsTargetSwitchesLabel.Size = UDim2.new(1, -20, 0, 20)
StatsTargetSwitchesLabel.Position = UDim2.new(0, 10, 0, 40)
StatsTargetSwitchesLabel.BackgroundTransparency = 1
StatsTargetSwitchesLabel.Text = "Target Switches: 0"
StatsTargetSwitchesLabel.TextColor3 = Color3.fromRGB(200, 210, 220)
StatsTargetSwitchesLabel.TextSize = 14
StatsTargetSwitchesLabel.Font = Enum.Font.Gotham
StatsTargetSwitchesLabel.TextXAlignment = Enum.TextXAlignment.Left
TabContainers["Stats"].CanvasSize = UDim2.new(0, 0, 0, 60)

local SaveButton = Instance.new("TextButton", TabContainers["Config"])
SaveButton.Size = UDim2.new(1, -40, 0, 30)
SaveButton.Position = UDim2.new(0, 20, 0, 10)
SaveButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
SaveButton.Text = "Save Config"
SaveButton.TextColor3 = Color3.fromRGB(20, 20, 30)
SaveButton.TextSize = 14
SaveButton.Font = Enum.Font.GothamBold
local SaveCorner = Instance.new("UICorner", SaveButton)
SaveCorner.CornerRadius = UDim.new(0, 5)

local LoadButton = Instance.new("TextButton", TabContainers["Config"])
LoadButton.Size = UDim2.new(1, -40, 0, 30)
LoadButton.Position = UDim2.new(0, 20, 0, 45)
LoadButton.BackgroundColor3 = Color3.fromRGB(0, 200, 200)
LoadButton.Text = "Load Config"
LoadButton.TextColor3 = Color3.fromRGB(20, 20, 30)
LoadButton.TextSize = 14
LoadButton.Font = Enum.Font.GothamBold
local LoadCorner = Instance.new("UICorner", LoadButton)
LoadCorner.CornerRadius = UDim.new(0, 5)

local DebugLogFrame = Instance.new("Frame", TabContainers["Config"])
DebugLogFrame.Size = UDim2.new(1, -40, 0, 150)
DebugLogFrame.Position = UDim2.new(0, 20, 0, 80)
DebugLogFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
DebugLogFrame.BackgroundTransparency = 0.1
local DebugLogCorner = Instance.new("UICorner", DebugLogFrame)
DebugLogCorner.CornerRadius = UDim.new(0, 5)

local DebugLogLabel = Instance.new("TextLabel", DebugLogFrame)
DebugLogLabel.Size = UDim2.new(1, -10, 1, -10)
DebugLogLabel.Position = UDim2.new(0, 5, 0, 5)
DebugLogLabel.BackgroundTransparency = 1
DebugLogLabel.Text = "Debug Log:\n"
DebugLogLabel.TextColor3 = Color3.fromRGB(200, 210, 220)
DebugLogLabel.TextSize = 12
DebugLogLabel.Font = Enum.Font.Gotham
DebugLogLabel.TextXAlignment = Enum.TextXAlignment.Left
DebugLogLabel.TextYAlignment = Enum.TextYAlignment.Top
DebugLogLabel.TextWrapped = true
TabContainers["Config"].CanvasSize = UDim2.new(0, 0, 0, 240)

local debugLogMessages = {}
local function addDebugLog(message)
    table.insert(debugLogMessages, message)
    if #debugLogMessages > 5 then
        table.remove(debugLogMessages, 1)
    end
    DebugLogLabel.Text = "Debug Log:\n" .. table.concat(debugLogMessages, "\n")
end

SaveButton.MouseButton1Click:Connect(function()
    saveConfig({Aimbot = AimbotSettings, ESP = ESPSettings, Rage = RageSettings, Visuals = VisualSettings, Misc = MiscSettings, Stats = StatsSettings})
    showNotification("Config Saved!", Color3.fromRGB(0, 255, 0))
    addDebugLog("Config saved at " .. os.date("%H:%M:%S"))
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
        addDebugLog("Config loaded at " .. os.date("%H:%M:%S"))
    else
        showNotification("Failed to Load Config", Color3.fromRGB(255, 0, 0))
        addDebugLog("Config load failed at " .. os.date("%H:%M:%S"))
    end
end)

local CrosshairH = Instance.new("Frame", UI)
CrosshairH.Size = UDim2.new(0, 20, 0, 2)
CrosshairH.Position = UDim2.new(0.5, -10, 0.5, 0)
CrosshairH.BackgroundColor3 = Color3.fromRGB(108, 59, 170)
CrosshairH.Visible = false
local crosshairPulseH = TweenService:Create(CrosshairH, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {BackgroundTransparency = 0.3})

local CrosshairV = Instance.new("Frame", UI)
CrosshairV.Size = UDim2.new(0, 2, 0, 20)
CrosshairV.Position = UDim2.new(0.5, 0, 0.5, -10)
CrosshairV.BackgroundColor3 = Color3.fromRGB(108, 59, 170)
CrosshairV.Visible = false
local crosshairPulseV = TweenService:Create(CrosshairV, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {BackgroundTransparency = 0.3})

local FOVCircle = Instance.new("ImageLabel", UI)
FOVCircle.Size = UDim2.new(0, 200, 0, 200)
FOVCircle.Position = UDim2.new(0.5, -100, 0.5, -100)
FOVCircle.BackgroundTransparency = 1
FOVCircle.Image = "rbxassetid://494929581"
FOVCircle.ImageColor3 = VisualSettings.FOVCircleColor
FOVCircle.Visible = false
local fovRotate = TweenService:Create(FOVCircle, TweenInfo.new(5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 360})

local lastFrame = tick()
local Target = nil
local IsAiming = false
local ESPInstances = {}
local Hue = 0
local isFlying = false
local LastLockOnTime = tick()

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

        if AimbotSettings.TeamCheck and Player.Team == LocalPlayer.Team and LocalPlayer.Team ~= nil then continue end

        local AimPart = HumanoidRootPart
        local ScreenPos, OnScreen = Camera:WorldToViewportPoint(AimPart.Position)
        local Distance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - MousePos).Magnitude

        if OnScreen and Distance < ClosestDistance and Distance <= AimbotSettings.FOV then
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
        local RootPart = Character:FindFirstChild("HumanoidRootPart")
        local Humanoid = Character:FindFirstChild("Humanoid")
        if not RootPart or not Humanoid then return end

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

        local HealthBarFrame = Instance.new("Frame", Billboard)
        HealthBarFrame.Size = UDim2.new(2, 0, 0.2, 0)
        HealthBarFrame.Position = UDim2.new(-0.5, 0, -0.6, 0)
        HealthBarFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        HealthBarFrame.BorderSizePixel = 0

        local HealthBarFill = Instance.new("Frame", HealthBarFrame)
        HealthBarFill.Size = UDim2.new(1, 0, 1, 0)
        HealthBarFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        HealthBarFill.BorderSizePixel = 0
        local HealthGradient = Instance.new("UIGradient", HealthBarFill)
        HealthGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 0))
        }

        local Chams = Instance.new("Highlight")
        Chams.FillColor = ESPSettings.ChamsColor
        Chams.OutlineColor = ESPSettings.TextColor
        Chams.Adornee = Character
        Chams.Parent = Character

        local BoxLines = {}
        for i = 1, 12 do
            local Line = Instance.new("Frame", UI)
            Line.Size = UDim2.new(0, 2, 0, 2)
            Line.BackgroundColor3 = ESPSettings.TextColor
            Line.Visible = false
            BoxLines[i] = Line
        end

        ESPInstances[Player] = {
            Gui = Billboard,
            Name = NameLabel,
            Health = HealthLabel,
            Distance = DistanceLabel,
            HealthBar = HealthBarFill,
            Chams = Chams,
            BoxLines = BoxLines
        }

        Player.CharacterAdded:Connect(function(NewChar)
            Character = NewChar
            RootPart = NewChar:FindFirstChild("HumanoidRootPart")
            Humanoid = NewChar:FindFirstChild("Humanoid")
            if RootPart and Humanoid then
                Billboard.Adornee = RootPart
                Chams.Adornee = NewChar
            end
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

local function InitializeESPAsync()
    for _, Player in pairs(Players:GetPlayers()) do
        CreateESP(Player)
        wait(0.05)
    end
end
spawn(InitializeESPAsync)

Players.PlayerAdded:Connect(function(Player)
    spawn(function()
        wait(0.1)
        CreateESP(Player)
    end)
end)

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == AimbotSettings.TriggerKey then
        IsAiming = true
        addDebugLog("Aimbot activated at " .. os.date("%H:%M:%S"))
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == AimbotSettings.TriggerKey then
        IsAiming = false
        if not AimbotSettings.AimLock then
            Target = nil
        end
        addDebugLog("Aimbot deactivated at " .. os.date("%H:%M:%S"))
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
        local NewTarget = GetClosestPlayer()
        if NewTarget ~= Target then
            if Target then
                StatsSettings.TargetSwitches = StatsSettings.TargetSwitches + 1
                StatsSettings.LastTargetSwitch = tick()
                addDebugLog("Target switched to " .. (NewTarget and NewTarget.Name or "None"))
            end
            Target = NewTarget
            LastLockOnTime = tick()
        end

        if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
            local AimPart = Target.Character.HumanoidRootPart
            local TargetPos = AimPart.Position

            if RageSettings.RageMode then
                AimbotSettings.SilentAim = true
                ESPSettings.Enabled = true
                ESPSettings.Names = true
                ESPSettings.Health = true
                ESPSettings.Chams = true
                ESPSettings.Boxes3D = true
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

    local lockOnTime = Target and (tick() - LastLockOnTime) * 1000 or 0
    StatsSettings.LockOnTime = (StatsSettings.LockOnTime * 0.9 + lockOnTime * 0.1)
    StatsLockOnLabel.Text = "Avg Lock-On Time: " .. math.floor(StatsSettings.LockOnTime) .. " ms"
    StatsTargetSwitchesLabel.Text = "Target Switches: " .. StatsSettings.TargetSwitches

    if ESPSettings.Enabled then
        for Player, ESP in pairs(ESPInstances) do
            if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") or not Player.Character:FindFirstChild("Humanoid") or Player.Character.Humanoid.Health <= 0 then
                ESP.Gui.Enabled = false
                ESP.Chams.Enabled = false
                for _, line in pairs(ESP.BoxLines) do line.Visible = false end
                continue
            end

            local RootPart = Player.Character.HumanoidRootPart
            local Humanoid = Player.Character.Humanoid
            local Distance = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) and (RootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude or math.huge

            local espColor = ESPSettings.TextColor
            if ESPSettings.TeamColors and Player.Team then
                espColor = Player.TeamColor.Color
            end

            if ESPSettings.Boxes3D and Distance <= ESPSettings.MaxDistance then
                local head = Player.Character:FindFirstChild("Head")
                if head and RootPart then
                    local headOffset = head.Position - RootPart.Position
                    local size = Vector3.new(2, 4, 1)
                    local corners = {
                        RootPart.Position + Vector3.new(-size.X,  size.Y, -size.Z) + headOffset,
                        RootPart.Position + Vector3.new( size.X,  size.Y, -size.Z) + headOffset,
                        RootPart.Position + Vector3.new( size.X, -size.Y, -size.Z) + headOffset,
                        RootPart.Position + Vector3.new(-size.X, -size.Y, -size.Z) + headOffset,
                        RootPart.Position + Vector3.new(-size.X,  size.Y,  size.Z) + headOffset,
                        RootPart.Position + Vector3.new( size.X,  size.Y,  size.Z) + headOffset,
                        RootPart.Position + Vector3.new( size.X, -size.Y,  size.Z) + headOffset,
                        RootPart.Position + Vector3.new(-size.X, -size.Y,  size.Z) + headOffset
                    }

                    local screenCorners = {}
                    local allOnScreen = true
                    for i, corner in ipairs(corners) do
                        local screenPos, onScreen = Camera:WorldToViewportPoint(corner)
                        screenCorners[i] = Vector2.new(screenPos.X, screenPos.Y)
                        if not onScreen then
                            allOnScreen = false
                            break
                        end
                    end

                    if allOnScreen then
                        local lines = ESP.BoxLines
                        local connections = {
                            {1, 2}, {2, 3}, {3, 4}, {4, 1},
                            {5, 6}, {6, 7}, {7, 8}, {8, 5},
                            {1, 5}, {2, 6}, {3, 7}, {4, 8}
                        }
                        for i, conn in ipairs(connections) do
                            local from, to = screenCorners[conn[1]], screenCorners[conn[2]]
                            lines[i].Position = UDim2.new(0, from.X, 0, from.Y)
                            lines[i].Size = UDim2.new(0, (to - from).Magnitude, 0, 2)
                            lines[i].Rotation = math.deg(math.atan2(to.Y - from.Y, to.X - from.X))
                            lines[i].BackgroundColor3 = espColor
                            local distanceFactor = math.clamp(1 - (Distance / ESPSettings.MaxDistance), 0, 1)
                            lines[i].Transparency = 1 - distanceFactor
                            lines[i].Visible = true
                        end
                    else
                        for _, line in pairs(ESP.BoxLines) do line.Visible = false end
                    end
                else
                    for _, line in pairs(ESP.BoxLines) do line.Visible = false end
                end
            else
                for _, line in pairs(ESP.BoxLines) do line.Visible = false end
            end

            if Distance <= ESPSettings.MaxDistance then
                ESP.Gui.Enabled = true
                ESP.Name.TextColor3 = espColor
                ESP.Health.TextColor3 = espColor
                ESP.Distance.TextColor3 = espColor
                ESP.Chams.FillColor = ESPSettings.ChamsColor
                ESP.Chams.OutlineColor = espColor

                ESP.Name.Text = ESPSettings.Names and Player.Name or ""
                ESP.Name.Visible = ESPSettings.Names
                ESP.Health.Text = ESPSettings.Health and ("HP: " .. math.floor(Humanoid.Health)) or ""
                ESP.Health.Visible = ESPSettings.Health
                ESP.Distance.Text = ESPSettings.Distance and ("Dist: " .. math.floor(Distance)) or ""
                ESP.Distance.Visible = ESPSettings.Distance
                ESP.Chams.Enabled = ESPSettings.Chams

                if ESPSettings.Health then
                    local healthPercent = Humanoid.Health / Humanoid.MaxHealth
                    ESP.HealthBar.Size = UDim2.new(healthPercent * 1, 0, 1, 0)
                    ESP.HealthBar.BackgroundTransparency = Distance > ESPSettings.MaxDistance * 0.7 and 0.5 or 0
                else
                    ESP.HealthBar.BackgroundTransparency = 1
                end
            else
                ESP.Gui.Enabled = false
                ESP.Chams.Enabled = false
                for _, line in pairs(ESP.BoxLines) do line.Visible = false end
            end
        end
    else
        for _, ESP in pairs(ESPInstances) do
            ESP.Gui.Enabled = false
            ESP.Chams.Enabled = false
            for _, line in pairs(ESP.BoxLines) do line.Visible = false end
        end
    end

    if VisualSettings.Crosshair then
        CrosshairH.Visible = true
        CrosshairV.Visible = true
        crosshairPulseH:Play()
        crosshairPulseV:Play()
    else
        CrosshairH.Visible = false
        CrosshairV.Visible = false
        crosshairPulseH:Pause()
        crosshairPulseV:Pause()
    end

    if VisualSettings.FOVCircle then
        local MousePos = UserInputService:GetMouseLocation()
        FOVCircle.Size = UDim2.new(0, VisualSettings.FOVCircleRadius * 2, 0, VisualSettings.FOVCircleRadius * 2)
        FOVCircle.Position = UDim2.new(0, MousePos.X - VisualSettings.FOVCircleRadius, 0, MousePos.Y - VisualSettings.FOVCircleRadius)
        FOVCircle.ImageColor3 = VisualSettings.FOVCircleColor
        FOVCircle.Visible = true
        fovRotate:Play()
    else
        FOVCircle.Visible = false
        fovRotate:Pause()
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
    if RageSettings.KillAura or RageSettings.RageMode then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            for _, Player in pairs(Players:GetPlayers()) do
                if Player == LocalPlayer or not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") or not Player.Character:FindFirstChild("Humanoid") or Player.Character.Humanoid.Health <= 0 then continue end
                local Distance = (Player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if Distance <= RageSettings.KillAuraRange then
                    local success, _ = pcall(function()
                        Player.Character.Humanoid:TakeDamage(100)
                    end)
                    if not success and Player.Character.HumanoidRootPart then
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
TabFrame:GetChildren()[1].TextColor3 = Color3.fromRGB(108, 59, 170)
TabFrame:GetChildren()[1].UIStroke.Transparency = 0

debugPrint("Chesco & Noxi v4.9.8 loaded!")
addDebugLog("Script initialized at " .. os.date("%H:%M:%S"))
