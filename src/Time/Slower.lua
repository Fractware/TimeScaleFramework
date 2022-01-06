local Module = {}

local CollectionService = game:GetService("CollectionService")
local Workspace = game:GetService("Workspace")

local DataModule = require(script.Parent.Parent.Data)
local ForcesModule = require(script.Parent.Forces)

local ApplyMethods = {
	["AlignOrientation"] = function(TimeScaleDifference, Object)
		Object.MaxAngularVelocity /= TimeScaleDifference
		Object.MaxTorque /= TimeScaleDifference
	end,
	["AlignPosition"] = function(TimeScaleDifference, Object)
		Object.MaxForce /= TimeScaleDifference
		Object.MaxVelocity /= TimeScaleDifference
	end,
	["AngularVelocity"] = function(TimeScaleDifference, Object)
		Object.AngularVelocity = Vector3.new(
			Object.AngularVelocity.X,
			Object.AngularVelocity.Y,
			Object.AngularVelocity.Z
		) / TimeScaleDifference
	end,
	["BasePart"] = function(TimeScaleDifference, Object)
		if Object.Parent:IsA("Model") and Object.Parent ~= Workspace and CollectionService:HasTag(Object.Parent, "TimeScaleWhitelist") then
			return
		end

		ForcesModule:Set(Object, true)

		Object.AssemblyAngularVelocity /= TimeScaleDifference
		Object.AssemblyLinearVelocity /= TimeScaleDifference
	end,
	["HingeConstraint"] = function(TimeScaleDifference, Object)
		Object.AngularSpeed /= TimeScaleDifference
		Object.AngularVelocity /= TimeScaleDifference
		Object.MotorMaxAcceleration /= TimeScaleDifference
		Object.MotorMaxTorque /= TimeScaleDifference
		Object.ServoMaxTorque /= TimeScaleDifference
	end,
	["Humanoid"] = function(TimeScaleDifference, Object)
		Object.WalkSpeed /= TimeScaleDifference
	end,
	["LinearVelocity"] = function(TimeScaleDifference, Object)
		Object.LineVelocity /= TimeScaleDifference
		Object.PlaneVelocity = Vector2.new(
			Object.PlaneVelocity.X,
			Object.PlaneVelocity.Y
		) / TimeScaleDifference
		Object.VectorVelocity = Vector3.new(
			Object.VectorVelocity.X,
			Object.VectorVelocity.Y,
			Object.VectorVelocity.Z
		) / TimeScaleDifference
	end,
	["LineForce"] = function(TimeScaleDifference, Object)
		Object.Magnitude /= TimeScaleDifference
	end,
	["Model"] = function(TimeScaleDifference, Object)
		if Object.PrimaryPart then
			ForcesModule:Set(Object, true)
		end

		for _, Descendant in pairs(Object:GetDescendants()) do
			Module:Apply(TimeScaleDifference, Descendant)
		end
	end,
	["ParticleEmitter"] = function(TimeScaleDifference, Object)
		Object.TimeScale /= TimeScaleDifference
	end,
	["PrismaticConstraint"] = function(TimeScaleDifference, Object)
		Object.MotorMaxForce /= TimeScaleDifference
		Object.ServoMaxForce /= TimeScaleDifference
	end,
	["Sound"] = function(TimeScaleDifference, Object)
		Object.PlaybackSpeed /= TimeScaleDifference
	end,
	["Torque"] = function(TimeScaleDifference, Object)
		Object.Torque /= TimeScaleDifference
	end,
	["VectorForce"] = function(TimeScaleDifference, Object)
		Object.Force /= TimeScaleDifference
	end,
}

function Module:Apply(TimeScaleDifference, Object)
	if Object:IsA("BasePart") then
		ApplyMethods["BasePart"](TimeScaleDifference, Object)
	else
		ApplyMethods[Object.ClassName](TimeScaleDifference, Object)
	end
end

return Module