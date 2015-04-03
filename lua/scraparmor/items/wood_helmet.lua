
ARMOR.name = "Wood Helmet"
ARMOR.tier = 2
ARMOR.health = 35
ARMOR.strength = 35
ARMOR.mdl = "models/props_c17/FurnitureDrawer001a_Chunk02.mdl"
ARMOR.attachment = "eyes"
ARMOR.modifyModel = function( ply, model, pos, ang )
	local scale = Vector(0.4, 0.5, 1.1)

	local mat = Matrix()
	mat:Scale(scale)
	model:EnableMatrix("RenderMultiply", mat)
	
	ang:RotateAroundAxis(ang:Right(), 180)
	ang:RotateAroundAxis(ang:Up(), 180)
	
	pos = pos - (ang:Forward() * 2) + (ang:Up() * 1) - (ang:Right() * 5)
	
	return model, pos, ang
end
 