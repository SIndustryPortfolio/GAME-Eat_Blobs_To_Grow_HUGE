local FoodGeneratorModule = {}

-- Dirs
local SharedModulesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Assets")["Modules"]

-- Modules
local UtilitiesModule = require(SharedModulesFolder["Utilities"])

-- Elements
-- UIs
--local HeadSignUi = script["HeadSign"]

-- CORE
local MaxFood = 5000 --10000

local FoodPortions = 
{
	["Small"] = 1,
	["Medium"] = 2,
	--["Large"] = 3	
}

-- Functions
-- MECHANICS
local function CreateRandomFoodPart()
	-- Functions
	-- INIT
	local PortionsArray = UtilitiesModule:GetDictKeys(FoodPortions)
	local ChosenPortion = PortionsArray[math.random(1, #PortionsArray)]
	
	local FoodPart = Instance.new("Part")
	local Size = math.clamp(FoodPortions[ChosenPortion] / 1.5, 0, 80)
	FoodPart.Size = Vector3.new(Size, Size, Size)
	FoodPart.Material = Enum.Material.SmoothPlastic
	FoodPart.Anchored = true
	FoodPart.CanCollide = false
	
	local RandomR = math.random(1, 255)
	local RandomG = math.random(1, 255)
	local RandomB = math.random(1, 255)
	
	FoodPart.Color = Color3.fromRGB(RandomR, RandomG, RandomB)
	
	FoodPart:SetAttribute("Food", math.floor(FoodPortions[ChosenPortion] --[[/ 3]]) --[[FoodPortions[ChosenPortion].X * 5]])
	
	--[[local HeadSign = HeadSignUi:Clone()
	HeadSign.Parent = FoodPart
	HeadSign.Title.Text = "Size: ".. tostring(FoodPart:GetAttribute("Food"))]]
	
	return FoodPart
end

local function SpawnFood()
	-- Functions
	-- INIT
	local BaseplatePart = workspace.Baseplate
	
	local FoodPart = CreateRandomFoodPart()
	
	local RandomX = math.random(BaseplatePart.Position.X - (BaseplatePart.Size.X / 2), BaseplatePart.Position.X + (BaseplatePart.Size.X / 2))
	local RandomZ = math.random(BaseplatePart.Position.Z - (BaseplatePart.Size.Z / 2), BaseplatePart.Position.Z + (BaseplatePart.Size.Z / 2))
	
	FoodPart.Position = Vector3.new(RandomX, FoodPart.Size.Y / 2, RandomZ)	
	FoodPart.Parent = workspace["Food"]
end

local function RegenFood()
	-- Functions
	--INIT
	for i = 1, math.floor(MaxFood * 0.75) do
		SpawnFood()
	end
end

local function Initialise()
	-- Functions
	-- INIT
	RegenFood()
	
	coroutine.wrap(function()
		while task.wait(.1) do
			if #workspace["Food"]:GetChildren() >= MaxFood then
				continue
			end
			
			SpawnFood()		
		end
	end)()
end

-- DIRECT
function FoodGeneratorModule.Initialise()
	return Initialise()
end

return FoodGeneratorModule