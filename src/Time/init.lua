local Time = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TimeScaleUtilities = require(ReplicatedStorage:WaitForChild("TimeScaleUtilities"))

local DataModule = require(script.Parent.Data)
local FasterModule = require(script.Faster)
local SlowerModule = require(script.Slower)

local function Set(Object)
	local TimeScale = DataModule.TimeScale

	local TimeScaleDifference = (TimeScale - DataModule.PreviousTimeScale) + 1

	if TimeScaleDifference < 0 then
		TimeScaleDifference = DataModule.PreviousTimeScale
		FasterModule:Apply(TimeScaleDifference, Object)
	else
		SlowerModule:Apply(TimeScaleDifference, Object)
	end
	--[[
	if Object then
		-- Only affect tweens for the specified object.
	else
		for _, Data in pairs(TimeScaleUtilities.TweenService.Tweens) do
			Data.Tween:Cancel()
			Data.TweenInfo = TweenInfo.new(Data.TweenInfo.Time / TimeScale, Data.TweenInfo.EasingStyle, Data.TweenInfo.EasingDirection, Data.TweenInfo.RepeatCount, Data.TweenInfo.Reverses, Data.TweenInfo.DelayTime)
			Data.Tween = game:GetService("TweenService"):Create(Data.Instance, Data.TweenInfo, Data.Goal)
			Data.Tween:Play()
		end
	end
	--]]
end

local function Unset(Object)
	local TimeScale = DataModule.TimeScale

	if TimeScale ~= 1 then
		FasterModule:Apply(TimeScale, Object)
	end
end

function Time:Apply(Object)
	if Object then
		Set(Object)
	else
		for Class, Objects in pairs(DataModule.PhysicsObjects) do
			for Checking, _ in pairs(Objects) do
				Set(Checking)
			end
		end
	end
end

function Time:Unapply(Object)
	if Object then
		Unset(Object)
	else
		for Class, Objects in pairs(DataModule.PhysicsObjects) do
			for Checking, _ in pairs(Objects) do
				Unset(Checking)
			end
		end
	end
end

return Time