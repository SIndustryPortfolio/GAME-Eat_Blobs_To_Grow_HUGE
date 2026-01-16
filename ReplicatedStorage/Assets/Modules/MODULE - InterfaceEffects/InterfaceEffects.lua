local InterfaceEffectsModule = {}

-- Dirs
local ModulesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Assets")["Modules"]
local HudElementsFolder = game:GetService("ReplicatedStorage"):WaitForChild("Assets")["Parts"]["HudElements"]

-- Client
--local Player = game.Players.LocalPlayer
--local Mouse = Player:GetMouse()

-- Modules
local UtilitiesModule = require(ModulesFolder["Utilities"])
local SoundsModule = require(ModulesFolder["Sounds"])
local DebugModule = require(ModulesFolder["Debug"])

-- CORE
local RequiredModules = {}

local AllEffectInfo = 
{
	["Particles"] = 
	{
		["Horizontal"] = 
		{
			["Start"] = 
			{
				["X"] = {0, 0},
				["Y"] = {0, 1}
			},
			["End"] = 
			{
				["X"] = {1, 1},
				["Y"] = {0, 1}
			}
		}	
	},
	["MainButton"] = 
	{
		["Duration"] = 0.3,
		["Style"] = Enum.EasingStyle.Cubic,
		["Direction"] = Enum.EasingDirection.InOut,
			
		["HoverSizeMultiplier"] = 0.125,
		["RGBAmplifier"] = 200,
			
		["StrokeThickness"] = 5,
	},
	--[["ShopButton"] = 
	{
		["Duration"] = 0.3,
		["Style"] = Enum.EasingStyle.Cubic,
		["Direction"] = Enum.EasingDirection.InOut,
			
		["HoverSizeMultiplier"] = 0.125,
	},]]
	["Fade"] = 
	{
		["Duration"] = 1,
		["Style"] = Enum.EasingStyle.Cubic,
		["Direction"] = Enum.EasingDirection.InOut
	},
	["ExpandElement"] = 
	{
		["Duration"] = 0.5,
		["Style"] = Enum.EasingStyle.Cubic,
		["Direction"] = Enum.EasingDirection.InOut
	},
	["ShrinkElement"] = 
	{
		["Duration"] = 0.5,
		["Style"] = Enum.EasingStyle.Cubic,
		["Direction"] = Enum.EasingDirection.InOut	
	},
	["YTransitionIn"] = 
	{
		["Duration"] = 0.5,
		["Style"] = Enum.EasingStyle.Cubic,
		["Direction"] = Enum.EasingDirection.InOut
	},
	["YTransitionOut"] = 
	{
		["Duration"] = 0.5,
		["Style"] = Enum.EasingStyle.Cubic,
		["Direction"] = Enum.EasingDirection.InOut
	}
}

local ElementCache = {}
local TweenDict = {}

-- Services
local TweenService = game:GetService("TweenService")

-- Functions
-- MECHANICS
local function RunSubModules()
	-- Functions
	-- INIT
	for i, Module in pairs(script:GetChildren()) do
		local Success, RequiredModule = pcall(function()
			return require(Module)
		end)

		if Success then
			RequiredModules[Module.Name] = RequiredModule
		else
			DebugModule:Print(script.Name.. " | Error: ".. tostring(RequiredModule))
		end
	end
end


local function TweenWait(TweenElement)
	if TweenElement.PlaybackState == Enum.PlaybackState.Playing then
		TweenElement.Completed:Wait()
	end
end

local function IsUiAdditionalElement(Element)
	-- CORE
	local ClassNames = {"UIListLayout", "UIGradient", "UIGridLayout", "UIStroke" , "UIPadding", "Frame", "TextLabel", "Configuration", "UIAspectRatioConstraint"}
	
	-- Functions
	-- INIT
	for i, ClassName in pairs(ClassNames) do
		if Element:IsA(ClassName) then
			return true
		end
	end
	
	return false
end

local function MultiplyUDim2(UDim2Value, Multiplier)
	return UDim2.new(UDim2Value.X.Scale * Multiplier, UDim2Value.X.Offset * Multiplier, UDim2Value.Y.Scale * Multiplier, UDim2Value.Y.Offset * Multiplier)
end

