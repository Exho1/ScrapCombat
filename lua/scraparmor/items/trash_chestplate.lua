
ARMOR.name = "Trash Chestplate"
ARMOR.tier = 1
ARMOR.health = 35
ARMOR.strength = 25
ARMOR.mdl = "models/props_trainstation/trashcan_indoor001b.mdl"
ARMOR.bone = "ValveBiped.Bip01_Spine2"
ARMOR.modifyModel = function( ply, model, pos, ang )
	local scale = Vector(0.9, 0.9, 0.7)

	local mat = Matrix()
	mat:Scale(scale)
	model:EnableMatrix("RenderMultiply", mat)
	
	ang:RotateAroundAxis(ang:Right(), 90)
	
	local fwd = ply:GetForward()
	pos = pos - (ang:Right() * 3) + (ang:Up() * 1)
	
	return model, pos, ang
end
 