local InventoryModule = {}

-- Functions
-- MECHANICS
local function DoesUserHaveItem(Player, Type, Name)
	-- Functions
	-- INIT
	local InventoryFolder = Player["Game"]["Inventory"][Type]
	
	return InventoryFolder:FindFirstChild(Name)
end

local function Unequip(Player, Type)
	-- Functions
	-- INIT
	local InventoryFolder = Player["Game"]["Inventory"][Type]
	InventoryFolder:SetAttribute("Equipped", "")
end

local function Equip(Player, Type, Name)
	-- Functions
	-- INIT
	if not DoesUserHaveItem(Player, Type, Name) then
		return "Doesn't have item"
	end
	
	local InventoryFolder = Player["Game"]["Inventory"][Type]
	InventoryFolder:SetAttribute("Equipped", Name)
end

-- CORE FUNCTIONS
local ClientRequests = 
{
	["Equip"] = Equip,
	["Unequip"] = Unequip
}

-- DIRECT
function InventoryModule.ClientRequest(NilParam, Player, FunctionName, ...)
	return ClientRequests[FunctionName](Player, ...)
end

return InventoryModule