local function Color3FromRGB(RGBValue)
	return Color3.fromRGB(RGBValue.R, RGBValue.G, RGBValue.B)
end

local function AddToColor3(RGBValue, Amplifier)
	return {R = RGBValue.R + Amplifier, G = RGBValue.G + Amplifier, B = RGBValue.B + Amplifier}
end

local function Color3ToRGB(Color3Value)
	return {R = Color3Value.r * 255, G = Color3Value.g * 255, B = Color3Value.b * 255}
end

local function CancelTween(TweenElement)
	if TweenDict[TweenElement] ~= nil then
		TweenDict[TweenElement]:Cancel()
		TweenDict[TweenElement]:Destroy()
	end
end

local function CompleteTween(TweenElement)
	if TweenDict[TweenElement] ~= nil then
		local Connection
		
		Connection = TweenDict[TweenElement].Completed:Connect(function(PlaybackStatus)
			if PlaybackStatus == Enum.PlaybackState.Completed then
				TweenDict[TweenElement]:Destroy()
			end
			
			Connection:Disconnect()
		end)
	end
end

local function CreateElementCache(Element, Properties)
	if not Element then
		return nil
	end
	
	if ElementCache[Element] == nil then
		ElementCache[Element] = {}
	end
	
	if not Properties then
		return nil
	end
	
	for i, PropertyName in pairs(Properties) do
		if ElementCache[Element][PropertyName] == nil then
			local Success, Error = pcall(function()
				ElementCache[Element][PropertyName] = Element[PropertyName]
			end)
			
			if not Success then
				ElementCache[Element][PropertyName] = Element:GetAttributes()[PropertyName]
			end
		end
	end
	
	return ElementCache[Element]
end

-- DIRECT
-- SINGLE LOADERS
function InterfaceEffectsModule.Fade(NilParam, Element, Type, _Wait, CustomEffectInfo, IgnoreProperties, ForceTweenTo, StartTransparency)
	if not Element then
		return nil
	end
	
	-- CORE
	local EffectInfo = CustomEffectInfo or AllEffectInfo["Fade"]
	local tweenInfo = TweenInfo.new(EffectInfo["Duration"], EffectInfo["Style"], EffectInfo["Direction"])
	
	local ClassToBackgroundProperties = 
	{
		["ImageLabel"] = {"ImageTransparency", "BackgroundTransparency"},
		["TextLabel"] = {"TextTransparency", "BackgroundTransparency"},
		["Frame"] = {"BackgroundTransparency"}	
	}
	
	local ChosenArrayOfProperties = ClassToBackgroundProperties[Element.ClassName]
	
	-- Functions
	-- INIT
	if IgnoreProperties then
		for i, PropertyName in pairs(IgnoreProperties) do
			local FoundIndex = table.find(ChosenArrayOfProperties, PropertyName)
			
			if FoundIndex then
				table.remove(ChosenArrayOfProperties, FoundIndex)
			end
		end
	end
	
	CreateElementCache(Element, ChosenArrayOfProperties)
	
	if StartTransparency then
		for i, PropertyName in pairs(ChosenArrayOfProperties) do
			Element[PropertyName] = StartTransparency
		end
	end
	
	-- Tween
	local tweeningInfo = {}
	
	for i, PropertyName in pairs(ChosenArrayOfProperties) do
		if Type == "In" then
			Element[PropertyName] = 1
			
			local ToTweenTo = ElementCache[Element][PropertyName] or 0
			
			if ForceTweenTo then
				ToTweenTo = ForceTweenTo
			end
			
			--[[if ToTweenTo == 1 then
				ToTweenTo = 0
			end]]
			
			tweeningInfo[PropertyName] = ToTweenTo
		elseif Type == "Out" then
			tweeningInfo[PropertyName] = 1
		end
	end

	CancelTween(Element)
	TweenDict[Element] = TweenService:Create(Element, tweenInfo, tweeningInfo)
	TweenDict[Element]:Play()
	CompleteTween(Element)
	
	if _Wait then
		TweenDict[Element].Completed:Wait()
	end
end

