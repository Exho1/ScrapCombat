if SERVER then
	AddCSLuaFile()
end

SWEP.PrintName 				= "Wooden Knife"
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
	["Knife"] = { type = "Model", model = "models/Gibs/wood_gib01e.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 1.5, -5), angle = Angle(-99.351, 143.766, -125.066), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["Knife"] = { type = "Model", model = "models/Gibs/wood_gib01e.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 2, -5), angle = Angle(-80.65, -12.858, -19.871), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}




