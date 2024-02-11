function looseWeapon() {
	// Loose weapon mechanich

	var char = argument[0];				// owner of this weapon
	if char.weapon != ""				// If Character had a weapon, loose it
	{
		var objItem = asset_get_index("oItem" + char.weapon);
		lostWeapon = instance_create_depth(x,y - sprite_height/2,depth - 1, objItem);
		lostWeapon.vx = 2*-char.facing;		// horizontal momentum for weapon
		lostWeapon.vy = -4;				// vertical momentum for weapon
		lostWeapon.dy = char.y;			// Set floor coord for weapon to fall 
		lostWeapon.onGround = false;	// Weapon will be launched into the air
		char.weapon = "";				// Player looses the weapon
		char.canPick = false;			// Can't pick items until pickstun ended
		char.alarm[7] = char.pickstun;	// pickstun duration
	}


}
