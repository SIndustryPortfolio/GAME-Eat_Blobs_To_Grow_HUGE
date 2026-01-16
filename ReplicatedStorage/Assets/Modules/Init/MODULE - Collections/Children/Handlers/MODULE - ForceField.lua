local TagModule = {}

-- Dirs
local ModulesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Assets")["Modules"]
local MiscPartsFolder = game:GetService("ReplicatedStorage"):WaitForChild("Assets")["Parts"]["Misc"]

-- Modules
local UtilitiesModule = require(ModulesFolder["Utilities"])
local DebugModule = require(ModulesFolder["Debug"])
local SoundsModule = require(ModulesFolder["Sounds"])

-- CORE
local CharacterConnections = {}

-- Services
local RunService = game:GetService("RunService")

-- Functions
-- MECHANICS
local function ChangeSize(Character, ForceFieldPart)
	-- Functions
	-- INIT
	local FoundWeld = ForceFieldPart:FindFirstChildOfClass("ManualWeld") or ForceFieldPart:FindFirstChildOfClass("WeldConstraint")
	
	if FoundWeld then
		FoundWeld:Destroy()
	end
	
	ForceFieldPart.Size = Character.PrimaryPart.Size * 2
	ForceFieldPart.Position = Character.PrimaryPart.Position
	
	UtilitiesModule:WeldParts(ForceFieldPart, Character.PrimaryPart)
end

local function Initialise(Character)
	--UtilitiesModule:DisconnectConnections(CharacterConnections[Character])
	
	local ForceFieldPartClone
	
	-- Functions
	-- DIRECT
	local Connection1 = Character:WaitForChild("HumanoidRootPart"):GetPropertyChangedSignal("Size"):Connect(function()
		ChangeSize(Character, ForceFieldPartClone)
	end)
	
	-- CONNECTIONS	
	CharacterConnections[Character] = {Connection1}	
	
	-- INIT
	ForceFieldPartClone = MiscPartsFolder["CustomForceField"]:Clone()
	ForceFieldPartClone.Parent = Character
	
	ChangeSize(Character, ForceFieldPartClone)
end

local function End(Character)
	-- Functions
	-- INIT
	local FoundForceField = Character:FindFirstChild("CustomForceField")
	
	if FoundForceField then
		FoundForceField:Destroy()
	end
	
	UtilitiesModule:DisconnectConnections(CharacterConnections[Character])
end

-- DIRECT
function TagModule.Initialise(NilParam, Model)
	return Initialise(Model)
end

function TagModule.End(NilParam, Model)
	return End(Model)
end

return TagModule