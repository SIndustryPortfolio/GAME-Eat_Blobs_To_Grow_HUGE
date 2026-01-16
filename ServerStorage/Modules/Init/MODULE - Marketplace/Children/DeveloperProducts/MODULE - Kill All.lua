local KillAllModule = {}

-- Dirs
local SharedModulesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Assets")["Modules"]

-- Modules
local UtilitiesModule = require(SharedModulesFolder["Utilities"])

-- Functions
-- MECHANICS
local function Initialise(Player, Value)
	-- Functions
	-- INIT
	for i, Character in pairs(UtilitiesModule:GetCharacters()) do
		if game.Players:GetPlayerFromCharacter(Character) == Player then
			continue
		end
		
		Character.Humanoid.Health = 0
	end
end

-- DIRECT
function KillAllModule.Initialise(NilParam, ...)
	return Initialise(...)
end

return KillAllModule