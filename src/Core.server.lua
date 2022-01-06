local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TimeScaleUtilities = script.Parent.TimeScaleUtilities

TimeScaleUtilities.Parent = ReplicatedStorage

local DataModule = require(script.Parent.Data)
local TimeModule = require(script.Parent.Time)

TimeScaleUtilities:GetAttributeChangedSignal("TimeScale"):Connect(function()
	DataModule.PreviousTimeScale = DataModule.TimeScale

	DataModule.TimeScale = TimeScaleUtilities:GetAttribute("TimeScale")
	TimeModule:Apply()
end)

script.Parent.AnimationTracker.Parent = ReplicatedFirst