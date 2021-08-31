local DefaultSettings = {
	UIColorSettings = {
		["ColorGradient1"] = {0,0.43674468994140625,1},
		["ColorGradient2"] = {0.07463932037353515625,0,1},
		["GradientTwoEnabled"] = true,
		["FasterLoading"] = false,
	},
}

local options = _G.options or 
{
    topcolor = Color3.fromRGB(35, 35, 35),
    textcolor = Color3.fromRGB(255, 255, 255),
    AccentColor = Color3.fromRGB(200, 0, 200),
    togglekey = Enum.KeyCode.RightShift,
    titlefont = Enum.Font.SourceSansSemibold,
    font = Enum.Font.SourceSansSemibold,
}

local GradientTwoEnabled = DefaultSettings["UIColorSettings"]["GradientTwoEnabled"]
local grad1 = DefaultSettings["UIColorSettings"]["ColorGradient1"]
local grad2 = DefaultSettings["UIColorSettings"]["ColorGradient2"]
local ColorGradient1 = Color3.fromRGB(41, 84, 255)
local ColorGradient2 = Color3.fromRGB(41, 112, 255)

local uiGradients = {}
local toggleInnerCircles = {}
local toggleOuterCircles = {}
local sliderLines = {}
local sliderDots = {}

local library = {}
local tabs = {}
local oldPositions = {}
local canaction = true
local isopen = true

local TweenService = game:GetService("TweenService")
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local mouse = game:GetService("Players").LocalPlayer:GetMouse()
local HttpService = game:GetService("HttpService")

local Design1 = Instance.new("ScreenGui")
Design1.Name = HttpService:GenerateGUID(false)
Design1.Parent = game:GetService("CoreGui")
library.mainUI = Design1



local function Resize (part,new,_delay)
	_delay = _delay or 0.5
	local tweenInfo = TweenInfo.new(_delay, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tween = TweenService:Create(part, tweenInfo, new)
	tween:Play()
end

function makeImage()
	local id = 'rbxassetid://1084963972'
	local id2 = 'rbxassetid://867619398'
	
	local randoms = {
		0,
		90,
		180,
		-90
	}
	
	local image = Instance.new("ImageLabel", Design1)
	image.Size = UDim2.new(0, 20, 0, 20)
	image.AnchorPoint = Vector2.new(0.5, 0.5)
	image.Position = UDim2.new(0, mouse.X, 0, mouse.Y)
	image.Image = id
	image.Rotation = randoms[math.random(#randoms)]
	image.BackgroundTransparency = 1
	image.ImageColor3 = Color3.fromRGB(255, 255, 255)
	image.ZIndex = 100000
	image.Name = HttpService:GenerateGUID(false)
	
	local image2 = image:Clone()
	image2.Parent = image.Parent
	image2.Image = id2
	
	Resize(image, {ImageTransparency = 1, Size = UDim2.new(0, 100, 0, 100)}, 0.3)
	Resize(image2, {ImageTransparency = 1, Size = UDim2.new(0, 100, 0, 100)}, 0.3)
end

local function CreateDrag (gui)
    local UserInputService = game:GetService("UserInputService")
    local dragging
    local dragInput
    local dragStart
	local startPos
	
    local function update(input)
		local delta = input.Position - dragStart
		Resize(gui, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}, 0.16)
	end
	
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
	end)
	
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
	end)
	
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

uis.InputBegan:connect(function(inputobj, gameProcessed) 
	if inputobj.UserInputType == Enum.UserInputType.Keyboard and not gameProcessed then
		if inputobj.KeyCode == options.togglekey then 
			if not canaction then
				return
			end
			if isopen then
				canaction = false
				for index,tab in next, tabs do
					oldPositions[index] = tab.Position
					Resize(tab,{Position = UDim2.new(-1, 0, -1, 0)})
				end
				spawn(function() wait(0.5) canaction = true end)
			else
				canaction = false
				for index,tab in next, tabs do
					Resize(tab,{Position = oldPositions[index]})
				end
				spawn(function() wait(0.5) canaction = true end)
			end
			isopen = not isopen
		end
	end
end)

local function CreateTop(text, list, size, pos)
	text = text or "New tab"
	local part = Instance.new("Frame", Design1)
	
	if pos then
		part.Position = pos
    else
        part.Position = UDim2.new(0, #tabs == 0 and 200 or tabs[#tabs].Position.X.Offset + 250, 0, 50)
    end

	if size then
		part.Size = size
	else
		part.Size = UDim2.new(0, 225, 0, 25)
	end
	part.BackgroundColor3 = options.topcolor
	part.Draggable = true
	part.ZIndex = 3
	part.Name = HttpService:GenerateGUID(false)

	local label = Instance.new("TextLabel", part)
	label.Size = part.Size
	label.BackgroundTransparency = 1
	label.TextSize = 19
	label.TextStrokeTransparency = 1
	label.TextXAlignment = Enum.TextXAlignment.Center
	label.Font = options.titlefont
	label.TextColor3 = options.textcolor
	label.ZIndex = part.ZIndex
	label.Text = tostring(text)
	label.Name = HttpService:GenerateGUID(false)
	CreateDrag(part)
	if not list then
		table.insert(tabs, part)
	end

	local underline = Instance.new("Frame", part)
	underline.BorderSizePixel = 0
	underline.Size = UDim2.new(1, 2, 0, 2)
	underline.Position = UDim2.new(0, -1, 1.1, -3)
	underline.ZIndex = part.ZIndex
	underline.Name = HttpService:GenerateGUID(false)

	local UIGradient = Instance.new("UIGradient")
	UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, ColorGradient1), ColorSequenceKeypoint.new(1, ColorGradient2)}
	UIGradient.Parent = underline
	UIGradient.Name = HttpService:GenerateGUID(false)

	table.insert(uiGradients, UIGradient)

	return part
end

