local TitlesInfoModule = {}

-- CORE
local TitlesInfo = 
{
	["Poo"] = {Id = 0, Price = {Value = 150, Type = "Coins"}, IconType = "Text", Properties = {TextColor3 = Color3.fromRGB(170, 85, 0), Font = Enum.Font.PermanentMarker}},		
	["Noob"] = {Id = 1, Price = {Value = 500, Type = "Coins"}, IconType = "Text", Properties = {TextColor3 = Color3.fromRGB(255, 255, 0), Font = Enum.Font.DenkOne}},
	["Average"] = {Id = 2, Price = {Value = 2000, Type = "Coins"}, IconType = "Text", Properties = {TextColor3 = Color3.fromRGB(0, 255, 127), Font = Enum.Font.Antique}},
	["Pro"] = {Id = 3, Price = {Value = 5000, Type = "Coins"}, IconType = "Text", Properties = {TextColor3 = Color3.fromRGB(198, 198, 0), Font = Enum.Font.Creepster}},
	["Super"] = {Id = 4, Price = {Value = 7500, Type = "Coins"}, IconType = "Text", Properties = {TextColor3 = Color3.fromRGB(85, 255, 255), Font = Enum.Font.ArialBold}},
	["Ultimate"] = {Id = 5, Price = {Value = 15000, Type = "Coins"}, IconType = "Text", Properties = {TextColor3 = Color3.fromRGB(255, 0, 0), Font = Enum.Font.SpecialElite}},
	["Black Hole"] = {Id = 6, Price = {Value = 20000, Type = "Coins"}, IconType = "Text", Properties = {TextColor3 = Color3.fromRGB(0, 0, 0), Font = Enum.Font.SciFi}},
	["Money"] = {Id = 7, Price = {Value = 30000, Type = "Coins"}, IconType = "Text", Properties = {TextColor3 = Color3.fromRGB(85, 170, 0), Font = Enum.Font.Gotham}},
	["Retro"] = {Id = 8, Price = {Value = 40000, Type = "Coins"}, IconType = "Text", Properties = {TextColor3 = Color3.fromRGB(85, 85, 255), Font = Enum.Font.Arcade}},
	["Mega"] = {Id = 9, Price = {Value = 45000, Type = "Coins"}, IconType = "Text", Properties = {TextColor3 = Color3.fromRGB(255, 170, 0), Font = Enum.Font.Jura}},
	["Insane"] = {Id = 10, Price = {Value = 50000, Type = "Coins"}, IconType = "Text", Properties = {TextColor3 = Color3.fromRGB(170, 85, 127), Font = Enum.Font.Legacy}}
}

-- Functions
-- DIRECT

function TitlesInfoModule.GetInfo(NilParam, SettingName)
	return TitlesInfo[SettingName]
end

function TitlesInfoModule.GetAllInfo()
	return TitlesInfo
end

return TitlesInfoModule