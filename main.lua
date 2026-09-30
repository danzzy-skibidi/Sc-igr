-- ========================================================
--                 DANZZY MENU PREMIUM
-- ========================================================
--  [+] Created By : @have.fun208
--  [+] Version    : v1.0.0
--  [+] Features   : Auto Farm, Fullbright, Infinite Jump,
--                   Teleport Player, WalkSpeed, Hide Menu
-- ========================================================

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- ========================================================
--                     SETTINGS
-- ========================================================

_G.H42 = {
    AutoFarm = false,
    Fullbright = false,
    InfiniteJump = false,
    WalkSpeed = 16
}

-- ========================================================
--                     GUI
-- ========================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Danzzy_MENU"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Parent = ScreenGui
Main.Size = UDim2.fromOffset(430, 270)
Main.Position = UDim2.new(0.5, -215, 0.5, -135)
Main.BackgroundColor3 = Color3.fromRGB(24, 26, 34)
Main.BorderSizePixel = 0

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = Main

-- ========================================================
--                     TITLE
-- ========================================================

local Title = Instance.new("TextLabel")
Title.Parent = Main
Title.Size = UDim2.new(1, -110, 0, 38)
Title.Position = UDim2.fromOffset(15, 5)
Title.BackgroundTransparency = 1
Title.Text = "DANZZY MENU"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

-- ========================================================
--                     HIDE BUTTON
-- ========================================================

local HideButton = Instance.new("TextButton")
HideButton.Parent = Main
HideButton.Size = UDim2.fromOffset(32, 28)
HideButton.Position = UDim2.new(1, -80, 0, 10)
HideButton.Text = "−"
HideButton.TextSize = 18
HideButton.Font = Enum.Font.GothamBold
HideButton.TextColor3 = Color3.fromRGB(255,255,255)
HideButton.BackgroundColor3 = Color3.fromRGB(55,60,75)
HideButton.BorderSizePixel = 0

Instance.new("UICorner", HideButton).CornerRadius = UDim.new(0,5)

-- ========================================================
--                     CLOSE BUTTON
-- ========================================================

local Close = Instance.new("TextButton")
Close.Parent = Main
Close.Size = UDim2.fromOffset(32, 28)
Close.Position = UDim2.new(1, -42, 0, 10)
Close.Text = "X"
Close.TextSize = 13
Close.Font = Enum.Font.GothamBold
Close.TextColor3 = Color3.new(1,1,1)
Close.BackgroundColor3 = Color3.fromRGB(190,45,45)
Close.BorderSizePixel = 0

Instance.new("UICorner", Close).CornerRadius = UDim.new(0,5)

-- ========================================================
--                  SHOW BUTTON
-- ========================================================

local ShowButton = Instance.new("TextButton")
ShowButton.Parent = ScreenGui
ShowButton.Size = UDim2.fromOffset(55,55)
ShowButton.Position = UDim2.new(0,20,0.5,-25)
ShowButton.Text = "D"
ShowButton.TextSize = 22
ShowButton.Font = Enum.Font.GothamBold
ShowButton.TextColor3 = Color3.fromRGB(255,255,255)
ShowButton.BackgroundColor3 = Color3.fromRGB(30,33,43)
ShowButton.BorderSizePixel = 0
ShowButton.Visible = false

Instance.new("UICorner", ShowButton).CornerRadius = UDim.new(1,0)

-- ========================================================
--                 HIDE / SHOW LOGIC
-- ========================================================

HideButton.MouseButton1Click:Connect(function()
    Main.Visible = false
    ShowButton.Visible = true
end)

ShowButton.MouseButton1Click:Connect(function()
    Main.Visible = true
    ShowButton.Visible = false
end)

Close.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- ========================================================
--                  BUTTON CREATOR
-- ========================================================

