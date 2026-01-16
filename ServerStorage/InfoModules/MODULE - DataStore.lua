local DataStoreInfoModule = {}

-- CORE
local DataStoreInfo = 
{
	["MasterKey"] = "Test0",	
	["InventoryStores"] = 
	{
		["Titles"] = {},
		["Skins"] = {}
	},
	["AttributeStores"] = 
	{
		["Coins"] = 0		
	}
}

-- Functions
-- DIRECT
function DataStoreInfoModule.GetDataStoreInfo(NilParam, SettingName)
	return DataStoreInfo[SettingName]
end

function DataStoreInfoModule.GetAllDataStoreInfo()
	return DataStoreInfo
end

return DataStoreInfoModule