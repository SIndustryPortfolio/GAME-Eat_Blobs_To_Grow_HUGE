local CratesInfoModule = {}

-- CORE
local CrateInfo = 
{
	["Common"] = {Id = 0, Price = {Value = 100, Type = "Coins"}, Image = {Id = "rbxassetid://5371326235"}},
	["Uncommon"] = {Id = 1, Price = {Value = 300, Type = "Coins"}, Image = {Id = "rbxassetid://5371326814"}},
	["Rare"] = {Id = 2, Price = {Value = 500, Type = "Coins"}, Image = {Id = "rbxassetid://5371326685"}},
	["Epic"] = {Id = 3, Price = {Value = 750, Type = "Coins"}, Image = {Id = "rbxassetid://5371326420"}},
	["Legendary"] = {Id = 4, Price = {Value = 1000, Type = "Coins"}, Image = {Id = "rbxassetid://5371326560"}}
}

-- Functions
-- DIRECT
function CratesInfoModule.GetCrateInfo(NilParam, SettingName)
	return CrateInfo[SettingName]
end

function CratesInfoModule.GetAllCratesInfo()
	return CrateInfo
end

return CratesInfoModule