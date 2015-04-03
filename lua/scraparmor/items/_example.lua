ARMOR.name = "Armor Name" -- Print name of the armor
ARMOR.tier = 1 -- Which tier of armor is it, 1 is lowest
ARMOR.health = 100 -- How much health does this piece of armor have
ARMOR.strength = 50 -- How much damage this armor reduces (100 is invincible)
ARMOR.mdl = "models/props_c17/oildrum001.mdl" -- Path to the model
ARMOR.bone = "ValveBiped.Bip01_Spine2" -- Bone that this armor is attached to
ARMOR.bone2 = nil -- Second bone to attach another model of this armor to if needed
ARMOR.attachment = nil -- (Used instead of bones) Attachment point to attach armor to

ARMOR.modifyModel = function( ply, model, pos, ang )
	-- Ply is the player who's armor is being modified
	-- Model is the actual clientside model
	-- Pos is the bone or attachment position 
	-- Ang is the bone or attachment angle
	return model, pos, ang
end
