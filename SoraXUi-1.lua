local Library = {}

local IconPacks = {
    lucide = "https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/lucide/dist/Icons.lua",
    geist = "https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/geist/dist/Icons.lua",
    gravity = "https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/gravity/dist/Icons.lua",
    sfsymbols = "https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/sfsymbols/dist/Icons.lua"
}

local LoadedIconPacks = {}

local function LoadIconPack(packName)
    if LoadedIconPacks[packName] then
        return LoadedIconPacks[packName]
    end

    local url = IconPacks[packName]
    if not url then
        return nil
    end

    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)

    if success then
        LoadedIconPacks[packName] = result
        return result
    end

    return nil
end

local IconPackOrder = {"lucide", "gravity", "geist", "sfsymbols"}

local function TryResolveFromPack(imageLabel, packName, name)
    local data = LoadIconPack(packName)
    if not data then
        return false
    end

    if packName == "geist" then
        local iconData = data.Icons and data.Icons[name]
        if iconData then
            imageLabel.Image = data.Spritesheets[tostring(iconData.Image)]
            imageLabel.ImageRectOffset = iconData.ImageRectPosition
            imageLabel.ImageRectSize = iconData.ImageRectSize
            return true
        end
    else
        local id = data[name]
        if id then
            imageLabel.Image = id
            return true
        end
    end

    return false
end

local function ResolveIcon(imageLabel, iconRef)
    if type(iconRef) ~= "string" then
        return
    end

    if iconRef:match("^rbxassetid://") then
        imageLabel.Image = iconRef
        return
    end

    local pack, name = iconRef:match("^(%a+):(.+)$")

    if pack and IconPacks[pack] then
        if TryResolveFromPack(imageLabel, pack, name) then
            return
        end
    else
        for _, packName in ipairs(IconPackOrder) do
            if TryResolveFromPack(imageLabel, packName, iconRef) then
                return
            end
        end
    end

    imageLabel.Image = iconRef
end

local Themes = {
    EgiXploit = {
        Accent = Color3.fromRGB(0, 255, 170),
        Active = Color3.fromRGB(0, 180, 110),
        ActiveTab = Color3.fromRGB(0, 170, 110),
        ClickFlash = Color3.fromRGB(0, 160, 100),
        BorderBase = Color3.fromRGB(0, 255, 150),
        Muted = Color3.fromRGB(0, 120, 85),
        UseImage = true,
        MinIconId = "82180962273473",
        BgImageId = "93691114983897",
        BgColor = Color3.fromRGB(10, 15, 18),
        BubbleColors = {Color3.fromRGB(0, 255, 170), Color3.fromRGB(100, 255, 200)},
        GradientColors = {
            Color3.fromRGB(0, 255, 170),
            Color3.fromRGB(0, 80, 50),
            Color3.fromRGB(150, 255, 200),
            Color3.fromRGB(0, 50, 30),
            Color3.fromRGB(0, 255, 170)
        },
        PanelBg = Color3.fromRGB(15, 28, 22),
        PanelAlt = Color3.fromRGB(20, 38, 30),
        TabInactive = Color3.fromRGB(25, 45, 35),
        SwitchOff = Color3.fromRGB(40, 55, 48),
        InputBg = Color3.fromRGB(10, 18, 14),
        TitleBtnBg = Color3.fromRGB(25, 60, 45),
        MainBg = Color3.fromRGB(10, 15, 18),
        WidgetBg = Color3.fromRGB(10, 22, 16)
    },
    Purple = {
        Accent = Color3.fromRGB(190, 110, 255),
        Active = Color3.fromRGB(165, 85, 240),
        ActiveTab = Color3.fromRGB(150, 70, 225),
        ClickFlash = Color3.fromRGB(135, 60, 205),
        BorderBase = Color3.fromRGB(170, 90, 255),
        Muted = Color3.fromRGB(90, 50, 130),
        UseImage = true,
        MinIconId = "101420008247254",
        BgImageId = "101420008247254",
        BgColor = Color3.fromRGB(55, 20, 85),
        BubbleColors = {Color3.fromRGB(170, 60, 255), Color3.fromRGB(210, 130, 255)},
        GradientColors = {
            Color3.fromRGB(170, 60, 255),
            Color3.fromRGB(40, 15, 75),
            Color3.fromRGB(210, 130, 255),
            Color3.fromRGB(30, 15, 60),
            Color3.fromRGB(170, 60, 255)
        },
        PanelBg = Color3.fromRGB(30, 18, 42),
        PanelAlt = Color3.fromRGB(38, 24, 50),
        TabInactive = Color3.fromRGB(45, 30, 58),
        SwitchOff = Color3.fromRGB(55, 42, 68),
        InputBg = Color3.fromRGB(20, 14, 26),
        TitleBtnBg = Color3.fromRGB(55, 35, 75),
        MainBg = Color3.fromRGB(18, 12, 22),
        WidgetBg = Color3.fromRGB(22, 14, 28)
    },
    FhriiXPloit = {
        Accent = Color3.fromRGB(255, 150, 60),
        Active = Color3.fromRGB(230, 120, 40),
        ActiveTab = Color3.fromRGB(210, 110, 35),
        ClickFlash = Color3.fromRGB(190, 100, 30),
        BorderBase = Color3.fromRGB(255, 140, 50),
        Muted = Color3.fromRGB(140, 80, 30),
        UseImage = true,
        MinIconId = "72831813686885",
        BgImageId = "72831813686885",
        BgColor = Color3.fromRGB(70, 40, 15),
        BubbleColors = {Color3.fromRGB(255, 150, 60), Color3.fromRGB(255, 200, 120)},
        GradientColors = {
            Color3.fromRGB(255, 150, 60),
            Color3.fromRGB(90, 50, 15),
            Color3.fromRGB(255, 200, 120),
            Color3.fromRGB(70, 35, 10),
            Color3.fromRGB(255, 150, 60)
        },
        PanelBg = Color3.fromRGB(42, 28, 15),
        PanelAlt = Color3.fromRGB(52, 35, 18),
        TabInactive = Color3.fromRGB(60, 42, 22),
        SwitchOff = Color3.fromRGB(70, 55, 35),
        InputBg = Color3.fromRGB(26, 18, 10),
        TitleBtnBg = Color3.fromRGB(75, 50, 20),
        MainBg = Color3.fromRGB(22, 16, 10),
        WidgetBg = Color3.fromRGB(28, 18, 10)
    },
    Red = {
        Accent = Color3.fromRGB(255, 70, 70),
        Active = Color3.fromRGB(220, 45, 45),
        ActiveTab = Color3.fromRGB(200, 40, 40),
        ClickFlash = Color3.fromRGB(180, 35, 35),
        BorderBase = Color3.fromRGB(255, 60, 60),
        Muted = Color3.fromRGB(130, 30, 30),
        UseImage = true,
        MinIconId = "92199485590858",
        BgImageId = "92199485590858",
        BgColor = Color3.fromRGB(70, 15, 15),
        BubbleColors = {Color3.fromRGB(255, 70, 70), Color3.fromRGB(255, 140, 140)},
        GradientColors = {
            Color3.fromRGB(255, 70, 70),
            Color3.fromRGB(90, 15, 15),
            Color3.fromRGB(255, 140, 140),
            Color3.fromRGB(70, 10, 10),
            Color3.fromRGB(255, 70, 70)
        },
        PanelBg = Color3.fromRGB(42, 15, 15),
        PanelAlt = Color3.fromRGB(52, 18, 18),
        TabInactive = Color3.fromRGB(60, 22, 22),
        SwitchOff = Color3.fromRGB(70, 35, 35),
        InputBg = Color3.fromRGB(26, 10, 10),
        TitleBtnBg = Color3.fromRGB(75, 20, 20),
        MainBg = Color3.fromRGB(22, 10, 10),
        WidgetBg = Color3.fromRGB(28, 10, 10)
    }
}

