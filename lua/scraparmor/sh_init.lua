
-- Includes all the scrap armor pieces 
function scrapArmor.includeItems()
	local items = file.Find("scraparmor/items/*.lua", "LUA") 
	for _, name in pairs( items ) do
		if string.sub(name,1,1) == "_" then continue end
		
		if SERVER then
			AddCSLuaFile("scraparmor/items/"..name)
		end
		
		ARMOR = {}
		
		ARMOR.name = nil
		ARMOR.tier = nil
		ARMOR.health = nil
		ARMOR.strength = nil
		ARMOR.mdl = "NO_MODEL"
		
		ARMOR.offset = function(ply, model, pos, ang)
			return ply, model, pos, ang
		end
		
		include("scraparmor/items/"..name)
		
		ARMOR.class = string.StripExtension( string.lower(name) )
		
		scrapArmor.registerAttachment( ARMOR )
		
		ARMOR = nil
	end

end

-- Adds a piece of armor to a table so it can be used
function scrapArmor.registerAttachment( tbl )
	scrapArmor.attachments[tbl.class] = tbl
end

scrapArmor.headBones = {
	["ValveBiped.Bip01_Head1"] = "",
	
	["eyes"] = "",
}

scrapArmor.chestBones = {
	["ValveBiped.Bip01_Spine2"] = "",
	["ValveBiped.Bip01_Spine"] = "",
	
	["chest"] = "",
}

scrapArmor.legBones = {
	["ValveBiped.Bip01_L_Thigh"] = "",
	["ValveBiped.Bip01_R_Thigh"] = "",
	["ValveBiped.Bip01_L_Calf"] = "",
	["ValveBiped.Bip01_R_Calf"] = "",
}


function player.getByNick( name )
	for k, v in pairs( player.GetAll() ) do
		if v:Nick():lower() == name:lower() then
			return v
		end
	end
end

function player.getBySteamID( id )
	for k, v in pairs( player.GetAll() ) do
		if v:SteamID() == id or v:SteamID() == "NULL" then -- TEMP
			return v
		end
	end
end
