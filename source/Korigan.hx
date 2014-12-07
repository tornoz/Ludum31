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


class Korigan extends Enemy {
	
	private var player:Player;
	public var bulletSpeed = 200;
	public var bullets:FlxTypedGroup<KoriBullet>;

	private var shootCounter:Float;
	public var shootRate = 1;
	
	public function new(X:Int, Y:Int, bullets:FlxTypedGroup<KoriBullet>, parent:FlxTypedGroup<Enemy>, player:Player, ?color:String = "green"){
		super(X, Y, parent, color);
		this.player = player;
		setFacingFlip(FlxObject.LEFT,true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		target = new FlxSprite(X,Y);
		target.loadGraphic("assets/images/korigan_" + color + ".png", true, 32,64);
		target.alpha = 0.5;
		loadGraphic("assets/images/korigan_" + color + ".png", true, 32,64);
		animation.add("idle", [0,2,1,2],6);
		//animation.add("idle", [0,1,2,1,0,0],8);
		animation.play("idle");
		// Basic player physics
		this.bullets = bullets;
		switch(color) {
			case "green":
				score  = 4;
			case "blue":
				hp = 3;
				dmg = 10;
				score = 15;
			case "red":
				hp =5;
				dmg = 20;
				score = 20;
		}
		
		this.parent = parent;
		
		drag.x = runSpeed * 2;
		acceleration.y = 1040;
		maxVelocity.set(runSpeed, jumpPower);
	}

	override public function update():Void {
		if(Std.int(player.y/32) == Std.int(this.y/32)) {
			acceleration.x = 0;
			velocity.x = 0;
			if(player.x > x)
				facing = FlxObject.RIGHT;
			else
				facing = FlxObject.LEFT;
			if(shootCounter > 0)
				shootCounter -= FlxG.elapsed;
			shoot();
		}
		else {
			if(following.x > this.x && acceleration.x <= 0) {
				acceleration.x += drag.x;
				facing = FlxObject.RIGHT;
			}
			else if(following.x < this.x && acceleration.x >= 0) {
				acceleration.x -= drag.x;
				facing = FlxObject.LEFT;
			}
		
			if(velocity.x == 0&& following.y < this.y) {
				this.jump();
			}
		}
		
		super.update();
		
	    
	}

	public function shoot():Void{
		if (shootCounter > 0) {
				return;
		}
		shootCounter = shootRate;
		var point = new FlxPoint(x+width/2, y + height - 8);
		bullets.recycle(KoriBullet, [bullets, bulletSpeed, dmg]).shoot(point, facing);
		
		
	}


}