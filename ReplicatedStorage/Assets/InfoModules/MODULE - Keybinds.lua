local KeybindsInfoModule = {}

-- CORE
local Keybinds = 
{
	["ToggleLeaderboard"] = {Enum.KeyCode.Tab}		
}

-- Functions
-- DIRECT
function KeybindsInfoModule.GetKeybindInfo(NilParam, SettingName)
	return Keybinds[SettingName]
end

function KeybindsInfoModule.GetAllKeybindsInfo()
	return Keybinds
end

return KeybindsInfoModule