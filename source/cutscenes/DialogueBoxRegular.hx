package cutscenes;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.geom.Point;
import flixel.math.FlxMatrix;
import flixel.addons.effects.chainable.FlxGlitchEffect;
import flixel.addons.effects.chainable.FlxEffectSprite;
import openfl.filters.ShaderFilter;
import shaders.StaticShader;
#if sys
import flixel.addons.plugin.screengrab.FlxScreenGrab;
#end

class DialogueBoxRegular extends FlxSpriteGroup
{
	//var grpDialogueStuff:FlxGroup;

	var box:FlxSprite;

	var curPrompt:String = '';
	var curCommand:String = '';
	var curCharacter:String = '';
	var curPortAnim:String = '';
	var curPortPos:String = '';
	var curDialogue:String = '';

	//var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	var canSkip:Bool = false;

	// SECOND DIALOGUE FOR THE PIXEL INSTEAD???
	var swagDialogue:FlxTypeText;

	var nameText:FlxText;

	public var finishThing:Void->Void;
	//public var nextDialogueThing:Void->Void = null;
	public var skipDialogueThing:Void->Void = null;

	var portraitLeft:FlxSprite;
	var portraitMiddle:FlxSprite;
	var portraitRight:FlxSprite;

	var skipButton:FlxSprite;
	var skipText:FlxText;
	var background:FlxSprite;
	var blackscreen:FlxSprite;
	var cgSprite:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	var button1:FlxSprite;
	var text1:FlxText;
	var button1Hover:Bool = false;
	var button2:FlxSprite;
	var text2:FlxText;
	var button2Hover:Bool = false;
	var buttonsAppear:Bool = false;

	public var isAct3:Bool = false;
	var isRevelation:Bool = false;
	var revLayer:Int = 1;

