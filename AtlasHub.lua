local AtlasHub = {}
AtlasHub.__index = AtlasHub

local Services = {
    Players = game:GetService("Players"),
    TweenService = game:GetService("TweenService"),
    UserInputService = game:GetService("UserInputService"),
    RunService = game:GetService("RunService")
}

local Player = Services.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Config = {
    ParticleCount = 60,
    ParticleSpeed = 60
}

local Colors = {
    Background = Color3.fromRGB(18, 18, 22),
    Surface = Color3.fromRGB(25, 25, 30),
    Primary = Color3.fromRGB(45, 45, 50),
    Secondary = Color3.fromRGB(35, 35, 40),
    Border = Color3.fromRGB(40, 40, 45),
    TextPrimary = Color3.fromRGB(220, 220, 225),
    TextSecondary = Color3.fromRGB(140, 140, 150),
    Success = Color3.fromRGB(25, 135, 84),
    Error = Color3.fromRGB(180, 50, 50),
    Accent = Color3.fromRGB(40, 140, 100),
    HoverPrimary = Color3.fromRGB(55, 55, 60),
    HoverAccent = Color3.fromRGB(30, 120, 80),
    NeonWhite = Color3.fromRGB(255, 255, 255),
    NeonGlow = Color3.fromRGB(240, 248, 255)
}

local function CreateParticleContainer(parent)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.ZIndex = 105
    container.Selectable = false
    container.Parent = parent
    return container
end

local function CreateParticle(state, container)
    if not container or not container.Parent or state.IsDestroyed then
        return nil
    end

    local size = math.random(8, 24)
    local particle = Instance.new("Frame")
    particle.Size = UDim2.new(0, size, 0, size)
    particle.Position = UDim2.new(math.random() * 1.4 - 0.2, 0, 1.2, 0)
    particle.BackgroundColor3 = Colors.NeonWhite
    particle.BackgroundTransparency = math.random(60, 85) / 100
    particle.BorderSizePixel = 0
    particle.ZIndex = 106
    particle.Selectable = false
    particle.Parent = container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = particle

    local gradient = Instance.new("UIGradient")
    local bubbleColors = {
        Color3.fromRGB(200, 230, 255),
        Color3.fromRGB(180, 220, 255),
        Color3.fromRGB(220, 240, 255),
        Color3.fromRGB(190, 210, 240)
    }
    local color1 = bubbleColors[math.random(#bubbleColors)]
    local color2 = bubbleColors[math.random(#bubbleColors)]

    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, color1),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.7, color2),
        ColorSequenceKeypoint.new(1, color1)
    }
    gradient.Rotation = math.random(0, 360)
    gradient.Parent = particle

    local highlight = Instance.new("Frame")
    highlight.Size = UDim2.new(0.3, 0, 0.3, 0)
    highlight.Position = UDim2.new(0.2, 0, 0.15, 0)
    highlight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    highlight.BackgroundTransparency = 0.3
    highlight.BorderSizePixel = 0
    highlight.ZIndex = particle.ZIndex + 1
    highlight.Parent = particle

    local highlightCorner = Instance.new("UICorner")
    highlightCorner.CornerRadius = UDim.new(1, 0)
    highlightCorner.Parent = highlight

    local glow = Instance.new("Frame")
    glow.Size = UDim2.new(1.8, 0, 1.8, 0)
    glow.Position = UDim2.new(-0.4, 0, -0.4, 0)
    glow.BackgroundColor3 = Color3.fromRGB(200, 230, 255)
    glow.BackgroundTransparency = 0.9
    glow.BorderSizePixel = 0
    glow.ZIndex = particle.ZIndex - 1
    glow.Parent = particle

    local glowCorner = Instance.new("UICorner")
    glowCorner.CornerRadius = UDim.new(1, 0)
    glowCorner.Parent = glow

    local particleData = {
        frame = particle,
        vx = (math.random() - 0.5) * 0.004,
        vy = -math.random(20, 50) / 10000,
        created = tick(),
        rotation = 0,
        rotationSpeed = (math.random() - 0.5) * 2,
        pulsePhase = math.random() * math.pi * 2,
        driftPhase = math.random() * math.pi * 2,
        originalTransparency = particle.BackgroundTransparency,
        glow = glow,
        highlight = highlight,
        lifetime = math.random(30, 60),
        originalSize = size,
        wobblePhase = math.random() * math.pi * 2
    }

    table.insert(state.Particles, particleData)
    return particleData
end

local function UpdateParticles(state)
    local now = tick()
    for i = #state.Particles, 1, -1 do
        local p = state.Particles[i]
        local age = now - p.created
        if age > p.lifetime or not p.frame.Parent then
            p.frame:Destroy()
            table.remove(state.Particles, i)
        else
            local pos = p.frame.Position
            local wobble = math.sin(now * 2 + p.wobblePhase) * 0.001
            p.frame.Position = UDim2.new(pos.X.Scale + p.vx + wobble, 0, pos.Y.Scale + p.vy, 0)
        end
    end
end

local function CreateButtonGlow(button, hoverColor, normalColor)
    button.MouseEnter:Connect(function()
        Services.TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = hoverColor}):Play()
    end)
    button.MouseLeave:Connect(function()
        Services.TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = normalColor}):Play()
    end)
