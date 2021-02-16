-- made by sipergameingbro#8529

local library = {}

function library:CreateWindow(winopts)
    winopts = winopts or {
        Name = "luminosity",
        Version = "1.0.0",
        Highlight = Color3.fromRGB(189, 84, 80)
    }
    local WinTypes = {}
    local windowdrag, sliderdrag, tabcolor = true, false, winopts.Highlight

    local Luminosity = Instance.new("ScreenGui")
    local core = Instance.new("Frame")
    local sidebar = Instance.new("Frame")
    local UIListLayout = Instance.new("UIListLayout")
    local title = Instance.new("TextLabel")
    local version = Instance.new("TextLabel")
    local main = Instance.new("Frame")
    local searchbar = Instance.new("TextBox")
    local linebar = Instance.new("Frame")
    local UIGradient = Instance.new("UIGradient")
    local glow = Instance.new("ImageLabel")

    Luminosity.Enabled = true
    Luminosity.Name = game:GetService("HttpService"):GenerateGUID(false)
    Luminosity.Parent = game.CoreGui
    Luminosity.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    core.Name = "core"
    core.Parent = Luminosity
    core.BackgroundColor3 = Color3.fromRGB(15,15,15)
    core.BorderColor3 = Color3.fromRGB(66, 66, 66)
    core.BorderSizePixel = 0
    core.Position = UDim2.new(0.3111251, 0, 0.281828105, 0)
    core.Size = UDim2.new(0, 600, 0, 400)

    sidebar.Name = "sidebar"
    sidebar.Parent = core
    sidebar.BackgroundColor3 = Color3.fromRGB(25,25,25)
    sidebar.BorderSizePixel = 0
    sidebar.Size = UDim2.new(0, 50, 0, 400)

    UIListLayout.Parent = sidebar
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    title.Name = "title"
    title.Parent = core
    title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundTransparency = 1.000
    title.Position = UDim2.new(0.125, 0, 0.0249999985, 0)
    title.Size = UDim2.new(0, 200, 0, 25)
    title.Font = Enum.Font.GothamBold
    title.Text = winopts.Name:upper()
    title.TextColor3 = winopts.Highlight
    title.TextSize = 20.000
    title.TextXAlignment = Enum.TextXAlignment.Left

    version.Name = "version"
    version.Parent = title
    version.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    version.BackgroundTransparency = 1.000
    version.Position = UDim2.new(0, 0, 0.800000012, 0)
    version.Size = UDim2.new(0, 135, 0, 16)
    version.Font = Enum.Font.Gotham
    version.Text = "VERSION "..tostring(winopts.Version):upper()
    version.TextColor3 = Color3.fromRGB(178, 178, 178)
    version.TextSize = 12.000
    version.TextXAlignment = Enum.TextXAlignment.Left

    main.Name = "main"
    main.Parent = core
    main.BackgroundColor3 = Color3.fromRGB(25,25,25)
    main.BorderColor3 = Color3.fromRGB(66, 66, 66)
    main.BorderSizePixel = 0
    main.Position = UDim2.new(0.125, 0, 0.125, 0)
    main.Size = UDim2.new(0, 500, 0, 325)

    searchbar.Name = "searchbar"
    searchbar.Parent = core
    searchbar.BackgroundColor3 = Color3.fromRGB(35,35,35)
    searchbar.BorderSizePixel = 0
    searchbar.Position = UDim2.new(0.349999994, 0, 0.0250000004, 0)
    searchbar.Size = UDim2.new(0, 365, 0, 25)
    searchbar.Font = Enum.Font.SourceSans
    searchbar.PlaceholderColor3 = Color3.fromRGB(178, 178, 178)
    searchbar.PlaceholderText = "Search for something here ..."
    searchbar.Text = ""
    searchbar.TextColor3 = Color3.fromRGB(255, 255, 255)
    searchbar.TextSize = 14.000
    searchbar.Visible = false

    linebar.Name = "linebar"
    linebar.Parent = core
    linebar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    linebar.BorderSizePixel = 0
    linebar.Position = UDim2.new(0.0833333358, 0, 0, 0)
    linebar.Size = UDim2.new(0, 6, 0, 400)

    UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 0, 0)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(20, 18, 44))}
    UIGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.80), NumberSequenceKeypoint.new(1.00, 0.80)}
    UIGradient.Parent = linebar

    glow.Name = "glow"
    glow.Parent = core
    glow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    glow.BackgroundTransparency = 1.000
    glow.BorderSizePixel = 0
    glow.Position = UDim2.new(0, -15, 0, -15)
    glow.Size = UDim2.new(1, 30, 1, 30)
    glow.ZIndex = 0
    glow.Image = "rbxassetid://4996891970"
    glow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    glow.ScaleType = Enum.ScaleType.Slice
    glow.SliceCenter = Rect.new(20, 20, 280, 280)

    spawn(function()
        while true do
            title.TextColor3 = winopts.Highlight
            wait(0.02)
        end
    end)

    local tweenservice = game:GetService("TweenService")
    local userinputservice = game:GetService("UserInputService")
    local dragInput, dragStart, startPos = nil, nil, nil

    core.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and userinputservice:GetFocusedTextBox() == nil then
            dragStart = input.Position
            startPos = core.Position
            windowdrag = true
            input.Changed:Connect(function()
                if (input.UserInputState == Enum.UserInputState.End) then
                    windowdrag = false
                end
            end)
        end
    end)

    core.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    userinputservice.InputChanged:Connect(function(input)
        if input == dragInput and windowdrag and not sliderdrag then
            local Delta = input.Position - dragStart
            local Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + Delta.X, startPos.Y.Scale, startPos.Y.Offset + Delta.Y)
            tweenservice:Create(core, TweenInfo.new(0.100), {Position = Position}):Play()
        end
    end)

    function WinTypes:CreateTab(Name, Icon)
        Name = Name or "NewTab"
        Icon = Icon or "5012544693"
        local TabTypes = {}
        local tab_select = Instance.new("TextButton")
        local icon = Instance.new("ImageLabel")
        local tab_container = Instance.new("ScrollingFrame")
        local UIPadding = Instance.new("UIPadding")
        local UIListLayout_2 = Instance.new("UIListLayout")

        tab_select.Name = "tab_"..Name.."_select"
        tab_select.Parent = sidebar
        tab_select.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        tab_select.BackgroundTransparency = 1.000
        tab_select.Size = UDim2.new(0, 50, 0, 50)
        tab_select.Font = Enum.Font.SourceSansSemibold
        tab_select.Text = ""
        tab_select.TextColor3 = Color3.fromRGB(255, 255, 255)
        tab_select.TextSize = 28.000

        icon.Name = "icon"
        icon.Parent = tab_select
        icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        icon.BackgroundTransparency = 1.000
        icon.Position = UDim2.new(0.299999974, 0, 0.230000001, 0)
        icon.Size = UDim2.new(0, 24, 0, 24)
        icon.Image = "rbxassetid://" .. Icon
        icon.ImageColor3 = Color3.fromRGB(178, 178, 178)

        tab_container.Name = "tab_"..Name.."_container"
        tab_container.Parent = main
        tab_container.Active = true
        tab_container.Visible = false
        tab_container.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        tab_container.BackgroundTransparency = 1.000
        tab_container.BorderSizePixel = 0
        tab_container.Size = UDim2.new(0, 500, 0, 325)
        tab_container.CanvasSize = UDim2.new(0, 0, 1.75, 0)
        tab_container.ScrollBarThickness = 1

        UIPadding.Parent = tab_container
        UIPadding.PaddingLeft = UDim.new(0, 15)
        UIPadding.PaddingTop = UDim.new(0, 15)

        UIListLayout_2.Parent = tab_container
        UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout_2.Padding = UDim.new(0, 5)

        tab_select.MouseButton1Click:Connect(function()
            for i,v in pairs(main:GetChildren()) do
                if (v.Name:find("tab_" .. Name .. "_container")) then
                    v.Visible = true
                else
                    v.Visible = false
                end
            end
            for i,v in pairs(sidebar:GetChildren()) do
                if (v:IsA("TextButton")) then
                    if (v.Name:find("tab_" .. Name .. "_select")) then
                        v.icon.ImageColor3 = tabcolor
                    else
                        v.icon.ImageColor3 = Color3.fromRGB(178, 178, 178)
                    end
                end
            end
            title.Text = title.Text .. ": " .. Name:upper()
        end)

        local function Resize()
            local Y = UIListLayout_2.AbsoluteContentSize.Y + 30
            tab_container.CanvasSize = UDim2.new(0, 0, 0, Y)
        end

        function TabTypes:SelectTab()
            for i,v in pairs(main:GetChildren()) do
                if (v.Name:find("tab_" .. Name .. "_container")) then
                    v.Visible = true
                else
                    v.Visible = false
                end
            end
            for i,v in pairs(sidebar:GetChildren()) do
                if (v:IsA("TextButton")) then
                    if (v.Name:find("tab_" .. Name .. "_select")) then
                        v.icon.ImageColor3 = tabcolor
                    else
                        v.icon.ImageColor3 = Color3.fromRGB(178, 178, 178)
                    end
                end
            end
            title = title .. ": " .. Name:upper()
        end

        spawn(function()
            while true do
                tabcolor = winopts.Highlight
                wait(0.02)
            end
        end)

        function TabTypes:CreateToggle(Name, Callback)
            local toggled = false
            local ToggleTypes = {}
            Name = Name:upper() or "NEW TOGGLE"
            Callback = Callback or function()
                print(toggled)
            end

            local toggle = Instance.new("Frame")
            local main_2 = Instance.new("TextButton")
            local icon_2 = Instance.new("ImageLabel")
            local title_2 = Instance.new("TextLabel")

            toggle.Name = "toggle"
            toggle.Parent = tab_container
            toggle.BackgroundColor3 = Color3.fromRGB(30,30,30)
            toggle.BorderSizePixel = 0
            toggle.Position = UDim2.new(0.0299999993, 0, 0.0461538471, 0)
            toggle.Size = UDim2.new(0, 470, 0, 40)

            main_2.Name = "main"
            main_2.Parent = toggle
            main_2.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            main_2.BorderSizePixel = 0
            main_2.Position = UDim2.new(0.93599999, 0, 0.286000013, 0)
            main_2.Size = UDim2.new(0, 20, 0, 20)
            main_2.Font = Enum.Font.SourceSans
            main_2.Text = ""
            main_2.TextColor3 = Color3.fromRGB(0, 0, 0)
            main_2.TextSize = 1.000

            icon_2.Name = "icon"
            icon_2.Parent = main_2
            icon_2.BackgroundColor3 = Color3.fromRGB(35,35,35)
            icon_2.BackgroundTransparency = 1.000
            icon_2.ImageTransparency = 1.000
            icon_2.Size = UDim2.new(0, 20, 0, 20)
            icon_2.Image = "rbxassetid://6065476353"
            icon_2.ImageColor3 = winopts.Highlight

            title_2.Name = "title"
            title_2.Parent = toggle
            title_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            title_2.BackgroundTransparency = 1.000
            title_2.Position = UDim2.new(0.0425531901, 0, 0, 0)
            title_2.Size = UDim2.new(0, 419, 0, 40)
            title_2.Font = Enum.Font.Gotham
            title_2.Text = Name:upper()
            title_2.TextColor3 = Color3.fromRGB(255, 255, 255)
            title_2.TextSize = 14.000
            title_2.TextXAlignment = Enum.TextXAlignment.Left

            spawn(function()
                while true do
                    icon_2.ImageColor3 = winopts.Highlight
                    wait(0.02)
                end
            end)

            main_2.MouseButton1Click:Connect(function()
                toggled = not toggled

                if (Callback) then
                    Callback(toggled)
                end

                if (toggled) then
                    tweenservice:Create(icon_2, TweenInfo.new(0.250, Enum.EasingStyle.Quint), {
                        ImageTransparency = 0,
                        Rotation = 360
                    }):Play()
                else
                    tweenservice:Create(icon_2, TweenInfo.new(0.250, Enum.EasingStyle.Quint), {
                        ImageTransparency = 1,
                        Rotation = 0
                    }):Play()
                end
            end)

            function ToggleTypes:GetState()
                return toggled
            end

            function ToggleTypes:SetState(state)
                toggled = state
            end

            Resize()
            return ToggleTypes
        end

        function TabTypes:CreateButton(Name, Callback)
            local ButtonTypes = {}
            Name = Name:upper() or "NEWBUTTON"
            Callback = Callback or function()
                print("pressed me")
            end

            local button = Instance.new("Frame")
            local main_3 = Instance.new("TextButton")

            button.Name = "button"
            button.Parent = tab_container
            button.BackgroundColor3 = Color3.fromRGB(30,30,30)
            button.BorderSizePixel = 0
            button.Position = UDim2.new(0.0299999993, 0, 0.215384617, 0)
            button.Size = UDim2.new(0, 470, 0, 40)

            main_3.Name = "main"
            main_3.Parent = button
            main_3.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            main_3.BorderSizePixel = 0
            main_3.Position = UDim2.new(0.0120000308, 0, 0.100000001, 0)
            main_3.Size = UDim2.new(0, 459, 0, 31)
            main_3.Font = Enum.Font.Gotham
            main_3.Text = Name
            main_3.TextColor3 = Color3.fromRGB(255, 255, 255)
            main_3.TextSize = 14.000

            main_3.MouseButton1Click:Connect(function()
                tweenservice:Create(main_3, TweenInfo.new(0.250, Enum.EasingStyle.Quint), {TextSize = 10}):Play()
                tweenservice:Create(main_3, TweenInfo.new(0.250, Enum.EasingStyle.Quint), {TextSize = 14}):Play()

                if (Callback) then
                    Callback()
                end
            end)

            function ButtonTypes:GetText()
                return main_3.Text
            end

            function ButtonTypes:SetText(Text)
                main_3.Text = Text
            end

            Resize()
            return ButtonTypes
        end

        function TabTypes:CreateSeperator()
            local seperator = Instance.new("Frame")

            seperator.Name = "seperator"
            seperator.Parent = tab_container
            seperator.BackgroundColor3 = Color3.fromRGB(35,35,35)
            seperator.BorderSizePixel = 0
            seperator.Position = UDim2.new(0.0299999993, 0, 0.584615409, 0)
            seperator.Size = UDim2.new(0, 470, 0, 1)

            Resize()
        end

        function TabTypes:CreateLabel(Name)
            local LabelTypes = {}
            Name = Name:upper() or "NEWLABEL"

            local label = Instance.new("Frame")
            local title_5 = Instance.new("TextLabel")
            label.Name = "label"
            label.Parent = tab_container
            label.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            label.BorderSizePixel = 0
            label.Position = UDim2.new(0.0299999993, 0, 0.215384617, 0)
            label.Size = UDim2.new(0, 470, 0, 25)

            title_5.Name = "title"
            title_5.Parent = label
            title_5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            title_5.BackgroundTransparency = 1.000
            title_5.Size = UDim2.new(0, 470, 0, 25)
            title_5.Font = Enum.Font.Gotham
            title_5.Text = Name
            title_5.TextColor3 = Color3.fromRGB(255, 255, 255)
            title_5.TextSize = 14.000

            function LabelTypes:GetText()
                return title_5.Text
            end

            function LabelTypes:SetText(Text)
                title_5.Text = Text
            end

            Resize()
            return LabelTypes
        end

        function TabTypes:CreateSlider(Name, Options, callback)
            local SliderTypes = {}
            local slvalue = 0
            local dragging = false
            Name = Name:upper() or "SLIDE ME"
            Options = Options or {
                Min = 0,
                Max = 100
            }
            callback = callback or function(value)
                print("slider:",value)
            end

            local slider = Instance.new("Frame")
            local title_3 = Instance.new("TextLabel")
            local main_4 = Instance.new("Frame")
            local bar = Instance.new("Frame")
            local value = Instance.new("TextLabel")

            slider.Name = "slider"
            slider.Parent = tab_container
            slider.BackgroundColor3 = Color3.fromRGB(30,30,30)
            slider.BorderSizePixel = 0
            slider.Position = UDim2.new(0.0299999993, 0, 0.384615391, 0)
            slider.Size = UDim2.new(0, 470, 0, 50)

            title_3.Name = "title"
            title_3.Parent = slider
            title_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            title_3.BackgroundTransparency = 1.000
            title_3.Position = UDim2.new(0.0425531901, 0, 0, 0)
            title_3.Size = UDim2.new(0, 289, 0, 34)
            title_3.Font = Enum.Font.Gotham
            title_3.Text = Name
            title_3.TextColor3 = Color3.fromRGB(255, 255, 255)
            title_3.TextSize = 14.000
            title_3.TextXAlignment = Enum.TextXAlignment.Left

            main_4.Name = "main"
            main_4.Parent = slider
            main_4.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            main_4.BorderSizePixel = 0
            main_4.Position = UDim2.new(0.0425531901, 0, 0.685000002, 0)
            main_4.Size = UDim2.new(0, 439, 0, 5)

            bar.Name = "bar"
            bar.Parent = main_4
            bar.BackgroundColor3 = winopts.Highlight
            bar.BorderSizePixel = 0
            bar.Size = UDim2.new(0, 0, 0, 5)

            value.Name = "value"
            value.Parent = slider
            value.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            value.BackgroundTransparency = 1.000
            value.Position = UDim2.new(0.657446802, 0, 0, 0)
            value.Size = UDim2.new(0, 150, 0, 34)
            value.Font = Enum.Font.Gotham
            value.Text = Options.Min .. "/" .. Options.Max
            value.TextColor3 = Color3.fromRGB(255, 255, 255)
            value.TextSize = 14.000
            value.TextXAlignment = Enum.TextXAlignment.Right

            spawn(function()
                while true do
                    bar.BackgroundColor3 = winopts.Highlight
                    wait(0.02)
                end
            end)

            local function slide(input)
				local pos = UDim2.new(math.clamp((input.Position.X - main_4.AbsolutePosition.X) / main_4.AbsoluteSize.X, 0, 1), 0, 1, 0)
                tweenservice:Create(bar, TweenInfo.new(0.250, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Size = pos }):Play()
                local s = math.floor(((pos.X.Scale * Options.Max) / Options.Max) * (Options.Max - Options.Min) + Options.Min)
                slvalue = s
				value.Text = tostring(s) .. "/" .. Options.Max
				callback(s)
			end

			main_4.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    slide(input)
                    dragging = true
                    sliderdrag = true
                end
            end)

            main_4.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                    sliderdrag = false
                end
            end)

            userinputservice.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    slide(input)
                end
            end)

            function SliderTypes:GetValue()
                return slvalue
            end

            function SliderTypes:SetValue(svalue)
                slvalue = svalue
            end

            Resize()
            return SliderTypes
        end

        return TabTypes
    end

    function WinTypes:UpdateHighlight(color)
        winopts.Highlight = color
    end

    return WinTypes
end

return library
