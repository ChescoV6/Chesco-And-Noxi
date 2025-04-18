-- Chesco & Noxi v5.0 - Advanced Aimbot, Skeleton ESP, Hitbox Expander
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Camera = workspace.CurrentCamera
local Lighting = game:GetService("Lighting")

-- Utility Functions
local function debugPrint(message) print("[Chesco & Noxi] " .. message) end
local function saveConfig(settings)
    pcall(function() writefile("Chesco_Noxi_Config.json", HttpService:JSONEncode(settings)) end)
end
local function loadConfig()
    local success, data = pcall(function() return HttpService:JSONDecode(readfile("Chesco_Noxi_Config.json")) end)
    return success and data or nil
end

-- UI Setup
local UI = Instance.new("ScreenGui")
UI.Name = "Chesco_Noxi_CheatUI_" .. math.random(1000, 9999)
UI.IgnoreGuiInset = true
UI.Parent = game.CoreGui or LocalPlayer.PlayerGui

-- Welcome Screen
local WelcomeFrame = Instance.new("Frame", UI)
WelcomeFrame.Size = UDim2.new(0, 250, 0, 120)
WelcomeFrame.Position = UDim2.new(0.5, -125, 0.5, -60)
WelcomeFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
WelcomeFrame.BackgroundTransparency = 0.2
local WelcomeCorner = Instance.new("UICorner", WelcomeFrame)
WelcomeCorner.CornerRadius = UDim.new(0, 12)
local WelcomeLabel = Instance.new("TextLabel", WelcomeFrame)
WelcomeLabel.Size = UDim2.new(1, 0, 0, 40)
WelcomeLabel.Position = UDim2.new(0, 0, 0, 20)
WelcomeLabel.BackgroundTransparency = 1
WelcomeLabel.Text = "Welcome, " .. LocalPlayer.Name .. "!"
WelcomeLabel.TextColor3 = Color3.fromRGB(108, 59, 170)
WelcomeLabel.TextSize = 20
WelcomeLabel.Font = Enum.Font.GothamBold
local OpenButton = Instance.new("TextButton", WelcomeFrame)
OpenButton.Size = UDim2.new(0, 100, 0, 35)
OpenButton.Position = UDim2.new(0.5, -50, 0.6, 0)
OpenButton.BackgroundColor3 = Color3.fromRGB(0, 200, 200)
OpenButton.Text = "Open Cheat"
OpenButton.TextColor3 = Color3.fromRGB(15, 15, 25)
OpenButton.TextSize = 16
OpenButton.Font = Enum.Font.GothamBold
local OpenCorner = Instance.new("UICorner", OpenButton)
OpenCorner.CornerRadius = UDim.new(0, 8)
TweenService:Create(WelcomeFrame, TweenInfo.new(1, Enum.EasingStyle.Sine), {BackgroundTransparency = 0.1, Size = UDim2.new(0, 260, 0, 130)}):Play()

