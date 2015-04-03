
ARMOR.name = "Metal Leggings"
ARMOR.tier = 2
ARMOR.health = 65
ARMOR.strength = 50
ARMOR.mdl = "models/props_wasteland/laundry_basket001.mdl" 
ARMOR.bone = "ValveBiped.Bip01_R_Calf"
ARMOR.bone2 = 'ValveBiped.Bip01_L_Calf'
ARMOR.modifyModel = function( ply, model, pos, ang )
	local scale = Vector(0.2, 0.3, 0.5)

	local mat = Matrix()
	mat:Scale(scale)
	model:EnableMatrix("RenderMultiply", mat)
	
	ang:RotateAroundAxis( ang:Right(), 90 )
	
	local fwd = ply:GetForward()
	pos = pos - (ang:Up() * 5)
	
	return model, pos, ang
end
 