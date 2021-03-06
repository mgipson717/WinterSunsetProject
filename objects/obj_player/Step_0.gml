if (global.playerHealth == 0) {
	if (!audio_is_playing(snd_mauriceDeath)){
		audio_play_sound(snd_mauriceDeath, 20, false);
	}
	instance_destroy();
	room_goto(rm_gameOver);
}

if ( global.talking == 14 ){
	instance_destroy(obj_queen);
	instance_destroy();
	room_goto(rm_youWin);
}

if (global.pause || global.view)
{
	image_speed = 0;
	exit;
}

//Get player inputs (ord("A")) lets u use input of other letters 
key_left = keyboard_check(vk_left) or (keyboard_check(ord("A")));
key_right = keyboard_check(vk_right) or (keyboard_check(ord("D")));

key_jump = keyboard_check_pressed(vk_space);
key_attack = keyboard_check_pressed(ord("E"));
key_crouching = keyboard_check(ord("H"));

//Calculate movement
var _move = key_right - key_left;

hsp = _move * walksp;

vsp += grv;

//if player is touching the floor
meetsFloor = place_meeting(x,y+1,obj_floor);

//jumping
if (meetsFloor && (key_jump)){
	vsp = -jumpsp;
}

move();
hide();

audio_sound_pitch(snd_walk, 0.6);

if (key_right && meetsFloor) {
	if (!audio_is_playing(snd_walk)){
		audio_play_sound(snd_walk, 20, false);
	}
}else if (key_left && meetsFloor){
	if (!audio_is_playing(snd_walk)){
		audio_play_sound(snd_walk, 20, false);
	}
}

if (key_right){
	lookRight = true;
}
if (key_left) {
	lookRight = false;
}

//Change direction, walk and jump
if(meetsFloor){
	if (lookRight) {
		sprite_index = spr_walkRight;
		image_speed = 1;
	}
	else {
		sprite_index = spr_walkLeft;
		image_speed = 1;
	}
}
else if (!meetsFloor) {
	if (!lookRight){
		sprite_index = spr_jumpLeft;
	} else{
		sprite_index = spr_jump;
	}
}

if (!(key_left || key_right)){
	image_index = 0;
	image_speed = 0;
}

if (global.crouching) {
	if (!(key_left || key_right)) {
		if (lookRight) {
			sprite_index = spr_crouchRight;
		}
		else {
			sprite_index = spr_crouchLeft;
		}
	}
}

if ((place_meeting(x,y, obj_monster) || place_meeting(x,y, obj_trainingDummy) || (place_meeting(x,y, obj_baxter) && global.princeFight))  && key_attack) {
	if (!audio_is_playing(snd_atk)){
		audio_play_sound(snd_atk, 20, false);
	}
	if (lookRight){
		sprite_index = spr_atkRight;
		image_speed = 1;
	}
	else {
		sprite_index = spr_atkLeft;
		image_speed = 1;
	}
}

if(hasQueen){
	jumpsp = 0;
	walksp = 5;
	grv = 0.6;
	if (room == rm_escaped) {
		global.escaped = true;
	}
}

if (fallingXY) {
	playerX = obj_player.x;
	playerY = obj_player.y;
	fallingXY = false;
}

if (pitTimeStart) {
	if (pitTime <= 0){
		pitTime = 0;
	}
	else {
		pitTime -= delta_time/1000000;
	}
}

if (pitTime == 0) {
	pitTimeStart = false;
	obj_player.x = playerX - 400;
	obj_player.y = playerY - 460;
	global.playerHealth -=1;
	pitTime = 1.4;
}