-- Dirs
local ModulesInitFolder = game:GetService("ReplicatedStorage"):WaitForChild("Assets")["Modules"]["Init"]
local ModulesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Assets")["Modules"]

-- Modules
local DebugModule = require(ModulesFolder["Debug"])
local UtilitiesModule = require(ModulesFolder["Utilities"])

-- CORE
local CharacterConnections = {}

-- Client
local Player = game.Players.LocalPlayer

-- Functions
-- MECHANICS
local function RunCharacterModules(Character, Toggle)
	-- Functions
	-- INIT
	for i, Module in pairs(UtilitiesModule:WaitForChildTimed(Character, "Modules"):GetChildren()) do
		local Success, Error = pcall(function()
			local RequiredModule = require(Module)

			if RequiredModule then
				if Toggle and RequiredModule.Initialise ~= nil then
					return RequiredModule:Initialise()
				elseif RequiredModule.End ~= nil then
					return RequiredModule:End()
				end
			end
		end)

		if not Success then
			DebugModule:Print(script.Name.. " | Initialise | Module: ".. tostring(Module).. " | Error: ".. tostring(Error))
		end
	end
end

local function CharacterAdded(Character)
	UtilitiesModule:DisconnectConnections(CharacterConnections)
	
	-- Functions
	-- DIRECT
	local Connection1 = Character:GetPropertyChangedSignal("Parent"):Connect(function()
		if not Character or not Character.Parent then
			return RunCharacterModules(Character, false)
		end
	end)
	
	local Connection2 = UtilitiesModule:WaitForChildOfClass(Character, "Humanoid").Died:Connect(function()
		return RunCharacterModules(Character, false)
	end)
	
	-- INIT
	RunCharacterModules(Character, true)
end

local function Initialise()
	-- Functions
	-- INIT
	game.ReplicatedFirst:RemoveDefaultLoadingScreen()
	game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
	
	for i, Module in pairs(ModulesInitFolder:GetChildren()) do
		coroutine.wrap(function()
			local Success, Error = pcall(function()
				local RequiredModule = require(Module)
				
				if RequiredModule and RequiredModule.Initialise ~= nil then
					return RequiredModule:Initialise()
				end
			end)
			
			if not Success then
				DebugModule:Print(script.Name.. " | Initialise | Module: ".. tostring(Module).. " | Error: ".. tostring(Error))
			end
		end)()
	end
end

-- DIRECT
local Connection1 = Player.CharacterAdded:Connect(CharacterAdded)

-- INIT
Initialise()

local Character = UtilitiesModule:GetCharacter(Player, true)

if Character then
	return CharacterAdded(Character)
end