local ControllerModule = {}

-- Dirs
local ModulesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Assets")["Modules"]
local InfoModulesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Assets")["InfoModules"]

-- Info Modules
local KeybindsInfoModule = require(InfoModulesFolder["Keybinds"])

-- Modules
local UtilitiesModule = require(ModulesFolder["Utilities"])
local DebugModule = require(ModulesFolder["Debug"])

-- CORE
local Connections = {}
local RequiredModules = {}

-- Services
local ContextActionService = game:GetService("ContextActionService")

-- Functions
-- MECHANICS
local function HandleAction(ActionName, InputState, _InputObject)
	-- Functions
	-- INIT
	if InputState == Enum.UserInputState.Begin then
		return RequiredModules[ActionName]:InputBegin()
	elseif InputState == Enum.UserInputState.End then
		return RequiredModules[ActionName]:InputEnd()
	end
end

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
		
		if Success then
			RequiredModules[Module.Name] = Error
		else
			DebugModule:Print(script.Name.. " | RunSubModules | Module: ".. tostring(Module.Name).. " | Error: ".. tostring(Error))
		end
	end
end

local function Initialise()
	-- Functions
	-- INIT
	RunSubModules()
	
	for KeybindName, Keybinds in pairs(KeybindsInfoModule:GetAllKeybindsInfo()) do
		ContextActionService:BindAction(KeybindName, HandleAction, false, unpack(Keybinds))
	end
end

local function End()
	-- Functions
	-- INIT
	UtilitiesModule:DisconnectConnections(Connections)
end

-- DIRECT
function ControllerModule.Initialise()
	return Initialise()
end

function ControllerModule.End()
	return End()
end

return ControllerModule