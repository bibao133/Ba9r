local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local maxSpeed = 50000
local speed = 16
local enabled = false

-- GUI
local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui

-- FRAME (ĐÃ ĐỔI MÀU ĐỎ NHẠT)
local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0, 300, 0, 260)
frame.Position = UDim2.new(0.4, 0, 0.35, 0)
frame.BackgroundColor3 = Color3.fromRGB(200, 100, 100) -- 🔥 ĐỎ NHẠT
frame.BorderColor3 = Color3.fromRGB(180, 0, 255)
frame.BorderSizePixel = 3

-- ICON "+"
local icon = Instance.new("TextButton")
icon.Parent = gui
icon.Size = UDim2.new(0, 40, 0, 40)
icon.Position = UDim2.new(0, 20, 0.5, 0)
icon.Text = "+"
icon.Visible = false

-- TITLE
local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "ULTRA MENU"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(0, 0, 0)

-- SPEED
local speedLabel = Instance.new("TextLabel")
speedLabel.Parent = frame
speedLabel.Size = UDim2.new(1, 0, 0, 25)
speedLabel.Position = UDim2.new(0, 0, 0, 35)
speedLabel.Text = "Speed: 16"
speedLabel.BackgroundTransparency = 1

-- TOGGLE
local toggle = Instance.new("TextButton")
toggle.Parent = frame
toggle.Size = UDim2.new(1, -20, 0, 30)
toggle.Position = UDim2.new(0, 10, 0, 70)
toggle.Text = "OFF"

-- + / -
local plus = Instance.new("TextButton")
plus.Parent = frame
plus.Size = UDim2.new(0.45, 0, 0, 30)
plus.Position = UDim2.new(0.05, 0, 0, 120)
plus.Text = "+"

local minus = Instance.new("TextButton")
minus.Parent = frame
minus.Size = UDim2.new(0.45, 0, 0, 30)
minus.Position = UDim2.new(0.5, 0, 0, 120)
minus.Text = "-"

-- MINIMIZE
local mini = Instance.new("TextButton")
mini.Parent = frame
mini.Size = UDim2.new(0, 25, 0, 25)
mini.Position = UDim2.new(1, -30, 0, 5)
mini.Text = "-"

-- UPDATE
local function update()
	if enabled then
		hum.WalkSpeed = speed
	else
		hum.WalkSpeed = 16
	end
	speedLabel.Text = "Speed: "..speed
end

-- TOGGLE SPEED
toggle.MouseButton1Click:Connect(function()
	enabled = not enabled
	if not enabled then speed = 16 end
	toggle.Text = enabled and "ON" or "OFF"
	update()
end)

-- SPEED CONTROL
local holdPlus, holdMinus = false,false

plus.MouseButton1Down:Connect(function()
	holdPlus = true
	while holdPlus do
		speed = math.clamp(speed + 200, 16, maxSpeed)
		update()
		task.wait(0.03)
	end
end)

plus.MouseButton1Up:Connect(function()
	holdPlus = false
end)

minus.MouseButton1Down:Connect(function()
	holdMinus = true
	while holdMinus do
		speed = math.clamp(speed - 200, 16, maxSpeed)
		update()
		task.wait(0.03)
	end
end)

minus.MouseButton1Up:Connect(function()
	holdMinus = false
end)

-- APPLY SPEED
RunService.RenderStepped:Connect(function()
	if enabled then
		hum.WalkSpeed = speed
	end
end)

-- MINIMIZE / OPEN
mini.MouseButton1Click:Connect(function()
	frame.Visible = false
	icon.Visible = true
end)

icon.MouseButton1Click:Connect(function()
	frame.Visible = true
	icon.Visible = false
end)

-- DRAG
local dragging = false
local dragStart
local startPos

frame.Active = true

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

player.CharacterAdded:Connect(function(c)
	char = c
	hum = c:WaitForChild("Humanoid")
end)
