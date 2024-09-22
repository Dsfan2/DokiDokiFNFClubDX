package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.FlxCamera;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;
import flixel.graphics.FlxGraphic;

class StoryStartState extends MusicBeatState
{
	var scoreText:FlxText;

	var curDifficulty:Int = 0;

	var weekDiffiulties:Array<String> = [
		'Normal,Doki Doki'
	];

	private static var lastDifficultyName:String = '';
	var txtWeekTitle:FlxText;

	var curPlayer:Int = 1;
	private static var curSelected:Int = 0;

	//var curRoute:Int = 0;
	//var curAct:Int = 2;

	var txtTracklist:FlxText;

	var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	var bfStorySpr:FlxSprite;
	var jrStorySpr:FlxSprite;
	var moniStorySpr:FlxSprite;

	override function create()
	{		
		persistentUpdate = persistentDraw = true;
		FlxG.mouse.visible = true;
		MusicBeatState.reloadCursor();

		scoreText = new FlxText(10, 10, 0, "SCORE: 49324858", 36);
		scoreText.setFormat("Riffic Free Bold", 32);
		scoreText.setBorderStyle(OUTLINE, 0xFFBB5599, 3.5);
		scoreText.borderSize = 2;
		scoreText.borderQuality = 3;

		txtWeekTitle = new FlxText(0, 20, FlxG.width, "", 32);
		txtWeekTitle.setFormat("Riffic Free Bold", 50, FlxColor.WHITE, FlxTextAlign.CENTER);
		txtWeekTitle.setBorderStyle(OUTLINE, 0xFFBB5599, 4);
		txtWeekTitle.borderSize = 2;
		txtWeekTitle.borderQuality = 3;

		var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');

		var titleBg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('storymenu/new_game/StoryStart'));
		titleBg.setGraphicSize(Std.int(titleBg.width * 0.7));
		titleBg.updateHitbox();
		add(titleBg);

		bfStorySpr = new FlxSprite(0, 130);
		bfStorySpr.frames = Paths.getSparrowAtlas('storymenu/new_game/BF_Story');
		bfStorySpr.animation.addByPrefix('idle', 'Idle', 24, true);
		bfStorySpr.animation.addByPrefix('hey', 'Hey', 24, false);
		bfStorySpr.animation.addByPrefix('null', 'Null', 24, true);
		bfStorySpr.antialiasing = ClientPrefs.globalAntialiasing;
		bfStorySpr.setGraphicSize(Std.int(bfStorySpr.width * 0.6));
		bfStorySpr.updateHitbox();
		bfStorySpr.flipX = true;

		jrStorySpr = new FlxSprite(440, 105);
		jrStorySpr.frames = Paths.getSparrowAtlas('storymenu/new_game/JR_Story');
		jrStorySpr.animation.addByPrefix('idle', 'Idle', 24, true);
		jrStorySpr.animation.addByPrefix('hey', 'Hey', 24, false);
		jrStorySpr.animation.addByPrefix('null', 'Null', 24, true);
		jrStorySpr.antialiasing = ClientPrefs.globalAntialiasing;
		jrStorySpr.setGraphicSize(Std.int(jrStorySpr.width * 0.65));
		jrStorySpr.updateHitbox();
		jrStorySpr.flipX = true;

		moniStorySpr = new FlxSprite(860, 75);
		moniStorySpr.frames = Paths.getSparrowAtlas('storymenu/new_game/MONI_Story');
		moniStorySpr.animation.addByPrefix('idle', 'Idle', 24, true);
		moniStorySpr.animation.addByPrefix('hey', 'Hey', 24, false);
		moniStorySpr.animation.addByPrefix('null', 'Null', 24, true);
		moniStorySpr.antialiasing = ClientPrefs.globalAntialiasing;
		moniStorySpr.setGraphicSize(Std.int(moniStorySpr.width * 0.6));
		moniStorySpr.updateHitbox();

		var otherTxt:FlxText = new FlxText(0, 530, FlxG.width, "Selected Difficulty:", 32);
		otherTxt.setFormat("Riffic Free Bold", 50, FlxColor.WHITE, FlxTextAlign.CENTER);
		otherTxt.setBorderStyle(OUTLINE, 0xFFBB5599, 4);
		otherTxt.borderSize = 2;
		otherTxt.borderQuality = 3;
		add(otherTxt);

		add(txtWeekTitle);
		switch (SaveData.lockedRoute)
		{
			case 'BF' | 'BFDOKI':
				add(bfStorySpr);
			case 'JR' | 'JRDOKI':
				curPlayer = 2;
				add(jrStorySpr);
				changeChar();
			default:
				add(bfStorySpr);
				add(jrStorySpr);
				add(moniStorySpr);
		}
		
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		difficultySelectors = new FlxGroup();
		add(difficultySelectors);

