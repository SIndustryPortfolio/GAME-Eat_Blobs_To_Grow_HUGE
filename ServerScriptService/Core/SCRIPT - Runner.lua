-- Dirs
local ServerModulesInitFolder = game:GetService("ServerStorage"):WaitForChild("Game")["Modules"]["Init"]
local SharedModulesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Assets")["Modules"]

-- Modules
local DebugModule = require(SharedModulesFolder["Debug"])

-- Functions
-- MECHANICS
local function Initialise()
	-- Functions
	-- INIT
	for i, Module in pairs(ServerModulesInitFolder:GetChildren()) do
		coroutine.wrap(function()
			local Success, Error = pcall(function()
				local RequiredModule = require(Module)
				
				if RequiredModule and RequiredModule.Initialise ~= nil then
					return RequiredModule:Initialise()
				end
			end)
			
			if not Success then
				DebugModule:Print(script.Name.. " | Module: ".. tostring(Module).. " | Error: ".. tostring(Error))
			end
		end)()
	end
end

-- INIT
Initialise()