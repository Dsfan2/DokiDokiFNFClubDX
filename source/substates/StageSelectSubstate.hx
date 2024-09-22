package substates;

import flixel.effects.FlxFlicker;

class StageSelectSubstate extends MusicBeatSubstate
{
	var grpMenutrash:FlxTypedGroup<FlxText>;
	var curSelected:Int = 0;
	var route:String = "";
	var difficultyNum:Int = 0;
	var selectedSomethin:Bool = false;
	var canInput:Bool = false;
	var box:FlxSprite;

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	var highscoreText:FlxText;

	public var camGame:FlxCamera;
	public var camTran:FlxCamera;
	
	var boxSuffix:String = '';

	public function new(listID:Int, diff:Int)
	{
		super();
		FlxG.mouse.visible = true;
		MusicBeatState.reloadCursor();
		TitleState.setDefaultRGB();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);

		add(bg);
		bg.alpha = 0.6;

		if (TitleState.endEasterEgg)
			boxSuffix = '-act3';

		difficultyNum = diff;

		box = new FlxSprite(0, 0).loadGraphic(Paths.image('blankPopup' + boxSuffix));
		box.antialiasing = ClientPrefs.globalAntialiasing;
		box.setGraphicSize(450, 620);
		box.screenCenter();
		add(box);

		highscoreText = new FlxText(0, 75, 400, "");
		highscoreText.setFormat(Paths.font("dokiUI.ttf"), 25, FlxColor.WHITE, FlxTextAlign.CENTER);
		highscoreText.setBorderStyle(OUTLINE, 0xFFBB5599, 4);
		highscoreText.screenCenter(X);
		add(highscoreText);

		var text:FlxText = new FlxText(0, 115, 400, 'Choose A Stage');
		text.setFormat(Paths.font("doki.ttf"), 28, FlxColor.BLACK, FlxTextAlign.CENTER);
		text.screenCenter(X);
		add(text);

		grpMenutrash = new FlxTypedGroup<FlxText>();
		add(grpMenutrash);

		switch (listID)
		{
			case 0 | 3:
				route = "BF";
				for (i in 0...WeekData.boyfriendRouteList.length) {
					var item:FlxText = new FlxText(10, (49 * i) + 160, 0, WeekData.boyfriendRouteList[i][0]);
					item.setFormat(Paths.font("dokiUI.ttf"), 25, FlxColor.WHITE, FlxTextAlign.CENTER);
					item.setBorderStyle(OUTLINE, 0xFFBB5599, 4);
					item.screenCenter(X);
					item.ID = i;
					grpMenutrash.add(item);
				}
			case 1 | 4:
				route = "JR";
				for (i in 0...WeekData.bowserJrRouteList.length) {
					var item:FlxText = new FlxText(10, (49 * i) + 160, 0, WeekData.bowserJrRouteList[i][0]);
					item.setFormat(Paths.font("dokiUI.ttf"), 25, FlxColor.WHITE, FlxTextAlign.CENTER);
					item.setBorderStyle(OUTLINE, 0xFFBB5599, 4);
					item.screenCenter(X);
					item.ID = i;
					grpMenutrash.add(item);
				}
			case 2 | 5:
				route = "MONI";
				for (i in 0...WeekData.monikaRouteList.length) {
					var item:FlxText = new FlxText(10, (49 * i) + 160, 0, WeekData.monikaRouteList[i][0]);
					item.setFormat(Paths.font("dokiUI.ttf"), 25, FlxColor.WHITE, FlxTextAlign.CENTER);
					item.setBorderStyle(OUTLINE, 0xFFBB5599, 4);
					item.screenCenter(X);
					item.ID = i;
					grpMenutrash.add(item);
				}
		}
		new FlxTimer().start(0.5, function(tmr:FlxTimer){
			canInput = true;
		});
		changeSelection(0, false);
	}

	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, CoolUtil.boundTo(elapsed * 24, 0, 1)));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		highscoreText.text = "Stage Highscore: " + lerpScore;

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;

		if (canInput)
		{
			if (upP)
			{
				changeSelection(-1);
			}
			if (downP)
			{
				changeSelection(1);
			}

			if (accepted)
			{
				selectThing();
			}
			else if (controls.BACK && !selectedSomethin)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				close();
			}
			if (!selectedSomethin)
			{
				grpMenutrash.forEach(function(txt:FlxText)
				{
					if (FlxG.mouse.overlaps(txt)){
						if (curSelected != txt.ID){
							curSelected = txt.ID;
							changeSelection();
						}
						if (FlxG.mouse.justPressed)
							selectThing();
					}
				});
			}
		}
	}

	function selectThing()
	{
		selectedSomethin = true;
		FlxG.sound.play(Paths.sound('confirmMenu'));
		switch (route)
		{
			default:
				WeekData.weekID = WeekData.boyfriendRouteList[curSelected][1];
				PlayState.storyPlaylist = WeekData.boyfriendRouteList[curSelected][2];
			case "JR":
				WeekData.weekID = WeekData.bowserJrRouteList[curSelected][1];
				PlayState.storyPlaylist = WeekData.bowserJrRouteList[curSelected][2];
			case "MONI":
				WeekData.weekID = WeekData.monikaRouteList[curSelected][1];
				PlayState.storyPlaylist = WeekData.monikaRouteList[curSelected][2];
		}

		PlayState.isStoryMode = true;
		PlayState.storyFreeplay = true;
		var diffic = CoolUtil.getDifficultyFilePath(difficultyNum);
		if(diffic == null) diffic = '';

		PlayState.storyDifficulty = difficultyNum;

		if (curSelected == 0 && difficultyNum != 1)
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

		grpMenutrash.forEach(function(spr:FlxText)
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
				FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker){
					CustomFadeTransition.isHeartTran = true;
					openSubState(new CustomFadeTransition(0.4, false, new LoadingState(new PlayState(), true, true)));
					FlxG.sound.music.stop();
					FlxG.sound.music.volume = 0;
				});
			}
		});
	}

	override function destroy()
	{
		super.destroy();
	}

	function changeSelection(change:Int = 0, ?playSound:Bool = true):Void
	{
		curSelected += change;

		if (playSound) FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		if (curSelected < 0)
			curSelected = grpMenutrash.length - 1;
		if (curSelected >= grpMenutrash.length)
			curSelected = 0;

		grpMenutrash.forEach(function(txt:FlxText)
		{
			txt.setBorderStyle(OUTLINE, 0xFFBB5599, 4);
			
			if (txt.ID == curSelected)
				txt.setBorderStyle(OUTLINE, 0xFFFFAACC, 4);
		});

		switch (route)
		{
			default:
				WeekData.weekID = WeekData.boyfriendRouteList[curSelected][1];
			case "JR":
				WeekData.weekID = WeekData.bowserJrRouteList[curSelected][1];
			case "MONI":
				WeekData.weekID = WeekData.monikaRouteList[curSelected][1];
		}

		intendedScore = Highscore.getWeekScore(WeekData.weekID, difficultyNum);
	}
}