function library:CreateTab(name, list, size, pos)
	name = name or "New tab"
	local pixelspacing = 38
	local elements = {}
	local PhaseOneInstances = {}
	
	local CurrentTabCode = HttpService:GenerateGUID(false)
	
	
	
	local part = Instance.new("Frame")
	part.Name = HttpService:GenerateGUID(false)
	part.Parent = Design1
	
	
	
	if pos then
		part.Position = pos
    else
        part.Position = UDim2.new(0, #tabs == 0 and 100 or tabs[#tabs].Position.X.Offset + 215, 0, 50)
    end

	if size then
		part.Size = size
	else
		part.Size = UDim2.new(0, 225/1.15, 0, 28/1.15)
	end
	
	
	
	part.BackgroundColor3 = options.topcolor
	part.Draggable = true
	part.ZIndex = #tabs == 0 and 3 or (#tabs * 3) + 3
	part.Name = HttpService:GenerateGUID(false)

	local label = Instance.new("TextLabel", part)
	label.Size = part.Size
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.BackgroundTransparency = 1
	label.TextSize = 19
	label.TextStrokeTransparency = 1
	label.Font = options.titlefont
	label.TextColor3 = options.textcolor
	label.ZIndex = part.ZIndex
	label.Text = "    " .. tostring(name)
	label.Name = HttpService:GenerateGUID(false)
	CreateDrag(part)
	
	if not list then
		table.insert(tabs, part)
	end

	local underline = Instance.new("Frame", part)
	underline.BorderSizePixel = 0
	underline.Size = UDim2.new(1, 2, 0, 2)
	underline.Position = UDim2.new(0, -1, 1.1, -3)
	underline.ZIndex = part.ZIndex
	underline.Name = HttpService:GenerateGUID(false)

	local UIGradient = Instance.new("UIGradient")
	UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, ColorGradient1), ColorSequenceKeypoint.new(1, ColorGradient2)}
	UIGradient.Parent = underline
	UIGradient.Name = HttpService:GenerateGUID(false)

	table.insert(uiGradients, UIGradient)
	
	local body = Instance.new("Frame", part)
	body.Size = UDim2.new(1, 0, 0, 0)
	body.ZIndex = part.ZIndex - 1
	body.AnchorPoint = Vector2.new(0.5,0)
	body.Position = UDim2.new(0.5, 0, 6, -141)
	body.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	body.BorderSizePixel = 0
	body.BorderColor3 = Color3.fromRGB(40, 40, 40)
	body.ClipsDescendants = false
	body.BackgroundTransparency = 0
	body.Name = HttpService:GenerateGUID(false)

	local UIGradient_2 = Instance.new("UIGradient")
	UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(130, 130, 130)), ColorSequenceKeypoint.new(1, Color3.fromRGB(245, 245, 245))}
	UIGradient_2.Parent = body
	UIGradient_2.Name = HttpService:GenerateGUID(false)
	UIGradient_2.Rotation = 45

	table.insert(uiGradients, UIGradient)

	local bodyelements = Instance.new("Frame", body)
	bodyelements.ZIndex = part.ZIndex - 1
	bodyelements.Size = body.Size + UDim2.new(0, 0, 0, 1000)
	bodyelements.BackgroundTransparency = 1
	bodyelements.Name = HttpService:GenerateGUID(false)

	local UIGradient_2 = Instance.new("UIGradient")
	UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(130, 130, 130)), ColorSequenceKeypoint.new(1, Color3.fromRGB(245, 245, 245))}
	UIGradient_2.Parent = bodyelements
	UIGradient_2.Name = HttpService:GenerateGUID(false)
	table.insert(uiGradients, UIGradient)
	
	
	
	local function CreateBackground (color)
		local background = Instance.new("Frame", body)
		background.Name = HttpService:GenerateGUID(false)
		local function CreateSection (pos)
			local section = Instance.new("ImageLabel", background)
			
			section.BackgroundColor3 = Color3.new(1, 1, 1)
			section.Position = pos
			section.Size = UDim2.new(0, 200, 0, 200)
			section.BackgroundTransparency = 1
			section.Image = "https://www.roblox.com/Thumbs/Asset.ashx?width=420&height=420&assetId=4000222087"
			section.ImageColor3 = color
			section.Name = HttpService:GenerateGUID(false)
		end

		for x = 0, 2 do 
			for i = 0, 5 do 
				CreateSection(UDim2.new(0, 197 * x, 0, i * 200 - (i * 3)))
			end
		end
	end
	
	local actionbutton = Instance.new("ImageButton", part)
	actionbutton.BackgroundTransparency = 1
	actionbutton.Size = UDim2.new(0, 21, 0, 21)
	actionbutton.AnchorPoint = Vector2.new(0,0.5)
	actionbutton.Position = UDim2.new(1, -30, 0.5, 0)
	actionbutton.ZIndex = part.ZIndex
	actionbutton.Image = 'rbxassetid://244221613'
	actionbutton.ImageTransparency = 1
	actionbutton.Name = HttpService:GenerateGUID(false)

	local OPImg = Instance.new("ImageLabel", actionbutton)
	OPImg.BackgroundTransparency = 1
	OPImg.Size = UDim2.new(0, 0, 1, 0)
	OPImg.Position = UDim2.new(0.5, 0, 0, 0)
	OPImg.ZIndex = actionbutton.ZIndex + 1
	OPImg.Image = 'rbxassetid://52756150'
	OPImg.Name = HttpService:GenerateGUID(false)

	local CLImg = Instance.new("ImageLabel", actionbutton)
	CLImg.BackgroundTransparency = 1
	CLImg.Size = UDim2.new(1, 0, 1, 0)
	CLImg.Position = UDim2.new(0, 0, 0, 0)
	CLImg.ZIndex = actionbutton.ZIndex + 1
	CLImg.Image = 'rbxassetid://52756189'
	CLImg.Name = HttpService:GenerateGUID(false)
	
	
	
	local function Close()
		body.ClipsDescendants = true
        Resize(body,{Size = UDim2.new(1.01, 0, 0, 0), Position = UDim2.new(0.5, 0, 6, -141)})
        
        Resize(OPImg, {Size = UDim2.new(1.01, 0, 1.01, 0), Position = UDim2.new(0, 0, 0, 0)}, 0.25)
	end

	local function Open()
		body.ClipsDescendants = true
        Resize(body, {Size = UDim2.new(1.01, 0, 0, pixelspacing * #PhaseOneInstances + 16), Position = UDim2.new(0.5, 0, (pixelspacing / 1000) * #PhaseOneInstances + 0.85, -6)})
        
		Resize(OPImg, {Size = UDim2.new(1.01, 0, 0, 0), Position = UDim2.new(0, 0, 0.5, 0)}, 0.25)
		spawn(function()
			wait(0.3)
			body.ClipsDescendants = false
		end)
	end

	local open = true
	actionbutton.MouseButton1Click:connect(function()
		open = not open
		local func = open and Open or Close
		func()
	end)
	
	

	function elements:CreateSection(text)
		text = text or "New button"
		local SectionElements = {}
		local SectionTabs = {}
		local fakeTabs = {}
		
		local CurrentSectionCode = HttpService:GenerateGUID(false)
		
		local button = Instance.new("TextButton", bodyelements)

		button.Size = UDim2.new(0, 215/1.15, 0, 32.5/1.15)
		button.AnchorPoint = Vector2.new(0.5,0)
		button.Position = UDim2.new(0.5, 0, (pixelspacing / 990) * #PhaseOneInstances + 0.0155, 0)
		button.BackgroundTransparency = 0
        button.BorderSizePixel = 1
        button.BorderColor3 = Color3.fromRGB(60, 60, 60)
		button.TextColor3 = Color3.new(1, 1, 1)
		button.TextSize = 15
		button.TextXAlignment = Enum.TextXAlignment.Left
		button.Font = options.font
		button.Text = "    "
		button.ZIndex = bodyelements.ZIndex
        button.AutoButtonColor = false
		button.Active = true
		button.Name = HttpService:GenerateGUID(false)
		
		local buttonText = Instance.new("TextLabel", button)
		buttonText.Name = HttpService:GenerateGUID(false)
		buttonText.BackgroundTransparency = 1
		buttonText.Size = UDim2.new(1,0,1,0)
		buttonText.AnchorPoint = Vector2.new(0.5,0.5)
		buttonText.Position = UDim2.new(0.5,0,0.5,0)
		buttonText.ZIndex = bodyelements.ZIndex
		buttonText.Text = "    " .. tostring(text)
		buttonText.TextColor3 = Color3.new(1, 1, 1)
		buttonText.TextSize = 15
		buttonText.TextXAlignment = Enum.TextXAlignment.Left
		buttonText.Font = options.font
		
		local UIGradient = Instance.new("UIGradient")
		UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, ColorGradient1), ColorSequenceKeypoint.new(1, ColorGradient2)}
		UIGradient.Parent = button
		UIGradient.Name = HttpService:GenerateGUID(false)
		table.insert(uiGradients, UIGradient)
		
		local actionbutton = Instance.new("ImageButton", button)
		actionbutton.BackgroundTransparency = 1
		actionbutton.Size = UDim2.new(0, 30, 0, 30)
		actionbutton.AnchorPoint = Vector2.new(0.5,0.5)
		actionbutton.Position = UDim2.new(0.9, 0, 0.5, 0)
		actionbutton.ZIndex = button.ZIndex
		actionbutton.Image = 'rbxassetid://244221613'
		actionbutton.ImageTransparency = 1
		actionbutton.Name = HttpService:GenerateGUID(false)
	
		local OPImg = Instance.new("ImageButton", actionbutton)
		OPImg.BackgroundTransparency = 1
		OPImg.Size = UDim2.new(1, 0, 1, 0)
		OPImg.Position = UDim2.new(0, 0, 0, 0)
		OPImg.ZIndex = actionbutton.ZIndex + 1
		OPImg.Image = 'rbxassetid://3192533593'
		OPImg.Name = HttpService:GenerateGUID(false)
		OPImg.Rotation = 180
		
		local SecBodyelements = Instance.new("Frame", button)
		SecBodyelements.ZIndex = button.ZIndex
		SecBodyelements.Size = UDim2.new(body.Size.X.Scale, body.Size.X.Offset, 0, 0)--body.Size + UDim2.new(0, 0, 0, 1000)
		SecBodyelements.AnchorPoint = Vector2.new(0.5, 0)
		SecBodyelements.Position = UDim2.new(0.5,0,1,5)
		
		SecBodyelements.BackgroundTransparency = 0
		
		SecBodyelements.ClipsDescendants = true
		SecBodyelements.BackgroundColor3 = Color3.fromRGB(112, 112, 112)
		SecBodyelements.Name = CurrentTabCode
		SecBodyelements.BackgroundTransparency = 0
        SecBodyelements.BorderSizePixel = 2
		SecBodyelements.BorderColor3 = Color3.fromRGB(40, 40, 40)
		SecBodyelements.Visible = false
		
		local UIGradient = Instance.new("UIGradient")
		UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, ColorGradient1), ColorSequenceKeypoint.new(1, ColorGradient2)}
		UIGradient.Parent = SecBodyelements
		UIGradient.Rotation = 45
		UIGradient.Name = HttpService:GenerateGUID(false)
		table.insert(uiGradients, UIGradient)
		
		local toggleCoolD = false
		local function CloseSec()
			for i,v in pairs(fakeTabs) do
				for x,y in pairs(PhaseOneInstances) do
					if v == y then
						table.remove(PhaseOneInstances, x)
						v:Destroy()
						print(i)
					end
				end
			end
			
			TweenService:Create(OPImg,TweenInfo.new(0.35),{Rotation = 180}):Play()
			
			Resize(SecBodyelements, {Size = UDim2.new(body.Size.X.Scale, body.Size.X.Offset, 0, 0)})
			
			Open()
			
			for i,v in pairs(PhaseOneInstances) do 
				if v.Position.Y.Scale > button.Position.Y.Scale or v.Position.Y.Offset > button.Position.Y.Offset then
					Resize(v, {Position = UDim2.new(v.Position.X.Scale, v.Position.X.Offset, v.Position.Y.Scale, v.Position.Y.Offset - pixelspacing * #SectionTabs)})
				end
			end
			
			wait(0.25)
			SecBodyelements.Visible = false
			
		end
	
		local function OpenSec()
			SecBodyelements.Visible = true
			
			for i = 1, #SectionTabs do
				local s = Instance.new("Frame")
				s.Name = CurrentSectionCode
				s.Parent = nil
				table.insert(fakeTabs, s)
				table.insert(PhaseOneInstances, s)
			end
			TweenService:Create(OPImg,TweenInfo.new(0.35),{Rotation = 0}):Play()
			
			Resize(SecBodyelements, {Size = UDim2.new(body.Size.X.Scale, body.Size.X.Offset, 0, pixelspacing * #SectionTabs - 4)})
			Open()
			
			for i,v in pairs(PhaseOneInstances) do 
				if v.Position.Y.Scale > button.Position.Y.Scale or v.Position.Y.Offset > button.Position.Y.Offset then
					Resize(v, {Position = UDim2.new(v.Position.X.Scale, v.Position.X.Offset, v.Position.Y.Scale, v.Position.Y.Offset + pixelspacing * #SectionTabs)})
				end
			end
			
		end
		
		local function shine(duration)
            button.ClipsDescendants = true
            local sFrame = Instance.new("ImageLabel", button)
            sFrame.Active = true
            sFrame.Image = "rbxassetid://2954823376"
            sFrame.Size = UDim2.new(0, 200, 0, 200)
            sFrame.Position = UDim2.new(0, -100, -1.5, 0)
            sFrame.AnchorPoint = Vector2.new(0.5, 0.5)
            sFrame.ZIndex = button.ZIndex
            sFrame.BorderSizePixel = 0
            sFrame.BackgroundTransparency = 1
            sFrame.ImageTransparency = 1
			sFrame.BackgroundColor3 = Color3.new(255, 255, 255)
			sFrame.Name = HttpService:GenerateGUID(false)
            Resize(sFrame, {ImageTransparency = 0.35}, 0.5)
            sFrame:TweenPosition(UDim2.new(1, 50, 3, 0), "Out", "Quad", duration)

            spawn(function()
                wait(duration + 0.5)
				button.ClipsDescendants = false
                sFrame:Destroy()
            end)
        end

		local openSec = false
		local function buttonPress()
			if not toggleCoolD then
				toggleCoolD = true
				spawn(function()
					wait(0.5)
					toggleCoolD = false
				end)
	            makeImage()
				openSec = not openSec
				local func = openSec and OpenSec or CloseSec
				func()
			end
		end
		OPImg.MouseButton1Click:connect(buttonPress)
		button.MouseButton1Click:connect(buttonPress)

		table.insert(PhaseOneInstances, button)

		Open()
		
		
		function SectionElements:AddSwitch(text, callback)
			local switchactions = {}
			text = text or "New switch"
			callback = callback or function() end
			
			local switch = Instance.new("TextButton", SecBodyelements)
			table.insert(SectionTabs, switch)
			
			switch.Size = UDim2.new(0, 205, 0, 32.5)
			switch.AnchorPoint = Vector2.new(0.5,0)
			switch.Position = UDim2.new(0.5, 0, ((pixelspacing - 3) / 700) * #SectionTabs, 28 * (#SectionTabs - 1))
			switch.BackgroundTransparency = 0
			switch.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			switch.BorderSizePixel = 1
			switch.BorderColor3 = Color3.fromRGB(60, 60, 60)
			switch.TextColor3 = Color3.new(1, 1, 1)
			switch.TextSize = 15
			switch.TextXAlignment = Enum.TextXAlignment.Left
			switch.Font = options.font
			switch.Text = "    "
	        switch.ZIndex = SecBodyelements.ZIndex
			switch.AutoButtonColor = false
			switch.Name = HttpService:GenerateGUID(false)
			
			local buttonText = Instance.new("TextLabel", switch)
			buttonText.Name = HttpService:GenerateGUID(false)
			buttonText.BackgroundTransparency = 1
			buttonText.Size = UDim2.new(1,0,1,0)
			buttonText.AnchorPoint = Vector2.new(0.5,0.5)
			buttonText.Position = UDim2.new(0.5,0,0.5,0)
			buttonText.ZIndex = bodyelements.ZIndex
			buttonText.Text = "    " .. tostring(text)
			buttonText.TextColor3 = Color3.new(1, 1, 1)
			buttonText.TextSize = 15
			buttonText.TextXAlignment = Enum.TextXAlignment.Left
			buttonText.Font = options.font
			
			local UIGradient = Instance.new("UIGradient")
			UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, ColorGradient1), ColorSequenceKeypoint.new(1, ColorGradient2)}
			UIGradient.Parent = switch
			UIGradient.Name = HttpService:GenerateGUID(false)
			table.insert(uiGradients, UIGradient)
	
			local enabled = false
			local OuterCircle = Instance.new("ImageLabel", switch)
			OuterCircle.AnchorPoint = Vector2.new(0, 0.5)
			OuterCircle.Size = UDim2.new(0, 20, 0, 20)
			OuterCircle.Position = UDim2.new(1, -30, 0.5, 0)
			OuterCircle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			OuterCircle.BorderSizePixel = 0
			OuterCircle.ZIndex = switch.ZIndex + 2
			OuterCircle.ImageTransparency = 0
			OuterCircle.BackgroundTransparency = 1
			OuterCircle.Image = 'rbxassetid://2012883770'
			OuterCircle.ImageColor3 = Color3.fromRGB(150, 150, 150)
			OuterCircle.ScaleType = "Stretch"
			OuterCircle.SliceScale = 1
			OuterCircle.Name = HttpService:GenerateGUID(false)
	
	        local InnerCircle = Instance.new("ImageLabel", OuterCircle)
	        InnerCircle.Size = UDim2.new(0, 0, 0, 0)
	        InnerCircle.AnchorPoint = Vector2.new(0.5, 0.5)
			InnerCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
			InnerCircle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			InnerCircle.BorderSizePixel = 0
			InnerCircle.ZIndex = switch.ZIndex + 3
			InnerCircle.ImageTransparency = 0
			InnerCircle.BackgroundTransparency = 1
			InnerCircle.Image = 'rbxassetid://517259585'
			InnerCircle.ImageColor3 = Color3.fromRGB(150, 150, 150)
			InnerCircle.ScaleType = "Stretch"
			InnerCircle.SliceScale = 1
			InnerCircle.Name = HttpService:GenerateGUID(false)
	
	        local Frame = Instance.new("ImageLabel", OuterCircle)
	        Frame.ClipsDescendants = true
	        Frame.BackgroundTransparency = 1
	        Frame.BorderSizePixel = 0
	        Frame.ZIndex = switch.ZIndex + 1
	        Frame.Size = UDim2.new(1, 5, 1, 5)
	        Frame.AnchorPoint = Vector2.new(0.5, 0.5)
	        Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	        Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	        Frame.Image = "rbxassetid://200182847"
			Frame.ImageTransparency = 1
			Frame.Name = HttpService:GenerateGUID(false)
	
	        switch.MouseEnter:Connect(function()
	            Frame.ImageTransparency = .9
	        end)
	        switch.MouseLeave:Connect(function()
	            Frame.ImageTransparency = 1
	        end)
	
			local function Trigger(state)
				enabled = state or not enabled
				local ac = options.AccentColor
	
				if enabled then
	                Resize(OuterCircle, {ImageColor3 = Color3.fromRGB(255, 255, 255)}, .2)
	                Resize(InnerCircle, {Size = UDim2.new(1, -14.5, 1, -14.5), ImageColor3 = Color3.fromRGB(255, 255, 255)}, .2)
				else
	                Resize(OuterCircle, {ImageColor3 = Color3.fromRGB(150,150,150)}, .2)
	                Resize(InnerCircle, {Size = UDim2.new(0, 0, 0, 0), ImageColor3 = Color3.fromRGB(150,150,150)}, .2)
				end
	
				pcall(callback, enabled)
			end
	
			switch.MouseButton1Click:connect(Trigger)
	
			function switchactions:Set(state)
				Trigger(state)
				pcall(callback, enabled)
			end
	
			Open()
			return switchactions
		end
		
		function SectionElements:AddButton(text, callback)
			text = text or "New button"
			callback = callback or function() end
	
			local button = Instance.new("TextButton", SecBodyelements)
			table.insert(SectionTabs, button)
	
			button.Size = UDim2.new(0, 205, 0, 32.5)
			button.AnchorPoint = Vector2.new(0.5,0)
			button.Position = UDim2.new(0.5, 0, ((pixelspacing - 3) / 700) * #SectionTabs, 28 * (#SectionTabs - 1))
			button.BackgroundTransparency = 0
			button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	        button.BorderSizePixel = 1
	        button.BorderColor3 = Color3.fromRGB(60, 60, 60)
			button.TextColor3 = Color3.new(1, 1, 1)
			button.TextSize = 15
			button.TextXAlignment = Enum.TextXAlignment.Left
			button.Font = options.font
			button.Text = "    " .. tostring(text)
			button.ZIndex = SecBodyelements.ZIndex
	        button.AutoButtonColor = false
	        button.ClipsDescendants = true
			button.Active = true
			button.Name = HttpService:GenerateGUID(false)
			
			local buttonText = Instance.new("TextLabel", button)
			buttonText.Name = HttpService:GenerateGUID(false)
			buttonText.BackgroundTransparency = 1
			buttonText.Size = UDim2.new(1,0,1,0)
			buttonText.AnchorPoint = Vector2.new(0.5,0.5)
			buttonText.Position = UDim2.new(0.5,0,0.5,0)
			buttonText.ZIndex = bodyelements.ZIndex
			buttonText.Text = "    " .. tostring(text)
			buttonText.TextColor3 = Color3.new(1, 1, 1)
			buttonText.TextSize = 15
			buttonText.TextXAlignment = Enum.TextXAlignment.Left
			buttonText.Font = options.font
			
			local UIGradient = Instance.new("UIGradient")
			UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, ColorGradient1), ColorSequenceKeypoint.new(1, ColorGradient2)}
			UIGradient.Parent = button 
			UIGradient.Name = HttpService:GenerateGUID(false)
			table.insert(uiGradients, UIGradient)
			
			local actionbutton = Instance.new("ImageButton", button)
			actionbutton.BackgroundTransparency = 1
			actionbutton.Size = UDim2.new(0, 24, 0, 24)
			actionbutton.AnchorPoint = Vector2.new(0.5,0.5)
			actionbutton.Position = UDim2.new(0.9, 0, 0.5, 0)
			actionbutton.ZIndex = button.ZIndex
			actionbutton.Image = 'rbxassetid://5044249458'
			actionbutton.ImageTransparency = 1
			actionbutton.Name = HttpService:GenerateGUID(false)
		
			local OPImg = Instance.new("ImageButton", actionbutton)
			OPImg.BackgroundTransparency = 1
			OPImg.Size = UDim2.new(1, 0, 1, 0)
			OPImg.Position = UDim2.new(0, 0, 0, 0)
			OPImg.ZIndex = actionbutton.ZIndex + 1
			OPImg.Image = 'rbxassetid://5044275451'
			OPImg.Name = HttpService:GenerateGUID(false)
	        
	        local function shine(duration)
	            button.ClipsDescendants = true
	            local sFrame = Instance.new("ImageLabel", button)
	            sFrame.Active = true
	            sFrame.Image = "rbxassetid://2954823376"
	            sFrame.Size = UDim2.new(0, 200, 0, 200)
	            sFrame.Position = UDim2.new(0, -100, -1.5, 0)
	            sFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	            sFrame.ZIndex = button.ZIndex
	            sFrame.BorderSizePixel = 0
	            sFrame.BackgroundTransparency = 1
	            sFrame.ImageTransparency = 1
				sFrame.BackgroundColor3 = Color3.new(255, 255, 255)
				sFrame.Name = HttpService:GenerateGUID(false)
	            Resize(sFrame, {ImageTransparency = 0.35}, 0.5)
	            sFrame:TweenPosition(UDim2.new(1, 50, 3, 0), "Out", "Quad", duration)
	
	            spawn(function()
	                wait(duration + 0.5)
	                sFrame:Destroy()
	            end)
	        end
	
			local function onClick()
	            makeImage()
	            shine(0.75)
				pcall(callback)
			end
			
			OPImg.MouseButton1Click:connect(onClick)
			button.MouseButton1Click:connect(onClick)
			
			Open()
		end
		
		function SectionElements:AddSlider(text, minvalue, maxvalue, callback)
			local slideractions = {}
			text = text or "New slider"
			minvalue = minvalue or 0
			maxvalue = maxvalue or 100
			callback = callback or function() end
	
			local box = Instance.new("TextLabel", SecBodyelements)
			table.insert(SectionTabs, box)
	
			box.Size = UDim2.new(0, 205, 0, 32.5)
			box.AnchorPoint = Vector2.new(0.5,0)
			box.Position = UDim2.new(0.5, 0, ((pixelspacing - 3) / 700) * #SectionTabs, 28 * (#SectionTabs - 1))
			box.BackgroundTransparency = 0
			box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	        box.BorderSizePixel = 1
	        box.BorderColor3 = Color3.fromRGB(60, 60, 60)
			box.TextColor3 = Color3.new(1, 1, 1)
			box.TextSize = 15
			box.TextXAlignment = Enum.TextXAlignment.Left
			box.Font = options.font
			box.Text = ""
			box.ZIndex = SecBodyelements.ZIndex
			box.Name = HttpService:GenerateGUID(false)
			
			local UIGradient = Instance.new("UIGradient")
			UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, ColorGradient1), ColorSequenceKeypoint.new(1, ColorGradient2)}
			UIGradient.Parent = box
			UIGradient.Name = HttpService:GenerateGUID(false)
			table.insert(uiGradients, UIGradient)
			
			local UpperSlideValue = Instance.new("TextLabel")
			UpperSlideValue.Name = HttpService:GenerateGUID(false)
			UpperSlideValue.Parent = box
			UpperSlideValue.AnchorPoint = Vector2.new(0.5, 0.5)
			UpperSlideValue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			UpperSlideValue.BackgroundTransparency = 1.000
			UpperSlideValue.Position = UDim2.new(0.5, 0, 0.5, 0)
			UpperSlideValue.Size = UDim2.new(1, -7, 1, -1)
			UpperSlideValue.ZIndex = box.ZIndex + 1
			UpperSlideValue.Font = options.font
			UpperSlideValue.Text = tostring(minvalue)
			UpperSlideValue.TextColor3 = Color3.fromRGB(150, 150, 150)
			UpperSlideValue.TextSize = 14
			UpperSlideValue.TextXAlignment = Enum.TextXAlignment.Right
			UpperSlideValue.TextYAlignment = Enum.TextYAlignment.Top
			
			local UpperSlideText = Instance.new("TextLabel")
			UpperSlideText.Name = HttpService:GenerateGUID(false)
			UpperSlideText.Parent = box
			UpperSlideText.AnchorPoint = Vector2.new(0.5, 0.5)
			UpperSlideText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			UpperSlideText.BackgroundTransparency = 1.000
			UpperSlideText.Position = UDim2.new(0.5, 0, 0.5, 0)
			UpperSlideText.Size = UDim2.new(1, -7, 1, -1)
			UpperSlideText.ZIndex = box.ZIndex
			UpperSlideText.Font = options.font
			UpperSlideText.Text = tostring(text)
			UpperSlideText.TextColor3 = Color3.fromRGB(150, 150, 150)
			UpperSlideText.TextSize = 14
			UpperSlideText.TextXAlignment = Enum.TextXAlignment.Left
			UpperSlideText.TextYAlignment = Enum.TextYAlignment.Top
			
	
			local Slider = Instance.new("Frame")
			local Point = Instance.new("ImageLabel")
			local MouseOn = Instance.new("ImageLabel")
			local MouseDown = Instance.new("ImageLabel")
			local ValIcon = Instance.new("ImageLabel")
			local ValText = Instance.new("TextLabel")
			local Back = Instance.new("Frame")
			local MouseButton = Instance.new("TextButton")
			
			Slider.Name = HttpService:GenerateGUID(false)
			Slider.Parent = box
			Slider.BackgroundColor3 = Color3.fromRGB(125, 125, 125)
			Slider.BorderSizePixel = 0
			Slider.Size = UDim2.new(0, 160, 0, 2)
			Slider.ZIndex = box.ZIndex
			Slider.AnchorPoint = Vector2.new(0.5,0.5)
			Slider.Position = UDim2.new(0.5, 0, 0.5, 7)
			
			Point.Name = HttpService:GenerateGUID(false)
			Point.Parent = Slider
			Point.AnchorPoint = Vector2.new(0.5, 0.5)
			Point.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Point.BackgroundTransparency = 1.000
			Point.Position = UDim2.new(0, 0, 0.5, 0)
			Point.Size = UDim2.new(0, 12, 0, 12)
			Point.ZIndex = box.ZIndex + 1
			Point.Image = "rbxassetid://1217158727"
			Point.ImageColor3 = Color3.fromRGB(255, 255, 255)
			
			MouseOn.Name = HttpService:GenerateGUID(false)
			MouseOn.Parent = Point
			MouseOn.AnchorPoint = Vector2.new(0.5, 0.5)
			MouseOn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			MouseOn.BackgroundTransparency = 1.000
			MouseOn.Position = UDim2.new(0.5, 0, 0.5, 0)
			MouseOn.ZIndex = box.ZIndex + 1
			MouseOn.Image = "rbxassetid://1217158727"
			MouseOn.ImageColor3 = Color3.fromRGB(255, 255, 255)
			MouseOn.ImageTransparency = 0.850
			
			MouseDown.Name = HttpService:GenerateGUID(false)
			MouseDown.Parent = Point
			MouseDown.AnchorPoint = Vector2.new(0.5, 0.5)
			MouseDown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			MouseDown.BackgroundTransparency = 1.000
			MouseDown.Position = UDim2.new(0.5, 0, 0.5, 0)
			MouseDown.ZIndex = box.ZIndex + 1
			MouseDown.Image = "rbxassetid://1217158727"
			MouseDown.ImageColor3 = Color3.fromRGB(255, 255, 255)
			MouseDown.ImageTransparency = 0.850
			
			ValIcon.Name = HttpService:GenerateGUID(false)
			ValIcon.Parent = Point
			ValIcon.AnchorPoint = Vector2.new(0.5, 1)
			ValIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ValIcon.BackgroundTransparency = 1.000
			ValIcon.BorderSizePixel = 0
			ValIcon.ClipsDescendants = true
			ValIcon.Position = UDim2.new(0.5, 0, 0, 2)
			ValIcon.ZIndex = box.ZIndex + 1
			ValIcon.Image = "http://www.roblox.com/asset/?id=5047851106"
			ValIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
			
			ValText.Name = HttpService:GenerateGUID(false)
			ValText.Parent = ValIcon
			ValText.AnchorPoint = Vector2.new(0.5, 0.5)
			ValText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ValText.BackgroundTransparency = 1.000
			ValText.Position = UDim2.new(0.5, 0, 0.5, 0)
			ValText.Size = UDim2.new(0.800000012, 0, 0, 28)
			ValText.ZIndex = box.ZIndex + 1
			ValText.Font = Enum.Font.SourceSans
			ValText.Text = "1"
			ValText.TextColor3 = Color3.fromRGB(0, 170, 210)
			ValText.TextSize = 14
			
			Back.Name = HttpService:GenerateGUID(false)
			Back.Parent = Slider
			Back.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Back.BorderSizePixel = 0
			Back.Size = UDim2.new(0, 0, 1, 0)
			Back.ZIndex = box.ZIndex
			
			MouseButton.Name = HttpService:GenerateGUID(false)
			MouseButton.Parent = Slider
			MouseButton.AnchorPoint = Vector2.new(0, 0.5)
			MouseButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			MouseButton.BackgroundTransparency = 1.000
			MouseButton.BorderSizePixel = 0
			MouseButton.Position = UDim2.new(0, 0, 0.5, 0)
			MouseButton.Size = UDim2.new(1, 0, 1, 10)
			MouseButton.Font = Enum.Font.SourceSans
			MouseButton.Text = ""
			MouseButton.TextColor3 = Color3.fromRGB(0, 0, 0)
			MouseButton.TextSize = 14
			MouseButton.TextTransparency = 1
			
			local MouseisOn = false
			local MouseisDown = false
			local Value = 0
			local Max = 100
			local IntOnly = true 
			local ValueLabelMultiply = 1
			local ValueLabel = true
			
			MouseButton.MouseEnter:Connect(function()
				MouseisOn = true
				MouseOn:TweenSize(UDim2.new(2, 0, 2, 0),Enum.EasingDirection.Out,Enum.EasingStyle.Linear,0.12,true,nil)
			end)
			
			MouseButton.MouseLeave:Connect(function()
				MouseisOn = false
				if MouseisDown == false then
					MouseOn:TweenSize(UDim2.new(0,0,0,0),Enum.EasingDirection.Out,Enum.EasingStyle.Linear,0.12,true,nil)
				end
			end)
			
			local UserInputService = game:GetService("UserInputService")
			local RunService = game:GetService("RunService")
			
			local Connection;
			UserInputService.InputEnded:Connect(function(input)
			    if input.UserInputType == Enum.UserInputType.MouseButton1 then
			        if(Connection) then
						ValIcon:TweenSize(UDim2.new(0, 0, 0, 0),Enum.EasingDirection.Out,Enum.EasingStyle.Linear,0.12,true,nil)
			            Connection:Disconnect();
			            Connection = nil;
			        end;
			    end;
			end);
			
			MouseButton.MouseButton1Down:Connect(function()
			    if(Connection) then
			        Connection:Disconnect();
			    end;
			
			    Connection = RunService.Heartbeat:Connect(function()
			        local mouse = UserInputService:GetMouseLocation();
			        local percent = math.clamp((mouse.X - MouseButton.AbsolutePosition.X) / (MouseButton.AbsoluteSize.X), 0, 1);
			        local Value = minvalue + (maxvalue - minvalue) * percent;
					
					ValIcon:TweenSize(UDim2.new(0, 28,0, 40),Enum.EasingDirection.Out,Enum.EasingStyle.Linear,0.12,true,nil)
						
					if MouseisOn == false then
						MouseOn:TweenSize(UDim2.new(0,0,0,0),Enum.EasingDirection.Out,Enum.EasingStyle.Linear,0.12,true,nil)
					end
					
					local NewValue = percent * 100
					Point:TweenPosition(UDim2.new(NewValue/Max,0,0.5,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.1,true,nil)
					Back:TweenSize(UDim2.new(NewValue/Max,0,1,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.1,true,nil)
			
			        Value = tonumber(string.format("%.2f", math.floor(Value)));
			
					ValText.Text = Value
					UpperSlideValue.Text = tostring(Value)
					
			    end);
			end);
			
			function slideractions:Set(val)
				local NewValue = ((val-minvalue)/(maxvalue-minvalue)) * 100
				Point:TweenPosition(UDim2.new(NewValue/Max,0,0.5,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.1,true,nil)
				Back:TweenSize(UDim2.new(NewValue/Max,0,1,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.1,true,nil)
		
				ValText.Text = val
				UpperSlideValue.Text = tostring(val)
			end
	
			return slideractions
		end
		
		return SectionElements
	end
	
	function elements:AddButton(text, callback)
		text = text or "New button"
		callback = callback or function() end

		local button = Instance.new("TextButton", bodyelements)

		button.Size = UDim2.new(0, 215/1.15, 0, 32.5/1.15)
		button.AnchorPoint = Vector2.new(0.5,0)
		button.Position = UDim2.new(0.5, 0, (pixelspacing / 990) * #PhaseOneInstances + 0.0155, 0)
		button.BackgroundTransparency = 0
		button.BackgroundColor3 = Color3.fromRGB(160, 160, 160)
        button.BorderSizePixel = 3
		button.BorderMode = Enum.BorderMode.Inset
        button.BorderColor3 = Color3.fromRGB(160, 160, 160)
		button.TextColor3 = Color3.new(1, 1, 1)
		button.TextSize = 15
		button.TextXAlignment = Enum.TextXAlignment.Left
		button.Font = options.font
		button.Text = "    " --.. tostring(text)
		button.ZIndex = bodyelements.ZIndex
        button.AutoButtonColor = false
        button.ClipsDescendants = true
		button.Active = true
		button.Name = HttpService:GenerateGUID(false)
		
		local buttonText = Instance.new("TextLabel", button)
		buttonText.Name = HttpService:GenerateGUID(false)
		buttonText.BackgroundTransparency = 1
		buttonText.Size = UDim2.new(1,0,1,0)
		buttonText.AnchorPoint = Vector2.new(0.5,0.5)
		buttonText.Position = UDim2.new(0.5,0,0.5,0)
		buttonText.ZIndex = bodyelements.ZIndex
		buttonText.Text = "    " .. tostring(text)
		buttonText.TextColor3 = Color3.new(1, 1, 1)
		buttonText.TextSize = 15
		buttonText.TextXAlignment = Enum.TextXAlignment.Left
		buttonText.Font = options.font
		
		local UIGradient = Instance.new("UIGradient")
		UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, ColorGradient1), ColorSequenceKeypoint.new(1, ColorGradient2)}
		UIGradient.Parent = button
		UIGradient.Name = HttpService:GenerateGUID(false)
		table.insert(uiGradients, UIGradient)
		
		local actionbutton = Instance.new("ImageButton", button)
		actionbutton.BackgroundTransparency = 1
		actionbutton.Size = UDim2.new(0, 24, 0, 24)
		actionbutton.AnchorPoint = Vector2.new(0.5,0.5)
		actionbutton.Position = UDim2.new(0.9, 0, 0.5, 0)
		actionbutton.ZIndex = button.ZIndex
		actionbutton.Image = 'rbxassetid://5044249458'
		actionbutton.ImageTransparency = 1
		actionbutton.Name = HttpService:GenerateGUID(false)
	
		local OPImg = Instance.new("ImageButton", actionbutton)
		OPImg.BackgroundTransparency = 1
		OPImg.Size = UDim2.new(1, 0, 1, 0)
		OPImg.Position = UDim2.new(0, 0, 0, 0)
		OPImg.ZIndex = actionbutton.ZIndex + 1
		OPImg.Image = 'rbxassetid://5044275451'
		OPImg.Name = HttpService:GenerateGUID(false)
        
        local function shine(duration)
            button.ClipsDescendants = true
            local sFrame = Instance.new("ImageLabel", button)
            sFrame.Active = true
            sFrame.Image = "rbxassetid://2954823376"
            sFrame.Size = UDim2.new(0, 200, 0, 200)
            sFrame.Position = UDim2.new(0, -100, -1.5, 0)
            sFrame.AnchorPoint = Vector2.new(0.5, 0.5)
            sFrame.ZIndex = button.ZIndex
            sFrame.BorderSizePixel = 0
            sFrame.BackgroundTransparency = 1
            sFrame.ImageTransparency = 1
			sFrame.BackgroundColor3 = Color3.new(255, 255, 255)
			sFrame.Name = HttpService:GenerateGUID(false)
            Resize(sFrame, {ImageTransparency = 0.35}, 0.5)
            sFrame:TweenPosition(UDim2.new(1, 50, 3, 0), "Out", "Quad", duration)

            spawn(function()
                wait(duration + 0.5)
                sFrame:Destroy()
            end)
        end

		local function onClick()
            makeImage()
            shine(0.75)
			pcall(callback)
		end

		OPImg.MouseButton1Click:connect(onClick)

		button.MouseButton1Click:connect(onClick)

		table.insert(PhaseOneInstances, button)

		Open()
	end
	local openColors = {}
	function elements:AddColor(text, presetColor, callback)
		text = text or "New color"
		callback = callback or function() end

		local hueSatDragging = false;
		local valueDragging = false;
		local button = Instance.new("TextButton", bodyelements)
		local statusFrame = Instance.new("Frame", button);
		local colorPickingFrame = Instance.new("Frame", button);
		local hueSatFrame = Instance.new("ImageLabel", colorPickingFrame);
		local hueSatIndicatorFrame = Instance.new("ImageLabel", hueSatFrame);
		local valueFrame = Instance.new("ImageLabel", colorPickingFrame);
		local valueIndicatorFrame = Instance.new("ImageLabel", valueFrame);

		button.Size = UDim2.new(0, 215/1.15, 0, 32.5/1.15)
		button.AnchorPoint = Vector2.new(0.5,0)
		button.Position = UDim2.new(0.5, 0, (pixelspacing / 990) * #PhaseOneInstances + 0.0155, 0)
		button.BackgroundTransparency = 0
		button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		button.BorderSizePixel = 1
		button.BorderColor3 = Color3.fromRGB(60, 60, 60)
		button.TextColor3 = Color3.new(1, 1, 1)
		button.TextSize = 15
		button.TextXAlignment = Enum.TextXAlignment.Left
		button.Font = options.font
		button.Text = "    " --.. tostring(text)
        button.AutoButtonColor = false
        button.ClipsDescendants = false
		button.Active = true
		button.Name = HttpService:GenerateGUID(false)
		button.ZIndex = bodyelements.ZIndex

		local buttonText = Instance.new("TextLabel", button)
		buttonText.Name = HttpService:GenerateGUID(false)
		buttonText.BackgroundTransparency = 1
		buttonText.Size = UDim2.new(1,0,1,0)
		buttonText.AnchorPoint = Vector2.new(0.5,0.5)
		buttonText.Position = UDim2.new(0.5,0,0.5,0)
		buttonText.ZIndex = button.ZIndex + 1
		buttonText.Text = "    " .. tostring(text)
		buttonText.TextColor3 = Color3.new(1, 1, 1)
		buttonText.TextSize = 15
		buttonText.TextXAlignment = Enum.TextXAlignment.Left
		buttonText.Font = options.font
		
		statusFrame.Name = HttpService:GenerateGUID(false)
		statusFrame.AnchorPoint = Vector2.new(1, 0);
		statusFrame.BackgroundColor3 = presetColor or Color3.fromRGB(255, 255, 255);
		statusFrame.BorderSizePixel = 0;
		statusFrame.Position = UDim2.new(1, 0, 0, 0);
		statusFrame.Size = UDim2.new(0.223, 0, 1, 0);

		local ColorBoxButton = Instance.new("ImageLabel", button)
		ColorBoxButton.AnchorPoint = Vector2.new(0, 0.5)
		ColorBoxButton.Size = UDim2.new(0, 20, 0, 20)
		ColorBoxButton.Position = UDim2.new(1, -30, 0.5, 0)
		ColorBoxButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		ColorBoxButton.BorderSizePixel = 0
		ColorBoxButton.ZIndex = button.ZIndex + 2
		ColorBoxButton.ImageTransparency = 0
		ColorBoxButton.BackgroundTransparency = 1
		ColorBoxButton.Image = 'rbxassetid://3574700605'
		ColorBoxButton.ImageColor3 = presetColor
		ColorBoxButton.ScaleType = "Stretch"
		ColorBoxButton.SliceScale = 1
		ColorBoxButton.Name = HttpService:GenerateGUID(false)
		
		colorPickingFrame.Name = HttpService:GenerateGUID(false)
		colorPickingFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40);
		colorPickingFrame.BorderSizePixel = 1
		colorPickingFrame.BorderColor3 = Color3.fromRGB(60, 60, 60)
		colorPickingFrame.Position = UDim2.new(0, 0, 1, 0);
		colorPickingFrame.Size = UDim2.new(1, 0, 0, 0);
		colorPickingFrame.Visible = false;
		colorPickingFrame.ZIndex = button.ZIndex;
		
		hueSatFrame.Name = HttpService:GenerateGUID(false)
		hueSatFrame.BackgroundTransparency = 1;
		hueSatFrame.BorderSizePixel = 0;
		hueSatFrame.ClipsDescendants = true;
		hueSatFrame.Position = UDim2.new(0.03, 0, 0.057, 0);
		hueSatFrame.Size = UDim2.new(0.764, 0, 0.886, 0);
		hueSatFrame.Image = "rbxassetid://4018903152";
		hueSatFrame.ZIndex = button.ZIndex;
		
		hueSatIndicatorFrame.Name = HttpService:GenerateGUID(false)
		hueSatIndicatorFrame.AnchorPoint = Vector2.new(0.5, 0.5);
		hueSatIndicatorFrame.BackgroundTransparency = 1;
		hueSatIndicatorFrame.BorderSizePixel = 0;
		hueSatIndicatorFrame.Position = UDim2.new(presetColor and select(1, Color3.toHSV(presetColor)) or 0, 0, presetColor and 1 - select(2, Color3.toHSV(presetColor)) or 0, 0);
		hueSatIndicatorFrame.Size = UDim2.new(0.146, 0, 0.2, 0);
		hueSatIndicatorFrame.Image = "rbxassetid://4019495410";
		hueSatIndicatorFrame.ImageColor3 = Color3.fromRGB(0, 0, 0);
		hueSatIndicatorFrame.ScaleType = Enum.ScaleType.Crop;
		hueSatIndicatorFrame.ZIndex = button.ZIndex;
		
		valueFrame.Name = HttpService:GenerateGUID(false)
		valueFrame.AnchorPoint = Vector2.new(1, 0)
		valueFrame.BackgroundTransparency = 1
		valueFrame.BorderSizePixel = 0;
		valueFrame.Position = UDim2.new(0.981, 0, 0.057, 0);
		valueFrame.Size = UDim2.new(0.157, 0, 0.886, 0);
		valueFrame.Image = "rbxassetid://4019265005";
		valueFrame.ImageColor3 = presetColor and Color3.fromHSV(Color3.toHSV(presetColor)) or Color3.fromRGB(255, 255, 255);
		valueFrame.ScaleType = Enum.ScaleType.Crop;
		valueFrame.ZIndex = button.ZIndex;
		
		valueIndicatorFrame.Name = HttpService:GenerateGUID(false)
		valueIndicatorFrame.AnchorPoint = Vector2.new(0, 0.5);
		valueIndicatorFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		valueIndicatorFrame.BackgroundTransparency = 1
		valueIndicatorFrame.BorderColor3 = Color3.fromRGB(0, 0, 0);
		valueIndicatorFrame.BorderSizePixel = 0;
		valueIndicatorFrame.Position = UDim2.new(-0.6, 0, presetColor and 1 - select(3, Color3.toHSV(presetColor)) or 0, 0);
		valueIndicatorFrame.Size = UDim2.new(0, 25, 0, 25);
		valueIndicatorFrame.Image = "rbxassetid://71659683";
		valueIndicatorFrame.ImageColor3 = Color3.fromRGB(255,255,255)
		valueIndicatorFrame.ZIndex = button.ZIndex;

		openColors[button.Name] = function()
			spawn(function()
				button.ZIndex = bodyelements.ZIndex
				valueIndicatorFrame.ZIndex = button.ZIndex;
				valueFrame.ZIndex = button.ZIndex;
				hueSatIndicatorFrame.ZIndex = button.ZIndex;
				hueSatFrame.ZIndex = button.ZIndex;
				colorPickingFrame.ZIndex = button.ZIndex;
				ColorBoxButton.ZIndex = button.ZIndex + 2
				buttonText.ZIndex = button.ZIndex
				colorPickingFrame:TweenSize(UDim2.new(1, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true);
				wait(0.15);
				colorPickingFrame.Visible = false;
			end)
		end

		button.MouseButton1Click:Connect(function()
			if not colorPickingFrame.Visible then
				for i,v in pairs(openColors) do
					if i ~= button.Name then
						warn(i,v)
						v()
					end
				end
				button.ZIndex = 20
				valueIndicatorFrame.ZIndex = button.ZIndex;
				valueFrame.ZIndex = button.ZIndex;
				hueSatIndicatorFrame.ZIndex = button.ZIndex;
				hueSatFrame.ZIndex = button.ZIndex;
				colorPickingFrame.ZIndex = button.ZIndex;
				ColorBoxButton.ZIndex = button.ZIndex + 2
				colorPickingFrame.Visible = true;
				buttonText.ZIndex = button.ZIndex
				colorPickingFrame:TweenSize(UDim2.new(1, 0, 5, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true);
			elseif colorPickingFrame.Visible then
				button.ZIndex = bodyelements.ZIndex
				valueIndicatorFrame.ZIndex = button.ZIndex;
				valueFrame.ZIndex = button.ZIndex;
				hueSatIndicatorFrame.ZIndex = button.ZIndex;
				hueSatFrame.ZIndex = button.ZIndex;
				colorPickingFrame.ZIndex = button.ZIndex;
				ColorBoxButton.ZIndex = button.ZIndex + 2
				buttonText.ZIndex = button.ZIndex
				colorPickingFrame:TweenSize(UDim2.new(1, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true);
				wait(0.15);
				colorPickingFrame.Visible = false;
			end;
		end);
		
		hueSatFrame.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				hueSatDragging = true;
			end;
		end);
		
		hueSatFrame.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				hueSatDragging = false;
			end;
		end);

		valueFrame.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				valueDragging = true;
			end;
		end)
		
		valueFrame.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				valueDragging = false;
			end;
		end);
		
		game:GetService("UserInputService").InputChanged:Connect(function(input)
			if hueSatDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
				hueSatIndicatorFrame.Position = UDim2.new(math.clamp((input.Position.X - hueSatFrame.AbsolutePosition.X) / hueSatFrame.AbsoluteSize.X, 0, 1), 0, math.clamp((input.Position.Y - hueSatFrame.AbsolutePosition.Y) / hueSatFrame.AbsoluteSize.Y, 0, 1), 0);
				statusFrame.BackgroundColor3 = Color3.fromHSV(hueSatIndicatorFrame.Position.X.Scale, 1 - hueSatIndicatorFrame.Position.Y.Scale, 1 - valueIndicatorFrame.Position.Y.Scale);
				valueFrame.ImageColor3 = Color3.fromHSV(hueSatIndicatorFrame.Position.X.Scale, 1 - hueSatIndicatorFrame.Position.Y.Scale, 1);
				ColorBoxButton.ImageColor3 = statusFrame.BackgroundColor3
				callback(statusFrame.BackgroundColor3);

			elseif valueDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
				valueIndicatorFrame.Position = UDim2.new(-0.6, 0, math.clamp((input.Position.Y - valueFrame.AbsolutePosition.Y) / valueFrame.AbsoluteSize.Y, 0, 1), 0);
				statusFrame.BackgroundColor3 = Color3.fromHSV(hueSatIndicatorFrame.Position.X.Scale, 1 - hueSatIndicatorFrame.Position.Y.Scale, 1 - valueIndicatorFrame.Position.Y.Scale);
				valueFrame.ImageColor3 = Color3.fromHSV(hueSatIndicatorFrame.Position.X.Scale, 1 - hueSatIndicatorFrame.Position.Y.Scale, 1);
				ColorBoxButton.ImageColor3 = statusFrame.BackgroundColor3
				callback(statusFrame.BackgroundColor3);

			end;
		end);

		table.insert(PhaseOneInstances, button)
		callback(statusFrame.BackgroundColor3);

		Open()
	end
	
	function elements:AddSwitch(text, callback)
		local switchactions = {}
		text = text or "New switch"
		callback = callback or function() end
		
		local switch = Instance.new("TextButton", bodyelements)
		switch.Size = UDim2.new(0, 215/1.15, 0, 32.5/1.15)
		switch.AnchorPoint = Vector2.new(0.5,0)
		switch.Position = UDim2.new(0.5, 0, (pixelspacing / 990) * #PhaseOneInstances + 0.0155, 0)
		switch.BackgroundTransparency = 0
		switch.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		switch.BorderSizePixel = 1
		switch.BorderColor3 = Color3.fromRGB(60, 60, 60)
		switch.TextColor3 = Color3.new(1, 1, 1)
		switch.TextSize = 15
		switch.TextXAlignment = Enum.TextXAlignment.Left
		switch.Font = options.font
		switch.Text = "    " .. tostring(text)
        switch.ZIndex = bodyelements.ZIndex
		switch.AutoButtonColor = false
		switch.Name = HttpService:GenerateGUID(false)

		local enabled = false
		local OuterCircle = Instance.new("ImageLabel", switch)
		OuterCircle.AnchorPoint = Vector2.new(0, 0.5)
		OuterCircle.Size = UDim2.new(0, 20, 0, 20)
		OuterCircle.Position = UDim2.new(1, -30, 0.5, 0)
		OuterCircle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		OuterCircle.BorderSizePixel = 0
		OuterCircle.ZIndex = switch.ZIndex + 2
		OuterCircle.ImageTransparency = 0
		OuterCircle.BackgroundTransparency = 1
		OuterCircle.Image = 'rbxassetid://2012883770'
		OuterCircle.ImageColor3 = Color3.fromRGB(150, 150, 150)
		OuterCircle.ScaleType = "Stretch"
		OuterCircle.SliceScale = 1
		OuterCircle.Name = HttpService:GenerateGUID(false)
		toggleOuterCircles[OuterCircle] = enabled

        local InnerCircle = Instance.new("ImageLabel", OuterCircle)
        InnerCircle.Size = UDim2.new(0, 0, 0, 0)
        InnerCircle.AnchorPoint = Vector2.new(0.5, 0.5)
		InnerCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
		InnerCircle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		InnerCircle.BorderSizePixel = 0
		InnerCircle.ZIndex = switch.ZIndex + 3
		InnerCircle.ImageTransparency = 0
		InnerCircle.BackgroundTransparency = 1
		InnerCircle.Image = 'rbxassetid://517259585'
		InnerCircle.ImageColor3 = Color3.fromRGB(150, 150, 150)
		InnerCircle.ScaleType = "Stretch"
		InnerCircle.SliceScale = 1
		InnerCircle.Name = HttpService:GenerateGUID(false)
		toggleInnerCircles[InnerCircle] = enabled

        local Frame = Instance.new("ImageLabel", OuterCircle)
        Frame.ClipsDescendants = true
        Frame.BackgroundTransparency = 1
        Frame.BorderSizePixel = 0
        Frame.ZIndex = switch.ZIndex + 1
        Frame.Size = UDim2.new(1, 5, 1, 5)
        Frame.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
        Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Frame.Image = "rbxassetid://200182847"
		Frame.ImageTransparency = 1
		Frame.Name = HttpService:GenerateGUID(false)

        switch.MouseEnter:Connect(function()
            Frame.ImageTransparency = .9
        end)
        switch.MouseLeave:Connect(function()
            Frame.ImageTransparency = 1
        end)

		local function Trigger(state)
			if state == nil then 
				enabled = not enabled
			else 
				enabled = state 
			end
			local ac = options.AccentColor
			toggleOuterCircles[OuterCircle] = enabled
			toggleInnerCircles[InnerCircle] = enabled

			if enabled then
                Resize(OuterCircle, {ImageColor3 = ColorGradient1}, .2)
                Resize(InnerCircle, {Size = UDim2.new(1, -14.5, 1, -14.5), ImageColor3 = ColorGradient1}, .2)
			else
                Resize(OuterCircle, {ImageColor3 = Color3.fromRGB(150,150,150)}, .2)
                Resize(InnerCircle, {Size = UDim2.new(0, 0, 0, 0), ImageColor3 = Color3.fromRGB(150,150,150)}, .2)
			end
			pcall(callback, enabled)
		end

		switch.MouseButton1Click:connect(Trigger)

		function switchactions:Set(state)
			Trigger(state)
		end

		table.insert(PhaseOneInstances, switch)

		Open()

		return switchactions
	end
	
	function elements:NewList(name, text)
		text = text or "Empty List"
		
		local Top = CreateTop(name, true)

		local button = Instance.new("TextLabel", Top)
		
		local minHeight = 10
		
		button.Position = UDim2.new(0, 0, 0, 27)
		button.BackgroundTransparency = 0
		button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		button.BorderSizePixel = 0
		button.TextColor3 = Color3.new(1, 1, 1)
		button.TextSize = 20
		button.TextXAlignment = Enum.TextXAlignment.Left
		button.Font = options.font
		button.Text = tostring(text)
		button.TextXAlignment = Enum.TextXAlignment.Center
		button.Name = HttpService:GenerateGUID(false)
		
		button.Size = UDim2.new(0, 225, 0, math.max(minHeight, button.TextBounds.Y) )
		
		return Top
	end
	
	function elements:NewLogWindow(text)
		local actions = {}
		text = text or "New Window"
		
		local Top = CreateTop(text, true, UDim2.new(0, 600, 0, 25), UDim2.new(.65, 0, .6, 0))
		local body = Instance.new("ScrollingFrame", Top)
		
		body.Position = UDim2.new(0, 0, 0, 0)
		body.Size = UDim2.new(1, 0, 0, 300)
		body.BackgroundTransparency = 0
		body.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		body.BorderSizePixel = 0
		body.ClipsDescendants = true
		body.Name = HttpService:GenerateGUID(false)

		local VelTxt = Instance.new("TextLabel",Top)
		VelTxt.ZIndex = Top.ZIndex + 1
		VelTxt.Text = "Vel Earned: "
		VelTxt.BackgroundTransparency = 1
		VelTxt.TextColor3 = Color3.fromRGB(210, 210, 0)
		VelTxt.Position = UDim2.new(0,60,0.5,0)
		VelTxt.TextSize = 20
		VelTxt.Font = options.font
		VelTxt.Name = HttpService:GenerateGUID(false)

		function actions:Log(text, color3, image)
			local log = Instance.new("TextLabel")
			log.Parent = body
			log.Text = text or ""
			log.Size = UDim2.new(1, 0, 0, 35)
			log.TextColor3 = color3 or Color3.new(1,1,1)
			log.BackgroundTransparency = 1
			log.TextSize = 20
			log.TextXAlignment = Enum.TextXAlignment.Center
			log.Position = UDim2.new(0,0,0, (30 * #body:GetChildren()))
			log.Font = options.font
			log.Name = HttpService:GenerateGUID(false)
			body.CanvasSize = UDim2.new(0, 0, 0, #body:GetChildren() * 30)
		end

		local actionbutton = Instance.new("ImageButton", Top)
		actionbutton.BackgroundTransparency = 1
		actionbutton.Size = UDim2.new(0, 25, 0, 25)
		actionbutton.Position = UDim2.new(0.93, 0, 0, 0)
		actionbutton.ZIndex = Top.ZIndex
		actionbutton.Image = 'rbxassetid://244221613'
		actionbutton.ImageTransparency = 1
		actionbutton.Name = HttpService:GenerateGUID(false)

		local OPImg = Instance.new("ImageLabel", actionbutton)
		OPImg.BackgroundTransparency = 1
		OPImg.Size = UDim2.new(0, 0, 1, 0)
		OPImg.Position = UDim2.new(0.5, 0, 0, 0)
		OPImg.ZIndex = actionbutton.ZIndex + 1
		OPImg.Image = 'rbxassetid://52756150'
		OPImg.Name = HttpService:GenerateGUID(false)

		local CLImg = Instance.new("ImageLabel", actionbutton)
		CLImg.BackgroundTransparency = 1
		CLImg.Size = UDim2.new(1, 0, 1, 0)
		CLImg.Position = UDim2.new(0, 0, 0, 0)
		CLImg.ZIndex = actionbutton.ZIndex + 1
		CLImg.Image = 'rbxassetid://52756189'
		CLImg.Name = HttpService:GenerateGUID(false)

		local function Close ()
			Resize(body,{Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 6, -132.5)})
			
			Resize(OPImg, {Size = UDim2.new(1.05, 0, 1.05, 0), Position = UDim2.new(0, 0, 0, 0)}, 0.25)
		end

		local function Open ()
			Resize(body, {Size = UDim2.new(1, 0, 0, 300), Position = UDim2.new(0,0,0,0)})
			
			Resize(OPImg, {Size = UDim2.new(1.05, 0, 0, 0), Position = UDim2.new(0, 0, 0.5, 0)}, 0.25)
		end

		local open = true
		actionbutton.MouseButton1Click:connect(function()
			open = not open
			local func = open and Open or Close
			func()
		end)

		function actions:SetVel(num)
			VelTxt.Text = "Vel Earned: "..num
		end

		return actions

	end
	
	function elements:AddDrop(text, list, callback)
		local switchactions = {}
		text = text or "New Dropdown"
		callback = callback or function() end

		local DropDownOutlinedTextBox = Instance.new("TextBox")
		local Bar = Instance.new("Frame")
		local ErrorText = Instance.new("TextLabel")
		local UIPadding = Instance.new("UIPadding")
		local TopBarL = Instance.new("Frame")
		local TopBarR = Instance.new("Frame")
		local RBar = Instance.new("Frame")
		local LBar = Instance.new("Frame")
		local TextHit = Instance.new("TextLabel")
		local back = Instance.new("TextLabel")
		local TextSize = Instance.new("TextLabel")
		local DropDown = Instance.new("ImageLabel")
		local Holder = Instance.new("Frame")
		local UIListLayout = Instance.new("UIGridLayout")
		local UIPadding_2 = Instance.new("UIPadding")
		local Icon = Instance.new("ImageLabel")
		
		DropDownOutlinedTextBox.Name = HttpService:GenerateGUID(false)
		DropDownOutlinedTextBox.Parent = bodyelements
		DropDownOutlinedTextBox.Size = UDim2.new(0, 215/1.15, 0, 32.5/1.15)
		DropDownOutlinedTextBox.AnchorPoint = Vector2.new(0.5,0)
		DropDownOutlinedTextBox.Position = UDim2.new(0.5, 0, (pixelspacing / 990) * #PhaseOneInstances + 0.0155, 0)
		DropDownOutlinedTextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		DropDownOutlinedTextBox.BackgroundTransparency = 1
		DropDownOutlinedTextBox.ZIndex = bodyelements.ZIndex
		DropDownOutlinedTextBox.ClearTextOnFocus = false
		DropDownOutlinedTextBox.Font = Enum.Font.SourceSans
		DropDownOutlinedTextBox.PlaceholderColor3 = Color3.fromRGB(156, 156, 156)
		DropDownOutlinedTextBox.PlaceholderText = text
		DropDownOutlinedTextBox.Text = ""
		DropDownOutlinedTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
		DropDownOutlinedTextBox.TextSize = 15.000
		DropDownOutlinedTextBox.TextXAlignment = Enum.TextXAlignment.Left
		
		Bar.Name = HttpService:GenerateGUID(false)
		Bar.Parent = DropDownOutlinedTextBox
		Bar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		Bar.BorderSizePixel = 0
		Bar.Position = UDim2.new(0, -6, 1, 0)
		Bar.Selectable = true
		Bar.Size = UDim2.new(1, 12, 0, 2)
		Bar.ZIndex = DropDownOutlinedTextBox.ZIndex
		
		ErrorText.Name = HttpService:GenerateGUID(false)
		ErrorText.Parent = DropDownOutlinedTextBox
		ErrorText.AnchorPoint = Vector2.new(1, 0)
		ErrorText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ErrorText.BackgroundTransparency = 1.000
		ErrorText.BorderSizePixel = 0
		ErrorText.Position = UDim2.new(1, 6, 1, 0)
		ErrorText.Size = UDim2.new(1, -4, 0, 18)
		ErrorText.Visible = false
		ErrorText.Font = Enum.Font.SourceSans
		ErrorText.Text = "Error"
		ErrorText.TextColor3 = Color3.fromRGB(255, 33, 33)
		ErrorText.TextSize = 14.000
		ErrorText.TextStrokeColor3 = Color3.fromRGB(255, 33, 33)
		ErrorText.TextStrokeTransparency = 0.940
		ErrorText.TextXAlignment = Enum.TextXAlignment.Left
		ErrorText.ZIndex = DropDownOutlinedTextBox.ZIndex
		
		UIPadding.Parent = DropDownOutlinedTextBox
		UIPadding.PaddingLeft = UDim.new(0, 6)
		UIPadding.PaddingRight = UDim.new(0, 6)
		
		TopBarL.Name = HttpService:GenerateGUID(false)
		TopBarL.Parent = DropDownOutlinedTextBox
		TopBarL.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		TopBarL.BorderSizePixel = 0
		TopBarL.Position = UDim2.new(0, -6, 0, -2)
		TopBarL.Selectable = true
		TopBarL.Size = UDim2.new(0, 4, 0, 2)
		TopBarL.ZIndex = DropDownOutlinedTextBox.ZIndex
		
		TopBarR.Name = HttpService:GenerateGUID(false)
		TopBarR.Parent = DropDownOutlinedTextBox
		TopBarR.AnchorPoint = Vector2.new(1, 0)
		TopBarR.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		TopBarR.BorderSizePixel = 0
		TopBarR.Position = UDim2.new(1, 6, 0, -2)
		TopBarR.Selectable = true
		TopBarR.Size = UDim2.new(1, 8, 0, 2)
		TopBarR.ZIndex = DropDownOutlinedTextBox.ZIndex
		
		RBar.Name = HttpService:GenerateGUID(false)
		RBar.Parent = DropDownOutlinedTextBox
		RBar.AnchorPoint = Vector2.new(1, 0)
		RBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		RBar.BorderSizePixel = 0
		RBar.Position = UDim2.new(1, 7, 0, -1)
		RBar.Selectable = true
		RBar.Size = UDim2.new(0, 2, 1, 2)
		RBar.ZIndex = DropDownOutlinedTextBox.ZIndex
		
		LBar.Name = HttpService:GenerateGUID(false)
		LBar.Parent = DropDownOutlinedTextBox
		LBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		LBar.BorderSizePixel = 0
		LBar.Position = UDim2.new(0, -7, 0, -1)
		LBar.Selectable = true
		LBar.Size = UDim2.new(0, 2, 1, 2)
		LBar.ZIndex = DropDownOutlinedTextBox.ZIndex
		
		TextHit.Name = HttpService:GenerateGUID(false)
		TextHit.Parent = DropDownOutlinedTextBox
		TextHit.AnchorPoint = Vector2.new(0, 0.5)
		TextHit.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextHit.BackgroundTransparency = 1.000
		TextHit.Position = UDim2.new(0, 0, 0.5, 0)
		TextHit.Size = UDim2.new(1, 0, 1, 0)
		TextHit.ZIndex = DropDownOutlinedTextBox.ZIndex
		TextHit.Font = Enum.Font.SourceSans
		TextHit.TextColor3 = Color3.fromRGB(0, 0, 0)
		TextHit.TextSize = 14.000
		TextHit.TextXAlignment = Enum.TextXAlignment.Left
		
		back.Name = HttpService:GenerateGUID(false)
		back.Parent = TextHit
		back.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		back.BackgroundTransparency = 1.000
		back.Size = UDim2.new(1, 0, 1, 0)
		back.ZIndex = DropDownOutlinedTextBox.ZIndex
		back.Font = Enum.Font.SourceSans
		back.TextColor3 = Color3.fromRGB(0, 0, 0)
		back.TextSize = 14.000
		back.TextXAlignment = Enum.TextXAlignment.Left
		
		TextSize.Name = HttpService:GenerateGUID(false)
		TextSize.Parent = DropDownOutlinedTextBox
		TextSize.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextSize.BackgroundTransparency = 1.000
		TextSize.Size = UDim2.new(1, 0, 1, 0)
		TextSize.Visible = false
		TextSize.Font = Enum.Font.SourceSans
		TextSize.TextColor3 = Color3.fromRGB(0, 0, 0)
		TextSize.TextSize = 14.000
		TextSize.TextXAlignment = Enum.TextXAlignment.Left
		TextSize.ZIndex = DropDownOutlinedTextBox.ZIndex
		
		DropDown.Name = HttpService:GenerateGUID(false)
		DropDown.Parent = DropDownOutlinedTextBox
		DropDown.BackgroundColor3 = Color3.fromRGB(112, 112, 112)
		DropDown.BackgroundTransparency = 0
		DropDown.BorderSizePixel = 2
		DropDown.BorderColor3 = Color3.fromRGB(45,45,45)
		DropDown.AnchorPoint = Vector2.new(0.5,0)
		DropDown.Position = UDim2.new(0.5, 0, 1, 4)
		DropDown.Size = UDim2.new(1, 5, 0, 0)
		DropDown.Visible = false
		DropDown.ZIndex = DropDownOutlinedTextBox.ZIndex + 2
		--DropDown.Image = "rbxassetid://1935044829"
		DropDown.ImageTransparency = 1
		DropDown.ImageColor3 = Color3.fromRGB(112, 112, 112)
		DropDown.ScaleType = Enum.ScaleType.Slice
		DropDown.SliceCenter = Rect.new(8, 8, 248, 248)
		
		local UIGradient = Instance.new("UIGradient")
		UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, ColorGradient1), ColorSequenceKeypoint.new(1, ColorGradient2)}
		UIGradient.Parent = DropDown
		UIGradient.Name = HttpService:GenerateGUID(false)
		table.insert(uiGradients, UIGradient)
		
		Holder.Name = HttpService:GenerateGUID(false)
		Holder.Parent = DropDown
		Holder.BackgroundColor3 = Color3.fromRGB(112, 112, 112)
		Holder.BackgroundTransparency = 1.000
		Holder.BorderSizePixel = 0
		Holder.ClipsDescendants = true
		Holder.Size = UDim2.new(1, 0, 1, 0)
		Holder.ZIndex = DropDownOutlinedTextBox.ZIndex
		
		UIListLayout.Parent = Holder
		UIListLayout.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout.CellPadding = UDim2.new(0,0,0,4)
		UIListLayout.CellSize = UDim2.new(1,-8,0,32)
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout.StartCorner = Enum.StartCorner.TopLeft
		UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		
		UIPadding_2.Parent = Holder
		UIPadding_2.PaddingBottom = UDim.new(0, 4)
		UIPadding_2.PaddingTop = UDim.new(0, 4)
		
		Icon.Name = HttpService:GenerateGUID(false)
		Icon.Parent = DropDownOutlinedTextBox
		Icon.BackgroundTransparency = 1.000
		Icon.Position = UDim2.new(1, -13, 0.5, -2)
		Icon.Size = UDim2.new(0, 10, 0, 6)
		Icon.Image = "http://www.roblox.com/asset/?id=45732894"
		Icon.ImageColor3 = Color3.fromRGB(35, 35, 35)
		Icon.ZIndex = DropDownOutlinedTextBox.ZIndex
		
		
		local Color = ColorGradient1
		local DropButtons = {}
		local box = DropDownOutlinedTextBox
		local bar = Bar
		local round = Instance.new("Frame",bar)
		local TpBarR = TopBarR
		local TpBarL = TopBarL
		
		local BarR = RBar
		local BarL = LBar
		
		round.BorderSizePixel = 0
		round.AnchorPoint = Vector2.new(0,0)
		round.Position = UDim2.new(0,0,0,0)
		round.Size = UDim2.new(1,0,1,0)
		round.Name = HttpService:GenerateGUID(false)
		round.BackgroundColor3 = Color
		round.ZIndex = DropDownOutlinedTextBox.ZIndex
		round.BackgroundTransparency = 1
		
		local TopR_round = round:Clone()
		TopR_round.Parent = TpBarR
		
		local TopL_round = round:Clone()
		TopL_round.Parent = TpBarL
		
		local BarR_round = round:Clone()
		BarR_round.Parent = BarR
		
		local BarL_round = round:Clone()
		BarL_round.Parent = BarL
		
		local Hit = TextHit
		Hit.Parent = box
		Hit.TextScaled = true
		Hit.Text = text
		box.TextWrapped = true
		back.TextColor3 = Color
		back.TextColor3 = Color
		back.TextTransparency=1
		
		local TextSize = TextSize:Clone()
		TextSize.Parent = box
		
		local Foused = false
		local Hit_Foused = false
		local tarns_in = false
		local tarns_out = false
		local function box_Changed()
			if box.PlaceholderText ~= "" then
				Hit.Size = UDim2.new(0,box.TextBounds.X,1,0)
				Hit.TextSize = box.TextSize
				Hit.Text = box.PlaceholderText
				Hit.TextScaled = true
				Hit.TextColor3 = box.PlaceholderColor3
				TextSize.TextSize = box.TextSize
				TextSize.Text = box.PlaceholderText
				TextSize.TextColor3 = box.PlaceholderColor3
				back.TextSize = box.TextSize
				back.Text = box.PlaceholderText
				back.TextScaled = true
				back.TextColor3 = box.PlaceholderColor3
				back.Font = box.Font
				back.TextColor3 = Color
				wait()
				box.PlaceholderText = ""
			end
		end
		
		function Focused()
			Foused = true
			local Time = 0.3
			
			if Hit_Foused == false then
				Hit_Foused = true
				Hit:TweenSizeAndPosition(UDim2.new(0, TextSize.TextBounds.X-4, 0, TextSize.TextBounds.Y-4), UDim2.new(0, 0, 0, -2),Enum.EasingDirection.In,Enum.EasingStyle.Quad, Time, true, nil)
				TpBarR:TweenSize(UDim2.new(1, -(TextSize.TextBounds.X)+12,0,2),Enum.EasingDirection.In,Enum.EasingStyle.Quad, Time, true, nil)
			end
			tarns_out = false
			tarns_in = true
			local u = 10
			repeat wait(0.03)
				if back == nil then break end
				if back.TextTransparency < 0.01 then 
					tarns_in = false
				break end
				back.TextTransparency = back.TextTransparency-0.1
				back.TextScaled = true
				round.BackgroundTransparency = back.TextTransparency
				TopL_round.BackgroundTransparency = back.TextTransparency
				TopR_round.BackgroundTransparency = back.TextTransparency
				BarL_round.BackgroundTransparency = back.TextTransparency
				BarR_round.BackgroundTransparency = back.TextTransparency
			until back.TextTransparency < 0.01 or tarns_in == false
		end
		box.Focused:Connect(Focused)
		local function FocusLost()
			for i,v in pairs(DropButtons) do
				v.Visible = true
			end
				
			Foused = false
			local Time = 0.3
			
			if Hit_Foused == true and box.Text == "" then
				Hit_Foused = false
				Hit:TweenSizeAndPosition(UDim2.new(0, TextSize.TextBounds.X, 1, 0), UDim2.new(0, 0, 0.5, 0),Enum.EasingDirection.InOut,Enum.EasingStyle.Quad, Time, true, nil)
				TpBarR:TweenSize(UDim2.new(1, 8, 0, 2),Enum.EasingDirection.In,Enum.EasingStyle.Quad, Time-0.04, true, nil)
			--end
				tarns_in = false
				tarns_out = true
				local u = 10
				repeat wait(0.03)
					if back == nil then break end
					if back.TextTransparency > 0.9 then 
						tarns_out = false
					break end
					back.TextTransparency = back.TextTransparency+0.1
					back.TextScaled = true
					round.BackgroundTransparency = back.TextTransparency
					TopL_round.BackgroundTransparency = back.TextTransparency
					TopR_round.BackgroundTransparency = back.TextTransparency
					BarL_round.BackgroundTransparency = back.TextTransparency
					BarR_round.BackgroundTransparency = back.TextTransparency
				until back.TextTransparency > 0.9 or tarns_out == false
			end
		end
		
		box.FocusLost:Connect(FocusLost)
		box.Changed:Connect(box_Changed)
		
		
		
		local Main = DropDown
		local Padding = UIPadding
		local SizeXOffset = Main.Size.X.Offset
		local SizeXScale = Main.Size.X.Scale
		local Time = 300
		local MouseOn = false
		
		Main:GetPropertyChangedSignal("Size"):Connect(function()
			if Main.Size.Y.Offset == 0 then
				Main.Visible = false
			else
				Main.Visible = true
			end
		end)
		
		local TweenService = game:GetService("TweenService")
		local Inico = TweenService:Create(
			Icon,
			TweenInfo.new(
				Time / 1000, 
				Enum.EasingStyle.Quint, 
				Enum.EasingDirection.Out, 
				0,
				false,
				0
			),
			{ 
				Rotation = 180;
			}
		)
		local Outico = TweenService:Create(
			Icon,
			TweenInfo.new(
				Time / 1000,
				Enum.EasingStyle.Quint, 
				Enum.EasingDirection.Out, 
				0,
				false,
				0
			),
			{
				Rotation = 0;
			}
		)
		
		Main.MouseEnter:Connect(function()
			MouseOn = true
		end)
		Main.MouseLeave:Connect(function()
			MouseOn = false
		end)
		
		local function OpenBox()
			local childs = {}
			for i,v in pairs(Holder:GetChildren()) do
				if v:IsA("TextButton") and v.Visible == true then
					table.insert(childs, v)
				end
			end
			local AbsoluteContentSizeY = 38*(#childs)
			Main:TweenSize(UDim2.new(SizeXScale,SizeXOffset,0,AbsoluteContentSizeY+Padding.PaddingBottom.Offset+Padding.PaddingTop.Offset),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,Time / 1000,true,nil)
			Inico:Play()
		end
		
		local function CloseBox()
			local found = false
			for i,v in pairs(list) do
				if tostring(v) == tostring(box.Text) then
					found = true
				end	
			end
			if found == false then
				box.Text = ""
			else
				Focused()
			end
			Main:TweenSize(UDim2.new(SizeXScale,SizeXOffset,0,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,Time / 1000,true,nil)
			Outico:Play()
		end
		
		local save = box.Text
		box:GetPropertyChangedSignal("Text"):Connect(function()
			save = box.Text
			if Foused == false and box.Text == "" then
				Hit_Foused = false
				local Time = 0.3
				Hit:TweenSizeAndPosition(UDim2.new(0, TextSize.TextBounds.X, 1, 0), UDim2.new(0, 0, 0.5, 0),Enum.EasingDirection.InOut,Enum.EasingStyle.Quad, Time, true, nil)
				TpBarR:TweenSize(UDim2.new(1, 8, 0, 2),Enum.EasingDirection.In,Enum.EasingStyle.Quad, Time-0.04, true, nil)
			end
			if Foused == false and box.Text ~= "" then
				Hit_Foused = false
				local Time = 0.3
				Hit:TweenSizeAndPosition(UDim2.new(0, TextSize.TextBounds.X-4, 0, TextSize.TextBounds.Y-4), UDim2.new(0, 0, 0, -2),Enum.EasingDirection.In,Enum.EasingStyle.Quad, Time, true, nil)
				TpBarR:TweenSize(UDim2.new(1, -(TextSize.TextBounds.X)+12,0,2),Enum.EasingDirection.In,Enum.EasingStyle.Quad, Time, true, nil)
			end
			if Foused == true and box.Text ~= "" then
				for i,v in pairs(DropButtons) do
					if v.Text:lower():gsub(" ",""):find(box.Text:lower():gsub(" ","")) then
						v.Parent.Visible = true
					else
						v.Parent.Visible = false
					end
					OpenBox()
				end
			else
				for i,v in pairs(DropButtons) do
					v.Parent.Visible = true
				end
				OpenBox()
			end
		end)
		box_Changed()
		
		box.Focused:Connect(OpenBox)
		
		box.FocusLost:Connect(CloseBox)
		
		
		local function ListButton(name, callback)
			local TextButton = Instance.new("TextButton")
			
			TextButton.Name = HttpService:GenerateGUID(false)
			TextButton.Parent = Holder
			TextButton.BackgroundTransparency = 0
			TextButton.Size = UDim2.new(1, 0, 0, 32)
			TextButton.ZIndex = DropDownOutlinedTextBox.ZIndex + 4
			TextButton.Active = true
			TextButton.Text = "   "
			TextButton.Font = Enum.Font.SourceSans
			TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextButton.TextSize = 14.000
			TextButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			TextButton.TextXAlignment = Enum.TextXAlignment.Left
			TextButton.BorderSizePixel = 0
			
			local buttonText = Instance.new("TextLabel", TextButton)
			buttonText.Name = HttpService:GenerateGUID(false)
			buttonText.BackgroundTransparency = 1
			buttonText.Size = UDim2.new(1,0,1,0)
			buttonText.AnchorPoint = Vector2.new(0.5,0.5)
			buttonText.Position = UDim2.new(0.5,0,0.5,0)
			buttonText.ZIndex = TextButton.ZIndex
			buttonText.Text = "   "..name
			buttonText.TextColor3 = Color3.new(1, 1, 1)
			buttonText.TextSize = 15
			buttonText.TextXAlignment = Enum.TextXAlignment.Left
			buttonText.Font = options.font
			
			local UIGradient = Instance.new("UIGradient")
			UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, ColorGradient1), ColorSequenceKeypoint.new(1, ColorGradient2)}
			UIGradient.Parent = TextButton
			UIGradient.Name = HttpService:GenerateGUID(false)
			table.insert(uiGradients, UIGradient)
			
			table.insert(DropButtons, buttonText)
			
			local clck = function()
				spawn(function()
					pcall(callback, name) 
				end)
				box.Text = name
				CloseBox()
			end
			
			TextButton.MouseButton1Down:Connect(clck)
		end
		
		for i,v in pairs(list) do
			ListButton(v, callback)
		end
		
		table.insert(PhaseOneInstances, DropDownOutlinedTextBox)

		Open()

		return switchactions
	end

	function elements:NewHeader(text) 
		text = text or "New Label"
		local act = {}
		local button = Instance.new("TextLabel", bodyelements)
		button.Size = UDim2.new(0, 215/1.15, 0, 32.5/1.15)
		button.AnchorPoint = Vector2.new(0.5,0)
		button.Position = UDim2.new(0.5, 0, (pixelspacing / 990) * #PhaseOneInstances + 0.0155, 0)
		button.BackgroundTransparency = 1
		button.BorderSizePixel = 0
		button.TextColor3 = Color3.fromRGB(255, 255, 255)
		button.TextSize = 15
		button.TextXAlignment = Enum.TextXAlignment.Center
		button.Font = options.font
		button.Text = text
		button.ZIndex = bodyelements.ZIndex
		button.Name = HttpService:GenerateGUID(false)
		
		function act:SetText(txt)
			button.Text = txt
		end

		table.insert(PhaseOneInstances, button)
		
		Open()
		
		return act
	end
	
	


	function elements:AddBox(placeholder, callback) 
		placeholder = placeholder or "New Box"
		callback = callback or function() end
		
		local DisabledOutlineColor = Color3.fromRGB(60, 60, 60)

		
		local OutlinedTextBox = Instance.new("TextBox")
		local Bar = Instance.new("Frame")
		local ErrorText = Instance.new("TextLabel")
		local UIPadding = Instance.new("UIPadding")
		local TopBarL = Instance.new("Frame")
		local TopBarR = Instance.new("Frame")
		local RBar = Instance.new("Frame")
		local LBar = Instance.new("Frame")
		local TextHit = Instance.new("TextLabel")
		local back = Instance.new("TextLabel")
		local TextSize = Instance.new("TextLabel")
		
		
		OutlinedTextBox.Name = HttpService:GenerateGUID(false)
		OutlinedTextBox.Parent = bodyelements
		OutlinedTextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		OutlinedTextBox.BackgroundTransparency = 1
		OutlinedTextBox.Size = UDim2.new(0, 215/1.15, 0, 32.5/1.15)
		OutlinedTextBox.AnchorPoint = Vector2.new(0.5,0)
		OutlinedTextBox.Position = UDim2.new(0.5, 0, (pixelspacing / 990) * #PhaseOneInstances + 0.0155, 0)
		OutlinedTextBox.ZIndex = bodyelements.ZIndex
		OutlinedTextBox.ClearTextOnFocus = false
		OutlinedTextBox.Font = Enum.Font.SourceSans
		OutlinedTextBox.PlaceholderColor3 = Color3.fromRGB(156, 156, 156)
		OutlinedTextBox.PlaceholderText = placeholder
		OutlinedTextBox.Text = ""
		OutlinedTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
		OutlinedTextBox.TextSize = 15.000
		OutlinedTextBox.TextXAlignment = Enum.TextXAlignment.Left
		
		Bar.Name = HttpService:GenerateGUID(false)
		Bar.Parent = OutlinedTextBox
		Bar.BackgroundColor3 = DisabledOutlineColor
		Bar.BorderSizePixel = 0
		Bar.Position = UDim2.new(0, -6, 1, 0)
		Bar.Selectable = true
		Bar.Size = UDim2.new(1, 12, 0, 2)
		Bar.ZIndex = OutlinedTextBox.ZIndex
		
		ErrorText.Name = HttpService:GenerateGUID(false)
		ErrorText.Parent = OutlinedTextBox
		ErrorText.AnchorPoint = Vector2.new(1, 0)
		ErrorText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ErrorText.BackgroundTransparency = 1.000
		ErrorText.BorderSizePixel = 0
		ErrorText.Position = UDim2.new(1, 6, 1, 0)
		ErrorText.Size = UDim2.new(1, -4, 0, 18)
		ErrorText.Visible = false
		ErrorText.Font = Enum.Font.SourceSans
		ErrorText.Text = "Error"
		ErrorText.TextColor3 = Color3.fromRGB(255, 33, 33)
		ErrorText.TextSize = 14.000
		ErrorText.TextStrokeColor3 = Color3.fromRGB(255, 33, 33)
		ErrorText.TextStrokeTransparency = 0.940
		ErrorText.TextXAlignment = Enum.TextXAlignment.Left
		ErrorText.ZIndex = OutlinedTextBox.ZIndex
		
		UIPadding.Parent = OutlinedTextBox
		UIPadding.PaddingLeft = UDim.new(0, 6)
		UIPadding.PaddingRight = UDim.new(0, 6)
		
		TopBarL.Name = HttpService:GenerateGUID(false)
		TopBarL.Parent = OutlinedTextBox
		TopBarL.BackgroundColor3 = DisabledOutlineColor
		TopBarL.BorderSizePixel = 0
		TopBarL.Position = UDim2.new(0, -6, 0, -2)
		TopBarL.Selectable = true
		TopBarL.Size = UDim2.new(0, 4, 0, 2)
		TopBarL.ZIndex = OutlinedTextBox.ZIndex
		
		TopBarR.Name = HttpService:GenerateGUID(false)
		TopBarR.Parent = OutlinedTextBox
		TopBarR.AnchorPoint = Vector2.new(1, 0)
		TopBarR.BackgroundColor3 = DisabledOutlineColor
		TopBarR.BorderSizePixel = 0
		TopBarR.Position = UDim2.new(1, 6, 0, -2)
		TopBarR.Selectable = true
		TopBarR.Size = UDim2.new(1, 8, 0, 2)
		TopBarR.ZIndex = OutlinedTextBox.ZIndex
		
		RBar.Name = HttpService:GenerateGUID(false)
		RBar.Parent = OutlinedTextBox
		RBar.AnchorPoint = Vector2.new(1, 0)
		RBar.BackgroundColor3 = DisabledOutlineColor
		RBar.BorderSizePixel = 0
		RBar.Position = UDim2.new(1, 7, 0, -1)
		RBar.Selectable = true
		RBar.Size = UDim2.new(0, 2, 1, 2)
		RBar.ZIndex = OutlinedTextBox.ZIndex
		
		LBar.Name = HttpService:GenerateGUID(false)
		LBar.Parent = OutlinedTextBox
		LBar.BackgroundColor3 = DisabledOutlineColor
		LBar.BorderSizePixel = 0
		LBar.Position = UDim2.new(0, -7, 0, -1)
		LBar.Selectable = true
		LBar.Size = UDim2.new(0, 2, 1, 2)
		LBar.ZIndex = OutlinedTextBox.ZIndex
		
		TextHit.Name = HttpService:GenerateGUID(false)
		TextHit.Parent = OutlinedTextBox
		TextHit.AnchorPoint = Vector2.new(0, 0.5)
		TextHit.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextHit.BackgroundTransparency = 1.000
		TextHit.Position = UDim2.new(0, 0, 0.5, 0)
		TextHit.Size = UDim2.new(1, 0, 1, 0)
		TextHit.Font = Enum.Font.SourceSans
		TextHit.TextColor3 = Color3.fromRGB(0, 0, 0)
		TextHit.TextSize = 14.000
		TextHit.TextXAlignment = Enum.TextXAlignment.Left
		TextHit.ZIndex = OutlinedTextBox.ZIndex
		
		back.Name = HttpService:GenerateGUID(false)
		back.Parent = TextHit
		back.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		back.BackgroundTransparency = 1.000
		back.Size = UDim2.new(1, 0, 1, 0)
		back.Font = Enum.Font.SourceSans
		back.TextColor3 = Color3.fromRGB(0, 0, 0)
		back.TextSize = 14.000
		back.TextXAlignment = Enum.TextXAlignment.Left
		back.ZIndex = OutlinedTextBox.ZIndex
		
		TextSize.Name = HttpService:GenerateGUID(false)
		TextSize.Parent = OutlinedTextBox
		TextSize.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextSize.BackgroundTransparency = 1.000
		TextSize.Size = UDim2.new(1, 0, 1, 0)
		TextSize.Visible = false
		TextSize.Font = Enum.Font.SourceSans
		TextSize.TextColor3 = Color3.fromRGB(0, 0, 0)
		TextSize.TextSize = 14.000
		TextSize.TextXAlignment = Enum.TextXAlignment.Left
		TextSize.ZIndex = OutlinedTextBox.ZIndex
		
		local Color = ColorGradient1
		local box = OutlinedTextBox
		local bar = Bar
		local round = Instance.new("Frame",bar)
		local TpBarR = TopBarR
		local TpBarL = TopBarL
		
		local BarR = RBar
		local BarL = LBar
		
		round.BorderSizePixel = 0
		round.AnchorPoint = Vector2.new(0,0)
		round.Position = UDim2.new(0,0,0,0)
		round.Size = UDim2.new(1,0,1,0)
		round.Name = HttpService:GenerateGUID(false)
		round.BackgroundColor3 = Color
		round.BackgroundTransparency = 1
		round.ZIndex = OutlinedTextBox.ZIndex
		
		local TopR_round = round:Clone()
		TopR_round.Parent = TpBarR
		
		local TopL_round = round:Clone()
		TopL_round.Parent = TpBarL
		
		local BarR_round = round:Clone()
		BarR_round.Parent = BarR
		
		local BarL_round = round:Clone()
		BarL_round.Parent = BarL
		
		local Hit = TextHit
		Hit.Parent = box
		Hit.TextScaled = true
		Hit.Text = ""
		box.TextWrapped = true
		back.TextColor3 = Color
		back.TextColor3 = Color
		back.TextTransparency=1
		local TextSize = TextSize
		TextSize.Parent = box
		local Foused = false
		local Hit_Foused = false
		local tarns_in = false
		local tarns_out = false
		local function box_Changed()
			if box.PlaceholderText == "" then else
				Hit.Size = UDim2.new(0,box.TextBounds.X,1,0)
				Hit.TextSize = box.TextSize
				Hit.Text = box.PlaceholderText
				Hit.TextScaled = true
				Hit.TextColor3 = box.PlaceholderColor3
				TextSize.TextSize = box.TextSize
				TextSize.Text = box.PlaceholderText
				TextSize.TextColor3 = box.PlaceholderColor3
				back.TextSize = box.TextSize
				back.Text = box.PlaceholderText
				back.TextScaled = true
				back.TextColor3 = box.PlaceholderColor3
				back.Font = box.Font
				back.TextColor3 = Color
				box.PlaceholderText = ""
			end
		end
		local save = box.Text
		box:GetPropertyChangedSignal("Text"):Connect(function()
			save = box.Text
			if Foused == false and box.Text == "" then
				Hit_Foused = false
				local Time = 0.3
				Hit:TweenSizeAndPosition(UDim2.new(0, TextSize.TextBounds.X, 1, 0), UDim2.new(0, 0, 0.5, 0),Enum.EasingDirection.InOut,Enum.EasingStyle.Quad, Time, true, nil)
				TpBarR:TweenSize(UDim2.new(1, 8, 0, 2),Enum.EasingDirection.In,Enum.EasingStyle.Quad, Time-0.04, true, nil)
			end
			if Foused == false and box.Text ~= "" then
				Hit_Foused = false
				local Time = 0.3
				Hit:TweenSizeAndPosition(UDim2.new(0, TextSize.TextBounds.X-4, 0, TextSize.TextBounds.Y-4), UDim2.new(0, 0, 0, -2),Enum.EasingDirection.In,Enum.EasingStyle.Quad, Time, true, nil)
				TpBarR:TweenSize(UDim2.new(1, -(TextSize.TextBounds.X)+12,0,2),Enum.EasingDirection.In,Enum.EasingStyle.Quad, Time, true, nil)
			end
		end)
		box_Changed()
		local function Focused()
			Foused = true
			local Time = 0.3
			
			if Hit_Foused == false then
				Hit_Foused = true
				Hit:TweenSizeAndPosition(UDim2.new(0, TextSize.TextBounds.X-4, 0, TextSize.TextBounds.Y-4), UDim2.new(0, 0, 0, -2),Enum.EasingDirection.In,Enum.EasingStyle.Quad, Time, true, nil)
				TpBarR:TweenSize(UDim2.new(1, -(TextSize.TextBounds.X)+12,0,2),Enum.EasingDirection.In,Enum.EasingStyle.Quad, Time, true, nil)
			end
			tarns_out = false
			tarns_in = true
			local u = 10
			local back = Hit:FindFirstChild("back")
			repeat wait(0.03)
				if back == nil then break end
				if back.TextTransparency < 0.01 then 
					tarns_in = false
				break end
				back.TextTransparency = back.TextTransparency-0.1
				back.TextScaled = true
				round.BackgroundTransparency = back.TextTransparency
				TopL_round.BackgroundTransparency = back.TextTransparency
				TopR_round.BackgroundTransparency = back.TextTransparency
				BarL_round.BackgroundTransparency = back.TextTransparency
				BarR_round.BackgroundTransparency = back.TextTransparency
			until back.TextTransparency < 0.01 or tarns_in == false
		end
		box.Focused:Connect(Focused)
		local function FocusLost()
			spawn(function()
				pcall(callback, OutlinedTextBox.Text) 
			end)
			Foused = false
			local Time = 0.3
			if Hit_Foused == true and box.Text == "" then
				Hit_Foused = false
				Hit:TweenSizeAndPosition(UDim2.new(0, TextSize.TextBounds.X, 1, 0), UDim2.new(0, 0, 0.5, 0),Enum.EasingDirection.InOut,Enum.EasingStyle.Quad, Time, true, nil)
				TpBarR:TweenSize(UDim2.new(1, 8, 0, 2),Enum.EasingDirection.In,Enum.EasingStyle.Quad, Time-0.04, true, nil)
				tarns_in = false
				tarns_out = true
				local u = 10
				local back = Hit:FindFirstChild("back")
				repeat wait(0.03)
					if back == nil then break end
					if back.TextTransparency > 0.9 then 
						tarns_out = false
					break end
					back.TextTransparency = back.TextTransparency+0.1
					back.TextScaled = true
					round.BackgroundTransparency = back.TextTransparency
					TopL_round.BackgroundTransparency = back.TextTransparency
					TopR_round.BackgroundTransparency = back.TextTransparency
					BarL_round.BackgroundTransparency = back.TextTransparency
					BarR_round.BackgroundTransparency = back.TextTransparency
				until back.TextTransparency > 0.9 or tarns_out == false
			end
		end
		box.FocusLost:Connect(FocusLost)
		box.Changed:Connect(box_Changed)

		table.insert(PhaseOneInstances, OutlinedTextBox)
		Open()
	end
	local Mouse = game:service'Players'.LocalPlayer:GetMouse()
	function elements:AddSlider(text, minvalue, maxvalue, callback)
		local slideractions = {}
		text = text or "New slider"
		minvalue = minvalue or 0
		maxvalue = maxvalue or 100
		callback = callback or function() end

		local box = Instance.new("TextLabel", bodyelements)
		box.Size = UDim2.new(0, 215/1.15, 0, 32.5/1.15)
		box.AnchorPoint = Vector2.new(0.5,0)
		box.Position = UDim2.new(0.5, 0, (pixelspacing / 990) * #PhaseOneInstances + 0.0155, 0)
		box.BackgroundTransparency = 0
		box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		box.BorderSizePixel = 1
		box.BorderColor3 = Color3.fromRGB(60, 60, 60)
		box.TextColor3 = Color3.new(1, 1, 1)
		box.TextSize = 15
		box.TextXAlignment = Enum.TextXAlignment.Left
		box.Font = options.font
		box.Text = ""
        box.ZIndex = bodyelements.ZIndex
		box.Name = HttpService:GenerateGUID(false)
		
		local UpperSlideValue = Instance.new("TextLabel")
		UpperSlideValue.Name = HttpService:GenerateGUID(false)
		UpperSlideValue.Parent = box
		UpperSlideValue.AnchorPoint = Vector2.new(0.5, 0.5)
		UpperSlideValue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		UpperSlideValue.BackgroundTransparency = 1.000
		UpperSlideValue.Position = UDim2.new(0.5, 0, 0.5, 0)
		UpperSlideValue.Size = UDim2.new(1, -7, 1, -1)
		UpperSlideValue.ZIndex = box.ZIndex + 1
		UpperSlideValue.Font = options.font
		UpperSlideValue.Text = tostring(minvalue)
		UpperSlideValue.TextColor3 = Color3.fromRGB(150, 150, 150)
		UpperSlideValue.TextSize = 14
		UpperSlideValue.TextXAlignment = Enum.TextXAlignment.Right
		UpperSlideValue.TextYAlignment = Enum.TextYAlignment.Top
		
		local UpperSlideText = Instance.new("TextLabel")
		UpperSlideText.Name = HttpService:GenerateGUID(false)
		UpperSlideText.Parent = box
		UpperSlideText.AnchorPoint = Vector2.new(0.5, 0.5)
		UpperSlideText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		UpperSlideText.BackgroundTransparency = 1.000
		UpperSlideText.Position = UDim2.new(0.5, 0, 0.5, 0)
		UpperSlideText.Size = UDim2.new(1, -7, 1, -1)
		UpperSlideText.ZIndex = box.ZIndex
		UpperSlideText.Font = options.font
		UpperSlideText.Text = tostring(text)
		UpperSlideText.TextColor3 = Color3.fromRGB(150, 150, 150)
		UpperSlideText.TextSize = 14
		UpperSlideText.TextXAlignment = Enum.TextXAlignment.Left
		UpperSlideText.TextYAlignment = Enum.TextYAlignment.Top
		

		local Slider = Instance.new("Frame")
		local Point = Instance.new("ImageLabel")
		local MouseOn = Instance.new("ImageLabel")
		local MouseDown = Instance.new("ImageLabel")
		local ValIcon = Instance.new("ImageLabel")
		local ValText = Instance.new("TextLabel")
		local Back = Instance.new("Frame")
		local MouseButton = Instance.new("TextButton")
		
		Slider.Name = HttpService:GenerateGUID(false)
		Slider.Parent = box
		Slider.BackgroundColor3 = Color3.fromRGB(125, 125, 125)
		Slider.BorderSizePixel = 0
		Slider.Size = UDim2.new(0, 160, 0, 2)
		Slider.ZIndex = box.ZIndex
		Slider.AnchorPoint = Vector2.new(0.5,0.5)
		Slider.Position = UDim2.new(0.5, 0, 0.5, 7)
		
		Point.Name = HttpService:GenerateGUID(false)
		Point.Parent = Slider
		Point.AnchorPoint = Vector2.new(0.5, 0.5)
		Point.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Point.BackgroundTransparency = 1.000
		Point.Position = UDim2.new(0, 0, 0.5, 0)
		Point.Size = UDim2.new(0, 12, 0, 12)
		Point.ZIndex = box.ZIndex + 1
		Point.Image = "rbxassetid://1217158727"
		Point.ImageColor3 = ColorGradient1
		table.insert(sliderDots, Point)
		
		MouseOn.Name = HttpService:GenerateGUID(false)
		MouseOn.Parent = Point
		MouseOn.AnchorPoint = Vector2.new(0.5, 0.5)
		MouseOn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		MouseOn.BackgroundTransparency = 1.000
		MouseOn.Position = UDim2.new(0.5, 0, 0.5, 0)
		MouseOn.ZIndex = box.ZIndex + 1
		MouseOn.Image = "rbxassetid://1217158727"
		MouseOn.ImageColor3 = ColorGradient1
		MouseOn.ImageTransparency = 0.850
		table.insert(sliderDots, MouseOn)

		MouseDown.Name = HttpService:GenerateGUID(false)
		MouseDown.Parent = Point
		MouseDown.AnchorPoint = Vector2.new(0.5, 0.5)
		MouseDown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		MouseDown.BackgroundTransparency = 1.000
		MouseDown.Position = UDim2.new(0.5, 0, 0.5, 0)
		MouseDown.ZIndex = box.ZIndex + 1
		MouseDown.Image = "rbxassetid://1217158727"
		MouseDown.ImageColor3 = ColorGradient1
		MouseDown.ImageTransparency = 0.850
		table.insert(sliderDots, MouseDown)
		
		ValIcon.Name = HttpService:GenerateGUID(false)
		ValIcon.Parent = Point
		ValIcon.AnchorPoint = Vector2.new(0.5, 1)
		ValIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ValIcon.BackgroundTransparency = 1.000
		ValIcon.BorderSizePixel = 0
		ValIcon.ClipsDescendants = true
		ValIcon.Position = UDim2.new(0.5, 0, 0, 2)
		ValIcon.ZIndex = box.ZIndex + 1
		ValIcon.Image = "http://www.roblox.com/asset/?id=5047851106"
		ValIcon.ImageColor3 = ColorGradient1
		ValIcon.Size = UDim2.new(0, 0,0, 0)
		table.insert(sliderDots, ValIcon)
		
		ValText.Name = HttpService:GenerateGUID(false)
		ValText.Parent = ValIcon
		ValText.AnchorPoint = Vector2.new(0.5, 0.5)
		ValText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ValText.BackgroundTransparency = 1.000
		ValText.Position = UDim2.new(0.5, 0, 0.5, 0)
		ValText.Size = UDim2.new(0.800000012, 0, 0, 28)
		ValText.ZIndex = box.ZIndex + 1
		ValText.Font = Enum.Font.SourceSans
		ValText.Text = "1"
		ValText.TextColor3 = Color3.fromRGB(255, 255, 255)
		ValText.TextSize = 14
		
		Back.Name = HttpService:GenerateGUID(false)
		Back.Parent = Slider
		Back.BackgroundColor3 = ColorGradient2
		Back.BorderSizePixel = 0
		Back.Size = UDim2.new(0, 0, 1, 0)
		Back.ZIndex = box.ZIndex
		table.insert(sliderLines, Back)
		
		MouseButton.Name = HttpService:GenerateGUID(false)
		MouseButton.Parent = Slider
		MouseButton.AnchorPoint = Vector2.new(0, 0.5)
		MouseButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		MouseButton.BackgroundTransparency = 1.000
		MouseButton.BorderSizePixel = 0
		MouseButton.Position = UDim2.new(0, 0, 0.5, 0)
		MouseButton.Size = UDim2.new(1, 0, 1, 10)
		MouseButton.Font = Enum.Font.SourceSans
		MouseButton.Text = ""
		MouseButton.TextColor3 = Color3.fromRGB(0, 0, 0)
		MouseButton.TextSize = 14
		MouseButton.TextTransparency = 1
		
		table.insert(PhaseOneInstances, box)
		Open()
		
		local MouseisOn = false
		local MouseisDown = false
		local Value = 0
		local Max = 100
		local IntOnly = true 
		local ValueLabelMultiply = 1
		local ValueLabel = true
		
		MouseButton.MouseEnter:Connect(function()
			MouseisOn = true
			MouseOn:TweenSize(UDim2.new(2, 0, 2, 0),Enum.EasingDirection.Out,Enum.EasingStyle.Linear,0.12,true,nil)
		end)
		
		MouseButton.MouseLeave:Connect(function()
			MouseisOn = false
			if MouseisDown == false then
				MouseOn:TweenSize(UDim2.new(0,0,0,0),Enum.EasingDirection.Out,Enum.EasingStyle.Linear,0.12,true,nil)
			end
		end)
		
		local UserInputService = game:GetService("UserInputService")
		local RunService = game:GetService("RunService")
		
		local Connection;
		UserInputService.InputEnded:Connect(function(input)
		    if input.UserInputType == Enum.UserInputType.MouseButton1 then
		        if(Connection) then
					ValIcon:TweenSize(UDim2.new(0, 0, 0, 0),Enum.EasingDirection.Out,Enum.EasingStyle.Linear,0.12,true,nil)
		            Connection:Disconnect();
		            Connection = nil;
		        end;
		    end;
		end);
		
		MouseButton.MouseButton1Down:Connect(function()
		    if(Connection) then
		        Connection:Disconnect();
		    end;
		
		    Connection = RunService.Heartbeat:Connect(function()
		        local mouse = UserInputService:GetMouseLocation();
		        local percent = math.clamp((mouse.X - MouseButton.AbsolutePosition.X) / (MouseButton.AbsoluteSize.X), 0, 1);
		        local Value = minvalue + (maxvalue - minvalue) * percent;
				
				ValIcon:TweenSize(UDim2.new(0, 28,0, 40),Enum.EasingDirection.Out,Enum.EasingStyle.Linear,0.12,true,nil)
					
				if MouseisOn == false then
					MouseOn:TweenSize(UDim2.new(0,0,0,0),Enum.EasingDirection.Out,Enum.EasingStyle.Linear,0.12,true,nil)
				end
				
				local NewValue = percent * 100
				Point:TweenPosition(UDim2.new(NewValue/Max,0,0.5,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.1,true,nil)
				Back:TweenSize(UDim2.new(NewValue/Max,0,1,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.1,true,nil)
		
		        Value = tonumber(string.format("%.2f", math.floor(Value)));
		
				ValText.Text = Value
				UpperSlideValue.Text = tostring(Value)

				spawn(function()
					pcall(callback, (Value)) 
				end)
				
		    end);
		end);
		
		function slideractions:Set(val)
			local NewValue = ((val-minvalue)/(maxvalue-minvalue)) * 100
			Point:TweenPosition(UDim2.new(NewValue/Max,0,0.5,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.1,true,nil)
			Back:TweenSize(UDim2.new(NewValue/Max,0,1,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.1,true,nil)
	
			ValText.Text = val
			UpperSlideValue.Text = tostring(val)
		end

		return slideractions
	end
	return elements
end                      
return library
