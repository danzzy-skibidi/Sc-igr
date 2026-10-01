local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local Lighting=game:GetService("Lighting")
local UserInputService=game:GetService("UserInputService")

local player=Players.LocalPlayer
local gui=Instance.new("ScreenGui")
gui.Name="DanzzyMenu"
gui.ResetOnSpawn=false
gui.IgnoreGuiInset=true
gui.Parent=player:WaitForChild("PlayerGui")

local frame=Instance.new("Frame")
frame.Size=UDim2.new(0,210,0,330)
frame.Position=UDim2.new(.5,-105,.5,-165)
frame.BackgroundColor3=Color3.fromRGB(20,20,30)
frame.BorderSizePixel=0
frame.Active=true
frame.Parent=gui

local corner=Instance.new("UICorner")
corner.CornerRadius=UDim.new(0,10)
corner.Parent=frame

local title=Instance.new("TextLabel")
title.Size=UDim2.new(1,-45,0,35)
title.Position=UDim2.new(0,5,0,0)
title.BackgroundTransparency=1
title.Text="DANZZY MENU"
title.TextScaled=true
title.Font=Enum.Font.GothamBold
title.Parent=frame

task.spawn(function()
	local h=0
	while title.Parent do
		h=(h+.01)%1
		title.TextColor3=Color3.fromHSV(h,1,1)
		task.wait()
	end
end)

local hide=Instance.new("TextButton")
hide.Size=UDim2.new(0,30,0,30)
hide.Position=UDim2.new(1,-35,0,3)
hide.BackgroundColor3=Color3.fromRGB(45,45,60)
hide.Text="—"
hide.TextColor3=Color3.new(1,1,1)
hide.TextScaled=true
hide.Parent=frame

local show=Instance.new("TextButton")
show.Size=UDim2.new(0,110,0,35)
show.Position=UDim2.new(0,10,.5,-17)
show.BackgroundColor3=Color3.fromRGB(20,20,30)
show.Text="DANZZY MENU"
show.TextColor3=Color3.new(1,1,1)
show.TextScaled=true
show.Font=Enum.Font.GothamBold
show.Visible=false
show.Parent=gui

local function button(text,y)
	local b=Instance.new("TextButton")
	b.Size=UDim2.new(0,180,0,27)
	b.Position=UDim2.new(.5,-90,0,y)
	b.BackgroundColor3=Color3.fromRGB(35,35,50)
	b.TextColor3=Color3.new(1,1,1)
	b.Text=text
	b.TextScaled=true
	b.Font=Enum.Font.GothamBold
	b.Parent=frame

	local c=Instance.new("UICorner")
	c.CornerRadius=UDim.new(0,6)
	c.Parent=b

	return b
end

local record=button("REKAM JALUR",43)
local loop=button("AUTO LOOP",75)
local stop=button("STOP",107)
local bright=button("FULLBRIGHT: OFF",139)
local speed=button("WALKSPEED: 16",171)
local speedMinus=button("SPEED -",203)
local speedPlus=button("SPEED +",235)
local delayBtn=button("DELAY: 0.5",267)
local status=button("STATUS: STOP",299)

status.AutoButtonColor=false

local path={}
local recording=false
local looping=false
local fullbright=false
local lastPos=nil
local index=1
local walkSpeed=16
local delayTime=.5

local pathFolder=Instance.new("Folder")
pathFolder.Name="DanzzyPath"
pathFolder.Parent=workspace

local function clearPathLine()
	for _,v in ipairs(pathFolder:GetChildren()) do
		v:Destroy()
	end
end

local function drawPathLine()
	clearPathLine()

	for i=1,#path-1 do
		local a=path[i]
		local b=path[i+1]
		local distance=(b-a).Magnitude

		if distance>0 then
			local part=Instance.new("Part")
			part.Name="GreenPath"
			part.Anchored=true
			part.CanCollide=false
			part.CanTouch=false
			part.CanQuery=false
			part.Material=Enum.Material.Neon
			part.Color=Color3.fromRGB(0,255,80)
			part.Size=Vector3.new(.25,.25,distance)
			part.CFrame=CFrame.lookAt((a+b)/2,b)
			part.Parent=pathFolder
		end
	end
end

local function getCharacter()
	return player.Character
end

local function getHumanoid()
	local c=getCharacter()
	return c and c:FindFirstChildOfClass("Humanoid")
end

local function getRoot()
	local c=getCharacter()
	return c and c:FindFirstChild("HumanoidRootPart")
end

