local WynfUi = {}
WynfUi.__index = WynfUi

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")

local Icons = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/Main-v2.lua"))()
Icons.SetIconsType("lucide")

local c3 = Color3.fromRGB
local ti = TweenInfo.new
local ud2 = UDim2.new
local ud = UDim.new
local v2 = Vector2.new

local FONT_BOLD = Enum.Font.GothamBold
local FONT_NORMAL = Enum.Font.Gotham
local FONT_MEDIUM = Enum.Font.GothamMedium

local function resolveIcon(v)
	v = tostring(v or "")
	if v:find("rbxassetid://") then
		return v
	end
	local ok, res = pcall(Icons.GetIcon, v)
	if ok and typeof(res) == "string" then
		return res
	end
	return ""
end

local function makeTheme(t)
	t.Disabled = t.Disabled or t.TextInactive
	return t
end

local THEMES = {
	Purple = makeTheme({
		Background = c3(15, 12, 22), SecondaryBg = c3(10, 8, 15), Border = c3(120, 40, 220),
		Accent = c3(100, 30, 150), TextInactive = c3(200, 150, 255), Disabled = c3(120, 100, 160),
		Hover = c3(50, 20, 80), Button = c3(30, 15, 40), Slider = c3(150, 40, 255),
		ToggleOff = c3(40, 15, 70), TabInactive = c3(40, 15, 70), TabActive = c3(100, 30, 150),
		ControlButton = c3(30, 15, 45),
		RGB = {c3(180, 50, 220), c3(150, 50, 200), c3(200, 60, 230), c3(170, 40, 210), c3(190, 70, 240), c3(160, 30, 190)}
	}),
	Red = makeTheme({
		Background = c3(22, 12, 12), SecondaryBg = c3(15, 8, 8), Border = c3(220, 40, 40),
		Accent = c3(180, 30, 30), TextInactive = c3(255, 150, 150), Disabled = c3(160, 100, 100),
		Hover = c3(80, 20, 20), Button = c3(40, 15, 15), Slider = c3(255, 40, 40),
		ToggleOff = c3(70, 15, 15), TabInactive = c3(70, 15, 15), TabActive = c3(180, 30, 30),
		ControlButton = c3(45, 15, 15),
		RGB = {c3(220, 50, 50), c3(200, 50, 50), c3(230, 60, 60), c3(210, 40, 40), c3(240, 70, 70), c3(190, 30, 30)}
	}),
	Blue = makeTheme({
		Background = c3(10, 20, 22), SecondaryBg = c3(5, 12, 15), Border = c3(0, 200, 200),
		Accent = c3(0, 180, 180), TextInactive = c3(150, 255, 255), Disabled = c3(50, 100, 100),
		Hover = c3(15, 60, 60), Button = c3(10, 30, 30), Slider = c3(0, 255, 255),
		ToggleOff = c3(10, 40, 40), TabInactive = c3(10, 40, 40), TabActive = c3(0, 200, 200),
		ControlButton = c3(10, 45, 45),
		RGB = {c3(0, 255, 255), c3(0, 200, 200), c3(50, 255, 255), c3(0, 180, 180), c3(100, 255, 255), c3(0, 220, 220)}
	}),
	Green = makeTheme({
		Background = c3(10, 22, 10), SecondaryBg = c3(5, 15, 5), Border = c3(0, 200, 0),
		Accent = c3(0, 180, 0), TextInactive = c3(150, 255, 150), Disabled = c3(50, 100, 50),
		Hover = c3(15, 60, 15), Button = c3(10, 30, 10), Slider = c3(0, 255, 0),
		ToggleOff = c3(10, 40, 10), TabInactive = c3(10, 40, 10), TabActive = c3(0, 200, 0),
		ControlButton = c3(10, 45, 10),
		RGB = {c3(0, 255, 0), c3(0, 200, 0), c3(50, 255, 50), c3(0, 180, 0), c3(100, 255, 100), c3(0, 220, 0)}
	}),
	Pink = makeTheme({
		Background = c3(22, 10, 16), SecondaryBg = c3(15, 5, 10), Border = c3(255, 20, 147),
		Accent = c3(200, 10, 110), TextInactive = c3(255, 150, 200), Disabled = c3(120, 50, 80),
		Hover = c3(80, 10, 40), Button = c3(40, 10, 20), Slider = c3(255, 20, 147),
		ToggleOff = c3(50, 10, 25), TabInactive = c3(50, 10, 25), TabActive = c3(255, 20, 147),
		ControlButton = c3(45, 15, 25),
		RGB = {c3(255, 20, 147), c3(230, 10, 120), c3(255, 50, 160), c3(200, 0, 100), c3(255, 80, 180), c3(220, 15, 130)}
	}),
	Orange = makeTheme({
		Background = c3(22, 12, 10), SecondaryBg = c3(15, 8, 5), Border = c3(255, 69, 0),
		Accent = c3(200, 50, 0), TextInactive = c3(255, 180, 150), Disabled = c3(120, 60, 40),
		Hover = c3(80, 25, 10), Button = c3(40, 15, 10), Slider = c3(255, 69, 0),
		ToggleOff = c3(50, 15, 10), TabInactive = c3(50, 15, 10), TabActive = c3(255, 69, 0),
		ControlButton = c3(45, 20, 15),
		RGB = {c3(255, 69, 0), c3(230, 50, 0), c3(255, 90, 30), c3(200, 40, 0), c3(255, 120, 50), c3(220, 60, 0)}
	}),
	Yellow = makeTheme({
		Background = c3(22, 22, 8), SecondaryBg = c3(15, 15, 5), Border = c3(200, 200, 0),
		Accent = c3(180, 180, 0), TextInactive = c3(255, 255, 150), Disabled = c3(100, 100, 40),
		Hover = c3(80, 80, 10), Button = c3(40, 40, 10), Slider = c3(255, 255, 0),
		ToggleOff = c3(50, 50, 10), TabInactive = c3(50, 50, 10), TabActive = c3(200, 200, 0),
		ControlButton = c3(45, 45, 15),
		RGB = {c3(255, 255, 0), c3(230, 230, 0), c3(255, 255, 50), c3(200, 200, 0), c3(255, 255, 100), c3(220, 220, 0)}
	}),
	Grey = makeTheme({
		Background = c3(35, 35, 40), SecondaryBg = c3(25, 25, 30), Border = c3(120, 120, 130),
		Accent = c3(160, 160, 170), TextInactive = c3(180, 180, 190), Disabled = c3(80, 80, 90),
		Hover = c3(60, 60, 70), Button = c3(45, 45, 50), Slider = c3(180, 180, 190),
		ToggleOff = c3(50, 50, 60), TabInactive = c3(40, 40, 45), TabActive = c3(140, 140, 150),
		ControlButton = c3(50, 50, 55),
		RGB = {c3(150, 150, 160), c3(130, 130, 140), c3(170, 170, 180), c3(110, 110, 120), c3(190, 190, 200), c3(140, 140, 150)}
	}),
	Black = makeTheme({
		Background = c3(8, 8, 8), SecondaryBg = c3(5, 5, 5), Border = c3(60, 60, 60),
		Accent = c3(150, 150, 150), TextInactive = c3(150, 150, 150), Disabled = c3(40, 40, 40),
		Hover = c3(20, 20, 20), Button = c3(15, 15, 15), Slider = c3(200, 200, 200),
		ToggleOff = c3(30, 30, 30), TabInactive = c3(20, 20, 20), TabActive = c3(150, 150, 150),
		ControlButton = c3(25, 25, 25),
		RGB = {c3(120, 120, 120), c3(100, 100, 100), c3(140, 140, 140), c3(90, 90, 90), c3(150, 150, 150), c3(110, 110, 110)}
	})
}

local THEME_NAMES = {"Purple", "Red", "Blue", "Green", "Pink", "Orange", "Yellow", "Grey", "Black"}

local WHITE = c3(255, 255, 255)
local RED_CLOSE = c3(180, 40, 40)

local COLOR_KEYS = {"Background", "SecondaryBg", "Border", "Accent", "TextInactive", "Disabled", "Hover", "Button", "Slider", "ToggleOff", "TabInactive", "TabActive", "ControlButton"}

local function normalizeMode(v)
	if string.find(string.lower(tostring(v or "")), "multi") then
		return "MultiWindow"
	end
	return "NormalWindow"
