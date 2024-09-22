package states;

import flixel.addons.display.FlxBackdrop;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.ui.FlxButtonPlus;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import lime.utils.Assets;
import openfl.utils.Assets as OpenFlAssets;
import sys.io.File;
import sys.FileSystem;
import haxe.Json;
import haxe.format.JsonParser;
import openfl.display.BitmapData;
import flash.geom.Rectangle;
import flixel.ui.FlxButton;
import flixel.FlxBasic;
import sys.io.File;
import flixel.addons.ui.FlxUIInputText;

class SaveFileState extends MusicBeatState
{
	var percentage:Float;
	var bfAct:String = "";
	var jrAct:String = "";
	var moniAct:String = "";
	var selector:AttachedSprite;
	var buttonEnterCode:FlxButton;
	var buttonResetStoryData:FlxButton;
	var buttonResetHighscores:FlxButton;
	var buttonResetAchievements:FlxButton;
	var buttonResetAll:FlxButton;
	var yesTxt:FlxText;
	var noTxt:FlxText;
	var popUpVisible:Bool = false;
	var enterCode:Bool = false;
	var popUpID:Int = 0;
	var popUpMessage:FlxSprite;
	var popUpText:FlxText;
	var yesText:FlxText;
	var noText:FlxText;
	var codeInputText:FlxUIInputText;
	var yesOverlap:Bool = false;
	var noOverlap:Bool = false;
	var white:FlxSprite;
	var gameProgress:FlxText;
	var bfRouteProgress:FlxText;
	var jrRouteProgress:FlxText;
	var moniRouteProgress:FlxText;
	var normalSongsCleared:FlxText;
	var classicSongsCleared:FlxText;
	var bonusSongsCleared:FlxText;
	var isBigWarning:Bool = false;

	var boxSuffix:String = '';

	private var blockPressWhileTypingOn:Array<FlxUIInputText> = [];

	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		TitleState.setDefaultRGB();
		var titleBg:DDLCBorderBG;

		titleBg = new DDLCBorderBG(Paths.image('mainmenu/rgbBg'), -40, -40);
		add(titleBg);

		if (TitleState.endEasterEgg)
			boxSuffix = '-act3';

		selector = new AttachedSprite();
		selector.xAdd = -205;
		selector.yAdd = -68;
		selector.alphaMult = 0.5;
		makeSelectorGraphic();
		add(selector);
		selector.screenCenter();
		selector.alpha = 0.5;

		var gameText:FlxText = new FlxText(selector.x, selector.y + 30, selector.width, "DDFNFCDX Save Data", 48);
		gameText.setFormat(Paths.font("dokiUI.ttf"), 40, FlxColor.WHITE, FlxTextAlign.CENTER);
		gameText.setBorderStyle(OUTLINE, 0xFFBB5599, 6);
		add(gameText);

		gameProgress = new FlxText(selector.x + 10, selector.y + 150, 0, "", 32);
		gameProgress.setFormat(Paths.font("doki.ttf"), 32, FlxColor.WHITE, FlxTextAlign.LEFT);
		gameProgress.borderColor = 0xFF000000;
		gameProgress.borderStyle = OUTLINE;
		gameProgress.borderSize = 1.5;
		add(gameProgress);

		bfRouteProgress = new FlxText(selector.x + 10, gameProgress.y + 50, 0, "", 32);
		bfRouteProgress.setFormat(Paths.font("doki.ttf"), 32, FlxColor.WHITE, FlxTextAlign.LEFT);
		bfRouteProgress.borderColor = 0xFF000000;
		bfRouteProgress.borderStyle = OUTLINE;
		bfRouteProgress.borderSize = 1.5;
		add(bfRouteProgress);

		jrRouteProgress = new FlxText(selector.x + 10, bfRouteProgress.y + 50, 0, "", 32);
		jrRouteProgress.setFormat(Paths.font("doki.ttf"), 32, FlxColor.WHITE, FlxTextAlign.LEFT);
		jrRouteProgress.borderColor = 0xFF000000;
		jrRouteProgress.borderStyle = OUTLINE;
		jrRouteProgress.borderSize = 1.5;
		add(jrRouteProgress);

