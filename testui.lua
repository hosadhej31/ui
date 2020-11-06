local Library = {}

function Library:Create(options)
	options = options or {
		highlightColor = Color3.fromRGB(0, 165, 255)
	}
	local windowItems = {}
	
	local UILib = Instance.new("ScreenGui")
	local MainFrame = Instance.new("Frame")
	local HeaderLine = Instance.new("Frame")
	local TabContainer = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")
	
	UILib.Name = "UILib"
	UILib.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
	UILib.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	MainFrame.Name = "MainFrame"
	MainFrame.Parent = UILib
	MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	MainFrame.BorderSizePixel = 0
	MainFrame.Position = UDim2.new(0.2910496, 0, 0.22760801, 0)
	MainFrame.Size = UDim2.new(0, 500, 0, 400)
	
	HeaderLine.Name = "HeaderLine"
	HeaderLine.Parent = MainFrame
	HeaderLine.BackgroundColor3 = options.highlightColor
	HeaderLine.Position = UDim2.new(0, 0, 0.075000003, 0)
	HeaderLine.Size = UDim2.new(0, 500, 0, 1)

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
        end)
		
		function tabItems:Section(sectionName)
			local Section = Instance.new("Frame")
			local Text = Instance.new("TextLabel")
			
			Section.Name = "Section"
			Section.Parent = ScrollingFrame
			Section.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			Section.BorderSizePixel = 0
			Section.Size = UDim2.new(0, 500, 0, 30)

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
		
		return tabItems
	end
	
	return windowItems
end

return Library