end

local function recolorGui(gui, oldT, newT)
	local map = {}
	for _, k in ipairs(COLOR_KEYS) do
		if oldT[k] and newT[k] then
			table.insert(map, {oldT[k], newT[k]})
		end
	end

	local function mapIn(c)
		for _, p in ipairs(map) do
			if c == p[1] then
				return p[2]
			end
		end
		return nil
	end

	for _, d in ipairs(gui:GetDescendants()) do
		if d:IsA("UIGradient") then
			local kps = {}
			for _, kp in ipairs(d.Color.Keypoints) do
				table.insert(kps, ColorSequenceKeypoint.new(kp.Time, mapIn(kp.Value) or kp.Value))
			end
			d.Color = ColorSequence.new(kps)
		elseif d:IsA("UIStroke") then
			local c = mapIn(d.Color)
			if c then d.Color = c end
		elseif d:IsA("GuiObject") then
			local c = mapIn(d.BackgroundColor3)
			if c then d.BackgroundColor3 = c end
			if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
				c = mapIn(d.TextColor3)
				if c then d.TextColor3 = c end
			end
			if d:IsA("ImageLabel") or d:IsA("ImageButton") then
				c = mapIn(d.ImageColor3)
				if c then d.ImageColor3 = c end
			end
			if d:IsA("ScrollingFrame") then
				c = mapIn(d.ScrollBarImageColor3)
				if c then d.ScrollBarImageColor3 = c end
			end
		end
	end
end

local function addStroke(parent, color, thickness, transparency)
	local s = Instance.new("UIStroke", parent)
	s.Color = color
	s.Thickness = thickness or 1
	s.Transparency = transparency or 0
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	return s
end

local function addSubtleGradient(parent)
	local g = Instance.new("UIGradient", parent)
	g.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, c3(255, 255, 255)),
		ColorSequenceKeypoint.new(1, c3(127, 127, 127))
	})
	g.Rotation = 90
	return g
end

