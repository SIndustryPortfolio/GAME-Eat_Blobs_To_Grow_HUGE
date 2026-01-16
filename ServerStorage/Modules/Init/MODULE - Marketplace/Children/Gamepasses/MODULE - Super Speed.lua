local GamepassModule = {}

-- Dirs
local SharedModulesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Assets")["Modules"]

-- Modules
local DebugModule = require(SharedModulesFolder["Debug"])
local UtilitiesModule = require(SharedModulesFolder["Utilities"])

-- Functions
-- MECHANICS
local function Initialise(Player)
	-- CORE
	local Character = UtilitiesModule:GetCharacter(Player, true)
	
	if not Character then
		return nil
	end
	
	-- Elements
	-- HUMANOIDS
	local Humanoid = UtilitiesModule:WaitForChildOfClass(Character, "Humanoid")
	
	-- Functions
	-- INIT
	Humanoid.WalkSpeed *= 1.5
end

-- DIRECT
function GamepassModule.Initialise(NilParam, ...)
	return Initialise(...)
end

return GamepassModule