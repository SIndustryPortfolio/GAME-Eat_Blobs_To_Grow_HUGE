local SkinsInfoModule = {}

-- CORE
local SkinsInfo = 
{
	["Rick Roll"] = {Id = 0, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://6403436054"}}	,
	["Shocked Guy"] = {Id = 1, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://11818627057"}},
	["Skibiti Bop"] = {Id = 2, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://12245026315"}},
	["Anime PFP"] = {Id = 3, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://11215017001"}},
	["Pirate Logo"] = {Id = 4, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://11588149408"}},
	["Gigachad"] = {Id = 5, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://9597859601"}},
	["Clown"] = {Id = 6, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://7866490119"}},
	["Silly cat"] = {Id = 7, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://11176073563"}},
	["Luffy"] = {Id = 8, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://10997211132"}},
	["Shrok"] = {Id = 9, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://9180614261"}},
	["Eye"] = {Id = 10, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://10657365540"}},
	["Rock"] = {Id = 11, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://8425069718"}},
	["Goofy ahh skull"] = {Id = 12, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://11795654320"}},
	["Smiling cat"] = {Id = 13, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://7545257075"}},
	["Troll face"] = {Id = 14, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://6862780932"}},
	["Megamind"] = {Id = 15, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://10180628683"}},
	["Super Happy Face"] = {Id = 16, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://5752915564"}},
	["Sanic"] = {Id = 17, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://10491133358"}},
	["Doggo"] = {Id = 18, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://9835676490"}},
	["Sad Spongebob"] = {Id = 19, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://10729455634"}},
	["Springtrap"] = {Id = 20, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://8419910877"}},
	["Sus Doggo"] = {Id = 21, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://11648237415"}},
	["Smile in the Dark"] = {Id = 22, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://9182757465"}},
	["Amazon Box"] = {Id = 23, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://4700049607"}},
	["Sad Face"] = {Id = 24, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://3868600"}},
	["Capybara"] = {Id = 25, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://11514025723"}},
	["Angry Apple"] = {Id = 26, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://9676989223"}},
	["Cute Face"] = {Id = 27, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://8837546203"}},
	["Albert"] = {Id = 28, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://7278293462"}},
	["Nerd"] = {Id = 29, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://9210647432"}},
	["Floppa"] = {Id = 30, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://9846392404"}},
	["SCP"] = {Id = 31, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://9859971166"}},
	["Sus"] = {Id = 32, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://5747127665"}},
	["Monkey"] = {Id = 33, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://4275313474"}},
	["Epic Dab Noob"] = {Id = 34, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://7175591276"}},
	["Shiny Teeth Face"] = {Id = 35, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://33615381"}},
	["Studs"] = {Id = 36, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://6927295847"}},
	["Cool Bacon"] = {Id = 37, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://9421679578"}},
	["Saul"] = {Id = 38, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://10776847010"}},
	["Beluga"] = {Id = 39, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://9835936735"}},
	["Classic Roblox"] = {Id = 40, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://7008159454"}},
	["Missing Texture"] = {Id = 41, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://9099782826"}},
	["Rainbow"] = {Id = 42, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://965496575"}},
	["Aesthetic"] = {Id = 43, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://6300279086"}},
	["Jerry"] = {Id = 44, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://5215883542"}},
	["Obunga"] = {Id = 45, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://11988370920"}},
	["Minion"] = {Id = 46, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://11624862066"}},
	["Walter"] = {Id = 47, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://11443492344"}},
	["Gru Goofy"] = {Id = 48, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://10111107769"}},
	["World Map"] = {Id = 49, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://10855627200"}},
	["Pink Hearts"] = {Id = 50, Price = {Value = 100, Type = "Coins"}, Icon = {Id = "rbxassetid://8712872843"}}
}

-- Functions
-- DIRECT
function SkinsInfoModule.GetInfo(NilParam, Type)
	return SkinsInfo[Type]
end

function SkinsInfoModule.GetAllInfo()
	return SkinsInfo
end

return SkinsInfoModule