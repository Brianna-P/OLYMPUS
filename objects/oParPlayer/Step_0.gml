/// @description Movement, actions and states management
// ----- Movement ------
if state != DEAD
{
	checkInput();											// Check input controls (for keyboard and joypad). Except if Player is DEAD
	#region Movement										// This region manages movement
	if state = IDLE or state = RUN or state = JUMP			// Only accept moving input in these states
	{
		// Left 
		if (kLeft and !kRight)
		{
			facing = LEFT;                                  // Player looks to the left
			if (vx > 0)
			    vx = Approach(vx, 0, fric);					// Slide and brake if change direccion
			vx = Approach(vx, -maxVX, accel);				// Apply acceleration to get left speed
        
			if (onGround)
			    state = RUN;								// If onGround go to RUN state
			//++x_location;
			//if(x_location >200){
			//	room_goto(Room3Helipad);
			//}
		}
		

		// Right 
		if (kRight and !kLeft)
		{
			facing = RIGHT;                                 // Player looks to the right
			if (vx < 0)
			    vx = Approach(vx, 0, fric);					// Slide and brake if change direccion
			vx = Approach(vx, maxVX, accel);				// Apply acceleration to get right speed
        
			if (onGround)
			    state = RUN;                                // If onGround go to RUN state
		}
		// Down 
		if (kDown and !kUp)
		{
			if (vy > 0)
			    vy = Approach(vy, 0, fric);					// Slide and brake if change direccion
			vy = Approach(vy, maxVY, accel);				// Apply acceleration to get down speed
        
			if (onGround)
			    state = RUN;								// If onGround go to RUN state
		}

		// Up 
		if (kUp and !kDown)
		{
			if (vy < 0)
			    vy = Approach(vy, 0, fric);					// Slide and brake if change direccion
			vy = Approach(vy, -maxVY, accel);				// Apply acceleration to get up speed
        
			if (onGround)
			    state = RUN;								// If onGround go to RUN state
		}
	}
	#endregion
}
	#region Gravity											// This region manages gravity
	if (!onGround){
		if state = IDLE or state = RUN
			state = JUMP;
		// Make player fall
		if (vz < 0)
		{
			vz = Approach(vz, 0, gravRise);					// Gravity on rise
		}
		else
		{
			vz = Approach(vz, maxVZ, gravFall);				// Gravity on fall
		}
	}
	#endregion
#region Resets and No Inputs
// No moving inputs
if (!kRight and !kLeft) or (kRight and kLeft)
    vx = Approach(vx, 0, fric);								// Slide and brake when not moving or when pressing oposite inputs at the same time
if (!kDown and !kUp) or (kDown and kUp)
    vy = Approach(vy, 0, fric);								// Slide and brake when not moving or when pressing oposite inputs at the same time
// Reset grab if no near collisions
if (!grabRight and !grabLeft) and weapon = ""
{
	grabbedId = -1;
	canGrab = true;
}
#endregion
// ---------------------

