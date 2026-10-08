AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
    self:SetModel("models/srp/prop_pbucket.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self._LastThink = CurTime()
    
    self.dt.GrowthTime = 0
    self.dt.GrowthScale = 0
    self.dt.Grown = false
    self.dt.GrowthRate = 1.0
    
    self.GrowthInterval = 1
    
    self:GetPhysicsObject():Wake()
    self:SetNWBool("pboosted", false)
end

function ENT:Think()
    if self.dt.Grown then
        self:NextThink(CurTime() + 5)
        return true
    end

    local baseGrowthRate = self.dt.GrowthRate or 1.0

    local props = ents.FindInSphere(self:GetPos(), 100)
    local activeFan = false

    for _, ent in ipairs(props) do
        if ent:GetClass() == "spronk_growlamp" and ent:GetNWBool("on", false) then
            activeFan = true
            break
        end
    end

    if activeFan then
        if not self:GetNWBool("pboosted", false) then
            self:SetNWBool("pboosted", true)
        end

        baseGrowthRate = baseGrowthRate * GetConVarNumber("spronk_growlamp_boost")
    else
    if self:GetNWBool("pboosted", false) then
        self:SetNWBool("pboosted", false)
    end
    end

    local delta = self.GrowthInterval

    if self._LastThink then
        delta = math.min(CurTime() - self._LastThink, 0.5)
    end

    self._LastThink = CurTime()

    self.dt.GrowthTime = self.dt.GrowthTime + (baseGrowthRate * delta)
    self.dt.GrowthScale = math.min(
        1,
        self.dt.GrowthTime / self.FullGrowthTime
    )

    if self.dt.GrowthScale >= 1 and not self.dt.Grown then
        self.dt.Grown = true
        self:OnFullyGrown()
    end

    self:NextThink(CurTime() + 0.1)
    return true
end

function ENT:OnFullyGrown()
    self:EmitSound("physics/surfaces/sand_impact_bullet3.wav", 85, 100)
end

function ENT:Use(activator, caller)
    if not IsValid(activator) or not activator:IsPlayer() then return end
    
    if not self.dt.Grown then
        DarkRP.notify(activator, 1, 4, "This plant is not ready!")
        return
    end
    
    if self.Disabled then
        return
    end


    
    local count = math.random(GetConVarNumber("spronk_weed_hmin"), GetConVarNumber("spronk_weed_hmax"))
    if self.growthformula then
        count = count +1
    end
    local entity = GetConVar("spronk_weed_ent")
    local spawnOffset = Vector(0, 0, 55)
        self.Disabled = true
        for i = 1, count do
            timer.Simple(0.5 * (i - 1), function()
                if not IsValid(self) then return end
                local pos = self:LocalToWorld(spawnOffset)
                local ang = self:LocalToWorldAngles(Angle(0, 0, 0))

                local result = ents.Create(entity:GetString())
                result:SetPos(pos)
                result:SetAngles(ang)
                result:Spawn()
                self:EmitSound("physics/cardboard/cardboard_box_strain" .. math.random(1,3) .. ".wav", 85, 100)

            end)
        end
        timer.Simple(count, function()
        self:Remove()
        end)
end

function ENT:OnRemove()
end