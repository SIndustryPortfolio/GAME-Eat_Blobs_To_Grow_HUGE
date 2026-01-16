local GameClientModule = {}

-- Dirs
local SharedModulesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Assets")["Modules"]

-- Modules
local UtilitiesModule = require(SharedModulesFolder["Utilities"])

-- Functions
-- MECHANICS
local function GetAllScores()
	-- Functions
	-- INIT
	local Scores = {}
	
	for i, Player in pairs(game.Players:GetPlayers()) do
		local Character = UtilitiesModule:GetCharacter(Player, true)
		
		if not Character then
			Scores[Player.Name] = 0
		else
			Scores[Player.Name] = Character:GetAttributes()["Food"] or 0
		end
	end
	
	return Scores
end

local function GetOrderedScores()
	-- Functions
	-- INIT
	local AllScores = GetAllScores()
	local OrderedArray = UtilitiesModule:GetDictKeys(AllScores)
		
	while true do
		local Pass = true
		for i, Name in pairs(OrderedArray) do
			if i >= #OrderedArray then
				break
			end
			
			local CurrentScore = AllScores[Name]
			
			local NextName = OrderedArray[i + 1]
			local NextScore = AllScores[NextName]
			
			if CurrentScore == nil or NextScore == nil then
				break
			end
			
			if NextScore > CurrentScore then
				Pass = false
				
				OrderedArray[i] = NextName
				OrderedArray[i + 1] = Name
				--table.remove(OrderedArray, i)
				--table.insert(OrderedArray, i + 1, CurrentScore)
				continue
			end
		end
		
		if Pass then
			break
		end
	end
	
	return OrderedArray, AllScores
end

-- DIRECT
function GameClientModule.GetOrderedScores()
	return GetOrderedScores()
end

return GameClientModule