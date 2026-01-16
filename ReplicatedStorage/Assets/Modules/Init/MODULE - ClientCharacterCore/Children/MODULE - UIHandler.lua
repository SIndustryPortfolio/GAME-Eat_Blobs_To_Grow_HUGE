local UIHandlerModule = {}

-- Dirs
local ModulesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Assets")["Modules"]
local InfoModulesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Assets")["InfoModules"]

-- Info Modules
local InventoryInfoModule = require(InfoModulesFolder["Inventory"])

-- Modules
local SoundsModule = require(ModulesFolder["Sounds"])
local UtilitiesModule = require(ModulesFolder["Utilities"])

-- CORE
local Connections = {}

-- Functions
-- MECHANICS
local function FoodChanged(Player, Character)
	-- Functions
	-- INIT
	--SoundsModule:PlaySoundEffectByName("Character", "Eat", nil, Character.PrimaryPart)
	
	local HeadSignBillboard = Character.PrimaryPart:WaitForChild("HeadSign")

	HeadSignBillboard.Size = UDim2.new(Character.PrimaryPart.Size.X * 2, 0, Character.PrimaryPart.Size.Y / 2, 0)
	HeadSignBillboard.StudsOffset = Vector3.new(0, Character.PrimaryPart.Size.Y, 0)
	HeadSignBillboard.Username.Text = tostring(Player.DisplayName or Player.Name).. " | Size: ".. tostring(Character:GetAttributes()["Food"] or 0)
	
	for i, SurfaceUi in pairs(Character.PrimaryPart:WaitForChild("Faces"):GetChildren()) do
		SurfaceUi:WaitForChild("Backing")["Amount"].Text = UtilitiesModule:FormatNumber(Character:GetAttributes()["Food"] or 0)
	end
end

local function HandleHeadSign(Player, Character)
	-- Elements
	-- UIs
	local HeadSign = Character.PrimaryPart:WaitForChild("HeadSign")
	
	-- FOLDERS
	local PlayerTitlesInventoryFolder = Player:WaitForChild("Game")["Inventory"]["Titles"]
	
	-- TEXTS
	local UsernameText = HeadSign["Username"]
	local TitleText = HeadSign["Title"]	
	
	-- Functions
	-- MECHANICS
	local function UpdateTitle()
		-- CORE
		local TitleName = PlayerTitlesInventoryFolder:GetAttributes()["Equipped"]
		local TitleInfo = InventoryInfoModule:GetInventoryInfo("Titles"):GetInfo(TitleName)
		
		-- Functions
		-- INIT
		
		if not TitleInfo then
			TitleText.Text = ""
		else
			TitleText.Text = TitleName
			
			UtilitiesModule:ApplyProperties(TitleText, TitleInfo["Properties"])
		end
	end
	
	-- DIRECT
	local Connection1 = PlayerTitlesInventoryFolder:GetAttributeChangedSignal("Equipped"):Connect(function()
		return UpdateTitle()
	end)
	
	-- INIT
	UsernameText.Text = tostring(Player.DisplayName or Player.Name).. " | Size: ".. tostring(Character:GetAttributes()["Food"] or 0)
	
	UpdateTitle()
	
	return {Connection1}
end

local function SkinChanged(Player, Character)
	-- CORE
	local SkinsInventoryFolder = Player:WaitForChild("Game")["Inventory"]["Skins"]
	local SkinInfo = InventoryInfoModule:GetInventoryInfo("Skins"):GetInfo(SkinsInventoryFolder:GetAttributes()["Equipped"]) or {["Icon"] = {}}
	
	-- Functions
	-- INIT
	--[[for i, SurfaceUi in pairs(Character.PrimaryPart:WaitForChild("Faces"):GetChildren()) do
		pcall(function()
			SurfaceUi:WaitForChild("Backing")["Skin"]["Image"] = SkinInfo["Icon"]["Id"] or ""
		end)
	end]]
	
	for i, Texture in pairs(Character.PrimaryPart:GetChildren()) do
		if not Texture:IsA("Texture") then
			continue
		end
		
		pcall(function()
			Texture.Texture = SkinInfo["Icon"]["Id"] or ""
		end)
	end
end

local function CharacterAdded(Player, Character)
	if Connections[Player] then
		UtilitiesModule:DisconnectConnections(Connections[Player])
	end
	
	-- Functions
	-- DIRECT
	local Connection1 = Character:GetAttributeChangedSignal("Food"):Connect(function()
		return FoodChanged(Player, Character)
	end)
	
	local Connection2 = Player:WaitForChild("Game")["Inventory"]["Skins"]:GetAttributeChangedSignal("Equipped"):Connect(function()
		return SkinChanged(Player, Character)
	end)	
	
	-- INIT
	local HeadSignConnections = HandleHeadSign(Player, Character)
	FoodChanged(Player, Character)
	SkinChanged(Player, Character)
	
	-- Connections
	Connections[Player] = {Connection1, Connection2, unpack(HeadSignConnections)}
end

local function CharacterRemoved(Player, Character)
	-- Functions
	-- INIT
	UtilitiesModule:DisconnectConnections(Connections[Player])
end

-- DIRECT
function UIHandlerModule.CharacterAdded(NilParam, Player, Character)
	return CharacterAdded(Player, Character)
end

function UIHandlerModule.CharacterRemoved(NilParam, Player, Character)
	return CharacterRemoved(Player, Character)
end

return UIHandlerModule