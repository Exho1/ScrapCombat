
scrapArmor = {}
scrapArmor.attachments = {}

--[[ 
	* Gamemode idea brainstorming:
		- Relatively fast paced combat like EFT
		- Some sort of base capture or seige maybe
		- Different tiers of weapons that can be earned
		- Incorporate map props into the armor or weapon system somehow
		- Picking up dropped weapons
	
	* Armor made up of props and other scrap items
	* Eliminate net.WriteTable 
	* Armor types
		- Helmet
		- Chestplate
		- Leggings
	* Weapon types
		- Axe
		- Sword
		- Knife
		- Crossbow? Flaming bolts! 
		- Hammer
	* SWEP Kit saves
		- sword
		- sword2h
		
	models/props_c17/metalladder001.mdl
	models/props_junk/iBeam01a.mdl
	models\props_junk\garbage_glassbottle003a_chunk01.mdl
]]



if SERVER then
	AddCSLuaFile()
	AddCSLuaFile("scraparmor/cl_armor.lua")
	AddCSLuaFile("scraparmor/sh_init.lua")
	
	local images = file.Find("materials/vgui/scraparmor/*.png", "GAME") 
	for _, name in pairs( images ) do
		resource.AddFile("materials/vgui/scraparmor/"..name)
	end
	
	include("scraparmor/sh_init.lua")
	include("scraparmor/sv_armor.lua")
end

if CLIENT then

	include("scraparmor/sh_init.lua")
	include("scraparmor/cl_armor.lua")
	
end

scrapArmor.includeItems()
