local StarterCharacterInfoModule = {}

-- CORE
local StarterCharacterInfo = 
{
	["Properties"] = 
	{
		["Default"] = 
		{
			["Food"] = 15,
		},
		["HumanoidRootPart"] = 
		{
			--["Size"] = Vector3.new(4, 4, 4)	
		}
	}		
}

-- Functions
-- DIRECT
function StarterCharacterInfoModule.GetStarterCharacterInfo(NilParam, SettingName)
	return StarterCharacterInfo[SettingName]
end

function StarterCharacterInfoModule.GetAllStarterCharacterInfo()
	return StarterCharacterInfo
end

return StarterCharacterInfoModule