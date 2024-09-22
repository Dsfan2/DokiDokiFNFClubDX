package states;

import flixel.addons.display.FlxBackdrop;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.addons.text.FlxTypeText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import openfl.Assets;

//Hey JJGamerYT, you're welcome.
class WarningState extends MusicBeatState
{
	var box:FlxSprite;
	var bg1:FlxSprite;
	var bg2:FlxSprite;
	var whiteScreen:FlxSprite;

	var swagDialogue:FlxTypeText;

	var yesButton:FlxSprite;
	var yesText:FlxText;
	var yesHover:Bool = false;
	var noButton:FlxSprite;
	var noText:FlxText;
	var noHover:Bool = false;

	var agreeButton:FlxSprite;
	var agreeText:FlxText;
	var agreeHover:Bool = false;

	var readBox:Bool = false;
	var boxDone:Bool = false;

	var dialogueOpened:Bool = false;
	var dialogueEnded:Bool = false;
	var dialogueStarted:Bool = false;

	var isEnding:Bool = false;
	var curHalf:Int = 1;

	public var finishThing:Void->Void;
	public var nextDialogueThing:Void->Void = null;
	public var skipDialogueThing:Void->Void = null;

	public static var doneWarning:Bool = false;

	var words1:Array<String> = ["Doki Doki Friday Night Funkin' Club Deluxe is a DDLC related FNF mod, not affiliated with Team Salvato", 
	"This mod is designed to be played only after the original DDLC and base FNF have been completed, and contains spoilers for both.", 
	"The original DDLC and FNF can be downloaded for free at http://ddlc.moe and https://ninja-muffin24.itch.io/funkin",
	"Please be aware that this mod contains some flashing lights.",
	"It is reccommended that you disable these if you're sensitive to flashing lights.",
	"Do you wish to disable the flashing lights? (You can change this later in the options menu.)"];

	var words2:Array<String> = ["Understood. Your settings have been updated.",
	"The content contained in this mod is not suitable for children or those who are easily disturbed.", 
	"Individuals suffering from anxiety or depression, may not have a safe experience playing this mod. For the full list of warnings, please read the \"User Licence Agreement.txt\" file.", 
	"By playing Doki Doki FNF Club Deluxe, you agree that you acknowledge the sensitive content warnings, have completed DDLC and FNF, and consent to your exposure to any spoilers and mildly disturbing content."];

	public var dialogueList:Array<String> = [];

	override function create()
	{
		super.create();

		FlxG.mouse.visible = true;
		MusicBeatState.reloadCursor();

		bg1 = new FlxSprite(0, 0).loadGraphic(Paths.image('mainmenu/Sepia-SplashScreen'));
		bg2 = new FlxSprite(0, 0).loadGraphic(Paths.image('mainmenu/SplashScreen'));
		bg1.setGraphicSize(Std.int(FlxG.width));
		bg2.setGraphicSize(Std.int(FlxG.width));
		bg1.updateHitbox();
		bg2.updateHitbox();
		bg1.scrollFactor.set();
		bg2.scrollFactor.set();
		bg1.screenCenter();
		bg2.screenCenter();

		whiteScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
		dialogueList = words1;

		box = new FlxSprite(0, 0).loadGraphic(Paths.image('mainmenu/textbox_doki'));
		box.setGraphicSize(Std.int(box.width * 1.5));
		box.updateHitbox();
		box.screenCenter(X);
		box.y = 480;
		box.visible = false;

		swagDialogue = new FlxTypeText(60, 500, Std.int(box.width * 0.95), "", 32);
		swagDialogue.setFormat(Paths.font("doki.ttf"), 32, FlxColor.WHITE, FlxTextAlign.LEFT);
		swagDialogue.borderColor = 0xFF000000;
		swagDialogue.borderStyle = OUTLINE;
		swagDialogue.borderSize = 1.5;

		yesText = new FlxText(0, 0, 0, "Yes", 40);
		yesText.setFormat(Paths.font("doki.ttf"), 32, FlxColor.BLACK);
		yesText.screenCenter();
		yesText.y -= 30;
		yesText.visible = false;

		yesButton = new FlxSprite(0, 0);
		yesButton.frames = Paths.getSparrowAtlas('mainmenu/button_doki');
		yesButton.antialiasing = true;
		yesButton.animation.addByPrefix('idle', 'idle', 24);
		yesButton.animation.addByPrefix('select', 'select', 24);
		yesButton.animation.play('idle');
		yesButton.setGraphicSize(Std.int(yesButton.width * 1.3));
		yesButton.updateHitbox();
		yesButton.screenCenter();
		yesButton.y -= 30;
		yesButton.visible = false;

		noText = new FlxText(0, 0, 0, "No", 40);
		noText.setFormat(Paths.font("doki.ttf"), 32, FlxColor.BLACK);
		noText.screenCenter();
		noText.y += 30;
		noText.visible = false;

		noButton = new FlxSprite(0, 0);
		noButton.frames = Paths.getSparrowAtlas('mainmenu/button_doki');
		noButton.antialiasing = true;
		noButton.animation.addByPrefix('idle', 'idle', 24);
		noButton.animation.addByPrefix('select', 'select', 24);
		noButton.animation.play('idle');
		noButton.setGraphicSize(Std.int(noButton.width * 1.3));
		noButton.updateHitbox();
		noButton.screenCenter();
		noButton.y += 30;
		noButton.visible = false;

		agreeText = new FlxText(0, 0, 0, "I agree.", 40);
		agreeText.setFormat(Paths.font("doki.ttf"), 32, FlxColor.BLACK);
		agreeText.screenCenter(X);
		agreeText.screenCenter(Y);
		agreeText.visible = false;

		agreeButton = new FlxSprite(0, 0);
		agreeButton.frames = Paths.getSparrowAtlas('mainmenu/button_doki');
		agreeButton.antialiasing = true;
		agreeButton.animation.addByPrefix('idle', 'idle', 24);
		agreeButton.animation.addByPrefix('select', 'select', 24);
		agreeButton.animation.play('idle');
		agreeButton.setGraphicSize(Std.int(agreeButton.width * 1.3));
		agreeButton.updateHitbox();
		agreeButton.screenCenter(X);
		agreeButton.screenCenter(Y);
		agreeButton.visible = false;

		add(bg2);
		add(bg1);
		add(whiteScreen);
		add(box);
		add(yesButton);
		add(yesText);
		add(noButton);
		add(noText);
		add(agreeButton);
		add(agreeText);
		add(swagDialogue);

		startWarning();
	}

