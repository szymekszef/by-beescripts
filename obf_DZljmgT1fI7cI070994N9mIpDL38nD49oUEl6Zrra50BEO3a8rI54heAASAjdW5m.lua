--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "BeeScripts | South Of Bronx",
   LoadingTitle = "South Of Bronx",
   LoadingSubtitle = "by BeeScripts",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "BeeScripts"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },
   KeySystem = true, -- Set this to true to use our key system
   KeySettings = {
      Title = "Key | BeeScripts",
      Subtitle = "Key System",
      Note = "Key In https://discord.gg/8VArw6Ds7B",
      FileName = "BeeScripts", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = false, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = true, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"https://pastebin.com/raw/ffrVbHFS"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

--------------------------------------------------
-- SETTINGS (ALL OFF BY DEFAULT)
--------------------------------------------------

local ESPEnabled = false
local ShowBox = false
local ShowName = false
local ShowDistance = false
local ShowWeapon = false

local ESPColor = Color3.fromRGB(255,0,0)

local ESPCache = {}

--------------------------------------------------
-- TOOL DETECTION
--------------------------------------------------

local function GetToolName(character)
	for _, item in pairs(character:GetChildren()) do
		if item:IsA("Tool") then
			return item.Name
		end
	end
	return nil
end

--------------------------------------------------
-- CREATE ESP
--------------------------------------------------

local function CreateESP(player)
	if player == LocalPlayer then return end
	if not player.Character then return end
	if ESPCache[player] then return end

	local character = player.Character
	local head = character:FindFirstChild("Head")
	if not head then return end

	-- BOX
	local highlight = Instance.new("Highlight")
	highlight.Name = "ESP_Box"
	highlight.FillTransparency = 1
	highlight.OutlineColor = ESPColor
	highlight.Enabled = false
	highlight.Parent = character

	-- BILLBOARD
	local billboard = Instance.new("BillboardGui")
	billboard.Size = UDim2.new(0,150,0,40)
	billboard.StudsOffset = Vector3.new(0,2.5,0)
	billboard.AlwaysOnTop = true
	billboard.Adornee = head
	billboard.Enabled = false
	billboard.Parent = head

	local text = Instance.new("TextLabel")
	text.Size = UDim2.new(1,0,1,0)
	text.BackgroundTransparency = 1
	text.TextScaled = false
	text.TextSize = 14
	text.Font = Enum.Font.SourceSansBold
	text.TextColor3 = Color3.new(1,1,1)
	text.Parent = billboard

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 1
	stroke.Color = Color3.new(0,0,0)
	stroke.Parent = text

	ESPCache[player] = {
		Highlight = highlight,
		Billboard = billboard,
		Text = text
	}
end

--------------------------------------------------
-- UPDATE LOOP
--------------------------------------------------

RunService.Heartbeat:Connect(function()

	for _, player in pairs(Players:GetPlayers()) do
		if ESPEnabled then
			CreateESP(player)

			if ESPCache[player] and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				
				local data = ESPCache[player]

				-- BOX
				if ShowBox then
					data.Highlight.Enabled = true
					data.Highlight.OutlineColor = ESPColor
				else
					data.Highlight.Enabled = false
				end

				-- TEXT BUILD
				local parts = {}

				if ShowName then
					table.insert(parts, player.Name)
				end

				if ShowDistance and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
					local distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
					table.insert(parts, math.floor(distance) .. "m")
				end

				if ShowWeapon then
					local toolName = GetToolName(player.Character)
					if toolName then
						table.insert(parts, "[" .. toolName .. "]")
					end
				end

				data.Text.Text = table.concat(parts, " | ")
				data.Billboard.Enabled = true
			end
		end
	end
end)

--------------------------------------------------
-- CLEANUP
--------------------------------------------------

Players.PlayerRemoving:Connect(function(player)
	if ESPCache[player] then
		ESPCache[player].Highlight:Destroy()
		ESPCache[player].Billboard:Destroy()
		ESPCache[player] = nil
	end
end)

--------------------------------------------------
-- AUTO CREATE ESP ON JOIN / RESPAWN
--------------------------------------------------

local function SetupPlayer(player)
	if player == LocalPlayer then return end
	
	-- gdy postać się załaduje
	player.CharacterAdded:Connect(function()
		task.wait(0.5) -- mały delay żeby części się wczytały
		if ESPEnabled then
			CreateESP(player)
		end
	end)

	-- jeśli już ma postać (np. gdy skrypt się uruchomił później)
	if player.Character then
		if ESPEnabled then
			CreateESP(player)
		end
	end
end

-- dla nowych graczy
Players.PlayerAdded:Connect(function(player)
	SetupPlayer(player)
end)

-- dla graczy którzy już są w grze
for _, player in pairs(Players:GetPlayers()) do
	SetupPlayer(player)
end

Players.PlayerRemoving:Connect(function(player)
	if ESPCache[player] then
		ESPCache[player].Highlight:Destroy()
		ESPCache[player].Billboard:Destroy()
		ESPCache[player] = nil
	end
end)

--------------------------------------------------
-- UI
--------------------------------------------------

local VisualsTab = Window:CreateTab("👁️ Visuals", nil)

VisualsTab:CreateToggle({
	Name = "Enable ESP",
	CurrentValue = false,
	Callback = function(Value)
		ESPEnabled = Value
	end,
})

VisualsTab:CreateToggle({
	Name = "Show Box",
	CurrentValue = false,
	Callback = function(Value)
		ShowBox = Value
	end,
})

VisualsTab:CreateToggle({
	Name = "Show Name",
	CurrentValue = false,
	Callback = function(Value)
		ShowName = Value
	end,
})

VisualsTab:CreateToggle({
	Name = "Show Distance",
	CurrentValue = false,
	Callback = function(Value)
		ShowDistance = Value
	end,
})

VisualsTab:CreateToggle({
	Name = "Show Weapon",
	CurrentValue = false,
	Callback = function(Value)
		ShowWeapon = Value
	end,
})

VisualsTab:CreateColorPicker({
	Name = "ESP Color",
	Color = ESPColor,
	Callback = function(Value)
		ESPColor = Value
	end,
})