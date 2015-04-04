--// Base SWEP for an crossbow modified from Garry's HL2 crossbow

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
SWEP.Primary.Ammo			= "XBowBolt"
SWEP.Primary.AmmoType		= "crossbow_bolt"

SWEP.Primary.NumShots		= 1
SWEP.Primary.NumAmmo		= SWEP.Primary.NumShots
SWEP.ViewModel 				= "models/weapons/c_crossbow.mdl"
SWEP.WorldModel 			= "models/weapons/w_crossbow.mdl"
SWEP.ViewModelFlip			= false

SWEP.Primary.Reload			= Sound( "Weapon_Crossbow.Reload" )
SWEP.Primary.Sound 			= Sound ("Weapon_Crossbow.Single")
SWEP.Primary.Special2		= Sound( "Weapon_Crossbow.BoltFly" )

BOLT_MODEL	= "models/weapons/w_missile_closed.mdl"

BOLT_AIR_VELOCITY	= 3500
BOLT_WATER_VELOCITY	= 1500
BOLT_SKIN_NORMAL	= 0
BOLT_SKIN_GLOW		= 1

CROSSBOW_GLOW_SPRITE	= "sprites/light_glow02_noz.vmt"
CROSSBOW_GLOW_SPRITE2	= "sprites/blueflare1.vmt"

--[[---------------------------------------------------------
   Name: SWEP:Precache( )
   Desc: Use this function to precache stuff
---------------------------------------------------------]]
function SWEP:Precache()

	util.PrecacheSound( "Weapon_Crossbow.BoltHitBody" );
	util.PrecacheSound( "Weapon_Crossbow.BoltHitWorld" );
	util.PrecacheSound( "Weapon_Crossbow.BoltSkewer" );

	util.PrecacheModel( CROSSBOW_GLOW_SPRITE );
	util.PrecacheModel( CROSSBOW_GLOW_SPRITE2 );

	self.BaseClass:Precache();

end



--[[---------------------------------------------------------
   Name: SWEP:PrimaryAttack( )
   Desc: +attack1 has been pressed
---------------------------------------------------------]]
function SWEP:PrimaryAttack()

	-- Make sure we can shoot first
	if ( !self:CanPrimaryAttack() ) then return end
	
	self:FireBolt();

	-- Signal a reload
	self.m_bMustReload = true;

end


--[[---------------------------------------------------------
   Name: SWEP:SecondaryAttack( )
   Desc: +attack2 has been pressed
---------------------------------------------------------]]
function SWEP:SecondaryAttack()

end

--[[---------------------------------------------------------
   Name: SWEP:Reload( )
   Desc: Reload is being pressed
---------------------------------------------------------]]
function SWEP:Reload()

	if ( self.Weapon:DefaultReload( ACT_VM_RELOAD ) ) then
		self.m_bMustReload = false;
		return true;
	end

	return false;

end

-------------------------------------------------------------------------------
-- Purpose:
-------------------------------------------------------------------------------
function SWEP:CheckZoomToggle()

	local pPlayer = self.Owner;

	if ( pPlayer:KeyPressed( IN_ATTACK2 ) ) then
		self:ToggleZoom();
	end

end

--[[---------------------------------------------------------
   Name: SWEP:PreThink( )
   Desc: Called before every frame
---------------------------------------------------------]]
function SWEP:PreThink()
end


--[[---------------------------------------------------------
   Name: SWEP:Think( )
   Desc: Called every frame
---------------------------------------------------------]]
function SWEP:Think()

	-- Disallow zoom toggling
	-- self:CheckZoomToggle();

	if ( self.m_bMustReload ) then
		self:Reload();
	end

	local pPlayer = self.Owner;

	if ( !pPlayer ) then
		return;
	end

	self:PreThink();

	if ( pPlayer:WaterLevel() >= 3 ) then
		self.m_bIsUnderwater = true;
	else
		self.m_bIsUnderwater = false;
	end

end

