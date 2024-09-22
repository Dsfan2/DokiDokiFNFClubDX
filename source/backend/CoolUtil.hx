package backend;

import openfl.utils.Assets;
import lime.utils.Assets as LimeAssets;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;

class CoolUtil
{
	public static var programList:Array<String> = [
		'obs32',
		'obs64',
		'streamlabs obs',
		'bdcam',
		'fraps',
		'xsplit', // TIL c# program
		'hycam2', // hueh
		'twitchstudio', // why
		'OBS',
		'QuickTime Player'
	];

	public static var defaultDifficulties:Array<String> = [
		'Normal',
		'Doki Doki'
	];
	public static var defaultDifficulty:String = 'Normal'; //The chart that has no suffix and starting difficulty on Freeplay/Story Mode

	public static var difficulties:Array<String> = [];

	public static var isDokiDoki:Bool = false;

	public static var normalSongs:Array<String> = 
	['welcome to the club', 'daydream', 'happy thoughts', 'cinnamon bun', 'trust',
	'manga', 'anime', 'tsundere', 'respect', 'novelty', 'shy', 'cup of tea', 'reflection',
	'poetry', 'writing tip', 'i advise', 'last dual', 'un-welcome to the club',
	'depression', 'hxppy thxughts', 'cxnnamon bxn', 'malnourished', 'pale', 'glitch',
	'yandere', 'obsessed', 'psychopath', 'revelation', 'lines of code', 'self-aware',
	'elevated access', 'script error', 'system failure'];
	public static var classicSongs:Array<String> = 
	['candy hearts', 'lavender mist', 'strawberry peppermint', 'candy heartz',
	'my song your note', 'play with me', 'poem panic', 'just monika',
	'doki forever', 'dark star', "you can't run", 'ultimate glitcher',
	'fresh literature', 'cupcakes', 'poems are forever', 'the final battle', 'your reality'];
	public static var bonusSongs:Array<String> = 
	['mon-ika', 'flower power', 'honeycomb', 'supernatural', 'spiders of markov',
	'yuri is a raccoon', 'amy likes ninjas', 'roar of natsuki', 'crossover clash', 'festival deluxe'];
	public static var songsList:Array<String> = 
	['welcome to the club', 'daydream', 'happy thoughts', 'cinnamon bun', 'trust',
	'manga', 'anime', 'tsundere', 'respect', 'novelty', 'shy', 'cup of tea', 'reflection',
	'poetry', 'writing tip', 'i advise', 'last dual', 'un-welcome to the club',
	'depression', 'hxppy thxughts', 'cxnnamon bxn', 'malnourished', 'pale', 'glitch',
	'yandere', 'obsessed', 'psychopath', 'revelation', 'lines of code', 'self-aware',
	'elevated access', 'script error', 'system failure',
	'candy hearts', 'lavender mist', 'strawberry peppermint', 'candy heartz',
	'my song your note', 'play with me', 'poem panic', 'just monika',
	'doki forever', 'dark star', "you can't run", 'ultimate glitcher',
	'fresh literature', 'cupcakes', 'poems are forever', 'the final battle', 'your reality',
	'mon-ika', 'flower power', 'honeycomb', 'supernatural', 'spiders of markov',
	'yuri is a raccoon', 'amy likes ninjas', 'roar of natsuki', 'crossover clash', 'festival deluxe'];
	public static var secretsList:Array<String> =
	['Amanda', 'Kinito', 'Spam', 'Pomni', 'Cyn', 'Funkin', 'Hallyboo', 'Sunshine', 'JustArt'];
	public static var poemsList:Array<String> =
	['SP1', 'SP2', 'SP3','SP4', 'SP5', 'SP6', 'SP7', 'SP8', 'SP9', 'SP10', 'SP11'];

	inline public static function quantize(f:Float, snap:Float){
		// changed so this actually works lol
		var m:Float = Math.fround(f * snap);
		trace(snap);
		return (m / snap);
	}

	public static function getDifficultyFilePath(num:Null<Int> = null)
	{
		if(num == null) num = PlayState.storyDifficulty;

		var fileSuffix:String = difficulties[num];
		if(fileSuffix != defaultDifficulty)
		{
			fileSuffix = '-' + fileSuffix;
		}
		else
		{
			fileSuffix = '';
		}
		return Paths.formatToSongPath(fileSuffix);
	}

	public static function difficultyString():String
	{
		return difficulties[PlayState.storyDifficulty].toUpperCase();
	}

	inline public static function boundTo(value:Float, min:Float, max:Float):Float {
		return Math.max(min, Math.min(max, value));
	}

	public static function coolTextFile(path:String):Array<String>
	{
		var daList:Array<String> = [];
		#if sys
		if(FileSystem.exists(path)) daList = File.getContent(path).trim().split('\n');
		#else
		if(Assets.exists(path)) daList = Assets.getText(path).trim().split('\n');
		#end

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}
	public static function listFromString(string:String):Array<String>
	{
		var daList:Array<String> = [];
		daList = string.trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}
	public static function dominantColor(sprite:flixel.FlxSprite):Int{
		var countByColor:Map<Int, Int> = [];
		for(col in 0...sprite.frameWidth){
			for(row in 0...sprite.frameHeight){
			  var colorOfThisPixel:Int = sprite.pixels.getPixel32(col, row);
			  if(colorOfThisPixel != 0){
				  if(countByColor.exists(colorOfThisPixel)){
				    countByColor[colorOfThisPixel] =  countByColor[colorOfThisPixel] + 1;
				  }else if(countByColor[colorOfThisPixel] != 13520687 - (2*13520687)){
					 countByColor[colorOfThisPixel] = 1;
				  }
			  }
			}
		 }
		var maxCount = 0;
		var maxKey:Int = 0;//after the loop this will store the max color
		countByColor[flixel.util.FlxColor.BLACK] = 0;
			for(key in countByColor.keys()){
			if(countByColor[key] >= maxCount){
				maxCount = countByColor[key];
				maxKey = key;
			}
		}
		return maxKey;
	}

