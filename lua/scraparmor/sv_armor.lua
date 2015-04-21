--// Serverside armor management

util.AddNetworkString("scrap_updatearmor")
util.AddNetworkString("scrap_addarmor")
util.AddNetworkString("scrap_removearmor")

-- Returns a hitgroup enum for the bone given
scrapArmor.stringToHitgroup = {
	-- Bones
	["ValveBiped.Bip01_Spine"] = HITGROUP_STOMACH,
	["ValveBiped.Bip01_Spine2"] = HITGROUP_CHEST,
	["ValveBiped.Bip01_Head1"] = HITGROUP_HEAD,
	["ValveBiped.Bip01_L_Forearm"] = HITGROUP_LEFTARM,
	["ValveBiped.Bip01_R_Forearm"] = HITGROUP_RIGHTARM,
	["ValveBiped.Bip01_L_Thigh"] = HITGROUP_LEFTLEG,
	["ValveBiped.Bip01_R_Thigh"] = HITGROUP_RIGHTLEG,
	["ValveBiped.Bip01_L_Calf"] = HITGROUP_LEFTLEG,
	["ValveBiped.Bip01_R_Calf"] = HITGROUP_RIGHTLEG,
	
	
	-- Attachments
	["eyes"] = HITGROUP_HEAD,
	["chest"] = HITGROUP_CHEST,
	["lefthand"] = HITGROUP_LEFTARM,
	["righthand"] = HITGROUP_RIGHTARM,
}

hook.Add("ScalePlayerDamage", "scrap_damagereduction", function( ply, hitgroup, dmginfo )
	if ply.armorHitgroups != nil then
		if ply.armorHitgroups[ hitgroup ] then
			local class = ply.armorHitgroups[ hitgroup ]
			local data = scrapArmor.attachments[class]
			local dmg = dmginfo:GetDamage()
			
			-- Convert the number from being 1-100 to 0.01 to 1 and subtract it by 1 (0.6 -> 0.4)
			local dmgModifier = 1 - (data.strength * 0.01)
			
			-- Scale the damage according to our decimal modifier
			dmginfo:ScaleDamage( dmgModifier )
			
			-- Get the attachment table for the armor damaged
			ply.attachments = ply.attachments or {}
			local aData = nil
			for bone, tbl in pairs( ply.attachments ) do
				if tbl.class == class then
					aData = tbl
				end
			end
			
			-- Take damage for the armor
			if aData then
				aData.health = aData.health - dmg
				
				-- Armor broke
				if aData.health <= 0 then
					scrapArmor.removeArmor( ply, "class", class )
					ply:ChatPrint("Armor ("..class..") broke due to damage!")
				end
			end
			
			-- Make sure all the players know this
			net.Start("scrap_updatearmor")
				net.WriteString( ply:SteamID() )
				net.WriteTable( ply.attachments )
			net.Broadcast()
		end
	end
end)

hook.Add("PlayerDeath", "scrap_playerdeath", function( ply, inf, att )
	-- Remove their armor on death
	scrapArmor.removeArmor( ply, "all" )
end)

-- Gives the player a new piece of armor
function scrapArmor.giveArmor( ply, class )
	ply.armorHitgroups = ply.armorHitgroups or {}
	ply.attachments = ply.attachments or {}
	
	local data = scrapArmor.attachments[class]
	local bone = data.bone or data.attachment
	
	if ply.attachments[bone] then
		if ply.attachments[bone].class != class then
			ply.attachments[bone] = {class=class, health=data.health}
		end
	else
		ply.attachments[bone] = {class=class, health=data.health}
	end
	
	local hitgroup = scrapArmor.stringToHitgroup[bone]
	if hitgroup then
		ply.armorHitgroups[hitgroup] = class
	end
	
	-- Tell the client to equip the armor
	net.Start("scrap_addarmor")
		net.WriteString( ply:SteamID() )
		net.WriteString( class )
	net.Broadcast()
end

-- Removes the player's armor either one piece or all of it
function scrapArmor.removeArmor( ply, type, arg )
	type = type:lower()
	
	if type == "all" then
		ply.attachments = {}
		ply.armorHitgroups = {}
	elseif type == "class" then
		local data = scrapArmor.attachments[arg]
		local bone = data.bone or data.attachment
		
		if not bone then return end
		
		ply.attachments[bone] = nil
		
		local hitgroup = scrapArmor.stringToHitgroup[bone]
		if hitgroup then
			ply.armorHitgroups[hitgroup] = nil
		end
	elseif type == "bone" then
		ply.attachments[arg] = nil
		
		local hitgroup = scrapArmor.stringToHitgroup[bone]
		if hitgroup then
			ply.armorHitgroups[hitgroup] = nil
		end
	end
	
	net.Start("scrap_removearmor")
		net.WriteString( ply:SteamID() )
		net.WriteString( type )
		net.WriteString( arg or "" )
	net.Broadcast()
end

function findExho()
	for k, v in pairs(player.GetAll()) do
		if v:Nick() == "Exho" then
			return v
		end
	end
end

-- TEMPORARY
function addTrash()
	local ply = findExho()
	scrapArmor.giveArmor( ply, "trash_helmet" )
	scrapArmor.giveArmor( ply, "trash_chestplate" )
	scrapArmor.giveArmor( ply, "trash_leggings" )
end

function addWood()
	local ply = findExho()	
	scrapArmor.giveArmor( ply, "wood_helmet" )
	scrapArmor.giveArmor( ply, "wood_chestplate" )
	scrapArmor.giveArmor( ply, "wood_leggings" )
end

function addMetal()
	local ply = findExho()
	scrapArmor.giveArmor( ply, "metal_helmet" )
	scrapArmor.giveArmor( ply, "metal_chestplate" )
	scrapArmor.giveArmor( ply, "metal_leggings" )
end

function removeArmor()
	local ply = findExho()
	for k, ply in pairs(player.GetAll()) do
		scrapArmor.removeArmor( ply, "all" )
	end
end



