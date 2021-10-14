local CollectionService = game:GetService("CollectionService")

local TimeScaleUtilities = game:GetService("ReplicatedStorage"):WaitForChild("TimeScaleUtilities")

local AnimationTracks = {}
local Animators = {}
local StandardSpeeds = {}
local TimeScale = TimeScaleUtilities:GetAttribute("TimeScale")

local function AdjustSpeed(AnimationTrack)
	for Animator, _ in pairs(Animators) do
		for _, AnimatorAnimationTrack in pairs(Animator:GetPlayingAnimationTracks()) do
			if AnimatorAnimationTrack == AnimationTrack then
				if CollectionService:HasTag(Animator, "TimeScaleWhitelist") then
					AnimationTrack:AdjustSpeed(AnimationTrack.Length / (AnimationTrack.Length * TimeScale))
					break
				end
			end
		end
	end
end

local function AddAnimationTrack(AnimationTrack)
	if not AnimationTracks[AnimationTrack] then
		AnimationTracks[AnimationTrack] = true
		
		AdjustSpeed(AnimationTrack)
		
		AnimationTrack.DidLoop:Connect(function()
			AdjustSpeed(AnimationTrack)
		end)
	end
end

local function AddAnimator(Animator)
	if (Animator:IsA("AnimationController") or Animator:IsA("Animator") or Animator:IsA("Humanoid")) and CollectionService:HasTag(Animator, "TimeScaleWhitelist") then
		Animators[Animator] = true
		
		for _, AnimationTrack in pairs(Animator:GetPlayingAnimationTracks()) do
			AddAnimationTrack(AnimationTrack)
		end
		
		Animator.AnimationPlayed:Connect(function(AnimationTrack)
			AddAnimationTrack(AnimationTrack)
		end)
	end
end

CollectionService:GetInstanceAddedSignal("TimeScaleWhitelist"):Connect(function(Animator)
	AddAnimator(Animator)
end)

CollectionService:GetInstanceRemovedSignal("TimeScaleWhitelist"):Connect(function(Animator)
	if (Animator:IsA("AnimationController") or Animator:IsA("Animator") or Animator:IsA("Humanoid")) and CollectionService:HasTag(Animator, "TimeScaleWhitelist") then
		for _, AnimationTrack in pairs(Animator:GetPlayingAnimationTracks()) do
			AnimationTrack:AdjustSpeed(AnimationTrack.Length / (AnimationTrack.Length * 1))
			AnimationTracks[AnimationTrack] = nil
		end
		
		Animators[Animator] = nil
	end
end)

for _, Animator in pairs(CollectionService:GetTagged("TimeScaleWhitelist")) do
	AddAnimator(Animator)
end

TimeScaleUtilities:GetAttributeChangedSignal("TimeScale"):Connect(function()
	TimeScale = TimeScaleUtilities:GetAttribute("TimeScale")
	
	for _, AnimationTrack in pairs(AnimationTracks) do
		AdjustSpeed(AnimationTrack)
	end
end)
