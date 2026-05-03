local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- [[ AUTO TEAM SELECTOR (PIRATES) ]] --
task.spawn(function()
    repeat task.wait() until game:IsLoaded()
    local Player = game.Players.LocalPlayer
    local CommF = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_")
    
    while not Player.Team do
        task.wait(0.5)
        pcall(function()
            CommF:InvokeServer("SetTeam", "Pirates")
        end)
    end
end)

-- [[ WINDOW INITIALIZATION ]] --
local Window = Rayfield:CreateWindow({
   Name = "KayrexxHubV2 | Blox Fruits",
   LoadingTitle = "KayrexxHub Premium",
   LoadingSubtitle = "High Performance Mobile Script",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "KayrexxConfigs",
      FileName = "V2_Config"
   }
})

-- [[ GLOBAL VARIABLES ]] --
getgenv().AutoBounty = false
getgenv().FastAttack = false
getgenv().AutoV3 = false
getgenv().AutoV4 = false
getgenv().SafeMode = true
getgenv().AttackDistance = 5
local CombatRemote = game:GetService("ReplicatedStorage").RigControllerEvent

-- [[ MOBILE FLOATING BUTTON ]] --
local OpenCloseButton = Instance.new("ScreenGui")
local MainButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

OpenCloseButton.Name = "KayrexxButton"
OpenCloseButton.Parent = game:GetService("CoreGui")
MainButton.Parent = OpenCloseButton
MainButton.BackgroundColor3 = Color3.fromRGB(255, 46, 46)
MainButton.Position = UDim2.new(0, 10, 0.5, -25)
MainButton.Size = UDim2.new(0, 50, 0, 50)
MainButton.Font = Enum.Font.SourceSansBold
MainButton.Text = "K-V2"
MainButton.TextColor3 = Color3.new(1, 1, 1)
MainButton.Draggable = true
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainButton

MainButton.MouseButton1Click:Connect(function()
    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.RightControl, false, game)
end)

-- [[ TABS ]] --
local MainTab = Window:CreateTab("Main", 4483362458)
local RaceTab = Window:CreateTab("Race", 4483362458)
local ServerTab = Window:CreateTab("Server", 4483362458)

-- [[ MAIN TAB ]] --
MainTab:CreateSection("Bounty Hunter")

MainTab:CreateToggle({
   Name = "Auto Bounty (Safe Mode)",
   CurrentValue = false,
   Callback = function(Value) getgenv().AutoBounty = Value end,
})

MainTab:CreateToggle({
   Name = "Fast Attack (Optimized)",
   CurrentValue = false,
   Callback = function(Value) getgenv().FastAttack = Value end,
})

MainTab:CreateSlider({
   Name = "Attack Range",
   Min = 3, Max = 15, Default = 5,
   Callback = function(Value) getgenv().AttackDistance = Value end,
})

-- [[ RACE TAB ]] --
RaceTab:CreateSection("Auto Ability")

RaceTab:CreateToggle({
   Name = "Auto Use V3 (Skill T)",
   CurrentValue = false,
   Callback = function(Value) getgenv().AutoV3 = Value end,
})

RaceTab:CreateToggle({
   Name = "Auto Use V4 (Awakening Y)",
   CurrentValue = false,
   Callback = function(Value) getgenv().AutoV4 = Value end,
})

-- [[ SERVER TAB ]] --
ServerTab:CreateSection("Utility")

ServerTab:CreateButton({
   Name = "Smart Server Hop (No Restriction)",
   Callback = function()
       local HttpService = game:GetService("HttpService")
       local TeleportService = game:GetService("TeleportService")
       local function GetServers(cursor)
           local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
           if cursor then url = url .. "&cursor=" .. cursor end
           return HttpService:JSONDecode(game:HttpGet(url))
       end
       local serverList = GetServers()
       if serverList and serverList.nextPageCursor then serverList = GetServers(serverList.nextPageCursor) end
       for _, server in pairs(serverList.data) do
           if server.id ~= game.JobId and tonumber(server.playing) < tonumber(server.maxPlayers) then
               TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id)
               break
           end
       end
   end,
})

ServerTab:CreateButton({
   Name = "Rejoin Current Server",
   Callback = function()
       game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
   end,
})

-- [[ CORE FUNCTIONS ]] --

-- Get Closest Target
local function GetTarget()
    local closest, dist = nil, math.huge
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.Humanoid.Health > 0 then
            if v.Team ~= game.Players.LocalPlayer.Team then 
                local d = (v.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if d < dist then closest = v dist = d end
            end
        end
    end
    return closest
end

-- Fast Attack Logic
task.spawn(function()
    while true do
        task.wait(0.1)
        if getgenv().FastAttack then
            pcall(function()
                local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool and (tool.ToolTip == "Melee" or tool.ToolTip == "Sword") then
                    CombatRemote:FireServer("Attack")
                end
            end)
        end
    end
end)

-- Stick to Target Logic
game:GetService("RunService").Heartbeat:Connect(function()
    if getgenv().AutoBounty then
        local target = GetTarget()
        if target and target.Character then
            local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
            if hrp and targetHRP then
                hrp.CFrame = targetHRP.CFrame * CFrame.new(0, 2, getgenv().
            
