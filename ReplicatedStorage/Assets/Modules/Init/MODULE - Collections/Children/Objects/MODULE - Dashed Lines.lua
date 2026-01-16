local TagModule = {}

-- Dirs
local MiscPartsFolder = game:GetService("ReplicatedStorage"):WaitForChild("Assets")["Parts"]["Misc"]
local ModulesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Assets")["Modules"]
local InfoModulesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Assets")["InfoModules"]

-- Client
local Player = game.Players.LocalPlayer

-- Info Modules

-- Modules
local UtilitiesModule = require(ModulesFolder["Utilities"])
local DebugModule = require(ModulesFolder["Debug"])
local InterfacesModule = require(ModulesFolder["Interfaces"])

-- CORE
local Connections = {}

-- Services
local RunService = game:GetService("RunService")

-- Functions
-- MECHANICS
local function Initialise(Model)
	-- CORE
	local Textures = {}
	local OffsetStuds = 5
	
	-- Functions
	-- INIT
	for i, _Instance in pairs(Model:GetDescendants()) do
		if _Instance:IsA("Texture") then
			table.insert(Textures, _Instance)
		end
	end
	
	-- DIRECT
	local Connection1 = UtilitiesModule:RenderSteppedFPSLock(20, function(Time) --RunService.Stepped:Connect(function(Time) --[[RunService.Stepped:Connect(]] --UtilitiesModule:RenderSteppedFPSLock(60, function(DeltaTime)		
		--[[if SettingsModule:GetSetting("Game", "Performance") then
			return nil
		end]]

		local RenderOffset = OffsetStuds * Time
		
		for i, Texture in pairs(Textures) do
			--Texture.OffsetStudsU += ToAdd
			Texture.OffsetStudsU = RenderOffset
		end
	end)
	
	-- CONNECTIONS
	Connections[Model] = {Connection1}
end

local function End(Model)
	-- Functions
	-- INIT
	UtilitiesModule:DisconnectConnections(Connections[Model])
end

-- DIRECT
function TagModule.Initialise(NilParam, Model)
	return Initialise(Model)
end

function TagModule.End(NilParam, Model)
	return End(Model)
end


return TagModule