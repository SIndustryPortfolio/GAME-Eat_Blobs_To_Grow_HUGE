local DeadHandlerModule = {}

-- Dirs
local ModulesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Assets")["Modules"]

-- Modules
local UtilitiesModule = require(ModulesFolder["Utilities"])

-- CORE
local Connections = {}
local TweenDict = {}

local DeadEffectInfo = 
{
	["Duration"] = 3,
	["Style"] = Enum.EasingStyle.Linear,
	["Direction"] = Enum.EasingDirection.InOut
}

-- Services
local TweenService = game:GetService("TweenService")

-- Functions
-- MECHANICS
local function CharacterDied(Character)
	-- CORE
	local tweenInfo = TweenInfo.new(DeadEffectInfo["Duration"], DeadEffectInfo["Style"], DeadEffectInfo["Direction"])
	
	-- Functions
	-- INIT
	local ClassNameToProperties = 
	{
		["TextLabel"] = {"TextTransparency", "TextStrokeTransparency"},
		["ImageLabel"] = {"ImageTransparency"},
		["Part"] = {"Transparency"},
		["UIStroke"] = {"Transparency"}
	}

	for i, Part in pairs(Character:GetDescendants()) do
		if not ClassNameToProperties[Part.ClassName] then
			continue
		end
		
		local tweeningInfo = {}
		
		for x, PropertyName in pairs(ClassNameToProperties[Part.ClassName]) do
			tweeningInfo[PropertyName] = 1
		end
		
		UtilitiesModule:CancelTween(Part, TweenDict)
		TweenDict[Part] = TweenService:Create(Part, tweenInfo, tweeningInfo)
		TweenDict[Part]:Play()
		UtilitiesModule:CompleteTween(Part, TweenDict)
	end
end

local function CharacterAdded(Player, Character)
	if Connections[Player] then
		UtilitiesModule:DisconnectConnections(Connections[Player])
	end
	
	-- Functions
	-- DIRECT
	local Connection1 = Character:GetAttributeChangedSignal("Dead"):Connect(function()
		return CharacterDied(Character)
	end)
	
	Connections[Player] = {Connection1}
	
	-- INIT
	if Character:GetAttributes()["Dead"] then
		return CharacterDied(Character)
	end
end

local function CharacterRemoved(Player, Character)
	-- Functions
	-- INIT
	UtilitiesModule:DisconnectConnections(Connections[Player])
end

-- DIRECT
function DeadHandlerModule.CharacterAdded(NilParam, Player, Character)
	return CharacterAdded(Player, Character)
end

function DeadHandlerModule.CharacterRemoved(NilParam, Player, Character)
	return CharacterRemoved(Player, Character)
end

return DeadHandlerModule