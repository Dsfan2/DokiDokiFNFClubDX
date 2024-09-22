package backend;

import animateatlas.AtlasFrameMaker;
import flixel.math.FlxPoint;
import flixel.graphics.frames.FlxFrame.FlxFrameAngle;
import openfl.geom.Rectangle;
import flixel.math.FlxRect;
import haxe.xml.Access;
import openfl.system.System;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;
import lime.utils.Assets;
import flixel.graphics.FlxGraphic;
import openfl.display.BitmapData;

import flash.media.Sound;

class Paths
{
	inline public static var SOUND_EXT = #if web "mp3" #else "ogg" #end;
	inline public static var VIDEO_EXT = "mp4";

	public static var playerSongs:Array<String> = [
		'revelation',
		'lines-of-code',
		'self-aware',
		'elevated-access',
		'just-monika',
		'doki-forever',
		'dark-star',
		"you-can't-run",
		'ultimate-glitcher',
		'festival-deluxe'
	];

	public static function excludeAsset(key:String) {
		if (!dumpExclusions.contains(key))
			dumpExclusions.push(key);
	}

	public static var dumpExclusions:Array<String> =
	[
		'assets/music/DokiNightRemastered.$SOUND_EXT',
		'assets/music/storiesOfFriendshipAndGettinFreaky.$SOUND_EXT',
		'assets/music/TheDokiFinale.$SOUND_EXT',
		'assets/music/Quick-Breather_Pause.$SOUND_EXT',
		'assets/music/Quick-Breakdown_Act-2-Pause.$SOUND_EXT',
	];
	/// haya I love you for the base cache dump I took to the max
	public static function clearUnusedMemory() {
		// clear non local assets in the tracked assets list
		for (key in currentTrackedAssets.keys()) {
			// if it is not currently contained within the used local assets
			if (!localTrackedAssets.contains(key) 
				&& !dumpExclusions.contains(key)) {
				// get rid of it
				var obj = currentTrackedAssets.get(key);
				@:privateAccess
				if (obj != null) {
					openfl.Assets.cache.removeBitmapData(key);
					FlxG.bitmap._cache.remove(key);
					obj.destroy();
					currentTrackedAssets.remove(key);
				}
			}
		}
		// run the garbage collector for good measure lmfao
		System.gc();
	}

	// define the locally tracked assets
	public static var localTrackedAssets:Array<String> = [];
	public static function clearStoredMemory(?cleanUnused:Bool = false) {
		// clear anything not in the tracked assets list
		@:privateAccess
		for (key in FlxG.bitmap._cache.keys())
		{
			var obj = FlxG.bitmap._cache.get(key);
			if (obj != null && !currentTrackedAssets.exists(key)) {
				openfl.Assets.cache.removeBitmapData(key);
				FlxG.bitmap._cache.remove(key);
				obj.destroy();
			}
		}

		// clear all sounds that are cached
		for (key in currentTrackedSounds.keys()) {
			if (!localTrackedAssets.contains(key) 
			&& !dumpExclusions.contains(key) && key != null) {
				//trace('test: ' + dumpExclusions, key);
				Assets.cache.clear(key);
				currentTrackedSounds.remove(key);
			}
		}	
		// flags everything to be cleared out next unused memory clear
		localTrackedAssets = [];
		openfl.Assets.cache.clear("songs");
	}

	static public var currentModDirectory:String = '';
	static public var currentLevel:String;
	static public function setCurrentLevel(name:String)
	{
		currentLevel = name.toLowerCase();
	}

	public static function getPath(file:String, type:AssetType, ?library:Null<String> = null)
	{
		if (library != null)
			return getLibraryPath(file, library);

		if (currentLevel != null)
		{
			var levelPath:String = '';
			//if(currentLevel != 'shared') {
			levelPath = getLibraryPathForce(file, currentLevel);
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;
			//}

			//levelPath = getLibraryPathForce(file, "shared");
			//if (OpenFlAssets.exists(levelPath, type))
				//return levelPath;
		}

		return getPreloadPath(file);
	}

	static public function getLibraryPath(file:String, library = "preload")
	{
		return if (library == "preload" || library == "default") getPreloadPath(file); else getLibraryPathForce(file, library);
	}

	inline static function getLibraryPathForce(file:String, library:String)
	{
		var returnPath = '$library:assets/$library/$file';
		return returnPath;
	}

	inline public static function getPreloadPath(file:String = '')
	{
		return 'assets/$file';
	}

