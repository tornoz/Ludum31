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


class Enemy extends FlxSprite {

	private var jumpPower:Int = 400;
	private var runSpeed:Int = 150;
	private var following:FlxPoint;
	public var wait = false;
	public var target:FlxSprite;
	private var aim:Int;
	public var parent:FlxTypedGroup<Enemy>;
	public var isReadyToJump:Bool = true;
	public var hp = 2;
	public var dmg = 5;
	public var score = 2;
	
	
	public function new(X:Int, Y:Int, parent:FlxTypedGroup<Enemy>, ?color:String = "green"){
		super(X, Y);
		
		setFacingFlip(FlxObject.LEFT,true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		target = new FlxSprite(X,Y);
		target.loadGraphic("assets/images/korigan_" + color + ".png", true, 32,64);
		target.alpha = 0.5;
		loadGraphic("assets/images/enemy_" + color + ".png", true, 32,64);
		
		animation.add("idle", [0,1,2,1,0,0],8);
		animation.play("idle");
		// Basic player physics

		switch(color) {
			case "blue":
				hp = 3;
				dmg = 10;
				score = 8;
			case "red":
				hp =5;
				dmg = 20;
				score = 15;
		}
		
		this.parent = parent;
		
		drag.x = runSpeed * 2;
		acceleration.y = 1040;
		maxVelocity.set(runSpeed, jumpPower);
	}

	public function setFollow(f:FlxPoint) {
		this.following = f;
		target.x = f.x;
		target.y = f.y;
	}

	public function die() {
		parent.remove(this);
		this.exists = false;
	}
	public function hit(dmg:Int):Bool {
		hp -= dmg;
		FlxSpriteUtil.flicker(this, 1, 0.07, true, true);
		if(hp < 0) {
			die();
			return true;
		}
		else {
			return false;
		}
	}
	function jump():Void	{
		if (isReadyToJump && (velocity.y == 0))
			{
				velocity.y = -jumpPower;
			}
	}
	
	override public function update():Void {
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
	    
		super.update();
	}

}