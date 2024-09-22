package states;

import flixel.input.mouse.FlxMouseEventManager;
import flixel.addons.display.FlxBackdrop;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.tweens.FlxEase;
import flixel.FlxSubState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;

using StringTools;

class ExtraStuffState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxText>;

	var optionTrash:Array<String> = ['Achievements', 'Save Data'];

	var freeplayTxt:FlxText;

	var freeplaySpr:FlxSprite;
	var creditsSpr:FlxSprite;
	var achieveSpr:FlxSprite;
	var gallerySpr:FlxSprite;
	var dataSpr:FlxSprite;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		TitleState.setDefaultRGB();
		var titleBg:DDLCBorderBG;
		var titleBorder:DDLCBorder;

		titleBg = new DDLCBorderBG(Paths.image('mainmenu/rgbBg'), -40, -40);
		add(titleBg);

		titleBorder = new DDLCBorder(false);
		add(titleBorder);

		freeplayTxt = new FlxText(50, 50, 0, "Extras", 32);
		// scoreText.autoSize = false;
		freeplayTxt.setFormat(Paths.font("dokiUI.ttf"), 40, FlxColor.WHITE, FlxTextAlign.RIGHT);
		freeplayTxt.setBorderStyle(OUTLINE, 0xFFBB5599, 6);
		add(freeplayTxt);

		menuItems = new FlxTypedGroup<FlxText>();
		add(menuItems);

		//var tex = Paths.getSparrowAtlas('main-menu-assets');
		if (SaveData.bfRouteClear || SaveData.jrRouteClear || SaveData.monikaRouteClear || SaveData.dokiBFRouteClear || SaveData.dokiJRRouteClear || SaveData.dokiMONIRouteClear)
		{
			if (SaveData.actTwo) optionTrash = ['Credits', 'Achievements', 'Save Data'];
			else optionTrash = ['Freeplay', 'Credits', 'Achievements', 'Save Data'];
		}
		if (SaveData.clearAllNormal && SaveData.clearAllClassic && SaveData.clearAllBonus)
		{
			if (SaveData.actTwo) optionTrash = ['Credits', 'Achievements', 'Gallery', 'Save Data'];
			else optionTrash = ['Freeplay', 'Credits', 'Achievements', 'Gallery', 'Save Data'];
		}

		for (i in 0...optionTrash.length)
		{
			var menuItem:FlxText = new FlxText(460, (55 * i) + 300, 0, optionTrash[i]);
			menuItem.setFormat(Paths.font("dokiUI.ttf"), 30, FlxColor.WHITE, FlxTextAlign.LEFT);
			//menuItem.y += LangUtil.getFontOffset('riffic');
			menuItem.setBorderStyle(OUTLINE, 0xFF, 4);
			menuItem.antialiasing = true;
			menuItem.ID = i;
			menuItems.add(menuItem);
			//mouseManager.add(menuItem, onMouseDown, null, onMouseOver);
		}

		freeplaySpr = new FlxSprite(1280, 5).loadGraphic(Paths.image('freeplay/SprFreeplay'));
		freeplaySpr.antialiasing = ClientPrefs.globalAntialiasing;
		creditsSpr = new FlxSprite(1280, 5).loadGraphic(Paths.image('freeplay/SprCredits'));
		creditsSpr.antialiasing = ClientPrefs.globalAntialiasing;
		achieveSpr = new FlxSprite(1280, 5).loadGraphic(Paths.image('freeplay/SprAchievements'));
		achieveSpr.antialiasing = ClientPrefs.globalAntialiasing;
		gallerySpr = new FlxSprite(1280, 5).loadGraphic(Paths.image('freeplay/SprGallery'));
		gallerySpr.antialiasing = ClientPrefs.globalAntialiasing;
		dataSpr = new FlxSprite(1280, 5).loadGraphic(Paths.image('freeplay/SprSaveData'));
		dataSpr.antialiasing = ClientPrefs.globalAntialiasing;

		add(freeplaySpr);
		add(creditsSpr);
		add(achieveSpr);
		add(gallerySpr);
		add(dataSpr);

		changeItem(0, false);

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				changeItem(1);
			}

			if (controls.BACK)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				openSubState(new CustomFadeTransition(0.6, false, new MainMenuState()));
				//MusicBeatState.switchState(new MainMenuState());
			}

			if (controls.ACCEPT)
			{
				selectOption();
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(txt:FlxText)
		{
			txt.x = 10;
			//txt.screenCenter(X);
			//txt.x -= 520;
		});
		if (!selectedSomethin){
			menuItems.forEach(function(txt:FlxText)
			{
				if (FlxG.mouse.overlaps(txt)){
					if (curSelected != txt.ID){
						curSelected = txt.ID;
						changeItem();
					}
					if (FlxG.mouse.justPressed)
						selectOption();
				}
			});
		}
	}

	function changeItem(huh:Int = 0, playSound:Bool = true)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(txt:FlxText)
		{
			txt.setBorderStyle(OUTLINE, 0xFFBB5599, 4);
	
			if (txt.ID == curSelected)
				txt.setBorderStyle(OUTLINE, 0xFFFFAACC, 4);
		});

		if (playSound) FlxG.sound.play(Paths.sound('scrollMenu'));

		FlxTween.cancelTweensOf(freeplaySpr);
		FlxTween.cancelTweensOf(creditsSpr);
		FlxTween.cancelTweensOf(achieveSpr);
		FlxTween.cancelTweensOf(gallerySpr);
		FlxTween.cancelTweensOf(dataSpr);

		switch (optionTrash[curSelected])
		{
			case 'Freeplay':
				FlxTween.tween(freeplaySpr, {x: 380}, 0.5, {ease: FlxEase.linear});
				FlxTween.tween(creditsSpr, {x: 1280}, 0.5, {ease: FlxEase.linear});
				FlxTween.tween(achieveSpr, {x: 1280}, 0.5, {ease: FlxEase.linear});
				FlxTween.tween(gallerySpr, {x: 1280}, 0.5, {ease: FlxEase.linear});
				FlxTween.tween(dataSpr, {x: 1280}, 0.5, {ease: FlxEase.linear});
			case 'Credits':
				FlxTween.tween(creditsSpr, {x: 380}, 0.5, {ease: FlxEase.linear});
				FlxTween.tween(freeplaySpr, {x: 1280}, 0.5, {ease: FlxEase.linear});
				FlxTween.tween(achieveSpr, {x: 1280}, 0.5, {ease: FlxEase.linear});
				FlxTween.tween(gallerySpr, {x: 1280}, 0.5, {ease: FlxEase.linear});
				FlxTween.tween(dataSpr, {x: 1280}, 0.5, {ease: FlxEase.linear});
			case 'Achievements':
				FlxTween.tween(achieveSpr, {x: 380}, 0.5, {ease: FlxEase.linear});
				FlxTween.tween(creditsSpr, {x: 1280}, 0.5, {ease: FlxEase.linear});
				FlxTween.tween(freeplaySpr, {x: 1280}, 0.5, {ease: FlxEase.linear});
				FlxTween.tween(gallerySpr, {x: 1280}, 0.5, {ease: FlxEase.linear});
				FlxTween.tween(dataSpr, {x: 1280}, 0.5, {ease: FlxEase.linear});
			case 'Gallery':
				FlxTween.tween(gallerySpr, {x: 380}, 0.5, {ease: FlxEase.linear});
				FlxTween.tween(creditsSpr, {x: 1280}, 0.5, {ease: FlxEase.linear});
				FlxTween.tween(achieveSpr, {x: 1280}, 0.5, {ease: FlxEase.linear});
				FlxTween.tween(freeplaySpr, {x: 1280}, 0.5, {ease: FlxEase.linear});
				FlxTween.tween(dataSpr, {x: 1280}, 0.5, {ease: FlxEase.linear});
			case 'Save Data':
				FlxTween.tween(dataSpr, {x: 380}, 0.5, {ease: FlxEase.linear});
				FlxTween.tween(creditsSpr, {x: 1280}, 0.5, {ease: FlxEase.linear});
				FlxTween.tween(achieveSpr, {x: 1280}, 0.5, {ease: FlxEase.linear});
				FlxTween.tween(gallerySpr, {x: 1280}, 0.5, {ease: FlxEase.linear});
				FlxTween.tween(freeplaySpr, {x: 1280}, 0.5, {ease: FlxEase.linear});
		}
	}

	override function closeSubState() {
		changeItem(0, false);
		selectedSomethin = false;
		super.closeSubState();
	}

	function selectOption(){
		FlxG.sound.play(Paths.sound('confirmMenu'));

		if (optionTrash[curSelected] != 'Freeplay')
		{
			selectedSomethin = true;
			menuItems.forEach(function(spr:FlxText)
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
						var daChoice:String = optionTrash[curSelected];

						switch (daChoice)
						{
							case 'Credits':
								openSubState(new CustomFadeTransition(0.6, false, new CreditsState()));
								//MusicBeatState.switchState(new CreditsState());
							case 'Achievements':
								openSubState(new CustomFadeTransition(0.6, false, new AchievementsMenuState()));
								//MusicBeatState.switchState(new AchievementsMenuState());
							case 'Gallery':
								openSubState(new CustomFadeTransition(0.6, false, new GalleryState()));
								//MusicBeatState.switchState(new GalleryState());
							case 'Save Data':
								openSubState(new CustomFadeTransition(0.6, false, new SaveFileState()));
								//MusicBeatState.switchState(new SaveFileState());
						}
					});
				}
			});
		}
		else
		{
			if (!SaveData.monikaRouteClear && !SaveData.dokiMONIRouteClear)
			{
				menuItems.forEach(function(spr:FlxText)
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
							openSubState(new CustomFadeTransition(0.6, false, new FreeplayState()));
							//MusicBeatState.switchState(new FreeplayState());
						});
					}
				});
			}
			else
			{
				//persistentUpdate = false;
				selectedSomethin = true;
				openSubState(new FreeplaySelect());
			}
		}
	}
}
