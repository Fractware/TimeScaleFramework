local TimeScaleUtilities = script.Parent.TimeScaleUtilities

TimeScaleUtilities.Parent = game:GetService("ReplicatedStorage")

local DataModule = require(script.Parent.Data)
local TimeModule = require(script.Parent.Time)

TimeScaleUtilities:GetAttributeChangedSignal("TimeScale"):Connect(function()
	script.Parent.Time:SetAttribute("PreviousTimeScale", DataModule.TimeScale)
	
	DataModule.TimeScale = TimeScaleUtilities:GetAttribute("TimeScale")
	TimeModule:Apply()
end)

script.Parent.AnimationTracker.Parent = game:GetService("ReplicatedFirst")
