/// @description Read me and Game inits
#region Readme
// Hello and thanks for buying this asset, I'm glad it caught your interest!
// You've acquired a work in progress Engine to get the basics of Beat'em Up (BeU) fighting 
// and movement mechanics, which should help you to develop a BeU fighter with a wide variety 
// of animations

// You will see also a basic enemy behaviours and tweak its properties at your wish.
// The purpose of this asset is to help getting contact with how BeU games work but it doesn't 
// pretend to tell you HOW you should make a game like this. BeUs are quite complex games to 
// develop and there are lot of ways to manage hit and movement collisions and states machines 
// aswell. This is one of this ways which I hope, helps you to understand BeU mechanichs!
// In the future I'll try to upgrade this asset with more BeU gameplay, starting from adding a 
// sidescroller camera and more as I got time to work on it.

// Last but not less important, this code is a result of my learning from other GMStudio 
// gamedevs as Matt Thorson (Towerfall), Zack Bell (INK) and Andrew "NAL" McCluskey so I
// give them credits too!

// Finally don't hesitate to ask anything on https://twitter.com/CurialLloses !
#endregion

randomize();

// Globals
global.DebugGUIOn = false;
global.InfoGUIOn = false;
global.animFPS = 20 / game_get_speed(gamespeed_fps);		// Set the base animation speed for every sprite animation

global.friendlyFire = false;								// Set friendlyFire flag. Will check if Players can hit each other
global.sleepScale = 1;
global.sleepAcc = 1;
// Battle Zones vars
inBattleArea = false;
lastBattleAreaX = 0;
lastBattleAreaWidth = 0;

// Check Win/Loose and Go!conditions
letsGo = false;
playersFromStart = instance_exists(oParPlayer);				// Check that there are Player/s from the beggining for a better Loose condition
continueMsg = false;
gameOver = false;											// Will activate if CONTINUE timer reaches zero