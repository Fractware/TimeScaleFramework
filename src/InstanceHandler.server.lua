local CollectionService = game:GetService("CollectionService")

local DataModule = require(script.Parent.Data)
local TimeModule = require(script.Parent.Time)

local function AddInstance(Object)
	if not Object:IsA("BasePart") and not DataModule[Object.ClassName] then
		return
	end
	
	if Object:IsA("BasePart") then
		DataModule.PhysicsObjects["BasePart"][Object] = true
	else
		if DataModule.PhysicsObjects[Object.ClassName] then
			DataModule.PhysicsObjects[Object.ClassName][Object] = true
		end
	end
	
	if DataModule.TimeScale ~= 1 then
		TimeModule:Apply(Object)
	end
end

local function RemoveInstance(Object)
	if not Object:IsA("BasePart") and not DataModule[Object.ClassName] then
		return
	end
	
	if DataModule.TimeScale ~= 1 then
		TimeModule:Apply(Object)
	end
	
	if Object:IsA("BasePart") then
		DataModule.PhysicsObjects["BasePart"][Object] = nil
	else
		if DataModule.PhysicsObjects[Object.ClassName] then
			DataModule.PhysicsObjects[Object.ClassName][Object] = nil
		end
	end
end

for _, Object in pairs(CollectionService:GetTagged("TimeScaleWhitelist")) do
	AddInstance(Object)
end

CollectionService:GetInstanceAddedSignal("TimeScaleWhitelist"):Connect(function(Object)
	AddInstance(Object)
end)

CollectionService:GetInstanceRemovedSignal("TimeScaleWhitelist"):Connect(function(Object)
	RemoveInstance(Object)
end)