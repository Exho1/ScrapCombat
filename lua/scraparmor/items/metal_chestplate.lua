
ARMOR.name = "Metal Chestplate"
ARMOR.tier = 3
ARMOR.health = 75
ARMOR.strength = 65
ARMOR.mdl = "models/props_c17/oildrum001.mdl" 
ARMOR.bone = "ValveBiped.Bip01_Spine2"

ARMOR.modifyModel = function( ply, model, pos, ang )
	local scale = Vector(0.8, 0.8, 0.6)

	local mat = Matrix()
	mat:Scale(scale)
	model:EnableMatrix("RenderMultiply", mat)
	
	ang:RotateAroundAxis( ang:Right(), 90 )
	
	local fwd = ply:GetForward()
	pos = pos - (ang:Right() * 3) - (ang:Up() * 12)
	
	return model, pos, ang
end

 