	public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max)
		{
			dumbArray.push(i);
		}
		return dumbArray;
	}

	//uhhhh does this even work at all? i'm starting to doubt
	public static function precacheSound(sound:String, ?library:String = null):Void {
		precacheSoundFile(Paths.sound(sound, library));
	}

	public static function precacheMusic(sound:String, ?library:String = null):Void {
		precacheSoundFile(Paths.music(sound, library));
	}

	private static function precacheSoundFile(file:Dynamic):Void {
		if (Assets.exists(file, SOUND) || Assets.exists(file, MUSIC))
			Assets.getSound(file, true);
	}

	public static function browserLoad(site:String) {
		#if linux
		Sys.command('/usr/bin/xdg-open', [site]);
		#else
		FlxG.openURL(site);
		#end
	}

	public static function getUsername():String
	{
		if (!isRecording())
		{
			#if windows
			return Sys.environment()["USERNAME"].trim();
			#elseif (linux || macos)
			return Sys.environment()["USER"].trim();
			#else
			return 'Player';
			#end
		}
		else
		{
			return 'Player';
		}
	}

	public static function isRecording():Bool
	{
		#if FEATURE_OBS
		var isOBS:Bool = false;

		try
		{
			#if windows
			var taskList:Process = new Process('tasklist');
			#elseif (linux || macos)
			var taskList:Process = new Process('ps --no-headers');
			#end
			var readableList:String = taskList.stdout.readAll().toString().toLowerCase();

			for (i in 0...programList.length)
			{
				if (readableList.contains(programList[i]))
					isOBS = true;
			}

			taskList.close();
			readableList = '';
		}
		catch (e)
		{
			// If for some reason the game crashes when trying to run Process, just force OBS on
			// in case this happens when they're streaming.
			isOBS = true;
		}

		return isOBS;
		#else
		return false;
		#end
	}

	public static var _popups:Array<FileMessage> = [];
	public static function makeSecretFile(message:String, filename:String)
	{
		if (!FileSystem.exists("./clues/"))
			FileSystem.createDirectory("./clues/");

    	var path:String = "./clues/" + filename + ".txt";

		if (!FileSystem.exists("clues/" + filename + '.txt'))
		{
			File.saveContent(path, message + "\n");
			var popup:FileMessage = new FileMessage();
			_popups.push(popup);
		}
	}

	public static function playMusic(music:String, volume:Float = 1.0) {
		if (FileSystem.exists('assets/music/${music}-loop.ogg'))
		{
			FlxG.sound.play(Paths.music(music), volume, false, null, true, function()
			{
				FlxG.sound.playMusic(Paths.music(music + '-loop'), volume, true);
			});
		}
		else
			FlxG.sound.playMusic(Paths.music(music), volume, true);
	}

	public static function getTitleTheme() {
		if (TitleState.endEasterEgg)
			return 'TheDokiFinale';
		else
		{
			if (TitleState.classicEasterEgg)
				return 'storiesOfFriendshipAndGettinFreaky';
			else
				return 'DokiNightRemastered';
		}
	}

	inline public static function getRankLetter(acc:Int = 0):String
	{
		switch (acc)
		{
			case 100:
				return "P";
			case 99 | 98:
				return "S+";
			case 97 | 96| 95:
				return "S";
			case 94 | 93 | 92 | 91 | 90:
				return "A";
			case 89 | 88 | 87:
				return "B";
			case 86 | 85 | 84:
				return "C";
			case 83 | 82 | 81 | 80:
				return "D";
			case 79 | 78 | 77 | 76 | 75:
				return "E";
			case 74 | 73 | 72 | 71 | 70:
				return "F";
			case 69 | 68 | 67 | 66 | 65:
				return "G";
			case 64 | 63 | 62 | 61 | 60:
				return "H";
			default:
				return "L";
		}
	}

	inline public static function getRankName(letter:String = "", ?acc:Int = 0):String
	{
		if (letter != "")
		{
			switch (letter)
			{
				case "P":
					return "PERFECT";
				case "S+":
					return "SPECTACULAR";
				case "S":
					return "SUPER";
				case "A":
					return "AWESOME";
				case "B":
					return "BEAUTIFUL";
				case "C":
					return "COOL";
				case "D":
					return "DUMB";
				case "E":
					return "EMBARRASSING";
				case "F":
					return "FAILURE";
				case "G":
					return "GARBAGE";
				case "H":
					return "HORRIBLE";
				default:
					return "LOSER";
			}
		}
		else
		{
			switch (acc)
			{
				case 100:
					return "PERFECT";
				case 99 | 98:
					return "SPECTACULAR";
				case 97 | 96| 95:
					return "SUPER";
				case 94 | 93 | 92 | 91 | 90:
					return "AWESOME";
				case 89 | 88 | 87:
					return "BEAUTIFUL";
				case 86 | 85 | 84:
					return "COOL";
				case 83 | 82 | 81 | 80:
					return "DUMB";
				case 79 | 78 | 77 | 76 | 75:
					return "EMBARRASSING";
				case 74 | 73 | 72 | 71 | 70:
					return "FAILURE";
				case 69 | 68 | 67 | 66 | 65:
					return "GARBAGE";
				case 64 | 63 | 62 | 61 | 60:
					return "HORRIBLE";
				default:
					return "LOSER";
			}
		}
	}
}
