
ARMOR.name = "Wood Leggings"
ARMOR.tier = 2
ARMOR.health = 45
ARMOR.strength = 30
ARMOR.mdl = "models/props_c17/FurnitureDrawer003a.mdl" 
ARMOR.bone = "ValveBiped.Bip01_R_Calf"
ARMOR.bone2 = 'ValveBiped.Bip01_L_Calf'
ARMOR.modifyModel = function( ply, model, pos, ang )
	local scale = Vector(1.1, 1, 0.6)

	local mat = Matrix()
	mat:Scale(scale)
	model:EnableMatrix("RenderMultiply", mat)
	
	ang:RotateAroundAxis( ang:Right(), 90 )
	ang:RotateAroundAxis( ang:Up(), -90 )
	
	local fwd = ply:GetForward()
	pos = pos - (ang:Forward() * 2) - (ang:Up() * 2)
	
	return model, pos, ang
end
 