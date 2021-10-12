local AnimationTracks = {}
local Animators = {}
local StandardSpeeds = {}
local TimeScale = 1

local function AdjustSpeed(AnimationTrack)
	for _, Animator in pairs(Animators) do
		for _, AnimatorAnimationTrack in pairs(Animator:GetPlayingAnimationTracks()) do
			if AnimatorAnimationTrack == AnimationTrack then
				if game:GetService("CollectionService"):HasTag(Animator, "TimeScaleWhitelist") then
					AnimationTrack:AdjustSpeed(AnimationTrack.Length / (AnimationTrack.Length * TimeScale))
					break
				end
			end
		end
	end
end

local function AddAnimationTrack(Tagged)
	if (Tagged:IsA("AnimationController") or Tagged:IsA("Animator") or Tagged:IsA("Humanoid")) and game:GetService("CollectionService"):HasTag(Tagged, "TimeScaleWhitelist") then
		table.insert(Animators, Tagged)
		
		for _, AnimationTrack in pairs(Tagged:GetPlayingAnimationTracks()) do
			table.insert(AnimationTracks, AnimationTrack)
			AdjustSpeed(AnimationTrack)
			
			AnimationTrack.DidLoop:Connect(function()
				AdjustSpeed(AnimationTrack)
			end)
		end
		
		Tagged.AnimationPlayed:Connect(function(AnimationTrack)
			local Exists = false
			
			for _, Track in pairs(AnimationTracks) do
				if Track == AnimationTrack then
					Exists = true
					break
				end
			end
			
			if not Exists then
				table.insert(AnimationTracks, AnimationTrack)
				AdjustSpeed(AnimationTrack)
				
				AnimationTrack.DidLoop:Connect(function()
					AdjustSpeed(AnimationTrack)
				end)
			end
		end)
	end
end

game:GetService("CollectionService"):GetInstanceAddedSignal("TimeScaleWhitelist"):Connect(function(Tagged)
	AddAnimationTrack(Tagged)
end)

game:GetService("CollectionService"):GetInstanceRemovedSignal("TimeScaleWhitelist"):Connect(function(Tagged)
	if (Tagged:IsA("AnimationController") or Tagged:IsA("Animator") or Tagged:IsA("Humanoid")) and game:GetService("CollectionService"):HasTag(Tagged, "TimeScaleWhitelist") then
		for _, AnimationTrack in pairs(Tagged:GetPlayingAnimationTracks()) do
			AnimationTrack:AdjustSpeed(AnimationTrack.Length / (AnimationTrack.Length * 1))
		end
	end
end)

for _, Tagged in pairs(game:GetService("CollectionService"):GetTagged("TimeScaleWhitelist")) do
	AddAnimationTrack(Tagged)
end

game:GetService("ReplicatedStorage"):WaitForChild("TimeScaleUtilities"):GetAttributeChangedSignal("TimeScale"):Connect(function()
	TimeScale = game:GetService("ReplicatedStorage").TimeScaleUtilities:GetAttribute("TimeScale")
	
	for _, AnimationTrack in pairs(AnimationTracks) do
		AdjustSpeed(AnimationTrack)
	end
end)