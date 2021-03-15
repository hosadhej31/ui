local Library = {}

function Library:CreateWindow(WOptions)
    WOptions.Name = WOptions.Name or "Bracket Lib"
    WOptions.Color = WOptions.Color or Color3.fromRGB(0, 85, 127)
    local WinTypes = {}
    local windowdrag = false
    local sliderdrag = false
    local oldcolor = WOptions.Color

    local BracketLib = Instance.new("ScreenGui")
    local core = Instance.new("Frame")
    local innercore = Instance.new("Frame")
    local title = Instance.new("TextLabel")
    local tabs = Instance.new("Frame")
    local UIListLayout = Instance.new("UIListLayout")
    local containers = Instance.new("Frame")

    BracketLib.Name = "BracketLib"
    BracketLib.Parent = game.CoreGui
    BracketLib.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    core.Name = "core"
    core.Parent = BracketLib
    core.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    core.BorderColor3 = Color3.fromRGB(0, 0, 0)
    core.Position = UDim2.new(0.280864209, 0, 0.133572399, 0)
    core.Size = UDim2.new(0, 600, 0, 629)

    innercore.Name = "innercore"
    innercore.Parent = core
    innercore.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    innercore.BorderColor3 = Color3.fromRGB(3, 3, 3)
    innercore.Position = UDim2.new(0.0166666675, 0, 0.0526817027, 0)
    innercore.Size = UDim2.new(0, 580, 0, 585)

    title.Name = "title"
    title.Parent = core
    title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundTransparency = 1.000
    title.BorderSizePixel = 0
    title.Position = UDim2.new(0.0166666675, 0, 0, 0)
    title.Size = UDim2.new(0, 580, 0, 29)
    title.Font = Enum.Font.SourceSans
    title.Text = WOptions.Name
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 18.000
    title.TextXAlignment = Enum.TextXAlignment.Left

    tabs.Name = "tabs"
    tabs.Parent = core
    tabs.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    tabs.BorderColor3 = Color3.fromRGB(0, 0, 0)
    tabs.Position = UDim2.new(0.0166666675, 0, 0.0526817027, 0)
    tabs.Size = UDim2.new(0, 580, 0, 30)

    UIListLayout.Parent = tabs
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    containers.Name = "containers"
    containers.Parent = core
    containers.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    containers.BackgroundTransparency = 1.000
    containers.BorderSizePixel = 0
    containers.Position = UDim2.new(0.0166666675, 0, 0.087869676, 0)
    containers.Size = UDim2.new(0, 580, 0, 531)

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
            core.Position = Position
        end
    end)

    userinputservice.InputBegan:connect(function(input)
        if input.KeyCode == Enum.KeyCode.RightShift then
            local req = require(game.ReplicatedFirst.ClientModules.Old.framework.input)
            BracketLib.Enabled = not BracketLib.Enabled

            if BracketLib.Enabled and config.misc.lockuserinput then
                req.mouse.free()
                req.mouse.show()
            else
                if workspace.CurrentCamera:FindFirstChild("Left Arm") then
                    req.mouse.lockcenter()
                    req.mouse.hide()
                end
            end
        end
    end)

    function WinTypes:CreateTab(Name, tworows)
        Name = Name or "Tab"
        tworows = tworows or false
        local TabTypes = {}

        local tab = Instance.new("TextButton")
        local UIGradient = Instance.new("UIGradient")
        local title_tab = Instance.new("TextLabel")
        local container = Instance.new("Frame")
        local UIPadding = Instance.new("UIPadding")

        tab.Name = "tab_" .. Name
        tab.Parent = tabs
        tab.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        tab.BorderColor3 = Color3.fromRGB(0, 0, 0)
        tab.Size = UDim2.new(0, tabs.AbsoluteSize.X / (#tabs:GetChildren() - 1), 0, 30)
        tab.Text = ""

        title_tab.Name = "title"
        title_tab.Parent = tab
        title_tab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        title_tab.BackgroundTransparency = 1.000
        title_tab.BorderSizePixel = 0
        title_tab.Position = UDim2.new(0, 0, 0, 0)
        title_tab.Size = UDim2.new(1, 0, 1, 0)
        title_tab.Font = Enum.Font.SourceSans
        title_tab.Text = Name
        title_tab.TextColor3 = Color3.fromRGB(255, 255, 255)
        title_tab.TextSize = 18.000
        title_tab.TextXAlignment = Enum.TextXAlignment.Center

        UIGradient.Name = "tab_" .. Name
        UIGradient.Rotation = 90
        UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(90, 90, 90))}
        UIGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.00), NumberSequenceKeypoint.new(1.00, 0.00)}
        UIGradient.Parent = tab
        UIGradient.Enabled = false

        container.Name = "container_" .. Name
        container.Parent = containers
        container.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        container.BackgroundTransparency = 1.000
        container.BorderSizePixel = 0
        container.Size = UDim2.new(0, 580, 0, 585)
        container.Visible = false

        UIPadding.Parent = container
        UIPadding.PaddingLeft = UDim.new(0, 10)
        UIPadding.PaddingTop = UDim.new(0, 20)

        game:GetService("RunService").RenderStepped:Connect(function()
            for i,v in pairs(tabs:GetChildren()) do
                if (v.Name:find("tab") and v.BackgroundColor3 == oldcolor and oldcolor ~= WOptions.Color) then
                    v.BackgroundColor3 = WOptions.Color
                end
            end
        end)

        for i,v in pairs(tabs:GetChildren()) do
            if (v.Name:find("tab") and v.Name ~= "tab_" .. Name) then
                v.Size = UDim2.new(0, tabs.AbsoluteSize.X / (#tabs:GetChildren() - 1), 0, 30)
            end
        end

        tab.MouseButton1Click:Connect(function()
            container.Visible = true
            oldcolor = WOptions.Color
            tab.TextColor3 = Color3.fromRGB(255, 255, 255)
            tab.BackgroundColor3 = oldcolor
            UIGradient.Enabled = true

            for i,v in pairs(containers:GetChildren()) do
                if (v.Name:find("container") and v.Name ~= "container_" .. Name) then
                    v.Visible = false
                end
            end
            for i,v in pairs(tabs:GetChildren()) do
                if (v.Name:find("tab") and v.Name ~= "tab_" .. Name) then
                    v.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                    for i2,v2 in pairs(v:GetChildren()) do
                        if (v2.Name:find("tab") and v2.Name ~= "tab_" .. Name) then
                            v2.Enabled = false
                        else
                            v2.TextColor3 = Color3.fromRGB(166, 166, 166)
                        end
                    end
                end
            end
        end)

        function TabTypes:CreateGroupbox()
            local GroupBoxTypes = {}

            local UIGridLayout = Instance.new("UIGridLayout")
            local groupbox = Instance.new("Frame")
            local UIGradient = Instance.new("UIGradient")
            local title_2 = Instance.new("TextLabel")
            local UIListLayout = Instance.new("UIListLayout")

            UIGridLayout.Parent = container
            UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
            UIGridLayout.CellPadding = UDim2.new(0, 10, 0, 10)
            
            if (tworows) then
                UIGridLayout.CellSize = UDim2.new(0, 275, 0, 256)
            else
                UIGridLayout.CellSize = UDim2.new(0, 275, 0, 466)
            end

            UIGridLayout.FillDirectionMaxCells = 2

            groupbox.Name = "groupbox"
            groupbox.Parent = container
            groupbox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            groupbox.BorderColor3 = Color3.fromRGB(0, 0, 0)
            groupbox.Size = UDim2.new(0, 100, 0, 100)

            UIGradient.Rotation = 90
            UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(150, 150, 150))}
            UIGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.00), NumberSequenceKeypoint.new(1.00, 0.00)}
            UIGradient.Parent = groupbox

            title_2.Name = "title"
            title_2.Parent = groupbox
            title_2.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            title_2.BorderSizePixel = 0
            title_2.Size = UDim2.new(0, 275, 0, 20)
            title_2.Font = Enum.Font.SourceSans
            title_2.Text = ""

            UIListLayout.Parent = title_2
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout.FillDirection = Enum.FillDirection.Horizontal

            function GroupBoxTypes:CreateGroupboxTab(Name)
                local GroupTypes = {}
                Name = Name or "Tab"

                local tab = Instance.new("TextButton")
                local UIGradient = Instance.new("UIGradient")
                local title_tab = Instance.new("TextLabel")
                local groupbox_container = Instance.new("ScrollingFrame")
                local UIPadding = Instance.new("UIPadding")
                local UIListLayout_2 = Instance.new("UIListLayout")

                tab.Name = "tab_" .. Name
                tab.Parent = title_2
                tab.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                tab.BorderColor3 = Color3.fromRGB(0, 0, 0)
                tab.Size = UDim2.new(0, title_2.AbsoluteSize.X / (#title_2:GetChildren() - 1), 0, 20)
                tab.Text = ""

                title_tab.Name = "title"
                title_tab.Parent = tab
                title_tab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                title_tab.BackgroundTransparency = 1.000
                title_tab.BorderSizePixel = 0
                title_tab.Position = UDim2.new(0, 0, 0, 0)
                title_tab.Size = UDim2.new(1, 0, 1, 0)
                title_tab.Font = Enum.Font.SourceSans
                title_tab.Text = Name
                title_tab.TextColor3 = Color3.fromRGB(255, 255, 255)
                title_tab.TextSize = 18.000
                title_tab.TextXAlignment = Enum.TextXAlignment.Center

                UIGradient.Name = "tab_" .. Name
                UIGradient.Rotation = 90
                UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(90, 90, 90))}
                UIGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.00), NumberSequenceKeypoint.new(1.00, 0.00)}
                UIGradient.Parent = tab
                UIGradient.Enabled = false

                groupbox_container.Name = "groupbox_" .. Name
                groupbox_container.Parent = groupbox
                groupbox_container.Active = true
                groupbox_container.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                groupbox_container.BackgroundTransparency = 1.000
                groupbox_container.BorderSizePixel = 0
                groupbox_container.Position = UDim2.new(0, 0, 0, 20)
                groupbox_container.Visible = false

                if (tworows) then
                    groupbox_container.Size = UDim2.new(0, 275, 0, 231)
                else
                    groupbox_container.Size = UDim2.new(0, 275, 0, 441)
                end

                groupbox_container.BottomImage = ""
                groupbox_container.CanvasSize = UDim2.new(0, 0, 0, 0)
                groupbox_container.ScrollBarThickness = 3
                groupbox_container.TopImage = ""

                UIPadding.Parent = groupbox_container
                UIPadding.PaddingLeft = UDim.new(0, 10)
                UIPadding.PaddingTop = UDim.new(0, 10)

                UIListLayout_2.Parent = groupbox_container
                UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
                UIListLayout_2.Padding = UDim.new(0, 10)

                game:GetService("RunService").RenderStepped:Connect(function()
                    for i,v in pairs(title_2:GetChildren()) do
                        if (v.Name:find("tab") and v.BackgroundColor3 == oldcolor and oldcolor ~= WOptions.Color) then
                            v.BackgroundColor3 = WOptions.Color
                        end
                    end
                end)
        
                for i,v in pairs(title_2:GetChildren()) do
                    if (v.Name:find("tab") and v.Name ~= "tab_" .. Name) then
                        v.Size = UDim2.new(0, title_2.AbsoluteSize.X / (#title_2:GetChildren() - 1), 0, 20)
                    end
                end
        
                tab.MouseButton1Click:Connect(function()
                    groupbox_container.Visible = true
                    oldcolor = WOptions.Color
                    title_tab.TextColor3 = Color3.fromRGB(255, 255, 255)
                    tab.BackgroundColor3 = oldcolor
                    UIGradient.Enabled = true
        
                    for i,v in pairs(groupbox:GetChildren()) do
                        if (v.Name:find("groupbox") and v.Name ~= "groupbox_" .. Name) then
                            v.Visible = false
                        end
                    end
                    for i,v in pairs(title_2:GetChildren()) do
                        if (v.Name:find("tab") and v.Name ~= "tab_" .. Name) then
                            v.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                            for i2,v2 in pairs(v:GetChildren()) do
                                if (v2.Name:find("tab") and v2.Name ~= "tab_" .. Name) then
                                    v2.Enabled = false
                                else
                                    v.TextColor3 = Color3.fromRGB(166, 166, 166)
                                end
                            end
                        end
                    end
                end)

                function GroupTypes:CreateToggle(Name, Callback)
                    Name = Name or "Toggle"
                    Callback = Callback or function(s)
                        print(s)
                    end
                    local Toggled = false
                    local ToggleTypes = {}
    
                    local toggle = Instance.new("Frame")
                    local UIGradient = Instance.new("UIGradient")
                    local UIGradient_2 = Instance.new("UIGradient")
                    local title_3 = Instance.new("TextLabel")
                    local checkbox = Instance.new("Frame")
                    local main = Instance.new("TextButton")
    
                    UIGradient.Rotation = 90
                    UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(90, 90, 90))}
                    UIGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.00), NumberSequenceKeypoint.new(1.00, 0.00)}
                    UIGradient.Parent = toggle
    
                    UIGradient_2.Rotation = 90
                    UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(90, 90, 90))}
                    UIGradient_2.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.00), NumberSequenceKeypoint.new(1.00, 0.00)}
                    UIGradient_2.Parent = checkbox
                    
                    toggle.Name = "toggle"
                    toggle.Parent = groupbox_container
                    toggle.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
                    toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    toggle.Size = UDim2.new(0, 15, 0, 15)
    
                    title_3.Name = "title"
                    title_3.Parent = toggle
                    title_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    title_3.BackgroundTransparency = 1.000
                    title_3.Position = UDim2.new(1.39999998, 0, 0, 0)
                    title_3.Size = UDim2.new(0, 229, 0, 15)
                    title_3.Font = Enum.Font.SourceSans
                    title_3.Text = Name
                    title_3.TextColor3 = Color3.fromRGB(255, 255, 255)
                    title_3.TextSize = 16.000
                    title_3.TextXAlignment = Enum.TextXAlignment.Left
    
                    checkbox.Name = "checkbox"
                    checkbox.Parent = toggle
                    checkbox.BackgroundColor3 = WOptions.Color
                    checkbox.BorderSizePixel = 0
                    checkbox.Size = UDim2.new(0, 15, 0, 15)
                    checkbox.Visible = false
    
                    main.Name = "main"
                    main.Parent = toggle
                    main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    main.BackgroundTransparency = 1.000
                    main.BorderSizePixel = 0
                    main.Size = UDim2.new(0, 251, 0, 15)
                    main.Font = Enum.Font.SourceSans
                    main.Text = ""
                    main.TextColor3 = Color3.fromRGB(255, 255, 255)
                    main.TextSize = 14.000
    
                    game:GetService("RunService").Heartbeat:Connect(function()
                        checkbox.BackgroundColor3 = WOptions.Color
                    end)
    
                    function ToggleTypes:SetState(state)
                        Toggled = state
                        checkbox.Visible = Toggled
    
                        if (Callback) then
                            Callback(Toggled)
                        end
                    end
    
                    function ToggleTypes:GetState()
                        return Toggled
                    end
    
                    main.MouseButton1Click:Connect(function()
                        Toggled = not Toggled
                        checkbox.Visible = Toggled
    
                        if (Callback) then
                            Callback(Toggled)
                        end
                    end)
    
                    groupbox_container.CanvasSize = UDim2.new(0, 0, 0, UIListLayout_2.AbsoluteContentSize.Y + 20)
                    return ToggleTypes
                end
    
                function GroupTypes:CreateButton(Name, Callback)
                    Name = Name or "Button"
                    Callback = Callback or function()
                        print("callback")
                    end
    
                    local button = Instance.new("TextButton")
                    local UIGradient = Instance.new("UIGradient")
    
                    button.Name = "button"
                    button.Parent = groupbox_container
                    button.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
                    button.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    button.Position = UDim2.new(0.0370370373, 0, 0.19298245, 0)
                    button.Size = UDim2.new(0, 250, 0, 15)
                    button.Font = Enum.Font.SourceSans
                    button.Text = Name
                    button.TextColor3 = Color3.fromRGB(255, 255, 255)
                    button.TextSize = 16.000
    
                    UIGradient.Rotation = 90
                    UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(90, 90, 90))}
                    UIGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.00), NumberSequenceKeypoint.new(1.00, 0.00)}
                    UIGradient.Parent = button
    
                    button.MouseButton1Click:Connect(function()
                        if (Callback) then
                            Callback()
                        end
                    end)
    
                    groupbox_container.CanvasSize = UDim2.new(0, 0, 0, UIListLayout_2.AbsoluteContentSize.Y + 20)
                end
    
                function GroupTypes:CreateSlider(Name, Options, Callback)
                    Name = Name or "Slider"
                    Options = Options or {
                        Min = 0,
                        Max = 100,
                        Increments = 1
                    }
                    Callback = Callback or function(e)
                        print(e)
                    end
                    local SliderTypes = {}
                    local SliderValue = 0
                    local Dragging = false
    
                    local slider = Instance.new("Frame")
                    local UIGradient = Instance.new("UIGradient")
                    local UIGradient_2 = Instance.new("UIGradient")
                    local main_2 = Instance.new("Frame")
                    local value = Instance.new("TextLabel")
                    local title_4 = Instance.new("TextLabel")
    
                    UIGradient.Rotation = 90
                    UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(90, 90, 90))}
                    UIGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.00), NumberSequenceKeypoint.new(1.00, 0.00)}
                    UIGradient.Parent = slider
    
                    UIGradient_2.Rotation = 90
                    UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(90, 90, 90))}
                    UIGradient_2.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.00), NumberSequenceKeypoint.new(1.00, 0.00)}
                    UIGradient_2.Parent = main_2
    
                    slider.Name = "slider"
                    slider.Parent = groupbox_container
                    slider.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
                    slider.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    slider.Position = UDim2.new(0.0370370373, 0, 0.122807018, 0)
                    slider.Size = UDim2.new(0, 134, 0, 10)
    
                    main_2.Name = "main"
                    main_2.Parent = slider
                    main_2.BackgroundColor3 = WOptions.Color
                    main_2.BorderSizePixel = 0
                    main_2.Size = UDim2.new(0, 0, 0, 10)
    
                    value.Name = "value"
                    value.Parent = slider
                    value.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    value.BackgroundTransparency = 1.000
                    value.BorderSizePixel = 0
                    value.Position = UDim2.new(0.0370370373, 0, 0.122807018, 0)
                    value.Size = UDim2.new(0, 134, 0, 10)
                    value.Font = Enum.Font.SourceSans
                    value.Text = Options.Min .. "/" .. Options.Max
                    value.TextColor3 = Color3.fromRGB(255, 255, 255)
                    value.TextSize = 16.000
    
                    title_4.Name = "title"
                    title_4.Parent = slider
                    title_4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    title_4.BackgroundTransparency = 1.000
                    title_4.BorderSizePixel = 0
                    title_4.Position = UDim2.new(1.07751286, 0, 0, 0)
                    title_4.Size = UDim2.new(0, 105, 0, 10)
                    title_4.Font = Enum.Font.SourceSans
                    title_4.Text = Name
                    title_4.TextColor3 = Color3.fromRGB(255, 255, 255)
                    title_4.TextSize = 16.000
                    title_4.TextXAlignment = Enum.TextXAlignment.Left
    
                    local function slide(input)
                        local XSize = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
                        local Size = UDim2.new(XSize, 0, 1, 0)
                        local Increment = Options.Increments and 
                        (Options.Max / ((Options.Max - Options.Min) / (Options.Increments * 4))) or 
                        (Options.Max >= 50 and Options.Max / ((Options.Max - Options.Min) / 4)) or 
                        (Options.Max >= 25 and Options.Max / ((Options.Max - Options.Min) / 2)) or 
                        (Options.Max / (Options.Max - Options.Min))
                        local SizeRounded = UDim2.new((math.floor(Size.X.Scale * ((Options.Max / Increment) * 4)) / ((Options.Max / Increment) * 4)), 0, 1, 0)
                        local s = ((SizeRounded.X.Scale * Options.Max) / Options.Max) * (Options.Max - Options.Min) + Options.Min
                        local a = math.round(s * ((Options.Max / Increment) * 4)) / ((Options.Max / Increment) * 4)
                        main_2.Size = SizeRounded
                        SliderValue = s
                        value.Text = tostring(a) .. "/" .. Options.Max
        
                        if (Callback) then
                            Callback(SliderValue)
                        end
                    end
    
                    game:GetService("RunService").Heartbeat:Connect(function()
                        main_2.BackgroundColor3 = WOptions.Color
                    end)
    
                    slider.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            slide(input)
                            Dragging = true
                            sliderdrag = true
                        end
                    end)
        
                    slider.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            Dragging = false
                            sliderdrag = false
                        end
                    end)
        
                    userinputservice.InputChanged:Connect(function(input)
                        if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                            slide(input)
                        end
                    end)
    
                    function SliderTypes:SetValue(Value)
                        SliderValue = Value
                        value.Text = tostring(Value) .. "/" .. Options.Max
                        main_2.Size = UDim2.new(SliderValue / Options.Max, 0, 1, 0)
    
                        if (Callback) then
                            Callback(SliderValue)
                        end
                    end
    
                    function SliderTypes:GetValue()
                        return SliderValue
                    end
    
                    groupbox_container.CanvasSize = UDim2.new(0, 0, 0, UIListLayout_2.AbsoluteContentSize.Y + 20)
                    return SliderTypes
                end
    
                function GroupTypes:CreateLabel(Name)
                    Name = Name or "Label"
    
                    local label = Instance.new("TextLabel")
    
                    label.Name = "label"
    
                    label.Parent = groupbox_container
                    label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    label.BackgroundTransparency = 1.000
                    label.Position = UDim2.new(0.0370370373, 0, 0.280701756, 0)
                    label.Size = UDim2.new(0, 250, 0, 15)
                    label.Font = Enum.Font.SourceSans
                    label.Text = Name
                    label.TextColor3 = Color3.fromRGB(255, 255, 255)
                    label.TextSize = 16.000
    
                    groupbox_container.CanvasSize = UDim2.new(0, 0, 0, UIListLayout_2.AbsoluteContentSize.Y + 20)
                end
    
                function GroupTypes:CreateDropdown(Name, Options, Callback)
                    Name = Name or "Dropdown"
                    Callback = Callback or function(e)
                        print(e)
                    end
                    local SelectedItem = ""
                    local DropTypes = {}
    
                    local UIGradient = Instance.new("UIGradient")
                    local UIGradient_2 = Instance.new("UIGradient")
                    local dropdown_button = Instance.new("Frame")
                    local title_5 = Instance.new("TextLabel")
                    local drop = Instance.new("TextButton")
                    local dropdown_frame = Instance.new("Frame")
                    local UIListLayout_3 = Instance.new("UIListLayout")
    
                    UIGradient.Rotation = 90
                    UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(90, 90, 90))}
                    UIGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.00), NumberSequenceKeypoint.new(1.00, 0.00)}
                    UIGradient.Parent = dropdown_button
    
                    UIGradient_2.Rotation = 90
                    UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(90, 90, 90))}
                    UIGradient_2.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.00), NumberSequenceKeypoint.new(1.00, 0.00)}
                    UIGradient_2.Parent = dropdown_button
    
                    dropdown_button.Name = "dropdown_button"
                    dropdown_button.Parent = groupbox_container
                    dropdown_button.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
                    dropdown_button.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    dropdown_button.Position = UDim2.new(0.0370370373, 0, 0.368421048, 0)
                    dropdown_button.Size = UDim2.new(0, 249, 0, 20)
    
                    title_5.Name = "title"
                    title_5.Parent = dropdown_button
                    title_5.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
                    title_5.BackgroundTransparency = 1.000
                    title_5.BorderSizePixel = 0
                    title_5.Position = UDim2.new(0.0319999494, 0, 0, 0)
                    title_5.Size = UDim2.new(0, 220, 0, 20)
                    title_5.Font = Enum.Font.SourceSans
                    title_5.Text = Name
                    title_5.TextColor3 = Color3.fromRGB(255, 255, 255)
                    title_5.TextSize = 16.000
                    title_5.TextXAlignment = Enum.TextXAlignment.Left
    
                    drop.Name = "drop"
                    drop.Parent = dropdown_button
                    drop.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    drop.BackgroundTransparency = 1.000
                    drop.Position = UDim2.new(0.918902159, 0, 0, 0)
                    drop.Size = UDim2.new(0, 20, 0, 20)
                    drop.Font = Enum.Font.SourceSans
                    drop.Rotation = 180
                    drop.Text = "V"
                    drop.TextColor3 = Color3.fromRGB(255, 255, 255)
                    drop.TextSize = 16.000
    
                    dropdown_frame.Name = "dropdown_frame"
                    dropdown_frame.Parent = groupbox_container
                    dropdown_frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
                    dropdown_frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
                    dropdown_frame.Position = UDim2.new(0.0370370373, 0, 0.473684222, 0)
                    dropdown_frame.Size = UDim2.new(0, 249, 0, 99)
                    dropdown_frame.Visible = false
    
                    UIListLayout_3.Parent = dropdown_frame
                    UIListLayout_3.SortOrder = Enum.SortOrder.LayoutOrder
    
                    if (#Options > 0) then
                        for i,v in pairs(Options) do
                            local item = Instance.new("TextButton")
    
                            item.Name = "item"
                            item.Parent = dropdown_frame
                            item.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
                            item.BackgroundTransparency = 1
                            item.BorderColor3 = Color3.fromRGB(0, 0, 0)
                            item.Position = UDim2.new(0, 0, 0.808080792, 0)
                            item.Size = UDim2.new(0, 249, 0, 20)
                            item.Font = Enum.Font.SourceSans
                            item.Text = v
                            item.TextColor3 = Color3.fromRGB(255, 255, 255)
                            item.TextSize = 16.000
    
                            item.MouseButton1Click:Connect(function()
                                SelectedItem = v
                                title_5.Text = Name .. ": " .. SelectedItem
    
                                if (Callback) then
                                    Callback(v)
                                end
                            end)
    
                            dropdown_frame.Size = UDim2.new(0, 249, 0, UIListLayout_3.AbsoluteContentSize.Y)
                        end
                    end
                    
                    function DropTypes:SetItem(item)
                        SelectedItem = item
                        title_5.Text = Name .. ": " .. SelectedItem
    
                        if (Callback) then
                            Callback(item)
                        end
                    end
    
                    function DropTypes:GetItem()
                        return SelectedItem
                    end
    
                    drop.MouseButton1Click:Connect(function()
                        dropdown_frame.Visible = not dropdown_frame.Visible
                        drop.Rotation = drop.Rotation - 180
                        groupbox_container.CanvasSize = UDim2.new(0, 0, 0, UIListLayout_2.AbsoluteContentSize.Y + 20)
                    end)
    
                    groupbox_container.CanvasSize = UDim2.new(0, 0, 0, UIListLayout_2.AbsoluteContentSize.Y + 20)
                    return DropTypes
                end
    
                return GroupTypes
            end

            return GroupBoxTypes
        end

        return TabTypes
    end

    function WinTypes:UpdateMainColor(Color)
        WOptions.Color = Color
    end

    return WinTypes
end

return Library
