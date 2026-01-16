local InterfacesFixesModule = {}

-- Dirs
local InfoModulesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Assets")["InfoModules"]
local ModulesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Assets")["Modules"]

-- Client
local Player = game.Players.LocalPlayer

-- Info Modules
local InterfacesInfoModule = require(InfoModulesFolder["Interfaces"])

-- Modules
local UtilitiesModule = require(ModulesFolder["Utilities"])

-- Elements
-- FOLDERS
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Functions
-- MECHANICS
local function Initialise()
	-- Functions
	-- INIT
	for i, FolderName in pairs(UtilitiesModule:GetDictKeys(InterfacesInfoModule:GetInterfaceTypes())) do
		if PlayerGui:FindFirstChild(FolderName) then
			continue
		end
		
		local Folder = Instance.new("Folder")
		Folder.Name = FolderName
		Folder.Parent = PlayerGui
	end
end

-- DIRECT
function InterfacesFixesModule.Initialise()
	return Initialise()
end

return InterfacesFixesModule