		moniRouteProgress = new FlxText(selector.x + 10, jrRouteProgress.y + 50, 0, "", 32);
		moniRouteProgress.setFormat(Paths.font("doki.ttf"), 32, FlxColor.WHITE, FlxTextAlign.LEFT);
		moniRouteProgress.borderColor = 0xFF000000;
		moniRouteProgress.borderStyle = OUTLINE;
		moniRouteProgress.borderSize = 1.5;
		add(moniRouteProgress);

		normalSongsCleared = new FlxText(selector.x - 10, selector.y + 150, selector.width, "", 32);
		normalSongsCleared.setFormat(Paths.font("doki.ttf"), 32, FlxColor.WHITE, FlxTextAlign.RIGHT);
		normalSongsCleared.borderColor = 0xFF000000;
		normalSongsCleared.borderStyle = OUTLINE;
		normalSongsCleared.borderSize = 1.5;
		add(normalSongsCleared);

		classicSongsCleared = new FlxText(selector.x - 10, gameProgress.y + 50, selector.width, "", 32);
		classicSongsCleared.setFormat(Paths.font("doki.ttf"), 32, FlxColor.WHITE, FlxTextAlign.RIGHT);
		classicSongsCleared.borderColor = 0xFF000000;
		classicSongsCleared.borderStyle = OUTLINE;
		classicSongsCleared.borderSize = 1.5;
		add(classicSongsCleared);

		bonusSongsCleared = new FlxText(selector.x - 10, bfRouteProgress.y + 50, selector.width, "", 32);
		bonusSongsCleared.setFormat(Paths.font("doki.ttf"), 32, FlxColor.WHITE, FlxTextAlign.RIGHT);
		bonusSongsCleared.borderColor = 0xFF000000;
		bonusSongsCleared.borderStyle = OUTLINE;
		bonusSongsCleared.borderSize = 1.5;
		add(bonusSongsCleared);

