package;
import openfl.Assets;
import haxe.io.Path;
import haxe.xml.Parser;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.group.FlxTypedGroup;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectGroup;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.addons.tile.FlxTilemapExt;
/**
 * ...
 * @author Samuel Batista
 */
class TiledLevel extends TiledMap
{
	// For each "Tile Layer" in the map, you must define a "tileset" property which contains the name of a tile sheet image
	// used to draw tiles in that layer (without file extension). The image file must be located in the directory specified bellow.
	private inline static var c_PATH_LEVEL_TILESHEETS = "assets/images/";
	// Array of tilemaps used for collision
	public var tilemap:FlxTilemapExt;
	public var player:Player;
	public var spawners:FlxTypedGroup<Spawner>;
	public var itemSpawners:Array<FlxPoint>;
	public var star:Star;
	
	public function new(tiledLevel:Dynamic)
	{
		super(tiledLevel);
		var tilesetsImg = ["lava","brick", "wood", "dirt", "snow"];
		FlxG.camera.setBounds(0, 0, fullWidth, fullHeight, true);
		// Load Tile Maps
		var tileLayer = layers[FlxRandom.intRanged(0,layers.length-1)];
						
		var processedPath = c_PATH_LEVEL_TILESHEETS + "tileset_"
			+ tilesetsImg[FlxRandom.intRanged(0, tilesetsImg.length-1)] + "." + "png";
		tilemap = new FlxTilemapExt();
		tilemap.widthInTiles = width;
		tilemap.heightInTiles = height;
				
		tilemap.loadMap(tileLayer.csvData.split(",").filter(function(el) {return el != "\n";})
		, processedPath, 32, 32, 0, 1,1, 3);
				
		
		spawners = new FlxTypedGroup<Spawner>();
		itemSpawners = new Array<FlxPoint>();
	}
	public function loadObjects(state:PlayState)
	{
		for (group in objectGroups)
			{
				for (o in group.objects)
					{
						loadObject(o, group, state);
					}
			}
		state.add(spawners);
	}
	private function loadObject(o:TiledObject, g:TiledObjectGroup, state:PlayState)
	{
		var x:Int = o.x;
		var y:Int = o.y;
		// objects in tiled are aligned bottom-left (top-left in flixel)
		if (o.gid != -1)
			y -= g.map.getGidOwner(o.gid).tileHeight;
		switch (o.type.toLowerCase())
			{
				case "playerstart":
					player = new Player(x,y);
					player.width -=5;
					player.height -= 5;
					player.centerOffsets();
					player.height -= 15;
					player.offset.y += 15;
					state.add(player);
					state.add(player.bullets);
				case "spawner":
					var spawner = new Spawner(x,y, o.width, o.height);
					spawners.add(spawner);
				case "itemspawner":
					var itemspawner = new FlxPoint(x,y);
					itemSpawners.push(itemspawner);
				case "star":
					star = new Star(x,y);
					state.add(star);
					
			}
		
	}
	public function collideWithLevel(obj:FlxBasic, ?notifyCallback:FlxObject->FlxObject->Void):Bool
	{
		
		return FlxG.collide(tilemap, obj, notifyCallback);
		
	}
	 public function overlapWithLevel(obj:FlxBasic, ?notifyCallback:FlxObject->FlxObject->Void):Bool
	{
		
		return FlxG.overlap(tilemap, obj, notifyCallback);
		
	}

}