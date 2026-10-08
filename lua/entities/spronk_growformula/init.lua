

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize ( )
	self:SetModel("models/props_junk/garbage_plasticbottle002a.mdl")
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

function ENT:Use( activator, ent )

end

function ENT:StartTouch(entity)
    local class = entity:GetClass()
    if class == "spronk_w_plant" or class == "spronk_c_plant" then
		if entity.growformula then
			entity:EmitSound("player/footsteps/slosh" .. math.random(1,4) .. ".wav", 85, 100)
		return end
        local curgrate = entity.dt.GrowthRate
        entity.dt.GrowthRate = curgrate * GetConVarNumber("spronk_growthf_boost")
		entity.growformula = true
		entity:SetNWBool("gformula", true)
		entity:EmitSound("player/footsteps/slosh" .. math.random(1,4) .. ".wav", 85, 100)
        self:Remove()
    end
end

function ENT:Think()

end