local PlayerCoreModule = {}

-- Dirs
local SharedModulesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Assets")["Modules"]
local ServerInitModulesFolder = game:GetService("ServerStorage"):WaitForChild("Game")["Modules"]["Init"]

-- Modules
local UtilitiesModule = require(SharedModulesFolder["Utilities"])
local DebugModule = require(SharedModulesFolder["Debug"])
--
local CharacterCoreModule = require(script["CharacterCore"])
local PlayerManagementModule = require(script["PlayerManagement"])
--
local MarketplaceModule = require(ServerInitModulesFolder["Marketplace"])

-- CORE
local PlayerToConnections = {}

-- Services
local PhysicsService = game:GetService("PhysicsService")

-- Functions
-- MECHANICS
local function CharacterAdded(Player, Character)
	-- Functions
	-- INIT
	return CharacterCoreModule:CharacterAdded(Player, Character)
end

local function PlayerAdded(Player)
	-- Functions
	-- DIRECT
	local Connection1 = Player.CharacterAdded:Connect(function(Character)
		return CharacterAdded(Player, Character)
	end)
	
	-- Connections
	PlayerToConnections[Player] = {Connection1}
	
	-- INIT
	MarketplaceModule:PlayerAdded(Player)
	PlayerManagementModule:PlayerAdded(Player)
	
	Player:SetAttribute("Spawnable", true)
	
	if Player.Character then
		return CharacterAdded(Player, UtilitiesModule:GetCharacter(Player, true))
	else
		--return Player:LoadCharacter()
	end
end

local function PlayerRemoved(Player)
	-- Functions
	-- INIT
	UtilitiesModule:DisconnectConnections(PlayerToConnections[Player])
	
	MarketplaceModule:PlayerRemoved(Player)
	PlayerManagementModule:PlayerRemoved(Player)
end

local function Initialise()
	PhysicsService:RegisterCollisionGroup("Characters")
	PhysicsService:CollisionGroupSetCollidable("Characters", "Characters", false)
	
	task.wait(1)
	
	-- Functions
	-- DIRECT
	local Connection1 = game.Players.PlayerAdded:Connect(PlayerAdded)
	
	local Connection2 = game.Players.PlayerRemoving:Connect(PlayerRemoved)
	
	-- INIT
	for i, Player in pairs(game.Players:GetPlayers()) do
		local Success, Error = pcall(function()
			return PlayerAdded(Player)
		end)
		
		if not Success then
			DebugModule:Print(script.Name.. " | Initialise | Player: ".. tostring(Player).. " | Error: ".. tostring(Error))
		end
	end
end

-- CORE FUNCTIONS
local ClientRequests = 
{
	["Spawn"] = function(Player)
		if not Player:GetAttributes()["Spawnable"] then
			return nil
		end
			
		return Player:LoadCharacter()
	end,		
}

-- DIRECT
function PlayerCoreModule.ClientRequest(NilParam, Player, FunctionName, ...)
	return ClientRequests[FunctionName](Player, ...)
end

function PlayerCoreModule.Initialise()
	return Initialise()
end

return PlayerCoreModule