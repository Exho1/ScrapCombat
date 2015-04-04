if SERVER then
	AddCSLuaFile()
end

SWEP.PrintName 				= "Trash Axe"
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
	["Lamp"] = { type = "Model", model = "models/props_interiors/Furniture_Lamp01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 2, -6), angle = Angle(7, 0, 180), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["Lamp"] = { type = "Model", model = "models/props_interiors/Furniture_Lamp01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.596, 1.5, -9), angle = Angle(-5.844, 0, 175.156), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}



