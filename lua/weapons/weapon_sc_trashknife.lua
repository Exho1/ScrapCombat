if SERVER then
	AddCSLuaFile()
end

SWEP.PrintName 				= "Trash Knife"
SWEP.Author					= "Exho"

SWEP.Base 					= "weapon_sc_baseknife"
SWEP.DrawAmmo 				= true
SWEP.DrawCrosshair 			= true
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.Primary.Ammo       	= "none"
SWEP.Primary.Damage       	= 20
SWEP.Primary.Delay      	= 0.5
SWEP.Primary.Automatic		= true

SWEP.Secondary.Ammo       	= "none"
SWEP.Secondary.Delay    	= 1

SWEP.VElements = {
	["Bottle"] = { type = "Model", model = "models/props_junk/garbage_glassbottle003a_chunk01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.596, 1, -8.832), angle = Angle(-3.507, -80.571, -1.17), size = Vector(1.014, 1.014, 1.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["Bottle"] = { type = "Model", model = "models/props_junk/garbage_glassbottle003a_chunk01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.9, 1.299, -7.893), angle = Angle(4, 0, 0), size = Vector(1.144, 0.82, 1.34), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}




