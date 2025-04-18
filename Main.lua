-- Chesco & Noxi V.5.2.8
--     Credits to Chesco
--     Made for Me and Noxi
--     Hope you like it
--     Full Source Below:

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Camera = workspace.CurrentCamera
local Lighting = game:GetService("Lighting")

local function saveConfig(settings)
    local success, err = pcall(function() writefile("Chesco_Noxi_Config.json", HttpService:JSONEncode(settings)) end)
    if not success then warn("Failed to save config: " .. tostring(err)) end
end
local function loadConfig()
    local success, data = pcall(function() return HttpService:JSONDecode(readfile("Chesco_Noxi_Config.json")) end)
    return success and data or nil
end

local UI = Instance.new("ScreenGui")
UI.Name = "Chesco_Noxi_CheatUI_" .. math.random(1000, 9999)
UI.IgnoreGuiInset = true
UI.Parent = game.CoreGui or LocalPlayer.PlayerGui

local WelcomeFrame = Instance.new("Frame", UI)
WelcomeFrame.Size = UDim2.new(0, 250, 0, 120)
WelcomeFrame.Position = UDim2.new(0.5, -125, 0.5, -60)
WelcomeFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
WelcomeFrame.BackgroundTransparency = 0.1
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
OpenButton.TextColor3 = Color3.fromRGB(10, 10, 20)
OpenButton.TextSize = 16
OpenButton.Font = Enum.Font.GothamBold
local OpenCorner = Instance.new("UICorner", OpenButton)
OpenCorner.CornerRadius = UDim.new(0, 8)