	inline static public function file(file:String, type:AssetType = TEXT, ?library:String)
	{
		return getPath(file, type, library);
	}

	inline static public function chr(key:String)
	{
		return 'characters/$file.chr';
	}

	inline static public function txt(key:String, ?library:String)
	{
		return getPath('data/$key.txt', TEXT, library);
	}

	inline static public function dialogueTxt(key:String, ?library:String)
	{
		return getPath('data/dialogue/normal/$key.txt', TEXT, library);
	}

	inline static public function dialogueJSON(key:String, ?library:String)		
	{
		return getPath('data/dialogue/doki-doki/$key.json', TEXT, library);
	}

	inline static public function blurbJSON(key:String, ?library:String)		
	{
		return getPath('data/meta/$key.json', TEXT, library);
	}

	inline static public function xml(key:String, ?library:String)
	{
		return getPath('data/$key.xml', TEXT, library);
	}

	inline static public function json(key:String, ?library:String)
	{
		return getPath('data/$key.json', TEXT, library);
	}

	inline static public function shaderFragment(key:String, ?library:String)
	{
		return getPath('shaders/$key.frag', TEXT, library);
	}
	inline static public function shaderVertex(key:String, ?library:String)
	{
		return getPath('shaders/$key.vert', TEXT, library);
	}

	static public function video(key:String)
	{
		return 'assets/videos/$key.$VIDEO_EXT';
	}

	static public function sound(key:String, ?library:String):Sound
	{
		var sound:Sound = returnSound('sounds', key, library);
		return sound;
	}
	
	inline static public function soundRandom(key:String, min:Int, max:Int, ?library:String)
	{
		return sound(key + FlxG.random.int(min, max), library);
	}

	inline static public function music(key:String, ?library:String):Sound
	{
		var file:Sound = returnSound('music', key, library);
		return file;
	}

	inline static public function inst(song:String):Any
	{
		var diffSuffix:String = '';
		var diffStr:String = CoolUtil.difficultyString();
		if (diffStr == "DOKI DOKI")
			diffSuffix = "doki-doki/";
		else
			diffSuffix = "default/";
		var songKey:String = diffSuffix + '${song.toLowerCase().replace(' ', '-')}/Inst';
		var inst = returnSound('songs', songKey);
		return inst;
	}

	inline static public function opponentvoices(song:String):Any
	{
		var diffSuffix:String = '';
		var diffStr:String = CoolUtil.difficultyString();
		var songKey:String = '';
		if (diffStr == "DOKI DOKI")
			diffSuffix = "doki-doki/";
		else
			diffSuffix = "default/";
		if (ClientPrefs.playerChar == 1 || PlayState.songType != 'Normal')
		{
			songKey = diffSuffix + '${formatToSongPath(song)}/Voices-OPP';
		}
		else if (ClientPrefs.playerChar == 2)
		{
			if (FileSystem.exists('assets/songs/${diffSuffix}${formatToSongPath(song)}/Voices-OPP2.ogg'))
			{
				songKey = diffSuffix + '${formatToSongPath(song)}/Voices-OPP2';
			}
			else
				songKey = diffSuffix + '${formatToSongPath(song)}/Voices-OPP';
		}
		else
		{
			if (FileSystem.exists('assets/songs/${diffSuffix}${formatToSongPath(song)}/Voices-OPP3.ogg'))
			{
				songKey = diffSuffix + '${formatToSongPath(song)}/Voices-OPP3';
			}
			else
				songKey = diffSuffix + '${formatToSongPath(song)}/Voices-OPP';
		}
		var voices = returnSound('songs', songKey);
		return voices;
	}

