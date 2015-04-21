scrapInventory = {}

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
	
	local frame = vgui.Create("DFrame")
	frame:SetSize( 800, 600 )
	frame:SetTitle("")
	frame:ShowCloseButton( true )
	frame:SetDraggable( false )
	frame:SetPos( ScrW()/2 - (frame:GetWide()/2), ScrH()/2 - (frame:GetTall()/2))
	frame.Paint = function( self, w, h )
		scrapInventory.blur( self, 10, 20, 255 )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 30, 30, 30, 200 ) )
		draw.RoundedBox( 0, 0, 0, w, 25, Color( 80, 80, 80, 100 ) )
	end
	frame:MakePopup()
	
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
	
	-- Draw the armor onto the entity
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
		
		scrapInventory.armorSlots[index].icon = icon
		scrapInventory.armorSlots[index].button = selector
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
	
	for i = 1, 42 do -- 6x7 inventory
		local pnl = vgui.Create("DPanel", inventory)
		pnl:SetSize( 64, 64 )
		pnl:SetCursor( "hand" )
		pnl.Paint = function( self, w, h)
			surface.SetDrawColor( color_white )
			surface.DrawOutlinedRect( 0, 0, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 30, 30, 30, 200 ) )
		end
		pnl:Receiver( "scrapIcon", function( pnl, item, drop, key, x, y ) 
			if drop then
				local dropped = item[1]
				
				-- Get the table of spawnicon, dpanel, and button to match the dropped spawnicon
				local droppedData
				for k, v in pairs( scrapInventory.armorSlots ) do
					if v.icon == dropped then
						droppedData = v
						v.icon:Remove()
					end
				end
				
				-- Try again in the backback
				if not droppedData then
					for k, v in pairs( scrapInventory.backpackSlots ) do
						if v.icon == dropped then
							droppedData = v
							v.icon:Remove()
						end
					end
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
					
					-- Fallbacks
					if not droppedData then
						print("Unable to get droppedData")
						return
					end
					
					if not attachmentData then
						print("Unable to get attachmentData")
						return
					end
					
					-- Create a shiny new spawnicon
					local icon = vgui.Create("Spawnicon", pnl)
					icon:SetModel( attachmentData.mdl )
					icon.mdl = attachmentData.mdl
					icon:Droppable( "scrapIcon" )
					icon:SetTooltip( attachmentData.name )
					
					local selector = vgui.Create("DButton", pnl )
					selector:SetPos( 0, 0 )
					selector:SetText("")
					selector:SetSize( pnl:GetSize() )
					selector.Paint = function() end
					selector:SetDragParent( icon )
				
					-- Add it to the table
					scrapInventory.backpackSlots[i].icon = icon
					scrapInventory.backpackSlots[i].button = selector
				else
					scrapInventory.backpackSlots[i].icon:SetModel( attachmentData.mdl )
					scrapInventory.backpackSlots[i].icon.mdl = attachmentData.mdl
				end
			end
		end)
		
		--local icon = vgui.Create("Spawnicon", pnl)
		--icon:SetModel( "models/props_junk/food_pile03.mdl" )
		--icon:Droppable( "scrapIcon" )
		--icon:SetTooltip( data.name )
		
		local selector = vgui.Create("DButton", pnl )
		selector:SetPos( 0, 0 )
		selector:SetText("")
		selector:SetSize( pnl:GetSize() )
		selector.Paint = function() end
		--selector:SetDragParent( icon )
		
		table.insert( scrapInventory.backpackSlots, {panel=pnl, icon=icon, button=selector} )
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
