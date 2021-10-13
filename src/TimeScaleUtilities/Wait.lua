local Module = {}

local Timers = {}

function Module:Wait(WaitTime)
	WaitTime = WaitTime or 0
	local WaitBindable = Instance.new("BindableEvent")
	
	Timers[WaitBindable] = {Time = WaitTime, TimeElapsed = 0}
	
	WaitBindable.Event:Wait()
	
	Timers[WaitBindable] = nil
	
	return true
end

game:GetService("RunService").Heartbeat:Connect(function(Step)
	for WaitBindable, Data in pairs(Timers) do
		Data.TimeElapsed += (Step / script.Parent:GetAttribute("TimeScale"))
		if Data.TimeElapsed >= Data.Time then
			WaitBindable:Fire()
		end
	end
end)

return Module
