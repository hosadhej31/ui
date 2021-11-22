local magma = {
    TweenService = game:GetService("TweenService")
}

function magma.tween(class, property)
    return magma.TweenService:Create(class, TweenInfo.new(0.5, Enum.EasingStyle.Quint), property):Play()
end

function magma.spawn(f)
    coroutine.wrap(f)()
end

function magma.altersize(tab)
    local textcounter = 0

    for i = 1, #tab.Text do
        textcounter = textcounter + 7.9
    end

    tab.Size = UDim2.new(0, textcounter, 0, tab.Size.Y.Offset)
end

function magma:Create(class, properties)
    local object = Instance.new(class)

    for prop, val in pairs(properties) do
        object[prop] = val
    end

    return object
end

function magma:Window(name, color, sizey)
    getgenv().WindowThemeColor = color

    local CoreGui = game:GetService("CoreGui")

    local ScreenGui = magma:Create("ScreenGui", {
        Name = name,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 1000000000,
        ResetOnSpawn = false,
        Parent = CoreGui
    })

    local Drag = magma:Create("Frame", {
        Name = "Drag",
        Active = true,
        Draggable = true,
        BackgroundColor3 = Color3.new(0.0509804, 0.0509804, 0.0509804),
        BorderColor3 = Color3.new(0, 0, 0),
        Position = UDim2.new(0.355398446, 0, 0.184466019, 0),
        Size = UDim2.new(0, 513, 0, 27),
        Parent = ScreenGui
    })

    local Main = magma:Create("Frame", {
        Name = "Main",
        Active = true,
        BackgroundColor3 = Color3.new(0.0509804, 0.0509804, 0.0509804),
        BorderColor3 = Color3.new(0, 0, 0),
        Position = UDim2.new(-0.001, 0, 0.023466019, 0),
        Size = UDim2.new(0, 514, 0, sizey),
        Parent = Drag
    })

    local Frame = magma:Create("Frame", {
        BackgroundColor3 = Color3.new(0.0862745, 0.0862745, 0.0862745),
        BorderColor3 = Color3.new(0, 0, 0),
        Position = UDim2.new(0.0137524558, 0, 0.0470383018, 0),
        Size = UDim2.new(0, 499, 0, Main.Size.Y.Offset - 38),
        Parent = Main
    })

    local Heading = magma:Create("Frame", {
        Name = "Heading",
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 1,
        BorderColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 0,
        Position = UDim2.new(0.023499012, 0, 0, 0),
        Size = UDim2.new(0, 494, 0, 27),
        Parent = Main
    })

    local LabelListLayout = magma:Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 9),
        Parent = Heading
    })

    local Title = magma:Create("TextLabel", {
        Name = "Title",
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 1,
        Position = UDim2.new(0.0137524558, 0, 0.00199999125, 0),
        Size = UDim2.new(0, #name * 6.833333333333333, 0, 23),
        Font = Enum.Font.Code,
        Text = name,
        TextSize = 14,
        TextColor3 = Color3.new(0.490196, 0.490196, 0.490196),
        TextStrokeTransparency = 0.4,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Heading
    })

    local Background = magma:Create("Frame", {
        Name = "Background",
        BackgroundColor3 = Color3.new(0.141176, 0.141176, 0.141176),
        BorderColor3 = Color3.new(0, 0, 0),
        Position = UDim2.new(0.0155808367, 0, 0.0434783697, 0),
        Size = UDim2.new(0, 483, 0, Frame.Size.Y.Offset - 34),
        Parent = Frame
    })

    local Content = magma:Create("Frame", {
        Name = "Content",
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0.0124223605, 0, 0.0099593997, 0),
        Size = UDim2.new(0, 470, 0, Background.Size.Y.Offset - 11),
        Parent = Background
    })

    local Tabs = magma:Create("Frame", {
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 1,
        BorderColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 0,
        Position = UDim2.new(0.0276048928, 0, 0, 0),
        Size = UDim2.new(0, 476, 0, 23),
        Parent = Frame
    })

    local TabsListLayout = magma:Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5),
        Parent = Tabs
    })

    local RunService = game:GetService("RunService")

    local FramePosLeft, FramePosRight, ZIndexNum, ZIndexMax
    local ZIndexNum, ZIndexMax = 0, 0
    RunService.RenderStepped:Connect(function()
        FramePosLeft = 1
        FramePosRight = 1
        
        for _, frame in pairs(Content:GetChildren()) do
            frame.Position = UDim2.new(-0.00377, 0, 0, FramePosLeft - 2)
            FramePosLeft = FramePosLeft + frame.Size.Y.Offset + 5

            if Content.Size.Y.Offset - FramePosLeft + 7 < 0 then
                frame.Position = UDim2.new(0.507, 0, 0, -1)
            end

            if frame.Position.X.Scale >= 0.507 then
                frame.Position = UDim2.new(0.507, 0, 0, FramePosRight - 2)
                FramePosRight = FramePosRight + frame.Size.Y.Offset + 5
            end
        end

        ZIndexNum = 0
        ZIndexMax = 0

        for _, func in next, Content:GetDescendants() do
            if func.Name == "Section" or func.Name == "Dropdown" then
                ZIndexMax = ZIndexMax + 1
            end
        end
        for _, func in next, Content:GetDescendants() do
            if func.Name == "Section" or func.Name == "Dropdown" or func.Name == "Color" then
                func.ZIndex = 2 + (ZIndexMax - ZIndexNum)
                ZIndexNum = ZIndexNum + 1
            end
        end
    end)

    local oldTab
    local TabCounter = 0
    magma.spawn(function()
        while TabCounter == 0 do
            for _, tab in next, Tabs:GetChildren() do
                if tab:IsA("TextButton") then
                    magma.altersize(tab)
                    TabCounter = TabCounter + 1

                    if TabCounter == 1 then
                        tab.TextColor3 = Color3.fromRGB(255, 255, 255)

                        for _, section in next, tab.Contents:GetChildren() do
                            oldTab = tab
                            section.Visible = true
                            section.Parent = Content
                        end
                    else
                        tab.TextColor3 = Color3.fromRGB(125, 125, 125)
                    end
                end
            end
            wait()
        end
    end)

    local UserInputService = game:GetService("UserInputService")

    local upConnection
    local savedpos = UDim2.new(0.5, 0, 0.5, 0)
    local toggleKey, typing, toggled = Enum.KeyCode.RightShift, false, true

    upConnection = UserInputService.InputEnded:Connect(function(input)
        if input.KeyCode == toggleKey and not typing then
            toggled = not toggled
            
            if toggled then
                pcall(Drag.TweenPosition, Drag, savedpos, "Out", "Sine", 0.5, true)
            else
                savedpos = Drag.Position
                pcall(Drag.TweenPosition, Drag, UDim2.new(savedpos.Width.Scale, savedpos.Width.Offset, 1.5, 0), "Out", "Sine", 0.5, true)
            end
        end
    end)

    local windowLibrary = {}

    function windowLibrary:ChangeToggleKey(key)
        toggleKey = key

        if upConnection then
            upConnection:Disconnect()
        end

        upConnection = UserInputService.InputEnded:Connect(function(input)
            if input.KeyCode == toggleKey and not typing then
                toggled = not toggled

                if toggled then
                    pcall(Drag.TweenPosition, Drag, savedpos, "Out", "Sine", 0.5, true)
                else
                    savedpos = Drag.Position
                    pcall(Drag.TweenPosition, Drag, UDim2.new(savedpos.Width.Scale, savedpos.Width.Offset, 1.5, 0), "Out", "Sine", 0.5, true)
                end
            end
        end)
    end

    function windowLibrary:Label(name)
        local Differ = magma:Create("TextLabel", {
            Name = "Differ",
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 1,
            Position = UDim2.new(0.0137524558, 0, 0.00199999125, 0),
            Size = UDim2.new(0, 6, 0, 23),
            Font = Enum.Font.Code,
            Text = "|",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 14,
            TextStrokeTransparency = 0.4,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Heading
        })

        local Label = magma:Create("TextLabel", {
            Name = "Label",
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 1,
            Position = UDim2.new(0.0137524558, 0, 0.00199999125, 0),
            Size = UDim2.new(0, #name * 6.833333333333333, 0, 23),
            Font = Enum.Font.Code,
            Text = name,
            TextColor3 = Color3.fromRGB(150, 150, 150),
            TextSize = 14,
            TextStrokeTransparency = 0.4,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Heading
        })
    end

    function windowLibrary:Tab(name)
        local Tab = magma:Create("TextButton", {
            Name = "Tab",
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 24, 0, 23),
            AutoButtonColor = false,
            Font = Enum.Font.Code,
            Text = name,
            TextColor3 = Color3.new(1, 1, 1),
            TextSize = 14,
            TextStrokeTransparency = 0.4,
            Parent = Tabs
        })

        local Contents = magma:Create("Folder", {
            Name = "Contents",
            Parent = Tab
        })

        Tab.MouseButton1Down:Connect(function()
            for _, tab in next, Tabs:GetChildren() do
                if tab:IsA("TextButton") and tab ~= Tab then
                    magma.tween(tab, {
                        TextColor3 = Color3.fromRGB(125, 125, 125)
                    })

                    for _, section in next, Content:GetChildren() do
                        if section:IsA("Frame") then
                            section.Visible = false
                            section.Parent = oldTab.Contents
                        end
                    end
                end
            end

            magma.tween(Tab, {
                TextColor3 = Color3.fromRGB(255, 255, 255)
            })

            for _, section in next, Contents:GetChildren() do
                oldTab = Tab
                section.Visible = true
                section.Parent = Content
            end
        end)

        local sectionLibrary = {}

        function sectionLibrary:Section(name)
            local Section = magma:Create("Frame", {
                Name = "Section",
                BackgroundColor3 = Color3.new(0.0862745, 0.0862745, 0.0862745),
                BorderColor3 = Color3.new(0, 0, 0),
                Position = UDim2.new(0.0120000001, 0, 0.00899999961, 0),
                Size = UDim2.new(0, 235, 0, 247),
                ZIndex = 0,
                Visible = false,
                Parent = Contents
            })
    
            local SectionContents = magma:Create("Frame", {
                Name = "Contents",
                BackgroundColor3 = Color3.new(0.145098, 0.145098, 0.145098),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Position = UDim2.new(0.0278463159, 0, 0.0322874375, 0),
                Size = UDim2.new(0, 220, 0, 84),
                Parent = Section
            })

            local SectionTitle = magma:Create("TextLabel", {
                Name = "Title",
                BackgroundColor3 = Color3.new(1, 1, 1),
                BackgroundTransparency = 1,
                Position = UDim2.new(0.0260000005, 0, -1.05768967, 0),
                Size = UDim2.new(0, 178, 0, 12),
                Font = Enum.Font.Code,
                Text = name,
                TextColor3 = Color3.new(1, 1, 1),
                TextSize = 14,
                TextStrokeTransparency = 0.4,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = SectionContents
            })

            local SectionListLayout = magma:Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0.100000001, 0),
                Parent = SectionContents
            })

            RunService.Stepped:Connect(function()
                FuncSize = 0
                for _, func in next, SectionContents:GetChildren() do
                    if func:IsA("TextLabel") or func:IsA("TextButton") then
                        FuncSize = FuncSize + 9 + func.Size.Y.Offset
                    end
                end

                Section.Size = UDim2.new(0, Section.Size.X.Offset, 0, FuncSize)
            end)

            local functions = {}

            function functions:Label(name, color)
                local TextLabel = magma:Create("TextLabel", {
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1.67999995, 0, -0.0149999997, 0),
                    Size = UDim2.new(0, 199, 0, 13),
                    Font = Enum.Font.Code,
                    Text = name or "owo",
                    TextColor3 = color or Color3.new(0.301961, 0.301961, 0.301961),
                    TextSize = 14,
                    TextStrokeTransparency = 0.4,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = SectionContents
                })
            end

            function functions:Button(name, callback)
                callback = callback or function() end

                local Button = magma:Create("TextButton", {
                    Name = "Button",
                    BackgroundColor3 = Color3.new(0.176471, 0.176471, 0.176471),
                    BorderColor3 = Color3.new(0, 0, 0),
                    Position = UDim2.new(-0.00888097659, 0, 0.284795314, 0),
                    Size = UDim2.new(0, 223, 0, 18),
                    AutoButtonColor = false,
                    Font = Enum.Font.Code,
                    Text = name,
                    TextColor3 = Color3.new(1, 1, 1),
                    TextSize = 14,
                    TextStrokeTransparency = 0.4,
                    Parent = SectionContents
                })

                getgenv()[name] = false

                Button.MouseButton1Down:Connect(callback)

                return {
                    Fire = function()
                        callback()
                    end
                }
            end

            function functions:Toggle(name, callback)
                callback = callback or function() end

                local Toggle = magma:Create("TextButton", {
                    Name = "Toggle",
                    BackgroundColor3 = Color3.new(0.176471, 0.176471, 0.176471),
                    BorderColor3 = Color3.new(0, 0, 0),
                    Position = UDim2.new(-0.00888097659, 0, 0.284795314, 0),
                    Size = UDim2.new(0, 13, 0, 13),
                    AutoButtonColor = false,
                    Font = Enum.Font.Code,
                    Text = "",
                    TextColor3 = Color3.new(1, 1, 1),
                    TextSize = 14,
                    TextStrokeTransparency = 0.4,
                    Parent = SectionContents
                })

                local TextLabel = magma:Create("TextLabel", {
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1.67999995, 0, -0.0149999997, 0),
                    Size = UDim2.new(0, 199, 0, 13),
                    Font = Enum.Font.Code,
                    Text = name,
                    TextColor3 = Color3.new(0.301961, 0.301961, 0.301961),
                    TextSize = 14,
                    TextStrokeTransparency = 0.4,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Toggle
                })

                Toggle.MouseButton1Click:Connect(function()
                    if getgenv()[name] then
                        magma.tween(Toggle, {BackgroundColor3 = Color3.fromRGB(45, 45, 45)})
                        magma.tween(TextLabel, {TextColor3 = Color3.fromRGB(77, 77, 77)})
                    else
                        magma.tween(Toggle, {BackgroundColor3 = getgenv().WindowThemeColor})
                        magma.tween(TextLabel, {TextColor3 = Color3.fromRGB(255, 255, 255)})
                    end
                    
                    getgenv()[name] = not getgenv()[name]
                    callback(getgenv()[name])
                end)

                return {
                    Set = function(value)
                        magma.tween(Toggle, {BackgroundColor3 = Color3.fromRGB(45, 45, 45)})
                        magma.tween(TextLabel, {TextColor3 = Color3.fromRGB(77, 77, 77)})
    
                        getgenv()[name] = not value
                        callback(getgenv()[name])
                    end
                }
            end

            function functions:Slider(name, options, callback)
                callback = callback or function() end
                local max = (options.max - options.min)
                local min = options.min

                local Slider = magma:Create("TextLabel", {
                    Name = "Slider",
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 1.86666656, 0),
                    Size = UDim2.new(0, 178, 0, 39),
                    Font = Enum.Font.Code,
                    Text = name,
                    TextColor3 = Color3.new(255, 255, 255),
                    TextSize = 14,
                    TextStrokeTransparency = 0.4,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Top,
                    Parent = SectionContents
                })

                local Slide = magma:Create("TextButton", {
                    Name = "Slider",
                    Active = false,
                    BackgroundColor3 = Color3.new(0.176471, 0.176471, 0.176471),
                    BorderColor3 = Color3.new(0, 0, 0),
                    ClipsDescendants = true,
                    Position = UDim2.new(0, 0, 0.532051325, 0),
                    Size = UDim2.new(0, 223, 0, 18),
                    AutoButtonColor = false,
                    Font = Enum.Font.Code,
                    Text = "",
                    TextColor3 = Color3.new(1, 1, 1),
                    TextSize = 14,
                    TextStrokeTransparency = 0.4,
                    Parent = Slider
                })

                local TextButton = magma:Create("TextButton", {
                    BackgroundColor3 = getgenv().WindowThemeColor,
                    BorderSizePixel = 0,
                    Size = UDim2.new(0, 0, 1, 0),
                    AutoButtonColor = false,
                    Font = Enum.Font.Code,
                    Text = "",
                    TextColor3 = Color3.new(0, 0, 0),
                    TextSize = 14,
                    TextStrokeTransparency = 0.4,
                    Parent = Slide
                })

                local Num = magma:Create("TextLabel", {
                    Name = "Num",
                    Active = true,
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 112, 0, 0),
                    Size = UDim2.new(0, 0, 0, 18),
                    Font = Enum.Font.Code,
                    Text = tostring(min),
                    TextColor3 = Color3.new(1, 1, 1),
                    TextSize = 14,
                    TextStrokeTransparency = 0.4,
                    Parent = TextButton
                })

                local percentage

                if options.default then
                    local percent = 1 - ((max - options.default) / (max - min))
                    percentage = math.clamp(percent, 0, 1)
                    TextButton:TweenSizeAndPosition(UDim2.new(percentage, 0, 1, 0), UDim2.new(percentage / 100, -2, (TextButton.Position.Y.Scale), TextButton.Position.Y.Offset), nil, nil, 0.08)
                    Num.Text = tostring(options.default)
                end

                local function snap(number, factor)
                    if factor == 0 then
                        return number
                    else
                        return math.floor(number / factor + 0.5) * factor
                    end
                end

                local held

                Slide.MouseButton1Up:Connect(function()
                    held = false
                end)

                Slide.MouseEnter:Connect(function()
                    Slide.MouseButton1Down:Connect(function()
                        held = true
                    end)
                end)

                TextButton.MouseButton1Up:Connect(function()
                    held = false
                end)

                TextButton.MouseEnter:Connect(function()
                    TextButton.MouseButton1Down:Connect(function()
                        held = true
                    end)
                end)

                RunService.RenderStepped:Connect(function()
                    if not UserInputService:IsMouseButtonPressed(0) then
                        held = false
                    end
                end)

                RunService.RenderStepped:Connect(function()
                    if held then
                        local MousePos = UserInputService:GetMouseLocation().X
                        local BtnPos = TextButton.Position
                        local SliderSize = Slide.AbsoluteSize.X
                        local SliderPos = Slide.AbsolutePosition.X
                        local pos = snap((MousePos - SliderPos) / SliderSize, 0.01)
                        percentage = math.clamp(pos, 0, 1)
                        TextButton:TweenSizeAndPosition(UDim2.new(percentage, 0, 1, 0), UDim2.new(percentage / 100, -2, (BtnPos.Y.Scale), BtnPos.Y.Offset), nil, nil, 0.08)
                        local est = math.floor((math.floor((max * percentage) * max) / max)) + min

                        if min == est then
                            Num.Text = min
                        else
                            Num.Text = est
                        end

                        callback(tonumber(Num.Text))
                    end
                end)

                return {
                    Set = function(value)
                        local percent = 1 - ((max - value) / (max - min))
                        percentage = math.clamp(percent, 0, 1)
                        TextButton:TweenSizeAndPosition(UDim2.new(percentage, 0, 1, 0), UDim2.new(percentage / 100, -2, (TextButton.Position.Y.Scale), TextButton.Position.Y.Offset), nil, nil, 0.08)
                        Num.Text = tostring(value)

                        callback(tonumber(Num.Text))
                    end
                }
            end

            function functions:Textbox(name, placeholder, callback)
                local Textbox = magma:Create("TextLabel", {
                    Name = "Text box",
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.190909088, 0, 2.13571429, 0),
                    Size = UDim2.new(0, 178, 0, 36),
                    Font = Enum.Font.Code,
                    Text = name,
                    TextColor3 = Color3.new(1, 1, 1),
                    TextSize = 14,
                    TextStrokeTransparency = 0.4,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Top,
                    Parent = SectionContents
                })

                local TextBox = magma:Create("TextBox", {
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    BackgroundTransparency = 1,
                    BorderColor3 = Color3.new(0, 0, 0),
                    Position = UDim2.new(0, 0, 0.45999992, 0),
                    Size = UDim2.new(0, 220, 0, 14),
                    ClearTextOnFocus = false,
                    Font = Enum.Font.SourceSans,
                    PlaceholderColor3 = Color3.new(0.764706, 0.764706, 0.764706),
                    PlaceholderText = placeholder or "Type something here!",
                    Text = "",
                    TextColor3 = Color3.new(1, 1, 1),
                    TextSize = 14,
                    TextStrokeTransparency = 0.4,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Textbox
                })

                local Frame = magma:Create("Frame", {
                    BackgroundColor3 = getgenv().WindowThemeColor,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(0, 1, 0, 0),
                    Parent = TextBox
                })

                TextBox.Focused:Connect(function()
                    typing = true
                    Frame.Size = UDim2.new(0, 1, 0, 1)
                    Frame:TweenSizeAndPosition(UDim2.new(0, 220, 0, 1), UDim2.new(-0.009, 0, 1, 0), nil, nil, 0.5)
                end)

                TextBox.FocusLost:Connect(function()
                    typing = false
                    if TextBox.Text ~= "" then
                        Frame:TweenSizeAndPosition(UDim2.new(0, 1, 0, 0), UDim2.new(0, 0, 1, 0), nil, nil, 0.5)
                        callback(TextBox.Text) 
                    end
                end)

                return {
                    Get = function()
                        return TextBox.Text
                    end,

                    Set = function(value)
                        TextBox.Text = value
                    end,

                    Fire = function()
                        callback()
                    end
                }
            end

            function functions:Keybind(name, callback)
                local Keybind = magma:Create("TextLabel", {
                    Name = "Keybind",
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 1.98395073, 0),
                    Size = UDim2.new(0, 102, 0, 12),
                    Font = Enum.Font.Code,
                    Text = name or "keybind",
                    TextColor3 = Color3.new(1, 1, 1),
                    TextSize = 14,
                    TextStrokeTransparency = 0.4,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = SectionContents
                })

                local Button = magma:Create("TextButton", {
                    Name = "Button",
                    BackgroundColor3 = Color3.new(0.176471, 0.176471, 0.176471),
                    BackgroundTransparency = 1,
                    BorderColor3 = Color3.new(0, 0, 0),
                    Position = UDim2.new(1.35386384, 0, -0.298538178, 0),
                    Size = UDim2.new(0, 82, 0, 18),
                    AutoButtonColor = false,
                    Font = Enum.Font.Code,
                    Text = "None",
                    TextColor3 = Color3.new(1, 1, 1),
                    TextSize = 14,
                    TextStrokeTransparency = 0.4,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Parent = Keybind
                })

                getgenv()[name .. "Bind"] = nil
                getgenv()[name .. "Toggle"] = false
                getgenv()[name .. "Pressed"] = false

                local KeyLib = {
                    ["One"] = "1",
                    ["Two"] = "2",
                    ["Three"] = "3",
                    ["Four"] = "4",
                    ["Five"] = "5",
                    ["Six"] = "6",
                    ["Seven"] = "7",
                    ["Eight"] = "8",
                    ["Nine"] = "9",
                    ["Zero"] = "0"
                }

                Button.MouseButton1Click:Connect(function()
                    if getgenv()[name .. "Pressed"] then
                        Button.Text = "None"
                    else
                        Button.Text = "..."
                    end
                    getgenv()[name .. "Bind"] = nil
                    getgenv()[name .. "Pressed"] = not getgenv()[name .. "Pressed"]
                end)

                UserInputService.InputBegan:Connect(function(InputObject, Processed)
                    if getgenv()[name .. "Pressed"] and InputObject.UserInputType == Enum.UserInputType.Keyboard and not Processed then
                        KeyCodeName = InputObject.KeyCode.Name
                        if string.find(KeyCodeName, "Right") then
                            KeyCodeName = string.gsub(KeyCodeName, "Right", "R")
                        elseif string.find(KeyCodeName, "Left") then
                            KeyCodeName = string.gsub(KeyCodeName, "Left", "L")
                        elseif KeyLib[KeyCodeName] then
                            KeyCodeName = KeyLib[KeyCodeName]
                        end
                        Button.Text = KeyCodeName
                        getgenv()[name .. "Bind"] = InputObject
                        getgenv()[name .. "Pressed"] = false
                    end
                end)

                UserInputService.InputBegan:Connect(function(InputObject, Processed)
                    if InputObject == getgenv()[name .. "Bind"] and not Processed then
                        getgenv()[name .. "Toggle"] = not getgenv()[name .. "Toggle"]
                        callback(getgenv()[name .. "Toggle"])
                    end
                end)

                return {
                    Set = function(value)
                        Button.Text = value
                        getgenv()[name .. "Bind"] = Enum.KeyCode[value]
                        getgenv()[name .. "Pressed"] = false
                    end,

                    Fire = function()
                        getgenv()[name .. "Toggle"] = not getgenv()[name .. "Toggle"]
                        callback(getgenv()[name .. "Toggle"])
                    end
                }
            end

            function functions:Dropdown(name, options, callback)
                callback = callback or function() end

                local Dropdown = magma:Create("TextLabel", {
                    Name = "Dropdown",
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 2.39047599, 0),
                    Size = UDim2.new(0, 178, 0, 39),
                    ZIndex = 2,
                    Font = Enum.Font.Code,
                    Text = name,
                    TextColor3 = Color3.new(1, 1, 1),
                    TextSize = 14,
                    TextStrokeTransparency = 0.40000000596046,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Top,
                    Parent = SectionContents
                })

                local Button = magma:Create("TextButton", {
                    Name = "Button",
                    BackgroundColor3 = Color3.new(0.192157, 0.192157, 0.192157),
                    BorderColor3 = Color3.new(0, 0, 0),
                    Position = UDim2.new(-0.0140000004, 0, 0.48, 0),
                    Size = UDim2.new(0, 223, 0, 18),
                    AutoButtonColor = false,
                    Font = Enum.Font.Code,
                    Text = (options[1] and " " .. options[1]) or " ",
                    TextColor3 = Color3.new(1, 1, 1),
                    TextSize = 14,
                    TextStrokeTransparency = 0.40000000596046,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Dropdown,
                })

                local Frame = magma:Create("Frame", {
                    BackgroundColor3 = Color3.new(0.192157, 0.192157, 0.192157),
                    BorderColor3 = Color3.new(0, 0, 0),
                    BorderSizePixel = 1,
                    Position = UDim2.new(0, 0, 1.05, 0),
                    Size = UDim2.new(0, 223, 0, 0),
                    Visible = false,
                    ZIndex = 2,
                    Parent = Button
                })

                local UIListLayout = magma:Create("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Parent = Frame
                })

                local function tweenDropdown(Size, Time)
                    magma.tween(Frame, {Size = UDim2.new(0, 223, 0, (#options - 1) * Size)})
                    for _, TextButton in next, Frame:GetChildren() do
                        if TextButton:IsA("TextButton") and TextButton ~= Button then
                            magma.tween(TextButton, {Size = UDim2.new(0, 223, 0, Size)})
                        end
                    end
                    wait(Time)
                    Frame.Visible = not Frame.Visible
                end

                local function createfunc(Name, Function)
                    local Button = magma:Create("TextButton", {
                        Name = "Button",
                        BackgroundColor3 = Color3.new(0.192157, 0.192157, 0.192157),
                        BorderColor3 = Color3.new(0, 0, 0),
                        BorderSizePixel = 0,
                        Position = UDim2.new(-0.0140000004, 0, 0.519999981, 0),
                        Size = UDim2.new(0, 223, 0, 0),
                        AutoButtonColor = false,
                        Font = Enum.Font.Code,
                        Text = " " .. Name,
                        TextColor3 = Color3.new(1, 1, 1),
                        TextSize = 14,
                        TextStrokeTransparency = 0.40000000596046,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = Frame
                    })

                    Button.MouseButton1Click:Connect(function()
                        Button.Visible = false
                        tweenDropdown(0, 0.01)
                        Frame.Parent.Text = " " .. Name
                        for _, TextButton in next, Frame:GetChildren() do
                            if TextButton:IsA("TextButton") and TextButton ~= Button then
                                TextButton.Visible = true
                            end
                        end
                        Function(Name)
                    end)

                    return Button
                end

                Button.MouseButton1Click:Connect(function()
                    if Frame.Visible then
                        tweenDropdown(0, 0.01)
                    else
                        tweenDropdown(18, 0.02)
                    end
                end)

                for _, TextButton in next, Frame:GetChildren() do
                    if TextButton:IsA("TextButton") and TextButton ~= Button then
                        TextButton.Visible = true
                    end
                end

                for FuncNum, FuncName in next, options do
                    local Func = createfunc(FuncName, callback)
                    if FuncNum == 1 then
                        Func.Visible = false
                    end
                end

                return {  
                    Add = function(value)
                        createfunc(value, callback)
                    end
                }
            end
            
            return functions
        end

        return sectionLibrary
    end

    return windowLibrary
end

return magma