local MainFrame = Instance.new("Frame", UI)
MainFrame.Size = UDim2.new(0, 450, 0, 350)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
MainFrame.BackgroundTransparency = 0.1
MainFrame.ClipsDescendants = false
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 12)
local Gradient = Instance.new("UIGradient", MainFrame)
Gradient.Color = ColorSequence.new(Color3.fromRGB(10, 10, 20), Color3.fromRGB(20, 20, 30))
local Shadow = Instance.new("UIStroke", MainFrame)
Shadow.Thickness = 2
Shadow.Color = Color3.fromRGB(0, 200, 200)
Shadow.Transparency = 0.5
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, -100, 0, 25)
Title.Position = UDim2.new(0, 10, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "Chesco & Noxi - v5.2.8"
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
local MinimizeButton = Instance.new("TextButton", MainFrame)
MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
MinimizeButton.Position = UDim2.new(1, -65, 0, 5)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(40, 60, 90)
MinimizeButton.Text = "–"
MinimizeButton.TextColor3 = Color3.fromRGB(200, 210, 220)
MinimizeButton.TextSize = 14
MinimizeButton.Font = Enum.Font.GothamBold
local MinimizeCorner = Instance.new("UICorner", MinimizeButton)
MinimizeCorner.CornerRadius = UDim.new(0, 5)

local TabFrame = Instance.new("Frame", MainFrame)
TabFrame.Size = UDim2.new(1, -10, 0, 35)
TabFrame.Position = UDim2.new(0, 5, 0, 35)
TabFrame.BackgroundColor3 = Color3.fromRGB(40, 60, 90)
local TabCorner = Instance.new("UICorner", TabFrame)
TabCorner.CornerRadius = UDim.new(0, 8)
local Tabs = {"Aimbot", "ESP", "Rage", "Visuals", "Misc", "Stats", "Config"}
local TabContainers = {}
local ActiveTab = nil
local IsMinimized = false

for i, tabName in ipairs(Tabs) do
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1/#Tabs, -2, 1, 0)
    TabButton.Position = UDim2.new((i-1)/#Tabs, 1, 0, 0)
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
    TabContainer.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    TabContainer.BackgroundTransparency = 0.1
    TabContainer.Visible = false
    TabContainer.ScrollBarThickness = 5
    TabContainer.ScrollBarImageColor3 = Color3.fromRGB(108, 59, 170)
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.Parent = MainFrame
    TabContainers[tabName] = TabContainer
    TabButton.MouseEnter:Connect(function()
        if ActiveTab ~= TabContainer then
            TweenService:Create(TabButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(1/#Tabs + 0.01, -2, 1, 2)}):Play()
        end
    end)
    TabButton.MouseLeave:Connect(function()
        if ActiveTab ~= TabContainer then
            TweenService:Create(TabButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(1/#Tabs, -2, 1, 0)}):Play()
        end
    end)
    TabButton.MouseButton1Click:Connect(function()
        if ActiveTab == TabContainer then return end
        if ActiveTab then ActiveTab.Visible = false end
        for _, child in pairs(TabFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundTransparency = child.Text == tabName and 0 or 0.5
                child.TextColor3 = child.Text == tabName and Color3.fromRGB(108, 59, 170) or Color3.fromRGB(200, 210, 220)
                TweenService:Create(child, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = child.Text == tabName and UDim2.new(1/#Tabs + 0.02, -2, 1, 5) or UDim2.new(1/#Tabs, -2, 1, 0)}):Play()
            end
        end
        ActiveTab = TabContainer
        ActiveTab.Visible = true
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

local AimbotSettings = {Enabled = false, SilentAim = false, AimLock = false, DynamicSmoothing = false, Smoothing = 1, FOV = 100, TriggerKey = Enum.UserInputType.MouseButton2, TeamCheck = true, Wallbang = false, AimPart = "Head"}
local ESPSettings = {Enabled = false, Names = true, Health = true, Distance = true, Chams = false, Boxes3D = true, Tracers = false, Skeleton = false, TeamColors = true, VisibleOnly = false, MaxDistance = 1000, TextColor = Color3.fromRGB(108, 59, 170), ChamsColor = Color3.fromRGB(0, 255, 0), Rainbow = false}
local RageSettings = {KillAura = false, KillAuraRange = 10, Noclip = false, FlyHack = false, FlySpeed = 50, AutoFarm = false, HitboxExpander = false, HitboxSize = 10, TriggerBot = false, TriggerDelay = 0.1, TriggerHumanoidCheck = true, BunnyHop = false}
local VisualSettings = {Crosshair = false, FOVCircle = false, FOVCircleRadius = 100, FOVCircleColor = Color3.fromRGB(108, 59, 170), NoFog = false}
local MiscSettings = {SpinBot = false, AntiAim = false, KillSound = false, Notifications = true, FPSBoost = false}
local StatsSettings = {LockOnTime = 0, TargetSwitches = 0, LastTargetSwitch = tick()}
local ConfigSettings = {Aimbot = AimbotSettings, ESP = ESPSettings, Rage = RageSettings, Visuals = VisualSettings, Misc = MiscSettings, Stats = StatsSettings}

local loadedConfig = loadConfig()
if loadedConfig then
    for key, settings in pairs(loadedConfig) do
        if ConfigSettings[key] then
            for setting, value in pairs(settings) do
                if ConfigSettings[key][setting] ~= nil then
                    ConfigSettings[key][setting] = value
                end
            end
        end
    end
end

local Connections = {}
local function cleanup()
    AimbotSettings.Enabled = false
    ESPSettings.Enabled = false
    RageSettings.KillAura = false
    RageSettings.Noclip = false
    RageSettings.FlyHack = false
    RageSettings.HitboxExpander = false
    RageSettings.TriggerBot = false
    RageSettings.BunnyHop = false
    VisualSettings.Crosshair = false
    VisualSettings.FOVCircle = false
    VisualSettings.NoFog = false
    MiscSettings.SpinBot = false
    MiscSettings.AntiAim = false
    MiscSettings.FPSBoost = false
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
    if UI then UI:Destroy() end
end
CloseButton.MouseButton1Click:Connect(cleanup)
MinimizeButton.MouseButton1Click:Connect(function()
    IsMinimized = not IsMinimized
    TabFrame.Visible = not IsMinimized
    for _, container in pairs(TabContainers) do
        container.Visible = not IsMinimized and container == ActiveTab
    end
    StatusLabel.Visible = not IsMinimized
    FPSLabel.Visible = not IsMinimized
    MainFrame.Size = IsMinimized and UDim2.new(0, 450, 0, 40) or UDim2.new(0, 450, 0, 350)
    MinimizeButton.Text = IsMinimized and "+" or "–"
end)
OpenButton.MouseButton1Click:Connect(function()
    WelcomeFrame.Visible = false
    MainFrame.Visible = true
    TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {BackgroundTransparency = 0}):Play()
end)
Connections[#Connections + 1] = UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F1 then
        MainFrame.Visible = not MainFrame.Visible
        WelcomeFrame.Visible = not MainFrame.Visible
    end
end)

local NotifFrame = Instance.new("Frame", UI)
local NotifLabel = Instance.new("TextLabel", NotifFrame)
local function showNotification(message, color)
    if not MiscSettings.Notifications then return end
    NotifFrame.Size = UDim2.new(0, 150, 0, 40)
    NotifFrame.Position = UDim2.new(1, -170, 1, -50)
    NotifFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    NotifFrame.BackgroundTransparency = 0.2
    local NotifCorner = Instance.new("UICorner", NotifFrame)
    NotifCorner.CornerRadius = UDim.new(0, 8)
    NotifLabel.Size = UDim2.new(1, 0, 1, 0)
    NotifLabel.BackgroundTransparency = 1
    NotifLabel.Text = message
    NotifLabel.TextColor3 = color or Color3.fromRGB(108, 59, 170)
    NotifLabel.TextSize = 12
    NotifLabel.Font = Enum.Font.Gotham
    NotifFrame.Visible = true
    TweenService:Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {Position = UDim2.new(1, -160, 1, -50)}):Play()
    wait(2)
    NotifFrame.Visible = false
end

local function createUIElement(type, label, setting, callback, parent, yPos, extra)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -10, 0, type == "slider" and 45 or 30)
    Frame.Position = UDim2.new(0, 5, 0, yPos)
    Frame.BackgroundTransparency = 1
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(0.7, 0, type == "slider" and 0 or 1, type == "slider" and 20 or 0)
    Label.BackgroundTransparency = 1
    Label.Text = label .. (type == "slider" and ": " .. setting or "")
    Label.TextColor3 = Color3.fromRGB(200, 210, 220)
    Label.TextSize = 14
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    if type == "toggle" then
        local ToggleButton = Instance.new("TextButton", Frame)
        ToggleButton.Size = UDim2.new(0.15, 0, 0.7, 0)
        ToggleButton.Position = UDim2.new(0.85, 0, 0.15, 0)
        ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 60, 90)
        ToggleButton.Text = ""
        local Corner = Instance.new("UICorner", ToggleButton)
        Corner.CornerRadius = UDim.new(0, 5)
        local Shadow = Instance.new("UIStroke", ToggleButton)
        Shadow.Thickness = 1
        Shadow.Color = Color3.fromRGB(0, 200, 200)
        Shadow.Transparency = 0.7
        local ToggleIndicator = Instance.new("Frame", ToggleButton)
        ToggleIndicator.Size = UDim2.new(0.4, 0, 0.8, 0)
        ToggleIndicator.Position = setting and UDim2.new(0.55, 0, 0.1, 0) or UDim2.new(0.05, 0, 0.1, 0)
        ToggleIndicator.BackgroundColor3 = setting and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 200, 200)
        local IndicatorCorner = Instance.new("UICorner", ToggleIndicator)
        IndicatorCorner.CornerRadius = UDim.new(0, 5)
        ToggleButton.MouseEnter:Connect(function()
            TweenService:Create(ToggleButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(0.16, 0, 0.75, 0)}):Play()
        end)
        ToggleButton.MouseLeave:Connect(function()
            TweenService:Create(ToggleButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(0.15, 0, 0.7, 0)}):Play()
        end)
        ToggleButton.MouseButton1Click:Connect(function()
            setting = not setting
            callback(setting)
            TweenService:Create(ToggleIndicator, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Position = setting and UDim2.new(0.55, 0, 0.1, 0) or UDim2.new(0.05, 0, 0.1, 0),
                BackgroundColor3 = setting and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 200, 200)
            }):Play()
            showNotification(label .. " " .. (setting and "Enabled" or "Disabled"), setting and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
        end)
    elseif type == "slider" then
        local Slider = Instance.new("TextButton", Frame)
        Slider.Size = UDim2.new(1, 0, 0, 8)
        Slider.Position = UDim2.new(0, 0, 0, 25)
        Slider.BackgroundColor3 = Color3.fromRGB(40, 60, 90)
        Slider.Text = ""
        local SliderCorner = Instance.new("UICorner", Slider)
        SliderCorner.CornerRadius = UDim.new(0, 4)
        local Shadow = Instance.new("UIStroke", Slider)
        Shadow.Thickness = 1
        Shadow.Color = Color3.fromRGB(0, 200, 200)
        Shadow.Transparency = 0.7
        local SliderFill = Instance.new("Frame", Slider)
        SliderFill.Size = UDim2.new((setting - extra.min) / (extra.max - extra.min), 0, 1, 0)
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
                local value = extra.min + (extra.max - extra.min) * fraction
                value = math.floor(value * 10) / 10
                SliderFill.Size = UDim2.new(fraction, 0, 1, 0)
                Label.Text = label .. ": " .. value
                callback(value)
            end
        end)
    elseif type == "dropdown" then
        local DropdownButton = Instance.new("TextButton", Frame)
        DropdownButton.Size = UDim2.new(0.15, 0, 0.7, 0)
        DropdownButton.Position = UDim2.new(0.85, 0, 0.15, 0)
        DropdownButton.BackgroundColor3 = Color3.fromRGB(40, 60, 90)
        DropdownButton.Text = "▼"
        DropdownButton.TextColor3 = Color3.fromRGB(200, 210, 220)
        DropdownButton.TextSize = 12
        local DropdownCorner = Instance.new("UICorner", DropdownButton)
        DropdownCorner.CornerRadius = UDim.new(0, 5)
        local Shadow = Instance.new("UIStroke", DropdownButton)
        Shadow.Thickness = 1
        Shadow.Color = Color3.fromRGB(0, 200, 200)
        Shadow.Transparency = 0.7
        local DropdownMenu = Instance.new("Frame", Frame)
        DropdownMenu.Size = UDim2.new(0.2, 0, 0, #extra.options * 30)
        DropdownMenu.Position = UDim2.new(0.8, 0, 1, 5)
        DropdownMenu.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
        DropdownMenu.Visible = false
        DropdownMenu.ClipsDescendants = false
        local MenuCorner = Instance.new("UICorner", DropdownMenu)
        MenuCorner.CornerRadius = UDim.new(0, 5)
        local MenuShadow = Instance.new("UIStroke", DropdownMenu)
        MenuShadow.Thickness = 1
        MenuShadow.Color = Color3.fromRGB(0, 200, 200)
        MenuShadow.Transparency = 0.7
        for i, option in ipairs(extra.options) do
            local OptionButton = Instance.new("TextButton", DropdownMenu)
            OptionButton.Size = UDim2.new(1, 0, 0, 30)
            OptionButton.Position = UDim2.new(0, 0, 0, (i-1) * 30)
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
end

createUIElement("toggle", "Aimbot", AimbotSettings.Enabled, function(v) AimbotSettings.Enabled = v end, TabContainers["Aimbot"], 0)
createUIElement("toggle", "Silent Aim", AimbotSettings.SilentAim, function(v) AimbotSettings.SilentAim = v end, TabContainers["Aimbot"], 40)
createUIElement("toggle", "Aim Lock", AimbotSettings.AimLock, function(v) AimbotSettings.AimLock = v end, TabContainers["Aimbot"], 80)
createUIElement("toggle", "Dynamic Smoothing", AimbotSettings.DynamicSmoothing, function(v) AimbotSettings.DynamicSmoothing = v end, TabContainers["Aimbot"], 120)
createUIElement("toggle", "Team Check", AimbotSettings.TeamCheck, function(v) AimbotSettings.TeamCheck = v end, TabContainers["Aimbot"], 160)
createUIElement("toggle", "Wallbang", AimbotSettings.Wallbang, function(v) AimbotSettings.Wallbang = v end, TabContainers["Aimbot"], 200)
createUIElement("slider", "Smoothing", AimbotSettings.Smoothing, function(v) AimbotSettings.Smoothing = v end, TabContainers["Aimbot"], 240, {min = 1, max = 10})
createUIElement("slider", "FOV", AimbotSettings.FOV, function(v) AimbotSettings.FOV = v end, TabContainers["Aimbot"], 295, {min = 10, max = 300})
createUIElement("dropdown", "Aim Part", AimbotSettings.AimPart, function(v) AimbotSettings.AimPart = v end, TabContainers["Aimbot"], 350, {options = {"Head", "UpperTorso", "LowerTorso", "LeftArm", "RightArm", "LeftLeg", "RightLeg"}})
TabContainers["Aimbot"].CanvasSize = UDim2.new(0, 0, 0, 390)
createUIElement("toggle", "ESP Enabled", ESPSettings.Enabled, function(v) ESPSettings.Enabled = v end, TabContainers["ESP"], 0)
createUIElement("toggle", "Names", ESPSettings.Names, function(v) ESPSettings.Names = v end, TabContainers["ESP"], 40)
createUIElement("toggle", "Health", ESPSettings.Health, function(v) ESPSettings.Health = v end, TabContainers["ESP"], 80)
createUIElement("toggle", "Distance", ESPSettings.Distance, function(v) ESPSettings.Distance = v end, TabContainers["ESP"], 120)
createUIElement("toggle", "Chams", ESPSettings.Chams, function(v) ESPSettings.Chams = v end, TabContainers["ESP"], 160)
createUIElement("toggle", "3D Boxes", ESPSettings.Boxes3D, function(v) ESPSettings.Boxes3D = v end, TabContainers["ESP"], 200)
createUIElement("toggle", "Tracers", ESPSettings.Tracers, function(v) ESPSettings.Tracers = v end, TabContainers["ESP"], 240)
createUIElement("toggle", "Skeleton", ESPSettings.Skeleton, function(v) ESPSettings.Skeleton = v end, TabContainers["ESP"], 280)
createUIElement("toggle", "Team Colors", ESPSettings.TeamColors, function(v) ESPSettings.TeamColors = v end, TabContainers["ESP"], 320)
createUIElement("toggle", "Visible Only", ESPSettings.VisibleOnly, function(v) ESPSettings.VisibleOnly = v end, TabContainers["ESP"], 360)
createUIElement("toggle", "Rainbow", ESPSettings.Rainbow, function(v) ESPSettings.Rainbow = v end, TabContainers["ESP"], 400)
TabContainers["ESP"].CanvasSize = UDim2.new(0, 0, 0, 440)
createUIElement("toggle", "Kill Aura", RageSettings.KillAura, function(v) RageSettings.KillAura = v end, TabContainers["Rage"], 0)
createUIElement("slider", "Kill Aura Range", RageSettings.KillAuraRange, function(v) RageSettings.KillAuraRange = v end, TabContainers["Rage"], 40, {min = 5, max = 50})
createUIElement("toggle", "Noclip", RageSettings.Noclip, function(v) RageSettings.Noclip = v end, TabContainers["Rage"], 95)
createUIElement("toggle", "Fly Hack", RageSettings.FlyHack, function(v) RageSettings.FlyHack = v end, TabContainers["Rage"], 135)
createUIElement("slider", "Fly Speed", RageSettings.FlySpeed, function(v) RageSettings.FlySpeed = v end, TabContainers["Rage"], 190, {min = 10, max = 100})
createUIElement("toggle", "Auto-Farm", RageSettings.AutoFarm, function(v) RageSettings.AutoFarm = v end, TabContainers["Rage"], 245)
createUIElement("toggle", "Hitbox Expander", RageSettings.HitboxExpander, function(v) RageSettings.HitboxExpander = v end, TabContainers["Rage"], 285)
createUIElement("slider", "Hitbox Size", RageSettings.HitboxSize, function(v) RageSettings.HitboxSize = v end, TabContainers["Rage"], 325, {min = 5, max = 20})
createUIElement("toggle", "TriggerBot", RageSettings.TriggerBot, function(v) RageSettings.TriggerBot = v end, TabContainers["Rage"], 380)
createUIElement("slider", "Trigger Delay", RageSettings.TriggerDelay, function(v) RageSettings.TriggerDelay = v end, TabContainers["Rage"], 420, {min = 0.1, max = 1})
createUIElement("toggle", "Trigger Humanoid Check", RageSettings.TriggerHumanoidCheck, function(v) RageSettings.TriggerHumanoidCheck = v end, TabContainers["Rage"], 475)
createUIElement("toggle", "Bunny Hop", RageSettings.BunnyHop, function(v) RageSettings.BunnyHop = v end, TabContainers["Rage"], 515)
TabContainers["Rage"].CanvasSize = UDim2.new(0, 0, 0, 555)
createUIElement("toggle", "Crosshair", VisualSettings.Crosshair, function(v) VisualSettings.Crosshair = v end, TabContainers["Visuals"], 0)
createUIElement("toggle", "FOV Circle", VisualSettings.FOVCircle, function(v) VisualSettings.FOVCircle = v end, TabContainers["Visuals"], 40)
createUIElement("slider", "FOV Circle Radius", VisualSettings.FOVCircleRadius, function(v) VisualSettings.FOVCircleRadius = v end, TabContainers["Visuals"], 80, {min = 50, max = 200})
createUIElement("toggle", "No Fog", VisualSettings.NoFog, function(v) VisualSettings.NoFog = v end, TabContainers["Visuals"], 135)
TabContainers["Visuals"].CanvasSize = UDim2.new(0, 0, 0, 175)
createUIElement("toggle", "Spin Bot", MiscSettings.SpinBot, function(v) MiscSettings.SpinBot = v end, TabContainers["Misc"], 0)
createUIElement("toggle", "Anti-Aim", MiscSettings.AntiAim, function(v) MiscSettings.AntiAim = v end, TabContainers["Misc"], 40)
createUIElement("toggle", "Kill Sound", MiscSettings.KillSound, function(v) MiscSettings.KillSound = v end, TabContainers["Misc"], 80)
createUIElement("toggle", "Notifications", MiscSettings.Notifications, function(v) MiscSettings.Notifications = v end, TabContainers["Misc"], 120)
createUIElement("toggle", "FPS Boost", MiscSettings.FPSBoost, function(v) MiscSettings.FPSBoost = v end, TabContainers["Misc"], 160)
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
SaveButton.TextColor3 = Color3.fromRGB(10, 10, 20)
SaveButton.TextSize = 14
SaveButton.Font = Enum.Font.GothamBold
local SaveCorner = Instance.new("UICorner", SaveButton)
SaveCorner.CornerRadius = UDim.new(0, 5)
local LoadButton = Instance.new("TextButton", TabContainers["Config"])
LoadButton.Size = UDim2.new(1, -40, 0, 30)
LoadButton.Position = UDim2.new(0, 20, 0, 45)
LoadButton.BackgroundColor3 = Color3.fromRGB(0, 200, 200)
LoadButton.Text = "Load Config"
LoadButton.TextColor3 = Color3.fromRGB(10, 10, 20)
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
                    if ConfigSettings[key][setting] ~= nil then
                        ConfigSettings[key][setting] = value
                    end
                end
            end
        end
        showNotification("Config Loaded!", Color3.fromRGB(0, 255, 0))
    else
        showNotification("Failed to Load Config", Color3.fromRGB(255, 0, 0))
    end
end)
TabContainers["Config"].CanvasSize = UDim2.new(0, 0, 0, 80)

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
FOVCircle.Size = UDim2.new(0, VisualSettings.FOVCircleRadius * 2, 0, VisualSettings.FOVCircleRadius * 2)
FOVCircle.Position = UDim2.new(0.5, -VisualSettings.FOVCircleRadius, 0.5, -VisualSettings.FOVCircleRadius)
FOVCircle.BackgroundTransparency = 1
FOVCircle.Image = "rbxassetid://494929581"
FOVCircle.ImageColor3 = VisualSettings.FOVCircleColor
FOVCircle.Visible = false

local lastFrame = tick()
local Target = nil
local IsAiming = false
local ESPInstances = {}
local Hue = 0
local LastLockOnTime = tick()
local LastTriggerTime = 0

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
end)

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

