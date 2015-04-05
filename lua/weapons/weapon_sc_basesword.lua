--// Base SWEP for an 2 handed sword (axe mod)

if SERVER then
	AddCSLuaFile()
end

SWEP.PrintName 				= "Scrap Sword"
SWEP.Author					= "Exho"

SWEP.Base 					= "weapon_sc_baseaxe"
SWEP.Slot					= 1
SWEP.DrawAmmo 				= true
SWEP.DrawCrosshair 			= true
SWEP.HoldType				= "melee2"
SWEP.Spawnable				= false
SWEP.AdminSpawnable			= true

SWEP.Primary.Ammo       	= "none"
SWEP.Primary.Damage       	= 20
SWEP.Primary.Delay      	= 1
SWEP.Primary.Automatic		= true

SWEP.Secondary.Ammo       	= "none"
SWEP.Secondary.Delay    	= 1

SWEP.ViewModel 				= "models/weapons/c_crowbar.mdl"
SWEP.WorldModel 			= "models/weapons/w_crowbar.mdl"
SWEP.ViewModelFlip			= false