end

function AtlasHub:CreateWindow(config)
    config = config or {}
    local self = setmetatable({}, AtlasHub)

    self.State = {
        Particles = {},
        IsDestroyed = false
    }

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AtlasHub"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.IgnoreGuiInset = true
    screenGui.DisplayOrder = 100
    screenGui.Parent = PlayerGui

    local backdrop = Instance.new("Frame")
    backdrop.Name = "Backdrop"
    backdrop.Size = UDim2.new(1, 0, 1, 0)
    backdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    backdrop.BackgroundTransparency = 1
    backdrop.BorderSizePixel = 0
    backdrop.ZIndex = 100
    backdrop.Parent = screenGui

    local particleContainer = CreateParticleContainer(backdrop)

    local container = Instance.new("Frame")
    container.Name = "MainContainer"
    container.Size = UDim2.new(0, 420, 0, 600)
    container.Position = UDim2.new(0.5, -210, 0.5, -300)
    container.BackgroundColor3 = Colors.Background
    container.BorderSizePixel = 0
    container.ZIndex = 110
    container.Active = true
    container.Parent = screenGui

    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 20)
    containerCorner.Parent = container

    local containerStroke = Instance.new("UIStroke")
    containerStroke.Color = Colors.Border
    containerStroke.Thickness = 1
    containerStroke.Transparency = 0.3
    containerStroke.Parent = container

    local animBorder = Instance.new("Frame")
    animBorder.Name = "AnimatedBorder"
    animBorder.Size = UDim2.new(1, 6, 1, 6)
    animBorder.Position = UDim2.new(0, -3, 0, -3)
    animBorder.BackgroundTransparency = 1
    animBorder.ZIndex = 109
    animBorder.Selectable = false
    animBorder.Parent = container

    local animBorderCorner = Instance.new("UICorner")
    animBorderCorner.CornerRadius = UDim.new(0, 23)
    animBorderCorner.Parent = animBorder

    local animBorderStroke = Instance.new("UIStroke")
    animBorderStroke.Color = Colors.NeonWhite
    animBorderStroke.Thickness = 2
    animBorderStroke.Transparency = 0.3
    animBorderStroke.Parent = animBorder

    local animBorderGradient = Instance.new("UIGradient")
    animBorderGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Colors.NeonWhite),
        ColorSequenceKeypoint.new(0.5, Colors.NeonGlow),
        ColorSequenceKeypoint.new(1, Colors.NeonWhite)
    }
    animBorderGradient.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0.9),
        NumberSequenceKeypoint.new(0.2, 0.1),
        NumberSequenceKeypoint.new(0.8, 0.1),
        NumberSequenceKeypoint.new(1, 0.9)
    }
    animBorderGradient.Parent = animBorderStroke

    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 90)
    header.BackgroundTransparency = 1
    header.ZIndex = 111
    header.Selectable = false
    header.Parent = container

    local iconContainer = Instance.new("Frame")
    iconContainer.Size = UDim2.new(0, 56, 0, 56)
    iconContainer.Position = UDim2.new(0.5, -28, 0, 20)
    iconContainer.BackgroundColor3 = Colors.Primary
    iconContainer.BorderSizePixel = 0
    iconContainer.ZIndex = 112
    iconContainer.Selectable = false
    iconContainer.Parent = header

    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(0, 14)
    iconCorner.Parent = iconContainer

    local iconGlow = Instance.new("Frame")
    iconGlow.Size = UDim2.new(1, 12, 1, 12)
    iconGlow.Position = UDim2.new(0, -6, 0, -6)
    iconGlow.BackgroundTransparency = 1
    iconGlow.ZIndex = 111
    iconGlow.Selectable = false
    iconGlow.Parent = iconContainer

    local glowCorner = Instance.new("UICorner")
    glowCorner.CornerRadius = UDim.new(0, 20)
    glowCorner.Parent = iconGlow

    local glowStroke = Instance.new("UIStroke")
    glowStroke.Color = Colors.NeonWhite
    glowStroke.Thickness = 3
    glowStroke.Transparency = 0.2
    glowStroke.Parent = iconGlow

    local glowGradient = Instance.new("UIGradient")
    glowGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Colors.NeonWhite),
        ColorSequenceKeypoint.new(0.5, Colors.NeonGlow),
        ColorSequenceKeypoint.new(1, Colors.NeonWhite)
    }
    glowGradient.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0.8),
        NumberSequenceKeypoint.new(0.2, 0.05),
        NumberSequenceKeypoint.new(0.8, 0.05),
        NumberSequenceKeypoint.new(1, 0.8)
    }
    glowGradient.Parent = glowStroke

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 22)
    titleLabel.Position = UDim2.new(0, 0, 0, 62)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = config.Title or "AtlasHub"
    titleLabel.TextColor3 = Colors.TextPrimary
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center
    titleLabel.ZIndex = 111
    titleLabel.Parent = header

    local content = Instance.new("ScrollingFrame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -64, 1, -110)
    content.Position = UDim2.new(0, 32, 0, 100)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 3
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    content.ZIndex = 111
    content.Parent = container

    local contentList = Instance.new("UIListLayout")
    contentList.Padding = UDim.new(0, 10)
    contentList.SortOrder = Enum.SortOrder.LayoutOrder
    contentList.Parent = content

    local Dragging, DragStart, StartPos = false, nil, nil
    header.Active = true
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPos = container.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    header.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and Dragging then
            local delta = input.Position - DragStart
            container.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + delta.X, StartPos.Y.Scale, StartPos.Y.Offset + delta.Y)
        end
    end)

    self.ScreenGui = screenGui
    self.Backdrop = backdrop
    self.Container = container
    self.Content = content
    self.AnimatedBorder = {Frame = animBorder, Gradient = animBorderGradient}
    self.Header = {IconGlow = glowGradient}

    task.spawn(function()
        for i = 1, 25 do
            if self.State.IsDestroyed then break end
            CreateParticle(self.State, particleContainer)
            task.wait(math.random(20, 100) / 1000)
        end
        while not self.State.IsDestroyed and screenGui.Parent do
            if #self.State.Particles < Config.ParticleCount then
                CreateParticle(self.State, particleContainer)
            end
            task.wait(math.random(400, 1200) / 1000)
        end
    end)

    task.spawn(function()
        while not self.State.IsDestroyed and screenGui.Parent do
            pcall(UpdateParticles, self.State)
            task.wait(1 / Config.ParticleSpeed)
        end
    end)

    task.spawn(function()
        while not self.State.IsDestroyed and animBorder.Parent do
            local startRotation = animBorderGradient.Rotation
            local tween = Services.TweenService:Create(animBorderGradient, TweenInfo.new(4, Enum.EasingStyle.Linear), {Rotation = startRotation + 360})
            tween:Play()
            local success = pcall(function()
                tween.Completed:Wait()
            end)
            if not success then
                task.wait(4)
            end
            if animBorderGradient.Parent then
                animBorderGradient.Rotation = animBorderGradient.Rotation % 360
            end
            task.wait(0.1)
        end
    end)

    task.spawn(function()
        while not self.State.IsDestroyed and glowGradient.Parent do
            local startRotation = glowGradient.Rotation
            local tween = Services.TweenService:Create(glowGradient, TweenInfo.new(3, Enum.EasingStyle.Linear), {Rotation = startRotation + 360})
            tween:Play()
            local success = pcall(function()
                tween.Completed:Wait()
            end)
            if not success then
                task.wait(3)
            end
            if glowGradient.Parent then
                glowGradient.Rotation = glowGradient.Rotation % 360
            end
            task.wait(0.1)
        end
    end)

    container.Size = UDim2.new(0, 0, 0, 0)
    container.BackgroundTransparency = 1
    Services.TweenService:Create(backdrop, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.1}):Play()
    task.wait(0.1)
    Services.TweenService:Create(container, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 420, 0, 600), BackgroundTransparency = 0}):Play()

    return self
