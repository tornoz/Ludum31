package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxRandom;
import flixel.util.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxRandom;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	private var spawnTime:Float = 5;
	private var spawnTimer:Float = 2;
	private var map:TiledLevel;
	private var player:Player;
	private var bullets:FlxTypedGroup<Bullet>;
	private var koriBullets:FlxTypedGroup<KoriBullet>;
	
	private var enemies:FlxTypedGroup<Enemy>;
	private var spawners:FlxTypedGroup<Spawner>;
	private var hp:FlxSprite;
	private var timeToItemSpawn:Float = 0;
	private var itemTimer:Float = 0;
	private var items:FlxTypedGroup<Item>;
	private var totalTime:Float = 0;

	private var snowTimer:Float = 0;
	private var timeToSnowSpawn:Float = 0;

	private var scoreObjective:Float;
	private var currentScore:Float = 0;
	private var activeStar:Bool = false;
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		FlxG.debugger.drawDebug = true;
		FlxG.mouse.visible = false;
		scoreObjective = 400 + 100 * Reg.difficulty;

		map = new TiledLevel("assets/data/map.tmx");
	
		add(map.tilemap);
		map.loadObjects(this);
		player = map.player;
		bullets = player.bullets;
		spawners = map.spawners;
		items = new FlxTypedGroup<Item>();
		add(items);
		enemies = new FlxTypedGroup<Enemy>();
		add(enemies);
		koriBullets =  new FlxTypedGroup<KoriBullet>();
		add(koriBullets);
		add(player.gibs);
		FlxG.camera.setBounds(0, 0, 800, 600, true);
		FlxG.worldBounds.set(0, 0, 800, 600);

		FlxG.camera.bgColor = 0;
		var hpUi = new FlxText(0,575,0,"Snow left : ");
		hpUi.color = 255;
		hpUi.size = 20;
		add(hpUi);
		var hpBar = new FlxSprite(175, 575);
		hpBar.makeGraphic(300, 40, FlxColor.WHITE);
		add(hpBar);
		hp = new FlxSprite(175, 575);
		hp.makeGraphic(300, 40, FlxColor.RED);
		add(hp);
		timeToItemSpawn = FlxRandom.intRanged(5,20);
		timeToSnowSpawn = FlxRandom.intRanged(5,20);
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
		map.collideWithLevel(enemies);

		
		if(currentScore >= scoreObjective && !activeStar) {
			map.star.animation.play("active");
			activeStar = true;
			FlxG.sound.play("assets/sounds/star.wav", 1, false,false);
		}
		else {
			currentScore += FlxG.elapsed;
		
			map.star.alpha = currentScore / scoreObjective;
		}
		totalTime += FlxG.elapsed;
		spawnTimer += FlxG.elapsed;
		itemTimer += FlxG.elapsed;
		snowTimer += FlxG.elapsed;
		if(spawnTimer >= spawnTime) {
			spawnTimer = 0;
			spawnTime=FlxRandom.floatRanged(2,9 - Reg.difficulty *1.5);
			var spawn = spawners.getRandom();
			var enemyArray = ["enemy"];
			var colorArray = ["green"];
			if(totalTime > 30) {
				enemyArray.push("korigan");
			}
			if(totalTime > 60)
				enemyArray.push("golem");
			if(player.dmg>2 || Reg.difficulty == 3) {
				colorArray.push("red");
			}
			if(player.dmg > 1 || Reg.difficulty == 2) {
				colorArray.push("blue");
			}
			var color = colorArray[FlxRandom.intRanged(0, colorArray.length-1)];
				
			var enemy:Enemy = new Enemy(Std.int(spawn.x), Std.int(spawn.y), enemies, color);
			switch(enemyArray[FlxRandom.intRanged(0, enemyArray.length-1)]) {
			
				case "korigan":
					enemy = new Korigan(Std.int(spawn.x), Std.int(spawn.y), koriBullets, enemies, player, color);
				case "golem":
					 enemy = new Golem(Std.int(spawn.x), Std.int(spawn.y), enemies, color);
					 enemy.width = 32;
					 enemy.centerOffsets();
			}
			//enemy.setFollow(player);
			enemies.add(enemy);
		}
		if(itemTimer >= timeToItemSpawn) {
			spawnItem();
			timeToItemSpawn = FlxRandom.intRanged(5,5 + Reg.difficulty * 5);
			itemTimer = 0;
		}
		if(snowTimer >= timeToSnowSpawn) {
			spawnSnow();
			timeToSnowSpawn = FlxRandom.intRanged(8,20);
			snowTimer = 0;
		}

		for(enemy in enemies) {
			var path = map.tilemap.findPath(FlxPoint.get(enemy.x, enemy.y), FlxPoint.get(player.x, player.y));
			if(path.length > 1)
				enemy.setFollow(path[1]);
			//trace("goto " + path[1]);
			
		}
		
		hp.setGraphicSize(Std.int(player.hp *3.0), Std.int(hp.height));
		FlxG.collide(bullets,enemies, hit);
		FlxG.collide(player, enemies, hitPlayer);
		FlxG.collide(player, koriBullets, hitBullet);
		FlxG.overlap(player, items, catchItem);
		FlxG.overlap(player, map.star, win);
		if(player.hp <=0)
					openSubState( new LostState(true));
		super.update();
	}

	public function hit(bullet:Dynamic, enemy:Dynamic ):Void {
		if(enemy.hit(player.dmg)) {
			currentScore += enemy.score;
		}
		bullet.die();
	}

	public function win(player:Dynamic, star:Dynamic) {
		if(currentScore >= scoreObjective) {
			openSubState( new LostState(false));
		}
	}

	public function hitPlayer(player:Dynamic, enemy:Dynamic) {
		if(!player.hit) {
			FlxG.camera.shake(0.005, 0.3);
			player.hitBack((player.x < enemy.x));
			player.hp -= enemy.dmg;
			FlxG.sound.play("assets/sounds/hit.wav", 1, false,false);
		}
		enemy.acceleration.x = -50;
		enemy.velocity.x = -50;
	}
	public function hitBullet(player:Dynamic, bullet:Dynamic) {
		if(!player.hit) {
			FlxG.camera.shake(0.005, 0.3);
			player.hitBack((player.x < bullet.x));
			player.hp -= bullet.dmg;
				FlxG.sound.play("assets/sounds/hit.wav", 1, false,false);
		}
	   koriBullets.remove(bullet);
	   bullet.exists = false;
	}

	public function spawnItem() {
		if(map.itemSpawners.length > 0) {
			var point:FlxPoint = map.itemSpawners[FlxRandom.intRanged(0, map.itemSpawners.length-1)];
			map.itemSpawners.remove(point);
			var item = new Item(Std.int(point.x),Std.int( point.y));
			items.add(item);
		}
		
	}

	public function spawnSnow() {
		if(map.itemSpawners.length > 0) {
			var point:FlxPoint = map.itemSpawners[FlxRandom.intRanged(0, map.itemSpawners.length-1)];
			map.itemSpawners.remove(point);
			var item = new Item(Std.int(point.x),Std.int( point.y), true);
			items.add(item);
		}
		
	}

	public function catchItem(player:Player, item:Item) {
		item.setBonus(player);
		items.remove(item);
		map.itemSpawners.push(new FlxPoint(item.x, item.y));
		item.exists = false;
		
	}
}