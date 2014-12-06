package;



import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import flixel.ui.FlxButton;
import flixel.ui.FlxVirtualPad;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;


class Player extends FlxSprite {

	private var jumpPower:Int = 480;
	private var runSpeed:Int = 275;
	public var wait = false;

	private var shootCounter:Float;
	private var aim:Int;
	public var bullets:FlxTypedGroup<Bullet>;
	public var isReadyToJump:Bool = true;

	
	private static var SHOOT_RATE:Float = 1 / 5;
	
	public function new(X:Int, Y:Int){
		super(X, Y);
		
		setFacingFlip(FlxObject.LEFT,true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		
		loadGraphic("assets/images/player.png", true, 32,64);
		
		animation.add("idle", [0]);
		animation.play("idle");
		// Basic player physics

		bullets = new FlxTypedGroup<Bullet>();
		
		drag.x = runSpeed * 8;
		acceleration.y = 1040;
		maxVelocity.set(runSpeed, jumpPower);
	}

	
	override public function update():Void {
		acceleration.x = 0;
		if(shootCounter > 0)
			shootCounter -= FlxG.elapsed;
		aim = facing;
		// INPUT
		if (FlxG.keys.pressed.LEFT && !wait)	{
			
			moveLeft();
		}
		else if (FlxG.keys.pressed.RIGHT && !wait) {
			moveRight();
		}
		if (FlxG.keys.justPressed.X ||FlxG.keys.justPressed.UP  ){
			jump();
	    }
		if (FlxG.keys.pressed.C)	{
			
			shoot();
		}
		/*
		if(!wait) {
			if (velocity.y < 0){
				
				animation.play("jump");
	
			}
			else if (velocity.y > 0){
				animation.play("fall");
			}
			else if (velocity.x == 0){
				animation.play("idle");
			}
			else if (velocity.x != 0){
				animation.play("run");
			}
			}*/

		
	    
		super.update();
	}

	function moveLeft():Void {
		facing = FlxObject.LEFT;
		acceleration.x -= drag.x;
	}
	function moveRight():Void{
		facing = FlxObject.RIGHT;
		acceleration.x += drag.x;
	}
	function moveUp():Void {
		aim = FlxObject.UP;
	}
	function moveDown():Void {
		aim = FlxObject.DOWN;
	}

						 
	function jump():Void	{
		if (isReadyToJump && (velocity.y == 0))
			{
				velocity.y = -jumpPower;
			}
	}

	function shoot():Void{
		if (shootCounter > 0) {
				return;
		}
		shootCounter = SHOOT_RATE;
		getMidpoint(_point);
		bullets.recycle(Bullet, [bullets]).shoot(_point, aim);
		if (aim == FlxObject.DOWN)	{
			velocity.y -= 36;
		}
		
	}


}