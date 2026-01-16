local InventoryInfoModule = {}

-- Dirs
local ModulesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Assets")["Modules"]

-- Modules
local DebugModule = require(ModulesFolder["Debug"])

-- CORE
local RequiredModules = {}

-- Functions
-- MECHANICS
local function RunSubModules()
	-- Functions
	-- INIT
	for i, Module in pairs(script:GetChildren()) do
		local Success, Error = pcall(function()
			return require(Module)
		end)
		
		if not Success then
			DebugModule:Print(script.Name.. " | RunSubModules | Module: ".. tostring(Module).. " | Error: ".. tostring(Error))
		else
			RequiredModules[Module.Name] = Error
		end
	end
end

local function PackNames(Type, Names)
	-- CORE
	local Packed = {}
	
	-- Functions
	-- INIT
	for i, Name in pairs(Names or {}) do
		pcall(function()
			table.insert(Packed, RequiredModules[Type]:GetInfo(Name)["Id"])
		end)
	end
	
	return Packed
end

local function UnpackIds(Type, Ids)
	-- CORE
	local Unpacked = {}
	
	-- Functions
	-- INIT
	for i, Id in pairs(Ids) do
		for Name, Info in pairs(RequiredModules[Type]:GetAllInfo()) do
			if tonumber(Info["Id"]) == tonumber(Id) then
				table.insert(Unpacked, Name)
				break
			end
		end
	end
	
	return Unpacked
end

-- DIRECT
function InventoryInfoModule.PackNames(NilParam, Type, Names)
	return PackNames(Type, Names)
end

function InventoryInfoModule.UnpackIds(NilParam, Type, Ids)
	return UnpackIds(Type, Ids)
end

function InventoryInfoModule.GetInventoryInfo(NilParam, SettingName)
	return RequiredModules[SettingName]
end

function InventoryInfoModule.GetAllInventoryInfo()
	return RequiredModules
end

-- INIT
RunSubModules()

return InventoryInfoModule