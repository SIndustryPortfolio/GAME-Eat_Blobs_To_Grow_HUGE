local InfoModulesFixModule = {}

-- Dirs
local InfoModulesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Assets")["InfoModules"]

-- Functions
-- MECHANICS
local function Initialise()
	-- Functions
	-- INIT
	for i, Module in pairs(InfoModulesFolder:GetChildren()) do
		local Success, Error = pcall(function()
			return require(Module)
		end)
	end
end

-- DIRECT
function InfoModulesFixModule.Initialise()
	return Initialise()
end

return InfoModulesFixModule