package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

class LostState extends FlxSubState {

	private var title:FlxSprite;
	private var lost:Bool;
	private var difficulty:Difficulty;
	public function new(lost:Bool) {

		super();
		this.lost = lost;
	}
	
	public override function create() {
		title = new FlxSprite(100,50);
			FlxG.mouse.visible = true;
		if(lost)
			title.loadGraphic("assets/images/lost.png");
		else {
			if(Reg.won) {
				title.loadGraphic("assets/images/won2.png");
			}
			else {
				Reg.won = true;
				title.loadGraphic("assets/images/won1.png");
			}
		}
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
	
		
	public override function update() {
		if (FlxG.keys.anyPressed(["SPACE", "ENTER"])) {
			FlxG.resetState();
		}
		
		super.update();
	}

}