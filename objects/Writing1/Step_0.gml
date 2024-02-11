/// @description Insert description here
// You can write your code in this editor



if (_writingnum ==2){
	text_to_write = "My name is Alethea. I’ve brought you\n a mystery that I need uncovered.";
	type_out = "";
	i=1;
	spout();//alarm[0] = 1;
	
} else if (_writingnum ==3){
	text_to_write = "The mortals of the city have\n found themselves a fun new narcotic...";
	type_out = "";
	i=1;
	spout();//alarm[0] = 1;

}else if (_writingnum ==4){
	text_to_write = "Its code name is NECTAR, and it is the \ndrink of the gods... I mean that literally. \nI am the Goddess of Truth after all. ";
	type_out = "";
	i=1;
	spout();//alarm[0] = 1;

} else if (_writingnum ==5){
	text_to_write = "SOMEONE is either stealing it or has gotten \ntheir hands on Dionysus's old cookbook. Take my \nMagnifying Glass and find out who.";
	type_out = "";
	i=1;
	spout();
	//alarm[0] = 1;
	
} else if (_writingnum ==6){
	text_to_write = "I'm counting on you Des!";
	type_out = "";
	i=1;
	spout();
	//alarm[0] = 1;
	
}
else if (_writingnum ==7){
	room_goto(Room2Street);
}

function spout()
{
    type_out += string_char_at(text_to_write, i);
i +=1;
if ((i-1)!= string_length(text_to_write)) {
	spout();
	//alarm[0]=2;
}


}


