local ProcessCommunicationsModule = {}

-- Dirs
local ServerModulesInitFolder = game:GetService("ServerStorage"):WaitForChild("Game")["Modules"]["Init"]
local ClientServerRemotesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")["ClientServer"]["Remotes"]
local ServerModulesFolder = game:GetService("ServerStorage"):WaitForChild("Game")["Modules"]

-- Modules
local FoodModule = require(ServerModulesFolder["Food"])
local PlayerCoreModule = require(ServerModulesInitFolder["PlayerCore"])

-- Elements
-- REMOTES
local FoodRemote = ClientServerRemotesFolder["Food"]
local GameProcessRemote = ClientServerRemotesFolder["GameProcess"]

-- Functions
-- CORE FUNCTIONS
local ClientRequests = 
{
	["PlayerCore"] = function(Player, FunctionName, ...)
		return PlayerCoreModule:ClientRequest(Player, FunctionName, ...)
	end,
}

-- MECHANICS
local function Initialise()
	-- Functions
	-- DIRECT
	local Connection1 = FoodRemote.OnServerEvent:Connect(function(Player, FunctionName, ...)
		return FoodModule:ClientRequest(Player, FunctionName, ...)
	end)
	
	local Connection2 = GameProcessRemote.OnServerEvent:Connect(function(Player, FunctionName, ...)
		return ClientRequests[FunctionName](Player, ...)
	end)
end

-- DIRECT
function ProcessCommunicationsModule.Initialise()
	return Initialise()
end

return ProcessCommunicationsModule