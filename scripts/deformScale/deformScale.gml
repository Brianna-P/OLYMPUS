/// @desc Deform sprite scale
/// @arg {integer} stretchValue
/// @arg {integer} squashValue
/// @arg {float} instanceId
function deformScale(argument0, argument1, argument2) {

	// Useful to generate a bouncing effect on situations like jump or ground but others too
	var char = argument2;

	char.xScale = argument0;
	char.yScale = argument1;


}
