ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "Weed Plant"
ENT.Author = "Sproncker"
ENT.Category = "Drugs"

ENT.Spawnable = true
ENT.AdminOnly = true

ENT.FullGrowthTime = GetConVarNumber("spronk_weed_growtime")
ENT.GrowthInterval = GetConVarNumber("spronk_weed_interval")

function ENT:SetupDataTables()
    self:DTVar("Float", 0, "GrowthTime")
    self:DTVar("Float", 1, "GrowthScale")
    self:DTVar("Bool", 2, "Grown")
    self:DTVar("Float", 3, "GrowthRate")
end