-- Main UI Frame
local MainFrame = Instance.new("Frame", UI)
MainFrame.Size = UDim2.new(0, 450, 0, 350)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.BackgroundTransparency = 0.1
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 12)
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, -60, 0, 25)
Title.Position = UDim2.new(0, 10, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "Chesco & Noxi - v5.0"
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

-- Tab Navigation
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
    local ButtonCorner = Instance.new("UICorner", TabButton)
    ButtonCorner.CornerRadius = UDim.new(0, 5)
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Size = UDim2.new(1, -20, 1, -90)
    TabContainer.Position = UDim2.new(0, 10, 0, 80)
    TabContainer.BackgroundTransparency = 0.1
    TabContainer.Visible = false
    TabContainer.ScrollBarThickness = 5
    TabContainer.ScrollBarImageColor3 = Color3.fromRGB(108, 59, 170)
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.Parent = MainFrame
    TabContainers[tabName] = TabContainer
    TabButton.MouseButton1Click:Connect(function()
        if ActiveTab == TabContainer then return end
        if ActiveTab then ActiveTab.Visible = false end
        for _, child in pairs(TabFrame:GetChildren()) do
            if child:IsA("TextButton") and child.Text ~= tabName then
                child.BackgroundTransparency = 0.5
                child.TextColor3 = Color3.fromRGB(200, 210, 220)
            end
        end
        ActiveTab = TabContainer
        ActiveTab.Visible = true
        TabButton.BackgroundTransparency = 0
        TabButton.TextColor3 = Color3.fromRGB(108, 59, 170)
        TweenService:Create(TabButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(1/#Tabs + 0.02, 0, 1, 5)}):Play()
    end)
end

-- Status and FPS Labels
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

-- Settings
local AimbotSettings = {Enabled = false, SilentAim = false, AimLock = false, Smoothing = 1, FOV = 100, TriggerKey = Enum.UserInputType.MouseButton2, TeamCheck = true, Wallbang = false, AimPart = "Head"}
local ESPSettings = {Enabled = false, Names = true, Health = true, Distance = true, Chams = false, Boxes3D = true, Tracers = false, Skeleton = false, TeamColors = true, MaxDistance = 1000, TextColor = Color3.fromRGB(108, 59, 170), ChamsColor = Color3.fromRGB(0, 255, 0), Rainbow = false}
local RageSettings = {KillAura = false, KillAuraRange = 10, SpeedHack = false, SpeedMultiplier = 1, Noclip = false, RageMode = false, FlyHack = false, FlySpeed = 50, AutoFarm = false, HitboxExpander = false}
local VisualSettings = {Crosshair = false, FOVCircle = false, FOVCircleRadius = 100, FOVCircleColor = Color3.fromRGB(108, 59, 170), Fullbright = false}
local MiscSettings = {SpinBot = false, AntiAim = false, KillSound = false, Notifications = true, FPSBoost = false}
local StatsSettings = {LockOnTime = 0, TargetSwitches = 0, LastTargetSwitch = tick()}
local ConfigSettings = {Aimbot = AimbotSettings, ESP = ESPSettings, Rage = RageSettings, Visuals = VisualSettings, Misc = MiscSettings, Stats = StatsSettings}

-- Load Config
local loadedConfig = loadConfig()
if loadedConfig then
    for key, settings in pairs(loadedConfig) do
        if ConfigSettings[key] then
            for setting, value in pairs(settings) do
                ConfigSettings[key][setting] = value
            end
        end
    end
end

-- UI Handlers
CloseButton.MouseButton1Click:Connect(function() UI:Destroy() end)
OpenButton.MouseButton1Click:Connect(function()
    WelcomeFrame.Visible = false
    MainFrame.Visible = true
    TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {BackgroundTransparency = 0}):Play()
end)

-- Notification System
local function showNotification(message, color)
    if not MiscSettings.Notifications then return end
    local NotifFrame = Instance.new("Frame", UI)
    NotifFrame.Size = UDim2.new(0, 150, 0, 40)
    NotifFrame.Position = UDim2.new(1, -170, 1, -50)
    NotifFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    NotifFrame.BackgroundTransparency = 0.2
    local NotifCorner = Instance.new("UICorner", NotifFrame)
    NotifCorner.CornerRadius = UDim.new(0, 8)
    local NotifLabel = Instance.new("TextLabel", NotifFrame)
    NotifLabel.Size = UDim2.new(1, 0, 1, 0)
    NotifLabel.BackgroundTransparency = 1
    NotifLabel.Text = message
    NotifLabel.TextColor3 = color or Color3.fromRGB(108, 59, 170)
    NotifLabel.TextSize = 12
    NotifLabel.Font = Enum.Font.Gotham
    TweenService:Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {Position = UDim2.new(1, -160, 1, -50)}):Play()
    wait(2)
    NotifFrame:Destroy()
end

-- Toggle Creator
local function createToggle(label, setting, callback, parent, yPos)
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
    local ToggleIndicator = Instance.new("Frame", ToggleButton)
    ToggleIndicator.Size = UDim2.new(0.4, 0, 0.8, 0)
    ToggleIndicator.Position = setting and UDim2.new(0.55, 0, 0.1, 0) or UDim2.new(0.05, 0, 0.1, 0)
    ToggleIndicator.BackgroundColor3 = setting and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 200, 200)
    local IndicatorCorner = Instance.new("UICorner", ToggleIndicator)
    IndicatorCorner.CornerRadius = UDim.new(0, 5)
    ToggleButton.MouseButton1Click:Connect(function()
        setting = not setting
        callback(setting)
        TweenService:Create(ToggleIndicator, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = setting and UDim2.new(0.55, 0, 0.1, 0) or UDim2.new(0.05, 0, 0.1, 0),
            BackgroundColor3 = setting and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 200, 200)
        }):Play()
        showNotification(label .. " " .. (setting and "Enabled" or "Disabled"), setting and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
    end)
