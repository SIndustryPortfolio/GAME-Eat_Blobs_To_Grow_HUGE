local FoodModule = {}

-- Dirs
local SharedCachesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Assets")["Caches"]
local SharedModulesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Assets")["Modules"]

-- Caches
local GamepassesCacheModule = require(SharedCachesFolder["Gamepasses"])

-- Modules

local UtilitiesModule = require(SharedModulesFolder["Utilities"])

-- CORE
local BeingEaten = {}

-- Services
local CollectionService = game:GetService("CollectionService")

-- Functions
-- MECHANICS
local function Kill(Character)
	-- Elements
	-- HUMANOIDS
	local Humanoid = UtilitiesModule:WaitForChildOfClass(Character, "Humanoid")
	
	-- Functions
	-- INIT
	Humanoid.Health = 0	
end

local function Eat(Player, Food)
	if BeingEaten[Food] then
		return nil
	end
	
	-- CORE
	local PlayerCharacter = UtilitiesModule:GetCharacter(Player, true)
	--local FoodRoot = UtilitiesModule:GetRootModel(Food)
	
	local FoodPlayer = game.Players:GetPlayerFromCharacter(Food)
	
	if not PlayerCharacter then
		return nil
	end
	
	if not Food then
		return nil
	end
	
	-- Functions
	-- INIT
	if Food:GetAttributes()["Dead"] then
		return nil
	end
	
	if PlayerCharacter:GetAttributes()["Food"] <= Food:GetAttributes()["Food"] then
		return nil
	end
	
	if table.find(CollectionService:GetTags(Food), "ForceField") then
		return nil
	end
	
	BeingEaten[Food] = true
	
	local FoodToAdd = Food:GetAttributes()["Food"]
	local CoinsToAdd = Food:GetAttributes()["Food"]
	
	if GamepassesCacheModule:Get(Player, "2X Size Multiplier") ~= nil then
		FoodToAdd *= 2
	end
	
	if GamepassesCacheModule:Get(Player, "2X Coins Multiplier") ~= nil then
		CoinsToAdd *= 2
	end
	
	PlayerCharacter:SetAttribute("Food", PlayerCharacter:GetAttributes()["Food"] + FoodToAdd)
	Player:SetAttribute("Coins", Player:GetAttribute("Coins") + CoinsToAdd)
	
	if not FoodPlayer then
		Food:Destroy()
	else
		Kill(--[[FoodRoot]] Food)
	end
	
	task.wait(.1)
	BeingEaten[Food] = nil
end

-- CORE FUNCTIONS
local ClientRequests = 
{
	["Eat"] = Eat
}

-- MECHANICS
local function ClientRequest(Player, FunctionName, ...)
	return ClientRequests[FunctionName](Player, ...)
end

-- DIRECT
function FoodModule.ClientRequest(NilParam, Player, FunctionName, ...)
	return ClientRequest(Player, FunctionName, ...)
end

return FoodModule