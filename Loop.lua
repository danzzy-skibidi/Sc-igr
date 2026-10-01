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
frame.Size=UDim2.new(0,280,0,430)
frame.Position=UDim2.new(.5,-140,.5,-215)
frame.BackgroundColor3=Color3.fromRGB(20,20,30)
frame.BorderSizePixel=0
frame.Parent=gui

local corner=Instance.new("UICorner")
corner.CornerRadius=UDim.new(0,12)
corner.Parent=frame

local title=Instance.new("TextLabel")
title.Size=UDim2.new(1,-70,0,45)
title.Position=UDim2.new(0,10,0,0)
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
hide.Size=UDim2.new(0,35,0,35)
hide.Position=UDim2.new(1,-45,0,5)
hide.BackgroundColor3=Color3.fromRGB(45,45,60)
hide.Text="—"
hide.TextColor3=Color3.new(1,1,1)
hide.TextScaled=true
hide.Parent=frame

local show=Instance.new("TextButton")
show.Size=UDim2.new(0,120,0,40)
show.Position=UDim2.new(0,15,0,15)
show.BackgroundColor3=Color3.fromRGB(20,20,30)
show.Text="DANZZY MENU"
show.TextColor3=Color3.new(1,1,1)
show.TextScaled=true
show.Visible=false
show.Parent=gui

local function button(text,y)
	local b=Instance.new("TextButton")
	b.Size=UDim2.new(0,240,0,36)
	b.Position=UDim2.new(.5,-120,0,y)
	b.BackgroundColor3=Color3.fromRGB(35,35,50)
	b.TextColor3=Color3.new(1,1,1)
	b.Text=text
	b.TextScaled=true
	b.Font=Enum.Font.GothamBold
	b.Parent=frame

	local c=Instance.new("UICorner")
	c.CornerRadius=UDim.new(0,7)
	c.Parent=b

	return b
end

local record=button("REKAM JALUR",55)
local loop=button("AUTO LOOP",98)
local stop=button("STOP",141)
local bright=button("FULLBRIGHT: OFF",184)
local speed=button("WALKSPEED: 16",227)
local speedMinus=button("SPEED -",270)
local speedPlus=button("SPEED +",313)
local delayBtn=button("DELAY: 0.5",356)
local status=button("STATUS: STOP",399)

status.AutoButtonColor=false

local path={}
local recording=false
local looping=false
local fullbright=false
local lastPos=nil
local index=1
local walkSpeed=16
local delayTime=.5

local function getHumanoid()
	local c=player.Character
	return c and c:FindFirstChildOfClass("Humanoid")
end

local function updateSpeed()
	local h=getHumanoid()
	if h then h.WalkSpeed=walkSpeed end
	speed.Text="WALKSPEED: "..walkSpeed
end

player.CharacterAdded:Connect(function()
	task.wait(.1)
	updateSpeed()
end)

speedMinus.MouseButton1Click:Connect(function()
	walkSpeed=math.max(0,walkSpeed-5)
	updateSpeed()
end)

speedPlus.MouseButton1Click:Connect(function()
	walkSpeed=math.min(100,walkSpeed+5)
	updateSpeed()
end)

delayBtn.MouseButton1Click:Connect(function()
	delayTime=delayTime+.5
	if delayTime>3 then delayTime=.5 end
	delayBtn.Text="DELAY: "..string.format("%.1f",delayTime)
end)

record.MouseButton1Click:Connect(function()
	recording=not recording

	if recording then
		path={}
		lastPos=nil
		record.Text="STOP REKAM"
		status.Text="STATUS: MEREKAM"
	else
		record.Text="REKAM JALUR"
		status.Text="STATUS: JALUR TERSIMPAN"
	end
end)

RunService.Heartbeat:Connect(function()
	if not recording then return end

	local c=player.Character
	local root=c and c:FindFirstChild("HumanoidRootPart")
	if not root then return end

	if not lastPos or (root.Position-lastPos).Magnitude>=2 then
		table.insert(path,root.Position)
		lastPos=root.Position
	end
end)

loop.MouseButton1Click:Connect(function()
	if #path<2 then
		status.Text="STATUS: REKAM DULU"
		return
	end

	recording=false
	looping=true
	index=1
	status.Text="STATUS: AUTO LOOP"

	task.spawn(function()
		while looping do
			local h=getHumanoid()

			if h and path[index] then
				h.WalkSpeed=walkSpeed
				h:MoveTo(path[index])
				h.MoveToFinished:Wait()
				task.wait(delayTime)
			end

			index=index+1

			if index>#path then
				index=1
			end
		end
	end)
end)

stop.MouseButton1Click:Connect(function()
	looping=false
	recording=false
	status.Text="STATUS: STOP"
end)

bright.MouseButton1Click:Connect(function()
	fullbright=not fullbright

	if fullbright then
		Lighting.Brightness=2
		Lighting.ClockTime=14
		Lighting.FogEnd=100000
		Lighting.GlobalShadows=false
		bright.Text="FULLBRIGHT: ON"
	else
		Lighting.Brightness=1
		Lighting.GlobalShadows=true
		bright.Text="FULLBRIGHT: OFF"
	end
end)

hide.MouseButton1Click:Connect(function()
	frame.Visible=false
	show.Visible=true
end)

show.MouseButton1Click:Connect(function()
	frame.Visible=true
	show.Visible=false
end)

local dragging=false
local dragStart=nil
local startPos=nil

title.InputBegan:Connect(function(input)
	if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
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

	if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then
		local delta=input.Position-dragStart

		frame.Position=UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset+delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset+delta.Y
		)
	end
end)

local resize=Instance.new("TextButton")
resize.Size=UDim2.new(0,25,0,25)
resize.Position=UDim2.new(1,-30,1,-30)
resize.BackgroundColor3=Color3.fromRGB(55,55,70)
resize.Text="↘"
resize.TextColor3=Color3.new(1,1,1)
resize.TextScaled=true
resize.Parent=frame

local small=false

resize.MouseButton1Click:Connect(function()
	small=not small

	if small then
		frame.Size=UDim2.new(0,220,0,330)

		title.Size=UDim2.new(1,-60,0,38)
		title.TextScaled=true

		hide.Size=UDim2.new(0,30,0,30)
		hide.Position=UDim2.new(1,-38,0,4)

		for _,v in ipairs(frame:GetChildren()) do
			if v:IsA("TextButton") and v~=hide and v~=resize then
				v.Size=UDim2.new(0,185,0,28)
				v.Position=UDim2.new(.5,-92,0,v.Position.Y.Offset*.77)
				v.TextScaled=true
			end
		end

		resize.Position=UDim2.new(1,-28,1,-28)
	else
		frame.Size=UDim2.new(0,280,0,430)

		title.Size=UDim2.new(1,-70,0,45)

		hide.Size=UDim2.new(0,35,0,35)
		hide.Position=UDim2.new(1,-45,0,5)

		local buttons={
			[record]=55,
			[loop]=98,
			[stop]=141,
			[bright]=184,
			[speed]=227,
			[speedMinus]=270,
			[speedPlus]=313,
			[delayBtn]=356,
			[status]=399
		}

		for b,y in pairs(buttons) do
			b.Size=UDim2.new(0,240,0,36)
			b.Position=UDim2.new(.5,-120,0,y)
			b.TextScaled=true
		end

		resize.Position=UDim2.new(1,-30,1,-30)
	end
end)

updateSpeed()
