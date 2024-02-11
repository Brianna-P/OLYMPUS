function checkInput() {
	// Note that this script works with keyborad and pad inputs
	// You can customize it if you wish.
	// Input control vars
	if real(playerId) = 1
	{
		kLeft        = keyboard_check(vk_left);
		kRight       = keyboard_check(vk_right);
		kLeftOnce	 = keyboard_check_pressed(vk_left);
		kRightOnce	 = keyboard_check_pressed(vk_right);
		kDown		 = keyboard_check(vk_down);
		kUp			 = keyboard_check(vk_up);
		kHit1		 = keyboard_check_pressed(ord("D"));
		kHitSp		 = keyboard_check_pressed(ord("A"));
		kJumpIn      = keyboard_check(ord("S"));
		kJump        = keyboard_check_pressed(ord("S"));
		kJumpRelease = keyboard_check_released(ord("S"));
	}

	if real(playerId) = 2
	{		
		kLeft        = gamepad_axis_value(0, gp_axislh) < -0.40 or gamepad_button_check(0, gp_padl);
		kRight       = gamepad_axis_value(0, gp_axislh) >  0.40 or gamepad_button_check(0, gp_padr);
		kLeftOnce	 = (gamepad_axis_value(0, gp_axislh) < -0.40 and !onceStick) or gamepad_button_check_pressed(0, gp_padl);
		kRightOnce	 = (gamepad_axis_value(0, gp_axislh) > 0.40 and !onceStick) or gamepad_button_check_pressed(0, gp_padr);
		kDown		 = gamepad_axis_value(0, gp_axislv) >  0.40 or gamepad_button_check(0, gp_padd);
		kUp			 = gamepad_axis_value(0, gp_axislv) <  -0.40 or gamepad_button_check(0, gp_padu);
		kHit1		 = gamepad_button_check_pressed(0, gp_face3);
		kHitSp		 = gamepad_button_check_pressed(0, gp_face4);
		kJumpIn      = gamepad_button_check(0, gp_face1);
		kJump        = gamepad_button_check_pressed(0, gp_face1);
		kJumpRelease = gamepad_button_check_released(0, gp_face1);
	
		// onceStick is used to manage analogic sticks directions as a check_pressed and not as continuous check
		if kLeftOnce or kRightOnce
			onceStick = true;
	
		if onceStick and (gamepad_axis_value(0, gp_axislh) > -0.40 and gamepad_axis_value(0, gp_axislh) < 0.40)
			onceStick = false;	
	}



}
