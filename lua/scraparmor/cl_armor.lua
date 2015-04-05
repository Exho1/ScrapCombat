--// Clientside armor management

-- Adds the armor with the given name to a player
function scrapArmor.add( class, ply )
	ply = ply or LocalPlayer()
	
	for key, tbl in pairs( scrapArmor.attachments ) do
		if key:lower() == class:lower() then
			ply.armor = ply.armor or {}
			
			local index = tbl.bone or tbl.attachment
			
			if ply.armor[index] == nil then
				ply.armor[index] = {}
				ply.armor[index] = ClientsideModel( tbl.mdl )
				ply.armor[index].name = key
				ply.armor[index].class = class
				ply.armor[index].health = tbl.health 

				if tbl.bone2 then
					local index2 = tbl.bone2
					ply.armor[index2] = {}
					ply.armor[index2] = ClientsideModel( tbl.mdl )
					ply.armor[index2].name = key
					ply.armor[index2].class = class
					ply.armor[index2].health = health
				end
			else
				print("Cannot add new armor ("..class..") on top of existing for: ", ply:Nick())
				return
			end
		end
	end
end

-- Removes the armor at the specified bone or attachment
function scrapArmor.removeByBone( bone, ply )
	ply = ply or LocalPlayer()
	if not ply.armor then return end
	
	if bone and ply.armor[bone] then
		ply.armor[bone]:Remove()
		ply.armor[bone] = nil
	else
		for _, v in pairs( ply.armor ) do
			v:Remove()
			ply.armor[k] = nil
		end
	end
end

-- Removes an armor piece by its class for the player
function scrapArmor.removeByClass( class, ply )
	ply = ply or LocalPlayer()
	if not ply.armor then return end
	
	for k, v in pairs( ply.armor ) do
		if v.class == class then
			v:Remove()
			ply.armor[k] = nil
		end
	end
end

-- Removes all armor for the player
function scrapArmor.removeAll( ply ) 
	ply = ply or LocalPlayer()
	if not ply.armor then return end

	for _, v in pairs( ply.armor ) do
		v:Remove()
	end
	
	ply.armor = {}
end

-- Position the clientside models on the correct places on the correct players
hook.Add("PostPlayerDraw", "armor", function( ply )
	if not ply.armor then return end
	if not ply:Alive() then return end
	--if ply == LocalPlayer() then return end
	
	for bone, model in pairs( ply.armor ) do
		local data = scrapArmor.attachments[model.class]
		
		local pos = Vector()
		local ang = Angle()
		
		if not data then return end
		
		-- Get the position and angles for the armor's attachment or bone
		if data.attachment != nil then
			local attachID = ply:LookupAttachment( bone )
			if not attachID then return end
			
			local attachData = ply:GetAttachment( attachID )
			if not attachData then return end
			
			pos = attachData.Pos
			ang = attachData.Ang
		else
			local boneID = ply:LookupBone( bone )
			if not boneID then return end
		
			pos, ang = ply:GetBonePosition(boneID)
		end
		
		if pos then
			-- Run the armor function to modify the model, position, and angles
			model, pos, ang = data.modifyModel( ply, model, pos, ang )
			
			model:SetPos(pos)
			model:SetAngles(ang)
			
			model:SetRenderOrigin(pos)
			model:SetRenderAngles(ang)
			model:SetupBones()
			model:DrawModel()
			model:SetRenderOrigin()
			model:SetRenderAngles()
		end
	end
end)

-- Update a player's armor
net.Receive( "scrap_updatearmor", function()
	local steamID = net.ReadString()
	local classTable = net.ReadTable()
	
	local ply = player.getBySteamID( steamID )
	
	if not ply then return end
	
	-- Remove preexisting armor
	--scrapArmor.removeAll( ply )
	
	-- Add the new armor from the class table
	--[[for bone, tbl in pairs( classTable ) do
		local data = scrapArmor.attachments[tbl.class]
		
		if data then
			ply.armor = ply.armor or {}
			for _, class in pairs( ply.armor ) do
				if class == tbl.class then
					print("Attempt to update existing armor")
					return
				end
			end
			
			print("Why am I adding", tbl.class)
			scrapArmor.add( tbl.class, ply )
		end
	end]]
	
	-- Update health
	for bone, model in pairs( ply.armor ) do
		if classTable[bone] then
			local data = scrapArmor.attachments[model.class]
			
			model.health = classTable[bone].health or data.health
		end
	end
end)

