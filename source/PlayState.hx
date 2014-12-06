package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.group.FlxTypedGroup;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	private var map:TiledLevel;
	private var player:Player;
	private var bullets:FlxTypedGroup<Bullet>;
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		FlxG.debugger.drawDebug = true;
		FlxG.mouse.visible = false;


		map = new TiledLevel("assets/data/map.tmx");
	
		add(map.tilemap);
		map.loadObjects(this);
		player = map.player;
		bullets = player.bullets;
		
		FlxG.camera.setBounds(0, 0, 800, 600, true);
		FlxG.worldBounds.set(0, 0, 800, 600);
		super.create();
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		map.collideWithLevel(player);
		map.collideWithLevel(bullets);
		super.update();
	}	
}