function InterfaceEffectsModule.YTransitionOut(NilParam, Element, _Wait)
	-- CORE
	local EffectInfo = AllEffectInfo["YTransitionOut"]
	local tweenInfo = TweenInfo.new(EffectInfo["Duration"], EffectInfo["Style"], EffectInfo["Direction"])
	
	-- Functions
	-- INIT
	CreateElementCache(Element, {"Position", "Size"})
	
	local ElementOldPosition = ElementCache[Element]["Position"]
	local ElementOldSize = ElementCache[Element]["Size"]
	
	-- Tween
	local tweeningInfo = {}
	tweeningInfo.Position = UDim2.new(ElementOldPosition.X.Scale, ElementOldPosition.X.Offset, -ElementOldSize.Y.Scale, -ElementOldSize.Y.Offset - 36)
	
	CancelTween(Element)
	TweenDict[Element] = TweenService:Create(Element, tweenInfo, tweeningInfo)
	TweenDict[Element]:Play()
	CompleteTween(Element)
	
	if _Wait then
		TweenWait(TweenDict[Element])
	end
end

function InterfaceEffectsModule.YTransitionIn(NilParam, Element, _Wait)
	-- CORE
	local EffectInfo = AllEffectInfo["YTransitionIn"]
	local tweenInfo = TweenInfo.new(EffectInfo["Duration"], EffectInfo["Style"], EffectInfo["Direction"])
	
	-- Functions
	-- INIT
	CreateElementCache(Element, {"Position", "Size"})
	
	local ElementOldPosition = ElementCache[Element]["Position"]
	local ElementOldSize = ElementCache[Element]["Size"]
	
	-- Properties
	Element.Position = UDim2.new(ElementOldPosition.X.Scale, ElementOldPosition.X.Offset, -ElementOldSize.Y.Scale, -ElementOldSize.Y.Offset - 36)
	
	-- TWEEN
	local tweeningInfo = {}
	tweeningInfo.Position = ElementOldPosition
	
	CancelTween(Element)
	TweenDict[Element] = TweenService:Create(Element, tweenInfo, tweeningInfo)
	TweenDict[Element]:Play()
	CompleteTween(Element)
		
	if _Wait then
		TweenWait(TweenDict[Element])
	end
end

function InterfaceEffectsModule.ExpandElement(NilParam, Element, _Wait, Axis)
	-- CORE
	local EffectInfo = AllEffectInfo["ExpandElement"]
	local tweenInfo = TweenInfo.new(EffectInfo["Duration"], EffectInfo["Style"], EffectInfo["Direction"])

	-- Functions
	-- INIT
	CreateElementCache(Element, {"Size"})
	
	-- Properties
	if Axis then
		if string.lower(Axis) == "x" then
			Element.Size = UDim2.new(0, 0, Element.Size.Y.Scale, Element.Size.Y.Offset)
		elseif string.lower(Axis) == "y" then
			Element.Size = UDim2.new(Element.Size.X.Scale, Element.Size.X.Offset, 0, 0)
		end
	else
		Element.Size = UDim2.new()
	end
	
	-- TWEEN
	local tweeningInfo = {}
	tweeningInfo.Size = ElementCache[Element]["Size"]
	
	CancelTween(Element)
	TweenDict[Element] = TweenService:Create(Element, tweenInfo, tweeningInfo)
	TweenDict[Element]:Play()
	CompleteTween(Element)
	
	if _Wait then
		TweenWait(TweenDict[Element])
	end
	
	return TweenDict[Element]
end

function InterfaceEffectsModule.ShrinkElement(NilParam, Element, _Wait, Axis)
	-- CORE
	local EffectInfo = AllEffectInfo["ShrinkElement"]
	local tweenInfo = TweenInfo.new(EffectInfo["Duration"], EffectInfo["Style"], EffectInfo["Direction"])

	-- Functions
	-- INIT
	CreateElementCache(Element, {"Size"})

	-- TWEEN
	local tweeningInfo = {}
	
	if Axis then
		if string.lower(Axis) == "x" then
			tweeningInfo.Size = UDim2.new(0, 0, Element.Size.Y.Scale, Element.Size.Y.Offset)
		elseif string.lower(Axis) == "y" then
			tweeningInfo.Size = UDim2.new(Element.Size.X.Scale, Element.Size.X.Offset, 0, 0)
		end		
	else
		tweeningInfo.Size = UDim2.new()
	end

	CancelTween(Element)
	TweenDict[Element] = TweenService:Create(Element, tweenInfo, tweeningInfo)
	TweenDict[Element]:Play()
	CompleteTween(Element)
	
	if _Wait then
		TweenWait(TweenDict[Element])
	end

	return TweenDict[Element]
