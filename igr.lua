--========================================================
--              AUTO LOOP PATH SYSTEM
--========================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

--========================================================
-- SETTINGS
--========================================================

local recording = false
local playing = false

local path = {}
local currentPoint = 1
local direction = 1

-- 1ARAH / BOLAKBALIK
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
frame.Size = UDim2.new(0,220,0,290)
frame.Position = UDim2.new(0,20,0.5,-145)
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

    local b = Instance.new("TextButton")

    b.Size = UDim2.new(1,-20,0,35)
    b.Position = UDim2.new(0,10,0,y)

    b.Text = text
    b.TextColor3 = Color3.new(1,1,1)
    b.TextSize = 14
    b.Font = Enum.Font.GothamBold

    b.BackgroundColor3 = Color3.fromRGB(45,45,55)
    b.BorderSizePixel = 0

    b.Parent = frame

    return b
end

--========================================================
-- BUTTONS
--========================================================

local recordBtn = createButton("REKAM JALUR",40)
local modeBtn = createButton("MODE: 1 ARAH",80)
local playBtn = createButton("JALANKAN LOOP",120)
local stopBtn = createButton("STOP",160)
local continueBtn = createButton("LANJUT",200)
local clearBtn = createButton("HAPUS JALUR",240)

--========================================================
-- HIDE BUTTON
--========================================================

local hideBtn = Instance.new("TextButton")

hideBtn.Size = UDim2.new(0,80,0,35)
hideBtn.Position = UDim2.new(0,20,0.5,-180)

hideBtn.Text = "HIDE"
hideBtn.TextColor3 = Color3.new(1,1,1)
hideBtn.TextSize = 14
hideBtn.Font = Enum.Font.GothamBold

hideBtn.BackgroundColor3 = Color3.fromRGB(45,45,55)
hideBtn.BorderSizePixel = 0

hideBtn.Parent = gui

--========================================================
-- DRAG MENU
--========================================================

local dragging = false
local dragStart
local startPos

frame.InputBegan:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPos = frame.Position

        input.Changed:Connect(function()

            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end

        end)

    end

end)

UserInputService.InputChanged:Connect(function(input)

    if not dragging then
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then

        local delta = input.Position - dragStart

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
    showBtn.Position = UDim2.new(0,20,0.5,-180)

    showBtn.Text = "SHOW"
    showBtn.TextColor3 = Color3.new(1,1,1)
    showBtn.TextSize = 14
    showBtn.Font = Enum.Font.GothamBold

    showBtn.BackgroundColor3 = Color3.fromRGB(45,45,55)
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

    local distance = (b-a).Magnitude

    local line = Instance.new("Part")

    line.Name = "PathLine"

    line.Anchored = true
    line.CanCollide = false
    line.CanTouch = false
    line.CanQuery = false

    line.Material = Enum.Material.Neon
    line.Color = Color3.fromRGB(0,170,255)

    line.Size = Vector3.new(
        0.15,
        0.15,
        distance
    )

    line.CFrame = CFrame.lookAt(
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

    local character = player.Character

    if not character then
        return
    end

    local root =
        character:FindFirstChild("HumanoidRootPart")

    if not root then
        return
    end

    local position = root.Position

    -- Titik pertama
    if #path == 0 then

        table.insert(path,position)

    -- Titik berikutnya setiap 2 studs
    elseif (position - path[#path]).Magnitude >= 2 then

        makeLine(
            path[#path],
            position
        )

        table.insert(path,position)

    end

end)

--========================================================
-- REKAM
--========================================================

recordBtn.MouseButton1Click:Connect(function()

    recording = not recording

    if recording then

        recordBtn.Text = "⏺ SEDANG REKAM"

    else

        recordBtn.Text = "REKAM JALUR"

    end

end)

--========================================================
-- GANTI MODE
--========================================================

modeBtn.MouseButton1Click:Connect(function()

    if mode == "1ARAH" then

        mode = "BOLAKBALIK"

        modeBtn.Text = "MODE: BOLAK-BALIK"

    else

        mode = "1ARAH"

        modeBtn.Text = "MODE: 1 ARAH"

    end

end)

--========================================================
-- JALANKAN PATH
--========================================================

local function playPath()

    if #path < 2 then
        return
    end

    local character = player.Character

    if not character then
        return
    end

    local humanoid =
        character:FindFirstChildOfClass("Humanoid")

    local root =
        character:FindFirstChild("HumanoidRootPart")

    if not humanoid or not root then
        return
    end

    while playing do

        if currentPoint < 1 then
            currentPoint = 1
        end

        if currentPoint > #path then
            currentPoint = #path
        end

        local target = path[currentPoint]

        humanoid:MoveTo(target)

        repeat

            task.wait(0.05)

            if not playing then
                return
            end

            character = player.Character

            if not character then
                return
            end

            root =
                character:FindFirstChild("HumanoidRootPart")

            if not root then
                return
            end

        until (root.Position - target).Magnitude < 3

        --================================================
        -- 1 ARAH
        --================================================

        if mode == "1ARAH" then

            currentPoint += 1

            if currentPoint > #path then

                currentPoint = 1

            end

        --================================================
        -- BOLAK-BALIK
        --================================================

        elseif mode == "BOLAKBALIK" then

            currentPoint += direction

            if currentPoint >= #path then

                currentPoint = #path
                direction = -1

            elseif currentPoint <= 1 then

                currentPoint = 1
                direction = 1

            end

        end

    end

end

--========================================================
-- JALANKAN LOOP
--========================================================

playBtn.MouseButton1Click:Connect(function()

    if #path < 2 then

        playBtn.Text = "JALUR KOSONG"

        task.wait(1)

        playBtn.Text = "JALANKAN LOOP"

        return
    end

    if playing then
        return
    end

    playing = true

    playBtn.Text = "LOOP BERJALAN"

    task.spawn(playPath)

end)

--========================================================
-- STOP
--========================================================

stopBtn.MouseButton1Click:Connect(function()

    playing = false

    stopBtn.Text = "STOPPED"

    task.wait(0.7)

    stopBtn.Text = "STOP"

end)

--========================================================
-- LANJUT
--========================================================

continueBtn.MouseButton1Click:Connect(function()

    if playing then
        return
    end

    if #path < 2 then
        return
    end

    playing = true

    continueBtn.Text = "MELANJUTKAN..."

    task.spawn(playPath)

    task.wait(0.7)

    continueBtn.Text = "LANJUT"

end)

--========================================================
-- HAPUS JALUR
--========================================================

clearBtn.MouseButton1Click:Connect(function()

    recording = false
    playing = false

    path = {}

    currentPoint = 1
    direction = 1

    for _,object in ipairs(folder:GetChildren()) do
        object:Destroy()
    end

    recordBtn.Text = "REKAM JALUR"
    playBtn.Text = "JALANKAN LOOP"

end)
