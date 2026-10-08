

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize ( )
	self:SetModel("models/props/de_nuke/floodlight.mdl")
    self:SetSolid(SOLID_VPHYSICS)
    self:PhysicsInit(SOLID_VPHYSICS);
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:DrawShadow(true)
	self:PhysWake()
	self:SetUseType(SIMPLE_USE)
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end

end

function ENT:Use(activator, ent)
    self:SetNWBool("on", not self:GetNWBool("on"))
	self:EmitSound("buttons/lightswitch2.wav", 85,100)
end

function ENT:StartTouch(entity)

end

function ENT:Think()

end