local GamepasssInfoModule = {}

-- Services
local MarketplaceService = game:GetService("MarketplaceService")

-- CORE
local GamepasssInfo = 
{
	["2X Coins Multiplier"] = {Id = 148007437, Icon = {Id = "rbxassetid://12764071365"}},
	["2X Size Multiplier"] = {Id = 148007618, Icon = {Id = "rbxassetid://12764070529"}},
	["Super Speed"] = {Id = 148007803, Icon = {Id = "rbxassetid://12764067798"}},
	["Custom Skin"] = {Id = 148007939, Icon = {Id = "rbxassetid://12764069617"}, Hidden = true},
	["Buffed Spawn"] = {Id = 148301371, Icon = {Id = "rbxassetid://12770498404"}}
}

-- Functions
-- DIRECT
function GamepasssInfoModule.GetInfo(NilParam, SettingName)
	return GamepasssInfo[SettingName]	
end

function GamepasssInfoModule.GetAllInfo()
	return GamepasssInfo
end

-- INIT
for ProductName, Info in pairs(GamepasssInfo) do
	local Success, ProductInfo = pcall(function()
		return MarketplaceService:GetProductInfo(Info["Id"], Enum.InfoType.GamePass)
	end)
	
	if not Success then
		continue
	end
	
	Info["Price"] = {Value = ProductInfo["PriceInRobux"], Type = "Robux"}
	Info["Description"] = ProductInfo["Description"]
	
	if not Info["Icon"] then
		Info["Icon"] = {Id = ProductInfo["IconImageAssetId"]}
	end
end

return GamepasssInfoModule