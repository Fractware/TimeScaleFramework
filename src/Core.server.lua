script.Parent.TimeScaleUtilities.Parent = game:GetService("ReplicatedStorage")

local DataModule = require(script.Parent.Data)
local TimeModule = require(script.Parent.Time)

local PreviousTimeScaleCache = game:GetService("ReplicatedStorage").TimeScaleUtilities:GetAttribute("TimeScale")

game:GetService("ReplicatedStorage").TimeScaleUtilities:GetAttributeChangedSignal("TimeScale"):Connect(function()
	script.Parent.Time:SetAttribute("PreviousTimeScale", PreviousTimeScaleCache)
	
	DataModule.TimeScale = game:GetService("ReplicatedStorage").TimeScaleUtilities:GetAttribute("TimeScale")
	TimeModule:Apply()
	
	PreviousTimeScaleCache = game:GetService("ReplicatedStorage").TimeScaleUtilities:GetAttribute("TimeScale")
end)

script.Parent.AnimationTracker.Parent = game:GetService("ReplicatedFirst")