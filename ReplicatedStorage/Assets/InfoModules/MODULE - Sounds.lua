local SoundsInfoModule = {}

-- CORE
local EffectClassNames = {"FlangeSoundEffect", "EqualizerSoundEffect", "ReverbSoundEffect", "EchoSoundEffect", "CompressorSoundEffect", "TremoloSoundEffect"}

local Music = 
{
	["Main"] = {Id = "rbxassetid://5409360995"}	
}

local SoundEffects = 
{
	["Character"] = 
	{
		["Eat"] = {Id = "rbxassetid://5363075887"}	
	},
	["Button"] = 
	{
		["Hover"] = {Id = "rbxassetid://3199281218"},
		["Click"] = {Id = "rbxassetid://5852470908"}	
	},
	["Game"] = 
	{
		["FirstPlace"] = {Id = "rbxassetid://3295473241"}
	},
	["Shop"] = 
	{
		["PurchaseComplete"] = {Id = "rbxassetid://2609873966"}	
	}
}


local MusicEffectLists = 
{
	["InterfaceOverlay"] = {Equalizer = {HighGain = -80, MidGain = -80, LowGain = 0}}
}

--
local SoundTypes = 
{
	["Effects"] = SoundEffects,
	["Music"] = Music
}

-- Functions

function SoundsInfoModule.GetSounds(NilParam, SoundType)
	return SoundTypes[SoundType]
end

function SoundsInfoModule.GetMusicEffects()
	return MusicEffectLists
end

function SoundsInfoModule.GetSoundEffectClasses()
	return EffectClassNames
end

return SoundsInfoModule