
ARMOR.name = "Trash Helmet"
ARMOR.tier = 1
ARMOR.health = 20
ARMOR.strength = 15
ARMOR.mdl = "models/props_c17/lampShade001a.mdl"
ARMOR.attachment = "eyes"
ARMOR.modifyModel = function( ply, model, pos, ang )
	local scale = Vector(1.1, 1.1, 1.1)

	local mat = Matrix()
	mat:Scale(scale)
	model:EnableMatrix("RenderMultiply", mat)
	
	ang:RotateAroundAxis(ang:Right(), 180)
	
	pos = pos - (ang:Forward() * -3) - (ang:Up() * 7) 
	
	return model, pos, ang
end
 