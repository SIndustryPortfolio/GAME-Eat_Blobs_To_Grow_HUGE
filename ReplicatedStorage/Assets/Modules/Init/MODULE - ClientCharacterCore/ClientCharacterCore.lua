local ClientCharacterCoreModule = {}

-- Dirs
local ModulesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Assets")["Modules"]

-- Modules
local DebugModule = require(ModulesFolder["Debug"])
local UtilitiesModule = require(ModulesFolder["Utilities"])

-- CORE
local RequiredModules = {}
local Connections = {}
local CharacterConnections = {}

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

local function CharacterRemoved(Player, Character)
	-- Functions
	-- INIT
	for ModuleName, Module in pairs(RequiredModules) do
		Module:CharacterRemoved(Player, Character)
	end
end

local function CharacterAdded(Player, Character)
	-- Elements
	-- HUMANOIDS
	local Humanoid = UtilitiesModule:WaitForChildOfClass(Character, "Humanoid")
	
	-- Functions	
	-- DIRECT
	local Connection1 = Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
		if Humanoid.Health <= 0 then
			return CharacterRemoved()
		end
	end)
	
	-- Connections
	CharacterConnections[Player] = {Connection1}
	
	-- INIT	
	for ModuleName, Module in pairs(RequiredModules) do
		Module:CharacterAdded(Player, Character)
	end
end

local function PlayerAdded(Player)
	-- Functions
	-- DIRECT
	local Connection1 = Player.CharacterAdded:Connect(function(Character)
		return CharacterAdded(Player, Character)
	end)
	
	-- Connections
	Connections[Player] = {Connection1}
	
	-- INIT
	local Character = UtilitiesModule:GetCharacter(Player, true)
	
	if Character then
		return CharacterAdded(Player, Character)
	end
end

local function PlayerRemoved(Player)
	-- Functions
	-- INIT
	UtilitiesModule:DisconnectConnections(Connections[Player])
end

local function Initialise()
	-- Functions
	-- DIRECT
	local Connection1 = game.Players.PlayerAdded:Connect(PlayerAdded)
	local Connection2 = game.Players.PlayerRemoving:Connect(PlayerRemoved)
	
	-- INIT
	RunSubModules()
	
	for i, Player in pairs(game.Players:GetChildren()) do
		local Success, Error = pcall(function()
			return PlayerAdded(Player)
		end)
		
		if not Success then
			DebugModule:Print(script.Name.. " | Initialise | PlayerAdded | Player: ".. tostring(Player).. " | Error: ".. tostring(Error))
		end
	end
end

-- DIRECT
function ClientCharacterCoreModule.Initialise()
	return Initialise()
end

return ClientCharacterCoreModule