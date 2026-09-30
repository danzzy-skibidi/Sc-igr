-- ========================================================
--               INDO GLERITY REBORN PREMIUM
-- ========================================================
--  [+] Created By : @beruk
--  [+] Version    : v1.0.0-Final
--  [+] Features   : Auto Job, Anti-AFK, Screen GUI Toggle
-- ========================================================

-- === INTEGRASI FITUR ANTI-AFK ===
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = game:GetService("Players").LocalPlayer

LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    print("[Anti-AFK] Menghindari deteksi kick server!")
end)

-- === TAMPILAN MENU GUI & TOMBOL TOGGLE ===
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local InfoLabel = Instance.new("TextLabel")
local ToggleButton = Instance.new("TextButton")
local UICornerFrame = Instance.new("UICorner")
local UICornerButton = Instance.new("UICorner")

ScreenGui.Parent = game:GetService("CoreGui")
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- Tema Gelap Premium
Frame.Position = UDim2.new(0.02, 0, 0.1, 0)
Frame.Size = UDim2.new(0, 260, 0, 180) -- Ukuran diperbesar untuk tombol
Frame.BorderSizePixel = 0

UICornerFrame.CornerRadius = UDim.new(0, 8)
UICornerFrame.Parent = Frame

-- Judul Menu
TitleLabel.Parent = Frame
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.BackgroundColor3 = Color3.fromRGB(255, 165, 0) -- Orange Neon
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 14
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Text = "  INDO GLERITY AUTOMATION"
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleLabel

-- Teks Status Informasi
InfoLabel.Parent = Frame
InfoLabel.Position = UDim2.new(0, 10, 0, 35)
InfoLabel.Size = UDim2.new(1, -20, 0, 90)
InfoLabel.BackgroundTransparency = 1
InfoLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
InfoLabel.TextSize = 13
InfoLabel.Font = Enum.Font.SourceSans
InfoLabel.TextWrapped = true
InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
InfoLabel.TextYAlignment = Enum.TextYAlignment.Top
InfoLabel.RichText = true

-- Tombol On/Off
ToggleButton.Parent = Frame
ToggleButton.Position = UDim2.new(0, 10, 0, 135)
ToggleButton.Size = UDim2.new(1, -20, 0, 35)
ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 30, 30) -- Merah (Default: Mati)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 14
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Text = "MULAI BOT"

UICornerButton.CornerRadius = UDim.new(0, 6)
UICornerButton.Parent = ToggleButton

-- Fungsi memperbarui teks status di layar
local function updateStatus(statusBaru)
    InfoLabel.Text = string.format(
        "<b>Owner:</b> @XyzOwner\n" ..
        "<b>Version:</b> v1.6.0-Final\n" ..
        "<b>Features:</b> Auto Job + Anti-AFK\n\n" ..
        "<b>Status:</b> <font color='#FFA500'>%s</font>",
        statusBaru
    )
end

_G.AutoJobGlerity = false -- Bot mati saat pertama di-execute
updateStatus("Bot Siap Digunakan! 🤖")

-- === PENGATURAN LOGIC BOT ===
local KECEPATAN_TERBANG = 65 
local TINGGI_TERBANG = 25    
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local function jalanKeTarget(posisiTarget)
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    while _G.AutoJobGlerity and (character.PrimaryPart.Position - posisiTarget).Magnitude > 4 do
        humanoid:MoveTo(posisiTarget)
        task.wait(0.1)
    end
end

local function cariMobilPemain()
    local character = LocalPlayer.Character
    if character and character:FindFirstChildOfClass("Humanoid") then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("VehicleSeat") and v.Occupant == humanoid then
                return v.Parent
            end
        end
    end
    return nil
end

local function cariObjekBerdasarkanWarna(namaWarna)
    local karakter = LocalPlayer.Character
    if not karakter or not karakter.PrimaryPart then return nil end
    local objekTerdekat = nil
    local jarakTerdekat = math.huge
    
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Part") or v:IsA("MeshPart") or v:IsA("Decal") then
            local matchesColor = false
            if namaWarna == "Kuning" and (v.BrickColor.Name == "New Yeller" or v.BrickColor.Name == "Bright Yellow" or string.find(string.lower(v.Name), "yellow") or string.find(string.lower(v.Name), "panah")) then
                matchesColor = true
            elseif namaWarna == "Merah" and (v.BrickColor.Name == "Bright Red" or v.Name == "job" or string.find(string.lower(v.Name), "red")) then
                matchesColor = true
            end
            
            if matchesColor then
                local pos = v:IsA("Decal") and v.Parent.Position or v.Position
                local jarak = (karakter.PrimaryPart.Position - pos).Magnitude
                if jarak < jarakTerdekat and jarak > 2 then
                    jarakTerdekat = jarak
                    objekTerdekat = v
                end
            end
        end
    end
    return objekTerdekat
