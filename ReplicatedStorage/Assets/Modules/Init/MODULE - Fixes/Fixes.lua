local FixesModule = {}

-- Dirs
local ModulesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Assets")["Modules"]

-- Modules
local DebugModule = require(ModulesFolder["Debug"])

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
		end
	end
end

local function Initialise()
	-- Functions
	-- INIT
	RunSubModules()
end

-- DIRECT
function FixesModule.Initialise()
	return Initialise()
end

return FixesModule