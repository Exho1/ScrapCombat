
ARMOR.name = "Metal Helmet"
ARMOR.tier = 3
ARMOR.health = 55
ARMOR.strength = 55
ARMOR.mdl = "models/props_interiors/pot02a.mdl"
ARMOR.attachment = "eyes"
ARMOR.modifyModel = function( ply, model, pos, ang )
	local scale = Vector(1.2, 1.2, 1.2)

	local mat = Matrix()
	mat:Scale(scale)
	model:EnableMatrix("RenderMultiply", mat)
	
	ang:RotateAroundAxis(ang:Right(), 180)
	
	pos = pos - (ang:Forward() * -3) - (ang:Up() * 2) + (ang:Right() * 7)
	
	return model, pos, ang
end
