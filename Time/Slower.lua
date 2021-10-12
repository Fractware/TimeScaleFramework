local Module = {}

local DataModule = require(script.Parent.Parent.Data)
local ForcesModule = require(script.Parent.Forces)

function Module:Apply(TimeScaleDifference, Object)
	if Object:IsA("AlignOrientation") then
		Object.MaxAngularVelocity /= TimeScaleDifference
		Object.MaxTorque /= TimeScaleDifference
	elseif Object:IsA("AlignPosition") then
		Object.MaxForce /= TimeScaleDifference
		Object.MaxVelocity /= TimeScaleDifference
	elseif Object:IsA("AngularVelocity") then
		Object.AngularVelocity = Vector3.new(
			Object.AngularVelocity.X / TimeScaleDifference,
			Object.AngularVelocity.Y / TimeScaleDifference,
			Object.AngularVelocity.Z / TimeScaleDifference
		)
	elseif Object:IsA("BasePart") then
		ForcesModule:Set(Object, true)
		
		Object.AssemblyAngularVelocity /= TimeScaleDifference
		Object.AssemblyLinearVelocity /= TimeScaleDifference
	elseif Object:IsA("BodyVelocity") then -- Soon to be replaced with LinearVelocity.
		Object.MaxForce /= TimeScaleDifference
		Object.Velocity /= TimeScaleDifference
	elseif Object:IsA("HingeConstraint") then
		Object.AngularSpeed /= TimeScaleDifference
		Object.AngularVelocity /= TimeScaleDifference
		Object.MotorMaxTorque /= TimeScaleDifference
		Object.ServoMaxTorque /= TimeScaleDifference
	elseif Object:IsA("Humanoid") then
		Object.WalkSpeed /= TimeScaleDifference
	elseif Object:IsA("LinearVelocity") then
		Object.LineVelocity /= TimeScaleDifference
		Object.PlaneVelocity = Vector2.new(
			Object.PlaneVelocity.X / TimeScaleDifference,
			Object.PlaneVelocity.Y / TimeScaleDifference
		)
		Object.VectorVelocity = Vector3.new(
			Object.VectorVelocity.X / TimeScaleDifference,
			Object.VectorVelocity.Y / TimeScaleDifference,
			Object.VectorVelocity.Z / TimeScaleDifference
		)
	elseif Object:IsA("LineForce") then
		Object.Magnitude /= TimeScaleDifference
	elseif Object:IsA("Model") then
		if Object.PrimaryPart then
			ForcesModule:Set(Object, false)
		end
		
		for _, Descendant in pairs(Object:GetDescendants()) do
			Module:Apply(TimeScaleDifference, Descendant)
		end
	elseif Object:IsA("ParticleEmitter") then
		Object.TimeScale /= TimeScaleDifference
	elseif Object:IsA("PrismaticConstraint") then
		Object.MotorMaxForce /= TimeScaleDifference
		Object.ServoMaxForce /= TimeScaleDifference
	elseif Object:IsA("Sound") then
		Object.PlaybackSpeed /= TimeScaleDifference
	elseif Object:IsA("Torque") then
		Object.Torque /= TimeScaleDifference
	elseif Object:IsA("VectorForce") then
		Object.Force /= TimeScaleDifference
	end
end

return Module