package;



import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import flixel.ui.FlxButton;
import flixel.ui.FlxVirtualPad;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;
import flixel.util.FlxPoint;
import flixel.util.FlxPath;


class Golem extends Enemy {
	
	
	public function new(X:Int, Y:Int, parent:FlxTypedGroup<Enemy>, ?color:String = "green"){
		super(X, Y, parent, color);
		setFacingFlip(FlxObject.LEFT,true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		target = new FlxSprite(X,Y);
		target.loadGraphic("assets/images/korigan_" + color + ".png", true, 32,64);
		target.alpha = 0.5;
		loadGraphic("assets/images/golem_" + color + ".png", true, 64,64);
		
		animation.add("idle", [0,1,2,3,4,5],4);
		//animation.add("idle", [0,1,2,1,0,0],8);
		animation.play("idle");
		// Basic player physics
		switch(color) {
			case "green":
				hp = 6;
				dmg = 5;
				score  = 4;
			case "blue":
				hp = 8;
				dmg = 10;
				score = 15;
			case "red":
				hp =16;
				dmg = 15;
				score = 20;
		}
		
		this.parent = parent;
		runSpeed = 55;
		drag.x = runSpeed / 2;
		acceleration.y = 1040;
		maxVelocity.set(runSpeed, jumpPower);
	}

	override public function update():Void {
	    
		
		var ax = acceleration.x;
	    
		super.update();
		acceleration.x = ax;
		if(following.x > this.x && velocity.x <= 0) {
			acceleration.x += drag.x;
			facing = FlxObject.RIGHT;
		}
		else if(following.x < this.x && velocity.x >= 0) {
			acceleration.x -= drag.x;
			facing = FlxObject.LEFT;
		}
	}
									  
}