end

function InterfaceEffectsModule.SpawnMovingParticle(NilParam, Parent, Name, Type, Size, Colour, ZIndex)
	if not Parent then
		return nil
	end
	
	local EffectInfo = AllEffectInfo["Particles"]
	
	local FoundParticle = HudElementsFolder["Particles"]:FindFirstChild(Name)
	if not FoundParticle then
		return nil
	end

	FoundParticle = FoundParticle:Clone()
	FoundParticle.ImageColor3 = Colour
	FoundParticle.Size = Size
	FoundParticle.ZIndex = ZIndex

	local UiAspectRatioConstraint = Instance.new("UIAspectRatioConstraint", FoundParticle)

	local tweenInfo = TweenInfo.new(5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
	local tweeningInfo = {}

	local ParticleMovementInfo = EffectInfo[Type]
	local StartX = math.random(ParticleMovementInfo["Start"]["X"][1] * 100, ParticleMovementInfo["Start"]["X"][2] * 100) / 100
	local StartY = math.random(ParticleMovementInfo["Start"]["Y"][1] * 100, ParticleMovementInfo["Start"]["Y"][2] * 100) / 100


	if Type == "Horizontal" then
		FoundParticle.Position = UDim2.new(StartX - (FoundParticle.Size.X.Scale), -FoundParticle.Size.X.Offset, StartY, 0)
	elseif Type == "Vertical" then
		FoundParticle.Position = UDim2.new(StartX, 0, StartY - (FoundParticle.Size.Y.Scale), -FoundParticle.Size.X.Offset)		
	end

	local EndX = math.random(ParticleMovementInfo["End"]["X"][1] * 100, ParticleMovementInfo["End"]["X"][2] * 100) / 100
	local EndY = math.random(ParticleMovementInfo["End"]["Y"][1] * 100, ParticleMovementInfo["End"]["Y"][2] * 100) / 100

	if Type == "Horizontal" then
		tweeningInfo.Position = UDim2.new(EndX + (FoundParticle.Size.X.Scale), FoundParticle.Size.X.Offset,  EndY, 0)
	elseif Type == "Verticle" then
		tweeningInfo.Position = UDim2.new(EndX, 0,  EndY + (FoundParticle.Size.Y.Scale), FoundParticle.Size.Y.Offset)
	end

	FoundParticle.Visible = true
	FoundParticle.Parent = Parent

	TweenDict[FoundParticle] = TweenService:Create(FoundParticle, tweenInfo, tweeningInfo)
	TweenDict[FoundParticle]:Play()

	UtilitiesModule:CompleteTween(FoundParticle, TweenDict)
	TweenDict[FoundParticle].Completed:Connect(function()
		FoundParticle:Destroy()
	end)
end

function InterfaceEffectsModule.CreateElementCache(NilParam, Element, Properties)
	-- Functions
	-- INIT
	return CreateElementCache(Element, Properties)
end


function InterfaceEffectsModule.InitialiseMainButton(NilParam, Button)
	if not Button then
		return nil
	end
	
	DebugModule:Print("Initialising Main Button: ".. tostring(Button))
	
	-- Elements
	-- FRAMES
	local InnerBackingFrame = Button["InnerBacking"]
	
	-- BUTTONS
	local Button = InnerBackingFrame["Button"]
	
	-- STROKES
	local UIStroke = InnerBackingFrame["UIStroke"]
	
	-- Core
	local EffectInfo = AllEffectInfo["MainButton"]
	local tweenInfo = TweenInfo.new(EffectInfo["Duration"], EffectInfo["Style"], EffectInfo["Direction"])
	
	local ClassToColourProperty = 
	{
		["ImageButton"] = "ImageColor3",
		["TextButton"] = "BackgroundColor3",
		["Frame"] = "BackgroundColor3"
	}	
	
	local ColourProperty = ClassToColourProperty[InnerBackingFrame.ClassName]
	
	-- Functions
	-- INIT
	CreateElementCache(InnerBackingFrame, {"Size", ColourProperty})
	
	-- DIRECT
	local Connection1 = Button.MouseEnter:Connect(function()
		-- CORE
		local NewSize = ElementCache[InnerBackingFrame]["Size"] +  MultiplyUDim2(ElementCache[InnerBackingFrame]["Size"], EffectInfo["HoverSizeMultiplier"])
		local NewColour = Color3FromRGB(AddToColor3(ElementCache[InnerBackingFrame][ColourProperty], EffectInfo["RGBAmplifier"]))
		
		-- TWEEN
		local tweeningInfo = {}
		tweeningInfo.Size = NewSize
		tweeningInfo[ColourProperty] = NewColour
		
		local tweeningInfo1 = {}
		tweeningInfo1.Thickness = EffectInfo["StrokeThickness"]
		
		CancelTween(UIStroke)
		TweenDict[UIStroke] = TweenService:Create(UIStroke, tweenInfo, tweeningInfo1)
		TweenDict[UIStroke]:Play()
		CompleteTween(UIStroke)
		
		CancelTween(InnerBackingFrame)
		TweenDict[InnerBackingFrame] = TweenService:Create(InnerBackingFrame, tweenInfo, tweeningInfo)
		TweenDict[InnerBackingFrame]:Play()
		CompleteTween(InnerBackingFrame)
		
		SoundsModule:PlaySoundEffectByName("Button", "Hover")
	end)
	
	local Connection2 = Button.MouseLeave:Connect(function()
		-- TWEEN
		local tweeningInfo = {}
		tweeningInfo.Size = ElementCache[InnerBackingFrame]["Size"]
		tweeningInfo[ColourProperty] = ElementCache[InnerBackingFrame][ColourProperty]
		
		local tweeningInfo1 = {}
		tweeningInfo1.Thickness = 0

		CancelTween(UIStroke)
		TweenDict[UIStroke] = TweenService:Create(UIStroke, tweenInfo, tweeningInfo1)
		TweenDict[UIStroke]:Play()
		CompleteTween(UIStroke)
		
		CancelTween(InnerBackingFrame)
		TweenDict[InnerBackingFrame] = TweenService:Create(InnerBackingFrame, tweenInfo, tweeningInfo)
		TweenDict[InnerBackingFrame]:Play()
		CompleteTween(InnerBackingFrame)
	end)
	
	local Connection3 = Button.MouseButton1Down:Connect(function()
		SoundsModule:PlaySoundEffectByName("Button", "Click")
	end)
	
	return {Connection1, Connection2, Connection3}
end

-- CONVERSION
local ButtonTypes = 
{
	["Main"] = {Function = InterfaceEffectsModule.InitialiseMainButton, ClassName = "Frame"},
}

-- GROUP LOADERS
function InterfaceEffectsModule.InitialiseButtons(NilParam, ButtonsFolder, ButtonType, ...)
	-- CORE
	local ButtonConnections = {}
	
	-- Functions
	-- INIT
	local InitialiseFunction = ButtonTypes[ButtonType]["Function"]
	local ClassNameExceptance = ButtonTypes[ButtonType]["ClassName"]
	
	for i, Button in pairs(ButtonsFolder:GetChildren()) do
		-- INIT
		if IsUiAdditionalElement(Button) then
			if not ClassNameExceptance then
				continue
			else
				if ClassNameExceptance ~= Button.ClassName then
					continue
				end
			end
		end
		
		-- DIRECT
		local _ButtonConnections = InitialiseFunction(nil, Button, ...)
			
		-- Connections
		for x, Connection in pairs(_ButtonConnections) do
			table.insert(ButtonConnections, Connection)
		end		
	end
	
	return ButtonConnections
end

--
function InterfaceEffectsModule.InterfaceEffectProcess(NilParam, FunctionName, ...)
	-- Functions
	-- INIT
	local Success, RequiredModule = pcall(function()
		return RequiredModules[FunctionName] --require(UtilitiesModule:WaitForChildTimed(script, FunctionName))
	end)
	
	if Success then
		if RequiredModule and RequiredModule.Initialise ~= nil then
			return RequiredModule:Initialise(...)
		end
	else
		--DebugModule:PrintRequiredModule, "Error")
	end
end

-- INIT
RunSubModules()

return InterfaceEffectsModule