local function updateSpeed()
	local h=getHumanoid()

	if h then
		h.WalkSpeed=walkSpeed
	end

	speed.Text="WALKSPEED: "..walkSpeed
end

-- DRAG MENU
local dragging=false
local dragStart
local startPos

title.InputBegan:Connect(function(input)
	if input.UserInputType==Enum.UserInputType.MouseButton1
	or input.UserInputType==Enum.UserInputType.Touch then

		dragging=true
		dragStart=input.Position
		startPos=frame.Position

		input.Changed:Connect(function()
			if input.UserInputState==Enum.UserInputState.End then
				dragging=false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if not dragging then return end

	if input.UserInputType==Enum.UserInputType.MouseMovement
	or input.UserInputType==Enum.UserInputType.Touch then

		local delta=input.Position-dragStart

		frame.Position=UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset+delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset+delta.Y
		)
	end
end)

-- HIDE / SHOW
hide.MouseButton1Click:Connect(function()
	frame.Visible=false
	show.Visible=true
end)

show.MouseButton1Click:Connect(function()
	frame.Visible=true
	show.Visible=false
end)

-- SPEED -
speedMinus.MouseButton1Click:Connect(function()
	walkSpeed=math.max(0,walkSpeed-5)
	updateSpeed()
end)

-- SPEED +
speedPlus.MouseButton1Click:Connect(function()
	walkSpeed=math.min(1000,walkSpeed+5)
	updateSpeed()
end)

-- DELAY
delayBtn.MouseButton1Click:Connect(function()
	delayTime=delayTime+.5

	if delayTime>3 then
		delayTime=.5
	end

	delayBtn.Text="DELAY: "..string.format("%.1f",delayTime)
end)

-- REKAM JALUR
record.MouseButton1Click:Connect(function()
	if looping then
		looping=false
	end

	recording=not recording

	if recording then
		path={}
		lastPos=nil
		clearPathLine()

		record.Text="STOP REKAM"
		status.Text="STATUS: MEREKAM"
	else
		record.Text="REKAM JALUR"

		if #path>=2 then
			drawPathLine()
			status.Text="STATUS: JALUR TERSIMPAN"
		else
			status.Text="STATUS: JALUR KURANG"
		end
	end
end)

-- REKAM POSISI
RunService.Heartbeat:Connect(function()
	if not recording then return end

	local root=getRoot()

	if not root then return end

	if not lastPos or (root.Position-lastPos).Magnitude>=2 then
		table.insert(path,root.Position)
		lastPos=root.Position
	end
end)

-- AUTO LOOP LANCAR
loop.MouseButton1Click:Connect(function()
	if #path<2 then
		status.Text="STATUS: REKAM DULU"
		return
	end

	recording=false
	looping=true
	index=1

	record.Text="REKAM JALUR"
	drawPathLine()
	status.Text="STATUS: AUTO LOOP"

	task.spawn(function()
		while looping do
			local humanoid=getHumanoid()
			local root=getRoot()

			if not humanoid or not root then
				task.wait(.1)
				continue
			end

			humanoid.WalkSpeed=walkSpeed

			local target=path[index]

			if target then
				local start=os.clock()

				humanoid:MoveTo(target)

				while looping and root.Parent do
					local distance=(root.Position-target).Magnitude

					if distance<=3 then
						break
					end

					-- refresh MoveTo agar tidak mudah berhenti
					humanoid:MoveTo(target)

					-- timeout agar tidak macet di satu titik
					if os.clock()-start>=5 then
						break
					end

					task.wait(.05)
				end
			end

			if not looping then
				break
			end

			index=index+1

			if index>#path then
				index=1
				task.wait(delayTime)
			end

			task.wait(.03)
		end
	end)
end)

-- STOP
stop.MouseButton1Click:Connect(function()
	looping=false
	recording=false

	local humanoid=getHumanoid()

	if humanoid then
		humanoid:Move(Vector3.zero)
	end

	status.Text="STATUS: STOP"
end)

-- FULLBRIGHT
bright.MouseButton1Click:Connect(function()
	fullbright=not fullbright

	if fullbright then
		Lighting.Brightness=2
		Lighting.ClockTime=14
		Lighting.FogEnd=1000000
		Lighting.GlobalShadows=false
		bright.Text="FULLBRIGHT: ON"
	else
		Lighting.Brightness=1
		Lighting.GlobalShadows=true
		bright.Text="FULLBRIGHT: OFF"
	end
end)

player.CharacterAdded:Connect(function()
	task.wait(.2)
	updateSpeed()
end)

updateSpeed()