		buttonEnterCode = new FlxButton(selector.x + 25, (selector.y + selector.height) - 48, "Enter Code", function()
		{
			if (!enterCode && !popUpVisible)
			{
				enterCodeThing();
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);
			}
		});
		buttonEnterCode.setGraphicSize(150, 45);
		buttonEnterCode.updateHitbox();
		buttonEnterCode.label.setFormat(Paths.font("vcr.ttf"), 19, FlxColor.BLACK, CENTER);
		buttonEnterCode.label.fieldWidth = 150;
		setAllLabelsOffset(buttonEnterCode, 0, 8);
		add(buttonEnterCode);

		buttonResetStoryData = new FlxButton(buttonEnterCode.x + 160, (selector.y + selector.height) - 48, "Delete Story Data", function()
		{
			if (!enterCode && !popUpVisible)
			{
				warningPopUp(1);
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);
			}
		});
		buttonResetStoryData.setGraphicSize(150, 45);
		buttonResetStoryData.updateHitbox();
		buttonResetStoryData.label.setFormat(Paths.font("vcr.ttf"), 19, FlxColor.BLACK, CENTER);
		buttonResetStoryData.label.fieldWidth = 150;
		add(buttonResetStoryData);

		buttonResetHighscores = new FlxButton(buttonResetStoryData.x + 160, (selector.y + selector.height) - 48, "Delete Highscores", function()
		{
			if (!enterCode && !popUpVisible)
			{
				warningPopUp(2);
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);
			}
		});
		buttonResetHighscores.setGraphicSize(150, 45);
		buttonResetHighscores.updateHitbox();
		buttonResetHighscores.label.setFormat(Paths.font("vcr.ttf"), 19, FlxColor.BLACK, CENTER);
		buttonResetHighscores.label.fieldWidth = 150;
		add(buttonResetHighscores);

		buttonResetAchievements = new FlxButton(buttonResetHighscores.x + 160, (selector.y + selector.height) - 48, "Delete Achievements", function()
		{
			if (!enterCode && !popUpVisible)
			{
				warningPopUp(3);
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);
			}
		});
		buttonResetAchievements.setGraphicSize(150, 45);
		buttonResetAchievements.updateHitbox();
		buttonResetAchievements.label.setFormat(Paths.font("vcr.ttf"), 19, FlxColor.BLACK, CENTER);
		buttonResetAchievements.label.fieldWidth = 150;
		add(buttonResetAchievements);

		buttonResetAll = new FlxButton(buttonResetAchievements.x + 160, (selector.y + selector.height) - 48, "Delete All Data", function()
		{
			if (!enterCode && !popUpVisible)
			{
				warningPopUp(4);
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);
			}
		});
		buttonResetAll.setGraphicSize(150, 45);
		buttonResetAll.updateHitbox();
		buttonResetAll.label.setFormat(Paths.font("vcr.ttf"), 19, FlxColor.BLACK, CENTER);
		buttonResetAll.label.fieldWidth = 150;
		add(buttonResetAll);

		var saveIcon:FlxSprite = new FlxSprite(selector.x, selector.y);

		if (SaveData.clearAllNormal && SaveData.clearAllClassic && SaveData.clearAllBonus)
		{
			saveIcon.loadGraphic(Paths.image('save/all-clear'));
		}
		else if (SaveData.clearAllClassic)
		{
			saveIcon.loadGraphic(Paths.image('save/classic-clear'));
		}
		else if (SaveData.bfRouteClear && SaveData.jrRouteClear && SaveData.monikaRouteClear)
		{
			saveIcon.loadGraphic(Paths.image('save/3-route-clear'));
		}
		else if ((SaveData.bfRouteClear && SaveData.jrRouteClear) || 
				(SaveData.jrRouteClear && SaveData.monikaRouteClear) ||
				(SaveData.bfRouteClear && SaveData.monikaRouteClear))
		{
			saveIcon.loadGraphic(Paths.image('save/2-route-clear'));
		}
		else if (SaveData.bfRouteClear || SaveData.jrRouteClear || SaveData.monikaRouteClear)
		{
			saveIcon.loadGraphic(Paths.image('save/1-route-clear'));
		}
		else if (SaveData.bfRoute != 0 || SaveData.jrRoute != 0 || SaveData.monikaRoute != 0)
		{
			saveIcon.loadGraphic(Paths.image('save/route-start'));
		}
		else
		{
			saveIcon.loadGraphic(Paths.image('save/start'));
		}

		saveIcon.antialiasing = ClientPrefs.globalAntialiasing;
		add(saveIcon);

		white = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
        white.alpha = 0;
		add(white);

		popUpMessage = new FlxSprite(0, 0).loadGraphic(Paths.image('blankPopup' + boxSuffix));
		popUpMessage.antialiasing = ClientPrefs.globalAntialiasing;
		popUpMessage.screenCenter();
		add(popUpMessage);
		popUpMessage.alpha = 0;

		popUpText = new FlxText(0, popUpMessage.y + 76, popUpMessage.width * 0.95, '');
		popUpText.setFormat(Paths.font('doki.ttf'), 32, FlxColor.BLACK, FlxTextAlign.CENTER);
		popUpText.screenCenter(X);
		popUpText.antialiasing = ClientPrefs.globalAntialiasing;
		add(popUpText);
		popUpText.alpha = 0;

		yesText = new FlxText(500, popUpMessage.y + 240, 0, "Yes");
		yesText.setFormat(Paths.font("dokiUI.ttf"), 32, FlxColor.WHITE, FlxTextAlign.CENTER);
		yesText.setBorderStyle(OUTLINE, 0xFFBB5599, 3); 
		add(yesText);
		yesText.alpha = 0;

		noText = new FlxText(750, popUpMessage.y + 240, 0, "No");
		noText.setFormat(Paths.font("dokiUI.ttf"), 32, FlxColor.WHITE, FlxTextAlign.CENTER);
		noText.setBorderStyle(OUTLINE, 0xFFBB5599, 3); 
		add(noText);
		noText.alpha = 0;

		codeInputText = new FlxUIInputText(420, popUpMessage.y + 240, 450, '', 24);
		add(codeInputText);
		blockPressWhileTypingOn.push(codeInputText);
		codeInputText.visible = false;
		
		FlxG.mouse.visible = true;
		MusicBeatState.reloadCursor();
		updateText();

		super.create();
	}

	var canExit:Bool = true;
	override function update(elapsed:Float)
	{
		if(canExit && controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			openSubState(new CustomFadeTransition(0.6, false, new ExtraStuffState()));
		}

		if (FlxG.mouse.overlaps(yesText) && popUpVisible)
		{
			if (!yesOverlap)
			{
				yesOverlap = true;
				FlxG.sound.play(Paths.sound('scrollMenu'));
				yesText.setBorderStyle(OUTLINE, 0xFFFFAACC, 3.5);
			}
			if (FlxG.mouse.justPressed)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));
				if (popUpID == 4)
					warning2();
				else if (popUpID == 5)
					warning3();
				else
					resetThing();
			}
		}
		else
		{
			yesOverlap = false;
			yesText.setBorderStyle(OUTLINE, 0xFFBB5599, 3.5);
		}

		if (FlxG.mouse.overlaps(noText) && popUpVisible)
		{
			if (!noOverlap)
			{
				noOverlap = true;
				FlxG.sound.play(Paths.sound('scrollMenu'));
				noText.setBorderStyle(OUTLINE, 0xFFFFAACC, 3.5);
			}
			if (FlxG.mouse.justPressed)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));
				popUpDisapear();
			}
		}
		else
		{
			noOverlap = false;
			noText.setBorderStyle(OUTLINE, 0xFFBB5599, 3.5);
		}

		if (enterCode)
		{
			if (FlxG.keys.justPressed.ESCAPE)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				enterCode = false;
				popUpMessage.alpha = 0;
				popUpText.alpha = 0;
				codeInputText.visible = false;
				white.alpha = 0;
				canExit = true;
				codeInputText.text = '';
			}
			if (FlxG.keys.justPressed.ENTER)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));
				proccessCode(codeInputText.text);
			}
		}

		var blockInput:Bool = false;
		for (inputText in blockPressWhileTypingOn) {
			if(inputText.hasFocus) {
				FlxG.sound.muteKeys = [];
				FlxG.sound.volumeDownKeys = [];
				FlxG.sound.volumeUpKeys = [];
				blockInput = true;
				break;
			}
		}

		if(!blockInput) {
			FlxG.sound.muteKeys = TitleState.muteKeys;
			FlxG.sound.volumeDownKeys = TitleState.volumeDownKeys;
			FlxG.sound.volumeUpKeys = TitleState.volumeUpKeys;
		}

		super.update(elapsed);
	}

	var cornerSize:Int = 11;
	function makeSelectorGraphic()
	{
		selector.makeGraphic(870, 450, FlxColor.BLACK);
		selector.pixels.fillRect(new Rectangle(0, selector.height - 55, selector.width, 5), 0x0);

		// Why did i do this? Because i'm a lmao stupid, of course
		// also i wanted to understand better how fillRect works so i did this trash lol???
		selector.pixels.fillRect(new Rectangle(0, 0, cornerSize, cornerSize), 0x0);														 //top left
		drawCircleCornerOnSelector(false, false);
		selector.pixels.fillRect(new Rectangle(selector.width - cornerSize, 0, cornerSize, cornerSize), 0x0);							 //top right
		drawCircleCornerOnSelector(true, false);
		selector.pixels.fillRect(new Rectangle(0, selector.height - cornerSize, cornerSize, cornerSize), 0x0);							 //bottom left
		drawCircleCornerOnSelector(false, true);
		selector.pixels.fillRect(new Rectangle(selector.width - cornerSize, selector.height - cornerSize, cornerSize, cornerSize), 0x0); //bottom right
		drawCircleCornerOnSelector(true, true);
	}

	function drawCircleCornerOnSelector(flipX:Bool, flipY:Bool)
	{
		var antiX:Float = (selector.width - cornerSize);
		var antiY:Float = flipY ? (selector.height - 1) : 0;
		if(flipY) antiY -= 2;
		selector.pixels.fillRect(new Rectangle((flipX ? antiX : 1), Std.int(Math.abs(antiY - 8)), 10, 3), FlxColor.BLACK);
		if(flipY) antiY += 1;
		selector.pixels.fillRect(new Rectangle((flipX ? antiX : 2), Std.int(Math.abs(antiY - 6)),  9, 2), FlxColor.BLACK);
		if(flipY) antiY += 1;
		selector.pixels.fillRect(new Rectangle((flipX ? antiX : 3), Std.int(Math.abs(antiY - 5)),  8, 1), FlxColor.BLACK);
		selector.pixels.fillRect(new Rectangle((flipX ? antiX : 4), Std.int(Math.abs(antiY - 4)),  7, 1), FlxColor.BLACK);
		selector.pixels.fillRect(new Rectangle((flipX ? antiX : 5), Std.int(Math.abs(antiY - 3)),  6, 1), FlxColor.BLACK);
		selector.pixels.fillRect(new Rectangle((flipX ? antiX : 6), Std.int(Math.abs(antiY - 2)),  5, 1), FlxColor.BLACK);
		selector.pixels.fillRect(new Rectangle((flipX ? antiX : 8), Std.int(Math.abs(antiY - 1)),  3, 1), FlxColor.BLACK);
	}

	function warningPopUp(popUpNum:Int = 1)
	{
		popUpID = popUpNum;
		popUpVisible = true;
		popUpMessage.alpha = 1;
		popUpText.alpha = 1;
		yesText.alpha = 1;
		noText.alpha = 1;
		white.alpha = 0.5;
		canExit = false;
		isBigWarning = false;
		yesText.text = "Yes";
		noText.text = "No";
		switch (popUpNum)
		{
			case 1:
				popUpText.text = "Do you wish to erase all your Story Mode data?";
			case 2:
				popUpText.text = "Do you wish to erase all your Highscore data?";
			case 3:
				popUpText.text = "Do you wish to erase some of your Achievement data?\n(Certain Achievements won't be erased)";
			case 4:
				isBigWarning = true;
				popUpText.text = "Do you wish to erase ALL your Save Data?";
		}
	}

	function warning2()
	{
		popUpID = 5;
		popUpText.text = "Are you REALLY sure you want to erase all your Save Data?!";
	}

	function warning3()
	{
		popUpID = 6;
		popUpText.text = "WARNING:\nTHIS ACTION CANNOT BE UNDONE!\nNO REGRETS?!";
		yesText.text = "YES!";
		noText.text = "NO!";
	}

	function popUpDisapear()
	{
		popUpVisible = false;
		popUpMessage.alpha = 0;
		popUpText.alpha = 0;
		yesText.alpha = 0;
		noText.alpha = 0;
		white.alpha = 0;
		canExit = true;
	}

	function resetThing()
	{
		popUpVisible = false;
		popUpMessage.alpha = 0;
		popUpText.alpha = 0;
		yesText.alpha = 0;
		noText.alpha = 0;
		white.alpha = 0;
		canExit = true;

		switch (popUpID)
		{
			case 1:
				SaveData.deleteREGULARStoryData();
			case 2:
				Highscore.resetAllScores();
			case 3:
				Achievements.resetAchievements();
			case 6:
				SaveData.deleteSystem32();
		}
	}

	function updateText()
	{
		percentage = (SaveData.songsCleared / 60) * 100;
		switch (SaveData.bfRoute)
		{
			case 0:
				bfAct = "Not Started";
			case 1 | 2 | 3 | 4:
				bfAct = "Act 1";
			case 5 | 6 | 7 | 8:
				bfAct = "Act 2";
			default:
				bfAct = "Cleared";
		}
		switch (SaveData.jrRoute)
		{
			case 0:
				jrAct = "Not Started";
			case 1 | 2 | 3 | 4:
				jrAct = "Act 1";
			case 5 | 6 | 7 | 8:
				jrAct = "Act 2";
			default:
				jrAct = "Cleared";
		}
		switch (SaveData.monikaRoute)
		{
			case 0:
				moniAct = "Not Started";
			case 1 | 2 | 3 | 4:
				moniAct = "Act 1";
			default:
				moniAct = "Cleared";
		}
		if (SaveData.bfRouteClear) bfAct = "Cleared";
		if (SaveData.jrRouteClear) jrAct = "Cleared";
		if (SaveData.monikaRouteClear) moniAct = "Cleared";

		gameProgress.text = "Game Progress: " + Highscore.floorDecimal(percentage, 1) + "%";
		bfRouteProgress.text = "Boyfriend Route: " + bfAct;
		jrRouteProgress.text = "Bowser Jr Route: " + jrAct;
		moniRouteProgress.text = "Monika Route: " + moniAct;
		normalSongsCleared.text = "Normal Songs: " + SaveData.normalSongs + "/33";
		classicSongsCleared.text = "Classic Songs: " + SaveData.classicSongs + "/16";
		bonusSongsCleared.text = "Bonus Songs: " + SaveData.bonusSongs + "/10";

		if (SaveData.clearAllNormal) normalSongsCleared.text = "Normal Songs: 33/33";
		if (SaveData.clearAllClassic) classicSongsCleared.text = "Classic Songs: 16/16";
		if (SaveData.clearAllBonus) bonusSongsCleared.text = "Bonus Songs: 10/10";
	}

	function setAllLabelsOffset(button:FlxButton, x:Float, y:Float)
	{
		for (point in button.labelOffsets)
		{
			point.set(x, y);
		}
	}

	function enterCodeThing()
	{
		enterCode = true;
		popUpMessage.alpha = 1;
		popUpText.alpha = 1;
		codeInputText.visible = true;
		white.alpha = 0.5;
		popUpText.text = "Enter Code\n(Press ENTER to accept)\n(Press ESCAPE to cancel)";
		canExit = false;
	}

	function proccessCode(code:String = '')
	{
		if (code == 'Dsfan2XMonikaCanon96024')
		{
			SaveData.cheatTheSystem();
			enterCode = false;
			popUpMessage.alpha = 0;
			popUpText.alpha = 0;
			codeInputText.visible = false;
			white.alpha = 0;
			canExit = true;
			Achievements.unlock('first_clear');
			Achievements.unlock('bfRoute_clear');
			Achievements.unlock('jrRoute_clear');
			Achievements.unlock('moniRoute_clear');
			Achievements.unlock('normal_clear');
			Achievements.unlock('classic_clear');
			Achievements.unlock('bonus_clear');
			Achievements.unlock('all_clear');
			codeInputText.text = '';
			openSubState(new CustomFadeTransition(0.6, false, new ExtraStuffState()));
		}
		else
		{
			switch (code.toLowerCase())
			{
				case 'c c d c f e':
					FlxG.sound.music.stop();
					SecretsState.code = 'Amanda';
					FlxTransitionableState.skipNextTransOut = true;
					openSubState(new CustomFadeTransition(0.6, false, new SecretsState()));
				case 'fountain':
					FlxG.sound.music.stop();
					SecretsState.code = 'Kinito';
					FlxTransitionableState.skipNextTransOut = true;
					openSubState(new CustomFadeTransition(0.6, false, new SecretsState()));
				case '1997':
					FlxG.sound.music.stop();
					SecretsState.code = 'Spam';
					FlxTransitionableState.skipNextTransOut = true;
					openSubState(new CustomFadeTransition(0.6, false, new SecretsState()));
				case 'xddcc':
					FlxG.sound.music.stop();
					SecretsState.code = 'Pomni';
					FlxTransitionableState.skipNextTransOut = true;
					openSubState(new CustomFadeTransition(0.6, false, new SecretsState()));
				case 'darkxwolf17':
					FlxG.sound.music.stop();
					SecretsState.code = 'Cyn';
					FlxTransitionableState.skipNextTransOut = true;
					openSubState(new CustomFadeTransition(0.6, false, new SecretsState()));
				case 'ugly worm':
					FlxG.sound.music.stop();
					SecretsState.code = 'Funkin';
					FlxTransitionableState.skipNextTransOut = true;
					openSubState(new CustomFadeTransition(0.6, false, new SecretsState()));
				case 'mario party ds':
					FlxG.sound.music.stop();
					SecretsState.code = 'Hallyboo';
					FlxTransitionableState.skipNextTransOut = true;
					openSubState(new CustomFadeTransition(0.6, false, new SecretsState()));
				case 'you are my sunshine':
					FlxG.sound.music.stop();
					SecretsState.code = 'Sunshine';
					FlxTransitionableState.skipNextTransOut = true;
					openSubState(new CustomFadeTransition(0.6, false, new SecretsState()));
				case 'skaterboi360':
					FlxG.sound.music.stop();
					SecretsState.code = 'JustArt';
					FlxTransitionableState.skipNextTransOut = true;
					openSubState(new CustomFadeTransition(0.6, false, new SecretsState()));
				case '5hark was here xoxo':
					FlxG.sound.music.stop();
					SecretsState.code = 'SP1';
					FlxTransitionableState.skipNextTransOut = true;
					openSubState(new CustomFadeTransition(0.6, false, new SecretsState()));
				case 'no but a tin can':
					FlxG.sound.music.stop();
					SecretsState.code = 'SP2';
					FlxTransitionableState.skipNextTransOut = true;
					openSubState(new CustomFadeTransition(0.6, false, new SecretsState()));
				case 'libitina':
					FlxG.sound.music.stop();
					SecretsState.code = 'SP3';
					FlxTransitionableState.skipNextTransOut = true;
					openSubState(new CustomFadeTransition(0.6, false, new SecretsState()));
				case 'poemcupcake':
					FlxG.sound.music.stop();
					SecretsState.code = 'SP4';
					FlxTransitionableState.skipNextTransOut = true;
					openSubState(new CustomFadeTransition(0.6, false, new SecretsState()));
				case 'hello world':
					FlxG.sound.music.stop();
					SecretsState.code = 'SP5';
					FlxTransitionableState.skipNextTransOut = true;
					openSubState(new CustomFadeTransition(0.6, false, new SecretsState()));
				case 'last4cheeze':
					FlxG.sound.music.stop();
					SecretsState.code = 'SP6';
					FlxTransitionableState.skipNextTransOut = true;
					openSubState(new CustomFadeTransition(0.6, false, new SecretsState()));
				case 'faucet':
					FlxG.sound.music.stop();
					SecretsState.code = 'SP7';
					FlxTransitionableState.skipNextTransOut = true;
					openSubState(new CustomFadeTransition(0.6, false, new SecretsState()));
				case 'miku':
					FlxG.sound.music.stop();
					SecretsState.code = 'SP8';
					FlxTransitionableState.skipNextTransOut = true;
					openSubState(new CustomFadeTransition(0.6, false, new SecretsState()));
				case 'migrane':
					FlxG.sound.music.stop();
					SecretsState.code = 'SP9';
					FlxTransitionableState.skipNextTransOut = true;
					openSubState(new CustomFadeTransition(0.6, false, new SecretsState()));
				case 'oranges':
					FlxG.sound.music.stop();
					SecretsState.code = 'SP10';
					FlxTransitionableState.skipNextTransOut = true;
					openSubState(new CustomFadeTransition(0.6, false, new SecretsState()));
				case 'monika after story':
					FlxG.sound.music.stop();
					SecretsState.code = 'SP11';
					FlxTransitionableState.skipNextTransOut = true;
					openSubState(new CustomFadeTransition(0.6, false, new SecretsState()));
				default:
					enterCode = false;
					popUpMessage.alpha = 0;
					popUpText.alpha = 0;
					codeInputText.visible = false;
					white.alpha = 0;
					codeInputText.text = '';
					openSubState(new DDLCPrompt('Error: Code Invalid', 0, function(){canExit = true;}, null, 'OK', null));
			}
		}
	}
}