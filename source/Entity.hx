package;

import flixel.FlxSprite;

class Entity extends FlxSprite {

	public function new(x:Int, y:Int) {
		super(Reg.CELL * x, Reg.CELL * y);
	}

}