
local Clockwork = Clockwork
local Schema = Schema
local PLUGIN = PLUGIN


AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

ENT.LastHitSomething = 0

local function RefreshTurretOwners(pl)
	for _, ent in pairs(ents.FindByClass("combine_turret")) do
		if ent:IsValid() and ent:GetObjectOwner() == pl then
			ent:ClearObjectOwner()
			ent:ClearTarget()
		end
	end
end
hook.Add("PlayerDisconnected", "GunTurret.PlayerDisconnected", RefreshTurretOwners)
hook.Add("OnPlayerChangedTeam", "GunTurret.OnPlayerChangedTeam", RefreshTurretOwners)

function ENT:Initialize()
	self:SetModel("models/Combine_turrets/Floor_turret.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)

	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMass(50)
		phys:EnableMotion(false)
		phys:Wake()
	end

	self:SetAmmo(self.DefaultAmmo)
	self:SetMaxObjectHealth(250)
	self:SetObjectHealth(self:GetMaxObjectHealth())
end

function ENT:SetObjectHealth(health)
	self:SetDTFloat(3, health)
	if health <= 0 and not self.Destroyed then
		self.Destroyed = true

		local pos = self:LocalToWorld(self:OBBCenter())

		local effectdata = EffectData()
			effectdata:SetOrigin(pos)
		util.Effect("Explosion", effectdata, true, true)

		local amount = math.ceil(self:GetAmmo() * 0.5)
		while amount > 0 do
			amount = amount - 50
			local ent = ents.Create("prop_ammo")
			if ent:IsValid() then
				local heading = VectorRand():GetNormalized()
				ent:SetAmmoType("smg1")
				ent:SetAmmo(math.min(amount, 50))
				ent:SetPos(pos + heading * 8)
				ent:SetAngles(VectorRand():Angle())
				ent:Spawn()

				local phys = ent:GetPhysicsObject()
				if phys:IsValid() then
					phys:ApplyForceOffset(heading * math.Rand(8000, 32000), pos)
				end
			end
		end
	end
end

local tempknockback
function ENT:StartBulletKnockback()
	tempknockback = {}
end

function ENT:EndBulletKnockback()
	tempknockback = nil
end

function ENT:DoBulletKnockback(scale)
	for ent, prevvel in pairs(tempknockback) do
		local curvel = ent:GetVelocity()
		ent:SetVelocity(curvel * -1 + (curvel - prevvel) * scale + prevvel)
	end
end

local function BulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity
	if ent:IsValid() then
		if ent:IsPlayer() then
			if ent:Team() == TEAM_UNDEAD and tempknockback then
				if attacker:GetTarget() == ent then
					attacker.LastHitSomething = CurTime()
				end
				tempknockback[ent] = ent:GetVelocity()
			end
		else
			local phys = ent:GetPhysicsObject()
			if ent:GetMoveType() == MOVETYPE_VPHYSICS and phys:IsValid() and phys:IsMoveable() then
				ent:SetPhysicsAttacker(attacker)
			end
		end

		dmginfo:SetAttacker(attacker:GetObjectOwner())
		dmginfo:SetInflictor(attacker)
	end
end

function ENT:FireTurret(src, dir, numbullets)
	if self:GetNextFire() <= CurTime() then
		local curammo = self:GetAmmo()
		if curammo > 0 then
			self:SetNextFire(CurTime() + 0.1)
			self:SetAmmo(curammo - 1)

			self:StartBulletKnockback()
			self:FireBullets({Num = numbullets or 1, Src = src, Dir = dir, Spread = Vector(0.05, 0.05, 0), Tracer = 1, Force = 1.3, Damage = 13, Callback = BulletCallback})
			self:DoBulletKnockback(0.05)
			self:EndBulletKnockback()
		else
			self:SetNextFire(CurTime() + 2)
			self:EmitSound("npc/turret_floor/die.wav")
		end
	end
end

function ENT:Think()
	if self.Destroyed then
		self:Remove()
		return
	end

	self:CalculatePoseAngles()

	local owner = self:GetObjectOwner()
	if owner:IsValid() and self:GetAmmo() > 0 and self:GetMaterial() == "" then

			if self:IsFiring() then self:SetFiring(false) end
			local target = self:GetTarget()
			if target:IsValid() then
				if self:IsValidTarget(target) and CurTime() < self.LastHitSomething + 0.5 then
					local shootpos = self:ShootPos()
					self:FireTurret(shootpos, (self:GetTargetPos(target) - shootpos):GetNormalized())
				else
					self:ClearTarget()
					self:EmitSound("npc/turret_floor/deploy.wav")
				end
			else
				local target = self:SearchForTarget()
				if target then
					self:SetTarget(target)
					self:SetTargetReceived(CurTime())
					self:EmitSound("npc/turret_floor/active.wav")
				end
			end
	elseif self:IsFiring() then
		self:SetFiring(false)
	end

	self:NextThink(CurTime())
	return true
end

function ENT:Use(activator, caller)
	if self.Removing or not activator:IsPlayer() or self:GetMaterial() ~= "" then return end

	if Schema:PlayerIsCombine(activator) then
		if self:GetObjectOwner():IsValid() then
			local curammo = self:GetAmmo()
			local togive = math.min(math.min(15, activator:GetAmmoCount("ar2")), self.MaxAmmo - curammo)
			if togive > 0 then
				self:SetAmmo(curammo + togive)
				activator:RemoveAmmo(togive, "ar2")
				activator:RestartGesture(ACT_GMOD_GESTURE_ITEM_GIVE)
				self:EmitSound("npc/turret_floor/click1.wav")
				gamemode.Call("PlayerRepairedObject", activator, self, togive * 1.5, self)
			end
		else
			self:SetObjectOwner(activator)
		end
	end
end

function ENT:AltUse(activator, tr)
	self:PackUp(activator)
end

function ENT:OnPackedUp(pl)

	self:Remove()
end

function ENT:OnTakeDamage(dmginfo)
	self:TakePhysicsDamage(dmginfo)

	local attacker = dmginfo:GetAttacker()
	if not (attacker:IsValid() and attacker:IsPlayer() and Schema:PlayerIsCombine(attacker)) then
		self:SetObjectHealth(self:GetObjectHealth() - dmginfo:GetDamage())
	end
end
