package states;

import lime.app.Promise;
import lime.app.Future;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxTimer;
import flixel.math.FlxMath;
import flixel.ui.FlxBar;

import openfl.utils.Assets;
import lime.utils.Assets as LimeAssets;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

import haxe.io.Path;

class LoadingState extends MusicBeatState
{
	inline static var MIN_TIME = 1.0;

	// Browsers will load create(), you can make your song load a custom directory there
	// If you're compiling to desktop (or something that doesn't use NO_PRELOAD_ALL), search for getNextState instead
	// I'd recommend doing it on both actually lol
	
	// TO DO: Make this easier
	
	var target:FlxState;
	var stopMusic = false;
	var directory:String;
	var storyMode:Bool = false;
	//var callbacks:MultiCallback;
	var targettrash:Float = 0;

	var remainingTasks:Int = 1;
	var tasksCompleted:Int = 0;
	var filesToLoad:Array<String> = [];
	var faxList:Array<String> = [];
	var canLoad:Bool = true;
	var chibiList:Array<String> = [
		'bf',
		'jr',
		'monmon',
		'bf-and-jr',
		'sayo',
		'natki',
		'yuyu',
		'monsayo',
		'monyu',
		'monnat',
		'sayoyu',
		'sayonat',
		'yunat',
		'sad',
		'glitch',
		'demon',
		'her',
		//'dsfan2',
		//'5hark',
		//'cheeze',
		//'monika_fan',
		//'kron'
	];

	var txt:FlxText;

	var loadingSpr:FlxSprite;
	var chibiSpr:FlxSprite;
	var levelLoad:FlxText;
	var otherText:FlxText;
	var funFact:FlxText;

	public function new(target:FlxState, stopMusic:Bool, storyMode:Bool)
	{
		super();
		this.target = target;
		this.stopMusic = stopMusic;
		this.storyMode = storyMode;
	}

	var funkay:FlxSprite;
	var loadBar:FlxBar;
	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();
		//var bg:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xffcaff4d);
		var bg:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
		add(bg);

		if (storyMode)
		{
			for (n in PlayState.storyPlaylist)
			{
				if (WeekData.weekID.startsWith('Start')) faxList = CoolUtil.coolTextFile(Paths.txt('meta/StoryMode/Start'));
				else if (WeekData.weekID.startsWith('Sayori')) faxList = CoolUtil.coolTextFile(Paths.txt('meta/StoryMode/Sayori'));
				else if (WeekData.weekID.startsWith('Natsuki')) faxList = CoolUtil.coolTextFile(Paths.txt('meta/StoryMode/Natsuki'));
				else if (WeekData.weekID.startsWith('Yuri')) faxList = CoolUtil.coolTextFile(Paths.txt('meta/StoryMode/Yuri'));
				else if (WeekData.weekID.startsWith('Monika')) faxList = CoolUtil.coolTextFile(Paths.txt('meta/StoryMode/Monika'));
				else if (WeekData.weekID.startsWith('Others')) faxList = CoolUtil.coolTextFile(Paths.txt('meta/StoryMode/Others'));
				else if (WeekData.weekID.startsWith('Midway')) faxList = CoolUtil.coolTextFile(Paths.txt('meta/StoryMode/Midway'));
				else if (WeekData.weekID.startsWith('Sxyori')) faxList = CoolUtil.coolTextFile(Paths.txt('meta/StoryMode/Sxyori'));
				else if (WeekData.weekID.startsWith('Glitchsuki')) faxList = CoolUtil.coolTextFile(Paths.txt('meta/StoryMode/Glitchsuki'));
				else if (WeekData.weekID.startsWith('Yurdere')) faxList = CoolUtil.coolTextFile(Paths.txt('meta/StoryMode/Yurdere'));
				else if (WeekData.weekID.startsWith('Final')) faxList = CoolUtil.coolTextFile(Paths.txt('meta/StoryMode/Final'));
				else faxList = CoolUtil.coolTextFile(Paths.txt('meta/StoryMode/Start'));
			}
		}
		else
		{
			var name:String = PlayState.SONG.song;
        	if (name.toLowerCase() == 'welcome to the club (boyfriend)' || name.toLowerCase() == 'welcome to the club (bowser jr)' || name.toLowerCase() == 'welcome to the club (monika)')
    	        name = 'Welcome To The Club';
			faxList = CoolUtil.coolTextFile(Paths.txt('meta/' + Paths.formatToSongPath(name) + '/FunFacts'));
		}

