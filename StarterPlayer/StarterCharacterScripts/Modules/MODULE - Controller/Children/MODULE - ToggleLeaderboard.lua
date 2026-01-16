local ToggleLeaderboardModule = {}

-- Dirs
local ModulesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Assets")["Modules"]

-- Modules
local InterfacesModule = require(ModulesFolder["Interfaces"])

-- Functions
-- MECHANICS
local function InputBegin()
	-- Functions
	-- INIT
	local HudGuiModule = InterfacesModule:GetUiModuleFromType("Custom", "Hud")
	
	if not HudGuiModule then
		return nil
	end
	
	HudGuiModule:HudProcess("Leaderboard", "ToggleLeaderboard")
end

local function InputEnd()
	-- Functions
	-- INIT
	
end

-- DIRECT
function ToggleLeaderboardModule.InputBegin()
	return InputBegin()
end

function ToggleLeaderboardModule.InputEnd()
	return InputEnd()
end

return ToggleLeaderboardModule