local ReplicatedStorage = game:GetService("ReplicatedStorage")

return {
	PhysicsObjects = {
		["AlignOrientation"] = {},
		["AlignPosition"] = {},
		["AngularVelocity"] = {},
		["BasePart"] = {},
		["HingeConstraint"] = {},
		["Humanoid"] = {},
		["LinearVelocity"] = {},
		["LineForce"] = {},
		["Model"] = {},
		["ParticleEmitter"] = {},
		["PrismaticConstraint"] = {},
		["Torque"] = {},
		["VectorForce"] = {},
	},
	PreviousTimeScale = ReplicatedStorage:WaitForChild("TimeScaleUtilities"):GetAttribute("TimeScale"),
	TimeScale = ReplicatedStorage:WaitForChild("TimeScaleUtilities"):GetAttribute("TimeScale"),
}
