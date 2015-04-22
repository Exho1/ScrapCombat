scrapInventory = {}

-- MAKE SURE THESE SCALE ON ALL RESOLUTIONS

surface.CreateFont( "scrap_18", {
font = "Roboto Lt",
size = 18,
weight = 500,
antialias = true,
} )

surface.CreateFont( "scrap_16", {
font = "Roboto Lt",
size = 16,
weight = 500,
antialias = true,
} )

function scrapInventory.buildCustomizeMenu()
	local client = LocalPlayer()
	client.armor = client.armor or {}
	
	-- Get a copy of the armor before we modify it
	local initialArmor = table.Copy( client.armor )
	
	local frame = vgui.Create("DFrame")
	frame:SetSize( 800, 600 )
	frame:SetTitle("")
	frame:ShowCloseButton( false )
	frame:SetDraggable( false )
	frame:SetPos( ScrW()/2 - (frame:GetWide()/2), ScrH()/2 - (frame:GetTall()/2))
	frame.Paint = function( self, w, h )
		scrapInventory.blur( self, 10, 30, 255 )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 30, 30, 30, 200 ) )
		draw.RoundedBox( 0, 0, 0, w, 25, Color( 80, 80, 80, 100 ) )
	end
	frame:MakePopup()
	
	local closeButton = vgui.Create("DButton", frame)
	closeButton:SetSize( 40, 18 )
	closeButton:SetPos( frame:GetWide() - closeButton:GetWide() - 5, 3 )
	closeButton:SetText( "X" )
	closeButton:SetTextColor( color_white )
	closeButton.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color(192, 57, 43) )
	end
	closeButton.DoClick = function( self )
		-- Close the frame
		local pnl = self:GetParent()
		pnl:Close()

		local isChange = false
		if table.Count( client.armor ) != table.Count( initialArmor ) then
			print("Count difference")
			isChange = true
		end
		
		if not isChange then
			for bone, model in pairs( initialArmor ) do
				if not client.armor[bone] then
					print("Removed armor")
					isChange = true
					break
				elseif model.class != client.armor[bone].class then	
					print("Differing armor class")
					isChange = true
					break
				end
			end
		end
		
		-- Check to see if we need to send our changes to the server for verification
		if isChange then
			print("Made changes to armor, telling server")
			net.Start("scrap_updatearmor")
				net.WriteTable( scrapArmor.getNWableArmor() )
			net.SendToServer()
		else
			print("Made no changes to armor")
		end
	end
	
	local title = vgui.Create("DLabel", frame)
	title:SetText( "Inventory" )
	title:SetFont( "scrap_18" )
	title:SizeToContents()
	title:SetPos( 5, 4 )
	
	local playerModel = vgui.Create("DModelPanel", frame)
	playerModel:SetSize( 200, 450 )
	playerModel:SetPos( 100, 25 )
	playerModel:SetModel( LocalPlayer():GetModel() )
	function playerModel:LayoutEntity( Entity ) return end
	
	-- Adjust the position of the entity
	playerModel.Entity:SetPos( Vector( 25, 25, 0 ) )
	playerModel.Entity:SetAngles( Angle( 0, 40, 0 ) )
	
	-- Modify the DModelPanel to draw our armor onto the player model
	local oldDraw = playerModel.DrawModel
	function playerModel:DrawModel()
		oldDraw( playerModel )
		
		local ent = self.Entity
		
		for bone, model in pairs( client.armor ) do
			local data = scrapArmor.attachments[model.class]
			
			local pos = Vector()
			local ang = Angle()
			
			if not data then return end
			
			-- Get the position and angles for the armor's attachment or bone
			if data.attachment != nil then
				local attachID = ent:LookupAttachment( bone )
				if not attachID then return end
				
				local attachData = ent:GetAttachment( attachID )
				if not attachData then return end
				
				pos = attachData.Pos
				ang = attachData.Ang
			else
				local boneID = ent:LookupBone( bone )
				if not boneID then return end
			
				pos, ang = ent:GetBonePosition(boneID)
			end
			
			if pos then
				-- Run the armor function to modify the model, position, and angles
				model, pos, ang = data.modifyModel( ent, model, pos, ang )
				
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
	end
	
	scrapInventory.armorSlots = {}
	
	-- Armor slots for head, chest, legs
	local yBuffer = select(2, playerModel:GetPos()) + 100
	for i = 1, 3 do
		local panel = vgui.Create("DPanel", frame)
		panel:SetPos( 25, yBuffer )
		panel:SetSize( 64, 64 )
		panel:SetCursor( "hand" )
		panel.Paint = function( self, w, h )
			surface.SetDrawColor( color_white )
			surface.DrawOutlinedRect( 0, 0, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 30, 30, 30, 200 ) )
		end
		panel:Receiver( "scrapIcon", function( pnl, item, drop, key, x, y )
			scrapInventory.armorReceive( pnl, item, drop, key, x, y, panel, i )
		end)
		
		table.insert( scrapInventory.armorSlots, {panel=panel} )
		
		yBuffer = yBuffer + panel:GetTall() + 30
	end
	
	-- Add the player's armor to the slots
	for bone, model in pairs( client.armor ) do
		local index = 0
		if scrapArmor.headBones[bone] then
			index = 1
		elseif scrapArmor.chestBones[bone] then
			index = 2
		elseif scrapArmor.legBones[bone] then
			index = 3
		end
		
		-- Make sure we only create this once
		if not scrapInventory.armorSlots[index].icon then
			local data = scrapArmor.attachments[model.class]
			
			local icon = vgui.Create("Spawnicon", scrapInventory.armorSlots[index].panel)
			icon:SetModel( model:GetModel())
			icon.mdl = model:GetModel() -- This is important so that we can access the model wherever we can access the spawnicon
			icon:Droppable( "scrapIcon" )
			icon:SetTooltip( data.name )
			
			local selector = vgui.Create("DButton", icon )
			selector:SetPos( 0, 0 )
			selector:SetText("")
			selector:SetSize( icon:GetSize() )
			selector.Paint = function() end
			selector:SetDragParent( icon )
			
			local pnl = scrapInventory.armorSlots[index].panel
			
			scrapInventory.armorSlots[index] = {panel=pnl, icon=icon, button=selector}
		end
	end
	
	local bgPanel = vgui.Create("DPanel", frame )
	bgPanel:SetSize( frame:GetWide() / 3 * 1.57, frame:GetTall() - 112 )
	bgPanel:SetPos( frame:GetWide() - bgPanel:GetWide() - 25, frame:GetTall()/2 - bgPanel:GetTall()/2 + 10 )
	bgPanel.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 30, 30, 30, 200 ) )
	end
	
	local inventory = vgui.Create( "DIconLayout", bgPanel )
	inventory:SetSize( bgPanel:GetSize() )
	inventory:SetPos( 5, 5 )
	inventory:SetSpaceY( 5 )
	inventory:SetSpaceX( 5 )
	
	scrapInventory.backpackSlots = {}
	
	-- Create the backpack
	for i = 1, 42 do -- 6x7 inventory
		local panel = vgui.Create("DPanel", inventory)
		panel:SetSize( 64, 64 )
		panel:SetCursor( "hand" )
		panel.Paint = function( self, w, h)
			surface.SetDrawColor( color_white )
			surface.DrawOutlinedRect( 0, 0, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 30, 30, 30, 200 ) )
		end
		panel:Receiver( "scrapIcon", function( pnl, item, drop, key, x, y )
			scrapInventory.backpackReceive( pnl, item, drop, key, x, y, panel, i )
		end)
		
		local selector = vgui.Create("DButton", panel )
		selector:SetPos( 0, 0 )
		selector:SetText("")
		selector:SetSize( panel:GetSize() )
		selector.Paint = function() end
		
		table.insert( scrapInventory.backpackSlots, {panel=panel, icon=icon, button=selector} )
	end
	
	--// Receives a dropped spawnicon on one of the backpack slots
	function scrapInventory.backpackReceive( pnl, item, drop, key, x, y, panel, i )
		if drop then
			local removingArmor = false
			
			local dropped = item[1]
			
			-- Get the table of spawnicon, dpanel, and button to match the dropped spawnicon
			local droppedData
			for k, v in pairs( scrapInventory.armorSlots ) do
				if v.icon == dropped then
					removingArmor = true
					print("Moving from armor slot to backpack "..k)
					droppedData = v
					v.icon:Remove()
				end
			end
			
			-- Try again in the backback
			if not droppedData then
				print("Moving from backpack to backpack")
				for k, v in pairs( scrapInventory.backpackSlots ) do
					if v.icon == dropped then
						droppedData = v
						v.icon:Remove()
					end
				end
			end
			
			-- Fallbacks
			if not droppedData then
				print("Unable to get droppedData")
				return
			end
			
			-- We are dropping on a slot without a spawn icon
			if not IsValid( scrapInventory.backpackSlots[i].icon ) then
				
				-- Get the data for the attachment
				local attachmentData 
				for k, v in pairs( scrapArmor.attachments ) do
					if v.mdl == droppedData.icon.mdl then
						attachmentData = v
					end
				end
				
				if not attachmentData then
					print("Unable to get attachmentData")
					return
				end
				
				-- Create a shiny new spawnicon
				local icon = vgui.Create("Spawnicon", panel)
				icon:SetModel( attachmentData.mdl )
				icon.mdl = attachmentData.mdl
				icon:Droppable( "scrapIcon" )
				icon:SetTooltip( attachmentData.name )
				
				local selector = vgui.Create("DButton", panel )
				selector:SetPos( 0, 0 )
				selector:SetText("")
				selector:SetSize( panel:GetSize() )
				selector.Paint = function() end
				selector:SetDragParent( icon )
			
				-- Add it to the table
				scrapInventory.backpackSlots[i].icon = icon
				scrapInventory.backpackSlots[i].button = selector
				
				if removingArmor then
					scrapArmor.removeByClass( attachmentData.class, client )
				end
			else
				scrapInventory.backpackSlots[i].icon:SetModel( attachmentData.mdl )
				scrapInventory.backpackSlots[i].icon.mdl = attachmentData.mdl
			end
		end
	end
	
	--// Receives a dropped spawnicon on one of the armor slots
	function scrapInventory.armorReceive( pnl, item, drop, key, x, y, panel, i )
		if drop then
			local dropped = item[1]
			
			-- Get the table of spawnicon, dpanel, and button to match the dropped spawnicon
			local droppedData
			for k, v in pairs( scrapInventory.armorSlots ) do
				if v.icon == dropped then
					print("Moving from armor to armor "..k)
					droppedData = v
					v.icon:Remove()
				end
			end
			
			-- Try again in the backback
			for k, v in pairs( scrapInventory.backpackSlots ) do
				if v.icon == dropped then
					print("Moving from backpack to armor")
					droppedData = v
					v.icon:Remove()
				end
			end
			
			-- Fallbacks
			if not droppedData then
				print("Unable to get droppedData")
				return
			end
			
			-- Get the data for the attachment
			local attachmentData 
			for k, v in pairs( scrapArmor.attachments ) do
				if v.mdl == droppedData.icon.mdl then
					attachmentData = v
				end
			end
			
			if not attachmentData then
				print("Unable to get attachmentData")
				return
			end
			
			-- We are dropping on a slot without a spawn icon
			if not IsValid( scrapInventory.armorSlots[i].icon ) then
				
				-- Create a shiny new spawnicon
				local icon = vgui.Create("Spawnicon", panel)
				icon:SetModel( attachmentData.mdl )
				icon.mdl = attachmentData.mdl
				icon:Droppable( "scrapIcon" )
				icon:SetTooltip( attachmentData.name )
				
				local selector = vgui.Create("DButton", panel )
				selector:SetPos( 0, 0 )
				selector:SetText("")
				selector:SetSize( panel:GetSize() )
				selector.Paint = function() end
				selector:SetDragParent( icon )
			
				-- Add it to the table
				scrapInventory.armorSlots[i].icon = icon
				scrapInventory.armorSlots[i].button = selector
				
				scrapArmor.add( attachmentData.class, client )
			else
				scrapInventory.armorSlots[i].icon:SetModel( attachmentData.mdl )
				scrapInventory.armorSlots[i].icon.mdl = attachmentData.mdl
			end
		end
	end
end

concommand.Add("inv", scrapInventory.buildCustomizeMenu)

--// Panel based blur function by Chessnut from NutScript
local blur = Material( "pp/blurscreen" )
function scrapInventory.blur( panel, layers, density, alpha )
	-- Its a scientifically proven fact that blur improves a script
	local x, y = panel:LocalToScreen(0, 0)

	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.SetMaterial( blur )

	for i = 1, 3 do
		blur:SetFloat( "$blur", ( i / layers ) * density )
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect( -x, -y, ScrW(), ScrH() )
	end
end
