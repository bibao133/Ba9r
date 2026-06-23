-- 1. Initialize Rayfield UI Library (New and Stable)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu'))()

-- Create Window
local Window = Rayfield:CreateWindow({
   Name = "Bao Menu",
   LoadingTitle = "Loading System...",
   LoadingSubtitle = "by Bao",
   ConfigurationSaving = {
      Enabled = false
   },
   Discord = {
      Enabled = false
   },
   KeySystem = false
})

-- 2. Create Tab
local Tab = Window:CreateTab("Features", 4483345998)

-- 3. State Configuration (Auto-enabled)
local SilentAimEnabled = true
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- 4. Toggle Button for "Bảo (Silent aim)"
local Toggle = Tab:CreateToggle({
   Name = "Bảo (Silent aim)",
   CurrentValue = true,
   Flag = "SilentAimToggle",
   Callback = function(Value)
      SilentAimEnabled = Value
   end,
})

-- 5. Target Scanning Function
local function GetClosestPlayer()
    local ClosestTarget = nil
    local MaxDistance = math.huge

    for _, Player in pairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character:FindFirstChild("Humanoid") and Player.Character.Humanoid.Health > 0 then
            local Position, OnScreen = game:GetService("Workspace").CurrentCamera:WorldToViewportPoint(Player.Character.HumanoidRootPart.Position)
            if OnScreen then
                local MousePosition = Vector2.new(Mouse.X, Mouse.Y)
                local TargetPosition = Vector2.new(Position.X, Position.Y)
                local Distance = (MousePosition - TargetPosition).Magnitude
                
                if Distance < MaxDistance then
                    ClosestTarget = Player.Character.HumanoidRootPart
                    MaxDistance = Distance
                end
            end
        end
    end
    return ClosestTarget
end

-- 6. Silent Aim Logic
local Namecall
Namecall = hookmetamethod(game, "__namecall", function(Self, ...)
    local Args = {...}
    local Method = getnamecallmethod()

    if SilentAimEnabled and (Method == "FindPartOnRayWithIgnoreList" or Method == "FindPartOnRay") then
        local Target = GetClosestPlayer()
        if Target then
            local Camera = game:GetService("Workspace").CurrentCamera
            Args = Ray.new(Camera.CFrame.Position, (Target.Position - Camera.CFrame.Position).Unit * 1000)
            return Namecall(Self, unpack(Args))
        end
    end

    return Namecall(Self, ...)
end)

-- Notify user that script loaded successfully
Rayfield:Notify({
   Title = "Success",
   Content = "Bảo (Silent aim) has been auto-activated!",
   Duration = 5,
   Image = 4483345998,
})
