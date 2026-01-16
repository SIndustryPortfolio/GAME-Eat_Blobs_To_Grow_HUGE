local MusicModule = {}

-- Dirs
local ModulesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Assets")["Modules"]

-- Modules
local SoundsModule = require(ModulesFolder["Sounds"])

-- Functions
-- MECHANICS
local function Initialise()
	-- Functions
	-- INIT
	SoundsModule:PlayMusicByName("Main")
end

-- DIRECT
function MusicModule.Initialise()
	return Initialise()
end

return MusicModule