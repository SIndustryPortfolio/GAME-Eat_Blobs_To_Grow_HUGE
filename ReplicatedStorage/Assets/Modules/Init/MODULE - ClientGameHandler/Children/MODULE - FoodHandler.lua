local FoodHandlerModule = {}

-- Dirs
local SharedModulesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Assets")["Modules"]

-- Modules
local DebugModule = require(SharedModulesFolder["Debug"])

-- Elements
-- UIs
local HeadSign = script:WaitForChild("HeadSign")

-- CORE
local Connections = {}

-- Functions
-- MECHANICS
local function FoodAdded(Part)
	-- Functions
	-- INIT
	if not Part:GetAttributes()["Food"] then
		repeat
			if not Part then
				return nil
			end
			task.wait()
		until Part:GetAttributes()["Food"] ~= nil
	end
	
	local HeadSignClone = HeadSign:Clone()
	HeadSignClone.Title.Text = "Size: ".. tostring(Part:GetAttributes()["Food"])
	HeadSignClone.Parent = Part
	HeadSignClone.Adornee = Part
end

local function Initialise()
	-- Functions
	-- DIRECT
	local Connection1 = workspace["Food"].ChildAdded:Connect(function(Child)
		return FoodAdded(Child)
	end)
	
	-- CONNECTIONS
	table.insert(Connections, Connection1)
	
	-- INIT
	for i, Part in pairs(workspace["Food"]:GetChildren()) do
		coroutine.wrap(function()
			local Success, Error = pcall(function()
				return FoodAdded(Part)
			end)
			
			if not Success then
				DebugModule:Print(script.Name.. " | Initialise | Error: ".. tostring(Error))
			end
		end)()
	end
end

-- DIRECT
function FoodHandlerModule.Initialise()
	return Initialise()
end

return FoodHandlerModule