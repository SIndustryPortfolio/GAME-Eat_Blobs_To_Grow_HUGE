local EatHandlerModule = {}

-- Dirs
local ModulesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Assets")["Modules"]
local ClientServerRemotesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")["ClientServer"]["Remotes"]

-- Modules
local DebugModule = require(ModulesFolder["Debug"])
local UtilitiesModule = require(ModulesFolder["Utilities"])

-- Client
local LocalPlayer = game.Players.LocalPlayer

-- Elements
-- REMOTES
local FoodRemote = ClientServerRemotesFolder["Food"]

-- CORE
local Character = script.Parent.Parent
local Connections = {}

local Eating = {}

-- Functions
-- MECHANICS
local function FoodTouched(Model)
	-- Functions
	-- INIT
	local RootModel = UtilitiesModule:GetRootModel(Model)
	
	if RootModel then
		Model = RootModel
	end
	
	if not Model then
		return nil
	end
	
	if Eating[Model] then
		return nil
	end
	
	if not Model:GetAttributes()["Food"] then
		return nil
	end
	
	Eating[Model] = true
	
	if Character:GetAttribute("Food") > Model:GetAttribute("Food") then
		FoodRemote:FireServer("Eat", Model)
	end
	
	task.wait(.1)
	
	Eating[Model] = nil
end

local function Initialise()
	-- Functions
	-- DIRECT
	local Connection1 = Character.PrimaryPart.Touched:Connect(function(Hit)
		return FoodTouched(Hit)
	end)
	
	-- CONNECTIONS
	table.insert(Connections, Connection1)
end

local function End()
	-- Functions
	-- INIT
	UtilitiesModule:DisconnectConnections(Connections)
end

-- DIRECT
function EatHandlerModule.Initialise()
	return Initialise()
end

function EatHandlerModule.End()
	return End()
end

return EatHandlerModule