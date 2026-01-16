local CharacterCoreModule = {}

-- Dirs
local SharedCachesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Assets")["Caches"]
local SharedInfoModulesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Assets")["InfoModules"]
local SharedModulesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Assets")["Modules"]

-- Caches
local GamepassesCacheModule = require(SharedCachesFolder["Gamepasses"])

-- InfoModules
local StarterCharacterInfoModule = require(SharedInfoModulesFolder["StarterCharacter"])

-- Modules
local GameModule = require(SharedModulesFolder["Game"])
local DebugModule = require(SharedModulesFolder["Debug"])
local UtilitiesModule = require(SharedModulesFolder["Utilities"])

-- CORE
local LastFirstPlace = nil
local PlayerToConnections = {}

-- Services
local CollectionService = game:GetService("CollectionService")
local PhysicsService = game:GetService("PhysicsService")

-- Functions
-- MECHANICS
local function ApplyProperties(Model, Dictionary)
	-- Functions
	-- INIT
	for PartName, Properties in pairs(Dictionary) do
		local ToEdit = nil
		
		if PartName == "Default" then
			ToEdit = Model
		else
			ToEdit = Model:FindFirstChild(PartName)
		end
		
		for PropertyName, PropertyValue in pairs(Properties) do
			local Success, Error = pcall(function()
				ToEdit[PropertyName] = PropertyValue
			end)
			
			if not Success then
				local Success, Error = pcall(function()
					return ToEdit:SetAttribute(PropertyName, PropertyValue)
				end)
				
				if not Success then
					DebugModule:Print(script.Name.. " | ApplyProperties | ToEdit: ".. tostring(ToEdit).. " | Dictionary: ".. tostring(Dictionary).. " | Error: ".. tostring(Error))
				end
			end
		end
	end
end

local function UpdateFirstPlace(OrderedScores, AllScore)
	-- Functions
	-- INIT
	if LastFirstPlace then
		local FoundLastPlayer = game.Players:FindFirstChild(LastFirstPlace)
		
		if FoundLastPlayer then
			CollectionService:RemoveTag(FoundLastPlayer, "FirstPlace")
		end
	end
	
	local NewPlayer = game.Players:FindFirstChild(OrderedScores[1])
	
	if not table.find(CollectionService:GetTags(NewPlayer), "FirstPlace") then
		CollectionService:AddTag(NewPlayer, "FirstPlace")
	end
	
	LastFirstPlace = OrderedScores[1]
end

local function UpdateSize(Character, Food)
	-- Functions
	-- INIT
	local OrderedScores, AllScores = GameModule:GetOrderedScores()
	
	if OrderedScores[1] ~= LastFirstPlace then
		UpdateFirstPlace(OrderedScores, AllScores)
	end
	
	local Size = math.clamp(Food / 3, 0, 60)
	
	Character.PrimaryPart.Size = Vector3.new(Size, Size / 2, Size)
	
	for i, Texture in pairs(Character.PrimaryPart:GetChildren()) do
		if not Texture:IsA("Texture") then
			continue
		end
		
		Texture.StudsPerTileU = Size
		Texture.StudsPerTileV = Size
	end 
end

local function SetCollisionGroup(Character)
	-- Functions
	-- INIT
	for i, Part in pairs(Character:GetDescendants()) do
		if not Part:IsA("BasePart") then
			continue
		end
		
		Part.CollisionGroup = "Characters"
	end
end

local function CharacterDied(Player, Character)
	-- Functions
	-- INIT
	pcall(function()
		return Character:SetAttribute("Dead", true)
	end)
	
	UtilitiesModule:DisconnectConnections(PlayerToConnections[Player])
	
	task.wait(3)
	
	if Player then
		return Player:LoadCharacter()
	end
end

local function ForceField(Character)
	-- Functions
	-- INIT
	CollectionService:AddTag(Character, "ForceField")
	
	coroutine.wrap(function()
		task.wait(5)
		CollectionService:RemoveTag(Character, "ForceField")
	end)()
end

local function CharacterAdded(Player, Character)
	-- CORE
	local Died = false
	
	-- Elements
	local Humanoid = UtilitiesModule:WaitForChildOfClass(Character, "Humanoid")
	
	-- Functions
	-- INIT
	ApplyProperties(Character, StarterCharacterInfoModule:GetStarterCharacterInfo("Properties"))
	
	local RandomR = math.random(0, 255)
	local RandomG = math.random(0, 255)
	local RandomB = math.random(0, 255)
	
	Character.PrimaryPart.Color = Color3.fromRGB(RandomR, RandomG, RandomB)
	
	-- DIRECT
	local Connection1 = Character:GetAttributeChangedSignal("Food"):Connect(function()
		return UpdateSize(Character, Character:GetAttribute("Food"))
	end)
	
	local Connection2 = nil
	local Connection3 = nil
	
	Connection2 = Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
		if Died then
			return nil
		end
		
		if Humanoid.Health <= 0 then
			Died = true
			Connection2:Disconnect()
			
			DebugModule:Print(script.Name.. " | Committing Die")
			return CharacterDied(Player, Character)
		end
	end)
	
	Connection3 = Character:GetPropertyChangedSignal("Parent"):Connect(function()
		if Died then
			return nil
		end
		
		if not Character or not Character.Parent then
			Died = true
			
			DebugModule:Print(script.Name.. " | Committing Die")
			
			return CharacterDied(Player, Character)
		end
	end)
	
	-- CONNECTIONS
	PlayerToConnections[Player] = {Connection1, Connection2, Connection3}
	
	-- INIT
	ForceField(Character)
	SetCollisionGroup(Character)
	UpdateSize(Character, Character:GetAttribute("Food"))
	
	if GamepassesCacheModule:Get(Player, "Buffed Spawn") ~= nil then
		Character:SetAttribute("Food", Character:GetAttribute("Food") * 2)
	end
	
	if GamepassesCacheModule:Get(Player, "Super Speed") ~= nil then
		Humanoid.WalkSpeed *= 1.5
	end
	
	if Humanoid.Health <= 0 then
		return Died(Player, Character)
	end
end

local function CharacterRemoved(Player, Character)
	-- Functions
	-- INIT
	UtilitiesModule:DisconnectConnections(PlayerToConnections[Player])
end

-- DIRECT
function CharacterCoreModule.CharacterAdded(NilParam, Player, Character)
	return CharacterAdded(Player, Character)
end

function CharacterCoreModule.CharacterRemoved(NilParam, Player, Character)
	return CharacterRemoved(Player, Character)
end

return CharacterCoreModule