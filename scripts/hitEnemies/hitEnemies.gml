function hitEnemies() {
	addParticles(0, x + (sprite_width/2*parentId.facing), y + random_range(5,-5), 0, 0, 0.5*damage, c_white, 0.75, other.depth - 1, 1*damage, true, sHitParticle, 0, 0, true);		// Hit particles
	hitstun(5, other);							// Stun the oppnent for a few milliseconds
		
	if parentId.weapon != ""					// if Player hit with a weapon...
		weaponDurability(parentId)				// ...check its durability
			
	checkKnockback();							// Apply a knockback depending on the hit type
		
	if other.life > damage						// If Enemy has still enough life points...
	{
		other.chanceToRetreat+=10;				// Increase the retreatCounter
		if damage = 1							// If the hit box received is low damaging...
			other.state = other.HURT;			// ...go to HURT state
		else									// But if it is hard damaging (any value over 1)...
		{
			other.image_index = 0;
			other.state = other.KO;					// ...go to KO state
		}
	}
	else										// If it was the last impact the enemy could receive...
	{
		other.state = other.DEAD;				// ...go to DEAD state
		other.alarm[4]= room_speed*other.timeToDisapear;	// And start the alarm to make the enemy disapear after DEAD
	}
		
	other.facing = -parentId.facing;			// Enemy always looks to the opposite direction of Hit
	other.life -= damage;						// In both cases decrease Enemy's life points
	deformScale(0.9,1.1,other);					// Stretch sprite on Hit for better gameplay feel
	other.image_index = 0;						// and reset the animations index
		
	/// ------- Gameplay tweaks ---------------
	if !parentId.onGround							// If this hit box is from an air kick
		parentId.vx = parentId.vx/2;				// Slow down the Player advance when hit
		
	// Some advance trick for every Hit to improve gameplay
	if !position_meeting(parentId.x + 5*sign(parentId.facing), parentId.y, oParSolid)			// If Player won't collide with any solid wall
		parentId.x += 5*parentId.facing;						// Player advance slightly
	
	/// ------- Update enemy info -------------
	// If this enemy is been hit, show her Health bar info
	oParEnemy.showInfo = false;			// Hide any other enemys HealthBar
	other.showInfo = true;				// Show this HealthBar


}
