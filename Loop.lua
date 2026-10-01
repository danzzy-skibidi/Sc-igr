local Players=game:GetService("Players")
local player=Players.LocalPlayer

local gui=Instance.new("ScreenGui")
gui.Name="DanzzyMenu"
gui.ResetOnSpawn=false
gui.IgnoreGuiInset=true
gui.Parent=player:WaitForChild("PlayerGui")

local frame=Instance.new("Frame")
frame.Size=UDim2.new(0,250,0,150)
frame.Position=UDim2.new(.5,-125,.5,-75)
frame.BackgroundColor3=Color3.fromRGB(20,20,30)
frame.Parent=gui

local title=Instance.new("TextLabel")
title.Size=UDim2.new(1,0,0,45)
title.BackgroundTransparency=1
title.Text="DANZZY MENU"
title.TextScaled=true
title.Font=Enum.Font.GothamBold
title.Parent=frame

task.spawn(function()
	local h=0
	while title.Parent do
		h=(h+0.01)%1
		title.TextColor3=Color3.fromHSV(h,1,1)
		task.wait()
	end
end)

local button=Instance.new("TextButton")
button.Size=UDim2.new(0,200,0,45)
button.Position=UDim2.new(.5,-100,0,65)
button.Text="TEST MENU"
button.TextScaled=true
button.Parent=frame
