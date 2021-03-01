local Library = {}

function Library:CreateWindow(Name)
    Name = Name or "Bracket Lib"
    local WinTypes = {}
    local windowdrag = false
    local sliderdrag = false

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
    core.Position = UDim2.new(0.280864209, 0, 0.243572399, 0)
    core.Size = UDim2.new(0, 600, 0, 399)

    innercore.Name = "innercore"
    innercore.Parent = core
    innercore.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    innercore.BorderColor3 = Color3.fromRGB(3, 3, 3)
    innercore.Position = UDim2.new(0.0166666675, 0, 0.0726817027, 0)
    innercore.Size = UDim2.new(0, 580, 0, 360)

    title.Name = "title"
    title.Parent = core
    title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundTransparency = 1.000
    title.BorderSizePixel = 0
    title.Position = UDim2.new(0.0166666675, 0, 0, 0)
    title.Size = UDim2.new(0, 580, 0, 29)
    title.Font = Enum.Font.SourceSans
    title.Text = Name
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 18.000
    title.TextXAlignment = Enum.TextXAlignment.Left

    tabs.Name = "tabs"
    tabs.Parent = core
    tabs.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    tabs.BorderColor3 = Color3.fromRGB(0, 0, 0)
    tabs.Position = UDim2.new(0.0166666675, 0, 0.0726817027, 0)
    tabs.Size = UDim2.new(0, 580, 0, 30)

    UIListLayout.Parent = tabs
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    containers.Name = "containers"
    containers.Parent = core
    containers.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    containers.BackgroundTransparency = 1.000
    containers.BorderSizePixel = 0
    containers.Position = UDim2.new(0.0166666675, 0, 0.147869676, 0)
    containers.Size = UDim2.new(0, 580, 0, 330)

    local userinputservice = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
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
            BracketLib.Enabled = not BracketLib.Enabled
        end
    end)

    function WinTypes:CreateTab(Name)
        Name = Name or "Tab"
        local TabTypes = {}

        local tab = Instance.new("TextButton")
        local container = Instance.new("Frame")
        local UIGridLayout = Instance.new("UIGridLayout")
        local UIPadding = Instance.new("UIPadding")
        
        tab.Name = "tab_" .. Name
        tab.Parent = tabs
        tab.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        tab.BorderColor3 = Color3.fromRGB(0, 0, 0)
        tab.Size = UDim2.new(0, tabs.AbsoluteSize.X / (#tabs:GetChildren() - 1), 0, 30)
        tab.Font = Enum.Font.SourceSans
        tab.Text = Name
        tab.TextColor3 = Color3.fromRGB(255, 255, 255)
        tab.TextSize = 18.000

        container.Name = "container_" .. Name
        container.Parent = containers
        container.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        container.BackgroundTransparency = 1.000
        container.BorderSizePixel = 0
        container.Size = UDim2.new(0, 580, 0, 330)
        container.Visible = false

        UIGridLayout.Parent = container
        UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIGridLayout.CellPadding = UDim2.new(0, 20, 0, 0)
        UIGridLayout.CellSize = UDim2.new(0, 270, 0, 310)
        UIGridLayout.FillDirectionMaxCells = 2

        UIPadding.Parent = container
        UIPadding.PaddingLeft = UDim.new(0, 10)
        UIPadding.PaddingTop = UDim.new(0, 10)

        for i,v in pairs(tabs:GetChildren()) do
            if (v.Name:find("tab") and v.Name ~= "tab_" .. Name) then
                v.Size = UDim2.new(0, tabs.AbsoluteSize.X / (#tabs:GetChildren() - 1), 0, 30)
            end
        end

        tab.MouseButton1Click:Connect(function()
            container.Visible = true
            tab.BackgroundColor3 = Color3.fromRGB(0, 85, 127)

            for i,v in pairs(containers:GetChildren()) do
                if (v.Name:find("container") and v.Name ~= "container_" .. Name) then
                    v.Visible = false
                end
            end
            for i,v in pairs(tabs:GetChildren()) do
                if (v.Name:find("tab") and v.Name ~= "tab_" .. Name) then
                    v.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                end
            end
        end)

        function TabTypes:CreateGroupbox(Name)
            Name = Name or "grep box"
            local GroupTypes = {}

            local groupbox = Instance.new("Frame")
            local title_2 = Instance.new("TextLabel")
            local groupbox_container = Instance.new("ScrollingFrame")
            local UIPadding_2 = Instance.new("UIPadding")
            local UIListLayout_2 = Instance.new("UIListLayout")

            groupbox.Name = "groupbox"
            groupbox.Parent = container
            groupbox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            groupbox.BorderColor3 = Color3.fromRGB(0, 0, 0)
            groupbox.Size = UDim2.new(0, 100, 0, 100)

            title_2.Name = "title"
            title_2.Parent = groupbox
            title_2.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            title_2.BorderSizePixel = 0
            title_2.Size = UDim2.new(0, 270, 0, 25)
            title_2.Font = Enum.Font.SourceSans
            title_2.Text = Name
            title_2.TextColor3 = Color3.fromRGB(255, 255, 255)
            title_2.TextSize = 16.000

            groupbox_container.Name = "groupbox_container"
            groupbox_container.Parent = groupbox
            groupbox_container.Active = true
            groupbox_container.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            groupbox_container.BackgroundTransparency = 1.000
            groupbox_container.BorderSizePixel = 0
            groupbox_container.Position = UDim2.new(0, 0, 0.0806451589, 0)
            groupbox_container.Size = UDim2.new(0, 270, 0, 285)
            groupbox_container.BottomImage = ""
            groupbox_container.CanvasSize = UDim2.new(0, 0, 0, 0)
            groupbox_container.ScrollBarThickness = 3
            groupbox_container.TopImage = ""

            UIPadding_2.Parent = groupbox_container
            UIPadding_2.PaddingLeft = UDim.new(0, 10)
            UIPadding_2.PaddingTop = UDim.new(0, 10)

            UIListLayout_2.Parent = groupbox_container
            UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout_2.Padding = UDim.new(0, 10)

            function GroupTypes:CreateToggle(Name, Callback)
                Name = Name or "Toggle"
                Callback = Callback or function(s)
                    print(s)
                end
                local Toggled = false

                local toggle = Instance.new("Frame")
                local title_3 = Instance.new("TextLabel")
                local checkbox = Instance.new("Frame")
                local main = Instance.new("TextButton")
                
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
                checkbox.BackgroundColor3 = Color3.fromRGB(0, 85, 127)
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

                main.MouseButton1Click:Connect(function()
                    Toggled = not Toggled
                    checkbox.Visible = Toggled

                    if (Callback) then
                        Callback(Toggled)
                    end
                end)

                groupbox_container.CanvasSize = UDim2.new(0, 0, 0, UIListLayout_2.AbsoluteContentSize.Y + 20)
            end

            function GroupTypes:CreateButton(Name, Callback)
                Name = Name or "Button"
                Callback = Callback or function()
                    print("callback")
                end

                local button = Instance.new("TextButton")

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

                button.MouseButton1Click:Connect(function()
                    if (Callback) then
                        Callback()
                    end
                end)

                groupbox_container.CanvasSize = UDim2.new(0, 0, 0, UIListLayout_2.AbsoluteContentSize.Y + 20)
            end

            return GroupTypes
        end

        return TabTypes
    end

    return WinTypes
end

return Library
