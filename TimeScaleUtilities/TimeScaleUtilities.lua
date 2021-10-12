local Utilities = {}

local WaitModule = require(script.Wait)

function Utilities:Wait(WaitTime)
	return WaitModule:Wait(WaitTime)
end

return Utilities