	public function new(dialogueList:Array<String>, isRevelation:Bool)
	{
		super();

		box = new FlxSprite(200, 430);
		box.frames = Paths.getSparrowAtlas('dialogue/Dialogue-box');
		box.animation.addByPrefix('talk', 'Talking', 24, false);
		box.animation.addByPrefix('think', 'Thinking', 24, false);
		box.animation.play('talk');
		box.setGraphicSize(Std.int(box.width * 1.5));
		box.updateHitbox();
		box.screenCenter(X);
		
		var hasDialog = true;

		background = new FlxSprite();
		background.x = 0;
		background.y = 0;
		add(background);
		background.visible = false;

		this.dialogueList = dialogueList;
		this.isRevelation = isRevelation;
		
		if (!hasDialog)
			return;
		
		portraitRight = new FlxSprite(820, 40);
		portraitRight.frames = Paths.getSparrowAtlas('dialogue/Regular/portraits/BF_Portraits');
		portraitRight.animation.addByPrefix('bf1', 'Normal', 24, false);
		portraitRight.setGraphicSize(Std.int(portraitRight.width * 0.9));
		portraitRight.updateHitbox();
		portraitRight.antialiasing = true;
		add(portraitRight);
		portraitRight.visible = false;

		portraitMiddle = new FlxSprite(420, 40);
		portraitMiddle.frames = Paths.getSparrowAtlas('dialogue/Regular/portraits/GF_Portraits');
		portraitMiddle.animation.addByPrefix('gf1', 'Normal', 24, false);
		portraitMiddle.setGraphicSize(Std.int(portraitMiddle.width * 0.9));
		portraitMiddle.updateHitbox();
		portraitMiddle.antialiasing = true;
		add(portraitMiddle);
		portraitMiddle.visible = false;

		portraitLeft = new FlxSprite(40, 40);
		portraitLeft.frames = Paths.getSparrowAtlas('dialogue/Regular/portraits/Monika_Portraits');
		portraitLeft.animation.addByPrefix('monika1', 'Take My Hand', 24, false);
		portraitLeft.setGraphicSize(Std.int(portraitLeft.width * 0.9));
		portraitLeft.updateHitbox();
		portraitLeft.antialiasing = true;
		add(portraitLeft);
		portraitLeft.visible = false;
		portraitLeft.flipX = true;

		cgSprite = new FlxSprite();
		cgSprite.x = 0;
		cgSprite.y = 0;
		add(cgSprite);
		cgSprite.visible = false;
		
		add(box);

		handSelect = new FlxSprite(FlxG.width * 0.93, FlxG.height * 0.92);
		handSelect.frames = Paths.getSparrowAtlas('dialogue/Arrow');
		handSelect.animation.addByPrefix('anim', 'Arrow', 24, true);
		handSelect.setGraphicSize(Std.int(handSelect.width * 1.5));
		handSelect.updateHitbox();
		handSelect.antialiasing = true;
		handSelect.visible = false;
		add(handSelect);

		swagDialogue = new FlxTypeText(60, 530, Std.int(box.width * 0.95), "", 32);
		swagDialogue.setFormat(Paths.font("doki.ttf"), 32, FlxColor.WHITE, FlxTextAlign.LEFT);
		swagDialogue.borderColor = 0xFF000000;
		swagDialogue.borderStyle = OUTLINE;
		swagDialogue.borderSize = 1.5;
		add(swagDialogue);

		nameText = new FlxText(100, FlxG.height * 0.61, 252, "", 40);
		nameText.setFormat(Paths.font("dokiUI.ttf"), 32, FlxColor.WHITE, FlxTextAlign.CENTER);
		nameText.setBorderStyle(OUTLINE, 0xFFBB5599, 3);
		add(nameText);

		skipButton = new FlxSprite(1000, 30).loadGraphic(Paths.image('dialogue/btn_skip'));
		skipButton.scrollFactor.set();
		skipButton.setGraphicSize(Std.int(skipButton.width * 0.65));
		skipButton.updateHitbox();
		add(skipButton);
		canSkip = true;

		blackscreen = new FlxSprite().makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), FlxColor.BLACK);
		blackscreen.scrollFactor.set();
		blackscreen.alpha = 0;

		text1 = new FlxText(0, 310, 0, "Masculine Voice", 40);
		text1.setFormat(Paths.font("doki.ttf"), 32, FlxColor.BLACK);
		text1.screenCenter(X);
		text1.scrollFactor.set();
		text1.visible = false;

		button1 = new FlxSprite(0, 310);
		button1.frames = Paths.getSparrowAtlas('mainmenu/button_doki');
		button1.antialiasing = true;
		button1.animation.addByPrefix('idle', 'idle', 24);
		button1.animation.addByPrefix('select', 'select', 24);
		button1.animation.play('idle');
		button1.setGraphicSize(Std.int(button1.width * 1.3));
		button1.updateHitbox();
		button1.screenCenter(X);
		button1.scrollFactor.set();
		button1.visible = false;

		text2 = new FlxText(0, 390, 0, "Feminine Voice", 40);
		text2.scrollFactor.set();
		text2.setFormat(Paths.font("doki.ttf"), 32, FlxColor.BLACK);
		text2.screenCenter(X);
		text2.visible = false;

		button2 = new FlxSprite(0, 390);
		button2.frames = Paths.getSparrowAtlas('mainmenu/button_doki');
		button2.scrollFactor.set();
		button2.antialiasing = true;
		button2.animation.addByPrefix('idle', 'idle', 24);
		button2.animation.addByPrefix('select', 'select', 24);
		button2.animation.play('idle');
		button2.setGraphicSize(Std.int(button2.width * 1.3));
		button2.updateHitbox();
		button2.screenCenter(X);
		button2.visible = false;
		button2.updateHitbox();

		if (isRevelation)
		{
			add(button1);
			add(text1);
			add(button2);
			add(text2);
		}
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;
	var dialogueEnded:Bool = false;

	var iTime:Float = 0;

	override function update(elapsed:Float)
	{
		if (staticlol != null && ClientPrefs.shaders)
		{
			iTime += elapsed;
			staticlol.iTime.value = [iTime];
		}

		if (canSkip)
			skipButton.alpha = 1;
		else
			skipButton.alpha = 0;

		dialogueOpened = true;

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ESCAPE && dialogueStarted == true && canSkip)
		{
			skipItAll();
		}

		if (FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE)
		{
			if (dialogueEnded && !buttonsAppear)
			{
				endDialogue();
			}
			else if (dialogueStarted)
			{
				swagDialogue.skip();
					
				if(skipDialogueThing != null) {
					skipDialogueThing();
				}
			}
		}

		if (isRevelation && revLayer == 5 && dialogueList[1] == null && FlxG.save.data.yourVoice == null)
		{
			button1.visible = true;
			text1.visible = true;
			button2.visible = true;
			text2.visible = true;
			buttonsAppear = true;
			FlxG.mouse.visible = true;
			MusicBeatState.reloadCursor();
			if (FlxG.mouse.overlaps(button1) && !button2Hover)
			{
				button1.animation.play('select');
				if (!button1Hover)
				{
					button1Hover = true;
					FlxG.sound.play(Paths.sound('scrollMenu'));
				}
			}
			else
			{
				button1Hover = false;
				button1.animation.play('idle');
			}
			if (FlxG.mouse.overlaps(button2) && !button1Hover)
			{
				button2.animation.play('select');
				if (!button2Hover)
				{
					button2Hover = true;
					FlxG.sound.play(Paths.sound('scrollMenu'));
				}
			}
			else
			{
				button2Hover = false;
				button2.animation.play('idle');
			}
	
			if (FlxG.mouse.justPressed)
			{
				if (FlxG.mouse.overlaps(button1) && !button2Hover)
				{
					FlxG.save.data.yourVoice = 'Masculine';
					ClientPrefs.yourVoice = FlxG.save.data.yourVoice;
					ClientPrefs.saveSettings();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					remove(button1);
					remove(button2);
					remove(text1);
					remove(text2);
					buttonsAppear = false;
					FlxG.mouse.visible = false;
					endDialogue();
				}
				if (FlxG.mouse.overlaps(button2) && !button1Hover)
				{
					FlxG.save.data.yourVoice = 'Feminine';
					ClientPrefs.yourVoice = FlxG.save.data.yourVoice;
					ClientPrefs.saveSettings();
					FlxG.sound.play(Paths.sound('confirmMenu'));
					remove(button1);
					remove(button2);
					remove(text1);
					remove(text2);
					buttonsAppear = false;
					FlxG.mouse.visible = false;
					endDialogue();
				}
			}
		}
		
		super.update(elapsed);
	}

	function skipItAll():Void
	{
		remove(swagDialogue);
		isEnding = true;
		canSkip = false;
		dialogueStarted = false;
		if (FlxG.sound.music != null)
			FlxG.sound.music.fadeOut(1.5, 0);

		FlxTween.tween(box, {alpha: 0}, 1, {ease: FlxEase.linear});
		FlxTween.tween(portraitLeft, {alpha: 0}, 1, {ease: FlxEase.linear});
		FlxTween.tween(portraitMiddle, {alpha: 0}, 1, {ease: FlxEase.linear});
		FlxTween.tween(portraitRight, {alpha: 0}, 1, {ease: FlxEase.linear});
		FlxTween.tween(handSelect, {alpha: 0}, 1, {ease: FlxEase.linear});
		FlxTween.tween(swagDialogue, {alpha: 0}, 1, {ease: FlxEase.linear});
		FlxTween.tween(background, {alpha: 0}, 1, {ease: FlxEase.linear});
		FlxTween.tween(cgSprite, {alpha: 0}, 1, {ease: FlxEase.linear});
		FlxTween.tween(nameText, {alpha: 0}, 1, {ease: FlxEase.linear});
		FlxTween.tween(skipButton, {alpha: 0}, 1, {ease: FlxEase.linear});
			
		new FlxTimer().start(1.5, function(tmr:FlxTimer)
		{
			finishThing();
			kill();
		});
	}

	function endDialogue():Void
	{
		if (dialogueList[1] == null && dialogueList[0] != null)
		{
			if (!isEnding)
			{
				if (isRevelation)
				{
					if (revLayer == 6)
					{
						isEnding = true;
						canSkip = false;
						//FlxG.sound.play(Paths.sound('clickText'), 0.8);	

						if (FlxG.sound.music != null)
							FlxG.sound.music.fadeOut(1.5, 0);

						FlxTween.tween(box, {alpha: 0}, 1, {ease: FlxEase.linear});
						FlxTween.tween(portraitLeft, {alpha: 0}, 1, {ease: FlxEase.linear});
						FlxTween.tween(portraitMiddle, {alpha: 0}, 1, {ease: FlxEase.linear});
						FlxTween.tween(portraitRight, {alpha: 0}, 1, {ease: FlxEase.linear});
						FlxTween.tween(handSelect, {alpha: 0}, 1, {ease: FlxEase.linear});
						FlxTween.tween(swagDialogue, {alpha: 0}, 1, {ease: FlxEase.linear});
						FlxTween.tween(background, {alpha: 0}, 1, {ease: FlxEase.linear});
						FlxTween.tween(cgSprite, {alpha: 0}, 1, {ease: FlxEase.linear});
						FlxTween.tween(nameText, {alpha: 0}, 1, {ease: FlxEase.linear});
						FlxTween.tween(skipButton, {alpha: 0}, 1, {ease: FlxEase.linear});

						new FlxTimer().start(1.5, function(tmr:FlxTimer)
						{
							finishThing();
							kill();
						});
					}
					else
					{
						revLayer++;
						var endSuffix:String = '';
						switch (revLayer)
						{
							case 2:
								endSuffix = 'Name';
								if (CoolUtil.isRecording())
									endSuffix = 'Recording';
							case 3:
								switch (SaveData.otherRoutesTxt)
								{
									case "Others": endSuffix = 'Others';
									case "BF": endSuffix = 'BF';
									case "JR": endSuffix = 'JR';
									case "None": endSuffix = 'Moni';
								}
							case 5:
								if (FlxG.save.data.yourVoice == 'Masculine') endSuffix = 'Male';
								else if (FlxG.save.data.yourVoice == 'Feminine') endSuffix = 'Female';
								else endSuffix = "None";
						}
						//trace(file + endSuffix);
						var file:String = Paths.dialogueTxt('moni/justMoni1/' + revLayer + endSuffix);
						trace(file);
						dialogueList = CoolUtil.coolTextFile(file);
						startDialogue();
					}
				}
				else
				{
					isEnding = true;
					canSkip = false;	

					if (FlxG.sound.music != null)
						FlxG.sound.music.fadeOut(1.5, 0);

					FlxTween.tween(box, {alpha: 0}, 1, {ease: FlxEase.linear});
					FlxTween.tween(portraitLeft, {alpha: 0}, 1, {ease: FlxEase.linear});
					FlxTween.tween(portraitMiddle, {alpha: 0}, 1, {ease: FlxEase.linear});
					FlxTween.tween(portraitRight, {alpha: 0}, 1, {ease: FlxEase.linear});
					FlxTween.tween(handSelect, {alpha: 0}, 1, {ease: FlxEase.linear});
					FlxTween.tween(swagDialogue, {alpha: 0}, 1, {ease: FlxEase.linear});
					FlxTween.tween(background, {alpha: 0}, 1, {ease: FlxEase.linear});
					FlxTween.tween(cgSprite, {alpha: 0}, 1, {ease: FlxEase.linear});
					FlxTween.tween(nameText, {alpha: 0}, 1, {ease: FlxEase.linear});
					FlxTween.tween(skipButton, {alpha: 0}, 1, {ease: FlxEase.linear});

					new FlxTimer().start(1.5, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
		}
		else
		{
			dialogueList.remove(dialogueList[0]);
			startDialogue();
		}
	}

	var isEnding:Bool = false;
	var isCommand:Bool = false;

	function startDialogue():Void
	{
		isCommand = false;
		getDialogJunk();

		if (curPrompt.startsWith('@'))
			isCommand = true;

		if (!isCommand)
		{
			swagDialogue.resetText(curDialogue);
			swagDialogue.start(0.04);
			swagDialogue.completeCallback = function() {
				if (!buttonsAppear) handSelect.visible = true;
				handSelect.animation.play('anim', true);
				dialogueEnded = true;
			};
		}
		handSelect.visible = false;
		dialogueEnded = false;

		switch (curPrompt)
		{
			case '@bg':
				background.loadGraphic(Paths.image('dialogue/Regular/bg/bg_' + curCommand));
				endDialogue();
				background.visible = true;
			case '@hideBG':
				endDialogue();
				background.visible = false;
			case '@cg':
				cgSprite.loadGraphic(Paths.image('dialogue/Regular/cg/cg_' + curCommand));
				endDialogue();
				cgSprite.visible = true;
			case '@hideCG':
				endDialogue();
				cgSprite.visible = false;
			case '@glitch':
				canSkip = false;
				isCommand = true;
				funnyGlitch();
			case '@noskip':
				canSkip = false;
				endDialogue();
			case '@yesskip':
				canSkip = true;
				endDialogue();
			case '@autoskip':
				canSkip = false;
				swagDialogue.resetText(curCommand);
				swagDialogue.start(0.04);
				swagDialogue.completeCallback = endDialogue;
			case '@hideRight':
				portraitRight.visible = false;
				endDialogue();
			case '@hideLeft':
				portraitLeft.visible = false;
				endDialogue();
			case '@hideMiddle':
				portraitMiddle.visible = false;
				endDialogue();
			case '@playsound':
				FlxG.sound.play(Paths.sound('dialogue/' + curCommand));
				endDialogue();
			case '@startmusic':
				CoolUtil.playMusic('dialogue/' + curCommand);
				endDialogue();
			case '@endmusic':
				if (FlxG.sound.music != null)
					FlxG.sound.music.fadeOut(0.5, 0);
				endDialogue();
			case '@normal-font':
				swagDialogue.setFormat(Paths.font("doki.ttf"), 32, FlxColor.WHITE, LEFT);
				swagDialogue.borderColor = 0xFF000000;
				swagDialogue.borderStyle = OUTLINE;
				swagDialogue.borderSize = 1.5;
				endDialogue();
			case '@edit-font':
				swagDialogue.setFormat(Paths.font("mono.otf"), 32, FlxColor.WHITE, LEFT);
				swagDialogue.borderColor = 0xFF000000;
				swagDialogue.borderStyle = OUTLINE;
				swagDialogue.borderSize = 3;
				endDialogue();
			case '@hideHUD':
				box.visible = false;
				swagDialogue.visible = false;
				nameText.visible = false;
				skipButton.visible = false;
				endDialogue();
			case '@showHUD':
				box.visible = true;
				swagDialogue.visible = true;
				nameText.visible = true;
				skipButton.visible = true;
				endDialogue();
			case '@hideall':
				box.visible = false;
				swagDialogue.visible = false;
				nameText.visible = false;
				skipButton.visible = false;
				portraitMiddle.visible = false;
				portraitRight.visible = false;
				portraitLeft.visible = false;
				endDialogue();
			case '@fadeout':
				canSkip = false;
				isCommand = true;
				nameText.text = "";
				add(blackscreen);
				blackscreen.alpha = 0;
				swagDialogue.visible = false;
				FlxTween.tween(blackscreen, {alpha: 1}, 2, {
					ease: FlxEase.expoOut,
					onComplete: function(twn:FlxTween)
					{
						endDialogue();
						canSkip = true;
					}
				});
			case '@fadein':
				canSkip = false;
				isCommand = true;
				nameText.text = "";
				add(blackscreen);
				blackscreen.alpha = 1;
				FlxTween.tween(blackscreen, {alpha: 0}, 2, {
					ease: FlxEase.expoOut,
					onComplete: function(twn:FlxTween)
					{
						canSkip = true;
						swagDialogue.visible = true;
						endDialogue();
					}
				});

			case 'Dialog':
				nameText.text = curCharacter;
				switch (curPortPos)
				{
					case 'L':
						portraitMiddle.alpha = 0.5;
						portraitRight.alpha = 0.5;
						portraitLeft.visible = true;
						portraitLeft.alpha = 1;
						portraitLeft.frames = Paths.getSparrowAtlas('dialogue/Regular/portraits/' + curCharacter + '_Portraits');
						portraitLeft.animation.addByPrefix('play', curPortAnim, 24, false);
						portraitLeft.animation.play('play');
					case 'M':
						portraitLeft.alpha = 0.5;
						portraitRight.alpha = 0.5;
						portraitMiddle.visible = true;
						portraitMiddle.alpha = 1;
						portraitMiddle.frames = Paths.getSparrowAtlas('dialogue/Regular/portraits/' + curCharacter + '_Portraits');
						portraitMiddle.animation.addByPrefix('play', curPortAnim, 24, false);
						portraitMiddle.animation.play('play');
					case 'R':
						portraitMiddle.alpha = 0.5;
						portraitLeft.alpha = 0.5;
						portraitRight.visible = true;
						portraitRight.alpha = 1;
						portraitRight.frames = Paths.getSparrowAtlas('dialogue/Regular/portraits/' + curCharacter + '_Portraits');
						portraitRight.animation.addByPrefix('play', curPortAnim, 24, false);
						portraitRight.animation.play('play');
				}
		}
		if (curDialogue == '' && !isCommand && curCharacter != 'hidedialogue')
			endDialogue();
	}

	function getDialogJunk():Void
	{
		if (dialogueList[0].startsWith('@'))
		{
			var splitName:Array<String> = dialogueList[0].split("::");
			curPrompt = splitName[0];
			curCommand = splitName[1];
		}
		else
		{
			var splitName:Array<String> = dialogueList[0].split("::");
			curPrompt = 'Dialog';
			curCharacter = splitName[0];
			curPortAnim = splitName[1];
			curPortPos = splitName[2];
			curDialogue = splitName[3];
			if (curDialogue.contains('{USERNAME}')) curDialogue = StringTools.replace(curDialogue, '{USERNAME}', CoolUtil.getUsername());
		}
	}

	var staticlol:StaticShader;

	var screenHUD:FlxSprite;
	var glitchEffect:FlxGlitchEffect;
	var glitchSprite:FlxEffectSprite;

	function funnyGlitch():Void
	{
		if (ClientPrefs.shaders)
		{
			staticlol = new StaticShader();
			PlayState.instance.camDialogue.setFilters([new ShaderFilter(staticlol)]);
		}
		else
		{
			screenHUD = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT);
			screenHUD.drawFrame();
			var screenPixels = screenHUD.framePixels;
			var targetCamera = PlayState.instance.camDialogue;
			
			if (FlxG.renderBlit)
				screenPixels.copyPixels(targetCamera.buffer, targetCamera.buffer.rect, new Point());
			else
				screenPixels.draw(targetCamera.canvas, new FlxMatrix(1, 0, 0, 1, 0, 0));
	
			glitchEffect = new FlxGlitchEffect(10, 2, 0.05, HORIZONTAL);
			glitchSprite = new FlxEffectSprite(screenHUD, [glitchEffect]);
			glitchSprite.antialiasing = ClientPrefs.globalAntialiasing;
			add(glitchSprite);
		
			glitchEffect.active = true;
		}
		
		FlxG.sound.play(Paths.sound('missnote1'));
		
		new FlxTimer().start(0.5, function(tmr:FlxTimer)
		{
			if (ClientPrefs.shaders)
				PlayState.instance.camDialogue.setFilters([]);
			else
			{
				glitchEffect.active = false;
				remove(glitchSprite);
				remove(screenHUD);
			}
			canSkip = true;
			endDialogue();
		});
	}
}
