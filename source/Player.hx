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
import flixel.util.FlxColor;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;

class Player extends FlxSprite {

	public var maxHp = 100;
	
	public var jumpPower:Int = 300;
	public var runSpeed:Int = 200;
	public var hp:Float = 100;
	public var shootRate = 1/2;
	public var meltingPerSecond = 2;
	public var dmg:Float = 1;
	public var bulletSpeed = 200;

	public var maxJumpPower = 900;
	public var maxRunSpeed = 900;
	public var wait = false;
	private var shootCounter:Float;
	private var aim:Int;
	public var bullets:FlxTypedGroup<Bullet>;
	public var isReadyToJump:Bool = true;
	public var invincibleTime:Float = 0.5;
	public var invincibleTimer:Float = 0;
	public var hitback = 500;
	public var hit:Bool = false;
	public var gibs:FlxEmitter;
	private var _whitePixel:FlxParticle;
	
	
	public function new(X:Int, Y:Int){
		super(X, Y);
		
		setFacingFlip(FlxObject.LEFT,true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		
		loadGraphic("assets/images/player.png", true, 32,64);
		
		animation.add("idle", [0,1,2,1], 4);
		animation.add("walk", [3,5,4,5], 4);
		animation.add("jump", [6,7,8,9,10], 5, false);
		animation.add("fall", [10,9,8,7,6], 5, false);
		animation.play("idle");
		// Basic player physics

		bullets = new FlxTypedGroup<Bullet>();
		
		drag.x = runSpeed * 8;
		acceleration.y = 1040;
		maxVelocity.set(runSpeed, maxJumpPower);

		gibs = new FlxEmitter();
		gibs.setXSpeed( -150, 150);
		gibs.setYSpeed( -200, 0);
		gibs.setRotation( -720, -720);
		gibs.gravity = 350;
		gibs.bounce = 0.5;

		
		//gibs.makeParticles(Reg.GIBS, 100, 10, true, 0.5);
	}

	
	override public function update():Void {
		
		if(shootCounter > 0)
			shootCounter -= FlxG.elapsed;
		aim = facing;
		hp -= meltingPerSecond * FlxG.elapsed;
		if(invincibleTimer>=0) {
			invincibleTimer -= FlxG.elapsed;
			if(invincibleTimer <=0) {
				hit = false;
			}
		}
		// INPUT
	
			acceleration.x = 0;
			if (FlxG.keys.pressed.LEFT && !wait)	{
			
				moveLeft();
			}
			else if (FlxG.keys.pressed.RIGHT && !wait) {
				moveRight();
			}
			else if (FlxG.keys.pressed.UP && !wait)	{
			
				moveUp();
			}
			else if (FlxG.keys.pressed.DOWN  && !wait) {
				moveDown();
			}
			if (FlxG.keys.justPressed.X){
				jump();
			}
			if (FlxG.keys.pressed.C)	{
			
				shoot();
			}
		
		
		
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
				animation.play("walk");
			}
			

		
	    
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

						 
	public function jump():Void	{
		if (isReadyToJump && (velocity.y == 0))
			{
				FlxG.sound.play("assets/sounds/jump.wav", 1, false,false);
				velocity.y = -jumpPower;
			}
	}

	public function shoot():Void{
		if (shootCounter > 0) {
				return;
		}
		FlxG.sound.play("assets/sounds/shoot.wav", 1, false,false);
		shootCounter = shootRate;
		var point = new FlxPoint(x + width/2,y);
		bullets.recycle(Bullet, [bullets, bulletSpeed]).shoot(point, aim);
		
		if (aim == FlxObject.DOWN)	{
			velocity.y -= 36;
		}
		
	}
							

	public function hitBack(side:Bool) {
		for (i in 0...10)
			{
				_whitePixel = new FlxParticle();
				_whitePixel.makeGraphic(2, 2, FlxColor.WHITE);
				// Make sure the particle doesn't show up at (0, 0)
				_whitePixel.visible = false;
				gibs.add(_whitePixel);
				_whitePixel = new FlxParticle();
				_whitePixel.makeGraphic(1, 1, FlxColor.WHITE);
				_whitePixel.visible = false;
				gibs.add(_whitePixel);
			}
		FlxSpriteUtil.flicker(this, 1, 0.07, true, true);
		hit=true;
		invincibleTimer = invincibleTime;
		if(side) {
			velocity.x = -hitback*2;
		}
		else {
			velocity.x = hitback*2;
		}
		gibs.at(this);
		gibs.start(true, 2, 0, 20);
		velocity.y = -hitback/2; 
	 }


}