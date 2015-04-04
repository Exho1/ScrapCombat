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
	["Pole"] = { type = "Model", model = "models/props_c17/utilitypole01b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1.5, 2, 22.337), angle = Angle(-1.17, -115.714, -176.495), size = Vector(0.1, 0.1, 0.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["Pole"] = { type = "Model", model = "models/props_c17/utilitypole01b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.5, 1.399, 6.752), angle = Angle(3.506, -90, 176.494), size = Vector(0.07, 0.07, 0.07), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}