// ----- Actions -------
if (kHit1)													// If Player got a kHit1/action input
{
	#region Grab											// Can Grab if combines with a directional input
	if ((kHit1 and grabRight and kRight) or (kHit1 and grabLeft and kLeft))					// If ActionButton + DirectionButton when colliding whith an enemy...
	and (state != JUMP and weapon = "") 						// Can't grab while in Jump neither with a weapon
	{
		if canGrab												// ..and Player is not grabbing anything...
		{
			grabbedId = instance_position(x + facing, y, oParEnemy);	// ..get the Id of the opponent to grab...
			if instance_exists(grabbedId)
			{
				if grabbedId.grabbable										// ..and check if its grabbable. If it is...
				and abs(grabbedId.depth - depth) <= EnemyLayerSize 
				and abs(grabbedId.y - y) <= EnemyLayerSize					// Check if Player and Opponent are in the depth and Y range to receive hit
				and grabbedId.state = grabbedId.IDLE or grabbedId.state = grabbedId.RUN or grabbedId.state = grabbedId.WAIT or grabbedId.state = grabbedId.RETREAT	// Check that opponent is in an available state					// Check that opponent is out of HIT state
				{
					state = GRAB;											// ..GRAB it/him/her!
					canGrab = false;										// Can't grab anything more while grabbing
					vx = 0;													// Can't move either
					vy = 0;
					grabbedId.state = grabbedId.GRABBED;					// Set the opponent state to GRABBED
					grabbedId.grabbed = true;
					grabbedId.grabberId = id;					// Pass to the opponent which instance is grabbing him/her
					grabbedId.x = x + sprite_width/2;			// And reposition it/him/her to adapt to the animation
					oParEnemy.showInfo = false;					// Hide any other enemys HealthBar
					grabbedId.showInfo = true;					// Show the grabbed opponent HealthBar
				}
				else hitAction();
			}
		}
	}
	#endregion
	#region Pick											// Can Pick if its over an item
	else if place_meeting(x,y,oParItem)						// If is colliding with an item
	and canGrab
	{
		myItem = instance_place(x,y,oParItem);
		myItem.owner = id;
		if myItem.onGround									// Only items onGround can be pickable
		{
			hitCounter = 0;									// If we pick, reset the HITHARD counter
			image_index = 0;
			state = PICK;
			canHit = false;									// Can't hit while picking an object
			canGrab = false;
			vx = 0;
			vy = 0;
		}
	}
	#endregion
	#region Hit												// Can Hit. Three types of hits can be made: punch (HIT1 state), air kick (HIT1 state when on air) and hard punch (HITHARD state)
	else if canHit											// If there aren't items to pick and the hit flag is false...
	{
		hitAction();
	}
	#endregion
}
/**
#region Special Move										// If Player got a Special Move Input
if (kHitSp)
{
	if life > 1	// Can't do a Special move if Player has not more than 1 life point
	{
		if canHit and onGround
		{
			image_index = 0;									// Reset the animation for every hit
			state = SPECIAL;									// Go to SPECIAL state
			hitCounter = 0;										// Reset hitCounter
			damage = 3;
			life -= 1;											// Using Special move drains Player life!
		}
	}
}
#endregion
*/
#region Throw												// If Player got a directional input while grabbing
if grabbedId != -1 and state = GRAB								// Check if Player is grabbing something
{
	if (kRightOnce and facing = LEFT) or (kLeftOnce and facing = RIGHT)	// And if inputs in the opposite direction of Grab...
	{
		grabbedId.thrown = true;								// Throw grabbed opponent!
		facing = kRightOnce - kLeftOnce;					// Face the opposite direction of GRAB (because of the thrown pose!)
		grabbedId.vx = throwForce*facing;					// Throw according the throwForce
		grabbedId.image_index = 0;
		grabbedId.state = grabbedId.KO;						// Set opponent state to KO (there will manage if this KO is because a thrown or other hits)
		grabbedId.koType = "Thrown";						// Set which type of KO animation will play
		grabbedId = -1;										// Player isn't grabbing anyone
		state = THROW;										// Put Player in THROW (to play THROW animation)				
	}
}
#endregion
#region Jump												// If Player got a Jump input
if (kJump and onGround)										// If jump and touching ground..
and (state = RUN or state = IDLE)							// ..and Player is in an state permitted to jump...
{
	onGround = false;
    vz = -jumpHeight;										// ..give jump momentum to player..
    state = JUMP;											// ..and show jump animation
	hitCounter = 0;											// If we jump, reset the HITHARD counter
	deformScale(0.8,1.2,id);								// Stretch sprite on Jump for better gameplay feel
} 
#endregion
// ----------------------

