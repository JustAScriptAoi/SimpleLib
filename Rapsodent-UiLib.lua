local RhapsodentLibrary = {}
RhapsodentLibrary.__index = RhapsodentLibrary

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local Icons = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/Main-v2.lua"))()
Icons.SetIconsType("lucide")

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

local THEMES = {
	Original = {
		Accent = Color3.fromRGB(191, 0, 255),
		AccentDim = Color3.fromRGB(60, 20, 90),
		Dark = Color3.fromRGB(12, 8, 20),
		Keys = {
			Color3.fromRGB(191, 0, 255),
			Color3.fromRGB(60, 60, 255),
			Color3.fromRGB(8, 4, 18)
		},
		Border = {
			Color3.fromRGB(191, 0, 255),
			Color3.fromRGB(60, 60, 255),
			Color3.fromRGB(191, 0, 255)
		},
		Panel = Color3.fromRGB(10, 6, 18),
		Track = Color3.fromRGB(35, 15, 55),
		Option = Color3.fromRGB(30, 12, 45),
		Field = Color3.fromRGB(20, 10, 35),
		TabBg = Color3.fromRGB(20, 10, 35),
		Background = "rbxassetid://99940036804594",
		Logo = "rbxassetid://118324456844701"
	},
	Red = {
		Accent = Color3.fromRGB(255, 45, 45),
		AccentDim = Color3.fromRGB(110, 10, 10),
		Dark = Color3.fromRGB(16, 6, 6),
		Keys = {
			Color3.fromRGB(255, 40, 40),
			Color3.fromRGB(150, 0, 0),
			Color3.fromRGB(70, 0, 0)
		},
		Border = {
			Color3.fromRGB(255, 30, 30),
			Color3.fromRGB(230, 10, 10),
			Color3.fromRGB(255, 30, 30)
		},
		Panel = Color3.fromRGB(26, 5, 5),
		Track = Color3.fromRGB(55, 8, 8),
		Option = Color3.fromRGB(48, 8, 8),
		Field = Color3.fromRGB(38, 6, 6),
		TabBg = Color3.fromRGB(42, 7, 7),
		Background = "rbxassetid://137184743125361",
		Logo = "rbxassetid://107253905846631"
	}
}

local THEME_NAMES = {"Original", "Red"}

local WHITE = Color3.fromRGB(255, 255, 255)
local GRAY = Color3.fromRGB(160, 160, 160)

local function normalizeMode(v)
	if string.find(string.lower(tostring(v or "")), "multi") then
		return "MultiWindow"
	end
	return "NormalWindow"
end

local function recolorGui(gui, oldT, newT)
	local plainMap = {
		{oldT.Accent, newT.Accent},
		{oldT.AccentDim, newT.AccentDim},
		{oldT.Dark, newT.Dark},
		{oldT.Panel, newT.Panel},
		{oldT.Track, newT.Track},
		{oldT.Option, newT.Option},
		{oldT.Field, newT.Field},
		{oldT.TabBg, newT.TabBg}
	}
	local gradMap = {}
	for i = 1, 3 do
		table.insert(gradMap, {oldT.Keys[i], newT.Keys[i]})
		table.insert(gradMap, {oldT.Border[i], newT.Border[i]})
	end

	local function mapIn(map, c)
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
				table.insert(kps, ColorSequenceKeypoint.new(kp.Time, mapIn(gradMap, kp.Value) or kp.Value))
			end
			d.Color = ColorSequence.new(kps)
		elseif d:IsA("UIStroke") then
			local c = mapIn(plainMap, d.Color)
			if c then d.Color = c end
		elseif d:IsA("GuiObject") then
			local c = mapIn(plainMap, d.BackgroundColor3)
			if c then d.BackgroundColor3 = c end
			if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
				c = mapIn(plainMap, d.TextColor3)
				if c then d.TextColor3 = c end
			end
			if d:IsA("ImageLabel") or d:IsA("ImageButton") then
				c = mapIn(plainMap, d.ImageColor3)
				if c then d.ImageColor3 = c end
				if d.Image == oldT.Background then
					d.Image = newT.Background
				elseif d.Image == oldT.Logo then
					d.Image = newT.Logo
				end
			end
			if d:IsA("ScrollingFrame") then
				c = mapIn(plainMap, d.ScrollBarImageColor3)
				if c then d.ScrollBarImageColor3 = c end
			end
		end
	end
end

