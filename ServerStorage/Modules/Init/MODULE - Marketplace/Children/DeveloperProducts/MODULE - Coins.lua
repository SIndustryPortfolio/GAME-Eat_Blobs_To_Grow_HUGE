local DeveloperProductModule = {}

-- Functions
-- MECHANICS
local function Initialise(Player, CoinsValue)
	-- Functions
	-- INIT
	return Player:SetAttribute(script.Name, Player:GetAttribute(script.Name) + CoinsValue)
end

-- DIRECT
function DeveloperProductModule.Initialise(NilParam, ...)
	return Initialise(...)
end

return DeveloperProductModule