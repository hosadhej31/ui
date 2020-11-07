local Library = {}

function Library:Create(options)
	options = options or {
		highlight = Color3.fromRGB(0, 255, 127)
	}
	local windowItems = {}

	local UILib = Instance.new("ScreenGui")
	local MainFrame = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local HeaderLine = Instance.new("Frame")
	local TabContainer = Instance.new("Frame")
    local UIListLayout = Instance.new("UIListLayout")
    
    syn.protect_gui(UILib)

	UILib.Name = "UILib"
	UILib.Parent = game.CoreGui
	UILib.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	MainFrame.Name = "MainFrame"
	MainFrame.Parent = UILib
	MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	MainFrame.BorderSizePixel = 0
	MainFrame.Position = UDim2.new(0.2910496, 0, 0.22760801, 0)
	MainFrame.Size = UDim2.new(0, 500, 0, 400)

	UICorner.Parent = MainFrame
	UICorner.CornerRadius = UDim.new(0, 8)
	UICorner.Archivable = true

	HeaderLine.Name = "HeaderLine"
	HeaderLine.Parent = MainFrame
	HeaderLine.BackgroundColor3 = options.highlight
	HeaderLine.Position = UDim2.new(0, 0, 0.075000003, 0)
    HeaderLine.Size = UDim2.new(0, 500, 0, 1)
    HeaderLine.BorderSizePixel = 0

	TabContainer.Name = "TabContainer"
	TabContainer.Parent = MainFrame
	TabContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TabContainer.BackgroundTransparency = 1.000
	TabContainer.Size = UDim2.new(0, 500, 0, 30)

	UIListLayout.Parent = TabContainer
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

	local UIS = game:GetService("UserInputService")
	local dragToggle = nil
	local dragSpeed = 0
	local dragInput = nil
	local dragStart = nil
	local dragPos = nil

	function updateInput(input)
		local Delta = input.Position - dragStart
		local Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + Delta.X, startPos.Y.Scale, startPos.Y.Offset + Delta.Y)
		game:GetService("TweenService"):Create(MainFrame, TweenInfo.new(0.25), {Position = Position}):Play()
	end

	MainFrame.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and UIS:GetFocusedTextBox() == nil then
			dragToggle = true
			dragStart = input.Position
			startPos = MainFrame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragToggle = false
				end
			end)
		end
	end)

	MainFrame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if input == dragInput and dragToggle then
			updateInput(input)
		end
	end)

	function windowItems:Toggle()
		MainFrame.Visible = not MainFrame.Visible
	end

	function windowItems:Tab(name)
		name = name or "tab"
		local tabItems = {}

		local Page1 = Instance.new("TextButton")
		local Page1_2 = Instance.new("Frame")
		local ScrollingFrame = Instance.new("ScrollingFrame")
		local UIPadding = Instance.new("UIPadding")
		local UIListLayout_2 = Instance.new("UIListLayout")

		Page1.Name = name .. "Page"
		Page1.Parent = TabContainer
		Page1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Page1.BackgroundTransparency = 1.000
		Page1.Size = UDim2.new(0, 100, 0, 30)
		Page1.Font = Enum.Font.SourceSans
		Page1.Text = name
		Page1.TextColor3 = Color3.fromRGB(255, 255, 255)
		Page1.TextSize = 18.000

		Page1_2.Name = name .. "Page"
		Page1_2.Parent = MainFrame
		Page1_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Page1_2.BackgroundTransparency = 1.000
		Page1_2.Position = UDim2.new(0, 0, 0.075000003, 0)
		Page1_2.Size = UDim2.new(0, 500, 0, 370)

		ScrollingFrame.Parent = Page1_2
		ScrollingFrame.Active = true
		ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ScrollingFrame.BackgroundTransparency = 1.000
		ScrollingFrame.BorderSizePixel = 0
		ScrollingFrame.Position = UDim2.new(0, 0, 0.0135135138, 0)
		ScrollingFrame.Size = UDim2.new(0, 500, 0, 365)
		ScrollingFrame.BottomImage = ""
		ScrollingFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
		ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(40, 40, 40)
		ScrollingFrame.ScrollBarThickness = 3
		ScrollingFrame.TopImage = ""
		ScrollingFrame.Visible = false

		UIPadding.Parent = ScrollingFrame
		UIPadding.PaddingBottom = UDim.new(0, 5)
		UIPadding.PaddingLeft = UDim.new(0, 5)
		UIPadding.PaddingRight = UDim.new(0, 5)
		UIPadding.PaddingTop = UDim.new(0, 5)

		UIListLayout_2.Parent = ScrollingFrame
		UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_2.Padding = UDim.new(0, 10)

		Page1.MouseButton1Click:Connect(function()
			for i,v in pairs(MainFrame:GetChildren()) do
				if (v.Name:find("Page")) then
					if (v.Name ~= name .. "Page") then
						v.ScrollingFrame.Visible = false
					else
						v.ScrollingFrame.Visible = true
					end
				end
			end
			for i,v in pairs(TabContainer:GetChildren()) do
				if (v.Name:find("Page")) then
					if (v.Name ~= name .. "Page") then
						v.TextColor3 = Color3.fromRGB(104, 104, 104)
					else
						v.TextColor3 = options.highlight
					end
				end
			end
		end)

		function tabItems:SelectTab()
			for i,v in pairs(MainFrame:GetChildren()) do
				if (v.Name:find("Page")) then
					if (v.Name ~= name .. "Page") then
						v.ScrollingFrame.Visible = false
					else
						v.ScrollingFrame.Visible = true
					end
				end
			end
			for i,v in pairs(TabContainer:GetChildren()) do
				if (v.Name:find("Page")) then
					if (v.Name ~= name .. "Page") then
						v.TextColor3 = Color3.fromRGB(104, 104, 104)
					else
						v.TextColor3 = options.highlight
					end
				end
			end
		end

		function tabItems:Section(sectionName)
			local Section = Instance.new("Frame")
			local Text = Instance.new("TextLabel")
			local UICornerS = Instance.new("UICorner")

			Section.Name = "Section"
			Section.Parent = ScrollingFrame
			Section.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			Section.BorderSizePixel = 0
			Section.Size = UDim2.new(0, 500, 0, 30)

			UICornerS.Parent = Section
			UICornerS.CornerRadius = UDim.new(0, 8)
			UICornerS.Archivable = true

			Text.Name = "Text"
			Text.Parent = Section
			Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Text.BackgroundTransparency = 1.000
			Text.Size = UDim2.new(0, 500, 0, 30)
			Text.Font = Enum.Font.SourceSans
			Text.Text = "Section Info"
			Text.TextColor3 = Color3.fromRGB(255, 255, 255)
			Text.TextSize = 18.000
		end

		function tabItems:Button(buttonName, callback)
			buttonName = buttonName or "Button"
			callback = callback or function()
				print("Button Pressed")
			end

			local Button = Instance.new("TextButton")
			local UICornerB = Instance.new("UICorner")

			Button.Name = "Button"
			Button.Parent = ScrollingFrame
			Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			Button.Position = UDim2.new(0.0199999996, 0, 0.01369863, 0)
			Button.Size = UDim2.new(0, 480, 0, 30)
			Button.Font = Enum.Font.SourceSans
			Button.Text = "Button Info"
			Button.TextColor3 = Color3.fromRGB(255, 255, 255)
			Button.TextSize = 18.000

			UICornerB.Parent = Button
			UICornerB.CornerRadius = UDim.new(0, 8)
			UICornerB.Archivable = true

			Button.MouseButton1Click:Connect(function()
				callback()
			end)
		end

		function tabItems:Toggle(toggleName, callback)
			toggleName = toggleName or "Toggle"
			callback = callback or function(state)
				print("Toggle: ",state)
			end
			local toggleItems = {}

			local toggled
			local Toggle = Instance.new("Frame")
			local Text_2 = Instance.new("TextLabel")
			local Frame = Instance.new("Frame")
            local TextButton = Instance.new("TextButton")
            local UICornerT = Instance.new("UICorner")
			local UICornerTT = Instance.new("UICorner")

			Toggle.Name = "Toggle"
			Toggle.Parent = ScrollingFrame
			Toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Toggle.Size = UDim2.new(0, 480, 0, 30)
            
            UICornerT.Parent = Toggle
			UICornerT.CornerRadius = UDim.new(0, 8)
			UICornerT.Archivable = true

			Text_2.Name = "Text"
			Text_2.Parent = Toggle
			Text_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Text_2.BackgroundTransparency = 1.000
			Text_2.Position = UDim2.new(0.020833334, 0, 0, 0)
			Text_2.Size = UDim2.new(0, 470, 0, 30)
			Text_2.Font = Enum.Font.SourceSans
			Text_2.Text = toggleName
			Text_2.TextColor3 = Color3.fromRGB(255, 255, 255)
			Text_2.TextSize = 18.000
			Text_2.TextXAlignment = Enum.TextXAlignment.Left

			Frame.Parent = Toggle
			Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			Frame.Position = UDim2.new(0.9375, 0, 0.166666657, 0)
            Frame.Size = UDim2.new(0, 20, 0, 20)
            
            UICornerTT.Parent = Frame
			UICornerTT.CornerRadius = UDim.new(0, 50)
			UICornerTT.Archivable = true

			TextButton.Parent = Frame
			TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TextButton.BackgroundTransparency = 1.000
			TextButton.Size = UDim2.new(0, 20, 0, 20)
			TextButton.Font = Enum.Font.SourceSans
			TextButton.Text = ""
			TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextButton.TextSize = 18.000

			TextButton.MouseButton1Click:Connect(function()
				toggled = not toggled		

				if (toggled) then
					TextButton.Text = "X"
				else
					TextButton.Text = ""
				end

				callback(toggled)
			end)

			function toggleItems:Update(state)
				toggled = state

				if (toggled) then
					TextButton.Text = "X"
				else
					TextButton.Text = ""
				end
			end

			return toggleItems
		end
		
		function tabItems:Textbox(textboxName, callback)
			textboxName = textboxName or "Textbox"
			callback = callback or function(new, old)
				print("New: ",new," | Old: ",old)
			end
			local oldInput = ""
			local textboxItems = {}
			
			local Textbox = Instance.new("Frame")
			local Text_3 = Instance.new("TextLabel")
            local Box = Instance.new("TextBox")
            local UICornerT1 = Instance.new("UICorner")
            local UICornerT2 = Instance.new("UICorner")
			
			Textbox.Name = "Textbox"
			Textbox.Parent = ScrollingFrame
			Textbox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Textbox.Size = UDim2.new(0, 480, 0, 30)
            
            UICornerT1.Parent = Textbox
			UICornerT1.CornerRadius = UDim.new(0, 8)
			UICornerT1.Archivable = true

			Text_3.Name = "Text"
			Text_3.Parent = Textbox
			Text_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Text_3.BackgroundTransparency = 1.000
			Text_3.Position = UDim2.new(0.020833334, 0, 0, 0)
			Text_3.Size = UDim2.new(0, 470, 0, 30)
			Text_3.Font = Enum.Font.SourceSans
			Text_3.Text = textboxName
			Text_3.TextColor3 = Color3.fromRGB(255, 255, 255)
			Text_3.TextSize = 18.000
			Text_3.TextXAlignment = Enum.TextXAlignment.Left

			Box.Name = "Box"
			Box.Parent = Textbox
			Box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			Box.Position = UDim2.new(0.583333313, 0, 0.166666672, 0)
			Box.Size = UDim2.new(0, 190, 0, 20)
			Box.Font = Enum.Font.SourceSans
			Box.Text = ""
			Box.TextColor3 = Color3.fromRGB(255, 255, 255)
			Box.TextSize = 18.000
            Box.TextWrapped = true

            UICornerT2.Parent = Box
			UICornerT2.CornerRadius = UDim.new(0, 8)
			UICornerT2.Archivable = true
			
			Box.FocusLost:Connect(function()
				callback(Box.Text, oldInput)
				oldInput = Box.Text
			end)
			
			function textboxItems:Update(text)
				Box.Text = text
			end
			
			return textboxItems
		end
		
		function tabItems:Label(labelName)
			labelName = labelName or "Label"
			local labelItems = {}
			
            local Label = Instance.new("TextLabel")
            local UICornerL = Instance.new("UICorner")
			
			Label.Name = "Label"
			Label.Parent = ScrollingFrame
			Label.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			Label.Size = UDim2.new(0, 480, 0, 30)
			Label.Font = Enum.Font.SourceSans
			Label.Text = labelName
			Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.TextSize = 18.000
            
            UICornerL.Parent = Label
			UICornerL.CornerRadius = UDim.new(0, 8)
			UICornerL.Archivable = true
			
			function labelItems:Update(text)
				Label.Text = text
			end
			
			return labelItems
		end

		return tabItems
	end

	return windowItems
end

return Library
