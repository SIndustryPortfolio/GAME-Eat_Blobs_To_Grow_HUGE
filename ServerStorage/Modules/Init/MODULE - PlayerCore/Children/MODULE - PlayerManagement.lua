local PlayerManagementModule = {}

-- Dirs
local ServerModulesFolder = game:GetService("ServerStorage"):WaitForChild("Game")["Modules"]
local ServerAPIsFolder = game:GetService("ServerStorage"):WaitForChild("Game")["APIs"]
local ServerInfoModulesFolder = game:GetService("ServerStorage"):WaitForChild("Game")["InfoModules"]
local SharedModulesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Assets")["Modules"]
local SharedInfoModulesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Assets")["InfoModules"]


-- Info Modules
local DataStoreInfoModule = require(ServerInfoModulesFolder["DataStore"])

-- Info Modules
local InventoryInfoModule = require(SharedInfoModulesFolder["Inventory"])

-- Modules
local DebugModule = require(SharedModulesFolder["Debug"])
local UtilitiesModule = require(SharedModulesFolder["Utilities"])
local DataStore2Module = require(ServerAPIsFolder["DataStore2"])

-- CORE
local FolderHierarchy = 
{
	["Game"] = 
	{
		["Inventory"] = UtilitiesModule:GetDictKeys(DataStoreInfoModule:GetDataStoreInfo("InventoryStores"))
	}		
}


-- Functions
-- MECHANICS
local function Setup()
	-- Functions
	-- INIT
	local InventoryStores = UtilitiesModule:GetDictKeys(DataStoreInfoModule:GetDataStoreInfo("InventoryStores"))
	
	for i, StoreName in pairs({unpack(InventoryStores)}) do
		table.insert(InventoryStores, "Equipped".. tostring(StoreName))
	end
	
	DataStore2Module.Combine(DataStoreInfoModule:GetDataStoreInfo("MasterKey"), unpack(UtilitiesModule:CombineTables(InventoryStores, UtilitiesModule:GetDictKeys(DataStoreInfoModule:GetDataStoreInfo("AttributeStores")))))
end

local function BuildMainFolders(Player, CurrentDirectory, CurrentDict)
	-- Functions
	-- INIT
	for FolderName, SubFolders in pairs(CurrentDict or FolderHierarchy) do
		local Folder = Instance.new("Folder")
		Folder.Name = FolderName
		Folder.Parent = CurrentDirectory or Player
		
		if SubFolders[1] == nil then
			BuildMainFolders(Player, Folder, SubFolders)
		else
			for i, SubFolderName in pairs(SubFolders) do
				local NewFolder = Instance.new("Folder")
				NewFolder.Name = SubFolderName
				NewFolder.Parent = Folder
			end
		end
	end
end

local function BuildAttributeStores(Player)
	-- CORE
	local _Connections = {}
	
	-- Functions
	-- INIT
	for StoreName, DefaultValue in pairs(DataStoreInfoModule:GetDataStoreInfo("AttributeStores")) do
		local Store = DataStore2Module(StoreName, Player)
		
		Player:SetAttribute(StoreName, Store:Get(DefaultValue))
		
		local Connection1 = Player:GetAttributeChangedSignal(StoreName):Connect(function()
			return Store:Set(Player:GetAttribute(StoreName))
		end)
		
		-- CONNECTIONS
		table.insert(_Connections, Connection1)
	end
	
	return _Connections
end

local function BuildInventoryStores(Player)
	-- CORE
	local _Connections = {}
	
	-- Functions
	-- MECHANICS
	local function Update(InventoryFolder)
		if not Player then
			return nil
		end
		
		-- CORE
		local Store = DataStore2Module(InventoryFolder.Name, Player)
		
		-- Functions
		-- INIT
		local ChildrenNames = UtilitiesModule:GetChildrenNames(InventoryFolder)
		local PackedNames = InventoryInfoModule:PackNames(InventoryFolder.Name, ChildrenNames)
		
		DebugModule:Print(script.Name.. " | Saving Inventory | Player: ".. tostring(Player).. " | InventoryFolder: ".. tostring(InventoryFolder).. " | VVV")
		--print(PackedNames)
		
		Store:Set(PackedNames)
	end
	
	local function UnpackPacked(InventoryFolder)
		-- CORE
		local Store = DataStore2Module(InventoryFolder.Name, Player)
		
		-- Functions
		-- INIT
		--print("Saved")
		--print(Store:Get({}))
		
		local Unpacked = InventoryInfoModule:UnpackIds(InventoryFolder.Name, Store:Get({}))
		
		DebugModule:Print(script.Name.. " | Unpacking Inventory | Player: ".. tostring(Player).. " | InventoryFolder: ".. tostring(InventoryFolder).. " | VVV")
		--print(Unpacked)
		
		for i, ItemName in pairs(Unpacked) do
			local BoolValue = Instance.new("BoolValue")
			BoolValue.Name = ItemName
			BoolValue.Parent = InventoryFolder
		end
	end
	
	-- INIT
	for i, InventoryFolder in pairs(Player["Game"]["Inventory"]:GetChildren()) do
		-- CORE
		local Store = DataStore2Module(InventoryFolder.Name, Player)
		local EquippedStore = DataStore2Module("Equipped".. InventoryFolder.Name, Player)
		
		-- Functions
		-- INIT
		UnpackPacked(InventoryFolder)
		InventoryFolder:SetAttribute("Equipped", InventoryInfoModule:UnpackIds(InventoryFolder.Name, {EquippedStore:Get()})[1] or "")
		
		-- DIRECT
		local Connection1 = InventoryFolder.ChildAdded:Connect(function()
			return Update(InventoryFolder)
		end)
		
		local Connection2 = InventoryFolder.ChildRemoved:Connect(function()
			return Update(InventoryFolder)
		end)
		
		local Connection3 = InventoryFolder:GetAttributeChangedSignal("Equipped"):Connect(function()
			EquippedStore:Set(InventoryInfoModule:PackNames(InventoryFolder.Name, {InventoryFolder:GetAttribute("Equipped")})[1] or nil)
		end)
		
		-- CONNECTIONS
		table.insert(_Connections, Connection1)
		table.insert(_Connections, Connection2)
		table.insert(_Connections, Connection3)
	end
	
	
	return _Connections
end

local function PlayerAdded(Player)
	-- Functions
	-- INIT
	BuildMainFolders(Player)
	BuildAttributeStores(Player)
	BuildInventoryStores(Player)
end

local function PlayerRemoved(Player)
	-- Functions
	-- INIT
	
end

-- DIRECT
function PlayerManagementModule.PlayerAdded(NilParam, Player)
	return PlayerAdded(Player)
end

function PlayerManagementModule.PlayerRemoved(NilParam, Player)
	return PlayerRemoved(Player)
end

-- INIT
Setup()

return PlayerManagementModule