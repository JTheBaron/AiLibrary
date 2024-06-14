-- Kavo UI-like Library with UI Elements

local Library = {}

-- Create the main UI library
function Library:CreateLib(title, theme)
    local window = Instance.new("ScreenGui")
    window.Name = title
    window.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local mainFrame = Instance.new("Frame", window)
    mainFrame.Size = UDim2.new(0.4, 0, 0.6, 0)
    mainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
    mainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    
    local titleLabel = Instance.new("TextLabel", mainFrame)
    titleLabel.Text = title
    titleLabel.Size = UDim2.new(1, 0, 0.1, 0)
    titleLabel.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.Font = Enum.Font.SourceSans
    titleLabel.TextSize = 24

    local tabHolder = Instance.new("Frame", mainFrame)
    tabHolder.Size = UDim2.new(1, 0, 0.9, 0)
    tabHolder.Position = UDim2.new(0, 0, 0.1, 0)
    tabHolder.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)

    function window:NewTab(name)
        local tabButton = Instance.new("TextButton", tabHolder)
        tabButton.Text = name
        tabButton.Size = UDim2.new(0.2, 0, 0.1, 0)
        tabButton.BackgroundColor3 = Color3.new(0.25, 0.25, 0.25)
        tabButton.TextColor3 = Color3.new(1, 1, 1)
        tabButton.Font = Enum.Font.SourceSans
        tabButton.TextSize = 20

        local tabFrame = Instance.new("Frame", tabHolder)
        tabFrame.Size = UDim2.new(1, 0, 0.9, 0)
        tabFrame.Position = UDim2.new(0, 0, 0.1, 0)
        tabFrame.Visible = false
        tabFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)

        tabButton.MouseButton1Click:Connect(function()
            for _, child in pairs(tabHolder:GetChildren()) do
                if child:IsA("Frame") then
                    child.Visible = false
                end
            end
            tabFrame.Visible = true
        end)

        local tab = {}
        tab.frame = tabFrame

        function tab:NewSection(name)
            local sectionFrame = Instance.new("Frame", tabFrame)
            sectionFrame.Size = UDim2.new(1, -10, 0.2, 0)
            sectionFrame.Position = UDim2.new(0, 5, 0, 5)
            sectionFrame.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)

            local sectionTitle = Instance.new("TextLabel", sectionFrame)
            sectionTitle.Text = name
            sectionTitle.Size = UDim2.new(1, 0, 0.2, 0)
            sectionTitle.BackgroundColor3 = Color3.new(0.35, 0.35, 0.35)
            sectionTitle.TextColor3 = Color3.new(1, 1, 1)
            sectionTitle.Font = Enum.Font.SourceSans
            sectionTitle.TextSize = 18

            local section = {}
            section.frame = sectionFrame

            function section:NewButton(text, info, callback)
                local button = Instance.new("TextButton", sectionFrame)
                button.Text = text
                button.Size = UDim2.new(1, -10, 0.2, 0)
                button.Position = UDim2.new(0, 5, 0.25, 0)
                button.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
                button.TextColor3 = Color3.new(1, 1, 1)
                button.Font = Enum.Font.SourceSans
                button.TextSize = 18

                button.MouseButton1Click:Connect(function()
                    callback()
                end)
                return button
            end

            function section:NewToggle(text, info, callback)
                local toggle = Instance.new("TextButton", sectionFrame)
                toggle.Text = text
                toggle.Size = UDim2.new(1, -10, 0.2, 0)
                toggle.Position = UDim2.new(0, 5, 0.5, 0)
                toggle.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
                toggle.TextColor3 = Color3.new(1, 1, 1)
                toggle.Font = Enum.Font.SourceSans
                toggle.TextSize = 18

                local state = false
                toggle.MouseButton1Click:Connect(function()
                    state = not state
                    callback(state)
                    toggle.BackgroundColor3 = state and Color3.new(0.2, 0.6, 0.2) or Color3.new(0.4, 0.4, 0.4)
                end)
                return toggle
            end

            function section:NewSlider(text, info, max, min, callback)
                local sliderFrame = Instance.new("Frame", sectionFrame)
                sliderFrame.Size = UDim2.new(1, -10, 0.2, 0)
                sliderFrame.Position = UDim2.new(0, 5, 0.75, 0)
                sliderFrame.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)

                local sliderText = Instance.new("TextLabel", sliderFrame)
                sliderText.Text = text
                sliderText.Size = UDim2.new(0.5, 0, 1, 0)
                sliderText.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
                sliderText.TextColor3 = Color3.new(1, 1, 1)
                sliderText.Font = Enum.Font.SourceSans
                sliderText.TextSize = 18

                local slider = Instance.new("TextButton", sliderFrame)
                slider.Text = ""
                slider.Size = UDim2.new(0.5, 0, 1, 0)
                slider.Position = UDim2.new(0.5, 0, 0, 0)
                slider.BackgroundColor3 = Color3.new(0.6, 0.6, 0.6)

                local dragging = false
                local function update(input)
                    local delta = input.Position.X - sliderFrame.AbsolutePosition.X
                    local percentage = math.clamp(delta / sliderFrame.AbsoluteSize.X, 0, 1)
                    slider.Size = UDim2.new(percentage, 0, 1, 0)
                    local value = math.floor((min + (max - min) * percentage) + 0.5)
                    callback(value)
                end

                slider.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                    end
                end)

                slider.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)

                sliderFrame.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        update(input)
                    end
                end)
                return sliderFrame
            end

            return section
        end

        return tab
    end

    return window
end

return Library
