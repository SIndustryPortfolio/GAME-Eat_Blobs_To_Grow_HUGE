local DeveloperProductsInfoModule = {}

-- Services
local MarketplaceService = game:GetService("MarketplaceService")

-- CORE
local DeveloperProductsInfo = 
{
	["100 Coins"] = {Id = 1481334334, Reward = {Type = "Coins", Value = 100}, Icon = {Id = "rbxassetid://5347960419"}, LayoutOrder = 1},
	["500 Coins"] = {Id = 1481334331, Reward = {Type = "Coins", Value = 500}, Icon = {Id = "rbxassetid://5347956362"}, LayoutOrder = 2},
	["1000 Coins"] = {Id = 1481334338, Reward = {Type = "Coins", Value = 1000}, Icon = {Id = "rbxassetid://5347978882"}, LayoutOrder = 3},
	["5000 Coins"] = {Id = 1481334340, Reward = {Type = "Coins", Value = 5000}, Icon = {Id = "rbxassetid://5348001600"}, LayoutOrder = 4},
	["100 Size"] = {Id = 1481334345, Reward = {Type = "Size", Value = 100}, LayoutOrder = 1},
	["500 Size"] = {Id = 1481334360, Reward = {Type = "Size", Value = 500}, LayoutOrder = 2},
	["1000 Size"] = {Id = 1481334323, Reward = {Type = "Size", Value = 1000}, LayoutOrder = 3},
	["10000 Size"] = {Id = 1481334353, Reward = {Type = "Size", Value = 10000}, LayoutOrder = 4},
	["Kill All"] = {Id = 1478512644, Rewarad = {Type = "KillAll", Value = 0}}
}

-- Functions
-- DIRECT
function DeveloperProductsInfoModule.GetInfo(NilParam, SettingName)
	return DeveloperProductsInfo[SettingName]	
end

function DeveloperProductsInfoModule.GetAllInfo()
	return DeveloperProductsInfo
end

-- INIT
for ProductName, Info in pairs(DeveloperProductsInfo) do
	local Success, ProductInfo = pcall(function()
		return MarketplaceService:GetProductInfo(Info["Id"], Enum.InfoType.Product)
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

return DeveloperProductsInfoModule