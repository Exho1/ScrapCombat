if SERVER then
	AddCSLuaFile()
end

SWEP.PrintName 				= "Wooden Axe"
SWEP.Author					= "Exho"

SWEP.Base					= "weapon_sc_baseaxe"
SWEP.HoldType				= "melee"
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
	["Chair"] = { type = "Model", model = "models/props_interiors/Furniture_chair01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.5, -2, -10), angle = Angle(-3.507, 0, 174.156), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["Chair"] = { type = "Model", model = "models/props_interiors/Furniture_chair01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.539, -3, -6.753), angle = Angle(-3, 0, 174), size = Vector(0.699, 0.699, 0.699), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}


