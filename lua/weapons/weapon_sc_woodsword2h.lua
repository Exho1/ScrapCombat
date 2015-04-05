if SERVER then
	AddCSLuaFile()
end

SWEP.PrintName 				= "Wood Sword 2H"
SWEP.Author					= "Exho"

SWEP.Base					= "weapon_sc_basesword"
SWEP.DrawAmmo 				= true
SWEP.DrawCrosshair 			= true
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.Primary.Ammo       	= "none"
SWEP.Primary.Damage       	= 30
SWEP.Primary.Delay      	= 1.2
SWEP.Primary.Automatic		= true

SWEP.Secondary.Ammo       	= "none"
SWEP.Secondary.Delay    	= 1


SWEP.VElements = {
	["Sword"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.5, 1.399, -5.715), angle = Angle(-1, 90.662, 170), size = Vector(0.3, 2.5, 0.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Hilt+"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7, 1.399, -4.676), angle = Angle(100, 0, 0), size = Vector(0.5, 0.5, 0.07), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Hilt"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.4, 1.399, -5), angle = Angle(8.182, 0, 0), size = Vector(0.5, 0.5, 0.07), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["Sword"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1.799, 4.3, -31), angle = Angle(5, -89.338, -3), size = Vector(0.2, 1.899, 0.25), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Hilt+"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 1.799, -4), angle = Angle(-3.5, 0, -5), size = Vector(0.5, 0.5, 0.109), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Hilt"] = { type = "Model", model = "models/props_c17/signpole001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-0.7, 1.899, -3.636), angle = Angle(-3.5, 90, 90), size = Vector(0.5, 0.5, 0.07), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}


