local BrickColorsInfoModule = {}

-- CORE
local BrickColorNames = {}

-- Functions
-- DIRECT
function BrickColorsInfoModule.GetBrickColourNames()
	return BrickColorNames
end

-- INIT
for i = 1, 1032 do
	local Success, Color = pcall(function()
		return BrickColor.palette(i)
	end)
	
	if Success then
		table.insert(BrickColorNames, Color.Name)
	end
end

return BrickColorsInfoModule