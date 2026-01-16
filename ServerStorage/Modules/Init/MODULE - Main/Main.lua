local MainModule = {}

-- Dirs
local SharedModulesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Assets")["Modules"]

-- Modules
local DebugModule = require(SharedModulesFolder["Debug"])

-- CORE
local RequiredModules = {}

-- Functions
-- MECHANICS
local function RunSubModules()
	-- Functions
	-- INIT
	for i, Module in pairs(script:GetChildren()) do
		local Success, Error = pcall(function()
			local RequiredModule = require(Module)
			
			if RequiredModule and RequiredModule.Initialise ~= nil then
				RequiredModule:Initialise()
			end
			
			return RequiredModule
		end)
		
		if not Success then
			DebugModule:Print(script.Name.. " | RunSubModules | Module: ".. tostring(Module).. " | Error: ".. tostring(Error))
		else
			RequiredModules[Module.Name] = Error	
		end
	end
end

local function Initialise()
	-- Functions
	-- INIT
	RunSubModules()
end

-- DIRECT
function MainModule.Initialise()
	return Initialise()
end

return MainModule