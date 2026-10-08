include('shared.lua')

ENT.Leaves = nil
ENT.LastParent = nil
ENT.ProgressBarEnabled = true 
ENT._BuiltClientModels = false
ENT._NextRepair = 0

local BAR_WIDTH = 100
local BAR_HEIGHT = 10
local BAR_OFFSET = Vector(0, 0, 20) 
local BAR_COLOR_BG = Color(50, 50, 50, 200)
local BAR_COLOR_FG = Color(0, 255, 0, 200)
local BAR_COLOR_UV = Color(155,10,160)
local TEXT_COLOR = Color(255, 255, 255, 255)

local function BuildClientModels(self)
    if self._BuiltClientModels then return end

    self.Leaves = ClientsideModel("models/srp/prop_cocaleaves.mdl", RENDERGROUP_OPAQUE)
    if not IsValid(self.Leaves) then return end
    
    self.Leaves:SetPos(self:GetPos())
    self.Leaves:SetParent(self)
    self.Leaves:SetNoDraw(true)

    self._BuiltClientModels = true
end

function ENT:Initialize()
    BuildClientModels(self)
end

function ENT:Think()
    if not self._BuiltClientModels then
        BuildClientModels(self)
    end

    if not self._NextRepair or CurTime() >= self._NextRepair then
        self._NextRepair = CurTime() + 0.5
        
        if IsValid(self.Leaves) then
            if self.Leaves:GetParent() ~= self then
                self.Leaves:SetParent(self)
                self:UpdateLeavesPosition()
            end
        else
            self._BuiltClientModels = false
            BuildClientModels(self)
        end
    end
    
    self:UpdateLeavesPosition()
end

function ENT:UpdateLeavesPosition()
    if not IsValid(self.Leaves) then return end
    self.Leaves:SetLocalPos(Vector(0, 0, 8))
    self.Leaves:SetLocalAngles(Angle(0, 180, 0))
end

function ENT:IsPotVisible()
    if not IsValid(LocalPlayer()) then return false end
    
    local eyePos = LocalPlayer():EyePos()
    local potPos = self:GetPos() + Vector(0, 0, 10)
    
    if eyePos:Distance(potPos) > 1000 then return false end
    
    local trace = util.TraceLine({
        start = eyePos,
        endpos = potPos,
        filter = {LocalPlayer(), self}
    })
    
    return not trace.Hit
end

function ENT:IsBeingLookedAt()
    if not IsValid(LocalPlayer()) then return false end
    
    local eyePos = LocalPlayer():EyePos()
    local plantPos = self:GetPos()
    
    if eyePos:Distance(plantPos) > 500 then return false end
    
    local tr = util.GetPlayerTrace(LocalPlayer())
    tr.filter = {LocalPlayer(), self, IsValid(self.Leaves) and self.Leaves or nil}
    local trace = util.TraceLine(tr)
    
    if trace.Entity == self or trace.Entity == self.Leaves then
        return true
    end
    
    if IsValid(self.Leaves) and (self.dt.GrowthScale or 0) > 0 then
        local leafPos = self:GetPos() + Vector(0, 0, 20)
        local leafDist = eyePos:Distance(leafPos)
        
        if leafDist < 100 then
            local dir = (leafPos - eyePos):GetNormalized()
            local dot = dir:Dot(EyeVector())
            
            if dot > 0.866 then
                return true
            end
        end
    end
    
    return false
end

function ENT:Draw()
    self:DrawModel()
    
    if IsValid(self.Leaves) and (self.dt.GrowthScale or 0) > 0 then
        render.SuppressEngineLighting(false)
        self.Leaves:SetModelScale(self.dt.GrowthScale, 0)
        self.Leaves:SetupBones()
        self.Leaves:DrawModel()
        render.SuppressEngineLighting(false)
    end
    
    if self:IsBeingLookedAt() then
        self:DrawProgressBar()
    end
end

function ENT:DrawProgressBar()
    if not self.ProgressBarEnabled then return end 
    local hasformula = self:GetNWBool("gformula")
    local owner = self:CPPIGetOwner()
    local entOwner = IsValid(owner) and owner:Nick() or "Somebody"
    
    local growth = self.dt.GrowthScale or 0
    local timeLeft = math.max(0, (1 - growth) * self.FullGrowthTime / (self.dt.GrowthRate or 1))

    local pos = self:GetPos() + Vector(0, 0, 15) + self:GetUp() * 6  
    local ang = self:GetAngles()
    ang.x = ang.x - 90
    ang:RotateAroundAxis(self:GetUp(), 0)
    ang:RotateAroundAxis(self:GetForward(), 90) 
    
    pos = pos + self:GetForward() * -15
    
    cam.Start3D2D(pos, ang, 0.1)
        surface.SetDrawColor(BAR_COLOR_BG)
        surface.DrawRect(-BAR_WIDTH/2, 0, BAR_WIDTH, BAR_HEIGHT)
        
        if self:GetNWBool("pboosted", true) then
            surface.SetDrawColor(BAR_COLOR_UV)
            surface.DrawRect(-BAR_WIDTH/2, 0, BAR_WIDTH * growth, BAR_HEIGHT)    
        else
            surface.SetDrawColor(BAR_COLOR_FG)
            surface.DrawRect(-BAR_WIDTH/2, 0, BAR_WIDTH * growth, BAR_HEIGHT)
        end
        
        surface.SetDrawColor(0, 0, 0, 200)
        surface.DrawOutlinedRect(-BAR_WIDTH/2, 0, BAR_WIDTH, BAR_HEIGHT)
        
        local text = growth < 1 and string.FormattedTime(timeLeft, "%02i:%02i") or "READY"
        draw.SimpleText(text, "CenterPrintText", 0, BAR_HEIGHT + 5, TEXT_COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        draw.SimpleText("Coca Plant", "CenterPrintText", 0, BAR_HEIGHT - 29, TEXT_COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        if hasformula then
            draw.SimpleText("+ Growth Formula", "CenterPrintText", 0, BAR_HEIGHT + 25, TEXT_COLOR, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        end
    cam.End3D2D()
end

function ENT:OnRemove()
    if IsValid(self.Leaves) then
        self.Leaves:Remove()
    end
    self._BuiltClientModels = false
end