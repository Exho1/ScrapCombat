--// Base SWEP for an axe (crowbar mod)

if SERVER then
	AddCSLuaFile()
end

SWEP.PrintName 				= "Scrap Axe"
SWEP.Author					= "Exho"

SWEP.Base 					= "weapon_sc_base"
SWEP.Slot					= 1
SWEP.DrawAmmo 				= true
SWEP.DrawCrosshair 			= true
SWEP.HoldType				= "melee"
SWEP.Spawnable				= false
SWEP.AdminSpawnable			= true

SWEP.Primary.Ammo       	= "none"
SWEP.Primary.Damage       	= 20
SWEP.Primary.Delay      	= 0.5
SWEP.Primary.Automatic		= true

SWEP.Secondary.Ammo       	= "none"
SWEP.Secondary.Delay    	= 1

SWEP.ViewModel 				= "models/weapons/c_crowbar.mdl"
SWEP.WorldModel 			= "models/weapons/w_crowbar.mdl"
SWEP.ViewModelFlip			= false

SWEP.swingSound = Sound("Weapon_Crowbar.Single")

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	local startPos = self.Owner:GetShootPos()
	local endPos = startPos + (self.Owner:GetAimVector() * 70)

	local data = {start=startPos, endpos=endPos, filter=self.Owner, mask=MASK_SHOT_HULL}
	local tr = util.TraceLine( data )
	
	-- Swing sound
	self:EmitSound( self.swingSound )
	
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	
	local ent = tr.Entity
	if IsValid( ent ) or tr.HitWorld then
		-- Animations
		self:SendWeaponAnim( ACT_VM_MISSCENTER )
		
		-- Hit effects
		local effect = EffectData()
        effect:SetStart( startPos )
        effect:SetOrigin( tr.HitPos )
        effect:SetNormal( tr.Normal )
        effect:SetEntity( ent )
		
		if ent:IsPlayer() or ent:IsNPC() or ent:GetClass() == "prop_ragdoll" then
			util.Effect("BloodImpact", effect)

			self.Owner:FireBullets({Num=1, Src=spos, Dir=self.Owner:GetAimVector(), Spread=Vector(0,0,0), Tracer=0, Force=1, Damage=0})
        else
			util.Effect("Impact", effect)
        end
	else
		-- Swing wildly at the air
		self:SendWeaponAnim( ACT_VM_MISSCENTER )
	end
	
	if SERVER then
		-- Trace again to deal damage
		local tr = util.TraceLine({start=startPos, endpos=endPos, filter=self.Owner})
      
		self.Owner:SetAnimation( PLAYER_ATTACK1 )

		if IsValid( ent ) then
			local dmg = DamageInfo()
			dmg:SetDamage( self.Primary.Damage )
			dmg:SetAttacker( self.Owner )
			dmg:SetInflictor( self )
			dmg:SetDamageForce(self.Owner:GetAimVector() * 1500 )
			dmg:SetDamagePosition( self.Owner:GetPos() )
			dmg:SetDamageType(DMG_CLUB)
			
			-- Inflict the damage
			ent:DispatchTraceAttack(dmg, startPos + (self.Owner:GetAimVector() * 3), endPos)
		end
	end
end

function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
	
	if CLIENT then
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
	end
	
	self:SendWeaponAnim( ACT_VM_HITCENTER )
end



