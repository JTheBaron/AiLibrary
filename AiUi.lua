-- Roblox Extended UI Library

local SimpleUILibrary = {}
SimpleUILibrary.__index = SimpleUILibrary

function SimpleUILibrary.new()
    local self = setmetatable({}, SimpleUILibrary)

    self.gui = Instance.new("ScreenGui")
    self.gui.Name = "SimpleUI"
    self.gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    self.mainFrame = Instance.new("Frame")
    self.mainFrame.Size = UDim2.new(0.4, 0, 0.4, 0)
    self.mainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
    self.mainFrame.BackgroundColor3 = Color3.new(1, 1, 1)
    self.mainFrame.Parent = self.gui

    self.openButton = Instance.new("TextButton")
    self.openButton.Size = UDim2.new(0, 100, 0, 50)
    self.openButton.Position = UDim2.new(0, 0, 0, 0)
    self.openButton.BackgroundColor3 = Color3.new(0, 1, 0)
    self.openButton.Text = "Open"
    self.openButton.Parent = self.gui

    self.closeButton = Instance.new("TextButton")
    self.closeButton.Size = UDim2.new(0, 50, 0, 50)
    self.closeButton.Position = UDim2.new(0.9, 0, 0, 0)
    self.closeButton.BackgroundColor3 = Color3.new(1, 0, 0)
    self.closeButton.Text = "Close"
    self.closeButton.Parent = self.mainFrame

    self.openButton.MouseButton1Click:Connect(function()
        self.mainFrame.Visible = true
    end)

    self.closeButton.MouseButton1Click:Connect(function()
        self.mainFrame.Visible = false
    end)

    local dragging = false
    local dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        self.mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    self.mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.mainFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    self.mainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    self.tabs = {}

    return self
end

function SimpleUILibrary:AddTab(name)
    local tab = {}

    tab.button = Instance.new("TextButton")
    tab.button.Size = UDim2.new(0, 100, 0, 50)
    tab.button.BackgroundColor3 = Color3.new(0, 0, 1)
    tab.button.Text = name
    tab.button.Parent = self.mainFrame

    if #self.tabs == 0 then
        tab.button.Position = UDim2.new(0, 0, 0, 50)
    else
        tab.button.Position = UDim2.new(0, #self.tabs * 100, 0, 50)
    end

    tab.content = Instance.new("Frame")
    tab.content.Size = UDim2.new(1, 0, 1, -100)
    tab.content.Position = UDim2.new(0, 0, 0, 100)
    tab.content.BackgroundColor3 = Color3.new(1, 1, 1)
    tab.content.Visible = false
    tab.content.Parent = self.mainFrame

    tab.button.MouseButton1Click:Connect(function()
        for _, t in ipairs(self.tabs) do
            t.content.Visible = false
        end
        tab.content.Visible = true
    end)

    table.insert(self.tabs, tab)

    return tab
end

function SimpleUILibrary:AddButton(tab, name, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 200, 0, 50)
    button.BackgroundColor3 = Color3.new(0.8, 0.8, 0.8)
    button.Text = name
    button.Parent = tab.content

    local buttonCount = #tab.content:GetChildren()
    button.Position = UDim2.new(0, 10, 0, (buttonCount - 1) * 60)

    button.MouseButton1Click:Connect(callback)

    return button
end

function SimpleUILibrary:AddToggle(tab, name, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(0, 200, 0, 50)
    toggleFrame.BackgroundColor3 = Color3.new(0.8, 0.8, 0.8)
    toggleFrame.Parent = tab.content

    local toggleText = Instance.new("TextLabel")
    toggleText.Size = UDim2.new(0.7, 0, 1, 0)
    toggleText.Position = UDim2.new(0, 10, 0, 0)
    toggleText.Text = name
    toggleText.Parent = toggleFrame

    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0.2, 0, 1, 0)
    toggleButton.Position = UDim2.new(0.8, 0, 0, 0)
    toggleButton.BackgroundColor3 = Color3.new(1, 0, 0)
    toggleButton.Text = "Off"
    toggleButton.Parent = toggleFrame

    local isToggled = false

    toggleButton.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        toggleButton.BackgroundColor3 = isToggled and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
        toggleButton.Text = isToggled and "On" or "Off"
        callback(isToggled)
    end)

    local buttonCount = #tab.content:GetChildren()
    toggleFrame.Position = UDim2.new(0, 10, 0, (buttonCount - 1) * 60)

    return toggleButton
end

function SimpleUILibrary:AddSlider(tab, name, minValue, maxValue, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(0, 200, 0, 50)
    sliderFrame.BackgroundColor3 = Color3.new(0.8, 0.8, 0.8)
    sliderFrame.Parent = tab.content

    local sliderText = Instance.new("TextLabel")
    sliderText.Size = UDim2.new(0.7, 0, 1, 0)
    sliderText.Position = UDim2.new(0, 10, 0, 0)
    sliderText.Text = name
    sliderText.Parent = sliderFrame

    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(0.2, 0, 1, 0)
    slider.Position = UDim2.new(0.8, 0, 0, 0)
    slider.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
    slider.Parent = sliderFrame

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 10, 1, 0)
    knob.Position = UDim2.new(0, 0, 0, 0)
    knob.BackgroundColor3 = Color3.new(0, 0, 0)
    knob.Parent = slider

    local dragging = false

    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)

    knob.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    slider.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local scale = (input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X
            scale = math.clamp(scale, 0, 1)
            knob.Position = UDim2.new(scale, 0, 0, 0)
            local value = minValue + (maxValue - minValue) * scale
            callback(value)
        end
    end)

    local buttonCount = #tab.content:GetChildren()
    sliderFrame.Position = UDim2.new(0, 10, 0, (buttonCount - 1) * 60)

    return slider
end

return SimpleUILibrary
