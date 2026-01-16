local DeveloperProductModule = {}

-- Dirs
local SharedModulesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Assets")["Modules"]

-- Modules
local UtilitiesModule = require(SharedModulesFolder["Utilities"])

-- Functions
-- MECHANICS
local function Initialise(Player, SizeValue)
	-- CORE
	local Character = UtilitiesModule:GetCharacter(Player)
	
	-- Functions
	-- INIT
	Character:SetAttribute("Food", Character:GetAttribute("Food") + SizeValue)
end

-- DIRECT
function DeveloperProductModule.Initialise(NilParam, ...)
	return Initialise(...)
end

return DeveloperProductModule