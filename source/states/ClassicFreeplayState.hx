package states;

import flixel.input.mouse.FlxMouseEventManager;
import backend.Song.SwagSong;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.effects.FlxFlicker;
import flixel.addons.transition.FlxTransitionableState;

class ClassicFreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadatatwo> = [];
	private static var curSelected:Int = 0;
	private static var curDifficulty:Int = 1;

	private static var lastDifficultyName:String = '';

	var composerText:FlxText;
	var scoreText:FlxText;
	var accuracyText:FlxText;
	var rankText:FlxText;
	var ratingText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var lerpRating:Float = 0;
	var lerpRank:String = "";
	var intendedScore:Int = 0;
	var intendedRating:Float = 0;
	var intendedRank:String = "";
	var diff:FlxSprite;
	var bg:FlxSprite;

	private var grpSongs:FlxTypedGroup<FlxText>;

	private var iconArray:Array<HealthIcon> = [];

	var isDebug:Bool = false;

	public static var songData:Map<String, Array<SwagSong>> = [];

	var difficultyTitle:String = '';

	override function create()
	{		
		FlxG.mouse.visible = true;
		MusicBeatState.reloadCursor();
		#if debug
		isDebug = true;
		#end

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		addSong('Candy Hearts', 		'Sayori', 	'sayori', 		'Normal,Doki Doki',	[2, 5]);
		addSong('Lavender Mist', 		'Yuri', 	'yuri', 		'Normal,Doki Doki',	[2, 6]);
		addSong('Strawberry Peppermint','Natsuki', 	'natsuki', 		'Normal,Doki Doki', [3, 7]);
		addSong('Candy Heartz', 		'Sayori', 	'sxyori', 		'Normal,Doki Doki', [1, 8]);
		addSong('My Song Your Note', 	'Monika', 	'monika', 		'Normal,Doki Doki', [3, 7]);
		addSong('Play With Me', 		'Natsuki', 	'glitchsuki',	'Normal,Doki Doki', [6, 9]);
		addSong('Poem Panic', 			'Yuri', 	'yurdere', 		'Normal,Doki Doki', [7, 13]);
		addSong('Just Monika', 			'Monika', 	'monika-giga', 	'Normal,Doki Doki', [6, 10]);
		addSong('Doki Forever', 		'Monika', 	'monika-giga', 	'Normal,Doki Doki', [8, 12]);
		addSong('Dark Star', 			'Monika', 	'monika-upset', 'Normal,Doki Doki', [8, 13]);
		addSong("You Can't Run", 		'Monika', 	'monika-rage', 	'Normal,Doki Doki', [14, 18]);
		addSong('Ultimate Glitcher', 	'Monika', 	'monika-rage', 	'Normal,Doki Doki', [16, 20]);
		addSong('Fresh Literature', 	'Sayori', 	'sayori', 		'Normal,Doki Doki', [4, 7]);
		addSong('Cupcakes', 			'Natsuki', 	'natsuki', 		'Normal,Doki Doki', [5, 8]);
		addSong('Poems Are Forever', 	'Yuri', 	'yuri', 		'Normal,Doki Doki', [5, 7]);
		addSong('The Final Battle', 	'Sayori', 	'sayorivil', 	'Normal,Doki Doki', [14, 19]);
		addSong('Your Reality', 		'Monika', 	'monika', 		'Normal,Doki Doki', [3, 9]);
		

		persistentUpdate = persistentDraw = true;

		bg = new FlxSprite(0, 0).loadGraphic(Paths.image('freeplay/Classic/ClassicFreeplayMenu'));
		add(bg);

		grpSongs = new FlxTypedGroup<FlxText>();
		add(grpSongs);

		var tex = Paths.getSparrowAtlas('freeplay/Classic/classic_songlist_assets');

		for (i in 0...songs.length)
		{
			var songText:FlxText = new FlxText(441, 123, 0, songs[i].songName);
			songText.setFormat(Paths.font("Halogen.ttf"), 25, FlxColor.BLACK, FlxTextAlign.CENTER);
			songText.y += i;
			songText.borderStyle = OUTLINE;
			songText.borderColor = 0xFFFF7FEE;
			songText.antialiasing = true;
			songText.ID = i;
			grpSongs.add(songText);

			switch (i)
			{
				case 0:
					songText.y = 120;
				case 1:
					songText.y = (122 + 45);
				case 2:
					songText.y = (123 + (45 * 2));
				case 3:
					songText.y = (123 + (45 * 3));
				case 4:
					songText.y = (123 + (45 * 4));
				case 5:
					songText.y = (123 + (45 * 5));
				case 6:
					songText.y = (125 + (45 * 6));
				case 7 | 12:
					songText.y = (125 + (45 * 7));
				case 8 | 13:
					songText.y = (125 + (45 * 8));
				case 9 | 14:
					songText.y = (125 + (45 * 9));
				case 10 | 15:
					songText.y = (125 + (45 * 10));
				case 11 | 16:
					songText.y = (125 + (45 * 11));
			}
			if (i < 12)
				songText.x = 441;

			if (i > 11)
				songText.x = 669;

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			iconArray.push(icon);
			icon.x = 100;
			icon.y = 500;
			icon.scale.set(1.6, 1.6);
			add(icon);
		}

		var daText1:FlxText = new FlxText(441, 60, 0, "Original Version", 24);
		daText1.setFormat(Paths.font("Halogen.ttf"), 24, FlxColor.BLACK, FlxTextAlign.CENTER);
		daText1.scrollFactor.set();
		add(daText1);

		var daText2:FlxText = new FlxText(739, 60, 0, "Plus Version", 24);
		daText2.setFormat(Paths.font("Halogen.ttf"), 24, FlxColor.BLACK, FlxTextAlign.CENTER);
		daText2.scrollFactor.set();
		add(daText2);

		composerText = new FlxText(30, 100, FlxG.width, "", 8);
		composerText.setFormat(Paths.font("Halogen.ttf"), 28, FlxColor.BLACK, FlxTextAlign.LEFT);
		composerText.antialiasing = true;
		add(composerText);

		scoreText = new FlxText(30, 148, FlxG.width, "", 8);
		scoreText.setFormat(Paths.font("Halogen.ttf"), 28, FlxColor.BLACK, FlxTextAlign.LEFT);
		scoreText.antialiasing = true;
		add(scoreText);

		accuracyText = new FlxText(30, 190, FlxG.width, "", 8);
		accuracyText.setFormat(Paths.font("Halogen.ttf"), 28, FlxColor.BLACK, FlxTextAlign.LEFT);
		accuracyText.antialiasing = true;
		add(accuracyText);

		rankText = new FlxText(30, 235, FlxG.width, "", 8);
		rankText.setFormat(Paths.font("Halogen.ttf"), 28, FlxColor.BLACK, FlxTextAlign.LEFT);
		rankText.antialiasing = true;
		add(rankText);

		ratingText = new FlxText(30, 280, FlxG.width, "", 8);
		ratingText.setFormat(Paths.font("Halogen.ttf"), 28, FlxColor.BLACK, FlxTextAlign.LEFT);
		ratingText.antialiasing = true;
		add(ratingText);

		diffText = new FlxText(31, 52, 365, "", 24);
		diffText.setFormat(Paths.font("Halogen.ttf"), 28, FlxColor.BLACK, FlxTextAlign.CENTER);
		diffText.scrollFactor.set();
		add(diffText);

		if(lastDifficultyName == '')
		{
			lastDifficultyName = CoolUtil.defaultDifficulty;
		}
		curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(lastDifficultyName)));

		changeItem(0, false);
		changeDiff(0, false);

		var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
		textBG.alpha = 0.6;
		add(textBG);
 
		#if PRELOAD_ALL
		var leText:String = "Press SPACE to listen to the Song / Press CTRL to open the Gameplay Changers Menu";
		var size:Int = 16;
		#else
		var leText:String = "Press CTRL to open the Gameplay Changers Menu";
		var size:Int = 18;
		#end
		var text:FlxText = new FlxText(textBG.x, textBG.y + 1, FlxG.width, leText, size);
		text.setFormat(Paths.font("doki.ttf"), size, FlxColor.WHITE, CENTER);
		text.scrollFactor.set();
		add(text);

		super.create();
	}

	public function addSong(songName:String, owner:String, songCharacter:String, songDifficulties:String, ratings:Array<Int>)
	{
		songs.push(new SongMetadatatwo(songName, owner, songCharacter, songDifficulties, ratings));
	}

	var selectedSomethin:Bool = false;
	var holdTime:Float = 0;
	var instPlaying:Int = -1;
	private static var vocals:FlxSound = null;

	override function update(elapsed:Float)
	{
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, CoolUtil.boundTo(elapsed * 24, 0, 1)));
		lerpRating = FlxMath.lerp(lerpRating, intendedRating, CoolUtil.boundTo(elapsed * 12, 0, 1));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;
		if (Math.abs(lerpRating - intendedRating) <= 0.01)
			lerpRating = intendedRating;

		var ratingSplit:Array<String> = Std.string(Highscore.floorDecimal(lerpRating * 100, 0)).split('.');
		if(ratingSplit.length < 2) { //No decimals, add an empty space
			ratingSplit.push('');
		}
		
		while(ratingSplit[1].length < 2) { //Less than 2 decimals in it, add decimals then
			ratingSplit[1] += '0';
		}

		scoreText.text = 'Highscore: ' + lerpScore;
		accuracyText.text = 'Clear Percent: ' + Std.string(Highscore.floorDecimal(lerpRating * 100, 0)) + "%";
		composerText.text = CoolSongBlurb.getMainComposer(songs[curSelected].songName);

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;
		var space = FlxG.keys.justPressed.SPACE;
		var ctrl = FlxG.keys.justPressed.CONTROL;


		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}
		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0;
		}

		if (iconArray.length > 0)
			iconArray[curSelected].alpha = 1;

		if (upP)
		{
			changeItem(-1);
			holdTime = 0;
		}

		if (downP)
		{
			changeItem(1);
			holdTime = 0;
		}

		if(controls.UI_DOWN || controls.UI_UP)
		{
			var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
			holdTime += elapsed;
			var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);
						
			if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
			{
				changeItem((checkNewHold - checkLastHold) * (controls.UI_UP ? -1 : 1));
				changeDiff();
			}
		}

		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			CoolUtil.playMusic(CoolUtil.getTitleTheme(), 0);
			openSubState(new CustomFadeTransition(0.6, false, new ExtraStuffState()));
		}

		if(ctrl)
		{
			persistentUpdate = false;
			openSubState(new GameplayChangersSubstate());
		}
		else if (controls.ACCEPT)
		{
			selectSong();
		}

		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		if (!selectedSomethin){
			grpSongs.forEach(function(spr:FlxText)
			{
				if (FlxG.mouse.overlaps(spr)){
					if (curSelected != spr.ID){
						curSelected = spr.ID;
						changeItem();
					}
					if (FlxG.mouse.justPressed)
						selectSong();
				}
			});
		}

		super.update(elapsed);
	}

	function changeDiff(change:Int = 0, changeMusic:Bool = true):Void
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = CoolUtil.difficulties.length-1;
		if (curDifficulty >= CoolUtil.difficulties.length)
			curDifficulty = 0;

		lastDifficultyName = CoolUtil.difficulties[curDifficulty];

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
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
		if (intendedRating <= 0) rankText.visible = false;
		else rankText.visible = true;
		rankText.text = "Best Rank: " + intendedRank;
		#end

		PlayState.storyDifficulty = curDifficulty;
		switch (CoolUtil.difficultyString())
		{
			case 'DOKI DOKI':
				difficultyTitle = 'DOKI DOKI REMIX';
			default:
				difficultyTitle = 'REGULAR';
		}
		diffText.text = '< ' + difficultyTitle + ' >';
		ratingText.text = "Difficulty Level: " + songs[curSelected].diffRatings[curDifficulty];
		if (changeMusic) playDaMusic(CoolUtil.difficultyString() == 'DOKI DOKI');
	}

	function changeItem(huh:Int = 0, ?playSound:Bool = true)
	{
		if (playSound) FlxG.sound.play(Paths.sound('scrollMenu'));
		curSelected += huh;

		if (curSelected >= songs.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = songs.length - 1;

		grpSongs.forEach(function(spr:FlxText)
		{
			if (spr.ID != curSelected)
				spr.setBorderStyle(OUTLINE, 0x00FF7FEE, 1, 1);
			else
				spr.setBorderStyle(OUTLINE, 0xFFFF7FEE, 1, 1);
		});

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
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
		#if PRELOAD_ALL
		playDaMusic(CoolUtil.difficultyString() == 'DOKI DOKI');
		#end
		changeDiff();
	}

	function selectSong(){
		selectedSomethin = true;
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);

		PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());

		PlayState.isStoryMode = false;
		PlayState.storyDifficulty = curDifficulty;

		CustomFadeTransition.isHeartTran = true;

		grpSongs.forEach(function(spr:FlxText)
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
				FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
				{
					openSubState(new CustomFadeTransition(0.4, false, new LoadingState(new PlayState(), true, false)));
					FlxG.sound.music.stop();
					FlxG.sound.music.volume = 0;						
				});
			}
		});
	}

	function playDaMusic(?doki:Bool = false)
	{
		if (doki) FlxG.sound.playMusic(Paths.music('previews/doki-doki/' + Paths.formatToSongPath(songs[curSelected].songName)), 0);
		else FlxG.sound.playMusic(Paths.music('previews/default/' + Paths.formatToSongPath(songs[curSelected].songName)), 0);
	}

	function onMouseOver(txt:FlxText):Void
	{
		if (!selectedSomethin)
		{
			if (curSelected != txt.ID)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				curSelected = txt.ID;
				changeItem();
			}
		}
	}

	function onMouseDown(spr:FlxSprite):Void
	{
		if (!selectedSomethin)
		{
			selectSong();
		}
	}
}

class SongMetadatatwo
{
	public var songName:String = "";
	public var owner:String = "";
	public var songCharacter:String = "";
	public var songDifficulties:String = '';
	public var diffRatings:Array<Int> = [];

	public function new(song:String, owner:String, songCharacter:String, songDifficulties:String, diffRatings:Array<Int>)
	{
		this.songName = song;
		this.owner = owner;
		this.songCharacter = songCharacter;
		this.songDifficulties = songDifficulties;
		this.diffRatings = diffRatings;
	}
}
