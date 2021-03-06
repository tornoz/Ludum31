
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.group.FlxTypedGroup;
class Bullet extends FlxSprite
{
	private var speed:Float;
	private var timeStopped:Float = 0;
	private var timeLasting = 1;
	private var parent:FlxTypedGroup<Bullet>;
	public function new( parent:FlxTypedGroup<Bullet>, speed:Float) {
		super();
		setFacingFlip(FlxObject.LEFT,true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		this.parent = parent;
		loadGraphic(Reg.BULLET, true);
		width = 16;
		height = 16;
		offset.set(1, 1);
		animation.add("iddle", [0,1, 2,3]);
		//animation.add("poof", [4, 5, 6, 7], 50, false);
		animation.play("iddle");
		this.speed = speed;
	}
	public function die() {
		parent.remove(this);
		this.exists = false;
	}
	override public function update():Void {
		if (velocity.x == 0&& velocity.y == 0) {
			animation.pause();
			timeStopped += FlxG.elapsed;
			if(timeStopped >= timeLasting) {
				parent.remove(this);
				this.exists = false;
			}
		}
		
		super.update();
	}
	public function shoot(location:FlxPoint, aim:Int):Void
	{
		//FlxG.sound.play("Shoot");
		super.reset(location.x - width / 2, location.y - height / 2);
		solid = true;
		switch (aim)
			{
				case FlxObject.UP:
					//animation.play("up");
					angle = -90;
					velocity.y = - speed;
				case FlxObject.DOWN:
					//	animation.play("down");
					angle = 90;
					velocity.y = speed;
				case FlxObject.LEFT:
					//	animation.play("left");
					velocity.x = - speed;
				case FlxObject.RIGHT:
					//	animation.play("right");
					velocity.x = speed;
					}
		facing = aim;
	}
																														}