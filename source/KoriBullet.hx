
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.group.FlxTypedGroup;
class KoriBullet extends FlxSprite
{
	private var speed:Float;
	private var parent:FlxTypedGroup<KoriBullet>;
	public var dmg =1;
	public function new( parent:FlxTypedGroup<KoriBullet>, speed:Float, damage:Float) {
		super();
		this.parent = parent;
		loadGraphic(Reg.KORIBULLET, true);
		width = 8;
		height = 8;
		offset.set(1, 1);
		animation.add("iddle", [0]);
		//animation.add("poof", [4, 5, 6, 7], 50, false);
		animation.play("iddle");
		dmg = Std.int(damage);
		this.speed = speed;
	}
	public function die() {
		parent.remove(this);
		this.exists = false;
	}
	override public function update():Void {
		if (velocity.x == 0&& velocity.y == 0) {
				parent.remove(this);
				this.exists = false;
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