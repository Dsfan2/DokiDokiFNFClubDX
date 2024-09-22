package states;

import flixel.addons.display.FlxBackdrop;
#if desktop
import backend.Discord.DiscordClient;
import sys.thread.Thread;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import haxe.Json;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import openfl.Assets;

class TitleState extends MusicBeatState
{
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

	public static var initialized:Bool = false;
	public static var loaded:Bool = false;
	public static var videoPlayed:Bool = false;

	public static var monkerEasterEgg:Bool = false;
	var ghostMenuEasterEgg:Bool = false;
	public static var classicEasterEgg:Bool = false;
	public static var endEasterEgg:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTexttrash:Alphabet;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;
	var randomChance:Int = 0;

	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;

	var mustUpdate:Bool = false;
	
	public static var updateVersion:String = '';

	public static var bgRGB:Array<FlxColor> = [0xFFFFFFFF, 0xFFFFDBF0, 0xFFFFBDE1];

	var tsSpr:FlxSprite;
	var tdSpr:FlxSprite;
	var textNormal1:FlxText;
	var textNormal2:FlxText;
	var textNormal3:FlxText;

	var sprSuffix:String = "menu";

	var dieScreen:FlxSprite;
	var smol:FlxSprite;

	override public function create():Void
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		randomChance = FlxG.random.int(1, 100);

		FlxG.game.focusLostFramerate = 120;
		FlxG.sound.muteKeys = muteKeys;
		FlxG.sound.volumeDownKeys = volumeDownKeys;
		FlxG.sound.volumeUpKeys = volumeUpKeys;
		FlxG.keys.preventDefaultKeys = [TAB];

		curWacky = FlxG.random.getObject(getIntroTextTrash());

		swagShader = new ColorSwap();
		super.create();

		if(!initialized && FlxG.save.data != null && FlxG.save.data.fullscreen)
		{
			FlxG.fullscreen = FlxG.save.data.fullscreen;
		}

		MusicBeatState.reloadCursor();

