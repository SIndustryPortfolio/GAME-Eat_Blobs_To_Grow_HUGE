local MapModule = {}

-- Dirs
local MiscFolder = workspace:WaitForChild("Misc")

-- Services
local RunService = game:GetService("RunService")

-- Functions
-- MECHANICS
local function RenderBlock()
	-- Functions
	-- INIT
	MiscFolder["MiddleBlock"].CFrame *= CFrame.Angles(0, math.rad(1), math.rad(1))
end

local function Initialise()
	-- Functions
	-- INIT
	RunService:BindToRenderStep("MiddleCube", Enum.RenderPriority.Last.Value, RenderBlock)
end

-- DIRECT
function MapModule.Initialise()
	return Initialise()
end

return MapModule