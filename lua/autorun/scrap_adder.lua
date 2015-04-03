
scrapArmor = {}
scrapArmor.attachments = {}

--[[ Idea - Modern scrap warfare with medieval weapons ORRRR medieval scrap warfare
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
		- Crossbow?
		- Hammer
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
