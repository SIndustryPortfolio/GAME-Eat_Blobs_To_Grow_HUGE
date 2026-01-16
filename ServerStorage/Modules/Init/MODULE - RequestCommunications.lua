local RequestCommunicationsModule = {}

-- Dirs
local ClientServerSignalsFolder = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")["ClientServer"]["Signals"]
local ServerModulesFolder = game:GetService("ServerStorage"):WaitForChild("Game")["Modules"]

-- Modules
local ServerShopModule = require(ServerModulesFolder["Shop"])
local ServerInventoryModule = require(ServerModulesFolder["Inventory"])

-- Elements
-- SIGNALS
local GameRequestSignal = ClientServerSignalsFolder["GameRequest"]

-- Functions
-- MECHANICS
local function Initialise()
	-- Functions
	-- MECHANICS
	local function OnGameRequestSignalInvoked(Player, ModuleName, ...)
		if ModuleName == "Shop" then
			return ServerShopModule:ClientRequest(Player, ...)
		elseif ModuleName == "Inventory" then
			return ServerInventoryModule:ClientRequest(Player, ...)
		end
	end
	
	-- DIRECT
	GameRequestSignal.OnServerInvoke = OnGameRequestSignalInvoked
end

-- DIRECT
function RequestCommunicationsModule.Initialise()
	return Initialise()
end

return RequestCommunicationsModule