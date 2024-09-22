package states;

import flixel.input.mouse.FlxMouseEventManager;
import flixel.addons.display.FlxBackdrop;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import flixel.input.keyboard.FlxKey;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '1.1.0h'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxText>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;

	var charFile:Array<String> = [];
	
	var optiontrash:Array<String> = ['New Game', 'Load Game', 'Extras', 'Settings', 'Help', 'Quit'];

	var debugKeys:Array<FlxKey>;

	public static var showPopUp:Bool = false;
	public static var popupWeek:Int = 0;
	public static var secondaryPopUp:Bool = false;
	public static var thirdindaryPopUp:Bool = false;

	public var acceptInput:Bool = true;

	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();
		
		FlxG.mouse.visible = true;
		MusicBeatState.reloadCursor();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var logoBl:FlxSprite;
		var titleBg:DDLCBorderBG;
		var titleBorder:DDLCBorder;

		TitleState.setDefaultRGB();
		titleBg = new DDLCBorderBG(Paths.image('mainmenu/rgbBg'), -40, -40);
		add(titleBg);

		titleBorder = new DDLCBorder(false);
		add(titleBorder);

		var monikaTitle:FlxSprite;
		if (TitleState.classicEasterEgg)
			monikaTitle = new FlxSprite(950, 380).loadGraphic(Paths.image('mainmenu/chars/monika_classic'));
		else if (TitleState.endEasterEgg)
			monikaTitle = new FlxSprite(950, 240).loadGraphic(Paths.image('mainmenu/chars/monika_end'));
		else if (TitleState.monkerEasterEgg)
			monikaTitle = new FlxSprite(950, 240).loadGraphic(Paths.image('mainmenu/chars/monika_OG'));
		else
			monikaTitle = new FlxSprite(950, 240).loadGraphic(Paths.image('mainmenu/chars/monika_menu'));
		monikaTitle.setGraphicSize(Std.int(monikaTitle.width * 0.5));
		monikaTitle.updateHitbox();
		monikaTitle.antialiasing = ClientPrefs.globalAntialiasing;

		var sayoriTitle:FlxSprite;
		if (TitleState.classicEasterEgg)
			sayoriTitle = new FlxSprite(380, 240).loadGraphic(Paths.image('mainmenu/chars/sayori_classic'));
		else if (TitleState.endEasterEgg)
			sayoriTitle = new FlxSprite(570, 240).loadGraphic(Paths.image('mainmenu/chars/sayori_end'));
		else if (TitleState.monkerEasterEgg)
			sayoriTitle = new FlxSprite(570, 240).loadGraphic(Paths.image('mainmenu/chars/sayori_OG'));
		else
			sayoriTitle = new FlxSprite(570, 240).loadGraphic(Paths.image('mainmenu/chars/sayori_menu'));
		sayoriTitle.setGraphicSize(Std.int(sayoriTitle.width * 0.5));
		sayoriTitle.updateHitbox();
		sayoriTitle.antialiasing = ClientPrefs.globalAntialiasing;

		var yuriTitle:FlxSprite;
		if (TitleState.classicEasterEgg)
			yuriTitle = new FlxSprite(500, 90).loadGraphic(Paths.image('mainmenu/chars/yuri_classic'));
		else if (TitleState.endEasterEgg)
			yuriTitle = new FlxSprite(700, 180).loadGraphic(Paths.image('mainmenu/chars/yuri_end'));
		else if (TitleState.monkerEasterEgg)
			yuriTitle = new FlxSprite(700, 185).loadGraphic(Paths.image('mainmenu/chars/yuri_OG'));
		else
			yuriTitle = new FlxSprite(700, 185).loadGraphic(Paths.image('mainmenu/chars/yuri_menu'));
		yuriTitle.setGraphicSize(Std.int(yuriTitle.width * 0.5));
		yuriTitle.updateHitbox();
		yuriTitle.antialiasing = ClientPrefs.globalAntialiasing;

		var natsukiTitle:FlxSprite;
		if (TitleState.classicEasterEgg)
			natsukiTitle = new FlxSprite(670, 140).loadGraphic(Paths.image('mainmenu/chars/natsuki_classic'));
		else if (TitleState.endEasterEgg)
			natsukiTitle = new FlxSprite(830, 230).loadGraphic(Paths.image('mainmenu/chars/natsuki_end'));
		else if (TitleState.monkerEasterEgg)
			natsukiTitle = new FlxSprite(830, 260).loadGraphic(Paths.image('mainmenu/chars/natsuki_OG'));
		else
			natsukiTitle = new FlxSprite(830, 260).loadGraphic(Paths.image('mainmenu/chars/natsuki_menu'));
		natsukiTitle.setGraphicSize(Std.int(natsukiTitle.width * 0.5));
		natsukiTitle.updateHitbox();
		natsukiTitle.antialiasing = ClientPrefs.globalAntialiasing;

		add(yuriTitle);
		add(sayoriTitle);
		add(natsukiTitle);
		add(monikaTitle);

		if (TitleState.classicEasterEgg)
		{
			logoBl = new FlxSprite(-100, 0).loadGraphic(Paths.image('mainmenu/og-logo'));
			monikaTitle.setGraphicSize(Std.int(monikaTitle.width * 1.5));
			sayoriTitle.setGraphicSize(Std.int(sayoriTitle.width * 1.4));
			yuriTitle.setGraphicSize(Std.int(yuriTitle.width * 1.1));
			natsukiTitle.setGraphicSize(Std.int(natsukiTitle.width * 1.1));
		}
		else if (TitleState.monkerEasterEgg)
			logoBl = new FlxSprite(-100, 0).loadGraphic(Paths.image('mainmenu/previous-logo'));
		else
			logoBl = new FlxSprite(-100, 0).loadGraphic(Paths.image('mainmenu/update-logo'));
		logoBl.setGraphicSize(Std.int(logoBl.width * 0.45));
		logoBl.updateHitbox();
		logoBl.antialiasing = ClientPrefs.globalAntialiasing;
		add(logoBl);

		menuItems = new FlxTypedGroup<FlxText>();
		add(menuItems);

		for (i in 0...optiontrash.length)
		{
			var menuItem:FlxText = new FlxText(50, 400 + (i * 47), 0, optiontrash[i], 32);
			menuItem.setFormat(Paths.font("dokiUI.ttf"), 24, FlxColor.WHITE, FlxTextAlign.LEFT);
			menuItem.setBorderStyle(OUTLINE, 0xFF, 4);
			menuItem.antialiasing = true;
			menuItem.ID = i;
			menuItems.add(menuItem);
		}

		var versionDS:FlxText = new FlxText(0, FlxG.height - 75, FlxG.width, "Psych Engine DS v" + psychEngineVersion, 12);
		versionDS.scrollFactor.set();
		versionDS.setFormat("Aller Bold", 32, FlxColor.WHITE, FlxTextAlign.RIGHT);
		versionDS.borderColor = 0xFF000000;
		versionDS.borderStyle = OUTLINE;
		versionDS.borderSize = 1.5;
		add(versionDS);

		var versionFNF:FlxText = new FlxText(0, FlxG.height - 39, FlxG.width, "DDFNFCDX v4.0.0", 12);
		versionFNF.scrollFactor.set();
		versionFNF.setFormat("Aller Bold", 32, FlxColor.WHITE, FlxTextAlign.RIGHT);
		versionFNF.borderColor = 0xFF000000;
		versionFNF.borderStyle = OUTLINE;
		versionFNF.borderSize = 1.5;
		add(versionFNF);

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18)
			Achievements.unlock('friday_night_play');

		if (TitleState.classicEasterEgg) Achievements.unlock('classic_menu');
		if (SaveData.seenGhost) Achievements.unlock('ghost_menu');
		if (TitleState.monkerEasterEgg && !TitleState.endEasterEgg && !TitleState.classicEasterEgg) Achievements.unlock('monker_appear');
		if (TitleState.endEasterEgg) Achievements.unlock('end_menu');
		#end

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (SaveData.monikaRouteCrash)
		{
			SaveData.monikaRouteCrash = false;
		}

		if (!selectedSomethin && acceptInput)
		{
			if (controls.UI_UP_P)
			{
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				changeItem(1);
			}

			if (controls.ACCEPT)
			{
				selectThing();
			}
			#if debug
			else if (FlxG.keys.anyJustPressed(debugKeys))
			{
				selectedSomethin = true;
				openSubState(new CustomFadeTransition(0.6, false, new MasterEditorMenu()));
			}
			#end
		}

		if (!selectedSomethin){
			menuItems.forEach(function(txt:FlxText)
			{
				if (FlxG.mouse.overlaps(txt)){
					if (curSelected != txt.ID){
						curSelected = txt.ID;
						changeItem();
					}
					if (FlxG.mouse.justPressed)
						selectThing();
				}
			});
		}		
		super.update(elapsed);
	}

	function changeItem(huh:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'));
		curSelected += huh;
	
		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;
	
		menuItems.forEach(function(txt:FlxText)
		{
			txt.setBorderStyle(OUTLINE, 0xFFBB5599, 3.5);
	
			if (txt.ID == curSelected)
				txt.setBorderStyle(OUTLINE, 0xFFFFAACC, 3.5);
		});
	}

	function selectThing(){
		selectedSomethin = true;
		FlxG.sound.play(Paths.sound('confirmMenu'));

		if (optiontrash[curSelected] != 'Help' && optiontrash[curSelected] != 'Quit')
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
						var daChoice:String = optiontrash[curSelected];
						switch (daChoice)
						{
							case 'New Game':
								openSubState(new CustomFadeTransition(0.6, false, new StoryStartState()));
							case 'Load Game':
								openSubState(new CustomFadeTransition(0.6, false, new StoryContinueState()));
							case 'Extras':
								openSubState(new CustomFadeTransition(0.6, false, new ExtraStuffState()));
							case 'Settings':
								openSubState(new CustomFadeTransition(0.6, false, new OptionsState()));
								OptionsState.onPlayState = false;
								if (PlayState.SONG != null)
								{
									PlayState.SONG.arrowSkin = null;
									PlayState.SONG.splashSkin = null;
								}
						}
					});
				}
			});
		}
		else
		{
			var daChoice:String = optiontrash[curSelected];
			switch (daChoice)
			{
				case 'Help':
					CoolUtil.browserLoad('https://github.com/Dsfan2/DokiDokiFNFClubDX/blob/main/art/readme.txt');
				case 'Quit':
					openSubState(new DDLCPrompt('Are you sure you want to exit?', 0, function(){Sys.exit(0);}, function(){selectedSomethin = false;}, 'YES', 'NO'));
			}
		}
	}
}
