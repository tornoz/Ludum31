package;



import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import flixel.ui.FlxButton;
import flixel.ui.FlxVirtualPad;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;
import flixel.util.FlxRandom;


class Item extends FlxSprite {


	
	
	public function new(X:Int, Y:Int, ?snow:Bool = false){
		super(X, Y);
		
		loadGraphic("assets/images/bonus.png", true, 32, 32);
		if(!snow) {
			var anims = ["frequency", "shotspeed", "speed", "strength", "jump"];
			for(i in 0...anims.length) {
				animation.add(anims[i], [i]);
			}
			animation.play(anims[FlxRandom.intRanged(0,anims.length-1)]);
		}
		else {
			animation.add("snow", [5]);
			animation.play("snow");
		}
	   
	}

	
	override public function update():Void {
	
	    
		super.update();
	}

	public function setBonus(player:Player):Void {
		switch(animation.name) {
			case "frequency":
				player.shootRate -= 0.05;
					FlxG.sound.play("assets/sounds/item.wav", 1, false,false);
			case "shotspeed":
				player.bulletSpeed += 75;
				FlxG.sound.play("assets/sounds/item.wav", 1, false,false);
			case "speed":
				player.maxVelocity.x += 50;
				FlxG.sound.play("assets/sounds/item.wav", 1, false,false);
			case"strength":
				player.dmg += 0.5;
				FlxG.sound.play("assets/sounds/item.wav", 1, false,false);
			case"jump":
				player.jumpPower += 100;
				FlxG.sound.play("assets/sounds/item.wav", 1, false,false);
			case "snow":
				FlxG.sound.play("assets/sounds/heal.wav", 1, false,false);
				player.hp += 40;
				if(player.hp > player.maxHp)
					player.hp = player.maxHp;
		}
	    
	
	}							  

}