		txt = new FlxText(0, 0, FlxG.width, remainingTasks);
		txt.size = 16;
		txt.setFormat(Paths.font('doki.ttf'), 16, FlxColor.WHITE, RIGHT);
		#if debug
		add(txt);
		#end
		
		initSongsManifest().onComplete
		(
			function (lib)
			{
				if (CoolUtil.difficultyString() == 'DOKI DOKI') loadSongAssetsDOKI(PlayState.SONG.song);
				else loadSongAssets(PlayState.SONG.song);
				Assets.loadLibrary("songs").onComplete(function(l) tasksCompleted++);

				var fadeTime = 0.00001;
				var loops = 0;
				FlxG.camera.fade(FlxG.camera.bgColor, fadeTime, true);
				new FlxTimer().start(fadeTime + MIN_TIME, function(t)
				{
					//tasksCompleted++;
					for (file in filesToLoad)
					{
						loops++;
						new FlxTimer().start(0.04 * loops, function(t){
							Assets.loadBitmapData(file).onComplete(function(s) {
								tasksCompleted++;
								filesToLoad.remove(file);
							});
						});
					}
				});
			}
		);
		loadingSpr = new FlxSprite(422, 22);
		loadingSpr.frames = Paths.getSparrowAtlas('loading/loading-spr');
		loadingSpr.animation.addByPrefix('anim', 'Loading', 24, true);
		loadingSpr.animation.play('anim', true);
		loadingSpr.alpha = 0;
		add(loadingSpr);

		var img:String = chibiList[FlxG.random.int(0, chibiList.length-1)];
		if (storyMode)
		{
			if (WeekData.weekID.startsWith('Start') || WeekData.weekID.startsWith('Midway')) 
			{	
				switch (ClientPrefs.playerChar)
				{
					case 1: img = 'bf';
					case 2: img = 'jr';
					case 3: img = 'monmon';
				}
			}
			else if (WeekData.weekID.startsWith('Sayori')) img = 'sayo';
			else if (WeekData.weekID.startsWith('Natsuki')) img = 'natki';
			else if (WeekData.weekID.startsWith('Yuri')) img = 'yuyu';
			else if (WeekData.weekID.startsWith('Monika')) img = 'monmon';
			else if (WeekData.weekID.startsWith('Others')) img = 'bf-and-jr';
			else if (WeekData.weekID.startsWith('Sxyori')) img = 'sad';
			else if (WeekData.weekID.startsWith('Glitchsuki')) img = 'glitch';
			else if (WeekData.weekID.startsWith('Yurdere')) img = 'demon';
			else if (WeekData.weekID.startsWith('Final')) img = 'her';
		}

		chibiSpr = new FlxSprite(422, 22).loadGraphic(Paths.image('loading/chibi/' + img));
		chibiSpr.alpha = 0;
		add(chibiSpr);

		levelLoad = new FlxText(6, -72, 0, '', 32);
		levelLoad.setFormat(Paths.font('dokiUI.ttf'), 32, FlxColor.WHITE, LEFT);
		levelLoad.alpha = 0;
		add(levelLoad);

		otherText = new FlxText(11, 638, 0, 'Fun Fact:', 32);
		otherText.setFormat(Paths.font('dokiUI.ttf'), 32, FlxColor.WHITE, LEFT);
		otherText.alpha = 0;
		add(otherText);

		funFact = new FlxText(8, 673, FlxG.width - 4, faxList[FlxG.random.int(0, faxList.length - 1)], 24);
		funFact.setFormat(Paths.font('dokiUI.ttf'), 24, FlxColor.WHITE, LEFT);
		funFact.alpha = 0;
		add(funFact);

