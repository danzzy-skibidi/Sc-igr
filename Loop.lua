--========================================================
--              AUTO LOOP PATH SYSTEM DANZZY PREMIUM
--========================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer

--========================================================
-- SETTINGS
--========================================================

local recording = false
local playing = false
local fullBright = false

local path = {}
local currentPoint = 1
local direction = 1

-- "1ARAH" / "BOLAKBALIK"
local mode = "1ARAH"

--========================================================
-- PATH FOLDER
--========================================================

local folder = Instance.new("Folder")
folder.Name = "SavedPath"
folder.Parent = workspace

--========================================================
-- GUI
--========================================================

local gui = Instance.new("ScreenGui")
gui.Name = "AutoLoopGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

--========================================================
-- MAIN FRAME
--========================================================

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,220,0,330)
frame.Position = UDim2.new(0,20,0.5,-165)

frame.BackgroundColor3 = Color3.fromRGB(20,20,25)
frame.BorderSizePixel = 0
frame.Active = true

frame.Parent = gui

--========================================================
-- TITLE
--========================================================

local title = Instance.new("TextLabel")

title.Size = UDim2.new(1,0,0,35)
title.BackgroundTransparency = 1

title.Text = "AUTO LOOP PATH"
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 18
title.Font = Enum.Font.GothamBold

title.Parent = frame

--========================================================
-- BUTTON FUNCTION
--========================================================

local function createButton(text,y)

    local button = Instance.new("TextButton")

    button.Size = UDim2.new(1,-20,0,35)
    button.Position = UDim2.new(0,10,0,y)

    button.Text = text
    button.TextColor3 = Color3.new(1,1,1)
    button.TextSize = 14
    button.Font = Enum.Font.GothamBold

    button.BackgroundColor3 = Color3.fromRGB(45,45,55)
    button.BorderSizePixel = 0

    button.Parent = frame

    return button
end

--========================================================
-- BUTTONS
--========================================================

local recordBtn =
    createButton("REKAM JALUR",40)

local modeBtn =
    createButton("MODE: 1 ARAH",80)

local playBtn =
    createButton("JALANKAN LOOP",120)

local stopBtn =
    createButton("STOP",160)

local continueBtn =
    createButton("LANJUT",200)

local clearBtn =
    createButton("HAPUS JALUR",240)

local fullBrightBtn =
    createButton("FULL BRIGHT: OFF",280)

--========================================================
-- HIDE BUTTON
--========================================================

local hideBtn = Instance.new("TextButton")

hideBtn.Size = UDim2.new(0,80,0,35)
hideBtn.Position = UDim2.new(0,20,0.5,-210)

hideBtn.Text = "HIDE"

hideBtn.TextColor3 = Color3.new(1,1,1)
hideBtn.TextSize = 14
hideBtn.Font = Enum.Font.GothamBold

hideBtn.BackgroundColor3 =
    Color3.fromRGB(45,45,55)

hideBtn.BorderSizePixel = 0

hideBtn.Parent = gui

--========================================================
-- DRAG / GESER MENU
--========================================================

local dragging = false
local dragStart
local startPos

frame.InputBegan:Connect(function(input)

    if input.UserInputType ==
        Enum.UserInputType.MouseButton1

        or input.UserInputType ==
        Enum.UserInputType.Touch then

        dragging = true

        dragStart = input.Position
        startPos = frame.Position

        input.Changed:Connect(function()

            if input.UserInputState ==
                Enum.UserInputState.End then

                dragging = false

            end

        end)

    end

end)

UserInputService.InputChanged:Connect(function(input)

    if not dragging then
        return
    end

    if input.UserInputType ==
        Enum.UserInputType.MouseMovement

        or input.UserInputType ==
        Enum.UserInputType.Touch then

        local delta =
            input.Position - dragStart

        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,

            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )

    end

end)

--========================================================
-- HIDE / SHOW
--========================================================

local showBtn

hideBtn.MouseButton1Click:Connect(function()

    frame.Visible = false
    hideBtn.Visible = false

    showBtn = Instance.new("TextButton")

    showBtn.Size = UDim2.new(0,80,0,35)

    showBtn.Position =
        UDim2.new(0,20,0.5,-210)

    showBtn.Text = "SHOW"

    showBtn.TextColor3 =
        Color3.new(1,1,1)

    showBtn.TextSize = 14
    showBtn.Font = Enum.Font.GothamBold

    showBtn.BackgroundColor3 =
        Color3.fromRGB(45,45,55)

    showBtn.BorderSizePixel = 0

    showBtn.Parent = gui

    showBtn.MouseButton1Click:Connect(function()

        frame.Visible = true
        hideBtn.Visible = true

        showBtn:Destroy()
        showBtn = nil

    end)

end)

--========================================================
-- BUAT GARIS JALUR
--========================================================

local function makeLine(a,b)

    local distance =
        (b-a).Magnitude

    local line =
        Instance.new("Part")

    line.Name = "PathLine"

    line.Anchored = true
    line.CanCollide = false
    line.CanTouch = false
    line.CanQuery = false

    line.Material =
        Enum.Material.Neon

    line.Color =
        Color3.fromRGB(0,170,255)

    line.Size =
        Vector3.new(
            0.15,
            0.15,
            distance
        )

    line.CFrame =
        CFrame.lookAt(
            (a+b)/2,
            b
        )

    line.Parent = folder

end

--========================================================
-- REKAM POSISI
--========================================================

RunService.Heartbeat:Connect(function()

    if not recording then
        return
    end

    local character =
        player.Character

    if not character then
        return
    end

    local root
