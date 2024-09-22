package substates;

import flixel.addons.display.FlxBackdrop;
import backend.Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import flixel.util.FlxStringUtil;

class PauseSubState extends MusicBeatSubstate
{
	//var grpMenutrash:FlxTypedGroup<Alphabet>;
	var grpMenutrash:FlxTypedGroup<FlxText>;

	var menuItems:Array<String> = [];
	var menuItemsOG:Array<String> = ['Resume', 'Restart Song', 'Options', 'Exit to menu'];
	var difficultyChoices = [];
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;
	var practiceText:FlxText;
	var skipTimeText:FlxText;
	//var skipTimeTracker:Alphabet;
	var skipTimeTracker:FlxText;
	var curTime:Float = Math.max(0, Conductor.songPosition);
	//var botplayText:FlxText;
	var pauseTxt:FlxText;

	public static var pausesongname:String = '';
	var pauseIcon:FlxSprite;
	var pauseChar:FlxSprite;

	var box:FlxSprite;
	var boxSuffix:String = '';

	public var p1Icon:HealthIcon;
	public var p2Icon:HealthIcon;

	public static var songName:String = '';

	public function new(x:Float, y:Float)
	{
		super();
		FlxG.mouse.visible = true;
		MusicBeatState.reloadCursor();

		if(PlayState.chartingMode)
		{
			menuItemsOG.insert(2, 'Leave Charting Mode');
			
			var num:Int = 0;
			menuItemsOG.insert(3 + num, 'Toggle Practice Mode');
			menuItemsOG.insert(4 + num, 'Toggle Botplay');
			menuItemsOG.insert(5 + num, 'Change Difficulty');
		}
		if (SaveData.actThree) menuItemsOG.remove('Exit to menu');
		menuItems = menuItemsOG;

		for (i in 0...CoolUtil.difficulties.length) {
			var diff:String = '' + CoolUtil.difficulties[i];
			difficultyChoices.push(diff);
		}
		difficultyChoices.push('BACK');

		switch (PlayState.SONG.song.toLowerCase())
		{
			case "un-welcome to the club" | 'depression' | 'hxppy thxughts' | 'cxnnamon bxn' | 'malnourished' | 'pale' | 'glitch' | 'yandere' | 'obsessed' | 'psychopath' | 'candy heartz' | 'play with me' | 'poem panic' | 'supernatural' | 'spiders of markov' | 'roar of natsuki':
				pausesongname = 'Quick-Breakdown_Act-2-Pause';
				boxSuffix = '-act2';
				OptionsState.actNumber = 2;
			case "revelation" | 'lines of code' | 'self-aware' | 'elevated access' | 'script error' | 'system failure' | 'just monika' | 'doki forever' | 'dark star' | "you can't run" | 'ultimate glitcher' | 'the final battle' | 'festival deluxe':
				pausesongname = 'Unnamed_Act-3-Pause';
				boxSuffix = '-act3';
				OptionsState.actNumber = 3;
			default:
				pausesongname = 'Quick-Breather_Pause';
				OptionsState.actNumber = 1;
		}
		pauseMusic = new FlxSound().loadEmbedded(Paths.music(pausesongname), true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
		add(bg);
		bg.alpha = 0;

		box = new FlxSprite().loadGraphic(Paths.image('blankPopup' + boxSuffix));
		box.setGraphicSize(599, 671);
		box.updateHitbox();
		box.screenCenter();
		box.alpha = 0;
		add(box);

		pauseTxt = new FlxText(350, 41, 580, "Paused", 32);
		pauseTxt.setFormat(Paths.font("doki.ttf"), 46, FlxColor.BLACK, FlxTextAlign.CENTER);
		pauseTxt.screenCenter(X);
		pauseTxt.alpha = 0;
		add(pauseTxt);

		var levelDifficulty:String = '';
		if (CoolUtil.difficultyString() == 'DOKI DOKI')
		{
			levelDifficulty = 'DOKI DOKI REMIX';
		}
		else
		{
			levelDifficulty = 'REGULAR';
		}

		var levelInfo:FlxText = new FlxText(350, 90, 580, "", 32);
		levelInfo.text = PlayState.SONG.song + '\n' + levelDifficulty + '\n' + "Game Over'd: " + PlayState.deathCounter;
		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Paths.font("doki.ttf"), 32, FlxColor.BLACK, FlxTextAlign.CENTER);
		levelInfo.screenCenter(X);
		levelInfo.alpha = 0;
		add(levelInfo);

		practiceText = new FlxText(350, 650, 580, "PRACTICE MODE", 32);
		practiceText.scrollFactor.set();
		practiceText.setFormat(Paths.font("doki.ttf"), 24, FlxColor.BLACK, FlxTextAlign.LEFT);
		practiceText.screenCenter(X);
		practiceText.alpha = 0;
		practiceText.visible = PlayState.instance.practiceMode;
		add(practiceText);

		var chartingText:FlxText = new FlxText(350, 650, 580, "CHARTING MODE", 32);
		chartingText.scrollFactor.set();
		chartingText.setFormat(Paths.font("doki.ttf"), 24, FlxColor.BLACK, FlxTextAlign.RIGHT);
		chartingText.screenCenter(X);
		chartingText.alpha = 0;
		chartingText.visible = PlayState.chartingMode;
		add(chartingText);

		p2Icon = new HealthIcon(PlayState.instance.dad.healthIcon, false);
		p2Icon.x = 350;
		p2Icon.y = 464;
		p2Icon.animation.curAnim.curFrame = 0;
		p2Icon.alpha = 0;
		add(p2Icon);

		p1Icon = new HealthIcon(PlayState.instance.boyfriend.healthIcon, true);
		p1Icon.x = 780;
		p1Icon.y = 464;
		p1Icon.animation.curAnim.curFrame = 0;
		p1Icon.alpha = 0;
		add(p1Icon);

		if (FlxG.random.bool(5))
		{
			p2Icon.changeIcon('ds');
		}

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(box, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(pauseTxt, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(practiceText, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(chartingText, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(p1Icon, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(p2Icon, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut});

		grpMenutrash = new FlxTypedGroup<FlxText>();
		add(grpMenutrash);

		var startx:Int = 230;
		var splitL:Int = 65;

		if (menuItems.length > 6 && menuItems.length < 9) splitL = 50;
		if (menuItems.length >= 9) splitL = 40;

		for (i in 0...menuItems.length) {
			var item:FlxText = new FlxText(0, (splitL * i) + 230, 0, menuItems[i]);
			item.setFormat(Paths.font("dokiUI.ttf"), 28, FlxColor.WHITE, FlxTextAlign.CENTER);
			item.setBorderStyle(OUTLINE, 0xFFBB5599, 4);
			item.ID = i;
			item.screenCenter(X);
			item.scrollFactor.set();
			grpMenutrash.add(item);
		}

		curSelected = 0;
		changeSelection();
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.05 * elapsed;

		super.update(elapsed);
		updateSkipTextStuff();

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		var daSelected:String = menuItems[curSelected];
		switch (daSelected)
		{
			case 'Skip Time':
				if (controls.UI_LEFT_P)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
					curTime -= 1000;
					holdTime = 0;
				}
				if (controls.UI_RIGHT_P)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
					curTime += 1000;
					holdTime = 0;
				}

				if(controls.UI_LEFT || controls.UI_RIGHT)
				{
					holdTime += elapsed;
					if(holdTime > 0.5)
					{
						curTime += 45000 * elapsed * (controls.UI_LEFT ? -1 : 1);
					}

					if(curTime >= FlxG.sound.music.length) curTime -= FlxG.sound.music.length;
					else if(curTime < 0) curTime += FlxG.sound.music.length;
					updateSkipTimeText();
				}
		}

		if (accepted)
		{
			selectOption();
		}

		grpMenutrash.forEach(function(txt:FlxText)
		{
			if (FlxG.mouse.overlaps(txt)){
				if (curSelected != txt.ID){
					curSelected = txt.ID;
					changeSelection();
				}
				if (FlxG.mouse.justPressed)
					selectOption();
			}
		});

		if (FlxG.mouse.overlaps(p2Icon) && FlxG.mouse.justPressed && p2Icon.getCharacter() == 'ds')
		{
			CoolUtil.makeSecretFile('Hello World', 'firsttest');
		}
		if (FlxG.mouse.overlaps(p2Icon) && FlxG.mouse.justPressed && p2Icon.getCharacter() == 'natsuki' && PlayState.SONG.song.toLowerCase() == 'anime')
		{
			CoolUtil.makeSecretFile("Who's the vocaloid idol from out of this world?" + '\n' + "Blue hair in your face, the world is her's!" + '\nIf Japanese Japes are something you wish...\nThen put your hands up and make them go swish!', 'Are you a weeb');
		}
	}

	public static function restartSong(noTrans:Bool = false)
	{
		PlayState.instance.paused = true;
		FlxG.sound.music.volume = 0;
		PlayState.instance.vocals.volume = 0;
		PlayState.instance.playervox.volume = 0;

		FlxTransitionableState.skipNextTransOut = true;
		FlxG.resetState();
	}

	override function destroy()
	{
		pauseMusic.destroy();
		FlxG.mouse.visible = false;

		super.destroy();
	}

	function selectOption(){
		var daSelected:String = menuItems[curSelected];
		switch (daSelected)
		{
			case "Resume":
				close();
			case 'Toggle Practice Mode':
				PlayState.instance.practiceMode = !PlayState.instance.practiceMode;
				PlayState.changedDifficulty = true;
				practiceText.visible = PlayState.instance.practiceMode;
				PlayState.instance.practiceSpr.visible = PlayState.instance.practiceMode;
				PlayState.instance.practiceSpr.alpha = 1;
				PlayState.instance.practiceSine = 0;
			case "Restart Song":
				restartSong();
			case "Leave Charting Mode":
				restartSong();
				PlayState.chartingMode = false;
			case 'Skip Time':
				if(curTime < Conductor.songPosition)
				{
					PlayState.startOnTime = curTime;
					restartSong(true);
				}
				else
				{
					if (curTime != Conductor.songPosition)
					{
						PlayState.instance.clearNotesBefore(curTime);
						PlayState.instance.setSongTime(curTime);
					}
					close();
				}
			case "End Song":
				close();
				PlayState.instance.finishSong(true);
			case 'Toggle Botplay':
				PlayState.instance.cpuControlled = !PlayState.instance.cpuControlled;
				PlayState.changedDifficulty = true;
				PlayState.instance.botplaySpr.visible = PlayState.instance.cpuControlled;
				PlayState.instance.botplaySpr.alpha = 1;
				PlayState.instance.botplaySine = 0;
			case 'Options':
				PlayState.instance.paused = true;
				PlayState.instance.vocals.volume = 0;
				PlayState.instance.playervox.volume = 0;
				openSubState(new CustomFadeTransition(0.6, false, new OptionsState()));
				CoolUtil.playMusic(Paths.formatToSongPath(pausesongname), pauseMusic.volume);
				FlxTween.tween(FlxG.sound.music, {volume: 1}, 0.8);
				FlxG.sound.music.time = pauseMusic.time;
				OptionsState.onPlayState = true;
			case "Exit to menu":
				CustomFadeTransition.isHeartTran = true;
				PlayState.deathCounter = 0;
				PlayState.seenCutscene = false;
				if(PlayState.isStoryMode) {
					if (PlayState.storyFreeplay) openSubState(new CustomFadeTransition(0.4, false, new StoryContinueState()));
					else openSubState(new CustomFadeTransition(0.4, false, new MainMenuState()));
					
					if (SaveData.actThree) CoolUtil.playMusic('ActThreeMenu');
					else CoolUtil.playMusic(CoolUtil.getTitleTheme());
				} else {
					FlxG.sound.music.stop();
					switch (PlayState.songType)
					{
						case 'Normal': openSubState(new CustomFadeTransition(0.4, false, new FreeplayState()));
						case 'Classic': openSubState(new CustomFadeTransition(0.4, false, new ClassicFreeplayState()));
						case 'Bonus': openSubState(new CustomFadeTransition(0.4, false, new BonusFreeplayState()));
					}
				}
				PlayState.changedDifficulty = false;
				PlayState.chartingMode = false;
		}
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		grpMenutrash.forEach(function(txt:FlxText)
		{
			txt.setBorderStyle(OUTLINE, 0xFFBB5599, 4);
			
			if (txt.ID == curSelected)
				txt.setBorderStyle(OUTLINE, 0xFFFFAACC, 4);
		});
	}
	
	function updateSkipTextStuff()
	{
		if(skipTimeText == null) return;

		skipTimeText.x = skipTimeTracker.x + skipTimeTracker.width + 10;
		skipTimeText.y = skipTimeTracker.y - 1;
		skipTimeText.visible = (skipTimeTracker.alpha >= 1);
	}

	function updateSkipTimeText()
	{
		skipTimeText.text = FlxStringUtil.formatTime(Math.max(0, Math.floor(curTime / 1000)), false) + ' / ' + FlxStringUtil.formatTime(Math.max(0, Math.floor(FlxG.sound.music.length / 1000)), false);
	}
}
