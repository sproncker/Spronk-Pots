include("shared.lua");


function ENT:Initialize ( )	
	self.Spawntime = CurTime()
end

local GlowMat = Material("sprites/light_glow02_add")

function ENT:Draw()
    self:DrawModel()

    local IsOn = self:GetNWBool("on")
    if not IsOn then return end

    local client = LocalPlayer()
    if not IsValid(client) then return end

    local max_range = 750
    if client:GetPos():Distance(self:GetPos()) > max_range then
        return
    end

    local lightPos = self:LocalToWorld(self:OBBCenter() + Vector(4.3, 0, -3)) 

    local lightColor = Color(150, 0, 255)

    render.SetMaterial(GlowMat)
    render.DrawSprite(
        lightPos,
        15,
        15,
        lightColor
    )


    if FrameNumber() % 2 == 0 then
        local lightSize = 200

        local dlight = DynamicLight(self:EntIndex())
        if dlight then
            dlight.Pos = lightPos
            dlight.r = lightColor.r
            dlight.g = lightColor.g
            dlight.b = lightColor.b
            dlight.Brightness = 2.3
            dlight.Decay = lightSize * 5
            dlight.Size = lightSize
            dlight.DieTime = CurTime() + 1
        end
    end
end