function RhapsodentLibrary:CreateWindow(config)
	config = config or {}
	local title = config.Title or "Rhapsodent Library"
	local T = THEMES[config.Theme or "Original"] or THEMES.Original
	local ACCENT = T.Accent
	local ACCENT_DIM = T.AccentDim
	local DARK = T.Dark
	local BG_IMAGE = T.Background
	local LOGO_DECAL = T.Logo

	local function grad3(obj, rot, keys)
		keys = keys or T.Keys
		local g = Instance.new("UIGradient")
		g.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, keys[1]),
			ColorSequenceKeypoint.new(0.55, keys[2]),
			ColorSequenceKeypoint.new(1, keys[3])
		})
		g.Rotation = rot or 45
		g.Parent = obj
		return g
	end

	local function makeSearchBox(parent, placeholder, size, position)
		local holder = Instance.new("Frame")
		holder.Size = size
		holder.Position = position or UDim2.new(0, 0, 0, 0)
		holder.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		holder.BackgroundTransparency = 0.5
		holder.BorderSizePixel = 0
		holder.ZIndex = 12
		holder.Parent = parent
		Instance.new("UICorner", holder).CornerRadius = UDim.new(0, 8)

		local stroke = Instance.new("UIStroke", holder)
		stroke.Thickness = 1.5
		stroke.Transparency = 0.4
		grad3(stroke, 45)

		local box = Instance.new("TextBox", holder)
		box.Size = UDim2.new(1, -34, 1, 0)
		box.Position = UDim2.new(0, 7, 0, 0)
		box.BackgroundTransparency = 1
		box.Text = ""
		box.PlaceholderText = placeholder
		box.PlaceholderColor3 = GRAY
		box.TextColor3 = WHITE
		box.Font = Enum.Font.Gotham
		box.TextSize = 12
		box.TextXAlignment = Enum.TextXAlignment.Left
		box.ClearTextOnFocus = false
		box.ZIndex = 13

		local icon = Instance.new("ImageLabel", holder)
		icon.Size = UDim2.new(0, 14, 0, 14)
		icon.AnchorPoint = Vector2.new(1, 0.5)
		icon.Position = UDim2.new(1, -8, 0.5, 0)
		icon.BackgroundTransparency = 1
		icon.Image = resolveIcon("search")
		icon.ImageColor3 = ACCENT
		icon.ZIndex = 13

		return holder, box
	end

	if CoreGui:FindFirstChild("RhapsodentLibrary_" .. title) then
		CoreGui:FindFirstChild("RhapsodentLibrary_" .. title):Destroy()
	end

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "RhapsodentLibrary_" .. title
	ScreenGui.Parent = CoreGui
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.DisplayOrder = 999

	local W, H = 520, 370
	local TAB_W = 130

	local ConfigState = {
		Theme = config.Theme or "Original",
		Transparency = 45,
		UseImage = true,
		SaveMode = "Manual Save"
	}
	local ConfigName = "config"

	local Main = Instance.new("Frame")
	Main.Name = "Main"
	Main.Parent = ScreenGui
	Main.BackgroundColor3 = DARK
	Main.BackgroundTransparency = 0.45
	Main.Position = UDim2.new(0.5, -(W / 2), 0.5, -(H / 2))
	Main.Size = UDim2.new(0, W, 0, H)
	Main.ClipsDescendants = true

	local mainStroke = Instance.new("UIStroke", Main)
	mainStroke.Thickness = 2.5
	mainStroke.Transparency = 0
	grad3(mainStroke, 90, T.Border)

	local fullSize = Main.Size
	local collapsedSize = UDim2.new(0, W, 0, 40)

	local MainClip = Instance.new("Frame", Main)
	MainClip.Size = UDim2.new(1, 0, 1, 0)
	MainClip.BackgroundTransparency = 1
	MainClip.ClipsDescendants = true
	MainClip.ZIndex = 0
	Instance.new("UICorner", MainClip).CornerRadius = UDim.new(0, 10)

	Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

	local BgImage = Instance.new("ImageLabel", MainClip)
	BgImage.Size = UDim2.new(1, 0, 1, 0)
	BgImage.BackgroundTransparency = 1
	BgImage.Image = BG_IMAGE
	BgImage.ImageTransparency = 0.3
	BgImage.ScaleType = Enum.ScaleType.Crop
	BgImage.ZIndex = 0
	Instance.new("UICorner", BgImage).CornerRadius = UDim.new(0, 10)

	local TopBar = Instance.new("Frame", Main)
	TopBar.Size = UDim2.new(1, 0, 0, 40)
	TopBar.BackgroundTransparency = 1
	TopBar.ZIndex = 50

	local TabToggleBtn = Instance.new("ImageButton", TopBar)
	TabToggleBtn.Size = UDim2.new(0, 28, 0, 28)
	TabToggleBtn.Position = UDim2.new(0, 8, 0.5, -14)
	TabToggleBtn.BackgroundTransparency = 1
	TabToggleBtn.Image = resolveIcon("panel-left")
	TabToggleBtn.ImageColor3 = ACCENT
	TabToggleBtn.ZIndex = 51

	local TitleLabel = Instance.new("TextLabel", TopBar)
	TitleLabel.Size = UDim2.new(1, -80, 1, 0)
	TitleLabel.Position = UDim2.new(0, 46, 0, 0)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Text = title
	TitleLabel.TextColor3 = ACCENT
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.TextSize = 16
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.ZIndex = 51
	grad3(TitleLabel, 0)

	local CloseBtn = Instance.new("TextButton", TopBar)
	CloseBtn.Size = UDim2.new(0, 30, 0, 30)
	CloseBtn.Position = UDim2.new(1, -35, 0, 5)
	CloseBtn.BackgroundTransparency = 1
	CloseBtn.Text = "−"
	CloseBtn.TextColor3 = ACCENT
	CloseBtn.Font = Enum.Font.GothamBold
	CloseBtn.TextSize = 22
	CloseBtn.ZIndex = 51
	grad3(CloseBtn, 0)

	local TabSidebar = Instance.new("ScrollingFrame", Main)
	TabSidebar.Name = "TabSidebar"
	TabSidebar.Size = UDim2.new(0, TAB_W, 1, -40)
	TabSidebar.Position = UDim2.new(0, 0, 0, 40)
	TabSidebar.BackgroundColor3 = T.Panel
	TabSidebar.BackgroundTransparency = 0.3
	TabSidebar.BorderSizePixel = 0
	TabSidebar.ZIndex = 10
	TabSidebar.ClipsDescendants = true
	TabSidebar.ScrollBarThickness = 2
	TabSidebar.ScrollBarImageColor3 = ACCENT
	TabSidebar.ScrollingDirection = Enum.ScrollingDirection.Y
	TabSidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
	TabSidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
	Instance.new("UICorner", TabSidebar).CornerRadius = UDim.new(0, 10)

	local SideList = Instance.new("UIListLayout", TabSidebar)
	SideList.SortOrder = Enum.SortOrder.LayoutOrder
	SideList.Padding = UDim.new(0, 4)
	SideList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	SideList.VerticalAlignment = Enum.VerticalAlignment.Top

	local SidePad = Instance.new("UIPadding", TabSidebar)
	SidePad.PaddingTop = UDim.new(0, 10)
	SidePad.PaddingBottom = UDim.new(0, 10)
	SidePad.PaddingLeft = UDim.new(0, 6)
	SidePad.PaddingRight = UDim.new(0, 6)

	local tabSearchHolder, tabSearchBox = makeSearchBox(TabSidebar, "Search tab...", UDim2.new(1, 0, 0, 28))
	tabSearchHolder.LayoutOrder = 0

	local ProfileHeader = Instance.new("Frame", TabSidebar)
	ProfileHeader.Name = "ProfileHeader"
	ProfileHeader.Size = UDim2.new(1, 0, 0, 44)
	ProfileHeader.BackgroundTransparency = 1
	ProfileHeader.LayoutOrder = 1
	ProfileHeader.ZIndex = 11

	local LocalPlayer = Players.LocalPlayer

	local AvatarIcon = Instance.new("ImageLabel", ProfileHeader)
	AvatarIcon.Size = UDim2.new(0, 32, 0, 32)
	AvatarIcon.Position = UDim2.new(0, 0, 0, 6)
	AvatarIcon.BackgroundColor3 = DARK
	AvatarIcon.Image = ""
	AvatarIcon.ScaleType = Enum.ScaleType.Crop
	AvatarIcon.ZIndex = 12
	Instance.new("UICorner", AvatarIcon).CornerRadius = UDim.new(1, 0)

	local avatarStroke = Instance.new("UIStroke", AvatarIcon)
	avatarStroke.Color = ACCENT
	avatarStroke.Thickness = 1.5
	avatarStroke.Transparency = 0.3
	grad3(avatarStroke, 90)

	task.spawn(function()
		local ok, content = pcall(function()
			return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
		end)
		if ok and content then
			AvatarIcon.Image = content
		end
	end)

	local DisplayNameLabel = Instance.new("TextLabel", ProfileHeader)
	DisplayNameLabel.Size = UDim2.new(1, -40, 0, 18)
	DisplayNameLabel.Position = UDim2.new(0, 40, 0, 4)
	DisplayNameLabel.BackgroundTransparency = 1
	DisplayNameLabel.Text = LocalPlayer.DisplayName
	DisplayNameLabel.TextColor3 = WHITE
	DisplayNameLabel.Font = Enum.Font.GothamBold
	DisplayNameLabel.TextSize = 13
	DisplayNameLabel.TextXAlignment = Enum.TextXAlignment.Left
	DisplayNameLabel.TextTruncate = Enum.TextTruncate.AtEnd
	DisplayNameLabel.ZIndex = 12

	local UsernameLabel = Instance.new("TextLabel", ProfileHeader)
	UsernameLabel.Size = UDim2.new(1, -40, 0, 16)
	UsernameLabel.Position = UDim2.new(0, 40, 0, 22)
	UsernameLabel.BackgroundTransparency = 1
	UsernameLabel.Text = "@" .. LocalPlayer.Name
	UsernameLabel.TextColor3 = GRAY
	UsernameLabel.Font = Enum.Font.Gotham
	UsernameLabel.TextSize = 11
	UsernameLabel.TextXAlignment = Enum.TextXAlignment.Left
	UsernameLabel.TextTruncate = Enum.TextTruncate.AtEnd
	UsernameLabel.ZIndex = 12

	local headerLine = Instance.new("Frame", ProfileHeader)
	headerLine.Size = UDim2.new(1, 0, 0, 1)
	headerLine.Position = UDim2.new(0, 0, 1, -2)
	headerLine.BackgroundColor3 = ACCENT
	headerLine.BackgroundTransparency = 0.7
	headerLine.BorderSizePixel = 0
	headerLine.ZIndex = 11
	grad3(headerLine, 0)

	local ContentArea = Instance.new("Frame", Main)
	ContentArea.Name = "ContentArea"
	ContentArea.Size = UDim2.new(1, -TAB_W, 1, -40)
	ContentArea.Position = UDim2.new(0, TAB_W, 0, 40)
	ContentArea.BackgroundTransparency = 1
	ContentArea.ZIndex = 5
	ContentArea.ClipsDescendants = false

	local dragging, dragStart, startPos
	Main.InputBegan:Connect(function(input)
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
			Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	local isOpen = true
	local sidebarOpen = true

	TabToggleBtn.MouseButton1Click:Connect(function()
		sidebarOpen = not sidebarOpen
		if sidebarOpen then
			TweenService:Create(TabSidebar, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, TAB_W, 1, -40)}):Play()
			TweenService:Create(ContentArea, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, -TAB_W, 1, -40), Position = UDim2.new(0, TAB_W, 0, 40)}):Play()
		else
			TweenService:Create(TabSidebar, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 1, -40)}):Play()
			TweenService:Create(ContentArea, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(1, 0, 1, -40), Position = UDim2.new(0, 0, 0, 40)}):Play()
		end
	end)

	CloseBtn.MouseButton1Click:Connect(function()
		isOpen = not isOpen
		if isOpen then
			CloseBtn.Text = "−"
			TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Size = fullSize}):Play()
			task.delay(0.15, function()
				ContentArea.Visible = true
			end)
		else
			CloseBtn.Text = "+"
			ContentArea.Visible = false
			TweenService:Create(TabSidebar, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 1, -40)}):Play()
			TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Size = collapsedSize}):Play()
		end
	end)

	local FloatBtn = Instance.new("ImageButton", ScreenGui)
	FloatBtn.Name = "FloatBtn"
	FloatBtn.Size = UDim2.new(0, 46, 0, 46)
	FloatBtn.Position = UDim2.new(1, -70, 1, -90)
	FloatBtn.BackgroundColor3 = DARK
	FloatBtn.BackgroundTransparency = 0.2
	FloatBtn.Image = LOGO_DECAL
	FloatBtn.ScaleType = Enum.ScaleType.Fit
	FloatBtn.ZIndex = 500
	Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(1, 0)

	local floatStroke = Instance.new("UIStroke", FloatBtn)
	floatStroke.Thickness = 2
	floatStroke.Transparency = 0
	grad3(floatStroke, 90, T.Border)

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
			FloatBtn.Position = UDim2.new(floatStartPos.X.Scale, floatStartPos.X.Offset + delta.X, floatStartPos.Y.Scale, floatStartPos.Y.Offset + delta.Y)
		end
	end)

	FloatBtn.MouseButton1Click:Connect(function()
		if floatMoved then return end
		Main.Visible = not Main.Visible
	end)

	local tabs = {}
	local tabEntries = {}
	local activeTab = nil
	local tabOrder = 1
	local sideQuery = ""

	local function filterTabs()
		for _, e in ipairs(tabEntries) do
			e.Btn.Visible = sideQuery == "" or e.Name:find(sideQuery, 1, true) ~= nil
		end
	end

	tabSearchBox:GetPropertyChangedSignal("Text"):Connect(function()
		sideQuery = string.lower(tabSearchBox.Text)
		filterTabs()
	end)

	local Window = {}

	function Window:AddTab(tabConfig)
		tabConfig = tabConfig or {}
		local tabName = tabConfig.Name or "Tab"
		local tabIcon = tabConfig.Icon or "circle"
		local curMode = normalizeMode(tabConfig.Mode or tabConfig.Layout or tabConfig.Type)
		tabOrder = tabOrder + 1

		local TabBtn = Instance.new("TextButton", TabSidebar)
		TabBtn.Size = UDim2.new(1, 0, 0, 34)
		TabBtn.BackgroundColor3 = T.TabBg
		TabBtn.BackgroundTransparency = 0.7
		TabBtn.Text = ""
		TabBtn.ZIndex = 11
		TabBtn.LayoutOrder = tabOrder
		TabBtn.BorderSizePixel = 0
		Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)

		local tabStroke = Instance.new("UIStroke", TabBtn)
		tabStroke.Thickness = 1.5
		tabStroke.Transparency = 0.7
		grad3(tabStroke, 45)

		local TabInner = Instance.new("Frame", TabBtn)
		TabInner.Size = UDim2.new(1, 0, 1, 0)
		TabInner.BackgroundTransparency = 1
		TabInner.ZIndex = 12

		local TabIconImg = Instance.new("ImageLabel", TabInner)
		TabIconImg.Size = UDim2.new(0, 18, 0, 18)
		TabIconImg.Position = UDim2.new(0, 7, 0.5, -9)
		TabIconImg.BackgroundTransparency = 1
		TabIconImg.Image = resolveIcon(tabIcon)
		TabIconImg.ImageColor3 = GRAY
		TabIconImg.ZIndex = 13

		local TabNameLabel = Instance.new("TextLabel", TabInner)
		TabNameLabel.Size = UDim2.new(1, -32, 1, 0)
		TabNameLabel.Position = UDim2.new(0, 30, 0, 0)
		TabNameLabel.BackgroundTransparency = 1
		TabNameLabel.Text = tabName
		TabNameLabel.TextColor3 = GRAY
		TabNameLabel.Font = Enum.Font.Gotham
		TabNameLabel.TextSize = 12
		TabNameLabel.TextXAlignment = Enum.TextXAlignment.Left
		TabNameLabel.ZIndex = 13

		local TabActiveLine = Instance.new("Frame", TabBtn)
		TabActiveLine.Size = UDim2.new(0, 3, 0.6, 0)
		TabActiveLine.AnchorPoint = Vector2.new(0, 0.5)
		TabActiveLine.Position = UDim2.new(0, 0, 0.5, 0)
		TabActiveLine.BackgroundColor3 = ACCENT
		TabActiveLine.BackgroundTransparency = 1
		TabActiveLine.BorderSizePixel = 0
		TabActiveLine.ZIndex = 12
		Instance.new("UICorner", TabActiveLine).CornerRadius = UDim.new(1, 0)
		grad3(TabActiveLine, 90)

		table.insert(tabEntries, {Btn = TabBtn, Name = string.lower(tabName)})
		filterTabs()

		local TabWrapper = Instance.new("CanvasGroup", ContentArea)
		TabWrapper.Name = "Wrap_" .. tabName
		TabWrapper.Size = UDim2.new(1, 0, 1, 0)
		TabWrapper.BackgroundTransparency = 1
		TabWrapper.BorderSizePixel = 0
		TabWrapper.ZIndex = 6
		TabWrapper.Visible = false
		TabWrapper.GroupTransparency = 0

		local elemSearchHolder, elemSearchBox = makeSearchBox(TabWrapper, "Search element...", UDim2.new(1, -16, 0, 28), UDim2.new(0, 8, 0, 6))

		local ScrollContainer = Instance.new("ScrollingFrame", TabWrapper)
		ScrollContainer.Name = "Tab_" .. tabName
		ScrollContainer.Position = UDim2.new(0, 0, 0, 40)
		ScrollContainer.Size = UDim2.new(1, 0, 1, -40)
		ScrollContainer.BackgroundTransparency = 1
		ScrollContainer.BorderSizePixel = 0
		ScrollContainer.ScrollBarThickness = 3
		ScrollContainer.ScrollBarImageColor3 = ACCENT
		ScrollContainer.ScrollingDirection = Enum.ScrollingDirection.Y
		ScrollContainer.ScrollingEnabled = true
		ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
		ScrollContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
		ScrollContainer.ZIndex = 6
		ScrollContainer.Visible = true
		ScrollContainer.ClipsDescendants = true

		local Pad = Instance.new("UIPadding", ScrollContainer)
		Pad.PaddingLeft = UDim.new(0, 8)
		Pad.PaddingRight = UDim.new(0, 8)
		Pad.PaddingTop = UDim.new(0, 4)
		Pad.PaddingBottom = UDim.new(0, 12)

		local List = Instance.new("UIListLayout", ScrollContainer)
		List.SortOrder = Enum.SortOrder.LayoutOrder
		List.Padding = UDim.new(0, 6)

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
				local prevWrap = activeTab.Wrapper
				TweenService:Create(activeTab.IconImg, TweenInfo.new(0.2), {ImageColor3 = GRAY}):Play()
				TweenService:Create(activeTab.NameLabel, TweenInfo.new(0.2), {TextColor3 = GRAY}):Play()
				TweenService:Create(activeTab.Btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.7}):Play()
				TweenService:Create(activeTab.Line, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
				TweenService:Create(prevWrap, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {GroupTransparency = 1}):Play()
				task.delay(0.2, function()
					prevWrap.Visible = false
					prevWrap.GroupTransparency = 0
				end)
			end
			activeTab = {Wrapper = TabWrapper, Container = ScrollContainer, Btn = TabBtn, IconImg = TabIconImg, NameLabel = TabNameLabel, Line = TabActiveLine}
			TabWrapper.GroupTransparency = 1
			TabWrapper.Visible = true
			TweenService:Create(TabWrapper, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {GroupTransparency = 0}):Play()
			TweenService:Create(TabIconImg, TweenInfo.new(0.2), {ImageColor3 = ACCENT}):Play()
			TweenService:Create(TabNameLabel, TweenInfo.new(0.2), {TextColor3 = WHITE}):Play()
			TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
			TweenService:Create(TabActiveLine, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
		end

		TabBtn.MouseButton1Click:Connect(activateTab)
		if #tabs == 0 then activateTab() end
		table.insert(tabs, {Wrapper = TabWrapper, Container = ScrollContainer, Btn = TabBtn})

		local itemOrder = 0
		local layoutItems = {}
		local pairFrames = {}
		local Tab = {}

		local function relayout()
			for _, it in ipairs(layoutItems) do
				it.frame.Parent = ScrollContainer
				it.frame.LayoutOrder = it.order
				it.frame.Position = UDim2.new(0, 0, 0, 0)
				it.frame.Size = UDim2.new(1, 0, 0, it.h)
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
					pair.Size = UDim2.new(1, 0, 0, it.h)
					pair.BackgroundTransparency = 1
					pair.BorderSizePixel = 0
					pair.LayoutOrder = it.order
					pair.ZIndex = 20
					table.insert(pairFrames, pair)
					it.frame.Parent = pair
					it.frame.Size = UDim2.new(0.5, -3, 0, it.h)
					it.frame.Position = UDim2.new(0, 0, 0, 0)
					pending = pair
				else
					it.frame.Parent = pending
					it.frame.Size = UDim2.new(0.5, -3, 0, it.h)
					it.frame.Position = UDim2.new(0.5, 3, 0, 0)
					if it.h > pending.Size.Y.Offset then
						pending.Size = UDim2.new(1, 0, 0, it.h)
					end
					pending = nil
				end
			end
		end

		local function addItem(frame, h, isBreak)
			table.insert(layoutItems, {frame = frame, h = h, order = frame.LayoutOrder, isBreak = isBreak})
			relayout()
		end

		local function makeRow(h, text)
			itemOrder = itemOrder + 1
			local row = Instance.new("Frame", ScrollContainer)
			row.Size = UDim2.new(1, 0, 0, h or 36)
			row.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			row.BackgroundTransparency = 0.65
			row.LayoutOrder = itemOrder
			row.ZIndex = 20
			row.ClipsDescendants = false
			Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)
			local rowStroke = Instance.new("UIStroke", row)
			rowStroke.Thickness = 1.8
			rowStroke.Transparency = 0.6
			grad3(rowStroke, 45)
			register(row, text)
			addItem(row, h or 36, false)
			return row
		end

		local function makeLabel(parent, text, icon)
			local hasIcon = icon ~= nil and tostring(icon) ~= ""
			local textX = 12
			if hasIcon then
				local ic = Instance.new("ImageLabel", parent)
				ic.Size = UDim2.new(0, 16, 0, 16)
				ic.Position = UDim2.new(0, 10, 0.5, -8)
				ic.BackgroundTransparency = 1
				ic.Image = resolveIcon(icon)
				ic.ImageColor3 = ACCENT
				ic.ZIndex = 21
				textX = 32
			end
			local lbl = Instance.new("TextLabel", parent)
			lbl.Size = UDim2.new(0.48, -textX, 1, 0)
			lbl.Position = UDim2.new(0, textX, 0, 0)
			lbl.BackgroundTransparency = 1
			lbl.Text = text
			lbl.TextColor3 = ACCENT
			lbl.Font = Enum.Font.GothamBold
			lbl.TextSize = 13
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.TextTruncate = Enum.TextTruncate.AtEnd
			lbl.ZIndex = 21
			grad3(lbl, 0)
			return lbl
		end

		local function ripple(row)
			local rip = Instance.new("Frame", row)
			rip.Size = UDim2.new(0, 0, 0, 0)
			rip.AnchorPoint = Vector2.new(0.5, 0.5)
			rip.Position = UDim2.new(0.5, 0, 0.5, 0)
			rip.BackgroundColor3 = ACCENT
			rip.BackgroundTransparency = 0.4
			rip.BorderSizePixel = 0
			rip.ZIndex = 25
			Instance.new("UICorner", rip).CornerRadius = UDim.new(1, 0)
			grad3(rip, 45)
			TweenService:Create(rip, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {
				Size = UDim2.new(0, 200, 0, 200),
				BackgroundTransparency = 1
			}):Play()
			task.delay(0.42, function() rip:Destroy() end)
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
			secRow.Size = UDim2.new(1, 0, 0, 24)
			secRow.BackgroundTransparency = 1
			secRow.LayoutOrder = itemOrder
			secRow.ZIndex = 20
			secRow.ClipsDescendants = false
			register(secRow, name, true)

			local textX = 12
			if secConfig.Icon then
				local secIcon = Instance.new("ImageLabel", secRow)
				secIcon.Size = UDim2.new(0, 14, 0, 14)
				secIcon.Position = UDim2.new(0, 12, 0.5, -7)
				secIcon.BackgroundTransparency = 1
				secIcon.Image = resolveIcon(secConfig.Icon)
				secIcon.ImageColor3 = ACCENT
				secIcon.ZIndex = 21
				textX = 32
			end

			local secLabel = Instance.new("TextLabel", secRow)
			secLabel.Size = UDim2.new(1, -textX, 1, 0)
			secLabel.Position = UDim2.new(0, textX, 0, 0)
			secLabel.BackgroundTransparency = 1
			secLabel.Text = name
			secLabel.TextColor3 = ACCENT
			secLabel.Font = Enum.Font.GothamBold
			secLabel.TextSize = 12
			secLabel.TextXAlignment = Enum.TextXAlignment.Left
			secLabel.ZIndex = 21
			grad3(secLabel, 0)

			local secLine = Instance.new("Frame", secRow)
			secLine.Size = UDim2.new(1, -12, 0, 1)
			secLine.Position = UDim2.new(0, 12, 1, -1)
			secLine.BackgroundColor3 = ACCENT
			secLine.BackgroundTransparency = 0.7
			secLine.BorderSizePixel = 0
			secLine.ZIndex = 21
			grad3(secLine, 0)

			addItem(secRow, 24, true)
		end

		function Tab:AddButton(btnConfig)
			btnConfig = btnConfig or {}
			local name = btnConfig.Name or "Button"
			local callback = btnConfig.Callback or function() end
			local row = makeRow(36, name)
			row.ClipsDescendants = true
			local btn = Instance.new("TextButton", row)
			btn.Size = UDim2.new(1, 0, 1, 0)
			btn.BackgroundTransparency = 1
			btn.Text = name
			btn.TextColor3 = ACCENT
			btn.Font = Enum.Font.GothamBold
			btn.TextSize = 13
			btn.TextXAlignment = Enum.TextXAlignment.Center
			btn.ZIndex = 22
			grad3(btn, 0)

			if btnConfig.Icon then
				local ic = Instance.new("ImageLabel", row)
				ic.Size = UDim2.new(0, 16, 0, 16)
				ic.AnchorPoint = Vector2.new(1, 0.5)
				ic.Position = UDim2.new(1, -10, 0.5, 0)
				ic.BackgroundTransparency = 1
				ic.Image = resolveIcon(btnConfig.Icon)
				ic.ImageColor3 = ACCENT
				ic.ZIndex = 22
			end

			btn.MouseButton1Click:Connect(function()
				ripple(row)
				callback()
			end)
		end

		function Tab:AddToggle(togConfig)
			togConfig = togConfig or {}
			local name = togConfig.Name or "Toggle"
			local default = togConfig.Default or false
			local callback = togConfig.Callback or function() end
			local state = default
			local row = makeRow(36, name)
			makeLabel(row, name, togConfig.Icon)

			local toggleTrack = Instance.new("Frame", row)
			toggleTrack.Size = UDim2.new(0, 42, 0, 24)
			toggleTrack.AnchorPoint = Vector2.new(1, 0.5)
			toggleTrack.Position = UDim2.new(1, -10, 0.5, 0)
			toggleTrack.BackgroundColor3 = T.Track
			toggleTrack.BorderSizePixel = 0
			toggleTrack.ZIndex = 21
			Instance.new("UICorner", toggleTrack).CornerRadius = UDim.new(1, 0)

			local trackStroke = Instance.new("UIStroke", toggleTrack)
			trackStroke.Thickness = 1.5
			trackStroke.Transparency = 0.5
			grad3(trackStroke, 45)

			local knob = Instance.new("Frame", toggleTrack)
			knob.Size = UDim2.new(0, 18, 0, 18)
			knob.Position = UDim2.new(0, 3, 0.5, -9)
			knob.BackgroundColor3 = WHITE
			knob.BorderSizePixel = 0
			knob.ZIndex = 22
			Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

			local function updateVisual(s)
				if s then
					TweenService:Create(toggleTrack, TweenInfo.new(0.2), {BackgroundColor3 = ACCENT_DIM}):Play()
					TweenService:Create(knob, TweenInfo.new(0.2), {Position = UDim2.new(0, 21, 0.5, -9), BackgroundColor3 = ACCENT}):Play()
				else
					TweenService:Create(toggleTrack, TweenInfo.new(0.2), {BackgroundColor3 = T.Track}):Play()
					TweenService:Create(knob, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -9), BackgroundColor3 = WHITE}):Play()
				end
			end

			updateVisual(state)

			local btn = Instance.new("TextButton", row)
			btn.Size = UDim2.new(1, 0, 1, 0)
			btn.BackgroundTransparency = 1
			btn.Text = ""
			btn.ZIndex = 23
			btn.MouseButton1Click:Connect(function()
				state = not state
				updateVisual(state)
				callback(state)
			end)
		end

		function Tab:AddInput(inputConfig)
			inputConfig = inputConfig or {}
			local name = inputConfig.Name or "Input"
			local placeholder = inputConfig.Placeholder or "Enter text..."
			local callback = inputConfig.Callback or function() end
			local row = makeRow(36, name)
			makeLabel(row, name, inputConfig.Icon)

			local inputBg = Instance.new("Frame", row)
			inputBg.Size = UDim2.new(0.42, 0, 0, 24)
			inputBg.AnchorPoint = Vector2.new(1, 0.5)
			inputBg.Position = UDim2.new(1, -10, 0.5, 0)
			inputBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			inputBg.BackgroundTransparency = 0.5
			inputBg.ZIndex = 21
			Instance.new("UICorner", inputBg).CornerRadius = UDim.new(0, 8)

			local inputStroke = Instance.new("UIStroke", inputBg)
			inputStroke.Thickness = 1.5
			inputStroke.Transparency = 0.5
			grad3(inputStroke, 45)

			local textBox = Instance.new("TextBox", inputBg)
			textBox.Size = UDim2.new(1, -10, 1, 0)
			textBox.Position = UDim2.new(0, 7, 0, 0)
			textBox.BackgroundTransparency = 1
			textBox.Text = ""
			textBox.PlaceholderText = placeholder
			textBox.TextColor3 = WHITE
			textBox.PlaceholderColor3 = GRAY
			textBox.Font = Enum.Font.Gotham
			textBox.TextSize = 12
			textBox.TextXAlignment = Enum.TextXAlignment.Left
			textBox.ClearTextOnFocus = false
			textBox.ZIndex = 22

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
			local row = makeRow(36, name)
			makeLabel(row, name, sliderConfig.Icon)

			local sliderBox = Instance.new("Frame", row)
			sliderBox.Size = UDim2.new(0.42, 0, 0, 26)
			sliderBox.AnchorPoint = Vector2.new(1, 0.5)
			sliderBox.Position = UDim2.new(1, -8, 0.5, 0)
			sliderBox.BackgroundColor3 = T.Field
			sliderBox.BackgroundTransparency = 0.2
			sliderBox.BorderSizePixel = 0
			sliderBox.ZIndex = 21
			sliderBox.ClipsDescendants = true
			Instance.new("UICorner", sliderBox).CornerRadius = UDim.new(0, 6)

			local sliderStroke = Instance.new("UIStroke", sliderBox)
			sliderStroke.Thickness = 1.5
			sliderStroke.Transparency = 0.3
			grad3(sliderStroke, 45)

			local fillBar = Instance.new("Frame", sliderBox)
			fillBar.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
			fillBar.Position = UDim2.new(0, 0, 0, 0)
			fillBar.BackgroundColor3 = ACCENT
			fillBar.BackgroundTransparency = 0.3
			fillBar.BorderSizePixel = 0
			fillBar.ZIndex = 22
			Instance.new("UICorner", fillBar).CornerRadius = UDim.new(0, 6)
			grad3(fillBar, 0)

			local numLabel = Instance.new("TextLabel", sliderBox)
			numLabel.Size = UDim2.new(1, 0, 1, 0)
			numLabel.Position = UDim2.new(0, 0, 0, 0)
			numLabel.BackgroundTransparency = 1
			numLabel.Text = tostring(value)
			numLabel.TextColor3 = WHITE
			numLabel.Font = Enum.Font.GothamBold
			numLabel.TextSize = 12
			numLabel.TextXAlignment = Enum.TextXAlignment.Center
			numLabel.ZIndex = 23

			local draggingSlider = false

			local function updateSlider(inputX)
				local abs = sliderBox.AbsolutePosition
				local size = sliderBox.AbsoluteSize
				local rel = math.clamp((inputX - abs.X) / size.X, 0, 1)
				value = math.floor(min + (max - min) * rel + 0.5)
				local pct = (value - min) / (max - min)
				fillBar.Size = UDim2.new(pct, 0, 1, 0)
				numLabel.Text = tostring(value)
				callback(value)
			end

			local sliderBtn = Instance.new("TextButton", sliderBox)
			sliderBtn.Size = UDim2.new(1, 0, 1, 0)
			sliderBtn.BackgroundTransparency = 1
			sliderBtn.Text = ""
			sliderBtn.ZIndex = 25

			sliderBtn.MouseButton1Down:Connect(function(x, y)
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

		function Tab:AddDropdown(dropConfig)
			dropConfig = dropConfig or {}
			local name = dropConfig.Name or "Dropdown"
			local options = dropConfig.Options or {}
			local callback = dropConfig.Callback or function() end
			local selected = dropConfig.Default or options[1] or "Select"
			local isDropOpen = false
			local trackConn = nil

			local searchText = name
			for _, o in ipairs(options) do
				searchText = searchText .. " " .. tostring(o)
			end

			local row = makeRow(36, searchText)
			makeLabel(row, name, dropConfig.Icon)

			local dropBox = Instance.new("Frame", row)
			dropBox.Size = UDim2.new(0.42, 0, 0, 24)
			dropBox.AnchorPoint = Vector2.new(1, 0.5)
			dropBox.Position = UDim2.new(1, -10, 0.5, 0)
			dropBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			dropBox.BackgroundTransparency = 0.5
			dropBox.ZIndex = 21
			Instance.new("UICorner", dropBox).CornerRadius = UDim.new(0, 8)

			local dropStroke = Instance.new("UIStroke", dropBox)
			dropStroke.Thickness = 1.5
			dropStroke.Transparency = 0.5
			grad3(dropStroke, 45)

			local selLabel = Instance.new("TextLabel", dropBox)
			selLabel.Size = UDim2.new(1, -22, 1, 0)
			selLabel.Position = UDim2.new(0, 7, 0, 0)
			selLabel.BackgroundTransparency = 1
			selLabel.Text = selected
			selLabel.TextColor3 = ACCENT
			selLabel.Font = Enum.Font.GothamBold
			selLabel.TextSize = 12
			selLabel.TextXAlignment = Enum.TextXAlignment.Left
			selLabel.TextTruncate = Enum.TextTruncate.AtEnd
			selLabel.ZIndex = 22
			grad3(selLabel, 0)

			local arrow = Instance.new("TextLabel", dropBox)
			arrow.Size = UDim2.new(0, 16, 1, 0)
			arrow.Position = UDim2.new(1, -18, 0, 0)
			arrow.BackgroundTransparency = 1
			arrow.Text = "v"
			arrow.TextColor3 = ACCENT
			arrow.Font = Enum.Font.GothamBold
			arrow.TextSize = 11
			arrow.ZIndex = 22
			grad3(arrow, 0)

			local optionHeight = 28
			local totalHeight = #options * (optionHeight + 2) + 8

			local dropList = Instance.new("Frame", ScreenGui)
			dropList.Size = UDim2.new(0, 0, 0, 0)
			dropList.BackgroundColor3 = DARK
			dropList.BackgroundTransparency = 0.2
			dropList.BorderSizePixel = 0
			dropList.ZIndex = 200
			dropList.Visible = false
			dropList.ClipsDescendants = true
			Instance.new("UICorner", dropList).CornerRadius = UDim.new(0, 8)

			local dropListStroke = Instance.new("UIStroke", dropList)
			dropListStroke.Thickness = 1.5
			dropListStroke.Transparency = 0.4
			grad3(dropListStroke, 45)

			local dlList = Instance.new("UIListLayout", dropList)
			dlList.SortOrder = Enum.SortOrder.LayoutOrder
			dlList.Padding = UDim.new(0, 2)

			local dlPad = Instance.new("UIPadding", dropList)
			dlPad.PaddingTop = UDim.new(0, 4)
			dlPad.PaddingBottom = UDim.new(0, 4)
			dlPad.PaddingLeft = UDim.new(0, 4)
			dlPad.PaddingRight = UDim.new(0, 4)

			local function boxW()
				return dropBox.AbsoluteSize.X
			end

			for idx, opt in ipairs(options) do
				local optBtn = Instance.new("TextButton", dropList)
				optBtn.Size = UDim2.new(1, 0, 0, optionHeight)
				optBtn.BackgroundColor3 = T.Option
				optBtn.BackgroundTransparency = 0.4
				optBtn.Text = opt
				optBtn.TextColor3 = ACCENT
				optBtn.Font = Enum.Font.GothamBold
				optBtn.TextSize = 12
				optBtn.ZIndex = 201
				optBtn.LayoutOrder = idx
				Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0, 5)

				optBtn.MouseEnter:Connect(function()
					TweenService:Create(optBtn, TweenInfo.new(0.1), {BackgroundTransparency = 0.1, TextColor3 = WHITE}):Play()
				end)
				optBtn.MouseLeave:Connect(function()
					TweenService:Create(optBtn, TweenInfo.new(0.1), {BackgroundTransparency = 0.4, TextColor3 = ACCENT}):Play()
				end)
				optBtn.MouseButton1Click:Connect(function()
					selected = opt
					selLabel.Text = opt
					isDropOpen = false
					dropList.Visible = false
					if trackConn then trackConn:Disconnect() trackConn = nil end
					TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
					callback(opt)
				end)
			end

			local function syncDropPos()
				local absPos = dropBox.AbsolutePosition
				local absSize = dropBox.AbsoluteSize
				dropList.Position = UDim2.new(0, absPos.X, 0, absPos.Y + absSize.Y + 4)
			end

			local dropBtn = Instance.new("TextButton", dropBox)
			dropBtn.Size = UDim2.new(1, 0, 1, 0)
			dropBtn.BackgroundTransparency = 1
			dropBtn.Text = ""
			dropBtn.ZIndex = 23

			dropBtn.MouseButton1Click:Connect(function()
				isDropOpen = not isDropOpen
				if isDropOpen then
					syncDropPos()
					dropList.Visible = true
					dropList.Size = UDim2.new(0, boxW(), 0, 0)
					TweenService:Create(dropList, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(0, boxW(), 0, totalHeight)}):Play()
					TweenService:Create(arrow, TweenInfo.new(0.25), {Rotation = 180}):Play()
					trackConn = RunService.RenderStepped:Connect(function()
						if isDropOpen and dropList.Visible then
							syncDropPos()
						end
					end)
				else
					TweenService:Create(dropList, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {Size = UDim2.new(0, boxW(), 0, 0)}):Play()
					TweenService:Create(arrow, TweenInfo.new(0.25), {Rotation = 0}):Play()
					task.delay(0.26, function() dropList.Visible = false end)
					if trackConn then trackConn:Disconnect() trackConn = nil end
				end
			end)
		end

		function Tab:AddMultiDropdown(dropConfig)
			dropConfig = dropConfig or {}
			local name = dropConfig.Name or "Multi Dropdown"
			local options = dropConfig.Options or {}
			local callback = dropConfig.Callback or function() end
			local selectedMap = {}
			local selectedCount = 0
			local isDropOpen = false
			local trackConn = nil

			local searchText = name
			for _, o in ipairs(options) do
				searchText = searchText .. " " .. tostring(o)
			end

			local row = makeRow(36, searchText)
			makeLabel(row, name, dropConfig.Icon)

			local dropBox = Instance.new("Frame", row)
			dropBox.Size = UDim2.new(0.42, 0, 0, 24)
			dropBox.AnchorPoint = Vector2.new(1, 0.5)
			dropBox.Position = UDim2.new(1, -10, 0.5, 0)
			dropBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			dropBox.BackgroundTransparency = 0.5
			dropBox.ZIndex = 21
			Instance.new("UICorner", dropBox).CornerRadius = UDim.new(0, 8)

			local dropStroke = Instance.new("UIStroke", dropBox)
			dropStroke.Thickness = 1.5
			dropStroke.Transparency = 0.5
			grad3(dropStroke, 45)

			local selLabel = Instance.new("TextLabel", dropBox)
			selLabel.Size = UDim2.new(1, -22, 1, 0)
			selLabel.Position = UDim2.new(0, 7, 0, 0)
			selLabel.BackgroundTransparency = 1
			selLabel.Text = "No Selected"
			selLabel.TextColor3 = WHITE
			selLabel.Font = Enum.Font.GothamBold
			selLabel.TextSize = 12
			selLabel.TextXAlignment = Enum.TextXAlignment.Left
			selLabel.TextTruncate = Enum.TextTruncate.AtEnd
			selLabel.ZIndex = 22

			local arrow = Instance.new("TextLabel", dropBox)
			arrow.Size = UDim2.new(0, 16, 1, 0)
			arrow.Position = UDim2.new(1, -18, 0, 0)
			arrow.BackgroundTransparency = 1
			arrow.Text = "v"
			arrow.TextColor3 = ACCENT
			arrow.Font = Enum.Font.GothamBold
			arrow.TextSize = 11
			arrow.ZIndex = 22
			grad3(arrow, 0)

			local optionHeight = 28
			local totalHeight = #options * (optionHeight + 2) + 8

			local dropList = Instance.new("Frame", ScreenGui)
			dropList.Size = UDim2.new(0, 0, 0, 0)
			dropList.BackgroundColor3 = DARK
			dropList.BackgroundTransparency = 0.2
			dropList.BorderSizePixel = 0
			dropList.ZIndex = 200
			dropList.Visible = false
			dropList.ClipsDescendants = true
			Instance.new("UICorner", dropList).CornerRadius = UDim.new(0, 8)

			local dropListStroke = Instance.new("UIStroke", dropList)
			dropListStroke.Thickness = 1.5
			dropListStroke.Transparency = 0.4
			grad3(dropListStroke, 45)

			local dlList = Instance.new("UIListLayout", dropList)
			dlList.SortOrder = Enum.SortOrder.LayoutOrder
			dlList.Padding = UDim.new(0, 2)

			local dlPad = Instance.new("UIPadding", dropList)
			dlPad.PaddingTop = UDim.new(0, 4)
			dlPad.PaddingBottom = UDim.new(0, 4)
			dlPad.PaddingLeft = UDim.new(0, 4)
			dlPad.PaddingRight = UDim.new(0, 4)

			local function boxW()
				return dropBox.AbsoluteSize.X
			end

			local function updateSelLabel()
				if selectedCount <= 0 then
					selLabel.Text = "No Selected"
					selLabel.TextColor3 = WHITE
				else
					selLabel.Text = selectedCount .. "+ Selected"
					selLabel.TextColor3 = ACCENT
				end
			end

			local function getSelectedList()
				local list = {}
				for _, opt in ipairs(options) do
					if selectedMap[opt] then
						table.insert(list, opt)
					end
				end
				return list
			end

			for idx, opt in ipairs(options) do
				local optBtn = Instance.new("TextButton", dropList)
				optBtn.Size = UDim2.new(1, 0, 0, optionHeight)
				optBtn.BackgroundColor3 = T.Option
				optBtn.BackgroundTransparency = 0.4
				optBtn.Text = opt
				optBtn.TextColor3 = WHITE
				optBtn.Font = Enum.Font.GothamBold
				optBtn.TextSize = 12
				optBtn.ZIndex = 201
				optBtn.LayoutOrder = idx
				Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0, 5)

				optBtn.MouseEnter:Connect(function()
					if not selectedMap[opt] then
						TweenService:Create(optBtn, TweenInfo.new(0.1), {BackgroundTransparency = 0.1}):Play()
					end
				end)
				optBtn.MouseLeave:Connect(function()
					if not selectedMap[opt] then
						TweenService:Create(optBtn, TweenInfo.new(0.1), {BackgroundTransparency = 0.4}):Play()
					end
				end)
				optBtn.MouseButton1Click:Connect(function()
					selectedMap[opt] = not selectedMap[opt]
					if selectedMap[opt] then
						selectedCount = selectedCount + 1
						TweenService:Create(optBtn, TweenInfo.new(0.15), {BackgroundColor3 = ACCENT, BackgroundTransparency = 0, TextColor3 = WHITE}):Play()
					else
						selectedCount = selectedCount - 1
						TweenService:Create(optBtn, TweenInfo.new(0.15), {BackgroundColor3 = T.Option, BackgroundTransparency = 0.4, TextColor3 = WHITE}):Play()
					end
					updateSelLabel()
					callback(getSelectedList())
				end)
			end

			local function syncDropPos()
				local absPos = dropBox.AbsolutePosition
				local absSize = dropBox.AbsoluteSize
				dropList.Position = UDim2.new(0, absPos.X, 0, absPos.Y + absSize.Y + 4)
			end

			local dropBtn = Instance.new("TextButton", dropBox)
			dropBtn.Size = UDim2.new(1, 0, 1, 0)
			dropBtn.BackgroundTransparency = 1
			dropBtn.Text = ""
			dropBtn.ZIndex = 23

			dropBtn.MouseButton1Click:Connect(function()
				isDropOpen = not isDropOpen
				if isDropOpen then
					syncDropPos()
					dropList.Visible = true
					dropList.Size = UDim2.new(0, boxW(), 0, 0)
					TweenService:Create(dropList, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(0, boxW(), 0, totalHeight)}):Play()
					TweenService:Create(arrow, TweenInfo.new(0.25), {Rotation = 180}):Play()
					trackConn = RunService.RenderStepped:Connect(function()
						if isDropOpen and dropList.Visible then
							syncDropPos()
						end
					end)
				else
					TweenService:Create(dropList, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {Size = UDim2.new(0, boxW(), 0, 0)}):Play()
					TweenService:Create(arrow, TweenInfo.new(0.25), {Rotation = 0}):Play()
					task.delay(0.26, function() dropList.Visible = false end)
					if trackConn then trackConn:Disconnect() trackConn = nil end
				end
			end)
		end

		function Tab:AddSocialLinkCopy(socConfig)
			socConfig = socConfig or {}
			local name = socConfig.Name or "Social"
			local image = socConfig.Image or socConfig.Icon or ""
			local about = socConfig.About or "Subscribe me"
			local link = socConfig.Link or ""
			local buttonText = socConfig.ButtonText or "Copy Link"
			local callback = socConfig.Callback or function() end
			local lines = math.max(1, math.ceil(#about / 8))
			local h = math.max(72, 56 + lines * 12)

			local row = makeRow(h, name .. " " .. about)

			local iconImg = Instance.new("ImageLabel", row)
			iconImg.Size = UDim2.new(0, 40, 0, 40)
			iconImg.Position = UDim2.new(0, 10, 0, 8)
			iconImg.BackgroundColor3 = T.Field
			iconImg.BorderSizePixel = 0
			iconImg.ScaleType = Enum.ScaleType.Crop
			iconImg.Image = image ~= "" and resolveIcon(image) or ""
			iconImg.ZIndex = 21
			Instance.new("UICorner", iconImg).CornerRadius = UDim.new(0, 12)
			local iconStroke = Instance.new("UIStroke", iconImg)
			iconStroke.Thickness = 1.5
			iconStroke.Transparency = 0.4
			grad3(iconStroke, 45)

			local aboutLbl = Instance.new("TextLabel", row)
			aboutLbl.Size = UDim2.new(0, 60, 0, lines * 12)
			aboutLbl.Position = UDim2.new(0, 0, 0, 52)
			aboutLbl.BackgroundTransparency = 1
			aboutLbl.Text = about
			aboutLbl.TextColor3 = GRAY
			aboutLbl.Font = Enum.Font.Gotham
			aboutLbl.TextSize = 10
			aboutLbl.TextWrapped = true
			aboutLbl.TextXAlignment = Enum.TextXAlignment.Center
			aboutLbl.TextYAlignment = Enum.TextYAlignment.Top
			aboutLbl.ZIndex = 21

			local nameLbl = Instance.new("TextLabel", row)
			nameLbl.Size = UDim2.new(1, -66, 0, 16)
			nameLbl.Position = UDim2.new(0, 60, 0, 10)
			nameLbl.BackgroundTransparency = 1
			nameLbl.Text = name
			nameLbl.TextColor3 = WHITE
			nameLbl.Font = Enum.Font.GothamBold
			nameLbl.TextSize = 13
			nameLbl.TextXAlignment = Enum.TextXAlignment.Left
			nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
			nameLbl.ZIndex = 21

			local copyBtn = Instance.new("TextButton", row)
			copyBtn.Size = UDim2.new(1, -66, 0, 24)
			copyBtn.Position = UDim2.new(0, 60, 0, 32)
			copyBtn.BackgroundColor3 = T.Option
			copyBtn.BackgroundTransparency = 0.3
			copyBtn.Text = buttonText
			copyBtn.TextColor3 = ACCENT
			copyBtn.Font = Enum.Font.GothamBold
			copyBtn.TextSize = 11
			copyBtn.ZIndex = 22
			Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 6)

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
			local image = menuConfig.Image or ""
			local callback = menuConfig.Callback or function() end
			local buttons = menuConfig.Buttons or {}
			local h = 128
			if kind == "Button" then
				h = 102 + #buttons * 28
			end

			local row = makeRow(h, name)

			local bg = Instance.new("TextButton", row)
			bg.Size = UDim2.new(1, 0, 1, 0)
			bg.BackgroundTransparency = 1
			bg.Text = ""
			bg.ZIndex = 20
			bg.MouseButton1Click:Connect(function()
				ripple(row)
				callback(name)
			end)

			local sq = Instance.new("ImageLabel", row)
			sq.Size = UDim2.new(0, 64, 0, 64)
			sq.Position = UDim2.new(0.5, -32, 0, 8)
			sq.BackgroundColor3 = T.Field
			sq.BorderSizePixel = 0
			sq.ScaleType = Enum.ScaleType.Crop
			sq.Image = image ~= "" and resolveIcon(image) or ""
			sq.ZIndex = 21
			Instance.new("UICorner", sq).CornerRadius = UDim.new(0, 14)
			local sqStroke = Instance.new("UIStroke", sq)
			sqStroke.Thickness = 1.5
			sqStroke.Transparency = 0.3
			grad3(sqStroke, 45)

			local nameLbl = Instance.new("TextLabel", row)
			nameLbl.Size = UDim2.new(1, -10, 0, 16)
			nameLbl.Position = UDim2.new(0, 5, 0, 76)
			nameLbl.BackgroundTransparency = 1
			nameLbl.Text = name
			nameLbl.TextColor3 = WHITE
			nameLbl.Font = Enum.Font.GothamBold
			nameLbl.TextSize = 13
			nameLbl.TextXAlignment = Enum.TextXAlignment.Center
			nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
			nameLbl.ZIndex = 21

			if kind == "Button" then
				for i, b in ipairs(buttons) do
					local bb = Instance.new("TextButton", row)
					bb.Size = UDim2.new(1, -12, 0, 24)
					bb.Position = UDim2.new(0, 6, 0, 96 + (i - 1) * 28)
					bb.BackgroundColor3 = T.Option
					bb.BackgroundTransparency = 0.3
					bb.Text = b.Name or ("Button " .. i)
					bb.TextColor3 = ACCENT
					bb.Font = Enum.Font.GothamBold
					bb.TextSize = 11
					bb.ZIndex = 22
					Instance.new("UICorner", bb).CornerRadius = UDim.new(0, 6)

					if b.Icon then
						local ic = Instance.new("ImageLabel", bb)
						ic.Size = UDim2.new(0, 14, 0, 14)
						ic.AnchorPoint = Vector2.new(1, 0.5)
						ic.Position = UDim2.new(1, -8, 0.5, 0)
						ic.BackgroundTransparency = 1
						ic.Image = resolveIcon(b.Icon)
						ic.ImageColor3 = ACCENT
						ic.ZIndex = 23
					end

					bb.MouseButton1Click:Connect(function()
						ripple(row)
						if b.Callback then b.Callback() end
					end)
				end
			else
				local btnRow = Instance.new("Frame", row)
				btnRow.Size = UDim2.new(1, -12, 0, 26)
				btnRow.Position = UDim2.new(0, 6, 0, 96)
				btnRow.BackgroundTransparency = 1
				btnRow.ZIndex = 21

				local bLayout = Instance.new("UIListLayout", btnRow)
				bLayout.FillDirection = Enum.FillDirection.Horizontal
				bLayout.SortOrder = Enum.SortOrder.LayoutOrder
				bLayout.Padding = UDim.new(0, 4)
				bLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

				for idx, r in ipairs(MENU_REACTIONS) do
					local rb = Instance.new("TextButton", btnRow)
					rb.Size = UDim2.new(0.25, -4, 1, 0)
					rb.BackgroundColor3 = T.Option
					rb.BackgroundTransparency = 0.4
					rb.Text = ""
					rb.LayoutOrder = idx
					rb.ZIndex = 22
					Instance.new("UICorner", rb).CornerRadius = UDim.new(0, 6)

					local rIcon = Instance.new("ImageLabel", rb)
					rIcon.Size = UDim2.new(0, 14, 0, 14)
					rIcon.AnchorPoint = Vector2.new(0.5, 0.5)
					rIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
					rIcon.BackgroundTransparency = 1
					rIcon.Image = resolveIcon(r.Icon)
					rIcon.ImageColor3 = WHITE
					rIcon.ZIndex = 23

					rb.MouseButton1Click:Connect(function()
						TweenService:Create(rb, TweenInfo.new(0.15), {BackgroundColor3 = ACCENT, BackgroundTransparency = 0}):Play()
						task.delay(0.3, function()
							TweenService:Create(rb, TweenInfo.new(0.2), {BackgroundColor3 = T.Option, BackgroundTransparency = 0.4}):Play()
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
			local barColor = ACCENT
			local startDelay = cfg.StartedNotify or 0
			local duration = cfg.EndedNotify or 4

			task.wait(startDelay)

			local notifGui = Instance.new("ScreenGui")
			notifGui.Name = "RobloxNotif_" .. tostring(os.clock())
			notifGui.ResetOnSpawn = false
			notifGui.DisplayOrder = 9999
			notifGui.Parent = CoreGui

			local frameH = 85
			local nFrame = Instance.new("Frame")
			nFrame.Size = UDim2.new(0, 280, 0, frameH)
			nFrame.Position = UDim2.new(1, 10, 1, -(frameH + 14))
			nFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
			nFrame.BackgroundTransparency = 0.2
			nFrame.BorderSizePixel = 0
			nFrame.Parent = notifGui
			Instance.new("UICorner", nFrame).CornerRadius = UDim.new(0, 8)

			local contentOffsetX = 12
			local topOffsetY = 8

			if useIcon then
				local isRbx = tostring(iconVal):find("rbxassetid://") ~= nil
				local iconImg = Instance.new("ImageLabel", nFrame)
				iconImg.Size = UDim2.new(0, 16, 0, 16)
				iconImg.Position = UDim2.new(0, contentOffsetX, 0, topOffsetY)
				iconImg.BackgroundTransparency = 1
				iconImg.ScaleType = Enum.ScaleType.Fit
				iconImg.ImageColor3 = WHITE
				if isRbx then
					iconImg.Image = tostring(iconVal)
				else
					iconImg.Image = resolveIcon(tostring(iconVal))
				end

				local titleLbl = Instance.new("TextLabel", nFrame)
				titleLbl.Size = UDim2.new(1, -(contentOffsetX + 22), 0, 20)
				titleLbl.Position = UDim2.new(0, contentOffsetX + 22, 0, topOffsetY - 2)
				titleLbl.BackgroundTransparency = 1
				titleLbl.Text = titleText
				titleLbl.TextColor3 = GRAY
				titleLbl.Font = Enum.Font.Gotham
				titleLbl.TextSize = 13
				titleLbl.TextXAlignment = Enum.TextXAlignment.Left

				local bodyLbl = Instance.new("TextLabel", nFrame)
				bodyLbl.Size = UDim2.new(1, -contentOffsetX, 0, 30)
				bodyLbl.Position = UDim2.new(0, contentOffsetX, 0, topOffsetY + 20)
				bodyLbl.BackgroundTransparency = 1
				bodyLbl.Text = bodyText
				bodyLbl.TextColor3 = WHITE
				bodyLbl.Font = Enum.Font.GothamBold
				bodyLbl.TextSize = 16
				bodyLbl.TextXAlignment = Enum.TextXAlignment.Left
			else
				local titleLbl = Instance.new("TextLabel", nFrame)
				titleLbl.Size = UDim2.new(1, -contentOffsetX, 0, 20)
				titleLbl.Position = UDim2.new(0, contentOffsetX, 0, topOffsetY)
				titleLbl.BackgroundTransparency = 1
				titleLbl.Text = titleText
				titleLbl.TextColor3 = GRAY
				titleLbl.Font = Enum.Font.Gotham
				titleLbl.TextSize = 13
				titleLbl.TextXAlignment = Enum.TextXAlignment.Left

				local bodyLbl = Instance.new("TextLabel", nFrame)
				bodyLbl.Size = UDim2.new(1, -contentOffsetX, 0, 30)
				bodyLbl.Position = UDim2.new(0, contentOffsetX, 0, topOffsetY + 18)
				bodyLbl.BackgroundTransparency = 1
				bodyLbl.Text = bodyText
				bodyLbl.TextColor3 = WHITE
				bodyLbl.Font = Enum.Font.GothamBold
				bodyLbl.TextSize = 16
				bodyLbl.TextXAlignment = Enum.TextXAlignment.Left
			end

			local barBg = Instance.new("Frame", nFrame)
			barBg.Size = UDim2.new(1, -24, 0, 5)
			barBg.Position = UDim2.new(0, 12, 1, -12)
			barBg.BackgroundColor3 = Color3.fromRGB(35, 20, 50)
			barBg.BorderSizePixel = 0
			Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

			local bar = Instance.new("Frame", barBg)
			bar.Size = UDim2.new(0, 0, 1, 0)
			bar.BackgroundColor3 = barColor
			bar.BorderSizePixel = 0
			Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
			grad3(bar, 0)

			local tweenIn = TweenService:Create(nFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Position = UDim2.new(1, -290, 1, -(frameH + 14))
			})
			tweenIn:Play()
			tweenIn.Completed:Connect(function()
				local barTween = TweenService:Create(bar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
					Size = UDim2.new(1, 0, 1, 0)
				})
				barTween:Play()
				barTween.Completed:Connect(function()
					local tweenOut = TweenService:Create(nFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
						Position = UDim2.new(1, 10, 1, -(frameH + 14))
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
		ACCENT = T.Accent
		ACCENT_DIM = T.AccentDim
		DARK = T.Dark
		BG_IMAGE = T.Background
		LOGO_DECAL = T.Logo
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
			Max = 100,
			Default = ConfigState.Transparency,
			Callback = function(v)
				ConfigState.Transparency = v
				Main.BackgroundTransparency = v / 100
				autoSave()
			end
		})

		Cfg:AddToggle({
			Name = "Use Image",
			Icon = "image",
			Default = ConfigState.UseImage,
			Callback = function(state)
				ConfigState.UseImage = state
				BgImage.Visible = state
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

	Window:AddConfigTab()

	return Window
end

return RhapsodentLibrary
