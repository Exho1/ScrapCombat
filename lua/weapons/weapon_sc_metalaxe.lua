if SERVER then
	AddCSLuaFile()
end

SWEP.PrintName 				= "Metal Axe"
SWEP.Author					= "Exho"

SWEP.Base					= "weapon_sc_baseaxe"
SWEP.DrawAmmo 				= true
SWEP.DrawCrosshair 			= true
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.Primary.Ammo       	= "none"
SWEP.Primary.Damage       	= 10
SWEP.Primary.Delay      	= 0.5
SWEP.Primary.Automatic		= true

SWEP.Secondary.Ammo       	= "none"
SWEP.Secondary.Delay    	= 1

SWEP.VElements = {
	["Hook"] = { type = "Model", model = "models/props_junk/meathook001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5, 2, -7.87), angle = Angle(2, 75.973, -6), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["Hook"] = { type = "Model", model = "models/props_junk/meathook001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5, 1, -9), angle = Angle(0, 110, 5), size = Vector(0.5, 0.6, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}