end

local function terbangKeTarget(targetObjek)
    local mobil = cariMobilPemain()
    if mobil and targetObjek and _G.AutoJobGlerity then
        local targetPos = targetObjek:IsA("Decal") and targetObjek.Parent.Position or targetObjek.Position
        local mainPart = mobil:FindFirstChild("DriveSeat") or mobil:FindFirstChild("VehicleSeat") or mobil.PrimaryPart or mobil:FindFirstChildOfClass("Part")
        
        if mainPart then
            local posisiAtas = mainPart.Position + Vector3.new(0, TINGGI_TERBANG, 0)
            TweenService:Create(mainPart, TweenInfo.new(1.2), {CFrame = CFrame.new(posisiAtas)}):Play()
            task.wait(1.2)
            if not _G.AutoJobGlerity then return end

            local posisiTargetTerbang = CFrame.new(targetPos.X, posisiAtas.Y, targetPos.Z)
            local jarak = (mainPart.Position - targetPos).Magnitude
            local infoTween = TweenInfo.new(jarak / KECEPATAN_TERBANG, Enum.EasingStyle.Linear)
            
            local tween = TweenService:Create(mainPart, infoTween, {CFrame = posisiTargetTerbang})
            tween:Play()
            tween.Completed:Wait()
            if not _G.AutoJobGlerity then return end
            
            TweenService:Create(mainPart, TweenInfo.new(1.2), {CFrame = CFrame.new(targetPos)}):Play()
            task.wait(1.5)
        end
    end
end

-- === LOOP UTAMA BOT YANG DIKENDALIKAN TOMBOL ===
local function startLoop()
    task.spawn(function()
        while _G.AutoJobGlerity do
            updateStatus("Jalan ke Spot Job... 🏃‍♂️")
            local spotJob = workspace:FindFirstChild("job", true) or cariObjekBerdasarkanWarna("Merah")
            if spotJob then
                local posJob = spotJob:IsA("Decal") and spotJob.Parent.Position or spotJob.Position
                jalanKeTarget(posJob)
                if not _G.AutoJobGlerity then break end
                task.wait(3)
            else
                updateStatus("Mencari lingkaran job... 🔎")
                task.wait(2)
                continue
            end

            updateStatus("Menunggu Naik Mobil... 🚗")
            repeat task.wait(0.5) until cariMobilPemain() or not _G.AutoJobGlerity
            if not _G.AutoJobGlerity then break end

            local panahKuning = cariObjekBerdasarkanWarna("Kuning")
            if panahKuning then
                updateStatus("Terbang Antar Barang... 💸")
                terbangKeTarget(panahKuning)
            end
            if not _G.AutoJobGlerity then break end

            updateStatus("Menunggu Proses Uang... ⏳")
            local jobSelesai = false
            local koneksiChat = LocalPlayer.Chatted:Connect(function(msg)
                local m = string.lower(msg)
                if string.find(m, "berhasil") or string.find(m, "sukses") or string.find(m, "selesai") or string.find(m, "rp") then
                    jobSelesai = true
                end
            end)

            local timer = 0
            while not jobSelesai and timer < 6 and _G.AutoJobGlerity do
                task.wait(1)
                timer = timer + 1
            end
            if koneksiChat then koneksiChat:Disconnect() end
            if not _G.AutoJobGlerity then break end

            local panahUang = cariObjekBerdasarkanWarna("Kuning")
            if panahUang and cariMobilPemain() then
                updateStatus("Ambil Gaji/Balik Base... 💰")
                terbangKeTarget(panahUang)
                task.wait(2)
            end

            task.wait(1)
        end
    end)
end

-- === LOGIC KLIK TOMBOL ON/OFF ===
ToggleButton.MouseButton1Click:Connect(function()
    if _G.AutoJobGlerity == false then
        -- Mengaktifkan Bot
        _G.AutoJobGlerity = true
        ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 150, 30) -- Warna Hijau
        ToggleButton.Text = "STOP BOT"
        startLoop()
    else
        -- Mematikan Bot
        _G.AutoJobGlerity = false
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 30, 30) -- Warna Merah
        ToggleButton.Text = "MULAI BOT"
        updateStatus("Bot Dinonaktifkan! 🛑")
    end
end)
