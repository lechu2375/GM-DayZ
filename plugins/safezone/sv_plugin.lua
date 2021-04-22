local PLUGIN = PLUGIN

function PLUGIN:LoadData()
	SH_SZ.SafeZones = self:GetData() or {}

	for _, sz in pairs(SH_SZ.SafeZones) do
		local shape = SH_SZ.ShapesIndex[sz.shape]
		if (!shape) then
			return end

		SH_SZ:CreateSafeZone(sz, shape)
	end
end

function PLUGIN:SaveData()
	self:SetData(SH_SZ.SafeZones)
end

function PLUGIN:CanPlayerEnterSafeZone(entity, activator)
	if (!activator:CanEnterSafe() or activator:GetPVPTime() > CurTime()) then
		local vel = activator:GetVelocity() * -4
		--vel[3] = math.Clamp(vel[3], 0, 10)
		vel.z = 0
		activator:SetVelocity(vel)

		-- local dir = entity:GetPos() - activator:GetPos()
		-- dir:Normalize()
		-- dir.z = 0

		-- activator:SetPos(activator:GetPos() - dir * 10)

		return false
	end
end

function PLUGIN:PlayerExitSafeZone(client)
	client.protection_time = CurTime() + 10
end

function PLUGIN:PlayerInitialSpawn(client)
	client:SetCustomCollisionCheck(true)
	client:SetAvoidPlayers(false)
	client:CollisionRulesChanged()
end

-- ShouldCollide ломает физику при опр. условиях.
function PLUGIN:ShouldCollide(ent1, ent2)
	if (ent1:IsPlayer() and ent2:IsPlayer()) then
		if (ent1:IsStuck() and ent2:IsStuck()) then return false end
		if (ent1:GetLocalVar("SH_SZ.Safe", SH_SZ.OUTSIDE) != SH_SZ.OUTSIDE or ent2:GetLocalVar("SH_SZ.Safe", SH_SZ.OUTSIDE) != SH_SZ.OUTSIDE) then
			return false
		end
	end
end