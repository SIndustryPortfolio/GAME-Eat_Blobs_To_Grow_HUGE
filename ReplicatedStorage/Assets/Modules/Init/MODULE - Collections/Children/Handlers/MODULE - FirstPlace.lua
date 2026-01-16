local TagModule = {}

-- Dirs
local ModulesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Assets")["Modules"]
local MiscPartsFolder = game:GetService("ReplicatedStorage"):WaitForChild("Assets")["Parts"]["Misc"]

-- Modules
local UtilitiesModule = require(ModulesFolder["Utilities"])
local DebugModule = require(ModulesFolder["Debug"])
local SoundsModule = require(ModulesFolder["Sounds"])

-- CORE
local Connections = {}

-- Services
local RunService = game:GetService("RunService")

-- Functions
-- MECHANICS

local function ChangeSize(Model, HollowRingClone)
	-- Functions
	-- INIT
	HollowRingClone.Size = Vector3.new(Model.PrimaryPart.Size.X * 2.5, HollowRingClone.Size.Y, Model.PrimaryPart.Size.Z * 2.5)
	
	local FoundWeld = HollowRingClone:FindFirstChildOfClass("ManualWeld") or HollowRingClone:FindFirstChildOfClass("WeldConstraint")
	
	if FoundWeld then
		FoundWeld:Destroy()
	end
	
	HollowRingClone.Position = Model.PrimaryPart.Position + Vector3.new(0, -((Model.PrimaryPart.Size.Y / 2) - HollowRingClone.Size.Y / 2), 0)
	
	UtilitiesModule:WeldParts(HollowRingClone, Model.PrimaryPart)
end

local function CharacterAdded(Character)
	--CORE
	local HollowRingClone = MiscPartsFolder["HollowRing"]:Clone()
	
	-- Functions
	-- INIT
	local Connection1 = Character:WaitForChild("HumanoidRootPart"):GetPropertyChangedSignal("Size"):Connect(function()
		return ChangeSize(Character, HollowRingClone)
	end)
	
	-- CONNECTIONS
	table.insert(Connections, Connection1)
	
	-- INIT
	HollowRingClone.Parent = Character
	ChangeSize(Character, HollowRingClone)
	
	SoundsModule:PlaySoundEffectByName("Game", "FirstPlace", nil, Character.PrimaryPart)
end

local function Initialise(Player)
	UtilitiesModule:DisconnectConnections(Connections)
	
	-- Functions
	-- DIRECT
	local Connection1 = Player.CharacterAdded:Connect(CharacterAdded)

	-- CONNECTIONS	
	table.insert(Connections, Connection1)
	
	-- INIT
	local Character = UtilitiesModule:GetCharacter(Player, true)

	if Character then
		CharacterAdded(Character)
	end
end

local function End(Player)
	-- Functions
	-- INIT
	local Character = UtilitiesModule:GetCharacter(Player, true)
	
	if Character then
		local FoundHollowRing = Character:FindFirstChild("HollowRing")
		
		if FoundHollowRing then
			FoundHollowRing:Destroy()
		end
	end
end

-- DIRECT
function TagModule.Initialise(NilParam, Model)
	return Initialise(Model)
end

function TagModule.End(NilParam, Model)
	return End(Model)
end

return TagModule