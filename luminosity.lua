-- made by sipergameingbro#8529

local library = {}

function library:CreateWindow(winopts)
    winopts = winopts or {
        Name = "luminosity",
        Version = "1.0.0",
        Highlight = Color3.fromRGB(189, 84, 80),
        DarkAccent = Color3.fromRGB(15, 15, 15),
        Accent1 = Color3.fromRGB(25, 25, 25),
        Accent2 = Color3.fromRGB(30, 30, 30)
    }

    local WinTypes = {}
    local windowdrag, sliderdrag, tabcolor = false, false, winopts.Highlight

    local Luminosity = Instance.new("ScreenGui")
    local core = Instance.new("Frame")
    local sidebar = Instance.new("Frame")
    local UIListLayout = Instance.new("UIListLayout")
    local title = Instance.new("TextLabel")
    local version = Instance.new("TextLabel")
    local main = Instance.new("Frame")
    local linebar = Instance.new("Frame")
    local UIGradient = Instance.new("UIGradient")
    local glow = Instance.new("ImageLabel")

    if (syn) then
        if (syn.protect_gui) then
            syn.protect_gui(Luminosity)
        end
    elseif (gethui) then
        Luminosity.Parent = gethui()
    else
        Luminosity.Parent = game.CoreGui
    end

    Luminosity.Enabled = true
    Luminosity.Name = game:GetService("HttpService"):GenerateGUID(false)
    Luminosity.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    core.Name = "core"
    core.Parent = Luminosity
    core.BackgroundColor3 = winopts.DarkAccent
    core.BorderColor3 = Color3.fromRGB(66, 66, 66)
    core.BorderSizePixel = 0
    core.Position = UDim2.new(0.3111251, 0, 0.281828105, 0)
    core.Size = UDim2.new(0, 600, 0, 400)

    sidebar.Name = "sidebar"
    sidebar.Parent = core
    sidebar.BackgroundColor3 = winopts.Accent1
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
    main.BackgroundColor3 = winopts.Accent1
    main.BorderColor3 = Color3.fromRGB(66, 66, 66)
    main.BorderSizePixel = 0
    main.Position = UDim2.new(0.125, 0, 0.125, 0)
    main.Size = UDim2.new(0, 500, 0, 325)

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
            core.BackgroundColor3 = winopts.DarkAccent
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

    userinputservice.InputBegan:connect(function(input)
        if input.KeyCode == Enum.KeyCode.RightControl then
            Luminosity.Enabled = not Luminosity.Enabled
        end
    end)

    function WinTypes:CreateTab(Name, Icon)
        Name = Name or "NewTab"
        Icon = Icon or "6022668898"
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
        tab_container.CanvasSize = UDim2.new(0, 0, 0, 0)
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
            title.Text = winopts.Name:upper() .. ": " .. Name:upper()
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
            title.Text = winopts.Name:upper() .. ": " .. Name:upper()
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
            toggle.BackgroundColor3 = winopts.Accent2
            toggle.BorderSizePixel = 0
            toggle.Position = UDim2.new(0.0299999993, 0, 0.0461538471, 0)
            toggle.Size = UDim2.new(0, 470, 0, 40)

            main_2.Name = "main"
            main_2.Parent = toggle
            main_2.BackgroundColor3 = winopts.DarkAccent
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
                    main_2.BackgroundColor3 = winopts.DarkAccent
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
            button.BackgroundColor3 = winopts.Accent2
            button.BorderSizePixel = 0
            button.Position = UDim2.new(0.0299999993, 0, 0.215384617, 0)
            button.Size = UDim2.new(0, 470, 0, 40)

            main_3.Name = "main"
            main_3.Parent = button
            main_3.BackgroundColor3 = winopts.DarkAccent
            main_3.BorderSizePixel = 0
            main_3.Position = UDim2.new(0.0120000308, 0, 0.100000001, 0)
            main_3.Size = UDim2.new(0, 459, 0, 31)
            main_3.Font = Enum.Font.Gotham
            main_3.Text = Name
            main_3.TextColor3 = Color3.fromRGB(255, 255, 255)
            main_3.TextSize = 14.000

            spawn(function()
                while true do
                    main_3.BackgroundColor3 = winopts.DarkAccent
                    main_3.TextColor3 = winopts.Highlight
                    wait(0.02)
                end
            end)

            main_3.MouseButton1Click:Connect(function()
                tweenservice:Create(main_3, TweenInfo.new(0.250, Enum.EasingStyle.Quint), {TextSize = 10}):Play()
                wait(0.01)
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
            label.BackgroundColor3 = winopts.DarkAccent
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

            spawn(function()
                while true do
                    label.BackgroundColor3 = winopts.DarkAccent
                    wait(0.02)
                end
            end)

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
            slider.BackgroundColor3 = winopts.Accent2
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
            main_4.BackgroundColor3 = winopts.DarkAccent
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
                    main_4.BackgroundColor3 = winopts.DarkAccent
                    wait(0.02)
                end
            end)

            local function slide(input)
				local pos = UDim2.new(math.clamp((input.Position.X - main_4.AbsolutePosition.X) / main_4.AbsoluteSize.X, 0, 1), 0, 1, 0)
                tweenservice:Create(bar, TweenInfo.new(0.250, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Size = pos }):Play()
                local s = math.floor(((pos.X.Scale * Options.Max) / Options.Max) * (Options.Max - Options.Min) + Options.Min)
                slvalue = s
				value.Text = tostring(s) .. "/" .. Options.Max

				if (callback) then
                    callback(s)
                end
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

                tweenservice:Create(bar, TweenInfo.new(0.250, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { 
                    Size = UDim2.new(slvalue / Options.Max, 0, 1, 0)
                }):Play()
                value.Text = tostring(slvalue) .. "/" .. Options.Max

                if (callback) then
                    callback(slvalue)
                end
            end

            Resize()
            return SliderTypes
        end

        function TabTypes:CreateTextbox(Name, Callback)
            local current = ""
            local old = ""
            Name = Name or "TEXTBOX"
            Callback = Callback or function(new,old)
                print("New:",new,"Old:",old)
            end

            local textbox = Instance.new("Frame")
            local title_4 = Instance.new("TextLabel")
            local main_5 = Instance.new("TextBox")

            textbox.Name = "textbox"
            textbox.Parent = tab_container
            textbox.BackgroundColor3 = winopts.Accent2
            textbox.BorderSizePixel = 0
            textbox.Position = UDim2.new(0.0299999993, 0, 0.0461538471, 0)
            textbox.Size = UDim2.new(0, 470, 0, 40)

            title_4.Name = "title"
            title_4.Parent = textbox
            title_4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            title_4.BackgroundTransparency = 1.000
            title_4.Position = UDim2.new(0.0425531901, 0, 0, 0)
            title_4.Size = UDim2.new(0, 200, 0, 40)
            title_4.Font = Enum.Font.Gotham
            title_4.Text = Name:upper()
            title_4.TextColor3 = Color3.fromRGB(255, 255, 255)
            title_4.TextSize = 14.000
            title_4.TextXAlignment = Enum.TextXAlignment.Left

            main_5.Name = "main"
            main_5.Parent = textbox
            main_5.BackgroundColor3 = winopts.DarkAccent
            main_5.BorderSizePixel = 0
            main_5.Position = UDim2.new(0.393617034, 0, 0.200000003, 0)
            main_5.Size = UDim2.new(0, 279, 0, 25)
            main_5.Font = Enum.Font.Gotham
            main_5.PlaceholderText = "Type something here ..."
            main_5.Text = ""
            main_5.TextColor3 = Color3.fromRGB(255,255,255)
            main_5.TextSize = 14.000

            spawn(function()
                while true do
                    main_5.BackgroundColor3 = winopts.DarkAccent
                    wait(0.02)
                end
            end)

            main_5.FocusLost:Connect(function()
                old = current
                current = main_5.Text

                if (Callback) then
                    Callback(current,old)
                end
            end)
        end

        function TabTypes:CreateDropdown(Name, Options, Callback)
            local DropdownTypes = {}
            local SelectedItem = ""
            local toggled = false
            local items = {}
            Name = Name or "DROP"
            Callback = Callback or function(value)
                print("Selected Item:",value)
            end

            local dropdown_button = Instance.new("Frame")
            local title_6 = Instance.new("TextLabel")
            local main_6 = Instance.new("TextButton")
            local dropdown_frame = Instance.new("Frame")
            local UIListLayout_3 = Instance.new("UIListLayout")

            dropdown_button.Name = "dropdown_button"
            dropdown_button.Parent = tab_container
            dropdown_button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            dropdown_button.BorderSizePixel = 0
            dropdown_button.Position = UDim2.new(0.0299999993, 0, 0.0461538471, 0)
            dropdown_button.Size = UDim2.new(0, 470, 0, 40)

            title_6.Name = "title"
            title_6.Parent = dropdown_button
            title_6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            title_6.BackgroundTransparency = 1.000
            title_6.Position = UDim2.new(0.0425531901, 0, 0, 0)
            title_6.Size = UDim2.new(0, 412, 0, 40)
            title_6.Font = Enum.Font.Gotham
            title_6.Text = Name:upper()
            title_6.TextColor3 = Color3.fromRGB(255, 255, 255)
            title_6.TextSize = 14.000
            title_6.TextXAlignment = Enum.TextXAlignment.Left

            main_6.Name = "main"
            main_6.Parent = dropdown_button
            main_6.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            main_6.BorderSizePixel = 0
            main_6.Position = UDim2.new(0.92051065, 0, 0.100000001, 0)
            main_6.Size = UDim2.new(0, 31, 0, 31)
            main_6.Font = Enum.Font.Gotham
            main_6.Text = "V"
            main_6.Rotation = 90
            main_6.TextColor3 = Color3.fromRGB(255, 255, 255)
            main_6.TextSize = 14.000

            dropdown_frame.Name = "dropdown_frame"
            dropdown_frame.Parent = tab_container
            dropdown_frame.BackgroundColor3 = winopts.Accent2
            dropdown_frame.BorderSizePixel = 0
            dropdown_frame.Position = UDim2.new(0.0299999993, 0, 0.00307692308, 0)
            dropdown_frame.Size = UDim2.new(0, 470, 0, 100)
            dropdown_frame.Visible = false

            UIListLayout_3.Parent = dropdown_frame
            UIListLayout_3.SortOrder = Enum.SortOrder.LayoutOrder

            local function ResizeList()
                dropdown_frame.Size = UDim2.new(0, 470, 0, UIListLayout_3.AbsoluteContentSize.Y + 10)
            end

            local function CreateItem(NameOp)
                local item = Instance.new("TextButton")

                item.Name = "item_" .. NameOp
                item.Parent = dropdown_frame
                item.BackgroundColor3 = winopts.Accent2
                item.BorderSizePixel = 0
                item.Size = UDim2.new(0, 470, 0, 30)
                item.Font = Enum.Font.Gotham
                item.Text = NameOp:upper()
                item.TextColor3 = Color3.fromRGB(255, 255, 255)
                item.TextSize = 14.000

                item.MouseButton1Click:Connect(function()
                    SelectedItem = NameOp
                    title_6.Text = Name:upper() .. ": " .. NameOp:upper()

                    for i,v in pairs(dropdown_frame:GetChildren()) do
                        if (v:IsA("TextButton")) then
                            if (v.Name == "item_" .. NameOp) then
                                tweenservice:Create(v, TweenInfo.new(0.250, Enum.EasingStyle.Quint), {
                                    BackgroundColor3 = winopts.DarkAccent,
                                    TextColor3 = winopts.Highlight
                                }):Play()
                            else
                                tweenservice:Create(v, TweenInfo.new(0.250, Enum.EasingStyle.Quint), {
                                    BackgroundColor3 = winopts.Accent2,
                                    TextColor3 = Color3.fromRGB(255, 255, 255)
                                }):Play()
                            end
                        end
                    end

                    tweenservice:Create(item, TweenInfo.new(0.250, Enum.EasingStyle.Quint), {TextSize = 10}):Play()
                    wait(0.01)
                    tweenservice:Create(item, TweenInfo.new(0.250, Enum.EasingStyle.Quint), {TextSize = 14}):Play()

                    if (Callback) then
                        Callback(SelectedItem)
                    end
                end)

                ResizeList()
                return item
            end

            if (Options ~= nil) then
                if (#Options > 0) then
                    for i,v in pairs(Options) do
                        local Item = CreateItem(v)
                        table.insert(items, #items, Item)
                    end
                end
            end

            main_6.MouseButton1Click:Connect(function()
                toggled = not toggled

                if (toggled) then
                    tweenservice:Create(main_6, TweenInfo.new(0.250, Enum.EasingStyle.Quint), {Rotation = 0}):Play()
                    dropdown_frame.Visible = true
                else
                    tweenservice:Create(main_6, TweenInfo.new(0.250, Enum.EasingStyle.Quint), {Rotation = 90}):Play()
                    dropdown_frame.Visible = false
                end
            end)

            function DropdownTypes:Add(Name)
                local Item = CreateItem(Name)
                table.insert(items, #items, Item)
                ResizeList()
            end

            function DropdownTypes:RemoveAll()
                for i,v in pairs(items) do
                    v:Destroy()
                end
            end

            function DropdownTypes:SetItem(NameOp)
                if (Options ~= nil) then
                    if (#Options > 0) then
                        for i,v in pairs(Options) do
                            if (v == NameOp) then
                                SelectedItem = NameOp
                                title_6.Text = Name:upper() .. ": " .. NameOp:upper()

                                for i,v in pairs(dropdown_frame:GetChildren()) do
                                    if (v:IsA("TextButton")) then
                                        if (v.Name == "item_" .. NameOp) then
                                            tweenservice:Create(v, TweenInfo.new(0.250, Enum.EasingStyle.Quint), {
                                                BackgroundColor3 = winopts.DarkAccent,
                                                TextColor3 = winopts.Highlight
                                            }):Play()
                                        else
                                            tweenservice:Create(v, TweenInfo.new(0.250, Enum.EasingStyle.Quint), {
                                                BackgroundColor3 = winopts.Accent2,
                                                TextColor3 = Color3.fromRGB(255, 255, 255)
                                            }):Play()
                                        end
                                    end
                                end

                                if (Callback) then
                                    Callback(SelectedItem)
                                end
                            end
                        end
                    end
                end
            end

            function DropdownTypes:GetItem()
                return SelectedItem
            end

            Resize()
            ResizeList()
            return DropdownTypes
        end

        function TabTypes:CreateColorpicker(Name, Callback)
            local ColorpickerTypes = {}
            Name = Name:upper() or "COLORPICKER"
            Callback = function(color)
                print("R:",color.R,"G:",color.G,"B:",color.B)
            end
            local dragging = false
            local red = 255
            local green = 255
            local blue = 255

            local colorpicker_button = Instance.new("Frame")
            local title_6 = Instance.new("TextLabel")
            local color = Instance.new("Frame")
            local main_6 = Instance.new("TextButton")
            local colorpicker_frame = Instance.new("Frame")
            local slider_1 = Instance.new("Frame")
            local title_7 = Instance.new("TextLabel")
            local main_7 = Instance.new("Frame")
            local bar_1 = Instance.new("Frame")
            local value_1 = Instance.new("TextLabel")
            local UIListLayout_4 = Instance.new("UIListLayout")
            local slider_2 = Instance.new("Frame")
            local title_8 = Instance.new("TextLabel")
            local main_8 = Instance.new("Frame")
            local bar_2 = Instance.new("Frame")
            local value_2 = Instance.new("TextLabel")
            local slider_3 = Instance.new("Frame")
            local title_9 = Instance.new("TextLabel")
            local main_9 = Instance.new("Frame")
            local bar_3 = Instance.new("Frame")
            local value_3 = Instance.new("TextLabel")

            colorpicker_button.Name = "colorpicker_button"
            colorpicker_button.Parent = tab_container
            colorpicker_button.BackgroundColor3 = Color3.fromRGB(29, 26, 53)
            colorpicker_button.BorderSizePixel = 0
            colorpicker_button.Position = UDim2.new(0.0299999993, 0, 0.0461538471, 0)
            colorpicker_button.Size = UDim2.new(0, 470, 0, 40)

            title_6.Name = "title"
            title_6.Parent = colorpicker_button
            title_6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            title_6.BackgroundTransparency = 1.000
            title_6.Position = UDim2.new(0.0425531901, 0, 0, 0)
            title_6.Size = UDim2.new(0, 412, 0, 40)
            title_6.Font = Enum.Font.Gotham
            title_6.Text = Name
            title_6.TextColor3 = Color3.fromRGB(255, 255, 255)
            title_6.TextSize = 14.000
            title_6.TextXAlignment = Enum.TextXAlignment.Left

            color.Name = "color"
            color.Parent = colorpicker_button
            color.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            color.Position = UDim2.new(0.925531924, 0, 0.200000003, 0)
            color.Size = UDim2.new(0, 24, 0, 24)

            main_6.Name = "main"
            main_6.Parent = color
            main_6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            main_6.BackgroundTransparency = 1.000
            main_6.Size = UDim2.new(0, 24, 0, 24)
            main_6.Font = Enum.Font.SourceSans
            main_6.Text = ""
            main_6.TextColor3 = Color3.fromRGB(0, 0, 0)
            main_6.TextSize = 14.000

            colorpicker_frame.Name = "colorpicker_frame"
            colorpicker_frame.Parent = tab_container
            colorpicker_frame.BackgroundColor3 = Color3.fromRGB(29, 26, 53)
            colorpicker_frame.BorderSizePixel = 0
            colorpicker_frame.Position = UDim2.new(0.0299999993, 0, 0.184615478, 0)
            colorpicker_frame.Size = UDim2.new(0, 470, 0, 150)
            colorpicker_frame.Visible = false

            -- First Slider
            slider_1.Name = "slider"
            slider_1.Parent = colorpicker_frame
            slider_1.BackgroundColor3 = Color3.fromRGB(29, 26, 53)
            slider_1.BorderSizePixel = 0
            slider_1.Position = UDim2.new(0.0299999993, 0, 0.384615391, 0)
            slider_1.Size = UDim2.new(0, 470, 0, 50)

            title_7.Name = "title"
            title_7.Parent = slider_1
            title_7.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            title_7.BackgroundTransparency = 1.000
            title_7.Position = UDim2.new(0.0425531901, 0, 0, 0)
            title_7.Size = UDim2.new(0, 289, 0, 34)
            title_7.Font = Enum.Font.Gotham
            title_7.Text = "RED"
            title_7.TextColor3 = Color3.fromRGB(255, 255, 255)
            title_7.TextSize = 14.000
            title_7.TextXAlignment = Enum.TextXAlignment.Left

            main_7.Name = "main"
            main_7.Parent = slider_1
            main_7.BackgroundColor3 = Color3.fromRGB(195, 195, 195)
            main_7.BorderSizePixel = 0
            main_7.Position = UDim2.new(0.0425531901, 0, 0.685000002, 0)
            main_7.Size = UDim2.new(0, 439, 0, 5)

            bar_1.Name = "bar"
            bar_1.Parent = main_7
            bar_1.BackgroundColor3 = Color3.fromRGB(52, 47, 86)
            bar_1.BorderSizePixel = 0
            bar_1.Size = UDim2.new(0, 100, 0, 5)

            value_1.Name = "value"
            value_1.Parent = slider_1
            value_1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            value_1.BackgroundTransparency = 1.000
            value_1.Position = UDim2.new(0.657446802, 0, 0, 0)
            value_1.Size = UDim2.new(0, 150, 0, 34)
            value_1.Font = Enum.Font.Gotham
            value_1.Text = "0/255"
            value_1.TextColor3 = Color3.fromRGB(255, 255, 255)
            value_1.TextSize = 14.000
            value_1.TextXAlignment = Enum.TextXAlignment.Right

            UIListLayout_4.Parent = colorpicker_frame
            UIListLayout_4.SortOrder = Enum.SortOrder.LayoutOrder

            -- Seocnd Slider
            slider_2.Name = "slider"
            slider_2.Parent = colorpicker_frame
            slider_2.BackgroundColor3 = Color3.fromRGB(29, 26, 53)
            slider_2.BorderSizePixel = 0
            slider_2.Position = UDim2.new(0.0299999993, 0, 0.384615391, 0)
            slider_2.Size = UDim2.new(0, 470, 0, 50)

            title_8.Name = "title"
            title_8.Parent = slider_2
            title_8.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            title_8.BackgroundTransparency = 1.000
            title_8.Position = UDim2.new(0.0425531901, 0, 0, 0)
            title_8.Size = UDim2.new(0, 289, 0, 34)
            title_8.Font = Enum.Font.Gotham
            title_8.Text = "GREEN"
            title_8.TextColor3 = Color3.fromRGB(255, 255, 255)
            title_8.TextSize = 14.000
            title_8.TextXAlignment = Enum.TextXAlignment.Left

            main_8.Name = "main"
            main_8.Parent = slider_2
            main_8.BackgroundColor3 = Color3.fromRGB(195, 195, 195)
            main_8.BorderSizePixel = 0
            main_8.Position = UDim2.new(0.0425531901, 0, 0.685000002, 0)
            main_8.Size = UDim2.new(0, 439, 0, 5)

            bar_2.Name = "bar"
            bar_2.Parent = main_8
            bar_2.BackgroundColor3 = Color3.fromRGB(52, 47, 86)
            bar_2.BorderSizePixel = 0
            bar_2.Size = UDim2.new(0, 100, 0, 5)

            value_2.Name = "value"
            value_2.Parent = slider_2
            value_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            value_2.BackgroundTransparency = 1.000
            value_2.Position = UDim2.new(0.657446802, 0, 0, 0)
            value_2.Size = UDim2.new(0, 150, 0, 34)
            value_2.Font = Enum.Font.Gotham
            value_2.Text = "0/255"
            value_2.TextColor3 = Color3.fromRGB(255, 255, 255)
            value_2.TextSize = 14.000
            value_2.TextXAlignment = Enum.TextXAlignment.Right

            -- Third Second
            slider_3.Name = "slider"
            slider_3.Parent = colorpicker_frame
            slider_3.BackgroundColor3 = Color3.fromRGB(29, 26, 53)
            slider_3.BorderSizePixel = 0
            slider_3.Position = UDim2.new(0.0299999993, 0, 0.384615391, 0)
            slider_3.Size = UDim2.new(0, 470, 0, 50)

            title_9.Name = "title"
            title_9.Parent = slider_3
            title_9.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            title_9.BackgroundTransparency = 1.000
            title_9.Position = UDim2.new(0.0425531901, 0, 0, 0)
            title_9.Size = UDim2.new(0, 289, 0, 34)
            title_9.Font = Enum.Font.Gotham
            title_9.Text = "BLUE"
            title_9.TextColor3 = Color3.fromRGB(255, 255, 255)
            title_9.TextSize = 14.000
            title_9.TextXAlignment = Enum.TextXAlignment.Left

            main_9.Name = "main"
            main_9.Parent = slider_3
            main_9.BackgroundColor3 = Color3.fromRGB(195, 195, 195)
            main_9.BorderSizePixel = 0
            main_9.Position = UDim2.new(0.0425531901, 0, 0.685000002, 0)
            main_9.Size = UDim2.new(0, 439, 0, 5)

            bar_3.Name = "bar"
            bar_3.Parent = main_9
            bar_3.BackgroundColor3 = Color3.fromRGB(52, 47, 86)
            bar_3.BorderSizePixel = 0
            bar_3.Size = UDim2.new(0, 100, 0, 5)

            value_3.Name = "value"
            value_3.Parent = slider_3
            value_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            value_3.BackgroundTransparency = 1.000
            value_3.Position = UDim2.new(0.657446802, 0, 0, 0)
            value_3.Size = UDim2.new(0, 150, 0, 34)
            value_3.Font = Enum.Font.Gotham
            value_3.Text = "0/255"
            value_3.TextColor3 = Color3.fromRGB(255, 255, 255)
            value_3.TextSize = 14.000
            value_3.TextXAlignment = Enum.TextXAlignment.Right

            spawn(function()
                while true do
                    color.BackgroundColor3 = Color3.fromRGB(red,green,blue)

                    bar_1.BackgroundColor3 = Color3.fromRGB(red,green,blue)
                    bar_2.BackgroundColor3 = Color3.fromRGB(red,green,blue)
                    bar_3.BackgroundColor3 = Color3.fromRGB(red,green,blue)
                    
                    main_7.BackgroundColor3 = winopts.DarkAccent
                    main_8.BackgroundColor3 = winopts.DarkAccent
                    main_9.BackgroundColor3 = winopts.DarkAccent

                    slider_1.BackgroundColor3 = winopts.Accent1
                    slider_2.BackgroundColor3 = winopts.Accent1
                    slider_3.BackgroundColor3 = winopts.Accent1
                    wait(0.02)
                end
            end)

            -- Button
            main_6.MouseButton1Click:Connect(function()
                colorpicker_frame.Visible = not colorpicker_frame.Visible
            end)

            -- Sliders
            local function slide(input,i)
				if (i == 1) then
                    local pos = UDim2.new(math.clamp((input.Position.X - main_7.AbsolutePosition.X) / main_7.AbsoluteSize.X, 0, 1), 0, 1, 0)
                    tweenservice:Create(bar_1, TweenInfo.new(0.250, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Size = pos }):Play()
                    local s = math.floor(((pos.X.Scale * 255) / 255) * (255 - 0) + 0)
                    red = s
                    value_1.Text = tostring(s) .. "/255"

                    if (Callback) then
                        Callback(Color3.fromRGB(red,green,blue))
                    end
                elseif (i == 2) then
                    local pos = UDim2.new(math.clamp((input.Position.X - main_8.AbsolutePosition.X) / main_8.AbsoluteSize.X, 0, 1), 0, 1, 0)
                    tweenservice:Create(bar_2, TweenInfo.new(0.250, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Size = pos }):Play()
                    local s = math.floor(((pos.X.Scale * 255) / 255) * (255 - 0) + 0)
                    green = s
                    value_2.Text = tostring(s) .. "/255"

                    if (Callback) then
                        Callback(Color3.fromRGB(red,green,blue))
                    end
                elseif (i == 3) then
                    local pos = UDim2.new(math.clamp((input.Position.X - main_9.AbsolutePosition.X) / main_9.AbsoluteSize.X, 0, 1), 0, 1, 0)
                    tweenservice:Create(bar_3, TweenInfo.new(0.250, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Size = pos }):Play()
                    local s = math.floor(((pos.X.Scale * 255) / 255) * (255 - 0) + 0)
                    blue = s
                    value_3.Text = tostring(s) .. "/255"

                    if (Callback) then
                        Callback(Color3.fromRGB(red,green,blue))
                    end
                end
			end

			main_7.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    slide(input,1)
                    dragging = true
                    sliderdrag = true
                end
            end)

            main_8.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    slide(input,2)
                    dragging = true
                    sliderdrag = true
                end
            end)

            main_9.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    slide(input,3)
                    dragging = true
                    sliderdrag = true
                end
            end)

            main_7.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    slide(input,1)
                end
            end)

            main_8.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    slide(input,2)
                end
            end)

            main_9.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    slide(input,3)
                end
            end)

            main_7.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                    sliderdrag = false
                end
            end)

            main_8.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                    sliderdrag = false
                end
            end)

            main_9.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                    sliderdrag = false
                end
            end)

            function ColorpickerTypes:SetColor()

            end

            return ColorpickerTypes
        end

        return TabTypes
    end

    function WinTypes:UpdateHighlight(color)
        winopts.Highlight = color
    end

    return WinTypes
end

return library
