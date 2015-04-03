
ARMOR.name = "Wood Chestplate"
ARMOR.tier = 2
ARMOR.health = 55
ARMOR.strength = 45
ARMOR.mdl = "models/props_c17/woodbarrel001.mdl"
ARMOR.bone = "ValveBiped.Bip01_Spine2"
ARMOR.modifyModel = function( ply, model, pos, ang )
	local scale = Vector(0.8, 0.8, 0.7)

	local mat = Matrix()
	mat:Scale(scale)
	model:EnableMatrix("RenderMultiply", mat)
	
	ang:RotateAroundAxis( ang:Right(), 90 )
	
	local fwd = ply:GetForward()
	pos = pos - (ang:Right() * 3) - (ang:Up() * 13)
	
	return model, pos, ang
end
 