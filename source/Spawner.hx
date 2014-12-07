package;



import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import flixel.ui.FlxButton;
import flixel.ui.FlxVirtualPad;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;


class Spawner extends FlxSprite {


	
	
	public function new(X:Int, Y:Int, width:Int, height:Int){
		super(X, Y);
		
		loadGraphic("assets/images/spawner.png", true, width, height);
		
		animation.add("idle", [0]);
		animation.play("idle");
	}

	
	override public function update():Void {
		this.angle += FlxG.elapsed*20;
	    
		super.update();
	}

}