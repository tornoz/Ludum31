package;



import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import flixel.ui.FlxButton;
import flixel.ui.FlxVirtualPad;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;


class Star extends FlxSprite {


	
	
	public function new(X:Int, Y:Int){
		super(X, Y);
		
		loadGraphic("assets/images/star.png", true, 64, 64);
		
		animation.add("idle", [0]);
		animation.add("active",[1]);
		animation.play("idle");
	}

	
	override public function update():Void {
	
	    
		super.update();
	}

}