if SERVER then
	AddCSLuaFile()
end

SWEP.PrintName 				= "Metal Crossbow"
SWEP.Author					= "Exho"

SWEP.Base 					= "weapon_sc_basecrossbow"
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
	["BoltHolder"] = { type = "Model", model = "models/props_wasteland/kitchen_counter001d.mdl", bone = "ValveBiped.Crossbow_base", rel = "", pos = Vector(0, -1.5, 0), angle = Angle(0, 0, -90), size = Vector(0.05, 0.05, 0.05), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["BarConnecter1"] = { type = "Model", model = "models/props_wasteland/kitchen_counter001c.mdl", bone = "ValveBiped.bowl1", rel = "", pos = Vector(-3.3, 0.899, 0), angle = Angle(0, 0, 0), size = Vector(0.05, 0.05, 0.05), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["RopeConnector+"] = { type = "Model", model = "models/props_wasteland/kitchen_counter001c.mdl", bone = "ValveBiped.bowr2", rel = "", pos = Vector(0, 0.899, 0), angle = Angle(100, 0, 0), size = Vector(0.05, 0.05, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["RopeConnector"] = { type = "Model", model = "models/props_wasteland/kitchen_counter001c.mdl", bone = "ValveBiped.bowl2", rel = "", pos = Vector(0, 0.899, 0), angle = Angle(-100, 0, 0), size = Vector(0.05, 0.05, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Bar2"] = { type = "Model", model = "models/props_c17/metalladder001.mdl", bone = "ValveBiped.bowr2", rel = "", pos = Vector(0, 0.5, 0), angle = Angle(-57, 0, 0), size = Vector(0.109, 0.109, 0.109), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["BarConnecter1+"] = { type = "Model", model = "models/props_wasteland/kitchen_counter001c.mdl", bone = "ValveBiped.bowr1", rel = "", pos = Vector(3.299, 0.899, 0), angle = Angle(0, 0, 0), size = Vector(0.05, 0.05, 0.05), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Bar1"] = { type = "Model", model = "models/props_c17/metalladder001.mdl", bone = "ValveBiped.bowl2", rel = "", pos = Vector(0, 0.5, 0), angle = Angle(57.272, 0, 0), size = Vector(0.109, 0.109, 0.109), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["CenterBeam"] = { type = "Model", model = "models/props_junk/iBeam01a.mdl", bone = "ValveBiped.Crossbow_base", rel = "", pos = Vector(0, -0, 5.714), angle = Angle(90, 0, 0), size = Vector(0.2, 0.2, 0.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}