end

function AtlasHub:AddButton(config)
    config = config or {}
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 48)
    button.BackgroundColor3 = Colors.Primary
    button.BorderSizePixel = 0
    button.Text = config.Name or "Button"
    button.TextColor3 = Colors.TextPrimary
    button.TextSize = 16
    button.Font = Enum.Font.GothamMedium
    button.AutoButtonColor = false
    button.ZIndex = 112
    button.LayoutOrder = #self.Content:GetChildren()
    button.Parent = self.Content

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = button

    CreateButtonGlow(button, Colors.HoverPrimary, Colors.Primary)

    button.MouseButton1Click:Connect(function()
        if config.Callback then
            config.Callback()
        end
    end)

    return button
end

function AtlasHub:AddToggle(config)
    config = config or {}
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, 0, 0, 48)
    holder.BackgroundColor3 = Colors.Surface
    holder.BorderSizePixel = 0
    holder.ZIndex = 112
    holder.LayoutOrder = #self.Content:GetChildren()
    holder.Parent = self.Content

    local holderCorner = Instance.new("UICorner")
    holderCorner.CornerRadius = UDim.new(0, 12)
    holderCorner.Parent = holder

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 16, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = config.Name or "Toggle"
    label.TextColor3 = Colors.TextPrimary
    label.TextSize = 15
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 113
    label.Parent = holder

    local track = Instance.new("Frame")
    track.Size = UDim2.new(0, 42, 0, 22)
    track.Position = UDim2.new(1, -56, 0.5, -11)
    track.BackgroundColor3 = Colors.Secondary
    track.BorderSizePixel = 0
    track.ZIndex = 113
    track.Parent = holder

    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0, 6)
    trackCorner.Parent = track

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = UDim2.new(0, 2, 0.5, -9)
    knob.BackgroundColor3 = Colors.TextPrimary
    knob.BorderSizePixel = 0
    knob.ZIndex = 114
    knob.Parent = track

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(0, 4)
    knobCorner.Parent = knob

    local clickArea = Instance.new("TextButton")
    clickArea.Size = UDim2.new(1, 0, 1, 0)
    clickArea.BackgroundTransparency = 1
    clickArea.Text = ""
    clickArea.ZIndex = 115
    clickArea.Parent = track

    local state = config.Default or false

    local function Update()
        if state then
            Services.TweenService:Create(track, TweenInfo.new(0.15), {BackgroundColor3 = Colors.Accent}):Play()
            Services.TweenService:Create(knob, TweenInfo.new(0.15), {Position = UDim2.new(1, -20, 0.5, -9)}):Play()
        else
            Services.TweenService:Create(track, TweenInfo.new(0.15), {BackgroundColor3 = Colors.Secondary}):Play()
            Services.TweenService:Create(knob, TweenInfo.new(0.15), {Position = UDim2.new(0, 2, 0.5, -9)}):Play()
        end
    end

    clickArea.MouseButton1Click:Connect(function()
        state = not state
        Update()
        if config.Callback then
            config.Callback(state)
        end
    end)

    Update()

    return {
        Set = function(v)
            state = v
            Update()
            if config.Callback then
                config.Callback(state)
            end
        end
    }