local function Button(text, position)
    local B = Instance.new("TextButton")
    B.Parent = Main
    B.Size = UDim2.fromOffset(185, 36)
    B.Position = position
    B.BackgroundColor3 = Color3.fromRGB(48,52,65)
    B.BorderSizePixel = 0
    B.Text = text
    B.TextColor3 = Color3.fromRGB(235,235,235)
    B.TextSize = 12
    B.Font = Enum.Font.Gotham

    Instance.new("UICorner", B).CornerRadius = UDim.new(0,5)

    return B
end

-- ========================================================
--                     AUTO FARM
-- ========================================================

local AutoFarm = Button(
    "Auto Farm : OFF",
    UDim2.fromOffset(15,55)
)

AutoFarm.MouseButton1Click:Connect(function()

    _G.H42.AutoFarm = not _G.H42.AutoFarm

    if _G.H42.AutoFarm then
        AutoFarm.Text = "Auto Farm : ON"
        AutoFarm.BackgroundColor3 = Color3.fromRGB(45,150,75)

        print("[Danzzy] Auto Farm aktif")

    else
        AutoFarm.Text = "Auto Farm : OFF"
        AutoFarm.BackgroundColor3 = Color3.fromRGB(48,52,65)

        print("[Danzzy] Auto Farm mati")
    end

end)

-- ========================================================
--                     FULLBRIGHT
-- ========================================================

local Fullbright = Button(
    "Fullbright : OFF",
    UDim2.fromOffset(15,100)
)

Fullbright.MouseButton1Click:Connect(function()

    _G.H42.Fullbright = not _G.H42.Fullbright

    if _G.H42.Fullbright then

        Lighting.Brightness = 3
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000

        Fullbright.Text = "Fullbright : ON"
        Fullbright.BackgroundColor3 = Color3.fromRGB(45,150,75)

    else

        Lighting.Brightness = 1
        Lighting.FogEnd = 1000

        Fullbright.Text = "Fullbright : OFF"
        Fullbright.BackgroundColor3 = Color3.fromRGB(48,52,65)

    end

end)

-- ========================================================
--                   INFINITE JUMP
-- ========================================================

local InfiniteJump = Button(
    "Infinite Jump : OFF",
    UDim2.fromOffset(15,145)
)

InfiniteJump.MouseButton1Click:Connect(function()

    _G.H42.InfiniteJump = not _G.H42.InfiniteJump

    if _G.H42.InfiniteJump then
        InfiniteJump.Text = "Infinite Jump : ON"
        InfiniteJump.BackgroundColor3 = Color3.fromRGB(45,150,75)
    else
        InfiniteJump.Text = "Infinite Jump : OFF"
        InfiniteJump.BackgroundColor3 = Color3.fromRGB(48,52,65)
    end

end)

UserInputService.JumpRequest:Connect(function()

    if _G.H42.InfiniteJump then

        local Character = LocalPlayer.Character
        local Humanoid = Character
            and Character:FindFirstChildOfClass("Humanoid")

        if Humanoid then
            Humanoid:ChangeState(
                Enum.HumanoidStateType.Jumping
            )
        end

    end

end)

-- ========================================================
--                     SPEED 16
-- ========================================================

local SpeedNormal = Button(
    "Set Speed Normal (16)",
    UDim2.fromOffset(215,55)
)

SpeedNormal.MouseButton1Click:Connect(function()

    local Character = LocalPlayer.Character
    local Humanoid = Character
        and Character:FindFirstChildOfClass("Humanoid")

    if Humanoid then
        Humanoid.WalkSpeed = 16
    end

end)

-- ========================================================
--                     SPEED 50
-- ========================================================

local SpeedFast = Button(
    "Set Speed Cepat (50)",
    UDim2.fromOffset(215,100)
)

SpeedFast.MouseButton1Click:Connect(function()

    local Character = LocalPlayer.Character
    local Humanoid = Character
        and Character:FindFirstChildOfClass("Humanoid")

    if Humanoid then
        Humanoid.WalkSpeed = 50
    end

end)

-- ========================================================
--                  SPEED 100
