local MiscModule = {}

-- Dirs
local ModulesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Assets")["Modules"]

-- Modules
local InterfacesModule = require(ModulesFolder["Interfaces"])

-- Services
local StarterGui = game:GetService("StarterGui")

-- Functions
-- MECHANICS
local function Initialise()
	-- Functions
	-- INIT	
	InterfacesModule:LoadPage("Custom", "Intro", true)
	
	coroutine.wrap(function()
		repeat 
			local success = pcall(function() 
				StarterGui:SetCore("ResetButtonCallback", false) 
			end)
			task.wait(1)
		until success
	end)()
end

-- DIRECT
function MiscModule.Initialise()
	return Initialise()
end

return MiscModule