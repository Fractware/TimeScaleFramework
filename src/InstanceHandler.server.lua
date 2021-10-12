local DataModule = require(script.Parent.Data)
local TimeModule = require(script.Parent.Time)

local function AddInstance(Object)
	local TimeScale = DataModule.TimeScale

	if Object:IsA("AlignOrientation") then
		DataModule.PhysicsObjects.AlignOrientation[Object] = true
	elseif Object:IsA("AlignPosition") then
		DataModule.PhysicsObjects.AlignPosition[Object] = true
	elseif Object:IsA("AngularVelocity") then
		DataModule.PhysicsObjects.AngularVelocity[Object] = true
	elseif Object:IsA("BasePart") then
		DataModule.PhysicsObjects.BasePart[Object] = true
	elseif Object:IsA("BodyVelocity") then -- Soon to be replaced with LinearVelocity.
		DataModule.PhysicsObjects.BodyVelocity[Object] = true
	elseif Object:IsA("HingeConstraint") then
		DataModule.PhysicsObjects.HingeConstraint[Object] = true
	elseif Object:IsA("Humanoid") then
		DataModule.PhysicsObjects.Humanoid[Object] = true
	elseif Object:IsA("LinearVelocity") then
		DataModule.PhysicsObjects.LinearVelocity[Object] = true
	elseif Object:IsA("LineForce") then
		DataModule.PhysicsObjects.LineForce[Object] = true
	elseif Object:IsA("Model") then
		DataModule.PhysicsObjects.Model[Object] = true
	elseif Object:IsA("ParticleEmitter") then
		DataModule.PhysicsObjects.ParticleEmitter[Object] = true
	elseif Object:IsA("PrismaticConstraint") then
		DataModule.PhysicsObjects.PrismaticConstraint[Object] = true
	elseif Object:IsA("Torque") then
		DataModule.PhysicsObjects.Torque[Object] = true
	elseif Object:IsA("VectorForce") then
		DataModule.PhysicsObjects.VectorForce[Object] = true
	end

	if TimeScale ~= 1 then
		TimeModule:Apply(Object)
	end
end

local function RemoveInstance(Object)
	if DataModule.TimeScale ~= 1 then
		TimeModule:Apply(Object)
	end

	if Object:IsA("AlignOrientation") then
		DataModule.PhysicsObjects.AlignOrientation[Object] = nil
	elseif Object:IsA("AlignPosition") then
		DataModule.PhysicsObjects.AlignPosition[Object] = nil
	elseif Object:IsA("AngularVelocity") then
		DataModule.PhysicsObjects.AngularVelocity[Object] = nil
	elseif Object:IsA("BasePart") then
		DataModule.PhysicsObjects.BasePart[Object] = nil
	elseif Object:IsA("BodyVelocity") then -- Soon to be replaced with LinearVelocity.
		DataModule.PhysicsObjects.BodyVelocity[Object] = nil
	elseif Object:IsA("HingeConstraint") then
		DataModule.PhysicsObjects.HingeConstraint[Object] = nil
	elseif Object:IsA("Humanoid") then
		DataModule.PhysicsObjects.Humanoid[Object] = nil
	elseif Object:IsA("LinearVelocity") then
		DataModule.PhysicsObjects.LinearVelocity[Object] = nil
	elseif Object:IsA("LineForce") then
		DataModule.PhysicsObjects.LineForce[Object] = nil
	elseif Object:IsA("Model") then
		DataModule.PhysicsObjects.Model[Object] = nil
	elseif Object:IsA("ParticleEmitter") then
		DataModule.PhysicsObjects.ParticleEmitter[Object] = nil
	elseif Object:IsA("PrismaticConstraint") then
		DataModule.PhysicsObjects.PrismaticConstraint[Object] = nil
	elseif Object:IsA("Torque") then
		DataModule.PhysicsObjects.Torque[Object] = nil
	elseif Object:IsA("VectorForce") then
		DataModule.PhysicsObjects.VectorForce[Object] = nil
	end
end

for _, Object in pairs(game:GetService("CollectionService"):GetTagged("TimeScaleWhitelist")) do
	AddInstance(Object)
end

game:GetService("CollectionService"):GetInstanceAddedSignal("TimeScaleWhitelist"):Connect(function(Object)
	AddInstance(Object)
end)

game:GetService("CollectionService"):GetInstanceRemovedSignal("TimeScaleWhitelist"):Connect(function(Object)
	RemoveInstance(Object)
end)