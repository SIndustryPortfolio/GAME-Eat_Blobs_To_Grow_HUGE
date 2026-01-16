local MarketplaceInfoModule = {}

-- Dirs
local ModulesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Assets")["Modules"]

-- Modules
local DebugModule = require(ModulesFolder["Debug"])

-- CORE
local RequiredModules = {}

-- Functions
-- MECHANICS
local function RunSubModules()
	-- Functions
	-- INIT
	for i, Module in pairs(script:GetChildren()) do
		local Success, Error = pcall(function()
			return require(Module)
		end)
		
		if Success then
			RequiredModules[Module.Name] = Error
		else
			DebugModule:Print(script.Name.. " | RunSubModules | Module: ".. tostring(Module).. " | Error: ".. tostring(Error))
		end
	end
end

-- DIRECT
function MarketplaceInfoModule.GetMarketplaceInfo(NilParam, SettingName)
	return RequiredModules[SettingName]
end

function MarketplaceInfoModule.GetAllMarketplaceInfo()
	return RequiredModules
end

-- INIT
RunSubModules()

return MarketplaceInfoModule