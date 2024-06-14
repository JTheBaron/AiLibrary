-- Simplified Kavo UI-like Library with UI Elements

local Library = {}

-- Create the main UI library
function Library:CreateLib(title, theme)
    local window = Instance.new("ScreenGui")
    window.Name = title
    window.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0.4, 0, 0.6, 0)
    mainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
    mainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    mainFrame.Parent = window

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = title
    titleLabel.Size = UDim2.new(1, 0, 0.1, 0)
    titleLabel.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.Font = Enum.Font.SourceSans
    titleLabel.TextSize = 24
    titleLabel.Parent = mainFrame

    local tabHolder = Instance.new("Frame")
    tabHolder.Size = UDim2.new(1, 0, 0.9, 0)
    tabHolder.Position = UDim2.new(0, 0, 0.1, 0)
    tabHolder.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    tabHolder.Parent = mainFrame

    function window:NewTab(name)
        local tabButton = Instance.new("TextButton")
        tabButton.Text = name
        tabButton.Size = UDim2.new(0.2, 0, 0.1, 0)
        tabButton.BackgroundColor3 = Color3.new(0.25, 0.25, 0.25)
        tabButton.TextColor3 = Color3.new(1, 1, 1)
        tabButton.Font = Enum.Font.SourceSans
        tabButton.TextSize = 20
        tabButton.Parent = tabHolder

        local tabFrame = Instance.new("Frame")
        tabFrame.Size = UDim2.new(1, 0, 0.9, 0)
        tabFrame.Position = UDim2.new(0, 0, 0.1, 0)
        tabFrame.Visible = false
        tabFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
        tabFrame.Parent = tabHolder

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
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Size = UDim2.new(1, -10, 0.2, 0)
            sectionFrame.Position = UDim2.new(0, 5, 0, 5)
            sectionFrame.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
            sectionFrame.Parent = tabFrame

            local sectionTitle = Instance.new("TextLabel")
            sectionTitle.Text = name
            sectionTitle.Size = UDim2.new(1, 0, 0.2, 0)
            sectionTitle.BackgroundColor3 = Color3.new(0.35, 0.35, 0.35)
            sectionTitle.TextColor3 = Color3.new(1, 1, 1)
            sectionTitle.Font = Enum.Font.SourceSans
            sectionTitle.TextSize = 18
            sectionTitle.Parent = sectionFrame

            local section = {}
            section.frame = sectionFrame

            function section:NewButton(text, info, callback)
                local button = Instance.new("TextButton")
                button.Text = text
                button.Size = UDim2.new(1, -10, 0.2, 0)
                button.Position = UDim2.new(0, 5, 0.25, 0)
                button.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
                button.TextColor3 = Color3.new(1, 1, 1)
                button.Font = Enum.Font.SourceSans
                button.TextSize = 18
                button.Parent = sectionFrame

                button.MouseButton1Click:Connect(function()
                    callback()
                end)
                return button
            end

            return section
        end

        return tab
    end

    return window
end

return Library
