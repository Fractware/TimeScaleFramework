local Module = {}

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
	GravityForce.Force = Vector3.new(0, (TotalMass * game:GetService("Workspace").Gravity) - (game:GetService("Workspace").Gravity / (TimeScale ^ 2)), 0)
	GravityForce.Attachment0 = GravityAttachment
	GravityAttachments[Object] = GravityAttachment
	GravityForces[Object] = GravityForce
	GravityForce.Parent = Object
end

local function AffectObject(Object, TimeScale)
	Object.CustomPhysicalProperties = Object.CustomPhysicalProperties or PhysicalProperties.new(Object.Material)
	
	Object.CustomPhysicalProperties = PhysicalProperties.new(
		Object.CustomPhysicalProperties.Density,
		Object.CustomPhysicalProperties.Friction / TimeScale,
		Object.CustomPhysicalProperties.Elasticity * TimeScale,
		Object.CustomPhysicalProperties.FrictionWeight,
		Object.CustomPhysicalProperties.ElasticityWeight
	)
	
	return Object:GetMass()
end

function Module:Set(Object, State)
	if State then
		local TimeScale = DataModule.TimeScale
		
		if Object:IsA("BasePart") then
			local TimeScale = DataModule.TimeScale
			
			CreateGravityForce(TimeScale, Object, AffectObject(Object, TimeScale))
		elseif Object:IsA("Model") then
			if Object.PrimaryPart then
				local TotalMass = 0
				
				for _, Descendant in pairs(Object:GetDescendants()) do
					if Descendant:IsA("BasePart") then
						TotalMass += AffectObject(Object)
					end
				end
				
				CreateGravityForce(TimeScale, Object.PrimaryPart, TotalMass)
			end
		end
	else
		if GravityForces[Object] then
			GravityForces[Object]:Destroy()
		end
		
		if GravityAttachments[Object] then
			GravityAttachments[Object]:Destroy()	
		end
	end
end

return Module