function WynfUi:CreateWindow(config)
	config = config or {}
	local title = config.Title or "Wynf Ui"
	local T = THEMES[config.Theme or "Purple"] or THEMES.Purple
	local rgbColors = T.RGB
	local rgbStrokes = {}

	local function trackRgb(s)
		table.insert(rgbStrokes, s)
		s.Color = rgbColors[1]
		return s
	end

	if CoreGui:FindFirstChild("WynfUi_" .. title) then
		CoreGui:FindFirstChild("WynfUi_" .. title):Destroy()
	end

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "WynfUi_" .. title
	ScreenGui.Parent = CoreGui
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.DisplayOrder = 999
	ScreenGui.ResetOnSpawn = false

	local W, H = 360, 400
	local TITLE_H = 40
	local TAB_H = 34
	local TABS_Y = TITLE_H + 6
	local CONTENT_Y = TITLE_H + TAB_H + 14

	local ConfigState = {
		Theme = config.Theme or "Purple",
		Transparency = 0,
		SaveMode = "Manual Save"
	}
	local ConfigName = "config"

	local Main = Instance.new("Frame")
	Main.Name = "MainWindow"
	Main.Parent = ScreenGui
	Main.Size = ud2(0, W, 0, H)
	Main.Position = ud2(0.5, -(W / 2), 0.5, -(H / 2))
	Main.BackgroundColor3 = c3(255, 255, 255)
	Main.BorderSizePixel = 0
	Main.ClipsDescendants = true
	Main.Active = true
	Instance.new("UICorner", Main).CornerRadius = ud(0, 3)

	local mainGrad = Instance.new("UIGradient", Main)
	mainGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, T.Background),
		ColorSequenceKeypoint.new(0.4, T.Background),
		ColorSequenceKeypoint.new(0.5, T.Accent),
		ColorSequenceKeypoint.new(0.6, T.Background),
		ColorSequenceKeypoint.new(1, T.Background)
	})
	mainGrad.Rotation = 45

	local mainStroke = trackRgb(Instance.new("UIStroke", Main))
	mainStroke.Thickness = 2
	mainStroke.Transparency = 0
	mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	local colorIndex = 1
	RunService.Heartbeat:Connect(function()
		colorIndex = colorIndex + 0.008
		if colorIndex > #rgbColors then
			colorIndex = 1
		end
		local i = math.floor(colorIndex)
		local nextC = rgbColors[i % #rgbColors + 1]
		local current = rgbColors[i]:Lerp(nextC, colorIndex - i)
		for k = #rgbStrokes, 1, -1 do
			local s = rgbStrokes[k]
			if s.Parent then
				s.Color = current
			else
				table.remove(rgbStrokes, k)
			end
		end
		mainGrad.Offset = v2(math.sin(tick() * 0.5) * 0.7, math.cos(tick() * 0.5) * 0.7)
	end)

	local TitleBar = Instance.new("Frame", Main)
	TitleBar.Name = "TitleBar"
	TitleBar.Size = ud2(1, 0, 0, TITLE_H)
	TitleBar.BackgroundColor3 = T.SecondaryBg
	TitleBar.BackgroundTransparency = 0.1
	TitleBar.BorderSizePixel = 0
	TitleBar.ZIndex = 20
	Instance.new("UICorner", TitleBar).CornerRadius = ud(0, 3)

	local TitleLabel = Instance.new("TextLabel", TitleBar)
	TitleLabel.Size = ud2(0.6, 0, 1, 0)
	TitleLabel.Position = ud2(0, 12, 0, 0)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Text = title
	TitleLabel.TextColor3 = WHITE
	TitleLabel.Font = FONT_BOLD
	TitleLabel.TextSize = 14
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.TextTruncate = Enum.TextTruncate.AtEnd
	TitleLabel.ZIndex = 21

	local MinimizeBtn = Instance.new("TextButton", TitleBar)
	MinimizeBtn.Size = ud2(0, 24, 0, 24)
	MinimizeBtn.Position = ud2(1, -62, 0.5, -12)
	MinimizeBtn.BackgroundColor3 = T.ControlButton
	MinimizeBtn.Text = "-"
	MinimizeBtn.TextColor3 = T.TextInactive
	MinimizeBtn.Font = FONT_BOLD
	MinimizeBtn.TextSize = 18
	MinimizeBtn.AutoButtonColor = false
	MinimizeBtn.ZIndex = 21
	Instance.new("UICorner", MinimizeBtn).CornerRadius = ud(1, 0)
	addStroke(MinimizeBtn, T.Border, 1, 0)

	local CloseBtn = Instance.new("TextButton", TitleBar)
	CloseBtn.Size = ud2(0, 24, 0, 24)
	CloseBtn.Position = ud2(1, -32, 0.5, -12)
	CloseBtn.BackgroundColor3 = T.ControlButton
	CloseBtn.Text = ">"
	CloseBtn.TextColor3 = T.TextInactive
	CloseBtn.Font = FONT_BOLD
	CloseBtn.TextSize = 14
	CloseBtn.AutoButtonColor = false
	CloseBtn.ZIndex = 21
	Instance.new("UICorner", CloseBtn).CornerRadius = ud(1, 0)
	addStroke(CloseBtn, T.Border, 1, 0)

	CloseBtn.MouseEnter:Connect(function()
		TweenService:Create(CloseBtn, ti(0.2), {BackgroundColor3 = RED_CLOSE}):Play()
	end)
	CloseBtn.MouseLeave:Connect(function()
		TweenService:Create(CloseBtn, ti(0.2), {BackgroundColor3 = T.ControlButton}):Play()
	end)
	MinimizeBtn.MouseEnter:Connect(function()
		TweenService:Create(MinimizeBtn, ti(0.2), {BackgroundColor3 = T.Hover}):Play()
	end)
	MinimizeBtn.MouseLeave:Connect(function()
		TweenService:Create(MinimizeBtn, ti(0.2), {BackgroundColor3 = T.ControlButton}):Play()
	end)

	local TabsScroll = Instance.new("ScrollingFrame", Main)
	TabsScroll.Name = "TabsScroll"
	TabsScroll.Position = ud2(0, 0, 0, TABS_Y)
	TabsScroll.Size = ud2(1, 0, 0, TAB_H + 6)
	TabsScroll.BackgroundTransparency = 1
	TabsScroll.BorderSizePixel = 0
	TabsScroll.ScrollBarThickness = 0
	TabsScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
	TabsScroll.CanvasSize = ud2(0, 0, 0, 0)
	TabsScroll.ScrollingDirection = Enum.ScrollingDirection.X
	TabsScroll.ZIndex = 10

	local TabsContainer = Instance.new("Frame", TabsScroll)
	TabsContainer.Name = "TabsContainer"
	TabsContainer.Size = ud2(0, 0, 1, 0)
	TabsContainer.AutomaticSize = Enum.AutomaticSize.X
	TabsContainer.BackgroundTransparency = 1
	TabsContainer.ZIndex = 10

	local TabsPadding = Instance.new("UIPadding", TabsContainer)
	TabsPadding.PaddingLeft = ud(0, 8)
	TabsPadding.PaddingRight = ud(0, 8)

	local TabsList = Instance.new("UIListLayout", TabsContainer)
	TabsList.FillDirection = Enum.FillDirection.Horizontal
	TabsList.Padding = ud(0, 4)
	TabsList.SortOrder = Enum.SortOrder.LayoutOrder
	TabsList.VerticalAlignment = Enum.VerticalAlignment.Center

	local ContentArea = Instance.new("Frame", Main)
	ContentArea.Name = "ContentArea"
	ContentArea.Size = ud2(1, -16, 1, -(CONTENT_Y + 8))
	ContentArea.Position = ud2(0, 8, 0, CONTENT_Y)
	ContentArea.BackgroundColor3 = T.SecondaryBg
	ContentArea.BackgroundTransparency = 0.4
	ContentArea.BorderSizePixel = 0
	ContentArea.ClipsDescendants = true
	ContentArea.ZIndex = 5
	Instance.new("UICorner", ContentArea).CornerRadius = ud(0, 3)
	addStroke(ContentArea, T.Border, 1, 0.5)

	local dragging, dragStart, startPos
	TitleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = Main.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			Main.Position = ud2(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	local minimized = false
	local fullSize = Main.Size
	MinimizeBtn.MouseButton1Click:Connect(function()
		minimized = not minimized
		if minimized then
			TabsScroll.Visible = false
			ContentArea.Visible = false
			MinimizeBtn.Text = "+"
			TweenService:Create(Main, ti(0.3, Enum.EasingStyle.Quart), {Size = ud2(0, W, 0, TITLE_H)}):Play()
		else
			MinimizeBtn.Text = "-"
			TweenService:Create(Main, ti(0.3, Enum.EasingStyle.Quart), {Size = fullSize}):Play()
			task.delay(0.2, function()
				if not minimized then
					TabsScroll.Visible = true
					ContentArea.Visible = true
				end
			end)
		end
	end)

	CloseBtn.MouseButton1Click:Connect(function()
		ScreenGui:Destroy()
	end)

	local FloatBtn = Instance.new("ImageButton", ScreenGui)
	FloatBtn.Name = "FloatBtn"
	FloatBtn.Size = ud2(0, 46, 0, 46)
	FloatBtn.Position = ud2(1, -70, 1, -90)
	FloatBtn.BackgroundColor3 = T.SecondaryBg
	FloatBtn.BackgroundTransparency = 0
	FloatBtn.Image = "rbxassetid://114170833075159"
	FloatBtn.ScaleType = Enum.ScaleType.Crop
	FloatBtn.AutoButtonColor = false
	FloatBtn.ZIndex = 500
	Instance.new("UICorner", FloatBtn).CornerRadius = ud(0, 4)
	trackRgb(Instance.new("UIStroke", FloatBtn)).Thickness = 2

	local floatDragging, floatDragStart, floatStartPos, floatMoved
	FloatBtn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			floatDragging = true
			floatMoved = false
			floatDragStart = input.Position
			floatStartPos = FloatBtn.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then floatDragging = false end
			end)
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if floatDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - floatDragStart
			if delta.Magnitude > 4 then floatMoved = true end
			FloatBtn.Position = ud2(floatStartPos.X.Scale, floatStartPos.X.Offset + delta.X, floatStartPos.Y.Scale, floatStartPos.Y.Offset + delta.Y)
		end
	end)

	FloatBtn.MouseButton1Click:Connect(function()
		if floatMoved then return end
		Main.Visible = not Main.Visible
	end)

	local tabs = {}
	local activeTab = nil
	local tabOrder = 1

	local Window = {}

	local function makeSearchBox(parent, placeholder)
		local holder = Instance.new("Frame", parent)
		holder.Size = ud2(1, -12, 0, 26)
		holder.Position = ud2(0, 6, 0, 6)
		holder.BackgroundColor3 = T.Button
		holder.BorderSizePixel = 0
		holder.ZIndex = 12
		Instance.new("UICorner", holder).CornerRadius = ud(0, 3)
		addStroke(holder, T.Border, 1, 0.4)

		local box = Instance.new("TextBox", holder)
		box.Size = ud2(1, -30, 1, 0)
		box.Position = ud2(0, 8, 0, 0)
		box.BackgroundTransparency = 1
		box.Text = ""
		box.PlaceholderText = placeholder
		box.PlaceholderColor3 = T.TextInactive
		box.TextColor3 = WHITE
		box.Font = FONT_NORMAL
		box.TextSize = 12
		box.TextXAlignment = Enum.TextXAlignment.Left
		box.ClearTextOnFocus = false
		box.ZIndex = 13

		local icon = Instance.new("ImageLabel", holder)
		icon.Size = ud2(0, 14, 0, 14)
		icon.AnchorPoint = v2(1, 0.5)
		icon.Position = ud2(1, -8, 0.5, 0)
		icon.BackgroundTransparency = 1
		icon.Image = resolveIcon("search")
		icon.ImageColor3 = T.TextInactive
		icon.ZIndex = 13

		return holder, box
	end

	function Window:AddTab(tabConfig)
		tabConfig = tabConfig or {}
		local tabName = tabConfig.Name or "Tab"
		local tabIcon = tabConfig.Icon
		local curMode = normalizeMode(tabConfig.Mode or tabConfig.Layout or tabConfig.Type)
		tabOrder = tabOrder + 1

		local textW = TextService:GetTextSize(tabName, 11, FONT_BOLD, v2(9999, TAB_H)).X
		local padX = 10
		local iconW = tabIcon and 16 or 0
		local gap = tabIcon and 6 or 0
		local btnW = padX + iconW + gap + textW + padX

		local TabBtn = Instance.new("TextButton", TabsContainer)
		TabBtn.Size = ud2(0, btnW, 0, TAB_H)
		TabBtn.BackgroundColor3 = T.TabInactive
		TabBtn.Text = ""
		TabBtn.AutoButtonColor = false
		TabBtn.LayoutOrder = tabOrder
		TabBtn.ZIndex = 11
		Instance.new("UICorner", TabBtn).CornerRadius = ud(0, 3)
		addStroke(TabBtn, T.Border, 1, 0)
		addSubtleGradient(TabBtn)

		local TabLabel = Instance.new("TextLabel", TabBtn)
		TabLabel.Size = ud2(0, textW, 1, 0)
		TabLabel.Position = ud2(0, padX + iconW + gap, 0, 0)
		TabLabel.BackgroundTransparency = 1
		TabLabel.Text = tabName
		TabLabel.TextColor3 = T.TextInactive
		TabLabel.Font = FONT_BOLD
		TabLabel.TextSize = 11
		TabLabel.TextXAlignment = Enum.TextXAlignment.Left
		TabLabel.ZIndex = 12

		local TabIcon
		if tabIcon then
			TabIcon = Instance.new("ImageLabel", TabBtn)
			TabIcon.Size = ud2(0, 13, 0, 13)
			TabIcon.Position = ud2(0, padX, 0.5, -6)
			TabIcon.BackgroundTransparency = 1
			TabIcon.Image = resolveIcon(tabIcon)
			TabIcon.ImageColor3 = T.TextInactive
			TabIcon.ZIndex = 12
		end

		local TabWrapper = Instance.new("CanvasGroup", ContentArea)
		TabWrapper.Name = "Wrap_" .. tabName
		TabWrapper.Size = ud2(1, 0, 1, 0)
		TabWrapper.BackgroundTransparency = 1
		TabWrapper.BorderSizePixel = 0
		TabWrapper.ZIndex = 6
		TabWrapper.Visible = false
		TabWrapper.GroupTransparency = 0

		local elemSearchHolder, elemSearchBox = makeSearchBox(TabWrapper, "Search element...")

		local ScrollContainer = Instance.new("ScrollingFrame", TabWrapper)
		ScrollContainer.Name = "Tab_" .. tabName
		ScrollContainer.Position = ud2(0, 0, 0, 38)
		ScrollContainer.Size = ud2(1, 0, 1, -38)
		ScrollContainer.BackgroundTransparency = 1
		ScrollContainer.BorderSizePixel = 0
		ScrollContainer.ScrollBarThickness = 3
		ScrollContainer.ScrollBarImageColor3 = T.Border
		ScrollContainer.ScrollingDirection = Enum.ScrollingDirection.Y
		ScrollContainer.CanvasSize = ud2(0, 0, 0, 0)
		ScrollContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
		ScrollContainer.ZIndex = 6
		ScrollContainer.ClipsDescendants = true

		local Pad = Instance.new("UIPadding", ScrollContainer)
		Pad.PaddingLeft = ud(0, 8)
		Pad.PaddingRight = ud(0, 8)
		Pad.PaddingTop = ud(0, 4)
		Pad.PaddingBottom = ud(0, 12)

		local List = Instance.new("UIListLayout", ScrollContainer)
		List.SortOrder = Enum.SortOrder.LayoutOrder
		List.Padding = ud(0, 6)

		local itemEntries = {}
		local elemQuery = ""

		local function register(frame, text, isSection)
			local lowered = string.lower(tostring(text or ""))
			table.insert(itemEntries, {Frame = frame, Text = lowered, IsSection = isSection or false})
			if isSection then
				frame.Visible = elemQuery == ""
			else
				frame.Visible = elemQuery == "" or lowered:find(elemQuery, 1, true) ~= nil
			end
		end

		elemSearchBox:GetPropertyChangedSignal("Text"):Connect(function()
			elemQuery = string.lower(elemSearchBox.Text)
			for _, e in ipairs(itemEntries) do
				if e.IsSection then
					e.Frame.Visible = elemQuery == ""
				else
					e.Frame.Visible = elemQuery == "" or e.Text:find(elemQuery, 1, true) ~= nil
				end
			end
		end)

		local function activateTab()
			if activeTab then
				local prev = activeTab
				TweenService:Create(prev.Btn, ti(0.2), {BackgroundColor3 = T.TabInactive}):Play()
				TweenService:Create(prev.Label, ti(0.2), {TextColor3 = T.TextInactive}):Play()
				if prev.Icon then
					TweenService:Create(prev.Icon, ti(0.2), {ImageColor3 = T.TextInactive}):Play()
				end
				prev.Wrapper.Visible = false
			end
			activeTab = {Wrapper = TabWrapper, Btn = TabBtn, Label = TabLabel, Icon = TabIcon}
			TabWrapper.GroupTransparency = 1
			TabWrapper.Visible = true
			TweenService:Create(TabWrapper, ti(0.25, Enum.EasingStyle.Quad), {GroupTransparency = 0}):Play()
			TweenService:Create(TabBtn, ti(0.2), {BackgroundColor3 = T.TabActive}):Play()
			TweenService:Create(TabLabel, ti(0.2), {TextColor3 = WHITE}):Play()
			if TabIcon then
				TweenService:Create(TabIcon, ti(0.2), {ImageColor3 = WHITE}):Play()
			end
		end

		TabBtn.MouseButton1Click:Connect(activateTab)
		TabBtn.MouseEnter:Connect(function()
			if not (activeTab and activeTab.Btn == TabBtn) then
				TweenService:Create(TabBtn, ti(0.2), {BackgroundColor3 = T.Hover}):Play()
			end
		end)
		TabBtn.MouseLeave:Connect(function()
			if not (activeTab and activeTab.Btn == TabBtn) then
				TweenService:Create(TabBtn, ti(0.2), {BackgroundColor3 = T.TabInactive}):Play()
			end
		end)
		if #tabs == 0 then activateTab() end
		table.insert(tabs, {Wrapper = TabWrapper, Btn = TabBtn})

		local itemOrder = 0
		local layoutItems = {}
		local pairFrames = {}
		local Tab = {}

		local function relayout()
			for _, it in ipairs(layoutItems) do
				it.frame.Parent = ScrollContainer
				it.frame.LayoutOrder = it.order
				it.frame.Position = ud2(0, 0, 0, 0)
				it.frame.Size = ud2(1, 0, 0, it.h)
			end
			for _, p in ipairs(pairFrames) do
				p:Destroy()
			end
			pairFrames = {}
			if curMode ~= "MultiWindow" then return end
			local pending = nil
			for _, it in ipairs(layoutItems) do
				if it.isBreak then
					pending = nil
				elseif pending == nil then
					local pair = Instance.new("Frame", ScrollContainer)
					pair.Size = ud2(1, 0, 0, it.h)
					pair.BackgroundTransparency = 1
					pair.BorderSizePixel = 0
					pair.LayoutOrder = it.order
					pair.ZIndex = 6
					table.insert(pairFrames, pair)
					it.frame.Parent = pair
					it.frame.Size = ud2(0.5, -3, 0, it.h)
					it.frame.Position = ud2(0, 0, 0, 0)
					pending = pair
				else
					it.frame.Parent = pending
					it.frame.Size = ud2(0.5, -3, 0, it.h)
					it.frame.Position = ud2(0.5, 3, 0, 0)
					if it.h > pending.Size.Y.Offset then
						pending.Size = ud2(1, 0, 0, it.h)
					end
					pending = nil
				end
			end
		end

		local function addItem(frame, h, isBreak)
			table.insert(layoutItems, {frame = frame, h = h, order = frame.LayoutOrder, isBreak = isBreak})
			relayout()
		end

		local function makeRow(h, text, bgColor, bgTransparency)
			itemOrder = itemOrder + 1
			local row = Instance.new("Frame", ScrollContainer)
			row.Size = ud2(1, 0, 0, h or 32)
			row.BackgroundColor3 = bgColor or T.Button
			row.BackgroundTransparency = bgTransparency == nil and 1 or bgTransparency
			row.BorderSizePixel = 0
			row.LayoutOrder = itemOrder
			row.ZIndex = 6
			row.ClipsDescendants = false
			if bgColor or (bgTransparency ~= nil and bgTransparency < 1) then
				Instance.new("UICorner", row).CornerRadius = ud(0, 3)
			end
			register(row, text)
			addItem(row, h or 32, false)
			return row
		end

		local function makeLabel(parent, text, icon)
			local textX = 4
			if icon and tostring(icon) ~= "" then
				local ic = Instance.new("ImageLabel", parent)
				ic.Size = ud2(0, 16, 0, 16)
				ic.Position = ud2(0, 6, 0.5, -8)
				ic.BackgroundTransparency = 1
				ic.Image = resolveIcon(icon)
				ic.ImageColor3 = T.TextInactive
				ic.ZIndex = 7
				textX = 28
			end
			local lbl = Instance.new("TextLabel", parent)
			lbl.Size = ud2(0.5, -textX, 1, 0)
			lbl.Position = ud2(0, textX, 0, 0)
			lbl.BackgroundTransparency = 1
			lbl.Text = text
			lbl.TextColor3 = WHITE
			lbl.Font = FONT_BOLD
			lbl.TextSize = 13
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.TextTruncate = Enum.TextTruncate.AtEnd
			lbl.ZIndex = 7
			return lbl
		end

		local function clickEffect(obj)
			local eff = Instance.new("Frame", obj)
			eff.Size = ud2(1, 0, 1, 0)
			eff.BackgroundColor3 = T.Accent
			eff.BackgroundTransparency = 0.7
			eff.BorderSizePixel = 0
			eff.ZIndex = 26
			local corner = obj:FindFirstChildWhichIsA("UICorner")
			local c = Instance.new("UICorner", eff)
			c.CornerRadius = corner and corner.CornerRadius or ud(0, 5)
			TweenService:Create(eff, ti(0.3), {BackgroundTransparency = 1}):Play()
			task.delay(0.32, function() eff:Destroy() end)
		end

		function Tab:SetMode(mode)
			curMode = normalizeMode(mode)
			relayout()
		end

		function Tab:AddSection(secConfig)
			secConfig = secConfig or {}
			local name = secConfig.Name or "Section"
			itemOrder = itemOrder + 1
			local secRow = Instance.new("Frame", ScrollContainer)
			secRow.Size = ud2(1, 0, 0, 22)
			secRow.BackgroundTransparency = 1
			secRow.LayoutOrder = itemOrder
			secRow.ZIndex = 6
			register(secRow, name, true)

			local textX = 2
			if secConfig.Icon then
				local secIcon = Instance.new("ImageLabel", secRow)
				secIcon.Size = ud2(0, 13, 0, 13)
				secIcon.Position = ud2(0, 2, 0.5, -6)
				secIcon.BackgroundTransparency = 1
				secIcon.Image = resolveIcon(secConfig.Icon)
				secIcon.ImageColor3 = T.TextInactive
				secIcon.ZIndex = 7
				textX = 20
			end

			local secLabel = Instance.new("TextLabel", secRow)
			secLabel.Size = ud2(1, -textX, 1, 0)
			secLabel.Position = ud2(0, textX, 0, 0)
			secLabel.BackgroundTransparency = 1
			secLabel.Text = name
			secLabel.TextColor3 = T.TextInactive
			secLabel.Font = FONT_BOLD
			secLabel.TextSize = 11
			secLabel.TextXAlignment = Enum.TextXAlignment.Left
			secLabel.ZIndex = 7

			local secLine = Instance.new("Frame", secRow)
			secLine.Size = ud2(1, -4, 0, 1)
			secLine.Position = ud2(0, 2, 1, -1)
			secLine.BackgroundColor3 = T.Border
			secLine.BackgroundTransparency = 0.5
			secLine.BorderSizePixel = 0
			secLine.ZIndex = 7

			addItem(secRow, 22, true)
		end

		function Tab:AddButton(btnConfig)
			btnConfig = btnConfig or {}
			local name = btnConfig.Name or "Button"
			local callback = btnConfig.Callback or function() end
			local row = makeRow(44, name, T.Button, 0)
			row.ClipsDescendants = true
			addStroke(row, T.Border, 1, 0.4)
			addSubtleGradient(row)

			local btn = Instance.new("TextButton", row)
			btn.Size = ud2(1, 0, 1, 0)
			btn.BackgroundTransparency = 1
			btn.Text = name
			btn.TextColor3 = WHITE
			btn.Font = FONT_BOLD
			btn.TextSize = 13
			btn.ZIndex = 8

			if btnConfig.Icon then
				local ic = Instance.new("ImageLabel", row)
				ic.Size = ud2(0, 16, 0, 16)
				ic.AnchorPoint = v2(1, 0.5)
				ic.Position = ud2(1, -10, 0.5, 0)
				ic.BackgroundTransparency = 1
				ic.Image = resolveIcon(btnConfig.Icon)
				ic.ImageColor3 = T.TextInactive
				ic.ZIndex = 8
			end

			btn.MouseEnter:Connect(function()
				TweenService:Create(row, ti(0.2), {BackgroundColor3 = T.Hover, BackgroundTransparency = 0}):Play()
			end)
			btn.MouseLeave:Connect(function()
				TweenService:Create(row, ti(0.2), {BackgroundColor3 = T.Button, BackgroundTransparency = 0}):Play()
			end)
			btn.MouseButton1Click:Connect(function()
				clickEffect(row)
				callback()
			end)
		end

		function Tab:AddToggle(togConfig)
			togConfig = togConfig or {}
			local name = togConfig.Name or "Toggle"
			local default = togConfig.Default or false
			local callback = togConfig.Callback or function() end
			local state = default
			local row = makeRow(32, name)
			makeLabel(row, name, togConfig.Icon)

			local track = Instance.new("Frame", row)
			track.Size = ud2(0, 40, 0, 20)
			track.AnchorPoint = v2(1, 0.5)
			track.Position = ud2(1, -6, 0.5, 0)
			track.BackgroundColor3 = state and T.Slider or T.ToggleOff
			track.BorderSizePixel = 0
			track.ZIndex = 7
			Instance.new("UICorner", track).CornerRadius = ud(1, 0)
			addStroke(track, T.Border, 1, 0.4)

			local knob = Instance.new("Frame", track)
			knob.Size = ud2(0, 16, 0, 16)
			knob.Position = ud2(0, state and 21 or 2, 0.5, -8)
			knob.BackgroundColor3 = WHITE
			knob.BorderSizePixel = 0
			knob.ZIndex = 8
			Instance.new("UICorner", knob).CornerRadius = ud(1, 0)

			local btn = Instance.new("TextButton", row)
			btn.Size = ud2(1, 0, 1, 0)
			btn.BackgroundTransparency = 1
			btn.Text = ""
			btn.ZIndex = 9
			btn.MouseButton1Click:Connect(function()
				state = not state
				TweenService:Create(knob, ti(0.2), {Position = ud2(0, state and 21 or 2, 0.5, -8)}):Play()
				TweenService:Create(track, ti(0.2), {BackgroundColor3 = state and T.Slider or T.ToggleOff}):Play()
				callback(state)
			end)
		end

		function Tab:AddInput(inputConfig)
			inputConfig = inputConfig or {}
			local name = inputConfig.Name or "Input"
			local placeholder = inputConfig.Placeholder or "Enter text..."
			local callback = inputConfig.Callback or function() end
			local row = makeRow(32, name)
			makeLabel(row, name, inputConfig.Icon)

			local inputBg = Instance.new("Frame", row)
			inputBg.Size = ud2(0.42, 0, 0, 24)
			inputBg.AnchorPoint = v2(1, 0.5)
			inputBg.Position = ud2(1, -6, 0.5, 0)
			inputBg.BackgroundColor3 = T.Button
			inputBg.BorderSizePixel = 0
			inputBg.ZIndex = 7
			Instance.new("UICorner", inputBg).CornerRadius = ud(0, 3)
			addStroke(inputBg, T.Border, 1, 0.4)

			local textBox = Instance.new("TextBox", inputBg)
			textBox.Size = ud2(1, -10, 1, 0)
			textBox.Position = ud2(0, 5, 0, 0)
			textBox.BackgroundTransparency = 1
			textBox.Text = ""
			textBox.PlaceholderText = placeholder
			textBox.TextColor3 = WHITE
			textBox.PlaceholderColor3 = T.TextInactive
			textBox.Font = FONT_MEDIUM
			textBox.TextSize = 12
			textBox.TextXAlignment = Enum.TextXAlignment.Left
			textBox.ClearTextOnFocus = false
			textBox.ZIndex = 8

			textBox.FocusLost:Connect(function(enter)
				if enter then callback(textBox.Text) end
			end)
		end

		function Tab:AddSlider(sliderConfig)
			sliderConfig = sliderConfig or {}
			local name = sliderConfig.Name or "Slider"
			local min = sliderConfig.Min or 0
			local max = sliderConfig.Max or 100
			local default = sliderConfig.Default or min
			local callback = sliderConfig.Callback or function() end
			local value = math.clamp(default, min, max)
			local row = makeRow(32, name)
			makeLabel(row, name, sliderConfig.Icon)

			local sliderBox = Instance.new("Frame", row)
			sliderBox.Size = ud2(0.42, 0, 0, 20)
			sliderBox.AnchorPoint = v2(1, 0.5)
			sliderBox.Position = ud2(1, -6, 0.5, 0)
			sliderBox.BackgroundColor3 = T.Button
			sliderBox.BorderSizePixel = 0
			sliderBox.ZIndex = 7
			sliderBox.ClipsDescendants = true
			Instance.new("UICorner", sliderBox).CornerRadius = ud(0, 3)
			addStroke(sliderBox, T.Border, 1, 0.4)

			local fillBar = Instance.new("Frame", sliderBox)
			fillBar.Size = ud2((value - min) / (max - min), 0, 1, 0)
			fillBar.BackgroundColor3 = T.Slider
			fillBar.BorderSizePixel = 0
			fillBar.ZIndex = 8
			Instance.new("UICorner", fillBar).CornerRadius = ud(0, 3)

			local numLabel = Instance.new("TextLabel", sliderBox)
			numLabel.Size = ud2(1, 0, 1, 0)
			numLabel.BackgroundTransparency = 1
			numLabel.Text = tostring(value)
			numLabel.TextColor3 = WHITE
			numLabel.Font = FONT_BOLD
			numLabel.TextSize = 12
			numLabel.ZIndex = 9

			local draggingSlider = false

			local function updateSlider(inputX)
				local abs = sliderBox.AbsolutePosition
				local size = sliderBox.AbsoluteSize
				local rel = math.clamp((inputX - abs.X) / size.X, 0, 1)
				value = math.floor(min + (max - min) * rel + 0.5)
				local pct = (value - min) / (max - min)
				fillBar.Size = ud2(pct, 0, 1, 0)
				numLabel.Text = tostring(value)
				callback(value)
			end

			local sliderBtn = Instance.new("TextButton", sliderBox)
			sliderBtn.Size = ud2(1, 0, 1, 0)
			sliderBtn.BackgroundTransparency = 1
			sliderBtn.Text = ""
			sliderBtn.ZIndex = 10

			sliderBtn.MouseButton1Down:Connect(function(x)
				draggingSlider = true
				updateSlider(x)
			end)
			sliderBtn.MouseButton1Up:Connect(function()
				draggingSlider = false
			end)

			UIS.InputChanged:Connect(function(input)
				if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					updateSlider(input.Position.X)
				end
			end)
			UIS.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					draggingSlider = false
				end
			end)
		end

		local function buildDropdown(dropConfig, multi)
			dropConfig = dropConfig or {}
			local name = dropConfig.Name or (multi and "Multi Dropdown" or "Dropdown")
			local options = dropConfig.Options or {}
			local callback = dropConfig.Callback or function() end
			local selected = dropConfig.Default or options[1] or "Select"
			local selectedMap = {}
			local selectedCount = 0
			local open = false
			local trackConn = nil
			local optH = 28
			local listH = #options * (optH + 4) + 12

			local searchText = name
			for _, o in ipairs(options) do
				searchText = searchText .. " " .. tostring(o)
			end

			local row = makeRow(32, searchText)
			makeLabel(row, name, dropConfig.Icon)

			local dropBox = Instance.new("TextButton", row)
			dropBox.Size = ud2(0.42, 0, 0, 24)
			dropBox.AnchorPoint = v2(1, 0.5)
			dropBox.Position = ud2(1, -6, 0.5, 0)
			dropBox.BackgroundColor3 = T.Button
			dropBox.BorderSizePixel = 0
			dropBox.Text = ""
			dropBox.AutoButtonColor = false
			dropBox.ZIndex = 7
			Instance.new("UICorner", dropBox).CornerRadius = ud(0, 3)
			addStroke(dropBox, T.Border, 1, 0.4)

			local selLabel = Instance.new("TextLabel", dropBox)
			selLabel.Size = ud2(1, -22, 1, 0)
			selLabel.Position = ud2(0, 7, 0, 0)
			selLabel.BackgroundTransparency = 1
			selLabel.Font = FONT_BOLD
			selLabel.TextSize = 12
			selLabel.TextColor3 = WHITE
			selLabel.TextXAlignment = Enum.TextXAlignment.Left
			selLabel.TextTruncate = Enum.TextTruncate.AtEnd
			selLabel.ZIndex = 8

			local arrow = Instance.new("TextLabel", dropBox)
			arrow.Size = ud2(0, 16, 1, 0)
			arrow.Position = ud2(1, -18, 0, 0)
			arrow.BackgroundTransparency = 1
			arrow.Text = ">"
			arrow.TextColor3 = T.TextInactive
			arrow.Font = FONT_BOLD
			arrow.TextSize = 14
			arrow.ZIndex = 8

			local function refreshLabel()
				if multi then
					if selectedCount <= 0 then
						selLabel.Text = "No Selected"
					else
						selLabel.Text = selectedCount .. "+ Selected"
					end
				else
					selLabel.Text = selected
				end
			end
			refreshLabel()

			local function getSelectedList()
				local list = {}
				for _, opt in ipairs(options) do
					if selectedMap[opt] then
						table.insert(list, opt)
					end
				end
				return list
			end

			local panel = Instance.new("Frame", ScreenGui)
			panel.Size = ud2(0, 0, 0, 0)
			panel.BackgroundColor3 = T.Background
			panel.BorderSizePixel = 0
			panel.ClipsDescendants = true
			panel.Visible = false
			panel.ZIndex = 200
			Instance.new("UICorner", panel).CornerRadius = ud(0, 3)
			trackRgb(Instance.new("UIStroke", panel)).Thickness = 1.5

			local pList = Instance.new("UIListLayout", panel)
			pList.SortOrder = Enum.SortOrder.LayoutOrder
			pList.Padding = ud(0, 4)

			local pPad = Instance.new("UIPadding", panel)
			pPad.PaddingTop = ud(0, 6)
			pPad.PaddingBottom = ud(0, 6)
			pPad.PaddingLeft = ud(0, 6)
			pPad.PaddingRight = ud(0, 6)

			local function inside(obj, m)
				local p, s = obj.AbsolutePosition, obj.AbsoluteSize
				return m.X >= p.X and m.X <= p.X + s.X and m.Y >= p.Y and m.Y <= p.Y + s.Y
			end

			local function place()
				local p = dropBox.AbsolutePosition
				panel.Position = ud2(0, p.X, 0, p.Y + dropBox.AbsoluteSize.Y + 4)
				panel.Size = ud2(0, dropBox.AbsoluteSize.X, 0, panel.Size.Y.Offset)
			end

			local function setOpen(v)
				open = v
				TweenService:Create(arrow, ti(0.2), {Rotation = v and 90 or 0}):Play()
				if trackConn then trackConn:Disconnect() trackConn = nil end
				if v then
					panel.Visible = true
					place()
					panel.Size = ud2(0, dropBox.AbsoluteSize.X, 0, 0)
					TweenService:Create(panel, ti(0.3, Enum.EasingStyle.Quart), {Size = ud2(0, dropBox.AbsoluteSize.X, 0, listH)}):Play()
					trackConn = RunService.RenderStepped:Connect(place)
				else
					TweenService:Create(panel, ti(0.25, Enum.EasingStyle.Quart), {Size = ud2(0, dropBox.AbsoluteSize.X, 0, 0)}):Play()
					task.delay(0.26, function()
						if not open then
							panel.Visible = false
						end
					end)
				end
			end

			for idx, opt in ipairs(options) do
				local ob = Instance.new("TextButton", panel)
				ob.Size = ud2(1, 0, 0, optH)
				ob.BackgroundColor3 = T.Button
				ob.BorderSizePixel = 0
				ob.Text = opt
				ob.TextColor3 = WHITE
				ob.Font = FONT_BOLD
				ob.TextSize = 12
				ob.AutoButtonColor = false
				ob.ZIndex = 201
				ob.LayoutOrder = idx
				Instance.new("UICorner", ob).CornerRadius = ud(0, 3)

				ob.MouseEnter:Connect(function()
					if not (multi and selectedMap[opt]) then
						TweenService:Create(ob, ti(0.1), {BackgroundColor3 = T.Hover}):Play()
					end
				end)
				ob.MouseLeave:Connect(function()
					if not (multi and selectedMap[opt]) then
						TweenService:Create(ob, ti(0.1), {BackgroundColor3 = T.Button}):Play()
					end
				end)
				ob.MouseButton1Click:Connect(function()
					if multi then
						selectedMap[opt] = not selectedMap[opt]
						if selectedMap[opt] then
							selectedCount = selectedCount + 1
							TweenService:Create(ob, ti(0.15), {BackgroundColor3 = T.Slider}):Play()
						else
							selectedCount = selectedCount - 1
							TweenService:Create(ob, ti(0.15), {BackgroundColor3 = T.Button}):Play()
						end
						refreshLabel()
						callback(getSelectedList())
					else
						selected = opt
						refreshLabel()
						setOpen(false)
						callback(opt)
					end
				end)
			end

			dropBox.MouseButton1Click:Connect(function()
				setOpen(not open)
			end)

			UIS.InputBegan:Connect(function(input)
				if open and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
					local m = input.Position
					if not inside(dropBox, m) and not inside(panel, m) then
						setOpen(false)
					end
				end
			end)

			return row
		end

		function Tab:AddDropdown(dropConfig)
			return buildDropdown(dropConfig, false)
		end

		function Tab:AddMultiDropdown(dropConfig)
			return buildDropdown(dropConfig, true)
		end

		function Tab:AddSocialLinkCopy(socConfig)
			socConfig = socConfig or {}
			local name = socConfig.Name or "Social"
			local about = socConfig.About or "Subscribe me"
			local link = socConfig.Link or ""
			local buttonText = socConfig.ButtonText or "Copy Link"
			local callback = socConfig.Callback or function() end
			local lines = math.max(1, math.ceil(#about / 26))
			local h = 26 + lines * 12 + 6 + 24 + 8

			local row = makeRow(h, name .. " " .. about, T.Button, 0)
			addStroke(row, T.Border, 1, 0.4)

			local nameLbl = Instance.new("TextLabel", row)
			nameLbl.Size = ud2(1, -20, 0, 16)
			nameLbl.Position = ud2(0, 10, 0, 8)
			nameLbl.BackgroundTransparency = 1
			nameLbl.Text = name
			nameLbl.TextColor3 = WHITE
			nameLbl.Font = FONT_BOLD
			nameLbl.TextSize = 13
			nameLbl.TextXAlignment = Enum.TextXAlignment.Left
			nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
			nameLbl.ZIndex = 7

			local aboutLbl = Instance.new("TextLabel", row)
			aboutLbl.Size = ud2(1, -20, 0, lines * 12)
			aboutLbl.Position = ud2(0, 10, 0, 26)
			aboutLbl.BackgroundTransparency = 1
			aboutLbl.Text = about
			aboutLbl.TextColor3 = T.TextInactive
			aboutLbl.Font = FONT_NORMAL
			aboutLbl.TextSize = 10
			aboutLbl.TextWrapped = true
			aboutLbl.TextXAlignment = Enum.TextXAlignment.Left
			aboutLbl.TextYAlignment = Enum.TextYAlignment.Top
			aboutLbl.ZIndex = 7

			local copyBtn = Instance.new("TextButton", row)
			copyBtn.Size = ud2(1, -20, 0, 24)
			copyBtn.Position = ud2(0, 10, 0, 26 + lines * 12 + 6)
			copyBtn.BackgroundColor3 = T.Slider
			copyBtn.BorderSizePixel = 0
			copyBtn.Text = buttonText
			copyBtn.TextColor3 = WHITE
			copyBtn.Font = FONT_BOLD
			copyBtn.TextSize = 11
			copyBtn.AutoButtonColor = false
			copyBtn.ZIndex = 8
			Instance.new("UICorner", copyBtn).CornerRadius = ud(0, 3)

			copyBtn.MouseEnter:Connect(function()
				TweenService:Create(copyBtn, ti(0.15), {BackgroundColor3 = T.Hover}):Play()
			end)
			copyBtn.MouseLeave:Connect(function()
				TweenService:Create(copyBtn, ti(0.15), {BackgroundColor3 = T.Slider}):Play()
			end)
			copyBtn.MouseButton1Click:Connect(function()
				pcall(function()
					setclipboard(link)
				end)
				copyBtn.Text = "Copied!"
				task.delay(1.2, function()
					copyBtn.Text = buttonText
				end)
				callback(link)
			end)
		end

		local MENU_REACTIONS = {
			{Label = "Like", Icon = "thumbs-up"},
			{Label = "Favorite", Icon = "star"},
			{Label = "Save", Icon = "bookmark"},
			{Label = "Love", Icon = "heart"}
		}

		local function buildMenu(menuConfig, kind)
			menuConfig = menuConfig or {}
			local name = menuConfig.Name or "Menu"
			local callback = menuConfig.Callback or function() end
			local buttons = menuConfig.Buttons or {}
			local OFF = menuConfig.Image and 62 or 0
			local h = (kind == "Button" and (38 + #buttons * 28) or 72) + OFF

			local row = makeRow(h, name, T.Button, 0)
			addStroke(row, T.Border, 1, 0.4)

			if menuConfig.Image then
				local img = Instance.new("ImageLabel", row)
				img.Size = ud2(0, 56, 0, 56)
				img.Position = ud2(0.5, -28, 0, 8)
				img.BackgroundColor3 = T.Field or T.Button
				img.BorderSizePixel = 0
				img.Image = menuConfig.Image
				img.ScaleType = Enum.ScaleType.Crop
				img.ZIndex = 7
				Instance.new("UICorner", img).CornerRadius = ud(0, 3)
				addStroke(img, T.Border, 1, 0.3)
			end

			local bg = Instance.new("TextButton", row)
			bg.Size = ud2(1, 0, 1, 0)
			bg.BackgroundTransparency = 1
			bg.Text = ""
			bg.ZIndex = 6
			bg.MouseButton1Click:Connect(function()
				clickEffect(row)
				callback(name)
			end)

			local nameLbl = Instance.new("TextLabel", row)
			nameLbl.Size = ud2(1, -16, 0, 16)
			nameLbl.Position = ud2(0, 8, 0, 8 + OFF)
			nameLbl.BackgroundTransparency = 1
			nameLbl.Text = name
			nameLbl.TextColor3 = WHITE
			nameLbl.Font = FONT_BOLD
			nameLbl.TextSize = 13
			nameLbl.TextXAlignment = Enum.TextXAlignment.Center
			nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
			nameLbl.ZIndex = 7

			if kind == "Button" then
				for i, b in ipairs(buttons) do
					local bb = Instance.new("TextButton", row)
					bb.Size = ud2(1, -16, 0, 24)
					bb.Position = ud2(0, 8, 0, 32 + OFF + (i - 1) * 28)
					bb.BackgroundColor3 = T.TabInactive
					bb.BorderSizePixel = 0
					bb.Text = b.Name or ("Button " .. i)
					bb.TextColor3 = WHITE
					bb.Font = FONT_BOLD
					bb.TextSize = 11
					bb.AutoButtonColor = false
					bb.ZIndex = 8
					Instance.new("UICorner", bb).CornerRadius = ud(0, 3)

					if b.Icon then
						local ic = Instance.new("ImageLabel", bb)
						ic.Size = ud2(0, 14, 0, 14)
						ic.AnchorPoint = v2(1, 0.5)
						ic.Position = ud2(1, -8, 0.5, 0)
						ic.BackgroundTransparency = 1
						ic.Image = resolveIcon(b.Icon)
						ic.ImageColor3 = WHITE
						ic.ZIndex = 9
					end

					bb.MouseEnter:Connect(function()
						TweenService:Create(bb, ti(0.15), {BackgroundColor3 = T.Hover}):Play()
					end)
					bb.MouseLeave:Connect(function()
						TweenService:Create(bb, ti(0.15), {BackgroundColor3 = T.TabInactive}):Play()
					end)
					bb.MouseButton1Click:Connect(function()
						clickEffect(row)
						if b.Callback then b.Callback() end
					end)
				end
			else
				local btnRow = Instance.new("Frame", row)
				btnRow.Size = ud2(1, -16, 0, 30)
				btnRow.Position = ud2(0, 8, 0, 32 + OFF)
				btnRow.BackgroundTransparency = 1
				btnRow.ZIndex = 7

				local bLayout = Instance.new("UIListLayout", btnRow)
				bLayout.FillDirection = Enum.FillDirection.Horizontal
				bLayout.SortOrder = Enum.SortOrder.LayoutOrder
				bLayout.Padding = ud(0, 4)
				bLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

				for idx, r in ipairs(MENU_REACTIONS) do
					local rb = Instance.new("TextButton", btnRow)
					rb.Size = ud2(0.25, -4, 1, 0)
					rb.BackgroundColor3 = T.TabInactive
					rb.BorderSizePixel = 0
					rb.Text = ""
					rb.AutoButtonColor = false
					rb.LayoutOrder = idx
					rb.ZIndex = 8
					Instance.new("UICorner", rb).CornerRadius = ud(0, 3)

					local rIcon = Instance.new("ImageLabel", rb)
					rIcon.Size = ud2(0, 14, 0, 14)
					rIcon.AnchorPoint = v2(0.5, 0.5)
					rIcon.Position = ud2(0.5, 0, 0.5, 0)
					rIcon.BackgroundTransparency = 1
					rIcon.Image = resolveIcon(r.Icon)
					rIcon.ImageColor3 = WHITE
					rIcon.ZIndex = 9

					rb.MouseEnter:Connect(function()
						TweenService:Create(rb, ti(0.15), {BackgroundColor3 = T.Hover}):Play()
					end)
					rb.MouseLeave:Connect(function()
						TweenService:Create(rb, ti(0.15), {BackgroundColor3 = T.TabInactive}):Play()
					end)
					rb.MouseButton1Click:Connect(function()
						TweenService:Create(rb, ti(0.15), {BackgroundColor3 = T.Slider}):Play()
						task.delay(0.3, function()
							TweenService:Create(rb, ti(0.2), {BackgroundColor3 = T.TabInactive}):Play()
						end)
						callback(r.Label)
					end)
				end
			end

			return row
		end

		function Tab:AddMenuInfo(menuConfig)
			return buildMenu(menuConfig, "Info")
		end

		function Tab:AddMenuButton(menuConfig)
			return buildMenu(menuConfig, "Button")
		end

		function Tab:AddMenuSelected(menuConfig)
			menuConfig = menuConfig or {}
			local kind = string.lower(tostring(menuConfig.Type or menuConfig.Mode or "Info"))
			if string.find(kind, "button") then
				return buildMenu(menuConfig, "Button")
			end
			return buildMenu(menuConfig, "Info")
		end

		Tab:AddDropdown({
			Name = "Window Mode",
			Icon = "layout-grid",
			Default = curMode,
			Options = {"NormalWindow", "MultiWindow"},
			Callback = function(opt)
				Tab:SetMode(opt)
			end
		})
		layoutItems[#layoutItems].isBreak = true
		relayout()

		return Tab
	end

	local notifQueue = {}
	local notifRunning = false

	local function runNotifQueue()
		if notifRunning then return end
		notifRunning = true
		while #notifQueue > 0 do
			local cfg = table.remove(notifQueue, 1)
			local done = false

			local useIcon = cfg.UseIcon or false
			local iconVal = cfg.Icon or ""
			local titleText = cfg.Title or "Notify"
			local bodyText = cfg.Text or ""
			local startDelay = cfg.StartedNotify or 0
			local duration = cfg.EndedNotify or 4

			task.wait(startDelay)

			local notifGui = Instance.new("ScreenGui")
			notifGui.Name = "WynfUiNotif_" .. tostring(os.clock())
			notifGui.ResetOnSpawn = false
			notifGui.DisplayOrder = 9999
			notifGui.Parent = CoreGui

			local frameH = 85
			local nFrame = Instance.new("Frame")
			nFrame.Size = ud2(0, 280, 0, frameH)
			nFrame.Position = ud2(1, 10, 1, -(frameH + 14))
			nFrame.BackgroundColor3 = T.SecondaryBg
			nFrame.BackgroundTransparency = 0.1
			nFrame.BorderSizePixel = 0
			nFrame.Parent = notifGui
			Instance.new("UICorner", nFrame).CornerRadius = ud(0, 3)
			trackRgb(Instance.new("UIStroke", nFrame)).Thickness = 1.5

			local contentOffsetX = 12
			local topOffsetY = 8

			if useIcon then
				local isRbx = tostring(iconVal):find("rbxassetid://") ~= nil
				local iconImg = Instance.new("ImageLabel", nFrame)
				iconImg.Size = ud2(0, 16, 0, 16)
				iconImg.Position = ud2(0, contentOffsetX, 0, topOffsetY)
				iconImg.BackgroundTransparency = 1
				iconImg.ScaleType = Enum.ScaleType.Fit
				iconImg.ImageColor3 = T.TextInactive
				if isRbx then
					iconImg.Image = tostring(iconVal)
				else
					iconImg.Image = resolveIcon(tostring(iconVal))
				end
				contentOffsetX = 34
			end

			local titleLbl = Instance.new("TextLabel", nFrame)
			titleLbl.Size = ud2(1, -(contentOffsetX + 10), 0, 20)
			titleLbl.Position = ud2(0, contentOffsetX, 0, topOffsetY - 2)
			titleLbl.BackgroundTransparency = 1
			titleLbl.Text = titleText
			titleLbl.TextColor3 = T.TextInactive
			titleLbl.Font = FONT_BOLD
			titleLbl.TextSize = 13
			titleLbl.TextXAlignment = Enum.TextXAlignment.Left

			local bodyLbl = Instance.new("TextLabel", nFrame)
			bodyLbl.Size = ud2(1, -(contentOffsetX + 10), 0, 30)
			bodyLbl.Position = ud2(0, contentOffsetX, 0, topOffsetY + 18)
			bodyLbl.BackgroundTransparency = 1
			bodyLbl.Text = bodyText
			bodyLbl.TextColor3 = WHITE
			bodyLbl.Font = FONT_BOLD
			bodyLbl.TextSize = 15
			bodyLbl.TextXAlignment = Enum.TextXAlignment.Left

			local barBg = Instance.new("Frame", nFrame)
			barBg.Size = ud2(1, -24, 0, 5)
			barBg.Position = ud2(0, 12, 1, -12)
			barBg.BackgroundColor3 = T.ToggleOff
			barBg.BorderSizePixel = 0
			Instance.new("UICorner", barBg).CornerRadius = ud(1, 0)

			local bar = Instance.new("Frame", barBg)
			bar.Size = ud2(0, 0, 1, 0)
			bar.BackgroundColor3 = T.Slider
			bar.BorderSizePixel = 0
			Instance.new("UICorner", bar).CornerRadius = ud(1, 0)

			local tweenIn = TweenService:Create(nFrame, ti(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Position = ud2(1, -290, 1, -(frameH + 14))
			})
			tweenIn:Play()
			tweenIn.Completed:Connect(function()
				local barTween = TweenService:Create(bar, ti(duration, Enum.EasingStyle.Linear), {Size = ud2(1, 0, 1, 0)})
				barTween:Play()
				barTween.Completed:Connect(function()
					local tweenOut = TweenService:Create(nFrame, ti(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
						Position = ud2(1, 10, 1, -(frameH + 14))
					})
					tweenOut:Play()
					tweenOut.Completed:Connect(function()
						notifGui:Destroy()
						done = true
					end)
				end)
			end)

			while not done do task.wait(0.05) end
		end
		notifRunning = false
	end

	function Window:AddNotify(notifConfig)
		notifConfig = notifConfig or {}
		table.insert(notifQueue, notifConfig)
		task.spawn(runNotifQueue)
	end

	local function saveConfig(silent)
		local ok = pcall(function()
			writefile(ConfigName .. ".json", HttpService:JSONEncode(ConfigState))
		end)
		if not silent then
			Window:AddNotify({
				Title = "Config",
				Text = ok and ("Saved " .. ConfigName .. ".json") or "Save failed",
				UseIcon = true,
				Icon = "save"
			})
		end
	end

	local function autoSave()
		if ConfigState.SaveMode == "Auto Save" then
			saveConfig(true)
		end
	end

	function Window:SetTheme(name)
		local newT = THEMES[name]
		if not newT or newT == T then return end
		recolorGui(ScreenGui, T, newT)
		T = newT
		rgbColors = T.RGB
		ConfigState.Theme = name
		autoSave()
	end

	function Window:AddConfigTab()
		local Cfg = Window:AddTab({Name = "Config", Icon = "settings", Mode = "NormalWindow"})

		Cfg:AddSection({Name = "Config", Icon = "folder"})

		Cfg:AddDropdown({
			Name = "ModeSaveConfig",
			Icon = "archive",
			Default = ConfigState.SaveMode,
			Options = {"Manual Save", "Auto Save"},
			Callback = function(opt)
				ConfigState.SaveMode = opt
				autoSave()
			end
		})

		Cfg:AddDropdown({
			Name = "Select Theme",
			Icon = "palette",
			Default = ConfigState.Theme,
			Options = THEME_NAMES,
			Callback = function(opt)
				Window:SetTheme(opt)
			end
		})

		Cfg:AddSlider({
			Name = "Transparan UI",
			Icon = "blend",
			Min = 0,
			Max = 90,
			Default = ConfigState.Transparency,
			Callback = function(v)
				ConfigState.Transparency = v
				Main.BackgroundTransparency = v / 100
				autoSave()
			end
		})

		Cfg:AddInput({
			Name = "Config Name",
			Icon = "file-json",
			Placeholder = "config name...",
			Callback = function(text)
				if text ~= "" then
					ConfigName = text
				end
			end
		})

		Cfg:AddButton({
			Name = "Save Config JSON File",
			Icon = "download",
			Callback = function()
				saveConfig(false)
			end
		})

		return Cfg
	end

	if config.SaveConfiguration then
		Window:AddConfigTab()
	end

	return Window
end

return WynfUi