		#if desktop
		if (!DiscordClient.isInitialized)
		{
			DiscordClient.initialize();
			Application.current.onExit.add (function (exitCode) {
				DiscordClient.shutdown();
			});
		}
		#end
		
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			startIntro();
		});
	}

	var logoBl:FlxSprite;
	var titleText:FlxSprite;
	var titleBg:DDLCBorderBG;

	var bfTitle:FlxSprite;
	var gfTitle:FlxSprite;
	var jrTitle:FlxSprite;
	var monikaTitle:FlxSprite;
	var sayoriTitle:FlxSprite;
	var yuriTitle:FlxSprite;
	var natsukiTitle:FlxSprite;
	var swagShader:ColorSwap = null;

	function startIntro()
	{
		if (SaveData.bfRoute < 5 && SaveData.jrRoute < 5 && SaveData.monikaRoute < 5 && !SaveData.storyCleared)
		{
			curWacky = ["This mod is an unofficial fan work\nUnaffiliated with Team Salvato."];
		}
		else
		{
			if (randomChance > 0 && randomChance < 5 && SaveData.clearAllNormal)
			{
				monkerEasterEgg = true;
			}
			if (randomChance > 4 && randomChance < 9 && (SaveData.actTwo || SaveData.clearAllNormal))
			{
				SaveData.seenGhost = true;
				ghostMenuEasterEgg = true;
				SaveData.saveSwagData();
			}
			/*if (randomChance > 8 && randomChance < 14 && SaveData.clearAllNormal)
			{
				endEasterEgg = true;
			}*/
			else
			{
				endEasterEgg = false;
				if (randomChance > 8 && randomChance < 19 && SaveData.monikaRouteClear)
				{
					classicEasterEgg = true;
					curWacky = FlxG.random.getObject(getSecretIntroTextTrash());
				}
				else
				{
					classicEasterEgg = false;
					curWacky = FlxG.random.getObject(getIntroTextTrash());
				}
			}
		}
		if (!initialized)
		{
			if (SaveData.actThree)
			{
				if (ClientPrefs.playerChar == 1)
				{
					PlayState.storyPlaylist = WeekData.boyfriendRouteList[9][2];
					WeekData.weekID = "Final BF";
				}
				else if (ClientPrefs.playerChar == 2)
				{
					PlayState.storyPlaylist = WeekData.bowserJrRouteList[9][2];
					WeekData.weekID = "Final JR";
				}
				else if (ClientPrefs.playerChar == 3)
				{
					PlayState.storyPlaylist = WeekData.monikaRouteList[5][2];
					WeekData.weekID = "Final MONI";
				}
				PlayState.isStoryMode = true;
				PlayState.storyFreeplay = false;

				var difficulty:Int = 0;
					
				if (SaveData.lockedRoute.endsWith('DOKI')) difficulty = 1;
				
				var diffic = CoolUtil.getDifficultyFilePath(difficulty);
				if(diffic == null) diffic = '';

				PlayState.storyDifficulty = difficulty;
				
				PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
				PlayState.campaignScore = 0;
				PlayState.campaignMisses = 0;
				
				PlayState.campaignScore = 0;
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				FlxG.switchState(new LoadingState(new PlayState(), true, true));
			}
			else
			{
				if (ghostMenuEasterEgg)
				{
					trace('DIE');
					CoolUtil.playMusic('ghostMenu');
				}
				else
				{
					CoolUtil.playMusic(CoolUtil.getTitleTheme());
				}
			}
		}

		if (endEasterEgg)
			Conductor.changeBPM(156);
		else
			Conductor.changeBPM(101);

		swagShader = new ColorSwap();

		if (ghostMenuEasterEgg)
			sprSuffix = "ghost";
		else if (classicEasterEgg)
			sprSuffix = "classic";
		else if (endEasterEgg)
			sprSuffix = "end";
		else if (monkerEasterEgg)
			sprSuffix = "OG";

		persistentUpdate = true;

		if (ghostMenuEasterEgg)
			bgRGB = [0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF];
		else
			setDefaultRGB();

		titleBg = new DDLCBorderBG(Paths.image('mainmenu/rgbBg'), -40, -40);
		add(titleBg);

		bfTitle = new FlxSprite(370, 750).loadGraphic(Paths.image('mainmenu/chars/bf_' + sprSuffix));
		bfTitle.setGraphicSize(Std.int(bfTitle.width * 0.5));
		bfTitle.updateHitbox();
		bfTitle.antialiasing = ClientPrefs.globalAntialiasing;
		bfTitle.shader = swagShader.shader;

		if ((SaveData.lockedRoute == 'JR' || SaveData.lockedRoute == 'JRDOKI') && !ghostMenuEasterEgg) bfTitle.loadGraphic(Paths.image('mainmenu/chars/glitch_menu'));

		gfTitle = new FlxSprite(490, 750).loadGraphic(Paths.image('mainmenu/chars/gf_' + sprSuffix));
		gfTitle.setGraphicSize(Std.int(gfTitle.width * 0.5));
		gfTitle.updateHitbox();
		gfTitle.antialiasing = ClientPrefs.globalAntialiasing;
		gfTitle.shader = swagShader.shader;

		if ((SaveData.lockedRoute == 'JR' || SaveData.lockedRoute == 'JRDOKI') && !ghostMenuEasterEgg) gfTitle.loadGraphic(Paths.image('mainmenu/chars/glitch_menu'));

		jrTitle = new FlxSprite(650, 750).loadGraphic(Paths.image('mainmenu/chars/jr_' + sprSuffix));
		jrTitle.setGraphicSize(Std.int(jrTitle.width * 0.55));
		jrTitle.updateHitbox();
		jrTitle.antialiasing = ClientPrefs.globalAntialiasing;
		jrTitle.shader = swagShader.shader;

		if ((SaveData.lockedRoute == 'BF' || SaveData.lockedRoute == 'BFDOKI') && !ghostMenuEasterEgg) jrTitle.loadGraphic(Paths.image('mainmenu/chars/glitch_menu'));

		monikaTitle = new FlxSprite(820, 750).loadGraphic(Paths.image('mainmenu/chars/monika_' + sprSuffix));
		monikaTitle.setGraphicSize(Std.int(monikaTitle.width * 0.51));
		monikaTitle.updateHitbox();
		monikaTitle.antialiasing = ClientPrefs.globalAntialiasing;
		monikaTitle.shader = swagShader.shader;

		sayoriTitle = new FlxSprite(190, 750).loadGraphic(Paths.image('mainmenu/chars/sayori_' + sprSuffix));
		sayoriTitle.setGraphicSize(Std.int(sayoriTitle.width * 0.5));
		sayoriTitle.updateHitbox();
		sayoriTitle.antialiasing = ClientPrefs.globalAntialiasing;
		sayoriTitle.shader = swagShader.shader;

		yuriTitle = new FlxSprite(50, 750).loadGraphic(Paths.image('mainmenu/chars/yuri_' + sprSuffix));
		yuriTitle.setGraphicSize(Std.int(yuriTitle.width * 0.5));
		yuriTitle.updateHitbox();
		yuriTitle.antialiasing = ClientPrefs.globalAntialiasing;
		yuriTitle.shader = swagShader.shader;

		natsukiTitle = new FlxSprite(980, 730).loadGraphic(Paths.image('mainmenu/chars/natsuki_' + sprSuffix));
		natsukiTitle.setGraphicSize(Std.int(natsukiTitle.width * 0.5));
		natsukiTitle.updateHitbox();
		natsukiTitle.antialiasing = ClientPrefs.globalAntialiasing;
		natsukiTitle.shader = swagShader.shader;

		add(yuriTitle);
		add(sayoriTitle);
		add(natsukiTitle);
		add(monikaTitle);
		if (!classicEasterEgg)
		{
			add(gfTitle);
			add(jrTitle);
			add(bfTitle);
		}

		if (classicEasterEgg)
		{
			logoBl = new FlxSprite(-100, -320).loadGraphic(Paths.image('mainmenu/og-logo'));
			monikaTitle.setGraphicSize(Std.int(monikaTitle.width * 1.3));
			sayoriTitle.setGraphicSize(Std.int(sayoriTitle.width * 1.35));
			yuriTitle.setGraphicSize(Std.int(yuriTitle.width * 1.15));
			natsukiTitle.setGraphicSize(Std.int(natsukiTitle.width * 1.1));
			sayoriTitle.x = 120;
			yuriTitle.x = 300;
			natsukiTitle.x = 680;
			monikaTitle.x = 950;
			sayoriTitle.y = 900;
			yuriTitle.y = 900;
			natsukiTitle.y = 900;
			monikaTitle.y = 900;
		}
		else if (monkerEasterEgg)
		{
			logoBl = new FlxSprite(-100, -390).loadGraphic(Paths.image('mainmenu/previous-logo'));
		}
		else
			logoBl = new FlxSprite(-100, -320).loadGraphic(Paths.image('mainmenu/update-logo'));
		logoBl.setGraphicSize(Std.int(logoBl.width * 0.45));
		logoBl.updateHitbox();
		logoBl.antialiasing = ClientPrefs.globalAntialiasing;
		logoBl.screenCenter(X);
		add(logoBl);
		logoBl.shader = swagShader.shader;

		titleText = new FlxSprite(0, 620);
		titleText.frames = Paths.getSparrowAtlas('titleEnter');
		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		titleText.antialiasing = true;
		titleText.animation.play('idle');
		titleText.updateHitbox();
		titleText.antialiasing = ClientPrefs.globalAntialiasing;
		titleText.screenCenter(X);
		add(titleText);
		titleText.shader = swagShader.shader;

		if (ghostMenuEasterEgg)
		{
			logoBl.alpha = 0;
			titleText.alpha = 0;
		}

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		if (classicEasterEgg || ghostMenuEasterEgg)
			blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		else if (endEasterEgg)
			blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF820000);
		else
			blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
		credGroup.add(blackScreen);

		credTexttrash = new Alphabet(0, 0, "", true);
		credTexttrash.screenCenter();

		credTexttrash.visible = false;

		tsSpr = new FlxSprite(0, FlxG.height * 0.6).loadGraphic(Paths.image('mainmenu/team_salvato_logo'));
		add(tsSpr);
		tsSpr.visible = false;
		tsSpr.setGraphicSize(Std.int(tsSpr.width * 0.8));
		tsSpr.updateHitbox();
		tsSpr.screenCenter(X);
		tsSpr.antialiasing = true;

		tdSpr = new FlxSprite().loadGraphic(Paths.image('mainmenu/team_ds_logo-new'));
		add(tdSpr);
		tdSpr.alpha = 0;
		tdSpr.screenCenter(Y);
		tdSpr.screenCenter(X);
		tdSpr.antialiasing = true;

		textNormal1 = new FlxText(0, 0, (FlxG.width), "", 30);
		textNormal1.setFormat(Paths.font("doki.ttf"), 30, FlxColor.BLACK, CENTER);
		textNormal1.screenCenter(Y);
		textNormal1.y -= 20;
		textNormal1.alpha = 0;
		textNormal1.text = curWacky[0];
		add(textNormal1);

		textNormal2 = new FlxText(0, 0, (FlxG.width), "", 30);
		textNormal2.setFormat(Paths.font("doki.ttf"), 30, FlxColor.BLACK, CENTER);
		textNormal2.screenCenter(Y);
		textNormal2.y += 20;
		textNormal2.alpha = 0;
		textNormal2.text = curWacky[1];
		add(textNormal2);

		textNormal3 = new FlxText(0, 0, (FlxG.width), "", 30);
		textNormal3.setFormat(Paths.font("doki.ttf"), 30, FlxColor.BLACK, CENTER);
		textNormal3.screenCenter(Y);
		textNormal3.y += 60;
		textNormal3.alpha = 0;
		textNormal3.text = curWacky[1];
		add(textNormal3);

		smol = new FlxSprite(0, FlxG.height * 0.55).loadGraphic(Paths.image('mainmenu/chars/Monker_easteregg'));
		add(smol);
		smol.alpha = 0;
		smol.setGraphicSize(Std.int(smol.width * 0.5));
		smol.updateHitbox();
		smol.screenCenter(X);
		smol.antialiasing = true;

		dieScreen = new FlxSprite(0, 0).loadGraphic(Paths.image('mainmenu/cattoboireference'));
		if (ghostMenuEasterEgg)
			add(dieScreen);
		dieScreen.screenCenter();
		dieScreen.antialiasing = true;
		dieScreen.alpha = 0;

		FlxTween.tween(credTexttrash, {y: credTexttrash.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});

		if (initialized)
			skipIntro();
		else
			initialized = true;
	}

	function getIntroTextTrash():Array<Array<String>>
	{
		var fullText:String;
		fullText = Assets.getText(Paths.txt('introTextNormal'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	function getSecretIntroTextTrash():Array<Array<String>>
	{
		var fullText:String = '';
		fullText = Assets.getText(Paths.txt('introTextSecret'));
		
		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];
		
		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}
		
		return swagGoodArray;
	}

	var transitioning:Bool = false;
	private static var playJingle:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER || FlxG.mouse.justPressed;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}

		// EASTER EGG

		if (initialized && !transitioning && skippedIntro && !ghostMenuEasterEgg)
		{
			if(pressedEnter)
			{
				if(titleText != null) titleText.animation.play('press');

				FlxG.camera.flash(FlxColor.WHITE, 1);
				FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

				transitioning = true;

				CustomFadeTransition.isHeartTran = true;
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					openSubState(new CustomFadeTransition(0.4, false, new MainMenuState()));
					closedState = true;
				});
			}
		}

		if (initialized && pressedEnter && !skippedIntro && !ghostMenuEasterEgg)
		{
			skipIntro();
		}

		if(swagShader != null && !ghostMenuEasterEgg)
		{
			if(controls.UI_LEFT) swagShader.hue -= elapsed * 0.1;
			if(controls.UI_RIGHT) swagShader.hue += elapsed * 0.1;
		}

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>, ?offset:Float = 0)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			money.screenCenter(X);
			money.y += (i * 60) + 200 + offset;
			if(credGroup != null && textGroup != null) {
				credGroup.add(money);
				textGroup.add(money);
			}
		}
	}

	function addMoreText(text:String, ?offset:Float = 0)
	{
		if(textGroup != null && credGroup != null) {
			var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
			coolText.screenCenter(X);
			coolText.y += (textGroup.length * 60) + 200 + offset;
			credGroup.add(coolText);
			textGroup.add(coolText);
		}
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	public static function setDefaultRGB()
	{
		if (endEasterEgg)
			bgRGB = [0xFFCA1616, 0xFF950000, 0xFF560000];
		else
			bgRGB = [0xFFFFFFFF, 0xFFFFDBF0, 0xFFFFBDE1];
	}

	private var sickBeats:Int = 0; //Basically curBeat but won't be skipped if you hold the tab or resize the screen
	public static var closedState:Bool = false;
	override function beatHit()
	{
		super.beatHit();

		if(!closedState) {
			sickBeats++;
			if (!ghostMenuEasterEgg)
			{
				if (endEasterEgg)
				{
					switch (curBeat)
					{
						case 3:
							FlxTween.tween(tdSpr, {alpha: 1}, 0.5);
						case 7:
							FlxTween.tween(tdSpr, {alpha: 0}, 0.5);
						case 10:
							textNormal1.text = "This is my final goodbye to Friday Night Funkin'";
							textNormal2.text = "F O R E V E R";
							FlxTween.tween(textNormal1, {alpha: 1}, 0.5);
							FlxTween.tween(textNormal2, {alpha: 1}, 0.5);
						case 15:
							FlxTween.tween(textNormal1, {alpha: 0}, 0.5);
							FlxTween.tween(textNormal2, {alpha: 0}, 0.5);
						case 18:
							textNormal1.text = "DDFNFCDX";
							textNormal1.alpha = 1;
						case 20:
							textNormal2.text = "The";
							textNormal2.alpha = 1;
						case 22:
							textNormal3.text = "End";
							textNormal3.alpha = 1;
						case 24:
							skipIntro();
					}
				}
				else if (classicEasterEgg)
				{
					switch (curBeat)
					{
						case 1:
							createCoolText(['Team DS']);
						case 3:
							addMoreText('present');
						case 4:
							deleteCoolText();
						case 5:
							createCoolText(['Based on', 'the original work by'], -40);
						case 7:
							addMoreText('Team Salvato');
							tsSpr.visible = true;
						case 8:
							deleteCoolText();
							tsSpr.visible = false;
							addMoreText('This mod is not');
						case 9:
							addMoreText('suitable for children');
						case 10:
							addMoreText('or those who are');
						case 11:	
							addMoreText('easily disturbed');
						case 12:
							deleteCoolText();
						case 13:
							createCoolText([curWacky[0]]);
						case 15:
							addMoreText(curWacky[1]);
						case 16:
							deleteCoolText();
							curWacky = FlxG.random.getObject(getSecretIntroTextTrash());
						case 17:
							createCoolText([curWacky[0]]);
						case 19:
							addMoreText(curWacky[1]);
						case 20:
							deleteCoolText();
							curWacky = FlxG.random.getObject(getSecretIntroTextTrash());
						case 21:
							createCoolText([curWacky[0]]);
						case 23:
							addMoreText(curWacky[1]);
						case 24:
							deleteCoolText();
							addMoreText('Doki');
						case 26:
							addMoreText('Doki');
						case 28:
							addMoreText("Friday Night Funkin'");
						case 30:
							addMoreText('Club');
						case 32:
							skipIntro();
					}
				}
				else
				{
					switch (curBeat)
					{
						case 2:
							FlxTween.tween(tdSpr, {alpha: 1}, 0.5);
						case 5:
							FlxTween.tween(tdSpr, {alpha: 0}, 0.5);
						case 7:
							if (monkerEasterEgg)
							{
								textNormal1.text = "Monker";
								FlxTween.tween(textNormal1, {alpha: 1}, 0.5);
								FlxTween.tween(smol, {alpha: 1}, 0.5);
							}
							else
							{
								FlxTween.tween(textNormal1, {alpha: 1}, 0.5);
								FlxTween.tween(textNormal2, {alpha: 1}, 0.5);
							}
						case 11:
							if (monkerEasterEgg)
							{
								FlxTween.tween(textNormal1, {alpha: 0}, 0.5);
								FlxTween.tween(smol, {alpha: 0}, 0.5);
							}
							else
							{
								FlxTween.tween(textNormal1, {alpha: 0}, 0.5);
								FlxTween.tween(textNormal2, {alpha: 0}, 0.5);
							}
						case 13:
							textNormal1.text = "Doki Doki";
							textNormal1.alpha = 1;
						case 14:
							textNormal2.text = "Friday Night Funkin' Club";
							textNormal2.alpha = 1;
						case 15:
							textNormal3.text = "Deluxe!";
							textNormal3.alpha = 1;
						case 16:
							skipIntro();
					}
				}
			}
			else
			{
				if (!skippedIntro)
				{
					switch (curBeat)
					{
						case 5:
							FlxTween.tween(dieScreen, {alpha: 1}, 0.7);
						case 12:
							dieScreen.alpha = 0;
							skipIntro();
					}
				}
			}
		}
	}

	var skippedIntro:Bool = false;
	var increaseVolume:Bool = false;
	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			remove(tdSpr);
			remove(textNormal1);
			remove(textNormal2);
			remove(textNormal3);
			remove(tsSpr);
			remove(smol);

			FlxG.camera.flash(FlxColor.WHITE, 2);
			remove(credGroup);
			skippedIntro = true;
			if (!closedState)
			{
				new FlxTimer().start(0.5, function(tmr:FlxTimer)
				{
					FlxTween.tween(logoBl, {y: -2}, 1.3, {type:PERSIST, ease:FlxEase.bounceOut});
					if (classicEasterEgg)
					{
						FlxTween.tween(monikaTitle, {y: 320}, 1.1, {type:PERSIST, ease:FlxEase.backInOut});
						FlxTween.tween(sayoriTitle, {y: 320}, 1.1, {type:PERSIST, ease:FlxEase.backInOut});
						FlxTween.tween(yuriTitle, {y: 290}, 1, {type:PERSIST, ease:FlxEase.backInOut});
						FlxTween.tween(natsukiTitle, {y: 320}, 1, {type:PERSIST, ease:FlxEase.backInOut});
					}
					else
					{
						FlxTween.tween(monikaTitle, {y: 240}, 1.1, {type:PERSIST, ease:FlxEase.backInOut});
						FlxTween.tween(sayoriTitle, {y: 240}, 1.1, {type:PERSIST, ease:FlxEase.backInOut});
						FlxTween.tween(yuriTitle, {y: 180}, 1, {type:PERSIST, ease:FlxEase.backInOut});
						FlxTween.tween(natsukiTitle, {y: 260}, 1, {type:PERSIST, ease:FlxEase.backInOut});

						FlxTween.tween(bfTitle, {y: 280}, 1.2, {type:PERSIST, ease:FlxEase.backInOut});
						FlxTween.tween(gfTitle, {y: 250}, 1.3, {type:PERSIST, ease:FlxEase.backInOut});
						FlxTween.tween(jrTitle, {y: 250}, 1.2, {type:PERSIST, ease:FlxEase.backInOut});
					}
				});
			}
			else
			{
				logoBl.y = -5;
				if (classicEasterEgg)
				{
					monikaTitle.y = 380;
					sayoriTitle.y = 240;
					yuriTitle.y = 90;
					natsukiTitle.y = 140;
				}
				else
				{
					if (endEasterEgg)
					{
						monikaTitle.y = 240;
						sayoriTitle.y = 240;
						yuriTitle.y = 180;
						natsukiTitle.y = 230;
					}
					else
					{
						monikaTitle.y = 240;
						sayoriTitle.y = 240;
						yuriTitle.y = 180;
						natsukiTitle.y = 260;
					}
				}
			}
		}
	}
}
