--// Base SWEP for an spear (ar2 mod)

if SERVER then
	AddCSLuaFile()
end

SWEP.PrintName 				= "Scrap Spear"
SWEP.Author					= "Exho"

SWEP.Base 					= "weapon_sc_base"
SWEP.Slot					= 1
SWEP.DrawAmmo 				= true
SWEP.DrawCrosshair 			= true
SWEP.HoldType				= "ar2"
SWEP.Spawnable				= false
SWEP.AdminSpawnable			= true

SWEP.Primary.Ammo       	= "none"
SWEP.Primary.Damage       	= 20
SWEP.Primary.Delay      	= 0.5
SWEP.Primary.Automatic		= true

SWEP.Secondary.Ammo       	= "none"
SWEP.Secondary.Delay    	= 1

SWEP.ViewModel 				= "models/weapons/c_irifle.mdl"
SWEP.WorldModel 			= "models/weapons/w_irifle.mdl"
SWEP.ViewModelFlip			= false

SWEP.ViewModelFOV = 70

-- Temp
SWEP.VElements = {
	["Harpoon"] = { type = "Model", model = "models/props_junk/harpoon002a.mdl", bone = "Base", rel = "", pos = Vector(0, 3.4, 5.714), angle = Angle(92.337, 180, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

function SWEP:PrimaryAttack()
	self.lunging = true
	
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	local startPos = self.Owner:GetShootPos()
	local endPos = startPos + (self.Owner:GetAimVector() * 80)
	
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
		self.Owner:ViewPunch(Angle(-0.5, 0, 0))
		
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

function SWEP:Think()
	-- Simulate thrusting the spear forward using FOV
	if self.lunging then
		if math.ceil(self.ViewModelFOV) == 70 then
			to = 110
		elseif math.ceil(self.ViewModelFOV) == 110 then
			self.lunging = false
		end
		
		self.ViewModelFOV = Lerp( 20 * FrameTime(), self.ViewModelFOV, to )
	else
		self.ViewModelFOV = Lerp( 20 * FrameTime(), self.ViewModelFOV, 70 )
	end
end




