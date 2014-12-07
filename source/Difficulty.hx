package;



import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import flixel.ui.FlxButton;
import flixel.ui.FlxVirtualPad;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;


class Difficulty extends FlxSprite {


	
	
	public function new(X:Int, Y:Int){
		super(X, Y);
		
		loadGraphic("assets/images/difficulty.png", true, 200,64);
		
		animation.add("normal", [0]);
		animation.add("hard", [1]);
		animation.add("harder", [2]);
		set();
		
	}

	public function set() {
		switch(Reg.difficulty) {
			case 1:
				animation.play("normal");
			case 2:
				animation.play("hard");
			case 3:
				animation.play("harder");
				
		}

	}

	public function next() {
		Reg.difficulty = Reg.difficulty +1;
		if(Reg.difficulty >3)
			Reg.difficulty = 1;
		set();
	}

	public function previous() {
		Reg.difficulty = Reg.difficulty -1;
		if(Reg.difficulty <1)
			Reg.difficulty = 3;
		set();
	}
	

}