-- Add a piece of armor to a player
net.Receive( "scrap_addarmor", function()
	local id = net.ReadString()
	local class = net.ReadString()
	
	local ply = player.getBySteamID( id )
	if not ply then return end
	
	scrapArmor.add( class, ply )
end)

-- Remove a piece of armor for a player
net.Receive( "scrap_removearmor", function()
	local id = net.ReadString()
	local type = net.ReadString()
	local arg = net.ReadString()
	
	local ply = player.getBySteamID( id )
	if not ply then return end
	
	type = type:lower()
	
	if type == "all" then
		scrapArmor.removeAll( ply )
	elseif arg != "" then
		if type == "bone" then
			scrapArmor.removeByBone( arg, ply )
		else 
			scrapArmor.removeByClass( arg, ply )
		end
	end
end)

-- Helper function that returns black if the player does not have that piece of armor
local function getDestroyedColor( tbl )
	local color = Color( 255, 255, 255, 200 )
	
	for bone in pairs( tbl ) do
		if LocalPlayer().armor[bone] != nil then
			return Color( 255, 255, 255, 200 )
		else
			color = Color( 20, 20, 20, 200 )
		end
	end
	
	return color
end

local matHelmet = Material( "vgui/scraparmor/helmet.png", "noclamp smooth" ) -- 163, 232
local matChestplate = Material( "vgui/scraparmor/chestplate.png", "noclamp smooth" ) -- 326, 369
local matLeggings = Material( "vgui/scraparmor/leggings.png", "noclamp smooth" ) --352, 365

-- Armor damage/health indicator
hook.Add("HUDPaint", "armor_indicator", function()
	local client = LocalPlayer()
	if client.armor and table.Count(client.armor) > 0 then
		-- Sizes for the images
		local helmetH = 50
		local helmetW = 30
		local chestH = 70
		local chestW = 60
		local legH = 80
		local legW = 45
		
		local x = 75
		local y = ScrH() / 2 - helmetH / 2 - chestH / 2 - legH / 2
		
		-- Default color is a slightly transparent white
		local col = Color( 255, 255, 255, 200 )
		local helmetColor = col
		local chestColor = col
		local legColor = col
		
		-- Check if the equipped armor is damaged
		for bone, model in pairs(client.armor) do
			local data = scrapArmor.attachments[model.class]
			if not data then continue end
			
			model.health = model.health or data.health
			if not model.health then continue end
			
			-- Get the percentage of health out of the starting armor health
			local perc = model.health / data.health
			local dark = perc * 255 -- 255 = full health, 0 = no health
			
			-- Create a shade of red based off the percentage of damage that that piece of armor has taken
			if scrapArmor.headBones[bone] then
				helmetColor = Color( 255, dark, dark, 200 )
			elseif scrapArmor.chestBones[bone] then
				chestColor = Color( 255, dark, dark, 200 )
			elseif scrapArmor.legBones[bone] then
				legColor = Color( 255, dark, dark, 200 )
			end
		end
		
		-- If the armor is not damaged, we might as well check if it was destroyed
		if helmetColor == col then
			helmetColor = getDestroyedColor( scrapArmor.headBones )
		end
		
		if chestColor == col then
			chestColor = getDestroyedColor( scrapArmor.chestBones )
		end
		
		if legColor == col then
			legColor = getDestroyedColor( scrapArmor.legBones )
		end
		
		-- Draw the armor indicators
		surface.SetMaterial( matHelmet ) 
		surface.SetDrawColor( helmetColor )
		surface.DrawTexturedRect( x - (helmetW/2), y, helmetW, helmetH )
		
		y = y + helmetH
		
		surface.SetMaterial( matChestplate ) 
		surface.SetDrawColor( chestColor )
		surface.DrawTexturedRect( x - (chestW/2), y, chestW, chestH )
		
		y = y + chestH
		
		surface.SetMaterial( matLeggings ) 
		surface.SetDrawColor( legColor )
		surface.DrawTexturedRect( x - (legW/2), y, legW, legH )
	end
end)

