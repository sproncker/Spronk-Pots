include("shared.lua")


function ENT:Initialize ( )	
	self.Spawntime = CurTime()
end

function ENT:Draw()
	self:DrawModel()
end