for _, Player in pairs(Players:GetPlayers()) do
    pcall(function() CreateESP(Player) end)
end
Connections[#Connections + 1] = Players.PlayerAdded:Connect(function(Player) pcall(function() CreateESP(Player) end) end)

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
        local PredictedPos = AimPart.Position + Velocity * 0.1
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

Connections[#Connections + 1] = UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == AimbotSettings.TriggerKey then IsAiming = true end
end)
Connections[#Connections + 1] = UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == AimbotSettings.TriggerKey then
        IsAiming = false
        if not AimbotSettings.AimLock then Target = nil end
    end
end)

Connections[#Connections + 1] = RunService.RenderStepped:Connect(function()
    local current = tick()
    FPSLabel.Text = "FPS: " .. math.floor(1 / (current - lastFrame))
    lastFrame = current
    local activeFeatures = {}
    if AimbotSettings.Enabled then table.insert(activeFeatures, "Aimbot") end
    if ESPSettings.Enabled then table.insert(activeFeatures, "ESP") end
    if RageSettings.KillAura or RageSettings.FlyHack or RageSettings.TriggerBot or RageSettings.BunnyHop then table.insert(activeFeatures, "Rage") end
    StatusLabel.Text = #activeFeatures > 0 and "Active: " .. table.concat(activeFeatures, ", ") or "Status: Inactive"
    if ESPSettings.Rainbow then
        Hue = (Hue + 0.05) % 1
        ESPSettings.TextColor = Color3.fromHSV(Hue, 1, 1)
        ESPSettings.ChamsColor = Color3.fromHSV(Hue, 1, 1)
        VisualSettings.FOVCircleColor = Color3.fromHSV(Hue, 1, 1)
    end
    if AimbotSettings.Enabled or RageSettings.TriggerBot then
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
            local TargetPos = AimPart.Position + Velocity * 0.1
            local ScreenPos, OnScreen = Camera:WorldToViewportPoint(TargetPos)
            if OnScreen or AimbotSettings.Wallbang then
                local MousePos = UserInputService:GetMouseLocation()
                local TargetScreenPos = Vector2.new(ScreenPos.X, ScreenPos.Y)
                local EffectiveSmoothing = AimbotSettings.Smoothing
                local Delta = (TargetScreenPos - MousePos) / EffectiveSmoothing
                if RageSettings.TriggerBot and (tick() - LastTriggerTime) >= RageSettings.TriggerDelay and LocalPlayer.Character then
                    pcall(function() mouse1press() wait() mouse1release() end)
                    LastTriggerTime = tick()
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
    CrosshairH.Visible = VisualSettings.Crosshair
    CrosshairV.Visible = VisualSettings.Crosshair
    FOVCircle.Visible = VisualSettings.FOVCircle
    FOVCircle.Size = UDim2.new(0, VisualSettings.FOVCircleRadius * 2, 0, VisualSettings.FOVCircleRadius * 2)
    FOVCircle.Position = UDim2.new(0.5, -VisualSettings.FOVCircleRadius, 0.5, -VisualSettings.FOVCircleRadius)
    if VisualSettings.NoFog then
        Lighting.FogEnd = 100000
    else
        Lighting.FogEnd = 100
    end
    if MiscSettings.FPSBoost then
        pcall(function()
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and v ~= LocalPlayer.Character then
                    v.Material = Enum.Material.SmoothPlastic
                end
            end
        end)
    end
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
                            showNotification("Killed " .. Player.Name, Color3.fromRGB(255, 0, 0))
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

TabContainers["Aimbot"].Visible = true
ActiveTab = TabContainers["Aimbot"]
TabFrame:GetChildren()[1].BackgroundTransparency = 0
TabFrame:GetChildren()[1].TextColor3 = Color3.fromRGB(108, 59, 170)