end

function AtlasHub:AddSlider(config)
    config = config or {}
    local min = config.Min or 0
    local max = config.Max or 100
    local default = config.Default or min

    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, 0, 0, 58)
    holder.BackgroundColor3 = Colors.Surface
    holder.BorderSizePixel = 0
    holder.ZIndex = 112
    holder.LayoutOrder = #self.Content:GetChildren()
    holder.Parent = self.Content

    local holderCorner = Instance.new("UICorner")
    holderCorner.CornerRadius = UDim.new(0, 12)
    holderCorner.Parent = holder

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -80, 0, 24)
    label.Position = UDim2.new(0, 16, 0, 6)
    label.BackgroundTransparency = 1
    label.Text = config.Name or "Slider"
    label.TextColor3 = Colors.TextPrimary
    label.TextSize = 15
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 113
    label.Parent = holder

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 60, 0, 24)
    valueLabel.Position = UDim2.new(1, -76, 0, 6)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Colors.TextSecondary
    valueLabel.TextSize = 14
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.ZIndex = 113
    valueLabel.Parent = holder

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -32, 0, 8)
    track.Position = UDim2.new(0, 16, 1, -20)
    track.BackgroundColor3 = Colors.Secondary
    track.BorderSizePixel = 0
    track.ZIndex = 113
    track.Parent = holder

    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0, 4)
    trackCorner.Parent = track

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Colors.Accent
    fill.BorderSizePixel = 0
    fill.ZIndex = 114
    fill.Parent = track

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 4)
    fillCorner.Parent = fill

    local dragging = false
    local value = default

    local function SetFromInput(input)
        local relative = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        value = math.floor(min + (max - min) * relative)
        fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
        valueLabel.Text = tostring(value)
        if config.Callback then
            config.Callback(value)
        end
    end

    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            SetFromInput(input)
        end
    end)

    Services.UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            SetFromInput(input)
        end
    end)

    Services.UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    return {
        Set = function(v)
            value = math.clamp(v, min, max)
            fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
            valueLabel.Text = tostring(value)
            if config.Callback then
                config.Callback(value)
            end
        end
    }
