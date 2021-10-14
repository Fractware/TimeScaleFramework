local Module = {}

local Timers = {}

function Module:Wait(WaitTime)
	WaitTime = WaitTime or 0
	local WaitBindable = Instance.new("BindableEvent")

	local ID = game:GetService("HttpService"):GenerateGUID(false)
	Timers[ID] = {Bindable = WaitBindable, Time = WaitTime, TimeElapsed = 0}

	WaitBindable.Event:Wait()

	Timers[ID] = nil

	return true
end

game:GetService("RunService").Heartbeat:Connect(function(Step)
	for _, Data in pairs(Timers) do
		Data.TimeElapsed += (Step / script.Parent:GetAttribute("TimeScale"))
		if Data.TimeElapsed >= Data.Time then
			Data.Bindable:Fire()
		end
	end
end)

return Module