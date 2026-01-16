local HandleSpawnModule = {}

-- Dirs
local Character = script.Parent.Parent

-- EXT
local ModulesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Assets")["Modules"]

-- Client
local Player = game.Players.LocalPlayer

-- Modules
local UtilitiesModule = require(ModulesFolder["Utilities"])
local InterfacesModule = require(ModulesFolder["Interfaces"])

-- CORE
local Connections = {}

-- Functions
-- MECHANICS
local function HandleCamera()
	-- Functions
	-- MECHANICS
	local function Update()
		-- Functions
		-- INIT
		Player.CameraMinZoomDistance = Character:GetAttribute("Food")
	end
	
	-- DIRECT
	local Connection1 = Character:GetAttributeChangedSignal("Food"):Connect(function()
		return Update()
	end)
	
	-- Connections
	table.insert(Connections, Connection1)
	
	-- INIT
	Update()
end

local function Initialise()
	-- Functions
	-- INIT
	InterfacesModule:LoadPage("Custom", "Hud", true)
	
	local AnimateScript = Character:WaitForChild("Animate")
	
	if AnimateScript then
		AnimateScript:Destroy()
	end
end

local function End()
	-- Functions
	-- INIT
	UtilitiesModule:DisconnectConnections(Connections)
end

-- DIRECT
function HandleSpawnModule.Initialise()
	return Initialise()
end

function HandleSpawnModule.End()
	return End()
end

return HandleSpawnModule