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
title.TextColor3=Color3.new(1,1,1)
title.TextScaled=true
title.Parent=frame
