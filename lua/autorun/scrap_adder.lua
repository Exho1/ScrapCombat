
scrapArmor = {}
scrapArmor.attachments = {}

--[[ 
	* Trello: https://trello.com/b/sjf0ICXt/scrap-combat
	

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
]]



if SERVER then
	AddCSLuaFile()
	AddCSLuaFile("scraparmor/cl_armor.lua")
	AddCSLuaFile("scraparmor/cl_inventory.lua")
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
	include("scraparmor/cl_inventory.lua")
	
	LocalPlayer().armor = {}
	
end

scrapArmor.includeItems()