// ----- States ---------
#region states												// This region manages all Player states and animations
switch (state) 
{
    case IDLE:
        image_speed = global.animFPS/2*hitstuned;										// We set the animations speed relative to the game fps
        sprite_index = asset_get_index("sPlayer" + playerId + "Idle" + weapon);			// asset_get_index() can load an sprite from an string. So here we play the sprite animation sPlayer1Idle (or sPlayer1Idle, depending on playerId)
    break;
    
    case RUN: 
        image_speed = global.animFPS/2*hitstuned; 
        sprite_index = asset_get_index("sPlayer" + playerId + "Run" + weapon);
    break;
	
	case HIT1:
		var xPos = x + (sprite_get_width(sHitBox)/2)*facing;
		var yPos = y + z - (sprite_height/2 + 5);
		if onGround && sprite_index != asset_get_index("sPlayer" + playerId + "Hit1")							// If HIT was onGround, we play the punch animations
		{
			image_speed = global.animFPS*hitstuned;
			sprite_index = asset_get_index("sPlayer" + playerId + "Hit1");		//  + string((hitCounter mod 2)+1) Alternate between sPlayer1Hit1 and sPlayer1Hit2, for consecutive hits.
			if image_index = 1 and canHit																		// At frame 1, begins the active phase to Hit
			{
				punch = instance_create_depth(xPos,yPos,depth,oPlayerHitBox);									// Create the punch Hit box
				punch.parentId = id;																			// and store the Player instance id in de Hit box instance to know who made that hit
				punch.damage = damage;																			// Determines the damage that the hit box will make to enemies
				canHit = false;																					// Disable chance to Hit
				alarm[0] = hit1lag;																				// Hit lag
			}
		}
		else																									// If HIT was on air, we play the air kick animation
		{
			image_speed = global.animFPS*hitstuned;
			sprite_index = asset_get_index("sPlayer" + playerId + "Hit1");
			if image_index = 2 and canHit																		// From frame 2, begins the active phase to Hit
			{
				kick = instance_create_depth(xPos,yPos + 40,depth,oPlayerHitBox);								// Create the air kick Hit box
				kick.parentId = id;																				// and store the Player instance id in de Hit box instance to know who made that hit
				kick.image_yscale = 1.5;
				kick.damage = damage*2;																			// Determines the damage that the hit box will make to enemies
				canHit = false;																					// Disable chance to Hit
				alarm[0] = hithardlag;																			// Hit lag time
			}
		}
		
		if image_index > image_number-1																			// Once the animation ends, Player goes directly to IDLE state
		{
			image_speed = 0;																					// Stop Anim to the last frame
			if onGround																							// To avoid bad sprite animation while in the air, go back to IDLE/GRAB only when onGround
			{
				if grabbedId = -1													// If Player isn't grabbing anyone, Player can go to IDLE
					state = IDLE;
				else					 											// else means that Player was grabbing someone/thing and go back to GRAB
					state = GRAB;
			}
		}
    break;
	/**
	case HITHARD:
		var xPos = x + (sprite_get_width(sHitBox)/2)*facing;
		var yPos = y + z - (sprite_height/2 + 5);
		
		image_speed = global.animFPS*hitstuned;
		sprite_index = asset_get_index("sPlayer" + playerId + "Hit3");
		
		if image_index = 1 and canHit							// From frame 1, begins the active phase to Hit
		{
			punch = instance_create_depth(xPos,yPos,depth,oPlayerHitBox);		// Create the punch Hit box
			punch.parentId = id;																									// and store the Player instance id in de Hit box instance to know who made that hit
			punch.damage = damage;												// Determines the damage that the hit box will make to enemies
			canHit = false;														// Disable chance to Hit
			alarm[0] = hithardlag;												// Hit lag time
		}
		
		if image_index > image_number-1											// Once the animations end, Player goes directly to IDLE state
		{
            image_speed = 0;												
			state = IDLE;
		}
    break;
	*/
	
	case SPECIAL:
		var xPos = x;
		var yPos = y;
		
		image_speed = global.animFPS*hitstuned;
		sprite_index = asset_get_index("sPlayer" + playerId + "Special");
		
		if image_index = 2 and canHit							// From frame 1, begins the active phase to Hit
		{
			special = instance_create_depth(xPos,yPos,depth,oScalingHitBox);	// Create the punch Hit box
			special.parentId = id;												// and store the Player instance id in de Hit box instance to know who made that hit
			special.damage = damage;											// Determines the damage that the hit box will make to enemies
			special.endXscale = 5.25;											// Set how much will scale in X
			special.endYscale = 7;												// Set how much will scale in Y
			special.scaleSpdX = 0.25;											// Set the X scaling speed
			special.scaleSpdY = 0.35;											// Set the Y scaling speed
			special.alarm[0] = 30;												// Set how much time will the hitbox exist
			canHit = false;														// Disable chance to Hit
			alarm[0] = hithardlag;												// Hit lag time
		}
		
		if image_index > image_number-1											// Once the animations end, Player goes directly to IDLE state
		{
            image_speed = 0;												
			state = IDLE;
		}
    break;
	
	case THROWWEAPON:
		var xPos = x + (sprite_get_width(sHitBox)/2 + 14)*facing;
		var yPos = y - sprite_get_height(sHitBox)/2 + z;
		
		image_speed = global.animFPS*hitstuned;
		sprite_index = asset_get_index("sPlayer" + playerId + "Throw" + weapon);
		
		if image_index = 2 and canHit							// From frame 1, begins the active phase to Hit
		{
			projectile = instance_create_depth(xPos,yPos,depth - 1,oMovingHitBox);								// Create the weapon projectile Hit box
			projectile.parentId = id;																			// and store the Player instance id in de Hit box instance to know who made that hit
			projectile.damage = damage;																			// Determines the damage that the hit box will make to enemies
			projectile.fakeYDisp = sprite_height/2;																// Displacement between projectile sprite and its hit box
			projectile.weaponSprite = asset_get_index("s" + weapon);
			projectile.image_yscale = sprite_get_height(asset_get_index("s" + weapon))/sprite_get_height(sHitBox);
			projectile.spd = 4*facing;
			canHit = false;																						// Disable chance to Hit
			alarm[0] = hitweaponlag;																			// Hit lag time
		}
		
		if image_index > image_number-1																		// Once the animations end, Player goes directly to IDLE state
		{											
			weapon = "";				// ..came back to animations without weapon
            image_speed = 0;
			state = IDLE;
		}
    break;
	
	case HITWEAPON:
		var xPos = x + (sprite_get_width(sHitBox)/2 + 14)*facing;
		var yPos = y + z - (sprite_height/2 - 10);
		
		image_speed = global.animFPS*hitstuned;
		sprite_index = asset_get_index("sPlayer" + playerId + "Hit" + weapon);
		
		if image_index = 1 and canHit							// From frame 1, begins the active phase to Hit
		{
			punch = instance_create_depth(xPos,yPos,depth - 1,oPlayerHitBox);		// Create the punch Hit box
			punch.image_xscale = 1.8;
			punch.image_yscale = 2.5;
			punch.parentId = id;																			// and store the Player instance id in de Hit box instance to know who made that hit
			punch.damage = damage;																			// Determines the damage that the hit box will make to enemies
			canHit = false;																					// Disable chance to Hit
			alarm[0] = hitweaponlag;																		// Hit lag time
		}
		
		if image_index > image_number-1																		// Once the animations end, Player goes directly to IDLE state
		{
			if wResistance <= 0				// If weapon broke...												
				weapon = "";				// ..came back to animations without weapon
            image_speed = 0;
			state = IDLE;
		}
    break;
    /**
    case JUMP:
        image_speed = global.animFPS*hitstuned; 
        // Jump and fall
        if (vz <= 0)																							// JUMP has two diferent animations
            sprite_index = asset_get_index("sPlayer" + playerId + "Jump" + weapon);										// The rising up animation...
        else
            sprite_index = asset_get_index("sPlayer" + playerId + "Fall" + weapon);										// ...and the falling one
            
        if image_index > image_number-1																			// Once the animations end, Player goes directly to IDLE state
            image_speed = 0;
    break;
	*/
	case PICK:
        image_speed = global.animFPS*hitstuned; 
        sprite_index = asset_get_index("sPlayer" + playerId + "Pick" + weapon);									// The rising up animation...
		
		// Pick the item or replace the one we got by the new one
		#region pick and/or replace			
		if image_index = 2			// At the right frame start picking
		{
			if weapon != "" and myItem.weaponName != ""										// If we already had a weapon and the item to pick is a weapon, we will replace them
				instance_create_depth(x,y,depth-1, asset_get_index("oItem" + weapon))		// ..and place a new object of this weapon 
			// Now pick the new item
			if myItem.weaponName != ""								// If the item is a weapon get its properties
			{
				weapon = myItem.weaponName;							// ..start playing Player animations with that weapon...
				weaponType = myItem.type;							// ..get weapon type. Can be "fixed" or "thrown"
				weaponId = myItem;									// ..get its Id
				damage = myItem.damage;								// ..get its damage..
				wResistance = myItem.resistance;					// ..and get its resistance
			}
			with(myItem)											// Finally destroy the item object in the floor. We already have it!
				instance_destroy();
		}
		#endregion
		
        if image_index > image_number-1																			// Once the animations end, Player goes directly to IDLE state
		{
			canHit = true;
			state = IDLE;
            image_speed = 0;
		}
    break;
	case HURT: 
        image_speed = global.animFPS*hitstuned; 
        sprite_index = asset_get_index("sPlayer" + playerId + "Hurt" + weapon);
		canHit = true;
		if image_index > image_number-1										// Once the animations end, Player goes directly to IDLE state
		{
            image_speed = 0;
			state = IDLE;
		}
    break;
	case GRAB: 
        image_speed = global.animFPS*hitstuned; 
        sprite_index = asset_get_index("sPlayer" + playerId + "Grab");
		if image_index > image_number-1										// Once the animations end, Player goes directly to IDLE state
            image_speed = 0;
    break;
	case THROW: 
        image_speed = global.animFPS/2*hitstuned; 
        sprite_index = asset_get_index("sPlayer" + playerId + "Throw");
		if image_index > image_number-1										// Once the animations end, Player goes directly to IDLE state
		{
			canHit = true;
            image_speed = 0;
			state = IDLE;
		}
    break;
	case DEAD:
		image_speed = global.animFPS*hitstuned; 
        sprite_index = asset_get_index("sPlayer" + playerId + "Die" + weapon);
		if image_index > image_number-1										// Once the animations end, destroy the Player instance (would mean Game Over)
		{
            image_speed = 0;
			instance_destroy();
		}
    break;
}
#endregion
// ----------------------

#region Raycast for shadow shecks
// For properly place player shadow
if(ds_exists(ray, ds_type_map))
	ds_map_destroy(ray);
ray = ray_cast([x, y + z], 270, oParPlatform, false, true, camera_get_view_height(cam));
#endregion