end

-- Slider Creator
local function createSlider(label, min, max, current, callback, parent, yPos)
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
    local isDragging = false
    Slider.MouseButton1Down:Connect(function() isDragging = true end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then isDragging = false end
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
        end
    end)
end

-- Dropdown Creator
local function createDropdown(label, options, current, callback, parent, yPos)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -10, 0, 30)
    Frame.Position = UDim2.new(0, 5, 0, yPos)
    Frame.BackgroundTransparency = 1
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = label .. ": " .. current
    Label.TextColor3 = Color3.fromRGB(200, 210, 220)
    Label.TextSize = 14
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    local DropdownButton = Instance.new("TextButton", Frame)
    DropdownButton.Size = UDim2.new(0.15, 0, 0.7, 0)
    DropdownButton.Position = UDim2.new(0.85, 0, 0.15, 0)
    DropdownButton.BackgroundColor3 = Color3.fromRGB(40, 60, 90)
    DropdownButton.Text = "▼"
    DropdownButton.TextColor3 = Color3.fromRGB(200, 210, 220)
    DropdownButton.TextSize = 12
    local DropdownCorner = Instance.new("UICorner", DropdownButton)
    DropdownCorner.CornerRadius = UDim.new(0, 5)
    local DropdownMenu = Instance.new("Frame", Frame)
    DropdownMenu.Size = UDim2.new(0.15, 0, 0, #options * 25)
    DropdownMenu.Position = UDim2.new(0.85, 0, 1, 0)
    DropdownMenu.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    DropdownMenu.Visible = false
    local MenuCorner = Instance.new("UICorner", DropdownMenu)
    MenuCorner.CornerRadius = UDim.new(0, 5)
    for i, option in ipairs(options) do
        local OptionButton = Instance.new("TextButton", DropdownMenu)
        OptionButton.Size = UDim2.new(1, 0, 0, 25)
        OptionButton.Position = UDim2.new(0, 0, 0, (i-1) * 25)
        OptionButton.BackgroundTransparency = 1
        OptionButton.Text = option
        OptionButton.TextColor3 = Color3.fromRGB(200, 210, 220)
        OptionButton.TextSize = 12
        OptionButton.Font = Enum.Font.Gotham
        OptionButton.MouseButton1Click:Connect(function()
            callback(option)
            Label.Text = label .. ": " .. option
            DropdownMenu.Visible = false
            showNotification(label .. " set to " .. option, Color3.fromRGB(108, 59, 170))
        end)
    end
    DropdownButton.MouseButton1Click:Connect(function()
        DropdownMenu.Visible = not DropdownMenu.Visible
    end)
end

-- Create UI Elements
createToggle("Aimbot", AimbotSettings.Enabled, function(value) AimbotSettings.Enabled = value end, TabContainers["Aimbot"], 0)
createToggle("Silent Aim", AimbotSettings.SilentAim, function(value) AimbotSettings.SilentAim = value end, TabContainers["Aimbot"], 40)
createToggle("Aim Lock", AimbotSettings.AimLock, function(value) AimbotSettings.AimLock = value end, TabContainers["Aimbot"], 80)
createToggle("Team Check", AimbotSettings.TeamCheck, function(value) AimbotSettings.TeamCheck = value end, TabContainers["Aimbot"], 120)
createToggle("Wallbang", AimbotSettings.Wallbang, function(value) AimbotSettings.Wallbang = value end, TabContainers["Aimbot"], 160)
createSlider("Smoothing", 1, 10, AimbotSettings.Smoothing, function(value) AimbotSettings.Smoothing = value end, TabContainers["Aimbot"], 200)
createSlider("FOV", 10, 300, AimbotSettings.FOV, function(value) AimbotSettings.FOV = value end, TabContainers["Aimbot"], 255)
createDropdown("Aim Part", {"Head", "Torso", "Legs"}, AimbotSettings.AimPart, function(value) AimbotSettings.AimPart = value end, TabContainers["Aimbot"], 310)
TabContainers["Aimbot"].CanvasSize = UDim2.new(0, 0, 0, 350)
createToggle("ESP Enabled", ESPSettings.Enabled, function(value) ESPSettings.Enabled = value end, TabContainers["ESP"], 0)
createToggle("Names", ESPSettings.Names, function(value) ESPSettings.Names = value end, TabContainers["ESP"], 40)
createToggle("Health", ESPSettings.Health, function(value) ESPSettings.Health = value end, TabContainers["ESP"], 80)
createToggle("Distance", ESPSettings.Distance, function(value) ESPSettings.Distance = value end, TabContainers["ESP"], 120)
createToggle("Chams", ESPSettings.Chams, function(value) ESPSettings.Chams = value end, TabContainers["ESP"], 160)
createToggle("3D Boxes", ESPSettings.Boxes3D, function(value) ESPSettings.Boxes3D = value end, TabContainers["ESP"], 200)
createToggle("Tracers", ESPSettings.Tracers, function(value) ESPSettings.Tracers = value end, TabContainers["ESP"], 240)
createToggle("Skeleton", ESPSettings.Skeleton, function(value) ESPSettings.Skeleton = value end, TabContainers["ESP"], 280)
createToggle("Team Colors", ESPSettings.TeamColors, function(value) ESPSettings.TeamColors = value end, TabContainers["ESP"], 320)
createToggle("Rainbow", ESPSettings.Rainbow, function(value) ESPSettings.Rainbow = value end, TabContainers["ESP"], 360)
TabContainers["ESP"].CanvasSize = UDim2.new(0, 0, 0, 400)
createToggle("Kill Aura", RageSettings.KillAura, function(value) RageSettings.KillAura = value end, TabContainers["Rage"], 0)
createSlider("Kill Aura Range", 5, 50, RageSettings.KillAuraRange, function(value) RageSettings.KillAuraRange = value end, TabContainers["Rage"], 40)
createToggle("Speed Hack", RageSettings.SpeedHack, function(value) RageSettings.SpeedHack = value end, TabContainers["Rage"], 95)
createSlider("Speed Multiplier", 1, 5, RageSettings.SpeedMultiplier, function(value) RageSettings.SpeedMultiplier = value end, TabContainers["Rage"], 135)
createToggle("Noclip", RageSettings.Noclip, function(value) RageSettings.Noclip = value end, TabContainers["Rage"], 190)
createToggle("Rage Mode", RageSettings.RageMode, function(value) RageSettings.RageMode = value end, TabContainers["Rage"], 230)
createToggle("Fly Hack", RageSettings.FlyHack, function(value) RageSettings.FlyHack = value end, TabContainers["Rage"], 270)
createSlider("Fly Speed", 10, 100, RageSettings.FlySpeed, function(value) RageSettings.FlySpeed = value end, TabContainers["Rage"], 310)
createToggle("Auto-Farm", RageSettings.AutoFarm, function(value) RageSettings.AutoFarm = value end, TabContainers["Rage"], 365)
createToggle("Hitbox Expander", RageSettings.HitboxExpander, function(value) RageSettings.HitboxExpander = value end, TabContainers["Rage"], 405)
TabContainers["Rage"].CanvasSize = UDim2.new(0, 0, 0, 450)
createToggle("Crosshair", VisualSettings.Crosshair, function(value) VisualSettings.Crosshair = value end, TabContainers["Visuals"], 0)
createToggle("FOV Circle", VisualSettings.FOVCircle, function(value) VisualSettings.FOVCircle = value end, TabContainers["Visuals"], 40)
createSlider("FOV Circle Radius", 50, 200, VisualSettings.FOVCircleRadius, function(value) VisualSettings.FOVCircleRadius = value end, TabContainers["Visuals"], 80)
createToggle("Fullbright", VisualSettings.Fullbright, function(value) VisualSettings.Fullbright = value end, TabContainers["Visuals"], 135)
TabContainers["Visuals"].CanvasSize = UDim2.new(0, 0, 0, 175)
createToggle("Spin Bot", MiscSettings.SpinBot, function(value) MiscSettings.SpinBot = value end, TabContainers["Misc"], 0)
createToggle("Anti-Aim", MiscSettings.AntiAim, function(value) MiscSettings.AntiAim = value end, TabContainers["Misc"], 40)
createToggle("Kill Sound", MiscSettings.KillSound, function(value) MiscSettings.KillSound = value end, TabContainers["Misc"], 80)
createToggle("Notifications", MiscSettings.Notifications, function(value) MiscSettings.Notifications = value end, TabContainers["Misc"], 120)
createToggle("FPS Boost", MiscSettings.FPSBoost, function(value) MiscSettings.FPSBoost = value end, TabContainers["Misc"], 160)
TabContainers["Misc"].CanvasSize = UDim2.new(0, 0, 0, 200)
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
SaveButton.TextColor3 = Color3.fromRGB(15, 15, 25)
SaveButton.TextSize = 14
SaveButton.Font = Enum.Font.GothamBold
local SaveCorner = Instance.new("UICorner", SaveButton)
SaveCorner.CornerRadius = UDim.new(0, 5)
local LoadButton = Instance.new("TextButton", TabContainers["Config"])
LoadButton.Size = UDim2.new(1, -40, 0, 30)
LoadButton.Position = UDim2.new(0, 20, 0, 45)
LoadButton.BackgroundColor3 = Color3.fromRGB(0, 200, 200)
LoadButton.Text = "Load Config"
LoadButton.TextColor3 = Color3.fromRGB(15, 15, 25)
LoadButton.TextSize = 14
LoadButton.Font = Enum.Font.GothamBold
local LoadCorner = Instance.new("UICorner", LoadButton)
LoadCorner.CornerRadius = UDim.new(0, 5)
SaveButton.MouseButton1Click:Connect(function()
    saveConfig({Aimbot = AimbotSettings, ESP = ESPSettings, Rage = RageSettings, Visuals = VisualSettings, Misc = MiscSettings, Stats = StatsSettings})
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
TabContainers["Config"].CanvasSize = UDim2.new(0, 0, 0, 80)

-- Visual Elements
local CrosshairH = Instance.new("Frame", UI)
CrosshairH.Size = UDim2.new(0, 20, 0, 2)
CrosshairH.Position = UDim2.new(0.5, -10, 0.5, 0)
CrosshairH.BackgroundColor3 = Color3.fromRGB(108, 59, 170)
CrosshairH.Visible = false
local CrosshairV = Instance.new("Frame", UI)
CrosshairV.Size = UDim2.new(0, 2, 0, 20)
CrosshairV.Position = UDim2.new(0.5, 0, 0.5, -10)
CrosshairV.BackgroundColor3 = Color3.fromRGB(108, 59, 170)
CrosshairV.Visible = false
local FOVCircle = Instance.new("ImageLabel", UI)
FOVCircle.Size = UDim2.new(0, 200, 0, 200)
FOVCircle.Position = UDim2.new(0.5, -100, 0.5, -100)
FOVCircle.BackgroundTransparency = 1
FOVCircle.Image = "rbxassetid://494929581"
FOVCircle.ImageColor3 = VisualSettings.FOVCircleColor
FOVCircle.Visible = false

-- Game Logic Variables
local lastFrame = tick()
local Target = nil
local IsAiming = false
local ESPInstances = {}
local Hue = 0
local LastLockOnTime = tick()

-- Hitbox Expander
coroutine.wrap(function()
    while true do
        if RageSettings.HitboxExpander then
            for _, Player in pairs(Players:GetPlayers()) do
                if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                    local Root = Player.Character.HumanoidRootPart
                    Root.Size = Vector3.new(10, 10, 10)
                    Root.Transparency = 0.9
                    Root.CanCollide = false
                end
            end
        end
        wait(0.1)
    end
end)()

-- ESP Creation
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

coroutine.wrap(function()
    for _, Player in pairs(Players:GetPlayers()) do
        pcall(function() CreateESP(Player) end)
        wait(0.05)
    end
end)()
Players.PlayerAdded:Connect(function(Player) pcall(function() CreateESP(Player) end) end)

-- Aimbot Logic
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
        local AimPart = AimbotSettings.AimPart == "Head" and Character:FindFirstChild("Head") or
                        AimbotSettings.AimPart == "Torso" and Character:FindFirstChild("HumanoidRootPart") or
                        Character:FindFirstChild("LeftLowerLeg")
        if not AimPart then continue end
        local ScreenPos, OnScreen = Camera:WorldToViewportPoint(AimPart.Position)
        local Distance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - MousePos).Magnitude
        if (OnScreen or AimbotSettings.Wallbang) and Distance < ClosestDistance and Distance <= AimbotSettings.FOV then
            ClosestDistance = Distance
            ClosestPlayer = Player
        end
    end
    return ClosestPlayer
end

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == AimbotSettings.TriggerKey then IsAiming = true end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == AimbotSettings.TriggerKey then
        IsAiming = false
        if not AimbotSettings.AimLock then Target = nil end
    end
end)