-------------------------------------------------------------------------------
-- Purpose:
-------------------------------------------------------------------------------
function SWEP:FireBolt()

	if ( self.Weapon:Clip1() <= 0 && self.Primary.ClipSize > -1 ) then
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

	local pBolt = ents.Create( self.Primary.AmmoType );
	pBolt:SetPos( vecSrc );
	pBolt:SetAngles( angAiming );
	pBolt.m_iDamage = self.Primary.Damage;
	pBolt:SetOwner( pOwner );
	pBolt:Spawn()

	if ( pOwner:WaterLevel() == 3 ) then
		pBolt:SetVelocity( vecAiming * BOLT_WATER_VELOCITY );
	else
		pBolt:SetVelocity( vecAiming * BOLT_AIR_VELOCITY );
	end

end

	self:TakePrimaryAmmo( self.Primary.NumAmmo );

	if ( !pOwner:IsNPC() ) then
		pOwner:ViewPunch( Angle( -2, 0, 0 ) );
	end

	self.Weapon:EmitSound( self.Primary.Sound );
	self.Owner:EmitSound( self.Primary.Special2 );

	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK );

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay );
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay );

	-- self:DoLoadEffect();
	-- self:SetChargerState( CHARGER_STATE_DISCHARGE );

end

--[[---------------------------------------------------------
   Name: SWEP:Holster( weapon_to_swap_to )
   Desc: Weapon wants to holster
   RetV: Return true to allow the weapon to holster
---------------------------------------------------------]]
function SWEP:Holster( wep )

	if ( self.m_bInZoom ) then
		self:ToggleZoom();
	end

	-- self:SetChargerState( CHARGER_STATE_OFF );

	return self.BaseClass:Holster( wep );

end

--[[---------------------------------------------------------
   Name: SWEP:Deploy( )
   Desc: Whip it out
---------------------------------------------------------]]
function SWEP:Deploy()

	if ( self.Weapon:Clip1() <= 0 ) then
		self.Weapon:SendWeaponAnim( ACT_CROSSBOW_DRAW_UNLOADED );
		return self:SetDeploySpeed( self.Weapon:SequenceDuration() );
	end

	self:SetSkin( BOLT_SKIN_GLOW );

	self.Weapon:SendWeaponAnim( ACT_VM_DRAW );
	return self:SetDeploySpeed( self.Weapon:SequenceDuration() );

end


-------------------------------------------------------------------------------
-- Purpose:
-------------------------------------------------------------------------------
function SWEP:ToggleZoom()

	local pPlayer = self.Owner;

	if ( pPlayer == NULL ) then
		return;
	end

if ( !CLIENT ) then

	if ( self.m_bInZoom ) then
		pPlayer:SetCanZoom( true )
		pPlayer:SetFOV( 0, 0.2 )
		self.m_bInZoom = false;
	else
		pPlayer:SetCanZoom( false )
		pPlayer:SetFOV( 20, 0.1 )
		self.m_bInZoom = true;
	end
end

end

BOLT_TIP_ATTACHMENT	= 2

-------------------------------------------------------------------------------
-- Purpose:
-- Input  : skinNum -
-------------------------------------------------------------------------------
function SWEP:SetSkin( skinNum )

	local pOwner = self.Owner;

	if ( pOwner == NULL ) then
		return;
	end

	local pViewModel = pOwner:GetViewModel();

	if ( pViewModel == NULL ) then
		return;
	end

	pViewModel:SetSkin( skinNum );

end

--[[---------------------------------------------------------
   Name: SWEP:CanPrimaryAttack( )
   Desc: Helper function for checking for no ammo
---------------------------------------------------------]]
function SWEP:CanPrimaryAttack()
	return true
end


--[[---------------------------------------------------------
   Name: SWEP:CanSecondaryAttack( )
   Desc: Helper function for checking for no ammo
---------------------------------------------------------]]
function SWEP:CanSecondaryAttack()
	return true
end


--[[---------------------------------------------------------
   Name: SetDeploySpeed
   Desc: Sets the weapon deploy speed.
		 This value needs to match on client and server.
---------------------------------------------------------]]
function SWEP:SetDeploySpeed( speed )

	self.m_WeaponDeploySpeed = tonumber( speed / GetConVarNumber( "phys_timescale" ) )

	self.Weapon:SetNextPrimaryFire( CurTime() + speed )
	self.Weapon:SetNextSecondaryFire( CurTime() + speed )

end





