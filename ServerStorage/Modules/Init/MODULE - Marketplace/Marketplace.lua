local MarketplaceModule = {}

-- Dirs
local SharedModulesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Assets")["Modules"]
local SharedCachesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Assets")["Caches"]
local SharedInfoModulesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Assets")["InfoModules"]

-- CACHES
local GamepassesCacheModule = require(SharedCachesFolder["Gamepasses"])

-- Info Modules
local MarketplaceInfoModule = require(SharedInfoModulesFolder["Marketplace"])

-- Modules
local DebugModule = require(SharedModulesFolder["Debug"])

-- CORE
local RequiredModules = {}

-- Services
local MarketplaceService = game:GetService("MarketplaceService")

-- Functions
-- MECHANICS
local function RunSubModules()
	-- Functions
	-- INIT
	for i, Folder in pairs(script:GetChildren()) do
		RequiredModules[Folder.Name] = {}
		
		for x, Module in pairs(Folder:GetChildren()) do
			local Success, Error = pcall(function()
				return require(Module)
			end)
			
			if not Success then
				DebugModule:Print(script.Name.." | RunSubModules | Module: ".. tostring(Module).. " | Error: ".. tostring(Error))
			else
				RequiredModules[Folder.Name][Module.Name] = Error
			end
		end
	end
end

local function GetGamepassFromId(Id)
	-- Functions
	-- INIT
	for GamepassName, GamepassInfo in pairs(MarketplaceInfoModule:GetMarketplaceInfo("Gamepasses"):GetAllInfo()) do
		if GamepassInfo["Id"] == Id then
			return GamepassName, GamepassInfo
		end
	end
end

local function GetProductFromId(Id)
	-- Functions
	-- INIT
	for ProductName, ProductInfo in pairs(MarketplaceInfoModule:GetMarketplaceInfo("DeveloperProducts"):GetAllInfo()) do
		if ProductInfo["Id"] == Id then
			return ProductName, ProductInfo
		end
	end
end

local function ProcessReceipt(ReceiptInfo)
	-- Functions
	-- INIT
	local Player = game.Players:GetPlayerByUserId(ReceiptInfo.PlayerId)
	local ProductId = ReceiptInfo.ProductId
	local ProductName, ProductInfo = GetProductFromId(ProductId)
	
	RequiredModules["DeveloperProducts"][ProductInfo["Reward"]["Type"]]:Initialise(Player, ProductInfo["Reward"]["Value"])
	
	return Enum.ProductPurchaseDecision.PurchaseGranted
end

local function GamepassPurchased(Player, GamepassId, WasPurchased)
	if not WasPurchased then
		return nil
	end
	
	-- Functions
	-- INIT
	local GamepassName, GamepassInfo = GetGamepassFromId(GamepassId)
	
	if not GamepassName then
		return DebugModule:Print(script.Name.. " | GamepassPurchased | No GamepassName for Id: ".. tostring(GamepassId).. " | Player: ".. tostring(Player))
	end
	
	GamepassesCacheModule:Add(Player, GamepassName)
	
	if RequiredModules["Gamepasses"][GamepassName] then
		return RequiredModules["Gamepasses"][GamepassName]:Initialise(Player)
	end
end

local function Initialise()
	-- Functions
	-- DIRECT
	local Connection1 = MarketplaceService.PromptGamePassPurchaseFinished:Connect(GamepassPurchased)
	
	MarketplaceService.ProcessReceipt = ProcessReceipt
	
	-- INIT
	RunSubModules()
end

local function PlayerAdded(Player)
	-- Functions
	-- INIT
	for GamepassName, GamepassInfo in pairs(MarketplaceInfoModule:GetMarketplaceInfo("Gamepasses"):GetAllInfo()) do
		local Success, Error = pcall(function()
			if MarketplaceService:UserOwnsGamePassAsync(Player.UserId, GamepassInfo["Id"]) then
				return GamepassesCacheModule:Add(Player, GamepassName)
			end
		end)
		
		if not Success then
			DebugModule:Print(script.Name.. " | PlayerAdded | Player: ".. tostring(Player).. " | GamepassName: ".. tostring(GamepassName).. " | Error: ".. tostring(Error))
		end
	end
end

local function PlayerRemoved(Player)
	-- Functions
	-- INIT
	GamepassesCacheModule:Remove(Player)
end

-- DIRECT
function MarketplaceModule.PlayerAdded(NilParam, Player)
	return PlayerAdded(Player)
end

function MarketplaceModule.PlayerRemoved(NilParam, Player)
	return PlayerRemoved(Player)
end

function MarketplaceModule.Initialise()
	return Initialise()
end

return MarketplaceModule