		loadBar = new FlxBar(0, FlxG.height - 10, LEFT_TO_RIGHT, FlxG.width, 10, this, 'tasksCompleted', 0, remainingTasks);
		loadBar.createFilledBar(0xFF000000, FlxColor.WHITE);
		loadBar.numDivisions = 800; //How much lag this causes?? Should i tone it down to idk, 400 or 200?
		loadBar.screenCenter(X);
		add(loadBar);

		var diff:String = (CoolUtil.difficultyString() == 'DOKI DOKI' ? 'DOKI DOKI REMIX':'REGULAR');

		if (PlayState.isStoryMode)
		{
			levelLoad.text = 'Loading Stage: ' + WeekData.weekID + ' (' + diff + ')';
		}
		else
		{
			levelLoad.text = 'Loading Song: ' + PlayState.SONG.song + ' (' + diff + ')';
		}

		FlxTween.tween(loadingSpr, {alpha: 1, y: 102}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.1});
		FlxTween.tween(chibiSpr, {alpha: 1, y: 102}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.15});
		FlxTween.tween(levelLoad, {alpha: 1, y: 8}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.2});
		FlxTween.tween(otherText, {alpha: 1, y: 558}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(funFact, {alpha: 1, y: 593}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		txt.text = Std.string(tasksCompleted) + '/' + Std.string(remainingTasks);

		if (remainingTasks <= tasksCompleted && canLoad) {
			canLoad = false;
			onLoad();
		}
	}
	
	function onLoad()
	{
		if (stopMusic && FlxG.sound.music != null)
			FlxG.sound.music.stop();
		
		var bg2:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
		add(bg2);
		if (storyMode)
		{
			FlxTransitionableState.skipNextTransOut = true;
		}
		FlxG.switchState(target);
	}
	
	static function getSongPath()
	{
		return Paths.inst(PlayState.SONG.song);
	}
	
	static function getVocalPath()
	{
		return Paths.opponentvoices(PlayState.SONG.song);
	}
	static function getPlayerVocalPath()
	{
		return Paths.playervoices(PlayState.SONG.song);
	}
	
	static function isSoundLoaded(path:String):Bool
	{
		return Assets.cache.hasSound(path);
	}
	
	static function isLibraryLoaded(library:String):Bool
	{
		return Assets.getLibrary(library) != null;
	}
	
	override function destroy()
	{
		super.destroy();
		
	}
	
	static function initSongsManifest()
	{
		var id = "songs";
		var promise = new Promise<AssetLibrary>();

		var library = LimeAssets.getLibrary(id);

		if (library != null)
		{
			return Future.withValue(library);
		}

		var path = id;
		var rootPath = null;

		@:privateAccess
		var libraryPaths = LimeAssets.libraryPaths;
		if (libraryPaths.exists(id))
		{
			path = libraryPaths[id];
			rootPath = Path.directory(path);
		}
		else
		{
			if (StringTools.endsWith(path, ".bundle"))
			{
				rootPath = path;
				path += "/library.json";
			}
			else
			{
				rootPath = Path.directory(path);
			}
			@:privateAccess
			path = LimeAssets.__cacheBreak(path);
		}

		AssetManifest.loadFromFile(path, rootPath).onComplete(function(manifest)
		{
			if (manifest == null)
			{
				promise.error("Cannot parse asset manifest for library \"" + id + "\"");
				return;
			}

			var library = AssetLibrary.fromManifest(manifest);

			if (library == null)
			{
				promise.error("Cannot open library \"" + id + "\"");
			}
			else
			{
				@:privateAccess
				LimeAssets.libraries.set(id, library);
				library.onChange.add(LimeAssets.onChange.dispatch);
				promise.completeWith(Future.withValue(library));
			}
		}).onError(function(_)
		{
			promise.error("There is no asset library with an ID of \"" + id + "\"");
		});

		return promise.future;
	}

	function loadSongAssets(songName:String)
	{
		var songType:String = '';
		switch (Paths.formatToSongPath(songName))
		{
			case 'candy-hearts' | 'lavender-mist' | 'strawberry-peppermint' | 'candy-heartz' | 
			'my-song-your-note' | 'play-with-me' | 'poem-panic' | 'just-monika' | 'doki-forever'| 'dark-star'|
			"you-cant-run" | 'ultimate-glitcher' | 'fresh-literature' | 'cupcakes' | 'poems-are-forever' | 'the-final-battle' | 'your-reality':
				songType = 'Classic';
			case 'mon-ika' | 'flower-power' | 'honeycomb' | 'supernatural' | 
			'spiders-of-markov' | 'yuri-is-a-raccoon' | 'amy-likes-ninjas' | 'roar-of-natsuki' | 'crossover-clash' | 'festival-deluxe':
				songType = 'Bonus';
			default:
				songType = 'Normal';
		}
		switch (songType)
		{
			case 'Normal':
				pushFile('assets/images/characters/BOYFRIEND.png');
				pushFile('assets/images/characters/BowserJrDefaultAssets.png');
				pushFile('assets/images/characters/monika_new_assets.png');
				pushFile('assets/images/characters/bf_scared.png');
				pushFile('assets/images/characters/BowserJrScaredAssets.png');
				pushFile('assets/images/characters/monika_scared.png');
				pushFile('assets/images/characters/BowserJrAngryAssets.png');
				pushFile('assets/images/characters/Monika_NEO.png');
				pushFile('assets/images/characters/BOYFRIEND_DEAD.png');
				pushFile('assets/images/characters/BowserJrDEAD.png');
				pushFile('assets/images/characters/monika_dead.png');
				pushFile('assets/images/characters/player_game-over.png');
				pushFile('assets/images/characters/Monika_NEO_Dead.png');
				pushFile('assets/images/characters/GF_assets.png');
				pushFile('assets/images/characters/SpeakersOnly.png');
				pushFile('assets/images/characters/sayori_new_assets.png');
				pushFile('assets/images/characters/natsuki_new_assets.png');
				pushFile('assets/images/characters/yuri_new_assets.png');
				pushFile('assets/images/characters/yurdere_new_assets.png');
				pushFile('assets/images/characters/just-monika_assets.png');
				pushFile('assets/images/characters/upset-monika_assets.png');
				pushFile('assets/images/characters/rage-monika_assets.png');
				pushFile('assets/images/characters/sayori_evil_assets.png');
				pushFile('assets/images/stages/club/bg.png');
				pushFile('assets/images/stages/club/monika-back.png');
				pushFile('assets/images/stages/club/sayori-back.png');
				pushFile('assets/images/stages/club/yuri-back.png');
				pushFile('assets/images/stages/club/natsuki-back.png');
				pushFile('assets/images/stages/hallway/bg.png');
				pushFile('assets/images/stages/club/bg_skill.png');
				pushFile('assets/images/stages/s-room/bg.png');
				pushFile('assets/images/stages/spaceroom/space-bg.png');
				pushFile('assets/images/stages/spaceroom/bg.png');
				pushFile('assets/images/stages/spaceroom/table.png');
				pushFile('assets/images/stages/spaceroom/animatedClubroomGlitch.png');
				pushFile('assets/images/finale/bg_static.png');
				pushFile('assets/images/finale/backGlitchScroll.png');
				pushFile('assets/images/finale/deadgirls.png');
				pushFile('assets/images/finale/err.png');
				pushFile('assets/images/finale/fg.png');
				pushFile('assets/images/finale/frontGlitchScroll.png');
				pushFile('assets/images/finale/glitch1.png');
				pushFile('assets/images/finale/glitch2.png');
				pushFile('assets/images/finale/glitch3.png');
				pushFile('assets/images/finale/s-room.png');
				pushFile('assets/images/finale/hall.png');
			case 'Classic':
				pushFile('assets/images/characters/BOYFRIEND.png');
				pushFile('assets/images/characters/monika_new_assets.png');
				pushFile('assets/images/characters/bf_scared.png');
				pushFile('assets/images/characters/Monika_NEO.png');
				pushFile('assets/images/characters/BOYFRIEND_DEAD.png');
				pushFile('assets/images/characters/monika_dead.png');
				pushFile('assets/images/characters/player_game-over.png');
				pushFile('assets/images/characters/Monika_NEO_Dead.png');
				pushFile('assets/images/characters/GF_assets.png');
				pushFile('assets/images/characters/sayori_new_assets.png');
				pushFile('assets/images/characters/natsuki_new_assets.png');
				pushFile('assets/images/characters/yuri_new_assets.png');
				pushFile('assets/images/characters/yurdere_new_assets.png');
				pushFile('assets/images/characters/just-monika_assets.png');
				pushFile('assets/images/characters/upset-monika_assets.png');
				pushFile('assets/images/characters/rage-monika_assets.png');
				pushFile('assets/images/characters/sayori_evil_assets.png');
				pushFile('assets/images/stages/club/bg_club-v1.png');
				pushFile('assets/images/stages/club/monika-back.png');
				pushFile('assets/images/stages/club/sayori-back.png');
				pushFile('assets/images/stages/club/yuri-back.png');
				pushFile('assets/images/stages/club/natsuki-back.png');
				pushFile('assets/images/stages/hallway/bg.png');
				pushFile('assets/images/stages/club/bg_skill-v1.png');
				pushFile('assets/images/stages/s-room/bg.png');
				pushFile('assets/images/stages/spaceroom/space-bg.png');
				pushFile('assets/images/stages/spaceroom/bg.png');
				pushFile('assets/images/stages/spaceroom/table.png');
				pushFile('assets/images/stages/spaceroom/animatedClubroomGlitch.png');
				pushFile('assets/images/stages/void/bg.png');
			case 'Bonus':
				pushFile('assets/images/characters/BOYFRIEND.png');
				pushFile('assets/images/characters/bonus/BOYFRIEND-shade.png');
				pushFile('assets/images/characters/bonus/stuck-bf.png');
				pushFile('assets/images/characters/Doki_MonikaNonPixel_Assets.png');
				pushFile('assets/images/characters/Doki_Sayo_Assets.png');
				pushFile('assets/images/characters/Doki_Yuri_Assets.png');
				pushFile('assets/images/characters/Doki_Nat_Assets.png');
				pushFile('assets/images/characters/BowserJrDefaultAssets.png');
				pushFile('assets/images/characters/BOYFRIEND_DEAD.png');
				pushFile('assets/images/characters/DDTO-GameOver.png');
				pushFile('assets/images/characters/BowserJrDEAD.png');
				pushFile('assets/images/characters/monika_dead.png');
				pushFile('assets/images/characters/player_game-over.png');
				pushFile('assets/images/characters/bonus/mer-monika.png');
				pushFile('assets/images/characters/bonus/flower-monika.png');
				pushFile('assets/images/characters/bonus/flower-monika-shade.png');
				pushFile('assets/images/characters/bonus/sayorbee.png');
				pushFile('assets/images/characters/bonus/ghostyori.png');
				pushFile('assets/images/characters/bonus/yurachnae.png');
				pushFile('assets/images/characters/bonus/raccoon-yuri.png');
				pushFile('assets/images/characters/monika_new_assets.png');
				pushFile('assets/images/characters/sayori_new_assets.png');
				pushFile('assets/images/characters/natsuki_new_assets.png');
				pushFile('assets/images/characters/bonus/ninja-natsuki.png');
				pushFile('assets/images/characters/bonus/Buffsuki.png');
				pushFile('assets/images/characters/yurdere_new_assets.png');
				pushFile('assets/images/characters/just-monika_assets.png');
				pushFile('assets/images/characters/upset-monika_assets.png');
				pushFile('assets/images/stages/beach/clouds.png');
				pushFile('assets/images/stages/beach/fg.png');
				pushFile('assets/images/stages/beach/ocean.png');
				pushFile('assets/images/stages/beach/ship.png');
				pushFile('assets/images/stages/beach/sky.png');
				pushFile('assets/images/stages/beach/trees.png');
				pushFile('assets/images/stages/beach/waves-animated.png');
				pushFile('assets/images/stages/beach/bg-lowquality.png');
				pushFile('assets/images/stages/field/bg.png');
				pushFile('assets/images/stages/field/fg.png');
				pushFile('assets/images/stages/beehive/bg.png');
				pushFile('assets/images/stages/beehive/fg.png');
				pushFile('assets/images/stages/beehive/honey-back.png');
				pushFile('assets/images/stages/beehive/honey-front.png');
				pushFile('assets/images/stages/graveyard/bg.png');
				pushFile('assets/images/stages/graveyard/fg.png');
				pushFile('assets/images/stages/pyramid/bg.png');
				pushFile('assets/images/stages/pyramid/fg.png');
				pushFile('assets/images/stages/pyramid/pillars.png');
				pushFile('assets/images/stages/pyramid/torch.png');
				pushFile('assets/images/stages/pyramid/web.png');
				pushFile('assets/images/stages/pyramid/weird-vingette.png');
				pushFile('assets/images/stages/mario-level/bg.png');
				pushFile('assets/images/stages/mario-level/fg.png');
				pushFile('assets/images/stages/mario-level/clouds1.png');
				pushFile('assets/images/stages/mario-level/clouds2.png');
				pushFile('assets/images/stages/mario-level/mushrooms.png');
				pushFile('assets/images/stages/mario-level/vines.png');
				pushFile('assets/images/stages/ninja-hideaway/bg.png');
				pushFile('assets/images/stages/boxing-ring/bg.png');
				pushFile('assets/images/stages/boxing-ring/fg.png');
				pushFile('assets/images/stages/boxing-ring/jumbotron/screens.png');
				pushFile('assets/images/stages/boxing-ring/jumbotron/1text1.png');
				pushFile('assets/images/stages/boxing-ring/jumbotron/1text2.png');
				pushFile('assets/images/stages/boxing-ring/jumbotron/2text1.png');
				pushFile('assets/images/stages/boxing-ring/jumbotron/2text2.png');
				pushFile('assets/images/stages/boxing-ring/jumbotron/3text1.png');
				pushFile('assets/images/stages/boxing-ring/jumbotron/3text2.png');
				pushFile('assets/images/stages/boxing-ring/jumbotron/5text1.png');
				pushFile('assets/images/stages/boxing-ring/jumbotron/5text2.png');
				pushFile('assets/images/stages/boxing-ring/jumbotron/6text1.png');
				pushFile('assets/images/stages/boxing-ring/jumbotron/6text2.png');
				pushFile('assets/images/stages/ddto/DDLCbg.png');
				pushFile('assets/images/stages/ddto/DDLCfarbg.png');
				pushFile('assets/images/stages/ddto/DesksFront.png');
				pushFile('assets/images/stages/ddto/monika.png');
				pushFile('assets/images/stages/ddto/sayori.png');
				pushFile('assets/images/stages/ddto/yuri.png');
				pushFile('assets/images/stages/ddto/natsuki.png');
				pushFile('assets/images/stages/club/monika-back.png');
				pushFile('assets/images/stages/club/sayori-back.png');
				pushFile('assets/images/stages/club/yuri-back.png');
				pushFile('assets/images/stages/club/natsuki-back.png');
				pushFile('assets/images/stages/club/bg_skill.png');
				pushFile('assets/images/stages/s-room/bg.png');
				pushFile('assets/images/stages/spaceroom/space-bg.png');
				pushFile('assets/images/stages/spaceroom/bg.png');
				pushFile('assets/images/stages/spaceroom/table.png');
				pushFile('assets/images/stages/spaceroom/animatedClubroomGlitch.png');
		}
		pushFile('assets/images/bars/healthBar.png');
		pushFile('assets/images/bars/meter.png');
		pushFile('assets/images/bars/timeBar.png');
		pushFile('assets/images/effectz/bang.png');
		pushFile('assets/images/effectz/BSOD-draw.png');
		pushFile('assets/images/effectz/BSOD-QR.png');
		pushFile('assets/images/effectz/circle.png');
		pushFile('assets/images/effectz/flash.png');
		pushFile('assets/images/effectz/lines.png');
		pushFile('assets/images/effectz/star.png');
		pushFile('assets/images/hacks/moniA.png');
		pushFile('assets/images/hacks/moniB.png');
		pushFile('assets/images/hacks/moniC.png');
		pushFile('assets/images/hacks/popUp.png');
		pushFile('assets/images/hudFolders/defaultUI/sick.png');
		pushFile('assets/images/hudFolders/defaultUI/good.png');
		pushFile('assets/images/hudFolders/defaultUI/bad.png');
		pushFile('assets/images/hudFolders/defaultUI/trash.png');
		pushFile('assets/images/hudFolders/defaultUI/botplay.png');
		pushFile('assets/images/hudFolders/defaultUI/combo.png');
		pushFile('assets/images/hudFolders/defaultUI/practice.png');
		pushFile('assets/images/hudFolders/defaultUI/ready.png');
		pushFile('assets/images/hudFolders/defaultUI/set.png');
		pushFile('assets/images/hudFolders/defaultUI/go.png');
		pushFile('assets/images/hudFolders/defaultUI/num0.png');
		pushFile('assets/images/hudFolders/defaultUI/num1.png');
		pushFile('assets/images/hudFolders/defaultUI/num2.png');
		pushFile('assets/images/hudFolders/defaultUI/num3.png');
		pushFile('assets/images/hudFolders/defaultUI/num4.png');
		pushFile('assets/images/hudFolders/defaultUI/num5.png');
		pushFile('assets/images/hudFolders/defaultUI/num6.png');
		pushFile('assets/images/hudFolders/defaultUI/num7.png');
		pushFile('assets/images/hudFolders/defaultUI/num8.png');
		pushFile('assets/images/hudFolders/defaultUI/num9.png');
		pushFile('assets/images/icons/icon-bf.png');
		pushFile('assets/images/icons/icon-jr.png');
		pushFile('assets/images/icons/icon-monika.png');
		pushFile('assets/images/icons/icon-monika-giga.png');
		pushFile('assets/images/icons/icon-monika-upset.png');
		pushFile('assets/images/icons/icon-monika-rage.png');
		pushFile('assets/images/icons/icon-monika-neo.png');
		pushFile('assets/images/icons/icon-monika_ddto.png');
		pushFile('assets/images/icons/icon-mon-ika.png');
		pushFile('assets/images/icons/icon-sayori.png');
		pushFile('assets/images/icons/icon-sxyori.png');
		pushFile('assets/images/icons/icon-sayorivil.png');
		pushFile('assets/images/icons/icon-ghost.png');
		pushFile('assets/images/icons/icon-sayori_ddto.png');
		pushFile('assets/images/icons/icon-yuri.png');
		pushFile('assets/images/icons/icon-yurdere.png');
		pushFile('assets/images/icons/icon-raccoon-yuri.png');
		pushFile('assets/images/icons/icon-natsuki.png');
		pushFile('assets/images/icons/icon-glitchsuki.png');
		pushFile('assets/images/icons/icon-buffsuki.png');
		pushFile('assets/images/noteSkins/Regular.png');
		pushFile('assets/images/noteSkins/HURTRegular.png');
		pushFile('assets/images/noteSplashes/Regular.png');
		pushFile('assets/images/noteSplashes/HURTRegular.png');
	}

	function loadSongAssetsDOKI(songName:String)
	{
		pushFile('assets/images/characters/BOYFRIEND.png');
		pushFile('assets/images/characters/BowserJrDefaultAssets.png');
		pushFile('assets/images/characters/monika_new_assets.png');
		pushFile('assets/images/characters/BOYFRIEND_DEAD.png');
	}

	function pushFile(path:String)
	{
		if (FileSystem.exists(path))
		{
			filesToLoad.push(path);
			remainingTasks++;
		}
	}
}