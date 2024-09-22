package states;

import flixel.input.mouse.FlxMouseEventManager;
import flixel.addons.display.FlxBackdrop;
import states.editors.ChartingState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.effects.FlxFlicker;
import flixel.tweens.FlxEase;
import lime.utils.Assets;
import openfl.utils.Assets as OpenFlAssets;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	private static var curSelected:Int = 0;
	private static var curDifficulty:Int = 1;

	private static var lastDifficultyName:String = '';
	var grpSymbols:FlxSpriteGroup;

	var accuracyText:FlxText;
	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var lerpRating:Float = 0;
	var lerpRank:String = "";
	var intendedScore:Int = 0;
	var intendedRating:Float = 0;
	var intendedRank:String = "";
	var rankSprite:FlxSprite;
	var characterSpr:FlxSprite;

	var regularSpr:FlxSprite;
	var dokiSpr:FlxSprite;

	var albumCover:FlxSprite;
	var discThing:FlxSprite;

	private var grpSongs:FlxTypedGroup<FreeplaySongItem>;
	private var curPlaying:Bool = false;

	var difficultyTitle:String = '';

	var curCategory:Int = 4;
	var categoryList:Array<String> = ["Monika", "Sayori", "Yuri", "Natsuki", "All", "Favs"];
	public static var favoriteSongs:Array<String> = [];

	var bfCleared:Bool = SaveData.bfRouteClear || SaveData.dokiBFRouteClear;
	var jrCleared:Bool = SaveData.jrRouteClear || SaveData.dokiJRRouteClear;
	var moniCleared:Bool = SaveData.monikaRouteClear || SaveData.dokiMONIRouteClear;

	var initSongList:Array<Array<Dynamic>> = [];

	override function create()
	{	
		FlxG.mouse.visible = true;
		MusicBeatState.reloadCursor();
		var mouseManager:FlxMouseEventManager = new FlxMouseEventManager();
		
		TitleState.setDefaultRGB();
		var titleBg:DDLCBorderBG;

		var endSuffix:String = "";

		titleBg = new DDLCBorderBG(Paths.image('gallery/scrollbit'), -10, 0);
		add(titleBg);

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		if (FlxG.save.data.favoriteSongs != null) {
			favoriteSongs = FlxG.save.data.favoriteSongs;
		}

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		initSongList = [
			['Welcome To The Club',		'all',		'Normal,Doki Doki',		[3, 6],		'act1',		bfCleared || jrCleared || moniCleared],
			['Daydream',				'sayori',	'Normal,Doki Doki',		[4, 5],		'act1',		bfCleared || jrCleared || moniCleared],
			['Happy Thoughts', 			'sayori', 	'Normal,Doki Doki', 	[3, 7], 	'act1', 	bfCleared || moniCleared],
			['Cinnamon Bun', 			'sayori', 	'Normal,Doki Doki', 	[5, 5], 	'act1', 	jrCleared],
			['Trust', 					'sayori', 	'Normal,Doki Doki', 	[4, 6], 	'act1', 	moniCleared],
			['Manga', 					'natsuki', 	'Normal,Doki Doki', 	[5, 9], 	'act1', 	bfCleared || moniCleared],
			['Anime', 					'natsuki', 	'Normal,Doki Doki', 	[4, 8],		'act1', 	jrCleared || moniCleared],
			['Tsundere', 				'natsuki', 	'Normal,Doki Doki', 	[5, 8], 	'act1', 	bfCleared || jrCleared],
			['Respect', 				'natsuki', 	'Normal,Doki Doki', 	[7, 12], 	'act1', 	moniCleared],
			['Novelty', 				'yuri', 	'Normal,Doki Doki', 	[4, 7], 	'act1', 	bfCleared || jrCleared || moniCleared],
			['Shy', 					'yuri', 	'Normal,Doki Doki', 	[4, 8], 	'act1', 	bfCleared],
			['Cup Of Tea', 				'yuri', 	'Normal,Doki Doki', 	[5, 6], 	'act1', 	jrCleared || moniCleared],
			['Reflection', 				'yuri', 	'Normal,Doki Doki', 	[4, 10], 	'act1', 	moniCleared],
			['Poetry', 					'monika', 	'Normal,Doki Doki', 	[4, 8], 	'act1', 	bfCleared || jrCleared],
			['Writing Tip', 			'monika', 	'Normal,Doki Doki', 	[5, 9], 	'act1', 	bfCleared || moniCleared],
			['I Advise', 				'monika', 	'Normal,Doki Doki', 	[4, 8], 	'act1', 	jrCleared || moniCleared],
			['Last Dual', 				'all', 		'Normal,Doki Doki', 	[5, 11], 	'act1', 	bfCleared || jrCleared],
			['Un-welcome To The Club', 	'all', 		'Normal,Doki Doki', 	[4, 9], 	'act2', 	bfCleared || jrCleared],
			['Depression', 				'sayori', 	'Normal,Doki Doki', 	[5, 7], 	'act2', 	bfCleared || jrCleared],
			['Hxppy Thxughts', 			'sayori', 	'Normal,Doki Doki', 	[6, 9], 	'act2', 	bfCleared],
			['Cxnnamon Bxn', 			'sayori', 	'Normal,Doki Doki', 	[7, 11], 	'act2', 	jrCleared],
			['Malnourished', 			'natsuki', 	'Normal,Doki Doki', 	[7, 13], 	'act2', 	bfCleared],
			['Pale', 					'natsuki', 	'Normal,Doki Doki', 	[8, 14], 	'act2', 	jrCleared],
			['Glitch', 					'natsuki', 	'Normal,Doki Doki', 	[9, 15], 	'act2', 	bfCleared || jrCleared],
			['Yandere', 				'yuri', 	'Normal,Doki Doki', 	[7, 12], 	'act2', 	bfCleared || jrCleared],
			['Obsessed', 				'yuri', 	'Normal,Doki Doki', 	[9, 16], 	'act2', 	bfCleared],
			['Psychopath', 				'yuri', 	'Normal,Doki Doki', 	[10, 16], 	'act2', 	jrCleared],
			['Revelation', 				'monika', 	'Normal,Doki Doki', 	[5, 10], 	'act3', 	moniCleared],
			['Lines Of Code', 			'monika', 	'Normal,Doki Doki', 	[11, 13], 	'act3', 	bfCleared || jrCleared],
			['Self-Aware', 				'monika', 	'Normal,Doki Doki', 	[7, 11], 	'act3', 	bfCleared || moniCleared],
			['Elevated Access', 		'monika', 	'Normal,Doki Doki', 	[7, 16], 	'act3', 	jrCleared || moniCleared],
			['Script Error', 			'sayori', 	'Normal,Doki Doki', 	[13, 19], 	'act3', 	bfCleared || jrCleared || moniCleared],
			['System Failure', 			'sayori', 	'Normal,Doki Doki', 	[16, 20], 	'act3', 	moniCleared]
		];

		grpSongs = new FlxTypedGroup<FreeplaySongItem>();
		grpSymbols = new FlxSpriteGroup();
		for (i in 0...6)
		{
			var sym:FlxSprite = new FlxSprite(90 * i, 26);
			sym.frames = Paths.getSparrowAtlas('freeplay/Normal/categories');
			sym.animation.addByPrefix('idle', categoryList[i] + ' Idle', 24, true);
			sym.animation.addByPrefix('select', categoryList[i] + ' Select', 24, true);
			sym.animation.play('idle', true);
			sym.ID = i;
			grpSymbols.add(sym);
		}
		changeCategory(0, false);
		
		add(grpSongs);

		var sidebar:FlxSprite = new FlxSprite(651, 25).loadGraphic(Paths.image('freeplay/Normal/sideBar'));
		add(sidebar);

		regularSpr = new FlxSprite(742, 52);
		regularSpr.frames = Paths.getSparrowAtlas('freeplay/Normal/difficulties');
		regularSpr.animation.addByPrefix('idle', 'Regular Idle', 24, true);
		regularSpr.animation.addByPrefix('select', 'Regular Select', 24, true);
		regularSpr.animation.play('idle', true);
		add(regularSpr);

		dokiSpr = new FlxSprite(1001, 52);
		dokiSpr.frames = Paths.getSparrowAtlas('freeplay/Normal/difficulties');
		dokiSpr.animation.addByPrefix('idle', 'Doki Doki Idle', 24, true);
		dokiSpr.animation.addByPrefix('select', 'Doki Doki Select', 24, true);
		dokiSpr.animation.play('idle', true);
		add(dokiSpr);

		var dokiLock:FlxSprite = new FlxSprite(1050, 10).loadGraphic(Paths.image('freeplay/Normal/locked'));
		add(dokiLock);

		var scoreBox:FlxSprite = new FlxSprite(938, 523).loadGraphic(Paths.image('freeplay/Normal/scoreInfo'));
		add(scoreBox);

		accuracyText = new FlxText(1069, 605, 123, "", 24);
		accuracyText.setFormat(Paths.font("doki-bold.ttf"), 24, FlxColor.WHITE, FlxTextAlign.RIGHT);
		add(accuracyText);

		scoreText = new FlxText(1069, 634, 123, "", 24);
		scoreText.setFormat(Paths.font("doki-bold.ttf"), 24, FlxColor.WHITE, FlxTextAlign.RIGHT);
		add(scoreText);

		rankSprite = new FlxSprite(975, 599);
		rankSprite.frames = Paths.getSparrowAtlas('freeplay/Normal/rankLetters');
		rankSprite.animation.addByPrefix('P', 'PERFECT Rank', 24, true);
		rankSprite.animation.addByPrefix('S+', 'SPECTACULAR Rank', 24, true);
		rankSprite.animation.addByPrefix('S', 'SUPER Rank', 24, true);
		rankSprite.animation.addByPrefix('A', 'AWESOME Rank', 24, true);
		rankSprite.animation.addByPrefix('B', 'BEAUTIFUL Rank', 24, true);
		rankSprite.animation.addByPrefix('C', 'COOL Rank', 24, true);
		rankSprite.animation.addByPrefix('D', 'DUMB Rank', 24, true);
		rankSprite.animation.addByPrefix('E', 'EMBERASSING Rank', 24, true);
		rankSprite.animation.addByPrefix('F', 'FAILURE Rank', 24, true);
		rankSprite.animation.addByPrefix('G', 'GARBAGE Rank', 24, true);
		rankSprite.animation.addByPrefix('H', 'HORRIBLE Rank', 24, true);
		rankSprite.animation.addByPrefix('L', 'LOSER Rank', 24, true);
		add(rankSprite);

		discThing = new FlxSprite(690, 210).loadGraphic(Paths.image('freeplay/Normal/albums/regular-disc'));
		discThing.setGraphicSize(401, 366);
		discThing.updateHitbox();
		discThing.angle = 0;
		add(discThing);

		albumCover = new FlxSprite(893, 175);
		if (CoolUtil.difficultyString() == "DOKI DOKI") albumCover.loadGraphic(Paths.image('freeplay/Normal/albums/doki-' + songs[curSelected].albumName));
		else albumCover.loadGraphic(Paths.image('freeplay/Normal/albums/regular-' + songs[curSelected].albumName));
		albumCover.setGraphicSize(344);
		albumCover.updateHitbox();
		albumCover.angle = -15;
		add(albumCover);

		add(grpSymbols);

		if(lastDifficultyName == '')
		{
			lastDifficultyName = CoolUtil.defaultDifficulty;
		}
		curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(lastDifficultyName)));
		
		changeSelection();
		changeDiff();

		var toptextBG:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, 26, 0xFF000000);
		add(toptextBG);

		var text:FlxText = new FlxText(1, 0, FlxG.width, 'Normal Songs', 20);
		text.setFormat(Paths.font("doki.ttf"), 20, FlxColor.WHITE, LEFT);
		text.scrollFactor.set();
		add(text);

		var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
		textBG.alpha = 0.7;
		add(textBG);
 
		var leText:String = "UP/DOWN - Select Song    LEFT/RIGHT - Select Difficulty    Q/E - Change Category    F - Favorite    SPACE - Change Player Character    CTRL - Gameplay Changers Menu";
		var size:Int = 16;

		var text:FlxText = new FlxText(textBG.x, textBG.y + 4, FlxG.width, leText, size);
		text.setFormat(Paths.font("doki.ttf"), size, FlxColor.WHITE, CENTER);
		text.scrollFactor.set();
		add(text);
		super.create();
	}

	override function closeSubState() {
		changeSelection(0, false);
		persistentUpdate = true;
		super.closeSubState();
	}

	public function addSong(songName:String, owner:String, songDifficulties:String, ratings:Array<Int>, album:String, unlocked:Bool)
	{
		songs.push(new SongMetadata(songName, owner, songDifficulties, ratings, album, unlocked));
	}

	var selectedSomethin:Bool = false;
	var holdTime:Float = 0;
	var instPlaying:Int = -1;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		grpSongs.forEach(function(txt:FreeplaySongItem)
		{
			txt.lockStatus(songs[txt.ID].unlocked);
		});

		if (songs[curSelected].unlocked) discThing.angle += 0.2;

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, CoolUtil.boundTo(elapsed * 24, 0, 1)));
		lerpRating = FlxMath.lerp(lerpRating, intendedRating, CoolUtil.boundTo(elapsed * 12, 0, 1));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;
		if (Math.abs(lerpRating - intendedRating) <= 0.01)
			lerpRating = intendedRating;

		scoreText.text = Std.string(lerpScore);
		accuracyText.text = Std.string(Highscore.floorDecimal(lerpRating * 100, 0));

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;
		var space = FlxG.keys.justPressed.SPACE;
		var ctrl = FlxG.keys.justPressed.CONTROL;

		if (songs.length > 0)
		{
			if (upP)
			{
				changeSelection(-1);
				holdTime = 0;
			}
			if (downP)
			{
				changeSelection(1);
				holdTime = 0;
			}

			if(controls.UI_DOWN || controls.UI_UP)
			{
				var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
				holdTime += elapsed;
				var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

				if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
				{
					changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -1 : 1));
					changeDiff();
				}
			}
		}

		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			CoolUtil.playMusic(CoolUtil.getTitleTheme(), 0);
			FlxTween.tween(FlxG.sound, {volume: 1}, 2);
			openSubState(new CustomFadeTransition(0.6, false, new ExtraStuffState()));
		}

		if (FlxG.keys.justPressed.Q)
		{
			curSelected = 0;
			if (songs.length > 0) changeSelection();
			if (favoriteSongs.length <= 0 && curCategory == 0)
			{
				curCategory = 4;
				changeCategory();
			}
			else changeCategory(-1);
		}
		if (FlxG.keys.justPressed.E)
		{
			curSelected = 0;
			if (songs.length > 0) changeSelection();
			if (favoriteSongs.length <= 0 && curCategory == 4)
			{
				curCategory = 0;
				changeCategory();
			}
			else changeCategory(1);
		}
		if (FlxG.keys.justPressed.F && songs.length > 0)
		{
			if (favoriteSongs.contains(songs[curSelected].songName)) {
				favoriteSongs.remove(songs[curSelected].songName);
				FlxG.save.data.favoriteSongs = favoriteSongs;
				FlxG.save.flush();
				grpSongs.forEach(function(txt:FreeplaySongItem)
				{
					if (txt.ID == curSelected) txt.heartAnim(false);
				});
			} else {
				favoriteSongs.push(songs[curSelected].songName);
				FlxG.save.data.favoriteSongs = favoriteSongs;
				FlxG.save.flush();
				grpSongs.forEach(function(txt:FreeplaySongItem)
				{
					if (txt.ID == curSelected) txt.heartAnim(true);
				});
			}
		}

		if(ctrl)
		{
			persistentUpdate = false;
			openSubState(new GameplayChangersSubstate());
		}
		else if(space)
		{
			persistentUpdate = false;
			openSubState(new PlayerSelectMenu());
		}
		else if (controls.ACCEPT && songs[curSelected].unlocked)
		{
			selectSong();
		}

		if (!selectedSomethin){
			grpSongs.forEach(function(txt:FreeplaySongItem)
			{
				if (FlxG.mouse.overlaps(txt) && FlxG.mouse.justPressed){
					if (curSelected != txt.ID){
						curSelected = txt.ID;
						changeSelection();
					}
					else
						selectSong();
				}
			});
		}
	}

	function selectSong()
	{
		selectedSomethin = true;
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		if (songs[curSelected].songName == 'Welcome To The Club' && curDifficulty != 1)
		{
			switch (ClientPrefs.playerChar)
			{
				case 1:
					PlayState.SONG = Song.loadFromJson('welcome-to-the-club-bf', songs[curSelected].songName.toLowerCase());
				case 2:
					PlayState.SONG = Song.loadFromJson('welcome-to-the-club-jr', songs[curSelected].songName.toLowerCase());
				case 3:
					PlayState.SONG = Song.loadFromJson('welcome-to-the-club-moni', songs[curSelected].songName.toLowerCase());
			}
		}
		else
		{
			var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
			PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
		}

		PlayState.isStoryMode = false;
		PlayState.storyDifficulty = curDifficulty;

		CustomFadeTransition.isHeartTran = true;

		grpSongs.forEach(function(spr:FreeplaySongItem)
		{
			if (curSelected != spr.ID)
			{
				FlxTween.tween(spr, {alpha: 0}, 0.4, {
					ease: FlxEase.quadOut,
					onComplete: function(twn:FlxTween)
					{
						spr.kill();
					}
				});
			}
			else
			{
				spr.selected();
				FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
				{
					openSubState(new CustomFadeTransition(0.4, false, new LoadingState(new PlayState(), true, false)));
					FlxG.sound.music.stop();
					FlxG.sound.music.volume = 0;
				});
			}
		});
	}

	function changeDiff(change:Int = 0, changeMusic:Bool = true)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = CoolUtil.difficulties.length-1;
		if (curDifficulty >= CoolUtil.difficulties.length)
			curDifficulty = 0;

		lastDifficultyName = CoolUtil.difficulties[curDifficulty];

		#if !switch
		if (songs[curSelected].songName == 'Welcome To The Club' && curDifficulty != 1)
		{
			switch (ClientPrefs.playerChar)
			{
				case 1:
					intendedScore = Highscore.getScore('Welcome To The Club (Boyfriend)', curDifficulty);
					intendedRating = Highscore.getRating('Welcome To The Club (Boyfriend)', curDifficulty);
				case 2:
					intendedScore = Highscore.getScore('Welcome To The Club (Bowser Jr)', curDifficulty);
					intendedRating = Highscore.getRating('Welcome To The Club (Bowser Jr)', curDifficulty);
				case 3:
					intendedScore = Highscore.getScore('Welcome To The Club (Monika)', curDifficulty);
					intendedRating = Highscore.getRating('Welcome To The Club (Monika)', curDifficulty);
			}
		}
		else
		{
			intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
			intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		}
		switch (Std.int(Highscore.floorDecimal(intendedRating * 100, 0)))
		{
			case 100:
				intendedRank = "P";
			case 99 | 98:
				intendedRank = "S+";
			case 97 | 96| 95:
				intendedRank = "S";
			case 94 | 93 | 92 | 91 | 90:
				intendedRank = "A";
			case 89 | 88 | 87:
				intendedRank = "B";
			case 86 | 85 | 84:
				intendedRank = "C";
			case 83 | 82 | 81 | 80:
				intendedRank = "D";
			case 79 | 78 | 77 | 76 | 75:
				intendedRank = "E";
			case 74 | 73 | 72 | 71 | 70:
				intendedRank = "F";
			case 69 | 68 | 67 | 66 | 65:
				intendedRank = "G";
			case 64 | 63 | 62 | 61 | 60:
				intendedRank = "H";
			default:
				intendedRank = "L";
		}
		if (intendedRating <= 0) rankSprite.visible = false;
		else rankSprite.visible = true;
		rankSprite.animation.play(intendedRank, true);
		#end

		PlayState.storyDifficulty = curDifficulty;
		switch (CoolUtil.difficultyString())
		{
			case 'DOKI DOKI':
				regularSpr.animation.play('idle', true);
				dokiSpr.animation.play('select', true);
			default:
				regularSpr.animation.play('select', true);
				dokiSpr.animation.play('idle', true);
		}

		grpSongs.forEach(function(txt:FreeplaySongItem)
		{
			txt.updateCompText(CoolUtil.difficultyString() == 'DOKI DOKI');
		});

		if (changeMusic) playDaMusic(CoolUtil.difficultyString() == 'DOKI DOKI');

		reloadAlbumCover();
		updateDifficultyNumber();
	}

	function changeSelection(change:Int = 0, playSound:Bool = true)
	{
		if(playSound) FlxG.sound.play(Paths.sound('scrollMenu'));

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		if (songs.length > 0)
		{
			#if !switch
			if (songs[curSelected].songName == 'Welcome To The Club' && curDifficulty != 1)
			{
				switch (ClientPrefs.playerChar)
				{
					case 1:
						intendedScore = Highscore.getScore('Welcome To The Club (Boyfriend)', curDifficulty);
						intendedRating = Highscore.getRating('Welcome To The Club (Boyfriend)', curDifficulty);
					case 2:
						intendedScore = Highscore.getScore('Welcome To The Club (Bowser Jr)', curDifficulty);
						intendedRating = Highscore.getRating('Welcome To The Club (Bowser Jr)', curDifficulty);
					case 3:
						intendedScore = Highscore.getScore('Welcome To The Club (Monika)', curDifficulty);
						intendedRating = Highscore.getRating('Welcome To The Club (Monika)', curDifficulty);
				}
			}
			else
			{
				intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
				intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
			}
			#end
		}

		var bulltrash:Int = 0;

		grpSongs.forEach(function(txt:FreeplaySongItem)
		{
			txt.targetY = bulltrash - curSelected;
			bulltrash++;

			txt.alpha = 0.5;
			if (txt.targetY == 0)
			{
				txt.alpha = 1;
			}
		});

		#if PRELOAD_ALL
		playDaMusic(CoolUtil.difficultyString() == 'DOKI DOKI');
		#end

		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		var diffStr:String = songs[curSelected].songDifficulties;
		if(diffStr != null) diffStr = diffStr.trim();

		if(diffStr != null && diffStr.length > 0)
		{
			var diffs:Array<String> = diffStr.split(',');
			var i:Int = diffs.length - 1;
			while (i > 0)
			{
				if(diffs[i] != null)
				{
					diffs[i] = diffs[i].trim();
					if(diffs[i].length < 1) diffs.remove(diffs[i]);
				}
				--i;
			}

			if(diffs.length > 0 && diffs[0].length > 0)
			{
				CoolUtil.difficulties = diffs;
			}
		}
		
		if(CoolUtil.difficulties.contains(CoolUtil.defaultDifficulty))
		{
			curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(CoolUtil.defaultDifficulty)));
		}
		else
		{
			curDifficulty = 0;
		}

		var newPos:Int = CoolUtil.difficulties.indexOf(lastDifficultyName);
		if(newPos > -1)
		{
			curDifficulty = newPos;
		}
		changeDiff();
	}

	function updateDifficultyNumber() {
		grpSongs.forEach(function(txt:FreeplaySongItem)
		{
			var difficultyLevels:Array<Int> = songs[txt.ID].diffRatings;
			if (difficultyLevels != null) {
				txt.reloadDiff(difficultyLevels[curDifficulty]);
			}
			else txt.reloadDiff(0);
		});
	}

	function reloadAlbumCover() {
		if (CoolUtil.difficultyString() == "DOKI DOKI") albumCover.loadGraphic(Paths.image('freeplay/Normal/albums/doki-' + songs[curSelected].albumName));
		else albumCover.loadGraphic(Paths.image('freeplay/Normal/albums/regular-' + songs[curSelected].albumName));
		albumCover.setGraphicSize(344);
		albumCover.updateHitbox();
		albumCover.angle = -15;

		if (CoolUtil.difficultyString() == "DOKI DOKI") discThing.loadGraphic(Paths.image('freeplay/Normal/albums/doki-disc'));
		else discThing.loadGraphic(Paths.image('freeplay/Normal/albums/regular-disc'));
		discThing.setGraphicSize(401, 366);
		discThing.updateHitbox();
		discThing.angle = 0;
	}

	function changeCategory(change:Int = 0, playSound:Bool = true)
	{
		curCategory += change;

		if (curCategory < 0)
			curCategory = categoryList.length - 1;
		if (curCategory >= categoryList.length)
			curCategory = 0;
		resetSongList(categoryList[curCategory]);
		resetItems();
		if(playSound) FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		grpSymbols.forEach(function(cyn:FlxSprite)
		{
			cyn.animation.play('idle', true);
			if (cyn.ID == curCategory) cyn.animation.play('select', true);
		});
		if (playSound) playDaMusic(CoolUtil.difficultyString() == 'DOKI DOKI');
	}
	function resetSongList(?order:String = "All")
	{
		if (songs.length > 0) {
			for (i in 0...songs.length) {
				songs.pop();
			}
		}
		switch (order)
		{
			case "Monika":
				for (i in 0...initSongList.length) {
					if (initSongList[i][1] == "monika") {
						addSong(initSongList[i][0], initSongList[i][1], initSongList[i][2], initSongList[i][3], initSongList[i][4], initSongList[i][5]);
					}
				}
			case "Sayori":
				for (i in 0...initSongList.length) {
					if (initSongList[i][1] == "sayori") {
						addSong(initSongList[i][0], initSongList[i][1], initSongList[i][2], initSongList[i][3], initSongList[i][4], initSongList[i][5]);
					}
				}
			case "Yuri":
				for (i in 0...initSongList.length) {
					if (initSongList[i][1] == "yuri") {
						addSong(initSongList[i][0], initSongList[i][1], initSongList[i][2], initSongList[i][3], initSongList[i][4], initSongList[i][5]);
					}
				}
			case "Natsuki":
				for (i in 0...initSongList.length) {
					if (initSongList[i][1] == "natsuki") {
						addSong(initSongList[i][0], initSongList[i][1], initSongList[i][2], initSongList[i][3], initSongList[i][4], initSongList[i][5]);
					}
				}
			case "Favs":
				for (i in 0...initSongList.length) {
					if (favoriteSongs.contains(initSongList[i][0])) {
						addSong(initSongList[i][0], initSongList[i][1], initSongList[i][2], initSongList[i][3], initSongList[i][4], initSongList[i][5]);
					}
				}
			default:
				for (i in 0...initSongList.length) {
					addSong(initSongList[i][0], initSongList[i][1], initSongList[i][2], initSongList[i][3], initSongList[i][4], initSongList[i][5]);
				}
		}
	}

	function resetItems()
	{
		if (grpSongs.length > 0)
			for (i in grpSongs) grpSongs.remove(i);

		for (i in 0...songs.length)
		{
			var difficultyLevels:Array<Int> = songs[i].diffRatings;
			var songText:FreeplaySongItem = new FreeplaySongItem(songs[i].songName, difficultyLevels[0]);
			songText.targetY = i;
			songText.antialiasing = true;
			songText.ID = i;
			grpSongs.add(songText);
			if (favoriteSongs.contains(songs[i].songName)) songText.heartAnim(true);
		}
	}

	function playDaMusic(?doki:Bool = false)
	{
		if (songs[curSelected].unlocked)
		{
			if (doki) FlxG.sound.playMusic(Paths.music('previews/doki-doki/' + Paths.formatToSongPath(songs[curSelected].songName)), 0);
			else {
				if (songs[curSelected].songName == 'Welcome To The Club')
				{
					switch (ClientPrefs.playerChar)
					{
						case 1:
							FlxG.sound.playMusic(Paths.music('previews/default/welcome-to-the-club-(boyfriend)'), 0);
						case 2:
							FlxG.sound.playMusic(Paths.music('previews/default/welcome-to-the-club-(bowser-jr)'), 0);
						case 3:
							FlxG.sound.playMusic(Paths.music('previews/default/welcome-to-the-club-(monika)'), 0);
					}
				}
				else FlxG.sound.playMusic(Paths.music('previews/default/' + Paths.formatToSongPath(songs[curSelected].songName)), 0);
			}
		}
		else FlxG.sound.music.stop();
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var owner:String = "";
	public var songDifficulties:String = '';
	public var diffRatings:Array<Int> = [];
	public var albumName:String = '';
	public var unlocked:Bool = false;

	public function new(song:String, owner:String, songDifficulties:String, difficultyRatings:Array<Int>, albumName:String, isUnlocked:Bool)
	{
		this.songName = song;
		this.owner = owner;
		this.songDifficulties = songDifficulties;
		this.diffRatings = difficultyRatings;
		this.albumName = albumName;
		this.unlocked = isUnlocked;
	}
}