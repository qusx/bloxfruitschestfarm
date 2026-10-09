local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local path = {
    Vector3.new(-7454, 5639, 295),
    Vector3.new(-7352, 5639, 284),
    Vector3.new(-7326, 5639, 382),
    Vector3.new(-7428, 5639, 394),
    Vector3.new(-7428, 5683, 393),
    Vector3.new(-7444, 5683, 301),
    Vector3.new(-7353, 5683, 285),
    Vector3.new(-7337, 5683, 377),
    Vector3.new(-6025, 5469, 2218),
    Vector3.new(-4130, 1087, -398),
    Vector3.new(-4312, 1087, -536),
    Vector3.new(-4206, 1090, -447),
    Vector3.new(-4205, 1092, -370),
}

local running = false
local currentTween = nil

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PathGui"
screenGui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Name = "PathButton"
button.Size = UDim2.new(0, 200, 0, 50)
button.Position = UDim2.new(0, 20, 0, 20)
button.Text = "Start -- made by qusx"
button.TextColor3 = Color3.new(1, 1, 1)
button.TextSize = 16
button.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
button.BackgroundTransparency = 0.3
button.Font = Enum.Font.Gotham
button.Parent = screenGui

local function runPath()
    local character = player.Character or player.CharacterAdded:Wait()
    local root = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")

    humanoid.WalkSpeed = 0

    local died = false
    local diedConn = humanoid.Died:Connect(function()
        died = true
    end)

    for i, target in ipairs(path) do
        if not running then break end
        if died then break end

        local distance = (root.Position - target).Magnitude
        local duration = math.max(0.5, distance / 150)

        local info = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
        currentTween = TweenService:Create(root, info, { CFrame = CFrame.new(target) })
        currentTween:Play()

        local completed = false
        currentTween.Completed:Connect(function()
            completed = true
        end)

        while true do
            if not running then return end
            if died then break end
            if completed then break end
            task.wait(0.1)
        end

        if i == 9 or i == 12 then
            if not died and running then
                task.wait(3)
            end
        end
    end

    diedConn:Disconnect()

    if died and running then
        while player.Character == character do
            task.wait(0.5)
        end
    end
end

button.MouseButton1Click:Connect(function()
    if not running then
        running = true
        button.Text = "Stop -- made by qusx"
        task.spawn(function()
            while running do
                pcall(runPath)
                if running then
                    task.wait(5)
                end
            end
        end)
    else
        running = false
        if currentTween then
            currentTween:Cancel()
        end
        button.Text = "Start -- made by qusx"
    end
end)   
