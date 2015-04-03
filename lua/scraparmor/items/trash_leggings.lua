
ARMOR.name = "Trash Leggings"
ARMOR.tier = 1
ARMOR.health = 25
ARMOR.strength = 10
ARMOR.mdl = "models/props_junk/garbage_plasticbottle003a.mdl" 
ARMOR.bone = "ValveBiped.Bip01_R_Calf"
ARMOR.bone2 = 'ValveBiped.Bip01_L_Calf'
ARMOR.modifyModel = function( ply, model, pos, ang )
	local scale = Vector(1.5, 1.5, 1)

	local mat = Matrix()
	mat:Scale(scale)
	model:EnableMatrix("RenderMultiply", mat)
	
	ang:RotateAroundAxis( ang:Right(), 90 )
	ang:RotateAroundAxis( ang:Up(), -90 )
	
	local fwd = ply:GetForward()
	pos = pos - (ang:Right() * 1) - (ang:Up() * 2)
	
	return model, pos, ang
end
 