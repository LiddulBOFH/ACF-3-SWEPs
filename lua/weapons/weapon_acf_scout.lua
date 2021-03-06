AddCSLuaFile()

include("weapon_acf_base.lua")

SWEP.Base                   = "weapon_acf_base"
SWEP.PrintName              = "ACF Scout"

SWEP.UseHands               = true
SWEP.ViewModel              = "models/weapons/cstrike/c_snip_scout.mdl"
SWEP.ViewModelFlip          = false

SWEP.ShotSound				= Sound("Weapon_Scout.Single")
SWEP.WorldModel             = "models/weapons/w_snip_scout.mdl"
SWEP.HoldType               = "ar2"

SWEP.Weight                 = 1

SWEP.Slot                   = 1
SWEP.SlotPos                = 0

SWEP.Spawnable              = true
SWEP.AdminOnly              = false

SWEP.m_WeaponDeploySpeed    = 1.1
SWEP.Spread                 = 0.5
SWEP.RecoilMod              = 2

SWEP.Primary.ClipSize       = 5
SWEP.Primary.DefaultClip    = 5
SWEP.Primary.Ammo           = "AR2"
SWEP.Primary.Automatic      = true
SWEP.Primary.Delay          = 1.25

SWEP.Caliber                = 7.62 -- mm diameter of bullet
SWEP.ACFProjMass            = 0.011 -- kg of projectile
SWEP.ACFType                = "AP"
SWEP.ACFMuzzleVel           = 900 -- m/s of bullet leaving the barrel
SWEP.Tracer                 = 0

SWEP.CalcDistance			= 100
SWEP.CalcDistance2			= 300

SWEP.IronScale              = 0
SWEP.NextIronToggle         = 0
SWEP.IronSightPos           = Vector(-6.65,-10,3.35)
--SWEP.IronSightAng           = Angle()

SWEP.Scope					= true
SWEP.Zoom					= 6
SWEP.HasDropCalc			= true

SWEP.AimFocused				= 0.01
SWEP.AimUnfocused			= 3
SWEP.Recovery				= 0.4

SWEP:SetupACFBullet()

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	local Ply = self:GetOwner()

	if Ply:IsPlayer() then Ply:LagCompensation(true) end
	local AimMod = self:GetAimMod()
	local Punch = self:GetPunch()

	if SERVER then
		local Aim = self:GetForward()
		local Right = self:GetRight()
		local Up = self:GetUp()
		if Ply:IsNPC() then Aim = Ply:GetAimVector() end

		local Cone = math.tan(math.rad(self.Spread * AimMod))
		local randUnitSquare = (Up * (2 * math.random() - 1) + Right * (2 * math.random() - 1))
		local Spread = randUnitSquare:GetNormalized() * Cone * (math.random() ^ (1 / ACF.GunInaccuracyBias))
		local Dir = (Aim + Spread):GetNormalized()

		self:ShootBullet(Ply:GetShootPos(),Dir)
	else
		self.TempOut = true
		timer.Simple(self.Primary.Delay * 0.8,function() self.TempOut = false end)
		self:Recoil(Punch)
	end

	self:PostShot(1)

	if Ply:IsPlayer() then Ply:LagCompensation(false) end
end
