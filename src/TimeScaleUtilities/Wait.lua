local Module = {}

local TimeScale = script.Parent:GetAttribute("TimeScale")
script.Parent:GetAttributeChangedSignal("TimeScale"):Connect(function()
	TimeScale = script.Parent:GetAttribute("TimeScale")
end)

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
		
		TimeElapsed += DeltaTime / TimeScale
		if TimeElapsed >= WaitTime then
			Connection:Disconnect()
			Connection = nil
			
			task.spawn(Thread, TimeElapsed)
		end
	end)
	
	return coroutine.yield()
end

return Module