function Library:Init(titleName, themeName)
    if not game:IsLoaded() then game.Loaded:Wait() end

    local CoreGui = game:GetService("CoreGui")
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local ContentProvider = game:GetService("ContentProvider")

    local CurrentTheme = Themes[themeName] or Themes.EgiXploit

    if CoreGui:FindFirstChild("SoraXUI") then
        CoreGui.SoraXUI:Destroy()
    end

    local PixelFont = Enum.Font.Arcade

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SoraXUI"
    ScreenGui.Parent = CoreGui

    local function ApplyAssetImage(imageLabel, assetIdStr)
        task.spawn(function()
            local rawNum = tonumber(assetIdStr)
            if not rawNum then
                imageLabel.Image = "rbxassetid://" .. tostring(assetIdStr)
                return
            end

            local formattedUrl = "https://www.roblox.com/asset-thumbnail/image?assetId=" .. tostring(rawNum) .. "&width=420&height=420&format=png"
            imageLabel.Image = formattedUrl

            pcall(function()
                ContentProvider:PreloadAsync({imageLabel})
            end)
        end)
    end

    local OuterBorder = Instance.new("Frame")
    OuterBorder.Name = "OuterBorder"
    OuterBorder.Size = UDim2.new(0, 320, 0, 360)
    OuterBorder.Position = UDim2.new(0.5, -160, 0.5, -180)
    OuterBorder.BackgroundColor3 = CurrentTheme.BorderBase
    OuterBorder.BorderSizePixel = 0
    OuterBorder.Active = true
    OuterBorder.Draggable = true
    OuterBorder.Parent = ScreenGui

    local OuterCorner = Instance.new("UICorner")
    OuterCorner.CornerRadius = UDim.new(0, 10)
    OuterCorner.Parent = OuterBorder

    local BorderGradient = Instance.new("UIGradient")
    BorderGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, CurrentTheme.GradientColors[1]),
        ColorSequenceKeypoint.new(0.25, CurrentTheme.GradientColors[2]),
        ColorSequenceKeypoint.new(0.5, CurrentTheme.GradientColors[3]),
        ColorSequenceKeypoint.new(0.75, CurrentTheme.GradientColors[4]),
        ColorSequenceKeypoint.new(1, CurrentTheme.GradientColors[5])
    })
    BorderGradient.Parent = OuterBorder

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(1, -4, 1, -4)
    MainFrame.Position = UDim2.new(0, 2, 0, 2)
    MainFrame.BackgroundColor3 = CurrentTheme.MainBg
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = OuterBorder

    local UICornerMain = Instance.new("UICorner")
    UICornerMain.CornerRadius = UDim.new(0, 8)
    UICornerMain.Parent = MainFrame

    local BGImage
    if CurrentTheme.UseImage then
        BGImage = Instance.new("ImageLabel")
        BGImage.Name = "CustomBG"
        BGImage.Size = UDim2.new(1, 0, 1, 0)
        BGImage.Position = UDim2.new(0, 0, 0, 0)
        BGImage.BackgroundTransparency = 1
        BGImage.ScaleType = Enum.ScaleType.Crop
        BGImage.ImageTransparency = 0.1
        BGImage.ZIndex = 1
        BGImage.ClipsDescendants = true
        BGImage.Parent = MainFrame

        local BGCorner = Instance.new("UICorner")
        BGCorner.CornerRadius = UDim.new(0, 8)
        BGCorner.Parent = BGImage

        ApplyAssetImage(BGImage, CurrentTheme.BgImageId)
    else
        BGImage = Instance.new("Frame")
        BGImage.Name = "CustomBG"
        BGImage.Size = UDim2.new(1, 0, 1, 0)
        BGImage.Position = UDim2.new(0, 0, 0, 0)
        BGImage.BackgroundColor3 = CurrentTheme.BgColor
        BGImage.BorderSizePixel = 0
        BGImage.ZIndex = 1
        BGImage.ClipsDescendants = true
        BGImage.Parent = MainFrame

        local BGCorner = Instance.new("UICorner")
        BGCorner.CornerRadius = UDim.new(0, 8)
        BGCorner.Parent = BGImage

        local BGGradient = Instance.new("UIGradient")
        BGGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, CurrentTheme.GradientColors[1]),
            ColorSequenceKeypoint.new(0.5, CurrentTheme.BgColor),
            ColorSequenceKeypoint.new(1, CurrentTheme.GradientColors[3])
        })
        BGGradient.Rotation = 45
        BGGradient.Transparency = NumberSequence.new(0.55)
        BGGradient.Parent = BGImage
    end

    -- Continuous Neon Bubble Particles
    local ParticleContainer = Instance.new("Frame")
    ParticleContainer.Name = "ParticleContainer"
    ParticleContainer.Size = UDim2.new(1, 0, 1, 0)
    ParticleContainer.BackgroundTransparency = 1
    ParticleContainer.ZIndex = 2
    ParticleContainer.ClipsDescendants = true
    ParticleContainer.Parent = MainFrame

    local function SpawnBubble()
        if not MainFrame or not MainFrame.Parent then return end

        local Bubble = Instance.new("Frame")
        local bSize = math.random(8, 18)
        Bubble.Size = UDim2.new(0, bSize, 0, bSize)
        
        local startX = math.random(5, 95) / 100
        Bubble.Position = UDim2.new(startX, 0, 1, math.random(5, 25))
        Bubble.BackgroundColor3 = (math.random(1, 2) == 1) and CurrentTheme.BubbleColors[1] or CurrentTheme.BubbleColors[2]
        Bubble.BackgroundTransparency = math.random(30, 60) / 100
        Bubble.BorderSizePixel = 0
        Bubble.ZIndex = 2
        Bubble.Parent = ParticleContainer

        local BCorner = Instance.new("UICorner")
        BCorner.CornerRadius = UDim.new(1, 0)
        BCorner.Parent = Bubble

        local duration = math.random(5, 9)
        local targetXOffset = math.random(-30, 30)

        local tweenBubble = TweenService:Create(Bubble, TweenInfo.new(duration, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            Position = UDim2.new(startX, targetXOffset, -0.15, 0),
            BackgroundTransparency = 1,
            Size = UDim2.new(0, bSize + 4, 0, bSize + 4)
        })

        tweenBubble:Play()
        tweenBubble.Completed:Connect(function()
            Bubble:Destroy()
        end)
    end

    task.spawn(function()
        for _ = 1, 10 do
            SpawnBubble()
        end
        
        while MainFrame and MainFrame.Parent do
            SpawnBubble()
            task.wait(0.35)
        end
    end)

    RunService.RenderStepped:Connect(function()
        if OuterBorder and OuterBorder.Parent then
            BorderGradient.Rotation = (BorderGradient.Rotation + 2) % 360
        end
    end)

    local MinWidgetOuter = Instance.new("Frame")
    MinWidgetOuter.Name = "MinWidgetOuter"
    MinWidgetOuter.Size = UDim2.new(0, 50, 0, 50)
    MinWidgetOuter.Position = OuterBorder.Position
    MinWidgetOuter.BackgroundColor3 = CurrentTheme.BorderBase
    MinWidgetOuter.BorderSizePixel = 0
    MinWidgetOuter.Active = true
    MinWidgetOuter.Visible = false
    MinWidgetOuter.Parent = ScreenGui

    local MinOuterCorner = Instance.new("UICorner")
    MinOuterCorner.CornerRadius = UDim.new(0, 10)
    MinOuterCorner.Parent = MinWidgetOuter

    local MinBorderGradient = BorderGradient:Clone()
    MinBorderGradient.Parent = MinWidgetOuter

    RunService.RenderStepped:Connect(function()
        if MinWidgetOuter and MinWidgetOuter.Parent and MinWidgetOuter.Visible then
            MinBorderGradient.Rotation = (MinBorderGradient.Rotation + 25) % 360
        end
    end)

    local MinWidget = Instance.new("Frame")
    MinWidget.Size = UDim2.new(1, -4, 1, -4)
    MinWidget.Position = UDim2.new(0, 2, 0, 2)
    MinWidget.BackgroundColor3 = CurrentTheme.WidgetBg
    MinWidget.BorderSizePixel = 0
    MinWidget.Parent = MinWidgetOuter

    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 8)
    MinCorner.Parent = MinWidget

    local MinIcon = Instance.new("ImageLabel")
    MinIcon.Size = UDim2.new(0.85, 0, 0.85, 0)
    MinIcon.Position = UDim2.new(0.075, 0, 0.075, 0)
    MinIcon.BackgroundTransparency = 1
    MinIcon.ScaleType = Enum.ScaleType.Fit
    MinIcon.Parent = MinWidget
    ApplyAssetImage(MinIcon, CurrentTheme.MinIconId)

    local MinClickBtn = Instance.new("TextButton")
    MinClickBtn.Size = UDim2.new(1, 0, 1, 0)
    MinClickBtn.BackgroundTransparency = 1
    MinClickBtn.Text = ""
    MinClickBtn.Parent = MinWidget

    local dragging = false
    local dragStart, startPos
    local totalMove = 0

    MinClickBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MinWidgetOuter.Position
            totalMove = 0
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            totalMove = delta.Magnitude
            MinWidgetOuter.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    local function OpenUIWithAnimation()
        OuterBorder.Position = MinWidgetOuter.Position
        MinWidgetOuter.Visible = false
        OuterBorder.Size = UDim2.new(0, 0, 0, 0)
        OuterBorder.Visible = true

        local tweenOpen = TweenService:Create(OuterBorder, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 320, 0, 360)
        })
        tweenOpen:Play()
    end

    local function MinimizeUIWithAnimation()
        local currentPos = OuterBorder.Position
        local tweenMin = TweenService:Create(OuterBorder, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0)
        })
        tweenMin:Play()
        tweenMin.Completed:Connect(function()
            OuterBorder.Visible = false
            OuterBorder.Size = UDim2.new(0, 320, 0, 360)
            MinWidgetOuter.Position = currentPos
            MinWidgetOuter.Visible = true
        end)
    end

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                dragging = false
                if totalMove < 8 then
                    OpenUIWithAnimation()
                end
            end
        end
    end)

    OuterBorder:GetPropertyChangedSignal("Position"):Connect(function()
        if OuterBorder.Visible then
            MinWidgetOuter.Position = OuterBorder.Position
        end
    end)

    MinWidgetOuter:GetPropertyChangedSignal("Position"):Connect(function()
        if MinWidgetOuter.Visible then
            OuterBorder.Position = MinWidgetOuter.Position
        end
    end)

    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 35)
    TitleBar.BackgroundTransparency = 1
    TitleBar.ZIndex = 3
    TitleBar.Parent = MainFrame

    local TitleText = Instance.new("TextLabel")
    TitleText.Size = UDim2.new(1, -70, 1, 0)
    TitleText.Position = UDim2.new(0, 12, 0, 0)
    TitleText.Text = titleName or "SoraXUI"
    TitleText.TextColor3 = CurrentTheme.Accent
    TitleText.TextSize = 16
    TitleText.Font = PixelFont
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.BackgroundTransparency = 1
    TitleText.ZIndex = 3
    TitleText.Parent = TitleBar

    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Size = UDim2.new(0, 22, 0, 22)
    MinimizeBtn.Position = UDim2.new(1, -55, 0, 6)
    MinimizeBtn.BackgroundColor3 = CurrentTheme.TitleBtnBg
    MinimizeBtn.BackgroundTransparency = 0.2
    MinimizeBtn.Text = "-"
    MinimizeBtn.TextColor3 = CurrentTheme.Accent
    MinimizeBtn.Font = PixelFont
    MinimizeBtn.TextSize = 18
    MinimizeBtn.ZIndex = 3
    MinimizeBtn.Parent = TitleBar

    local UICornerMin = Instance.new("UICorner")
    UICornerMin.CornerRadius = UDim.new(0, 4)
    UICornerMin.Parent = MinimizeBtn

    MinimizeBtn.MouseButton1Click:Connect(function()
        MinimizeUIWithAnimation()
    end)

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 22, 0, 22)
    CloseBtn.Position = UDim2.new(1, -28, 0, 6)
    CloseBtn.BackgroundColor3 = CurrentTheme.TitleBtnBg
    CloseBtn.BackgroundTransparency = 0.2
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = CurrentTheme.Accent
    CloseBtn.Font = PixelFont
    CloseBtn.TextSize = 14
    CloseBtn.ZIndex = 3
    CloseBtn.Parent = TitleBar

    local UICornerClose = Instance.new("UICorner")
    UICornerClose.CornerRadius = UDim.new(0, 4)
    UICornerClose.Parent = CloseBtn

    CloseBtn.MouseButton1Click:Connect(function()
        local tweenClose = TweenService:Create(OuterBorder, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0)
        })
        tweenClose:Play()
        tweenClose.Completed:Connect(function()
            ScreenGui:Destroy()
        end)
    end)

    local TabBar = Instance.new("ScrollingFrame")
    TabBar.Size = UDim2.new(1, -24, 0, 30)
    TabBar.Position = UDim2.new(0, 12, 0, 38)
    TabBar.BackgroundTransparency = 1
    TabBar.BorderSizePixel = 0
    TabBar.ScrollingDirection = Enum.ScrollingDirection.X
    TabBar.ScrollBarThickness = 3
    TabBar.ScrollBarImageColor3 = CurrentTheme.Accent
    TabBar.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabBar.AutomaticCanvasSize = Enum.AutomaticSize.X
    TabBar.ZIndex = 3
    TabBar.Parent = MainFrame

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.Padding = UDim.new(0, 8)
    TabLayout.Parent = TabBar

    local ContainerFolder = Instance.new("Folder")
    ContainerFolder.Name = "TabContainers"
    ContainerFolder.Parent = MainFrame

    local ActiveTabBtn = nil
    local ActiveContainer = nil

    local Window = {}

    function Window:CreateTab(tabName, iconId)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(0, 0, 1, 0)
        TabBtn.AutomaticSize = Enum.AutomaticSize.X
        TabBtn.BackgroundColor3 = CurrentTheme.TabInactive
        TabBtn.BackgroundTransparency = 0.3
        TabBtn.Text = ""
        TabBtn.AutoButtonColor = false
        TabBtn.ZIndex = 3
        TabBtn.Parent = TabBar

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabBtn

        local TabPadding = Instance.new("UIPadding")
        TabPadding.PaddingLeft = UDim.new(0, 12)
        TabPadding.PaddingRight = UDim.new(0, 12)
        TabPadding.Parent = TabBtn

        local TabContent = Instance.new("Frame")
        TabContent.Name = "TabContent"
        TabContent.Size = UDim2.new(0, 0, 1, 0)
        TabContent.AutomaticSize = Enum.AutomaticSize.X
        TabContent.BackgroundTransparency = 1
        TabContent.ZIndex = 4
        TabContent.Parent = TabBtn

        local TabContentLayout = Instance.new("UIListLayout")
        TabContentLayout.FillDirection = Enum.FillDirection.Horizontal
        TabContentLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        TabContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        TabContentLayout.Padding = UDim.new(0, 6)
        TabContentLayout.Parent = TabContent

        if iconId then
            local TabIcon = Instance.new("ImageLabel")
            TabIcon.Name = "Icon"
            TabIcon.Size = UDim2.new(0, 16, 0, 16)
            TabIcon.BackgroundTransparency = 1
            ResolveIcon(TabIcon, iconId)
            TabIcon.ImageColor3 = Color3.fromRGB(150, 180, 165)
            TabIcon.ZIndex = 4
            TabIcon.Parent = TabContent
        end

        local TabLabel = Instance.new("TextLabel")
        TabLabel.Name = "Label"
        TabLabel.Size = UDim2.new(0, 0, 1, 0)
        TabLabel.AutomaticSize = Enum.AutomaticSize.X
        TabLabel.BackgroundTransparency = 1
        TabLabel.Text = tabName
        TabLabel.TextColor3 = Color3.fromRGB(150, 180, 165)
        TabLabel.Font = PixelFont
        TabLabel.TextSize = 13
        TabLabel.ZIndex = 4
        TabLabel.Parent = TabContent

        local TabScroll = Instance.new("ScrollingFrame")
        TabScroll.Name = "Container_" .. tabName
        TabScroll.Size = UDim2.new(1, -24, 1, -80)
        TabScroll.Position = UDim2.new(0, 12, 0, 74)
        TabScroll.BackgroundTransparency = 1
        TabScroll.BorderSizePixel = 0
        TabScroll.ScrollBarThickness = 3
        TabScroll.ScrollBarImageColor3 = CurrentTheme.Accent
        TabScroll.Visible = false
        TabScroll.ZIndex = 3
        TabScroll.Parent = ContainerFolder

        local ListLayout = Instance.new("UIListLayout")
        ListLayout.Padding = UDim.new(0, 8)
        ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        ListLayout.Parent = TabScroll

        ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabScroll.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
        end)

        local function SetTabColors(btn, active)
            local content = btn:FindFirstChild("TabContent")
            local label = content and content:FindFirstChild("Label")
            local icon = content and content:FindFirstChild("Icon")
            local color = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 180, 165)
            if label then
                label.TextColor3 = color
            end
            if icon then
                icon.ImageColor3 = color
            end
        end

        TabBtn.MouseButton1Click:Connect(function()
            if ActiveTabBtn then
                ActiveTabBtn.BackgroundColor3 = CurrentTheme.TabInactive
                ActiveTabBtn.BackgroundTransparency = 0.3
                SetTabColors(ActiveTabBtn, false)
            end
            if ActiveContainer then
                ActiveContainer.Visible = false
            end

            TabBtn.BackgroundColor3 = CurrentTheme.ActiveTab
            TabBtn.BackgroundTransparency = 0.1
            SetTabColors(TabBtn, true)
            TabScroll.Visible = true

            ActiveTabBtn = TabBtn
            ActiveContainer = TabScroll
        end)

        if not ActiveTabBtn then
            TabBtn.BackgroundColor3 = CurrentTheme.ActiveTab
            TabBtn.BackgroundTransparency = 0.1
            SetTabColors(TabBtn, true)
            TabScroll.Visible = true
            ActiveTabBtn = TabBtn
            ActiveContainer = TabScroll
        end

        local Elements = {}

        function Elements:AddToggle(text, defaultState, callback)
            callback = callback or function() end
            local toggled = defaultState or false

            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
            ToggleFrame.BackgroundColor3 = CurrentTheme.PanelBg
            ToggleFrame.BackgroundTransparency = 0.35
            ToggleFrame.ZIndex = 3
            ToggleFrame.Parent = TabScroll

            local TCorner = Instance.new("UICorner")
            TCorner.CornerRadius = UDim.new(0, 6)
            TCorner.Parent = ToggleFrame

            local TLabel = Instance.new("TextLabel")
            TLabel.Size = UDim2.new(0.65, 0, 1, 0)
            TLabel.Position = UDim2.new(0, 10, 0, 0)
            TLabel.Text = text
            TLabel.TextColor3 = Color3.fromRGB(220, 245, 230)
            TLabel.Font = PixelFont
            TLabel.TextSize = 13
            TLabel.TextXAlignment = Enum.TextXAlignment.Left
            TLabel.BackgroundTransparency = 1
            TLabel.ZIndex = 4
            TLabel.Parent = ToggleFrame

            local SwitchBg = Instance.new("Frame")
            SwitchBg.Size = UDim2.new(0, 44, 0, 22)
            SwitchBg.Position = UDim2.new(1, -54, 0.5, -11)
            SwitchBg.BackgroundColor3 = toggled and CurrentTheme.Active or CurrentTheme.SwitchOff
            SwitchBg.ZIndex = 4
            SwitchBg.Parent = ToggleFrame

            local SwitchCorner = Instance.new("UICorner")
            SwitchCorner.CornerRadius = UDim.new(1, 0)
            SwitchCorner.Parent = SwitchBg

            local SwitchDot = Instance.new("Frame")
            SwitchDot.Size = UDim2.new(0, 18, 0, 18)
            SwitchDot.Position = toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
            SwitchDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SwitchDot.ZIndex = 5
            SwitchDot.Parent = SwitchBg

            local DotCorner = Instance.new("UICorner")
            DotCorner.CornerRadius = UDim.new(1, 0)
            DotCorner.Parent = SwitchDot

            local ToggleClick = Instance.new("TextButton")
            ToggleClick.Size = UDim2.new(1, 0, 1, 0)
            ToggleClick.BackgroundTransparency = 1
            ToggleClick.Text = ""
            ToggleClick.ZIndex = 6
            ToggleClick.Parent = ToggleFrame

            ToggleClick.MouseButton1Click:Connect(function()
                toggled = not toggled
                TweenService:Create(SwitchBg, TweenInfo.new(0.2), {BackgroundColor3 = toggled and CurrentTheme.Active or CurrentTheme.SwitchOff}):Play()
                TweenService:Create(SwitchDot, TweenInfo.new(0.2), {Position = toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)}):Play()
                callback(toggled)
            end)
        end

        function Elements:AddButton(text, callback)
            callback = callback or function() end

            local BtnFrame = Instance.new("Frame")
            BtnFrame.Size = UDim2.new(1, 0, 0, 38)
            BtnFrame.BackgroundColor3 = CurrentTheme.PanelAlt
            BtnFrame.BackgroundTransparency = 0.35
            BtnFrame.ZIndex = 3
            BtnFrame.Parent = TabScroll

            local BCorner = Instance.new("UICorner")
            BCorner.CornerRadius = UDim.new(0, 6)
            BCorner.Parent = BtnFrame

            local BtnClick = Instance.new("TextButton")
            BtnClick.Size = UDim2.new(1, 0, 1, 0)
            BtnClick.BackgroundTransparency = 1
            BtnClick.Text = text
            BtnClick.TextColor3 = Color3.fromRGB(220, 255, 235)
            BtnClick.Font = PixelFont
            BtnClick.TextSize = 13
            BtnClick.ZIndex = 4
            BtnClick.Parent = BtnFrame

            BtnClick.MouseButton1Click:Connect(function()
                TweenService:Create(BtnFrame, TweenInfo.new(0.1), {BackgroundColor3 = CurrentTheme.ClickFlash}):Play()
                task.delay(0.1, function()
                    TweenService:Create(BtnFrame, TweenInfo.new(0.2), {BackgroundColor3 = CurrentTheme.PanelAlt}):Play()
                end)
                callback()
            end)
        end

        function Elements:AddSlider(text, min, max, default, callback)
            callback = callback or function() end
            local val = math.clamp(default or min, min, max)

            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(1, 0, 0, 46)
            SliderFrame.BackgroundColor3 = CurrentTheme.PanelBg
            SliderFrame.BackgroundTransparency = 0.35
            SliderFrame.ZIndex = 3
            SliderFrame.Parent = TabScroll

            local SCorner = Instance.new("UICorner")
            SCorner.CornerRadius = UDim.new(0, 6)
            SCorner.Parent = SliderFrame

            local SLabel = Instance.new("TextLabel")
            SLabel.Size = UDim2.new(0.6, 0, 0, 20)
            SLabel.Position = UDim2.new(0, 10, 0, 4)
            SLabel.Text = text
            SLabel.TextColor3 = Color3.fromRGB(220, 245, 230)
            SLabel.Font = PixelFont
            SLabel.TextSize = 12
            SLabel.TextXAlignment = Enum.TextXAlignment.Left
            SLabel.BackgroundTransparency = 1
            SLabel.ZIndex = 4
            SLabel.Parent = SliderFrame

            local ValLabel = Instance.new("TextLabel")
            ValLabel.Size = UDim2.new(0.3, 0, 0, 20)
            ValLabel.Position = UDim2.new(0.7, -10, 0, 4)
            ValLabel.Text = tostring(val)
            ValLabel.TextColor3 = CurrentTheme.Accent
            ValLabel.Font = PixelFont
            ValLabel.TextSize = 12
            ValLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValLabel.BackgroundTransparency = 1
            ValLabel.ZIndex = 4
            ValLabel.Parent = SliderFrame

            local Track = Instance.new("Frame")
            Track.Size = UDim2.new(1, -20, 0, 8)
            Track.Position = UDim2.new(0, 10, 0, 28)
            Track.BackgroundColor3 = Color3.fromRGB(40, 55, 48)
            Track.ZIndex = 4
            Track.Parent = SliderFrame

            local TrackCorner = Instance.new("UICorner")
            TrackCorner.CornerRadius = UDim.new(1, 0)
            TrackCorner.Parent = Track

            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new((val - min)/(max - min), 0, 1, 0)
            Fill.BackgroundColor3 = CurrentTheme.Active
            Fill.ZIndex = 5
            Fill.Parent = Track

            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(1, 0)
            FillCorner.Parent = Fill

            local isDragging = false

            local function updateSlider(input)
                local mousePos = input.Position.X
                local trackPos = Track.AbsolutePosition.X
                local trackWidth = Track.AbsoluteSize.X
                local percent = math.clamp((mousePos - trackPos) / trackWidth, 0, 1)
                val = math.floor(min + (max - min) * percent)

                Fill.Size = UDim2.new(percent, 0, 1, 0)
                ValLabel.Text = tostring(val)
                callback(val)
            end

            SliderFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    isDragging = true
                    updateSlider(input)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    updateSlider(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    isDragging = false
                end
            end)
        end

        function Elements:AddTextBox(text, placeholder, callback)
            callback = callback or function() end

            local BoxFrame = Instance.new("Frame")
            BoxFrame.Size = UDim2.new(1, 0, 0, 42)
            BoxFrame.BackgroundColor3 = CurrentTheme.PanelBg
            BoxFrame.BackgroundTransparency = 0.35
            BoxFrame.ZIndex = 3
            BoxFrame.Parent = TabScroll

            local BCorner = Instance.new("UICorner")
            BCorner.CornerRadius = UDim.new(0, 6)
            BCorner.Parent = BoxFrame

            local BLabel = Instance.new("TextLabel")
            BLabel.Size = UDim2.new(0.5, 0, 1, 0)
            BLabel.Position = UDim2.new(0, 10, 0, 0)
            BLabel.Text = text
            BLabel.TextColor3 = Color3.fromRGB(220, 245, 230)
            BLabel.Font = PixelFont
            BLabel.TextSize = 13
            BLabel.TextXAlignment = Enum.TextXAlignment.Left
            BLabel.BackgroundTransparency = 1
            BLabel.ZIndex = 4
            BLabel.Parent = BoxFrame

            local InputBox = Instance.new("TextBox")
            InputBox.Size = UDim2.new(0.42, 0, 0, 26)
            InputBox.Position = UDim2.new(0.55, 0, 0.5, -13)
            InputBox.BackgroundColor3 = CurrentTheme.InputBg
            InputBox.BackgroundTransparency = 0.2
            InputBox.Text = ""
            InputBox.PlaceholderText = placeholder or "Input..."
            InputBox.PlaceholderColor3 = Color3.fromRGB(100, 130, 115)
            InputBox.TextColor3 = CurrentTheme.Accent
            InputBox.Font = PixelFont
            InputBox.TextSize = 12
            InputBox.ClearTextOnFocus = false
            InputBox.ZIndex = 4
            InputBox.Parent = BoxFrame

            local InputCorner = Instance.new("UICorner")
            InputCorner.CornerRadius = UDim.new(0, 4)
            InputCorner.Parent = InputBox

            InputBox.FocusLost:Connect(function(enterPressed)
                callback(InputBox.Text, enterPressed)
            end)
        end

        function Elements:AddDropdown(text, options, default, callback)
            callback = callback or function() end
            options = options or {}
            local selected = default
            local isOpen = false
            local optionHeight = 30
            local optionSpacing = 4
            local headerHeight = 40
            local openHeight = headerHeight + (#options * (optionHeight + optionSpacing)) + 6

            local DropFrame = Instance.new("Frame")
            DropFrame.Size = UDim2.new(1, 0, 0, headerHeight)
            DropFrame.BackgroundColor3 = CurrentTheme.PanelBg
            DropFrame.BackgroundTransparency = 0.35
            DropFrame.ClipsDescendants = true
            DropFrame.ZIndex = 3
            DropFrame.Parent = TabScroll

            local DCorner = Instance.new("UICorner")
            DCorner.CornerRadius = UDim.new(0, 6)
            DCorner.Parent = DropFrame

            local DLabel = Instance.new("TextLabel")
            DLabel.Size = UDim2.new(0.75, 0, 0, headerHeight)
            DLabel.Position = UDim2.new(0, 10, 0, 0)
            DLabel.Text = selected and (text .. ": Selected 1") or text
            DLabel.TextColor3 = Color3.fromRGB(220, 245, 230)
            DLabel.Font = PixelFont
            DLabel.TextSize = 13
            DLabel.TextXAlignment = Enum.TextXAlignment.Left
            DLabel.BackgroundTransparency = 1
            DLabel.ZIndex = 4
            DLabel.Parent = DropFrame

            local Arrow = Instance.new("TextLabel")
            Arrow.Size = UDim2.new(0, 24, 0, 24)
            Arrow.Position = UDim2.new(1, -32, 0, 8)
            Arrow.BackgroundTransparency = 1
            Arrow.Text = "^"
            Arrow.TextColor3 = CurrentTheme.Accent
            Arrow.Font = PixelFont
            Arrow.TextSize = 16
            Arrow.Rotation = 180
            Arrow.ZIndex = 4
            Arrow.Parent = DropFrame

            local HeaderBtn = Instance.new("TextButton")
            HeaderBtn.Size = UDim2.new(1, 0, 0, headerHeight)
            HeaderBtn.BackgroundTransparency = 1
            HeaderBtn.Text = ""
            HeaderBtn.ZIndex = 5
            HeaderBtn.Parent = DropFrame

            local OptionHolder = Instance.new("Frame")
            OptionHolder.Size = UDim2.new(1, -20, 0, 0)
            OptionHolder.Position = UDim2.new(0, 10, 0, headerHeight)
            OptionHolder.BackgroundTransparency = 1
            OptionHolder.ZIndex = 4
            OptionHolder.Parent = DropFrame

            local OptionLayout = Instance.new("UIListLayout")
            OptionLayout.Padding = UDim.new(0, optionSpacing)
            OptionLayout.Parent = OptionHolder

            local function SetOpen(state)
                isOpen = state
                local targetHeight = isOpen and openHeight or headerHeight
                TweenService:Create(DropFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, targetHeight)}):Play()
                TweenService:Create(Arrow, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = isOpen and 0 or 180}):Play()
            end

            HeaderBtn.MouseButton1Click:Connect(function()
                SetOpen(not isOpen)
            end)

            for _, optionText in ipairs(options) do
                local OptionBtn = Instance.new("TextButton")
                OptionBtn.Size = UDim2.new(1, 0, 0, optionHeight)
                OptionBtn.BackgroundColor3 = CurrentTheme.PanelAlt
                OptionBtn.BackgroundTransparency = 0.35
                OptionBtn.Text = tostring(optionText)
                OptionBtn.TextColor3 = Color3.fromRGB(220, 255, 235)
                OptionBtn.Font = PixelFont
                OptionBtn.TextSize = 12
                OptionBtn.ZIndex = 5
                OptionBtn.Parent = OptionHolder

                local OCorner = Instance.new("UICorner")
                OCorner.CornerRadius = UDim.new(0, 5)
                OCorner.Parent = OptionBtn

                OptionBtn.MouseButton1Click:Connect(function()
                    selected = optionText
                    DLabel.Text = text .. ": Selected 1"
                    SetOpen(false)
                    callback(selected)
                end)
            end
        end

        function Elements:AddMultiDropdown(text, options, callback)
            callback = callback or function() end
            options = options or {}
            local selectedSet = {}
            local selectedCount = 0
            local isOpen = false
            local optionHeight = 30
            local optionSpacing = 4
            local headerHeight = 40
            local openHeight = headerHeight + (#options * (optionHeight + optionSpacing)) + 6

            local DropFrame = Instance.new("Frame")
            DropFrame.Size = UDim2.new(1, 0, 0, headerHeight)
            DropFrame.BackgroundColor3 = CurrentTheme.PanelBg
            DropFrame.BackgroundTransparency = 0.35
            DropFrame.ClipsDescendants = true
            DropFrame.ZIndex = 3
            DropFrame.Parent = TabScroll

            local DCorner = Instance.new("UICorner")
            DCorner.CornerRadius = UDim.new(0, 6)
            DCorner.Parent = DropFrame

            local DLabel = Instance.new("TextLabel")
            DLabel.Size = UDim2.new(0.75, 0, 0, headerHeight)
            DLabel.Position = UDim2.new(0, 10, 0, 0)
            DLabel.Text = text
            DLabel.TextColor3 = Color3.fromRGB(220, 245, 230)
            DLabel.Font = PixelFont
            DLabel.TextSize = 13
            DLabel.TextXAlignment = Enum.TextXAlignment.Left
            DLabel.BackgroundTransparency = 1
            DLabel.ZIndex = 4
            DLabel.Parent = DropFrame

            local Arrow = Instance.new("TextLabel")
            Arrow.Size = UDim2.new(0, 24, 0, 24)
            Arrow.Position = UDim2.new(1, -32, 0, 8)
            Arrow.BackgroundTransparency = 1
            Arrow.Text = "^"
            Arrow.TextColor3 = CurrentTheme.Accent
            Arrow.Font = PixelFont
            Arrow.TextSize = 16
            Arrow.Rotation = 180
            Arrow.ZIndex = 4
            Arrow.Parent = DropFrame

            local HeaderBtn = Instance.new("TextButton")
            HeaderBtn.Size = UDim2.new(1, 0, 0, headerHeight)
            HeaderBtn.BackgroundTransparency = 1
            HeaderBtn.Text = ""
            HeaderBtn.ZIndex = 5
            HeaderBtn.Parent = DropFrame

            local OptionHolder = Instance.new("Frame")
            OptionHolder.Size = UDim2.new(1, -20, 0, 0)
            OptionHolder.Position = UDim2.new(0, 10, 0, headerHeight)
            OptionHolder.BackgroundTransparency = 1
            OptionHolder.ZIndex = 4
            OptionHolder.Parent = DropFrame

            local OptionLayout = Instance.new("UIListLayout")
            OptionLayout.Padding = UDim.new(0, optionSpacing)
            OptionLayout.Parent = OptionHolder

            local function SetOpen(state)
                isOpen = state
                local targetHeight = isOpen and openHeight or headerHeight
                TweenService:Create(DropFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, targetHeight)}):Play()
                TweenService:Create(Arrow, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = isOpen and 0 or 180}):Play()
            end

            local function UpdateLabel()
                DLabel.Text = (selectedCount > 0) and (text .. ": " .. tostring(selectedCount) .. "+") or text
            end

            HeaderBtn.MouseButton1Click:Connect(function()
                SetOpen(not isOpen)
            end)

            for _, optionText in ipairs(options) do
                local checked = false

                local OptionBtn = Instance.new("TextButton")
                OptionBtn.Size = UDim2.new(1, 0, 0, optionHeight)
                OptionBtn.BackgroundColor3 = CurrentTheme.PanelAlt
                OptionBtn.BackgroundTransparency = 0.35
                OptionBtn.Text = ""
                OptionBtn.ZIndex = 5
                OptionBtn.Parent = OptionHolder

                local OCorner = Instance.new("UICorner")
                OCorner.CornerRadius = UDim.new(0, 5)
                OCorner.Parent = OptionBtn

                local OLabel = Instance.new("TextLabel")
                OLabel.Size = UDim2.new(1, -40, 1, 0)
                OLabel.Position = UDim2.new(0, 10, 0, 0)
                OLabel.Text = tostring(optionText)
                OLabel.TextColor3 = Color3.fromRGB(220, 255, 235)
                OLabel.Font = PixelFont
                OLabel.TextSize = 12
                OLabel.TextXAlignment = Enum.TextXAlignment.Left
                OLabel.BackgroundTransparency = 1
                OLabel.ZIndex = 6
                OLabel.Parent = OptionBtn

                local CheckBox = Instance.new("Frame")
                CheckBox.Size = UDim2.new(0, 20, 0, 20)
                CheckBox.Position = UDim2.new(1, -30, 0.5, -10)
                CheckBox.BackgroundColor3 = CurrentTheme.SwitchOff
                CheckBox.ZIndex = 6
                CheckBox.Parent = OptionBtn

                local CheckCorner = Instance.new("UICorner")
                CheckCorner.CornerRadius = UDim.new(0, 6)
                CheckCorner.Parent = CheckBox

                OptionBtn.MouseButton1Click:Connect(function()
                    checked = not checked
                    selectedSet[optionText] = checked
                    selectedCount = selectedCount + (checked and 1 or -1)
                    TweenService:Create(CheckBox, TweenInfo.new(0.2), {BackgroundColor3 = checked and CurrentTheme.Active or CurrentTheme.SwitchOff}):Play()
                    UpdateLabel()
                    callback(selectedSet)
                end)
            end
        end

        function Elements:AddSection(text)
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Size = UDim2.new(1, 0, 0, 24)
            SectionFrame.BackgroundTransparency = 1
            SectionFrame.ZIndex = 3
            SectionFrame.Parent = TabScroll

            local SecLabel = Instance.new("TextLabel")
            SecLabel.Size = UDim2.new(1, 0, 0, 18)
            SecLabel.Position = UDim2.new(0, 0, 0, 0)
            SecLabel.Text = text
            SecLabel.TextColor3 = CurrentTheme.Accent
            SecLabel.Font = PixelFont
            SecLabel.TextSize = 13
            SecLabel.TextXAlignment = Enum.TextXAlignment.Left
            SecLabel.BackgroundTransparency = 1
            SecLabel.ZIndex = 4
            SecLabel.Parent = SectionFrame

            local SecLine = Instance.new("Frame")
            SecLine.Size = UDim2.new(1, 0, 0, 1)
            SecLine.Position = UDim2.new(0, 0, 1, -2)
            SecLine.BackgroundColor3 = CurrentTheme.Muted
            SecLine.BorderSizePixel = 0
            SecLine.ZIndex = 3
            SecLine.Parent = SectionFrame
        end

        function Elements:AddParagraph(title, content)
            local ParaFrame = Instance.new("Frame")
            ParaFrame.Size = UDim2.new(1, 0, 0, 0)
            ParaFrame.AutomaticSize = Enum.AutomaticSize.Y
            ParaFrame.BackgroundColor3 = CurrentTheme.PanelBg
            ParaFrame.BackgroundTransparency = 0.35
            ParaFrame.ZIndex = 3
            ParaFrame.Parent = TabScroll

            local PCorner = Instance.new("UICorner")
            PCorner.CornerRadius = UDim.new(0, 6)
            PCorner.Parent = ParaFrame

            local PPadding = Instance.new("UIPadding")
            PPadding.PaddingTop = UDim.new(0, 8)
            PPadding.PaddingBottom = UDim.new(0, 8)
            PPadding.PaddingLeft = UDim.new(0, 10)
            PPadding.PaddingRight = UDim.new(0, 10)
            PPadding.Parent = ParaFrame

            local PList = Instance.new("UIListLayout")
            PList.Padding = UDim.new(0, 4)
            PList.Parent = ParaFrame

            local PTitle = Instance.new("TextLabel")
            PTitle.Size = UDim2.new(1, 0, 0, 18)
            PTitle.Text = title
            PTitle.TextColor3 = Color3.fromRGB(220, 245, 230)
            PTitle.Font = PixelFont
            PTitle.TextSize = 13
            PTitle.TextXAlignment = Enum.TextXAlignment.Left
            PTitle.BackgroundTransparency = 1
            PTitle.ZIndex = 4
            PTitle.LayoutOrder = 1
            PTitle.Parent = ParaFrame

            local PBody = Instance.new("TextLabel")
            PBody.Size = UDim2.new(1, 0, 0, 0)
            PBody.AutomaticSize = Enum.AutomaticSize.Y
            PBody.Text = content
            PBody.TextColor3 = Color3.fromRGB(150, 180, 165)
            PBody.Font = PixelFont
            PBody.TextSize = 11
            PBody.TextWrapped = true
            PBody.TextXAlignment = Enum.TextXAlignment.Left
            PBody.TextYAlignment = Enum.TextYAlignment.Top
            PBody.BackgroundTransparency = 1
            PBody.ZIndex = 4
            PBody.LayoutOrder = 2
            PBody.Parent = ParaFrame
        end

        function Elements:AddStatus(text, defaultText)
            local StatusFrame = Instance.new("Frame")
            StatusFrame.Size = UDim2.new(1, 0, 0, 40)
            StatusFrame.BackgroundColor3 = CurrentTheme.PanelBg
            StatusFrame.BackgroundTransparency = 0.35
            StatusFrame.ZIndex = 3
            StatusFrame.Parent = TabScroll

            local StCorner = Instance.new("UICorner")
            StCorner.CornerRadius = UDim.new(0, 6)
            StCorner.Parent = StatusFrame

            local Dot = Instance.new("Frame")
            Dot.Size = UDim2.new(0, 8, 0, 8)
            Dot.Position = UDim2.new(0, 10, 0.5, -4)
            Dot.BackgroundColor3 = CurrentTheme.Accent
            Dot.ZIndex = 4
            Dot.Parent = StatusFrame

            local DotCorner = Instance.new("UICorner")
            DotCorner.CornerRadius = UDim.new(1, 0)
            DotCorner.Parent = Dot

            local SLabel = Instance.new("TextLabel")
            SLabel.Size = UDim2.new(0.5, -24, 1, 0)
            SLabel.Position = UDim2.new(0, 26, 0, 0)
            SLabel.Text = text
            SLabel.TextColor3 = Color3.fromRGB(220, 245, 230)
            SLabel.Font = PixelFont
            SLabel.TextSize = 13
            SLabel.TextXAlignment = Enum.TextXAlignment.Left
            SLabel.BackgroundTransparency = 1
            SLabel.ZIndex = 4
            SLabel.Parent = StatusFrame

            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Size = UDim2.new(0.5, -10, 1, 0)
            ValueLabel.Position = UDim2.new(0.5, 0, 0, 0)
            ValueLabel.Text = defaultText or "Idle"
            ValueLabel.TextColor3 = CurrentTheme.Accent
            ValueLabel.Font = PixelFont
            ValueLabel.TextSize = 12
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.ZIndex = 4
            ValueLabel.Parent = StatusFrame

            local StatusObj = {}

            function StatusObj:Set(newText, dotColor)
                ValueLabel.Text = newText
                if dotColor then
                    Dot.BackgroundColor3 = dotColor
                end
            end

            return StatusObj
        end

        return Elements
    end

    return Window
end

return Library
