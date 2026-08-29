local Library = {}

function Library:Init(titleName)
    if not game:IsLoaded() then game.Loaded:Wait() end

    local CoreGui = game:GetService("CoreGui")
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local ContentProvider = game:GetService("ContentProvider")

    if CoreGui:FindFirstChild("EgiXploitCompactUI") then
        CoreGui.EgiXploitCompactUI:Destroy()
    end

    local PixelFont = Enum.Font.Arcade

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "EgiXploitCompactUI"
    ScreenGui.Parent = CoreGui

    local MinIconID = "82180962273473"
    local CustomBGID = "93691114983897"

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
    OuterBorder.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
    OuterBorder.BorderSizePixel = 0
    OuterBorder.Active = true
    OuterBorder.Draggable = true
    OuterBorder.Parent = ScreenGui

    local OuterCorner = Instance.new("UICorner")
    OuterCorner.CornerRadius = UDim.new(0, 10)
    OuterCorner.Parent = OuterBorder

    local BorderGradient = Instance.new("UIGradient")
    BorderGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 170)),
        ColorSequenceKeypoint.new(0.25, Color3.fromRGB(0, 80, 50)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 255, 200)),
        ColorSequenceKeypoint.new(0.75, Color3.fromRGB(0, 50, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 170))
    })
    BorderGradient.Parent = OuterBorder

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(1, -4, 1, -4)
    MainFrame.Position = UDim2.new(0, 2, 0, 2)
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 15, 18)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = OuterBorder

    local UICornerMain = Instance.new("UICorner")
    UICornerMain.CornerRadius = UDim.new(0, 8)
    UICornerMain.Parent = MainFrame

    -- Custom Background Image
    local BGImage = Instance.new("ImageLabel")
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

    ApplyAssetImage(BGImage, CustomBGID)

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
        Bubble.BackgroundColor3 = (math.random(1, 2) == 1) and Color3.fromRGB(0, 255, 170) or Color3.fromRGB(100, 255, 200)
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
    MinWidgetOuter.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
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
    MinWidget.BackgroundColor3 = Color3.fromRGB(10, 22, 16)
    MinWidget.BorderSizePixel = 0
    MinWidget.Parent = MinWidgetOuter

    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 8)
    MinCorner.Parent = MinWidget

    local MinIcon = Instance.new("ImageLabel")
    MinIcon.Size = UDim2.new(0.85, 0, 0.85, 0)
    MinIcon.Position = UDim2.new(0.075, 0, 0.075, 0)
    MinIcon.BackgroundTransparency = 1
    MinIcon.Parent = MinWidget
    ApplyAssetImage(MinIcon, MinIconID)

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
    TitleText.Text = titleName or "EgiXploit UI"
    TitleText.TextColor3 = Color3.fromRGB(0, 255, 170)
    TitleText.TextSize = 16
    TitleText.Font = PixelFont
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.BackgroundTransparency = 1
    TitleText.ZIndex = 3
    TitleText.Parent = TitleBar

    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Size = UDim2.new(0, 22, 0, 22)
    MinimizeBtn.Position = UDim2.new(1, -55, 0, 6)
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(25, 60, 45)
    MinimizeBtn.BackgroundTransparency = 0.2
    MinimizeBtn.Text = "-"
    MinimizeBtn.TextColor3 = Color3.fromRGB(0, 255, 170)
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
    CloseBtn.BackgroundColor3 = Color3.fromRGB(25, 60, 45)
    CloseBtn.BackgroundTransparency = 0.2
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(0, 255, 170)
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

    local TabBar = Instance.new("Frame")
    TabBar.Size = UDim2.new(1, -24, 0, 30)
    TabBar.Position = UDim2.new(0, 12, 0, 38)
    TabBar.BackgroundTransparency = 1
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

    function Window:CreateTab(tabName)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(0, 85, 1, 0)
        TabBtn.BackgroundColor3 = Color3.fromRGB(25, 45, 35)
        TabBtn.BackgroundTransparency = 0.3
        TabBtn.Text = tabName
        TabBtn.TextColor3 = Color3.fromRGB(150, 180, 165)
        TabBtn.Font = PixelFont
        TabBtn.TextSize = 13
        TabBtn.ZIndex = 3
        TabBtn.Parent = TabBar

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabBtn

        local TabScroll = Instance.new("ScrollingFrame")
        TabScroll.Name = "Container_" .. tabName
        TabScroll.Size = UDim2.new(1, -24, 1, -80)
        TabScroll.Position = UDim2.new(0, 12, 0, 74)
        TabScroll.BackgroundTransparency = 1
        TabScroll.BorderSizePixel = 0
        TabScroll.ScrollBarThickness = 3
        TabScroll.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 170)
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

        TabBtn.MouseButton1Click:Connect(function()
            if ActiveTabBtn then
                ActiveTabBtn.BackgroundColor3 = Color3.fromRGB(25, 45, 35)
                ActiveTabBtn.BackgroundTransparency = 0.3
                ActiveTabBtn.TextColor3 = Color3.fromRGB(150, 180, 165)
            end
            if ActiveContainer then
                ActiveContainer.Visible = false
            end

            TabBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 110)
            TabBtn.BackgroundTransparency = 0.1
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabScroll.Visible = true

            ActiveTabBtn = TabBtn
            ActiveContainer = TabScroll
        end)

        if not ActiveTabBtn then
            TabBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 110)
            TabBtn.BackgroundTransparency = 0.1
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
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
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(15, 28, 22)
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
            SwitchBg.BackgroundColor3 = toggled and Color3.fromRGB(0, 180, 110) or Color3.fromRGB(40, 55, 48)
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
                TweenService:Create(SwitchBg, TweenInfo.new(0.2), {BackgroundColor3 = toggled and Color3.fromRGB(0, 180, 110) or Color3.fromRGB(40, 55, 48)}):Play()
                TweenService:Create(SwitchDot, TweenInfo.new(0.2), {Position = toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)}):Play()
                callback(toggled)
            end)
        end

        function Elements:AddButton(text, callback)
            callback = callback or function() end

            local BtnFrame = Instance.new("Frame")
            BtnFrame.Size = UDim2.new(1, 0, 0, 38)
            BtnFrame.BackgroundColor3 = Color3.fromRGB(20, 38, 30)
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
                TweenService:Create(BtnFrame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 160, 100)}):Play()
                task.delay(0.1, function()
                    TweenService:Create(BtnFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20, 38, 30)}):Play()
                end)
                callback()
            end)
        end

        function Elements:AddSlider(text, min, max, default, callback)
            callback = callback or function() end
            local val = math.clamp(default or min, min, max)

            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(1, 0, 0, 46)
            SliderFrame.BackgroundColor3 = Color3.fromRGB(15, 28, 22)
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
            ValLabel.TextColor3 = Color3.fromRGB(0, 255, 170)
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
            Fill.BackgroundColor3 = Color3.fromRGB(0, 180, 110)
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
            BoxFrame.BackgroundColor3 = Color3.fromRGB(15, 28, 22)
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
            InputBox.BackgroundColor3 = Color3.fromRGB(10, 18, 14)
            InputBox.BackgroundTransparency = 0.2
            InputBox.Text = ""
            InputBox.PlaceholderText = placeholder or "Input..."
            InputBox.PlaceholderColor3 = Color3.fromRGB(100, 130, 115)
            InputBox.TextColor3 = Color3.fromRGB(0, 255, 170)
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
            DropFrame.BackgroundColor3 = Color3.fromRGB(15, 28, 22)
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
            DLabel.Text = selected and (text .. ": " .. tostring(selected)) or text
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
            Arrow.TextColor3 = Color3.fromRGB(0, 255, 170)
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
                OptionBtn.BackgroundColor3 = Color3.fromRGB(20, 38, 30)
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
                    DLabel.Text = text .. ": " .. tostring(selected)
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
            DropFrame.BackgroundColor3 = Color3.fromRGB(15, 28, 22)
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
            Arrow.TextColor3 = Color3.fromRGB(0, 255, 170)
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
                OptionBtn.BackgroundColor3 = Color3.fromRGB(20, 38, 30)
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
                CheckBox.BackgroundColor3 = Color3.fromRGB(40, 55, 48)
                CheckBox.ZIndex = 6
                CheckBox.Parent = OptionBtn

                local CheckCorner = Instance.new("UICorner")
                CheckCorner.CornerRadius = UDim.new(0, 6)
                CheckCorner.Parent = CheckBox

                OptionBtn.MouseButton1Click:Connect(function()
                    checked = not checked
                    selectedSet[optionText] = checked
                    selectedCount = selectedCount + (checked and 1 or -1)
                    TweenService:Create(CheckBox, TweenInfo.new(0.2), {BackgroundColor3 = checked and Color3.fromRGB(0, 180, 110) or Color3.fromRGB(40, 55, 48)}):Play()
                    UpdateLabel()
                    callback(selectedSet)
                end)
            end
        end

        return Elements
    end

    return Window
end

return Library
