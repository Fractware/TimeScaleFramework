local Module = {}

local Workspace = game:GetService("Workspace")

local DataModule = require(script.Parent.Parent.Data)

local GravityAttachments = {}
local GravityForces = {}

local function CreateGravityForce(TimeScale, Object, TotalMass)
	local GravityAttachment = Instance.new("Attachment")
	GravityAttachment.Name = "GravityAttachment"
	GravityAttachment.Parent = Object

	local GravityForce = Instance.new("VectorForce")
	GravityForce.Name = "GravityForce"
	GravityForce.ApplyAtCenterOfMass = true
	GravityForce.RelativeTo = Enum.ActuatorRelativeTo.World
	GravityForce.Force = Vector3.new(0, (TotalMass * Workspace.Gravity) - (Workspace.Gravity / (TimeScale ^ 2)), 0)
	GravityForce.Attachment0 = GravityAttachment
	GravityAttachments[Object] = GravityAttachment
	GravityForces[Object] = GravityForce
	GravityForce.Parent = Object
end

local function AffectObject(Object, TimeScale, State)
	Object.CustomPhysicalProperties = Object.CustomPhysicalProperties or PhysicalProperties.new(Object.Material)

	if State then
		Object.CustomPhysicalProperties = PhysicalProperties.new(
			Object.CustomPhysicalProperties.Density,
			Object.CustomPhysicalProperties.Friction / TimeScale,
			Object.CustomPhysicalProperties.Elasticity,
			Object.CustomPhysicalProperties.FrictionWeight,
			Object.CustomPhysicalProperties.ElasticityWeight
		)
	else
		Object.CustomPhysicalProperties = PhysicalProperties.new(
			Object.CustomPhysicalProperties.Density,
			Object.CustomPhysicalProperties.Friction * DataModule.PreviousTimeScale,
			Object.CustomPhysicalProperties.Elasticity,
			Object.CustomPhysicalProperties.FrictionWeight,
			Object.CustomPhysicalProperties.ElasticityWeight
		)
	end

	return Object.Mass
end

function Module:Set(Object, State)
	local TimeScale = DataModule.TimeScale

	if State then
		if Object:IsA("BasePart") then
			CreateGravityForce(TimeScale, Object, AffectObject(Object, TimeScale, State))
		elseif Object:IsA("Model") then
			if Object.PrimaryPart then
				local TotalMass = 0

				for _, Descendant in pairs(Object:GetDescendants()) do
					if Descendant:IsA("BasePart") then
						TotalMass += AffectObject(Object, TimeScale, State)
					end
				end

				CreateGravityForce(TimeScale, Object.PrimaryPart, TotalMass)
			end
		end
	else
		if Object:IsA("BasePart") then
			AffectObject(Object, TimeScale, State)
		elseif Object:IsA("Model") then
			for _, Descendant in pairs(Object:GetDescendants()) do
				if Descendant:IsA("BasePart") then
					AffectObject(Object, TimeScale, State)
				end
			end
		end

		if GravityForces[Object] then
			GravityForces[Object]:Destroy()
		end

		if GravityAttachments[Object] then
			GravityAttachments[Object]:Destroy()
		end
	end
end

return Module