	inline static public function playervoices(song:String):Any
	{
		var diffSuffix:String = '';
		var diffStr:String = CoolUtil.difficultyString();
		var songKey:String = '';
		if (diffStr == "DOKI DOKI")
			diffSuffix = "doki-doki/";
		else
			diffSuffix = "default/";
		if (ClientPrefs.playerChar == 1 || PlayState.songType != 'Normal')
		{
			if (playerSongs.contains(${formatToSongPath(song)}) && PlayState.songType != 'Normal')
			{
				switch (ClientPrefs.yourVoice)
				{
					case 'Masculine': songKey = diffSuffix + '${formatToSongPath(song)}/Voices-P3-M';
					case 'Feminine': songKey = diffSuffix + '${formatToSongPath(song)}/Voices-P3-F';
				}
			}
			else songKey = diffSuffix + '${formatToSongPath(song)}/Voices-P1';
		}
		else if (ClientPrefs.playerChar == 2)
		{
			if (FileSystem.exists('assets/songs/${diffSuffix}${formatToSongPath(song)}/Voices-P2.ogg'))
			{
				songKey = diffSuffix + '${formatToSongPath(song)}/Voices-P2';
			}
			else
				songKey = diffSuffix + '${formatToSongPath(song)}/Voices-P1';
		}
		else
		{
			if (FileSystem.exists('assets/songs/${diffSuffix}${formatToSongPath(song)}/Voices-P3.ogg'))
			{
				songKey = diffSuffix + '${formatToSongPath(song)}/Voices-P3';
			}
			else
			{
				if (playerSongs.contains(${formatToSongPath(song)}))
				{
					switch (ClientPrefs.yourVoice)
					{
						case 'Masculine': songKey = diffSuffix + '${formatToSongPath(song)}/Voices-P3-M';
						case 'Feminine': songKey = diffSuffix + '${formatToSongPath(song)}/Voices-P3-F';
					}
				}
				else songKey = diffSuffix + '${formatToSongPath(song)}/Voices-P1';
			}
		}
		var voices = returnSound('songs', songKey);
		return voices;
	}

	inline static public function image(key:String, ?library:String):FlxGraphic
	{
		// streamlined the assets process more
		var returnAsset:FlxGraphic = returnGraphic(key, library);
		return returnAsset;
	}
	
	static public function getTextFromFile(key:String, ?ignoreMods:Bool = false):String
	{
		#if sys
		if (FileSystem.exists(getPreloadPath(key)))
			return File.getContent(getPreloadPath(key));

		if (currentLevel != null)
		{
			var levelPath:String = '';
			levelPath = getLibraryPathForce(key, currentLevel);
			if (FileSystem.exists(levelPath))
				return File.getContent(levelPath);
		}
		#end
		return Assets.getText(getPath(key, TEXT));
	}

	inline static public function font(key:String)
	{
		return 'assets/fonts/$key';
	}

	inline static public function fileExists(key:String, type:AssetType, ?ignoreMods:Bool = false, ?library:String)
	{	
		if(OpenFlAssets.exists(getPath(key, type))) {
			return true;
		}
		return false;
	}

	inline static public function getSparrowAtlas(key:String, ?library:String):FlxAtlasFrames
	{
		return FlxAtlasFrames.fromSparrow(image(key, library), file('images/$key.xml', library));
	}


	inline static public function getPackerAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSpriteSheetPacker(image(key, library), file('images/$key.txt', library));
	}

	inline static public function formatToSongPath(path:String) {
		return path.toLowerCase().replace(' ', '-');
	}

	// completely rewritten asset loading?
	public static var currentTrackedAssets:Map<String, FlxGraphic> = [];
	public static function returnGraphic(key:String, ?library:String) {
		var path = getPath('images/$key.png', IMAGE, library);
		if (OpenFlAssets.exists(path, IMAGE)) {
			if(!currentTrackedAssets.exists(path)) {
				var newGraphic:FlxGraphic = FlxG.bitmap.add(path, false, path);
				currentTrackedAssets.set(path, newGraphic);
			}
			localTrackedAssets.push(path);
			return currentTrackedAssets.get(path);
		}
		trace('oh no its returning null NOOOO ($path)');
		return null;
	}

	public static var currentTrackedSounds:Map<String, Sound> = [];
	public static function returnSound(path:String, key:String, ?library:String) {
		// I hate this so much
		var gottenPath:String = getPath('$path/$key.$SOUND_EXT', SOUND, library);
		gottenPath = gottenPath.substring(gottenPath.indexOf(':') + 1, gottenPath.length);
		if(!currentTrackedSounds.exists(gottenPath))
			currentTrackedSounds.set(gottenPath, Sound.fromFile('./' + gottenPath));
		localTrackedAssets.push(gottenPath);
		return currentTrackedSounds.get(gottenPath);
	}

	inline static public function instString(song:String):String
	{
		var diffSuffix:String = '';
		var diffStr:String = CoolUtil.difficultyString();
		if (diffStr == "DOKI DOKI")
			diffSuffix = "doki-doki/";
		else
			diffSuffix = "default/";

		var songKey:String = diffSuffix + '${song.toLowerCase().replace(' ', '-')}/Inst.ogg';
		return 'assets/songs/' + songKey;
	}
}
