package;
import openfl.Assets;
import haxe.io.Path;
import haxe.xml.Parser;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
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
	public function new(tiledLevel:Dynamic)
	{
		super(tiledLevel);
		FlxG.camera.setBounds(0, 0, fullWidth, fullHeight, true);
		// Load Tile Maps
		for (tileLayer in layers) {
				var tileSheetName:String = tileLayer.properties.get("tileset");
				if (tileSheetName == null)
					throw "'tileset' property not defined for the '" + tileLayer.name + "' layer. Please add the property to the layer.";
				var tileSet:TiledTileSet = null;
				trace("tileset : " + tileSheetName);
				for (ts in tilesets) {
						if (ts.name == tileSheetName) {
							tileSet = ts;
							break;
						}
				}
				if (tileSet == null)
					throw "Tileset '" + tileSheetName + " not found. Did you mispell the 'tilesheet' property in " + tileLayer.name + "' layer?";
				
				var imagePath = new Path(tileSet.imageSource);
				var processedPath = c_PATH_LEVEL_TILESHEETS + imagePath.file + "." + imagePath.ext;
			    tilemap = new FlxTilemapExt();
				tilemap.widthInTiles = width;
				tilemap.heightInTiles = height;
				
				tilemap.loadMap(tileLayer.csvData.split(",").filter(function(el) {return el != "\n";})
					, processedPath, tileSet.tileWidth, tileSet.tileHeight, 0, 1, 1, 3);
				
			}
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