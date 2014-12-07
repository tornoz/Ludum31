package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	private var difficulty:Difficulty;
	override public function create():Void
	{
		var title = new FlxSprite(0,0);
		title.loadGraphic("assets/images/title.png");
		add(title);

		difficulty = new Difficulty(360, Std.int(title.height - 64));
		var next = new FlxButton(360 + difficulty.width, title.height-32 , ">", next);
		var previous = new FlxButton(360 -100, title.height-32 , "<",previous);

		add(difficulty);
		add(next);
		add(previous);
		super.create();
	}

	public function next() {
		difficulty.next();
	 }

		public function previous() {
		difficulty.previous();
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
		if (FlxG.keys.justPressed.SPACE || FlxG.keys.justPressed.ENTER){
				FlxG.switchState(new PlayState());
		}
	
		super.update();
	}	
}