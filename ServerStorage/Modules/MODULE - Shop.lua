local ShopModule = {}

-- Dirs
local SharedInfoModulesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Assets")["InfoModules"]

-- Info Modules
local InventoryInfoModule = require(SharedInfoModulesFolder["Inventory"])

-- Functions
-- MECHANICS
local function PlayerHasItem(Player, ItemType, ItemName)
	-- Functions
	-- INIT
	if Player["Game"]["Inventory"][ItemType]:FindFirstChild(ItemName) then
		return true
	end
end

local function Purchase(Player, ItemType, ItemName)
	-- Functions
	-- INIT
	local ItemInfo = InventoryInfoModule:GetInventoryInfo(ItemType):GetInfo(ItemName)
	
	if ItemInfo["Price"]["Type"] ~= "Coins" then
		return nil
	end
	
	if PlayerHasItem(Player, ItemType, ItemName) then
		return "Already have item"
	end
	
	if Player:GetAttribute("Coins") < ItemInfo["Price"]["Value"] then
		return "Not enough coins"
	end
	
	local BoolValue = Instance.new("BoolValue")
	BoolValue.Name = ItemName
	BoolValue.Parent = Player["Game"]["Inventory"][ItemType]
	
	Player:SetAttribute("Coins", Player:GetAttribute("Coins") - ItemInfo["Price"]["Value"])
	
	return true
end

-- CORE FUNCTIONS
local ClientRequests = 
{
	["Purchase"] = Purchase
}

-- DIRECT
function ShopModule.ClientRequest(NilParam, Player, FunctionName, ...)
	return ClientRequests[FunctionName](Player, ...)
end

return ShopModule