	override function update(elapsed:Float)
	{
		if (dialogueOpened && !dialogueStarted)
		{
			dialogueStarted = true;
			startDialogue();
		}
		if (FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE)
		{
			if (dialogueEnded)
			{
				if (dialogueList[1] != null && dialogueList[0] != null)
				{
					dialogueList.remove(dialogueList[0]);
					startDialogue();
				}
			}
			else if (dialogueStarted)
			{
				swagDialogue.skip();
					
				if(skipDialogueThing != null) {
					skipDialogueThing();
				}
			}
		}
		if (dialogueList[1] == null && dialogueList[0] != null && !boxDone && curHalf == 1)
		{
			yesButton.visible = true;
			yesText.visible = true;
			noButton.visible = true;
			noText.visible = true;
			if (FlxG.mouse.overlaps(yesButton) && !noHover)
			{
				yesButton.animation.play('select');
				if (!yesHover)
				{
					yesHover = true;
					FlxG.sound.play(Paths.sound('scrollMenu'));
				}
			}
			else
			{
				yesHover = false;
				yesButton.animation.play('idle');
			}
			if (FlxG.mouse.overlaps(noButton) && !yesHover)
			{
				noButton.animation.play('select');
				if (!noHover)
				{
					noHover = true;
					FlxG.sound.play(Paths.sound('scrollMenu'));
				}
			}
			else
			{
				noHover = false;
				noButton.animation.play('idle');
			}

			if (FlxG.mouse.justPressed)
			{
				if (FlxG.mouse.overlaps(yesButton) && !noHover)
				{
					ClientPrefs.flashing = false;
					FlxG.save.data.flashing = false;
					ClientPrefs.saveSettings();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					continueWarning();
				}
				if (FlxG.mouse.overlaps(noButton) && !yesHover)
				{
					FlxG.save.data.flashing = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));
					continueWarning();
				}
			}
		}
		if (dialogueList[1] == null && dialogueList[0] != null && !boxDone && curHalf == 2)
		{
			agreeButton.visible = true;
			agreeText.visible = true;
			if (FlxG.mouse.overlaps(agreeButton))
			{
				agreeButton.animation.play('select');
				if (!agreeHover)
				{
					agreeHover = true;
					FlxG.sound.play(Paths.sound('scrollMenu'));
				}
			}
			else
			{
				agreeHover = false;
				agreeButton.animation.play('idle');
			}
			if (FlxG.mouse.justPressed)
			{
				if (FlxG.mouse.overlaps(agreeButton))
				{
					agreeButton.visible = false;
					agreeText.visible = false;
					box.visible = false;
					swagDialogue.visible = false;
					boxDone = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));
					endWarning();
				}
			}
		}
		super.update(elapsed);
	}

	function startWarning():Void
	{
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			FlxTween.tween(whiteScreen, {alpha: 0}, 2);
		});
		new FlxTimer().start(4, function(tmr:FlxTimer)
		{
			dialogueOpened = true;
		});
	}

	function startDialogue():Void
	{
		box.visible = true;
		dialogueEnded = false;

		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);
		swagDialogue.completeCallback = function() {
			dialogueEnded = true;
		};
	
		if(nextDialogueThing != null) {
			nextDialogueThing();
		}
	}

	function continueWarning():Void
	{
		yesButton.visible = false;
		yesText.visible = false;
		noButton.visible = false;
		noText.visible = false;
		curHalf = 2;
		dialogueList = words2;
		dialogueStarted = true;
		startDialogue();
	}

	function endWarning():Void
	{
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			FlxTween.tween(bg1, {alpha: 0}, 2);
		});
		new FlxTimer().start(6, function(tmr:FlxTimer)
		{
			FlxTween.tween(whiteScreen, {alpha: 1}, 0.5);
		});
		new FlxTimer().start(6.5, function(tmr:FlxTimer)
		{
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			FlxG.save.data.warningAccept = true;
			SaveData.warningAccept = true;
			SaveData.saveSwagData();
			doneWarning = true;
			FlxG.switchState(new TeamDSIntro());
		});
	}
}