

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize ( )
	self:SetModel("models/srp/prop_cokerock.mdl")
    self:SetSolid(SOLID_VPHYSICS);
    self:PhysicsInit(SOLID_VPHYSICS); 
    self:SetMoveType(MOVETYPE_VPHYSICS);
    self:DrawShadow(true);
	self:PhysWake()
	self:SetUseType(SIMPLE_USE)
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end

end

function ENT:Use( activator, ent )
	if !IsValid(activator) then return end
	local usesell = GetConVarNumber("spronk_coca_usesell")

	if usesell >0 then
		activator:addMoney(GetConVarNumber("spronk_weed_value"))
		DarkRP.notify(activator, 2, 4, "You sold cocaine worth $" .. GetConVarNumber("spronk_coca_value"))
		self:Remove()
	end
end

function ENT:StartTouch(entity)

end

function ENT:Think()

end