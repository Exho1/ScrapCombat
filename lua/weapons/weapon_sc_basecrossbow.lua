--// Base SWEP for an axe (crowbar mod)

if SERVER then
	AddCSLuaFile()
end

SWEP.PrintName 				= "Scrap Crossbow"
SWEP.Author					= "Exho"

SWEP.Base 					= "weapon_sc_base"
SWEP.Slot					= 1
SWEP.DrawAmmo 				= true
SWEP.DrawCrosshair 			= true
SWEP.HoldType				= "crossbow"
SWEP.Spawnable				= false
SWEP.AdminSpawnable			= true

SWEP.Primary.Ammo       	= "crossbow_bolt"
SWEP.Primary.Damage       	= 20
SWEP.Primary.ClipSize		= 10
SWEP.Primary.DefaultClip 	= 10
SWEP.Primary.ClipMax 		= 10
SWEP.Primary.Delay      	= 0.75
SWEP.Primary.Automatic		= false

SWEP.Primary.NumShots		= 1
SWEP.Primary.NumAmmo		= SWEP.Primary.NumShots
SWEP.ViewModel 				= "models/weapons/c_crossbow.mdl"
SWEP.WorldModel 			= "models/weapons/w_crossbow.mdl"
SWEP.ViewModelFlip			= false

SWEP.Primary.Reload			= Sound( "Weapon_Crossbow.Reload" )
SWEP.Primary.Sound 			= Sound ("Weapon_Crossbow.Single")
SWEP.Primary.Special2		= Sound( "Weapon_Crossbow.BoltFly" )

BOLT_AIR_VELOCITY			= 3500
BOLT_WATER_VELOCITY			= 1500

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	if not self:CanPrimaryAttack() then return end
	
	self.Weapon:EmitSound( self.Primary.Sound )
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	
	self.m_bMustReload = true

	if ( self.Weapon:Clip1() <= 0 ) then
		if ( self:Ammo1() > 0 ) then
			self:Reload();
		else
			self.Weapon:SetNextPrimaryFire( 0.15 );
		end

		return;
	end

	local pOwner = self.Owner;

	if ( pOwner == NULL ) then
		return;
	end

	if ( !CLIENT ) then
		local vecAiming		= pOwner:GetAimVector();
		local vecSrc		= pOwner:GetShootPos();

		local angAiming;
		angAiming = vecAiming:Angle();

		local pBolt = ents.Create( "crossbow_bolt" );
		pBolt:SetPos( vecSrc );
		pBolt:SetAngles( angAiming );
		pBolt.m_iPlayerDamage = self.Primary.Damage;
		pBolt:SetOwner( pOwner );
		pBolt:Spawn()

		if ( pOwner:WaterLevel() == 3 ) then
			pBolt:SetVelocity( vecAiming * BOLT_WATER_VELOCITY );
		else
			pBolt:SetVelocity( vecAiming * BOLT_AIR_VELOCITY );
		end

	end

	self:TakePrimaryAmmo( self.Primary.NumShots )

	if ( !pOwner:IsNPC() ) then
		pOwner:ViewPunch( Angle( -2, 0, 0 ) );
	end

	self.Weapon:EmitSound( self.Primary.Sound );
	self.Weapon:EmitSound( self.Primary.Special2 )

	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK );

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay );
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay );
end

function SWEP:SecondaryAttack()

end

function SWEP:Think()

	if ( self.m_bMustReload ) then
		self:Reload();
	end

	local pPlayer = self.Owner;

	if ( !pPlayer ) then
		return;
	end

	if ( pPlayer:WaterLevel() >= 3 ) then
		self.m_bIsUnderwater = true;
	else
		self.m_bIsUnderwater = false;
	end

end

function SWEP:Reload()

	if ( self.Weapon:DefaultReload( ACT_VM_RELOAD ) ) then
		self.m_bMustReload = false;
		return true;
	end

	return false;

end

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	return self:SetDeploySpeed( self.Weapon:SequenceDuration() )
end


SWEP.VElements = {
	["BoltHolder"] = { type = "Model", model = "models/props_wasteland/kitchen_counter001d.mdl", bone = "ValveBiped.Crossbow_base", rel = "", pos = Vector(0, -1.5, 0), angle = Angle(0, 0, -90), size = Vector(0.05, 0.05, 0.05), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["BarConnecter1"] = { type = "Model", model = "models/props_wasteland/kitchen_counter001c.mdl", bone = "ValveBiped.bowl1", rel = "", pos = Vector(-3.3, 0.899, 0), angle = Angle(0, 0, 0), size = Vector(0.05, 0.05, 0.05), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["RopeConnector+"] = { type = "Model", model = "models/props_wasteland/kitchen_counter001c.mdl", bone = "ValveBiped.bowr2", rel = "", pos = Vector(0, 0.899, 0), angle = Angle(100, 0, 0), size = Vector(0.05, 0.05, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["RopeConnector"] = { type = "Model", model = "models/props_wasteland/kitchen_counter001c.mdl", bone = "ValveBiped.bowl2", rel = "", pos = Vector(0, 0.899, 0), angle = Angle(-100, 0, 0), size = Vector(0.05, 0.05, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Bar2"] = { type = "Model", model = "models/props_c17/metalladder001.mdl", bone = "ValveBiped.bowr2", rel = "", pos = Vector(0, 0.5, 0), angle = Angle(-57, 0, 0), size = Vector(0.109, 0.109, 0.109), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["BarConnecter1+"] = { type = "Model", model = "models/props_wasteland/kitchen_counter001c.mdl", bone = "ValveBiped.bowr1", rel = "", pos = Vector(3.299, 0.899, 0), angle = Angle(0, 0, 0), size = Vector(0.05, 0.05, 0.05), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Bar1"] = { type = "Model", model = "models/props_c17/metalladder001.mdl", bone = "ValveBiped.bowl2", rel = "", pos = Vector(0, 0.5, 0), angle = Angle(57.272, 0, 0), size = Vector(0.109, 0.109, 0.109), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["CenterBeam"] = { type = "Model", model = "models/props_junk/iBeam01a.mdl", bone = "ValveBiped.Crossbow_base", rel = "", pos = Vector(0, -0, 5.714), angle = Angle(90, 0, 0), size = Vector(0.2, 0.2, 0.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}




