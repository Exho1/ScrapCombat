--// Base SWEP for a knife 

if SERVER then
	AddCSLuaFile()
end

SWEP.PrintName 				= "Scrap Knife"
SWEP.Author					= "Exho"

SWEP.Base 					= "weapon_sc_base"
SWEP.Slot					= 2
SWEP.DrawAmmo 				= true
SWEP.DrawCrosshair 			= true
SWEP.HoldType				= "knife"
SWEP.Spawnable				= false
SWEP.AdminSpawnable			= true

SWEP.Primary.Ammo       	= "none"
SWEP.Primary.Damage       	= 20
SWEP.Primary.Delay      	= 0.5
SWEP.Primary.Automatic		= true

SWEP.Secondary.Ammo       	= "none"
SWEP.Secondary.Delay    	= 1

SWEP.ViewModel          	= "models/weapons/cstrike/c_knife_t.mdl"
SWEP.WorldModel        		= "models/weapons/w_knife_t.mdl"
SWEP.ViewModelFlip			= false

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	local startPos = self.Owner:GetShootPos()
	local endPos = startPos + (self.Owner:GetAimVector() * 70)
	
	local mins = Vector(1,1,1) * -10
	local maxs = Vector(1,1,1) * 10

	local data = {start=startPos, endpos=endPos, filter=self.Owner, mask=MASK_SHOT_HULL, mins=mins, maxs=maxs}
	local tr = util.TraceLine( data )
	
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	
	local ent = tr.Entity
	if IsValid( ent ) or tr.HitWorld then
		-- Animations
		self:SendWeaponAnim( ACT_VM_MISSCENTER )
		
		-- Sound based on what we hit
		if tr.HitWorld then
			self:EmitSound( "Weapon_Knife.HitWall" )
		else
			self:EmitSound( "Weapon_Knife.Hit" )
		end
		
		-- Hit effects
		local effect = EffectData()
        effect:SetStart( startPos )
        effect:SetOrigin( tr.HitPos )
        effect:SetNormal( tr.Normal )
        effect:SetEntity( ent )
		
		if ent:IsPlayer() or ent:GetClass() == "prop_ragdoll" then
			util.Effect("BloodImpact", effect)
        end
	else
		-- Swing wildly at the air
		self:SendWeaponAnim( ACT_VM_MISSCENTER )
		self:EmitSound( "Weapon_Knife.Slash" )
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
			dmg:SetDamageForce(self.Owner:GetAimVector() * 5 )
			dmg:SetDamagePosition( self.Owner:GetPos() )
			dmg:SetDamageType( DMG_SLASH )
			
			-- Inflict the damage
			ent:DispatchTraceAttack(dmg, startPos + (self.Owner:GetAimVector() * 3), endPos)
		end
	end
end

function SWEP:SecondaryAttack()
	
end

function SWEP:Deploy()
	self.Weapon:EmitSound( "Weapon_Knife.Deploy" )
end

function SWEP:DoImpactEffect( tr, nDamageType )
	util.Decal("ManhackCut", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)	
	return true
end

-- Hide the default view model
function SWEP:PreDrawViewModel( vm, ply, wep )
	vm:SetMaterial( "engine/occlusionproxy" )
end

-- Reset the material so the other view models show up
function SWEP:PostDrawViewModel( vm, ply, wep )
	vm:SetMaterial()
end