-- Autosave Config
coroutine.wrap(function()
    while true do
        saveConfig({Aimbot = AimbotSettings, ESP = ESPSettings, Rage = RageSettings, Visuals = VisualSettings, Misc = MiscSettings, Stats = StatsSettings})
        wait(60)
    end
end)()

-- Main Game Loop
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
            end
            Target = NewTarget
            LastLockOnTime = tick()
        end
        if Target and Target.Character then
            local AimPart = AimbotSettings.AimPart == "Head" and Target.Character:FindFirstChild("Head") or
                            AimbotSettings.AimPart == "Torso" and Target.Character:FindFirstChild("HumanoidRootPart") or
                            Target.Character:FindFirstChild("LeftLowerLeg")
            if AimPart then
                local TargetPos = AimPart.Position
                local ScreenPos, OnScreen = Camera:WorldToViewportPoint(TargetPos)
                if OnScreen or AimbotSettings.Wallbang then
                    local MousePos = UserInputService:GetMouseLocation()
                    local TargetScreenPos = Vector2.new(ScreenPos.X, ScreenPos.Y)
                    local Delta = (TargetScreenPos - MousePos) / AimbotSettings.Smoothing
                    if AimbotSettings.SilentAim and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool") then
                        local Tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                        if Tool and Tool:FindFirstChild("Fire") then
                            Tool.Fire:FireServer(TargetPos)
                        end
                    elseif IsAiming then
                        pcall(function() mousemoverel(Delta.X, Delta.Y) end)
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
                ESP.Tracer.Visible = false
                for _, line in pairs(ESP.Skeleton) do line.Visible = false end
                continue
            end
            local Character = Player.Character
            local RootPart = Character.HumanoidRootPart
            local Humanoid = Character.Humanoid
            local Distance = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) and (RootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude or math.huge
            local espColor = ESPSettings.TeamColors and Player.Team and Player.TeamColor.Color or ESPSettings.TextColor
            ESP.Gui.Enabled = Distance <= ESPSettings.MaxDistance
            ESP.Chams.Enabled = ESPSettings.Chams and Distance <= ESPSettings.MaxDistance
            ESP.Name.Text = ESPSettings.Names and Player.Name or ""
            ESP.Health.Text = ESPSettings.Health and ("HP: " .. math.floor(Humanoid.Health)) or ""
            ESP.Distance.Text = ESPSettings.Distance and ("Dist: " .. math.floor(Distance)) or ""
            ESP.Name.TextColor3 = espColor
            ESP.Health.TextColor3 = espColor
            ESP.Distance.TextColor3 = espColor
            ESP.Chams.FillColor = ESPSettings.ChamsColor
            ESP.Chams.OutlineColor = espColor
            if ESPSettings.Boxes3D and Distance <= ESPSettings.MaxDistance then
                local cframe, size = Character:GetBoundingBox()
                size = size * 0.5
                local corners = {
                    cframe * Vector3.new(-size.X,  size.Y, -size.Z),
                    cframe * Vector3.new( size.X,  size.Y, -size.Z),
                    cframe * Vector3.new( size.X, -size.Y, -size.Z),
                    cframe * Vector3.new(-size.X, -size.Y, -size.Z),
                    cframe * Vector3.new(-size.X,  size.Y,  size.Z),
                    cframe * Vector3.new( size.X,  size.Y,  size.Z),
                    cframe * Vector3.new( size.X, -size.Y,  size.Z),
                    cframe * Vector3.new(-size.X, -size.Y,  size.Z)
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
            if ESPSettings.Tracers and Distance <= ESPSettings.MaxDistance then
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
            if ESPSettings.Skeleton and Distance <= ESPSettings.MaxDistance then
                local bones = {
                    {"Head", "UpperTorso"},
                    {"UpperTorso", "LowerTorso"},
                    {"LowerTorso", "LeftUpperLeg"},
                    {"LowerTorso", "RightUpperLeg"},
                    {"LeftUpperLeg", "LeftLowerLeg"},
                    {"RightUpperLeg", "RightLowerLeg"},
                    {"UpperTorso", "LeftUpperArm"},
                    {"UpperTorso", "RightUpperArm"},
                    {"LeftUpperArm", "LeftLowerArm"},
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
    CrosshairH.Visible = VisualSettings.Crosshair
    CrosshairV.Visible = VisualSettings.Crosshair
    FOVCircle.Visible = VisualSettings.FOVCircle
    FOVCircle.Size = UDim2.new(0, VisualSettings.FOVCircleRadius * 2, 0, VisualSettings.FOVCircleRadius * 2)
    FOVCircle.Position = UDim2.new(0.5, -VisualSettings.FOVCircleRadius, 0.5, -VisualSettings.FOVCircleRadius)
    if VisualSettings.Fullbright then
        Lighting.Brightness = 2
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = 0
        Lighting.FogEnd = 100
        Lighting.GlobalShadows = true
    end
    if MiscSettings.FPSBoost then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic end
        end
    end
end)

-- Rage and Misc Logic
RunService.Heartbeat:Connect(function()
    if RageSettings.KillAura or RageSettings.RageMode then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            for _, Player in pairs(Players:GetPlayers()) do
                if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character:FindFirstChild("Humanoid") and Player.Character.Humanoid.Health > 0 then
                    local Distance = (Player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                    if Distance <= RageSettings.KillAuraRange then
                        pcall(function() Player.Character.Humanoid:TakeDamage(100) end)
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
    if RageSettings.Noclip and LocalPlayer.Character then
        for _, Part in pairs(LocalPlayer.Character:GetChildren()) do
            if Part:IsA("BasePart") then Part.CanCollide = false end
        end
    end
    if RageSettings.FlyHack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local Root = LocalPlayer.Character.HumanoidRootPart
        local BodyVelocity = Root:FindFirstChild("FlyVelocity") or Instance.new("BodyVelocity")
        BodyVelocity.Name = "FlyVelocity"
        BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        BodyVelocity.Velocity = Vector3.new(0, UserInputService:IsKeyDown(Enum.KeyCode.Space) and RageSettings.FlySpeed or UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and -RageSettings.FlySpeed or 0, 0)
        BodyVelocity.Parent = Root
    elseif LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local BodyVelocity = LocalPlayer.Character.HumanoidRootPart:FindFirstChild("FlyVelocity")
        if BodyVelocity then BodyVelocity:Destroy() end
    end
    if MiscSettings.SpinBot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(360 * 0.1), 0)
    end
    if MiscSettings.AntiAim and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(math.rad(math.random(-180, 180)), math.rad(math.random(-180, 180)), 0)
    end
end)

-- Initialize UI
TabContainers["Aimbot"].Visible = true
ActiveTab = TabContainers["Aimbot"]
TabFrame:GetChildren()[1].BackgroundTransparency = 0
TabFrame:GetChildren()[1].TextColor3 = Color3.fromRGB(108, 59, 170)
debugPrint("Chesco & Noxi v5.0 loaded!")
