local Module = {}

local Timers = {}

local TimeElapsed = 0

function Module:Wait(WaitTime)
	WaitTime = WaitTime or 0
	
	local Thread = coroutine.running()
	local TimeElapsed = 0
	
	local Connection
	
	Connection = game:GetService("RunService").Heartbeat:Connect(function(DeltaTime)
		if Connection == nil then
			return
		end
		
		TimeElapsed += DeltaTime / script.Parent:GetAttribute("TimeScale")
		if TimeElapsed >= WaitTime then
			Connection:Disconnect()
			Connection = nil
			
			task.spawn(Thread, TimeElapsed)
		end
	end)
	
	return coroutine.yield()
end

return Module