		leftArrow = new FlxSprite(360, 600);
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		leftArrow.antialiasing = ClientPrefs.globalAntialiasing;
		difficultySelectors.add(leftArrow);

		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		if(lastDifficultyName == '')
		{
			lastDifficultyName = "Regular";
		}
		curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(lastDifficultyName)));
		
		sprDifficulty = new FlxSprite(0, leftArrow.y);
		sprDifficulty.antialiasing = ClientPrefs.globalAntialiasing;
		difficultySelectors.add(sprDifficulty);

		rightArrow = new FlxSprite(leftArrow.x + 500, leftArrow.y);
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		rightArrow.antialiasing = ClientPrefs.globalAntialiasing;
		difficultySelectors.add(rightArrow);

		if (SaveData.lockedRoute.endsWith('DOKI')) curDifficulty = 1;
		else curDifficulty = 0;

		changeDifficulty();
		reloadDifficulties();
		changeChar();

		var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
		add(textBG);

		var leText:String = "Press ENTER to begin the story!";
		var size:Int = 18;
		var text:FlxText = new FlxText(textBG.x, textBG.y + 2, FlxG.width, leText, size);
		text.setFormat(Paths.font("doki.ttf"), size, FlxColor.WHITE, CENTER);
		text.scrollFactor.set();
		add(text);

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}	

		difficultySelectors.visible = true;

		if (!movedBack)
		{
			if (!selectedWeek)
			{
				if (controls.UI_RIGHT || (FlxG.mouse.overlaps(rightArrow) && FlxG.mouse.pressed))
					rightArrow.animation.play('press')
				else
					rightArrow.animation.play('idle');

				if (controls.UI_LEFT || (FlxG.mouse.overlaps(leftArrow) && FlxG.mouse.pressed))
					leftArrow.animation.play('press');
				else
					leftArrow.animation.play('idle');

				if (!SaveData.actTwo)
				{
					if (controls.UI_RIGHT_P || (FlxG.mouse.overlaps(rightArrow) && FlxG.mouse.justPressed))
						changeDifficulty(1);
					if (controls.UI_LEFT_P || (FlxG.mouse.overlaps(leftArrow) && FlxG.mouse.justPressed))
						changeDifficulty(-1);
				}
			}

			if (controls.ACCEPT)
			{
				selectWeek();
			}

			if (controls.BACK && !movedBack && !selectedWeek)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				movedBack = true;
				openSubState(new CustomFadeTransition(0.6, false, new MainMenuState()));
			}
		}

		if (FlxG.mouse.overlaps(bfStorySpr) && FlxG.mouse.justPressed && !selectedWeek)
		{
			if (SaveData.lockedRoute == 'BF' || SaveData.lockedRoute == 'BFDOKI' || SaveData.lockedRoute == 'None')
			{
				curPlayer = 1;
				changeChar();
			}
		}
		if (FlxG.mouse.overlaps(jrStorySpr) && FlxG.mouse.justPressed && !selectedWeek)
		{
			if (SaveData.lockedRoute == 'JR' || SaveData.lockedRoute == 'JRDOKI' || SaveData.lockedRoute == 'None')
			{
				curPlayer = 2;
				changeChar();
			}
		}
		if (FlxG.mouse.overlaps(moniStorySpr) && FlxG.mouse.justPressed && !selectedWeek)
		{
			if (SaveData.lockedRoute == 'None')
			{
				curPlayer = 3;
				changeChar();
			}
		}

		super.update(elapsed);
	}

	override function closeSubState() {
		selectedWeek = false;
		stopspamming = false;
		super.closeSubState();
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
	{
		if (curDifficulty == 1)
		{
			selectedWeek = true;
			stopspamming = true;
			FlxG.sound.play(Paths.sound('confirmMenu'));
			openSubState(new Part2Popup());
		}
		else
		{
			ClientPrefs.playerChar = curPlayer;
			ClientPrefs.saveSettings();
			if (stopspamming == false)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));
				switch (ClientPrefs.playerChar)
				{
					case 1:
						bfStorySpr.animation.play('hey');
					case 2:
						jrStorySpr.animation.play('hey');
					case 3:
						moniStorySpr.animation.play('hey');
				}
				stopspamming = true;
			}
			switch (ClientPrefs.playerChar)
			{
				case 1:
					if (SaveData.actTwo)
						WeekData.weekID = "Midway BF";
					else
						WeekData.weekID = "Start BF";
				case 2:
					if (SaveData.actTwo)
						WeekData.weekID = "Midway JR";
					else
						WeekData.weekID = "Start JR";
				case 3:
					WeekData.weekID = "Start MONI";
			}

			var songArray:Array<String> = [];
			if (SaveData.actTwo)
				songArray = ["Un-welcome To The Club"];
			else
				songArray = ["Welcome To The Club"];

			PlayState.storyPlaylist = songArray;
			PlayState.isStoryMode = true;
			PlayState.storyFreeplay = false;
			selectedWeek = true;

			var diffic = CoolUtil.getDifficultyFilePath(curDifficulty);
			if(diffic == null) diffic = '';

			PlayState.storyDifficulty = curDifficulty;

			if (songArray[0] == 'Welcome To The Club')
			{
				switch (ClientPrefs.playerChar)
				{
					case 1:
						PlayState.SONG = Song.loadFromJson('welcome-to-the-club-bf', 'welcome to the club');
					case 2:
						PlayState.SONG = Song.loadFromJson('welcome-to-the-club-jr', 'welcome to the club');
					case 3:
						PlayState.SONG = Song.loadFromJson('welcome-to-the-club-moni', 'welcome to the club');
				}
			}
			else PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
			PlayState.campaignScore = 0;
			PlayState.campaignMisses = 0;
			PlayState.campaignNotes = 0;
			PlayState.campaignHits = 0.0;
			PlayState.totalNotesHit = 0;
			PlayState.campaignAccuracy = 0.0;
			PlayState.campaignSicks = 0;
			PlayState.campaignGoods = 0;
			PlayState.campaignBads = 0;
			PlayState.campaignTrashes = 0;

			CustomFadeTransition.isHeartTran = true;
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				FlxG.sound.music.stop();
				if (WeekData.weekID.startsWith('Midway')) openSubState(new CustomFadeTransition(0.4, false, new LoadingState(new PlayState(), true, true)));
				else openSubState(new CustomFadeTransition(0.4, false, new LoadingState(new NotebookThing(), true, true)));
			});

			if (SaveData.actTwo)
			{
				switch (ClientPrefs.playerChar)
				{
					case 1:
						if (CoolUtil.difficultyString() == 'DOKI DOKI') SaveData.dokiBFRoute = 5;
						else SaveData.bfRoute = 5;
					case 2:
						if (CoolUtil.difficultyString() == 'DOKI DOKI') SaveData.dokiJRRoute = 5;
						else SaveData.jrRoute = 5;
				}
			}
			else
			{
				switch (ClientPrefs.playerChar)
				{
					case 1:
						if (CoolUtil.difficultyString() == 'DOKI DOKI') SaveData.dokiBFRoute = 0;
						else SaveData.bfRoute = 0;
					case 2:
						if (CoolUtil.difficultyString() == 'DOKI DOKI') SaveData.dokiJRRoute = 0;
						else SaveData.jrRoute = 0;
					case 3:
						if (CoolUtil.difficultyString() == 'DOKI DOKI') SaveData.dokiMONIRoute = 0;
						else SaveData.monikaRoute = 0;
				}
			}
			SaveData.saveSwagData();
		}
	}

	var tweenDifficulty:FlxTween;
	function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = CoolUtil.difficulties.length-1;
		if (curDifficulty >= CoolUtil.difficulties.length)
			curDifficulty = 0;

		var diff:String = CoolUtil.difficulties[curDifficulty];
		var newImage:FlxGraphic = Paths.image('menudifficulties/' + Paths.formatToSongPath(diff));

		if(sprDifficulty.graphic != newImage)
		{
			sprDifficulty.loadGraphic(newImage);
			sprDifficulty.x = leftArrow.x + 109;
			sprDifficulty.x += (308 - sprDifficulty.width) / 3;
			sprDifficulty.alpha = 0;
			sprDifficulty.y = leftArrow.y - 15;

			if(tweenDifficulty != null) tweenDifficulty.cancel();
			tweenDifficulty = FlxTween.tween(sprDifficulty, {y: leftArrow.y, alpha: 1}, 0.07, {onComplete: function(twn:FlxTween)
			{
				tweenDifficulty = null;
			}});
		}
		lastDifficultyName = diff;
	}

	function reloadDifficulties():Void
	{
		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		var diffStr:String = weekDiffiulties[curSelected];
		if(diffStr != null) diffStr = diffStr.trim();
		difficultySelectors.visible = true;
	
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
	}

	function changeChar()
	{
		switch (curPlayer)
		{
			case 1:
				txtWeekTitle.text = 'Selected Player\nBoyfriend';
				bfStorySpr.animation.play('idle');
				jrStorySpr.animation.play('null');
				moniStorySpr.animation.play('null');
			case 2:
				txtWeekTitle.text = 'Selected Player\nBowser Jr';
				bfStorySpr.animation.play('null');
				jrStorySpr.animation.play('idle');
				moniStorySpr.animation.play('null');
			case 3:
				txtWeekTitle.text = 'Selected Player\nMonika';
				bfStorySpr.animation.play('null');
				jrStorySpr.animation.play('null');
				moniStorySpr.animation.play('idle');
		}
	}
}
