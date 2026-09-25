local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local Icons = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/Main-v2.lua"))()
Icons.SetIconsType("lucide")

local SeseLib = {}
SeseLib.__index = SeseLib

local ACCENT = Color3.fromRGB(191, 0, 255)
local ACCENT_DIM = Color3.fromRGB(60, 20, 90)
local DARK = Color3.fromRGB(12, 8, 20)
local DARK2 = Color3.fromRGB(18, 12, 28)
local WHITE = Color3.fromRGB(255, 255, 255)
local GRAY = Color3.fromRGB(160, 160, 160)
local BG_IMAGE = "rbxassetid://99940036804594"
local LOGO_DECAL = "rbxassetid://118324456844701"

local function grad3(obj, rot)
	local g = Instance.new("UIGradient")
	g.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(191, 0, 255)),
		ColorSequenceKeypoint.new(0.55, Color3.fromRGB(60, 60, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 4, 18))
	})
	g.Rotation = rot or 45
	g.Parent = obj
	return g
end

function SeseLib:CreateWindow(config)
	config = config or {}
	local title = config.Title or "SeseLib"

	if CoreGui:FindFirstChild("SeseUI_" .. title) then
		CoreGui:FindFirstChild("SeseUI_" .. title):Destroy()
	end

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "SeseUI_" .. title
	ScreenGui.Parent = CoreGui
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.DisplayOrder = 999

	local W, H = 520, 370
	local TAB_W = 130

	local Main = Instance.new("Frame")
	Main.Name = "Main"
	Main.Parent = ScreenGui
	Main.BackgroundColor3 = DARK
	Main.BackgroundTransparency = 0.45
	Main.Position = UDim2.new(0.5, -(W/2), 0.5, -(H/2))
	Main.Size = UDim2.new(0, W, 0, H)
	Main.ClipsDescendants = true

	local mainStroke = Instance.new("UIStroke", Main)
	mainStroke.Thickness = 2.5
	mainStroke.Transparency = 0.3
	grad3(mainStroke, 90)

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
	TabToggleBtn.Size = UDim2.new(0, 32, 0, 32)
	TabToggleBtn.Position = UDim2.new(0, 6, 0.5, -16)
	TabToggleBtn.BackgroundTransparency = 1
	TabToggleBtn.Image = LOGO_DECAL
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

	local TabSidebar = Instance.new("Frame", Main)
	TabSidebar.Name = "TabSidebar"
	TabSidebar.Size = UDim2.new(0, 0, 1, -40)
	TabSidebar.Position = UDim2.new(0, 0, 0, 40)
	TabSidebar.BackgroundColor3 = Color3.fromRGB(10, 6, 18)
	TabSidebar.BackgroundTransparency = 0.3
	TabSidebar.BorderSizePixel = 0
	TabSidebar.ZIndex = 10
	TabSidebar.ClipsDescendants = true
	Instance.new("UICorner", TabSidebar).CornerRadius = UDim.new(0, 10)

	local SideList = Instance.new("UIListLayout", TabSidebar)
	SideList.SortOrder = Enum.SortOrder.LayoutOrder
	SideList.Padding = UDim.new(0, 4)
	SideList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	SideList.VerticalAlignment = Enum.VerticalAlignment.Top

	local SidePad = Instance.new("UIPadding", TabSidebar)
	SidePad.PaddingTop = UDim.new(0, 10)
	SidePad.PaddingLeft = UDim.new(0, 6)
	SidePad.PaddingRight = UDim.new(0, 6)

	local ContentArea = Instance.new("Frame", Main)
	ContentArea.Name = "ContentArea"
	ContentArea.Size = UDim2.new(1, 0, 1, -40)
	ContentArea.Position = UDim2.new(0, 0, 0, 40)
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
	local sidebarOpen = false

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
	floatStroke.Transparency = 0.2
	grad3(floatStroke, 90)

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
	local activeTab = nil
	local tabOrder = 0

	local Window = {}

	function Window:AddTab(tabConfig)
		tabConfig = tabConfig or {}
		local tabName = tabConfig.Name or "Tab"
		local tabIcon = tabConfig.Icon or "circle"
		tabOrder = tabOrder + 1

		local TabBtn = Instance.new("TextButton", TabSidebar)
		TabBtn.Size = UDim2.new(1, 0, 0, 34)
		TabBtn.BackgroundColor3 = Color3.fromRGB(20, 10, 35)
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
		TabIconImg.Image = Icons.GetIcon(tabIcon)
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

		local TabWrapper = Instance.new("CanvasGroup", ContentArea)
		TabWrapper.Name = "Wrap_" .. tabName
		TabWrapper.Size = UDim2.new(1, 0, 1, 0)
		TabWrapper.BackgroundTransparency = 1
		TabWrapper.BorderSizePixel = 0
		TabWrapper.ZIndex = 6
		TabWrapper.Visible = false
		TabWrapper.GroupTransparency = 0

		local ScrollContainer = Instance.new("ScrollingFrame", TabWrapper)
		ScrollContainer.Name = "Tab_" .. tabName
		ScrollContainer.Size = UDim2.new(1, 0, 1, 0)
		ScrollContainer.BackgroundTransparency = 1
		ScrollContainer.BorderSizePixel = 0
		ScrollContainer.ScrollBarThickness = 3
		ScrollContainer.ScrollBarImageColor3 = ACCENT
		ScrollContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
		ScrollContainer.ZIndex = 6
		ScrollContainer.Visible = true
		ScrollContainer.ClipsDescendants = true
		ScrollContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

		local Pad = Instance.new("UIPadding", ScrollContainer)
		Pad.PaddingLeft = UDim.new(0, 8)
		Pad.PaddingRight = UDim.new(0, 8)
		Pad.PaddingTop = UDim.new(0, 8)
		Pad.PaddingBottom = UDim.new(0, 10)

		local List = Instance.new("UIListLayout", ScrollContainer)
		List.SortOrder = Enum.SortOrder.LayoutOrder
		List.Padding = UDim.new(0, 6)

		local function activateTab()
			if activeTab then
				local prevWrap = activeTab.Wrapper
				TweenService:Create(activeTab.IconImg, TweenInfo.new(0.2), {ImageColor3 = GRAY}):Play()
				TweenService:Create(activeTab.NameLabel, TweenInfo.new(0.2), {TextColor3 = GRAY}):Play()
				TweenService:Create(activeTab.Btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.7}):Play()
				TweenService:Create(activeTab.Line, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
				TweenService:Create(prevWrap, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {GroupTransparency = 1}):Play()
				task.delay(0.2, function() prevWrap.Visible = false prevWrap.GroupTransparency = 0 end)
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
		table.insert(tabs, {Wrapper = TabWrapper, Container = ScrollContainer, Btn = TabBtn, IconImg = TabIconImg, NameLabel = TabNameLabel, Line = TabActiveLine})

		local itemOrder = 0
		local Tab = {}

		local function makeRow(h)
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
			return row
		end

		local function makeLabel(parent, text)
			local lbl = Instance.new("TextLabel", parent)
			lbl.Size = UDim2.new(0, 145, 1, 0)
			lbl.Position = UDim2.new(0, 12, 0, 0)
			lbl.BackgroundTransparency = 1
			lbl.Text = text
			lbl.TextColor3 = ACCENT
			lbl.Font = Enum.Font.GothamBold
			lbl.TextSize = 13
			lbl.TextXAlignment = Enum.TextXAlignment.Left
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

			local secLabel = Instance.new("TextLabel", secRow)
			secLabel.Size = UDim2.new(1, -12, 1, 0)
			secLabel.Position = UDim2.new(0, 12, 0, 0)
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
		end

		function Tab:AddButton(btnConfig)
			btnConfig = btnConfig or {}
			local name = btnConfig.Name or "Button"
			local callback = btnConfig.Callback or function() end
			local row = makeRow(36)
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
			local row = makeRow(36)
			makeLabel(row, name)

			local toggleTrack = Instance.new("Frame", row)
			toggleTrack.Size = UDim2.new(0, 42, 0, 24)
			toggleTrack.AnchorPoint = Vector2.new(1, 0.5)
			toggleTrack.Position = UDim2.new(1, -10, 0.5, 0)
			toggleTrack.BackgroundColor3 = Color3.fromRGB(35, 15, 55)
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
					TweenService:Create(toggleTrack, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 15, 55)}):Play()
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
			local row = makeRow(36)
			makeLabel(row, name)

			local inputBg = Instance.new("Frame", row)
			inputBg.Size = UDim2.new(0, 165, 0, 24)
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
			local row = makeRow(36)
			makeLabel(row, name)

			local sliderBox = Instance.new("Frame", row)
			sliderBox.Size = UDim2.new(0, 175, 0, 26)
			sliderBox.AnchorPoint = Vector2.new(1, 0.5)
			sliderBox.Position = UDim2.new(1, -8, 0.5, 0)
			sliderBox.BackgroundColor3 = Color3.fromRGB(20, 10, 35)
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
			local selected = options[1] or "Select"
			local isDropOpen = false
			local trackConn = nil
			local row = makeRow(36)
			makeLabel(row, name)

			local dropBox = Instance.new("Frame", row)
			dropBox.Size = UDim2.new(0, 165, 0, 24)
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
			dropList.Size = UDim2.new(0, 165, 0, 0)
			dropList.BackgroundColor3 = Color3.fromRGB(12, 7, 22)
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

			for idx, opt in ipairs(options) do
				local optBtn = Instance.new("TextButton", dropList)
				optBtn.Size = UDim2.new(1, 0, 0, optionHeight)
				optBtn.BackgroundColor3 = Color3.fromRGB(30, 12, 45)
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
					dropList.Size = UDim2.new(0, 165, 0, 0)
					TweenService:Create(dropList, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 165, 0, totalHeight)}):Play()
					TweenService:Create(arrow, TweenInfo.new(0.25), {Rotation = 180}):Play()
					trackConn = RunService.RenderStepped:Connect(function()
						if isDropOpen and dropList.Visible then
							syncDropPos()
						end
					end)
				else
					TweenService:Create(dropList, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 165, 0, 0)}):Play()
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
			local row = makeRow(36)
			makeLabel(row, name)

			local dropBox = Instance.new("Frame", row)
			dropBox.Size = UDim2.new(0, 165, 0, 24)
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
			selLabel.TextColor3 = ACCENT
			selLabel.Font = Enum.Font.GothamBold
			selLabel.TextSize = 12
			selLabel.TextXAlignment = Enum.TextXAlignment.Left
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
			dropList.Size = UDim2.new(0, 165, 0, 0)
			dropList.BackgroundColor3 = Color3.fromRGB(12, 7, 22)
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

			local function updateSelLabel()
				if selectedCount <= 0 then
					selLabel.Text = "No Selected"
				else
					selLabel.Text = selectedCount .. "+ Selected"
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
				optBtn.BackgroundColor3 = Color3.fromRGB(30, 12, 45)
				optBtn.BackgroundTransparency = 0.4
				optBtn.Text = opt
				optBtn.TextColor3 = ACCENT
				optBtn.Font = Enum.Font.GothamBold
				optBtn.TextSize = 12
				optBtn.ZIndex = 201
				optBtn.LayoutOrder = idx
				Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0, 5)

				optBtn.MouseEnter:Connect(function()
					if not selectedMap[opt] then
						TweenService:Create(optBtn, TweenInfo.new(0.1), {BackgroundTransparency = 0.1, TextColor3 = WHITE}):Play()
					end
				end)
				optBtn.MouseLeave:Connect(function()
					if not selectedMap[opt] then
						TweenService:Create(optBtn, TweenInfo.new(0.1), {BackgroundTransparency = 0.4, TextColor3 = ACCENT}):Play()
					end
				end)
				optBtn.MouseButton1Click:Connect(function()
					selectedMap[opt] = not selectedMap[opt]
					if selectedMap[opt] then
						selectedCount = selectedCount + 1
						TweenService:Create(optBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0, TextColor3 = WHITE}):Play()
					else
						selectedCount = selectedCount - 1
						TweenService:Create(optBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.4, TextColor3 = ACCENT}):Play()
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
					dropList.Size = UDim2.new(0, 165, 0, 0)
					TweenService:Create(dropList, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 165, 0, totalHeight)}):Play()
					TweenService:Create(arrow, TweenInfo.new(0.25), {Rotation = 180}):Play()
					trackConn = RunService.RenderStepped:Connect(function()
						if isDropOpen and dropList.Visible then
							syncDropPos()
						end
					end)
				else
					TweenService:Create(dropList, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 165, 0, 0)}):Play()
					TweenService:Create(arrow, TweenInfo.new(0.25), {Rotation = 0}):Play()
					task.delay(0.26, function() dropList.Visible = false end)
					if trackConn then trackConn:Disconnect() trackConn = nil end
				end
			end)
		end

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

			local useIcon    = cfg.UseIcon or false
			local iconVal    = cfg.Icon or ""
			local titleText  = cfg.Title or "Notify"
			local bodyText   = cfg.Text or ""
			local barColor   = ACCENT
			local startDelay = cfg.StartedNotify or 0
			local duration   = cfg.EndedNotify or 4

			task.wait(startDelay)

			local notifGui = Instance.new("ScreenGui")
			notifGui.Name = "SeseNotif_" .. tostring(os.clock())
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
					iconImg.Image = Icons.GetIcon(tostring(iconVal))
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

	return Window
end

return SeseLib
