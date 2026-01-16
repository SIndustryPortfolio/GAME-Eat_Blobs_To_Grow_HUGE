local GamepassesCache = {}

-- CORE
local Gamepasses = {}

-- Functions
-- MECHANICS
local function Add(Player, Gamepass)
	-- Functions
	-- INIT
	if not Gamepasses[Player.UserId] then
		Gamepasses[Player.UserId] = {}
	end
	
	if not table.find(Gamepasses[Player.UserId], Gamepass) then
		table.insert(Gamepasses[Player.UserId], Gamepass)
	end
end

local function Remove(Player)
	-- Functions
	-- INIT
	Gamepasses[Player.UserId] = nil
end

-- DIRECT
function GamepassesCache.Get(NilParam, Player, GamepassName)
	if Gamepasses[Player.UserId] then
		return table.find(Gamepasses[Player.UserId], GamepassName)
	end
end

function GamepassesCache.GetAll()
	return Gamepasses
end

function GamepassesCache.Add(NilParam, Player, GamepassName)
	return Add(Player, GamepassName)
end

function GamepassesCache.Remove(NilParam, Player)
	return Remove(Player)
end


return GamepassesCache