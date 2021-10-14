local Module = {}

local Timers = {}

local TimeElapsed = 0

function Module:Wait(WaitTime)
	WaitTime = WaitTime or 0
	local WaitBindable = Instance.new("BindableEvent")
	
	Timers[WaitBindable] = TimeElapsed + WaitTime
	
	WaitBindable.Event:Wait()
	
	Timers[WaitBindable] = nil
	
	return true
end

game:GetService("RunService").Heartbeat:Connect(function(Step)
	TimeElapsed += (Step / script.Parent:GetAttribute("TimeScale"))
	
	for WaitBindable, TargetTime in pairs(Timers) do
		if TimeElapsed >= TargetTime then
			WaitBindable:Fire()
		end
	end
end)

return Module