end

function AtlasHub:AddNotify(config)
    config = config or {}
    local notifHolder = self.ScreenGui:FindFirstChild("NotifHolder")
    if not notifHolder then
        notifHolder = Instance.new("Frame")
        notifHolder.Name = "NotifHolder"
        notifHolder.Size = UDim2.new(0, 260, 1, -20)
        notifHolder.Position = UDim2.new(1, -270, 0, 10)
        notifHolder.BackgroundTransparency = 1
        notifHolder.ZIndex = 200
        notifHolder.Parent = self.ScreenGui

        local list = Instance.new("UIListLayout")
        list.Padding = UDim.new(0, 6)
        list.VerticalAlignment = Enum.VerticalAlignment.Top
        list.SortOrder = Enum.SortOrder.LayoutOrder
        list.Parent = notifHolder
    end

    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(1, 0, 0, 50)
    notif.BackgroundColor3 = Colors.Background
    notif.BorderSizePixel = 0
    notif.ZIndex = 201
    notif.Parent = notifHolder

    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 10)
    notifCorner.Parent = notif

    local notifTitle = Instance.new("TextLabel")
    notifTitle.Size = UDim2.new(1, -16, 0, 20)
    notifTitle.Position = UDim2.new(0, 8, 0, 4)
    notifTitle.BackgroundTransparency = 1
    notifTitle.Text = config.Title or ""
    notifTitle.TextColor3 = Colors.Accent
    notifTitle.Font = Enum.Font.GothamBold
    notifTitle.TextSize = 13
    notifTitle.TextXAlignment = Enum.TextXAlignment.Left
    notifTitle.ZIndex = 202
    notifTitle.Parent = notif

    local notifText = Instance.new("TextLabel")
    notifText.Size = UDim2.new(1, -16, 0, 20)
    notifText.Position = UDim2.new(0, 8, 0, 24)
    notifText.BackgroundTransparency = 1
    notifText.Text = config.Text or ""
    notifText.TextColor3 = Colors.TextPrimary
    notifText.Font = Enum.Font.Gotham
    notifText.TextSize = 12
    notifText.TextXAlignment = Enum.TextXAlignment.Left
    notifText.ZIndex = 202
    notifText.Parent = notif

    task.delay(4, function()
        notif:Destroy()
    end)
end

function AtlasHub:Destroy()
    self.State.IsDestroyed = true
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

return AtlasHub
