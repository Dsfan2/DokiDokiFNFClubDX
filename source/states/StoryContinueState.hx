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

class StoryContinueState extends MusicBeatState
{
	private static var curDifficulty:Int = 1;

	private static var curSelected:Int = 0;

	var curPlayer:Int = 1;

	var choseRouteTxt:FlxText;

	var story_bf_reg:FlxSprite;
	var story_bf_doki:FlxSprite;
	var story_jr_reg:FlxSprite;
	var story_jr_doki:FlxSprite;
	var story_moni_reg:FlxSprite;
	var story_moni_doki:FlxSprite;
	var story_cursor:FlxSprite;

	var backdrop:DDLCBorderBG;
	var smBorder:DDLCBorder;

	public static var instance:StoryContinueState;

	public var acceptInput:Bool = true;

	var selectedSomethin:Bool = false;

	override function create()
	{
		instance = this;

		PlayState.isStoryMode = true;
		FlxG.mouse.visible = true;
		MusicBeatState.reloadCursor();

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		TitleState.setDefaultRGB();
		backdrop = new DDLCBorderBG(Paths.image('mainmenu/rgbBg'), -40, -40);
		add(backdrop);

		smBorder = new DDLCBorder(false);
		add(smBorder);

		var storyTxt:FlxText = new FlxText(40, 30, 0, "Load", 36);
		storyTxt.setFormat(Paths.font("dokiUI.ttf"), 32, FlxColor.WHITE, FlxTextAlign.CENTER);
		storyTxt.setBorderStyle(OUTLINE, 0xFFBB5599, 6, 1);
		add(storyTxt);

		choseRouteTxt = new FlxText(650, 95, 0, "Select Route", 5);
		choseRouteTxt.setFormat(Paths.font("doki.ttf"), 32, FlxColor.BLACK, FlxTextAlign.LEFT);
		add(choseRouteTxt);

		loadStorySlots();

		story_cursor = new FlxSprite(335, 150);
		story_cursor.frames = Paths.getSparrowAtlas('storymenu/load_game/Selector');
		story_cursor.animation.addByPrefix('idle', 'Idle', 24, true);
		story_cursor.animation.addByPrefix('selected', 'Select', 24, true);
		story_cursor.animation.play('idle');
		story_cursor.updateHitbox();
		add(story_cursor);

		loadStars();
		loadTexts();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		changeItem(0, false);

		CoolUtil.difficulties = CoolUtil.defaultDifficulties;

		super.create();
	}

	override function update(elapsed:Float)
	{
		switch (curSelected)
		{
			case 0:
				curPlayer = 1;
				story_cursor.x = 335;
				story_cursor.y = 150;
				curDifficulty = 0;
			case 1:
				curPlayer = 2;
				story_cursor.x = 635;
				story_cursor.y = 150;
				curDifficulty = 0;
			case 2:
				curPlayer = 3;
				story_cursor.x = 935;
				story_cursor.y = 150;
				curDifficulty = 0;
			case 3:
				curPlayer = 1;
				story_cursor.x = 335;
				story_cursor.y = 350;
				curDifficulty = 1;
			case 4:
				curPlayer = 2;
				story_cursor.x = 635;
				story_cursor.y = 350;
				curDifficulty = 1;
			case 5:
				curPlayer = 3;
				story_cursor.x = 935;
				story_cursor.y = 350;
				curDifficulty = 1;
		}

		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin && acceptInput)
		{
			if (controls.UI_LEFT_P)
			{
				changeItem(-1);
			}

			if (controls.UI_RIGHT_P)
			{
				changeItem(1);
			}

			if (controls.UI_UP_P)
			{
				changeItem(-3);
			}

			if (controls.UI_DOWN_P)
			{
				changeItem(3);
			}

			if (controls.BACK)
			{
				acceptInput = false;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				openSubState(new CustomFadeTransition(0.6, false, new MainMenuState()));
			}
			else if (controls.ACCEPT)
			{
				selectThing();
			}
		}

		if (!selectedSomethin){
			if (FlxG.mouse.overlaps(story_bf_reg)){
				if (curSelected != 0){
					curSelected = 0;
					changeItem();
				}
				//if (FlxG.mouse.justPressed && SaveData.bfRoute > 0 && (SaveData.lockedRoute == 'BF' || SaveData.lockedRoute == 'None'))
				if (FlxG.mouse.justPressed)
					selectThing();
			}
			if (FlxG.mouse.overlaps(story_jr_reg)){
				if (curSelected != 1){
					curSelected = 1;
					changeItem();
				}
				//if (FlxG.mouse.justPressed && SaveData.jrRoute > 0 && (SaveData.lockedRoute == 'JR' || SaveData.lockedRoute == 'None'))
				if (FlxG.mouse.justPressed)
					selectThing();
			}
			if (FlxG.mouse.overlaps(story_moni_reg)){
				if (curSelected != 2){
					curSelected = 2;
					changeItem();
				}
				//if (FlxG.mouse.justPressed && SaveData.monikaRoute > 0 && SaveData.lockedRoute == 'None')
				if (FlxG.mouse.justPressed)
					selectThing();
			}
			if (FlxG.mouse.overlaps(story_bf_doki)){
				if (curSelected != 3){
					curSelected = 3;
					changeItem();
				}
				//if (FlxG.mouse.justPressed && SaveData.dokiBFRoute > 0 && (SaveData.lockedRoute == 'BFDOKI' || SaveData.lockedRoute == 'None'))
				if (FlxG.mouse.justPressed)
					selectThing();
			}
			if (FlxG.mouse.overlaps(story_jr_doki)){
				if (curSelected != 4){
					curSelected = 4;
					changeItem();
				}
				//if (FlxG.mouse.justPressed && SaveData.dokiJRRoute > 0 && (SaveData.lockedRoute == 'JRDOKI' || SaveData.lockedRoute == 'None'))
				if (FlxG.mouse.justPressed)
					selectThing();
			}
			if (FlxG.mouse.overlaps(story_moni_doki)){
				if (curSelected != 5){
					curSelected = 5;
					changeItem();
				}
				//if (FlxG.mouse.justPressed && SaveData.dokiMONIRoute > 0 && SaveData.lockedRoute == 'None')
				if (FlxG.mouse.justPressed)
					selectThing();
			}
		}

		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		super.update(elapsed);
	}

	function selectThing()
	{
		FlxG.sound.play(Paths.sound('confirmMenu'));
		ClientPrefs.playerChar = curPlayer;
		ClientPrefs.saveSettings();

		switch (curSelected)
		{
			case 0:
				if (story_bf_reg.animation.curAnim.name != 'locked')
				{
					if (SaveData.bfRoute < 10 && !SaveData.bfRouteClear) continueRoute();
					else openDaSelector();
				}
			case 1:
				if (story_jr_reg.animation.curAnim.name != 'locked')
				{
					if (SaveData.jrRoute < 10 && !SaveData.jrRouteClear) continueRoute();
					else openDaSelector();
				}
			case 2:
				if (story_moni_reg.animation.curAnim.name != 'locked')
				{
					if (SaveData.monikaRoute < 6 && !SaveData.monikaRouteClear) continueRoute();
					else openDaSelector();
				}
			case 3:
				if (story_bf_doki.animation.curAnim.name != 'locked')
				{
					if (SaveData.dokiBFRoute < 10 && !SaveData.dokiBFRouteClear) continueRoute();
					else openDaSelector();
				}
			case 4:
				if (story_jr_doki.animation.curAnim.name != 'locked')
				{
					if (SaveData.dokiJRRoute < 10 && !SaveData.dokiJRRouteClear) continueRoute();
					else openDaSelector();
				}
			case 5:
				if (story_moni_doki.animation.curAnim.name != 'locked')
				{
					if (SaveData.dokiMONIRoute < 6 && !SaveData.dokiMONIRouteClear) continueRoute();
					else openDaSelector();
				}
		}
	}

	function continueRoute()
	{
		selectedSomethin = true;
		var route:Int = curPlayer;
		switch (route)
		{
			default:
				var num:Int = (curDifficulty == 1) ? SaveData.dokiBFRoute : SaveData.bfRoute;
				WeekData.weekID = WeekData.boyfriendRouteList[num][1];
				PlayState.storyPlaylist = WeekData.boyfriendRouteList[num][2];
			case 2:
				var num:Int = (curDifficulty == 1) ? SaveData.dokiJRRoute : SaveData.jrRoute;
				WeekData.weekID = WeekData.bowserJrRouteList[num][1];
				PlayState.storyPlaylist = WeekData.bowserJrRouteList[num][2];
			case 3:
				var num:Int = (curDifficulty == 1) ? SaveData.dokiMONIRoute : SaveData.monikaRoute;
				WeekData.weekID = WeekData.monikaRouteList[num][1];
				PlayState.storyPlaylist = WeekData.monikaRouteList[num][2];
		}

		PlayState.isStoryMode = true;
		PlayState.storyFreeplay = false;
		var diffic = CoolUtil.getDifficultyFilePath(curDifficulty);
		if(diffic == null) diffic = '';

		PlayState.storyDifficulty = curDifficulty;

		PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
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

		if (SaveData.actTwo && (SaveData.bfRoute == 5 || SaveData.jrRoute == 5))
		{
			if (curSelected == 1)
			{
				openSubState(new DDLCPrompt('File Error: "characters/boyfriend.chr"\n\nThe file is missing or corrupt', 0, function()
					{
						openSubState(new DDLCPrompt('The save file is corrupt. Starting a new game.', 0, function()
							{
								FlxTransitionableState.skipNextTransIn = true;
								FlxG.switchState(new LoadingState(new PlayState(), true, true));
								FlxG.sound.music.stop();
								FlxG.sound.music.volume = 0;
							}, null, 'OK', null));
					}, null, 'OK', null));
			}
			else
			{
				openSubState(new DDLCPrompt('File Error: "characters/bowserjr.chr"\n\nThe file is missing or corrupt', 0, function()
					{
						openSubState(new DDLCPrompt('The save file is corrupt. Starting a new game.', 0, function()
							{
								FlxTransitionableState.skipNextTransIn = true;
								FlxG.switchState(new LoadingState(new PlayState(), true, true));
								FlxG.sound.music.stop();
								FlxG.sound.music.volume = 0;
							}, null, 'OK', null));
					}, null, 'OK', null));
			}
		}
		else
		{
			story_cursor.animation.play('selected', true);
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				CustomFadeTransition.isHeartTran = true;
				openSubState(new CustomFadeTransition(0.4, false, new LoadingState(new PlayState(), true, true)));
				FlxG.sound.music.stop();
				FlxG.sound.music.volume = 0;
			});
		}
	}

	function openDaSelector()
	{
		selectedSomethin = true;
		openSubState(new StageSelectSubstate(curSelected, curDifficulty));
	}

	override function closeSubState() {
		changeItem(0, false);
		selectedSomethin = false;
		super.closeSubState();
	}

	function changeItem(huh:Int = 0, playSound:Bool = true)
	{
		curSelected += huh;

		// attempts to loop back into the bottom row
		if (curSelected == -3)
			curSelected = 3;
		if (curSelected == -2)
			curSelected = 4;
		if (curSelected == -1)
			curSelected = 5;

		// attempts to loop back into the top row
		if (curSelected == 7)
			curSelected = 1;
		if (curSelected == 8)
			curSelected = 2;
		if (curSelected == 9)
			curSelected = 3;

		if (curSelected >= 6)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = 6 - 1;

		if (playSound) FlxG.sound.play(Paths.sound('scrollMenu'));
	}

	function loadStorySlots()
	{
		story_bf_reg = new FlxSprite(350, 150);
		story_bf_reg.frames = Paths.getSparrowAtlas('storymenu/load_game/Save_Slots');
		story_bf_reg.animation.addByPrefix('locked', 'Locked', 24);
		story_bf_reg.animation.addByPrefix('idle', 'BF REGULAR', 24);
		if (SaveData.bfRoute > 0 || SaveData.bfRouteClear) story_bf_reg.animation.play('idle');
		else story_bf_reg.animation.play('locked');
		story_bf_reg.updateHitbox();
		add(story_bf_reg);

		story_bf_doki = new FlxSprite(350, 350);
		story_bf_doki.frames = Paths.getSparrowAtlas('storymenu/load_game/Save_Slots');
		story_bf_doki.animation.addByPrefix('locked', 'Locked', 24);
		story_bf_doki.animation.addByPrefix('idle', 'BF DOKI', 24);
		if (SaveData.dokiBFRoute > 0 || SaveData.dokiBFRouteClear) story_bf_doki.animation.play('idle');
		else story_bf_doki.animation.play('locked');
		story_bf_doki.updateHitbox();
		add(story_bf_doki);

		story_jr_reg = new FlxSprite(650, 150);
		story_jr_reg.frames = Paths.getSparrowAtlas('storymenu/load_game/Save_Slots');
		story_jr_reg.animation.addByPrefix('locked', 'Locked', 24);
		story_jr_reg.animation.addByPrefix('idle', 'JR REGULAR', 24);
		if (SaveData.jrRoute > 0 || SaveData.jrRouteClear) story_jr_reg.animation.play('idle');
		else story_jr_reg.animation.play('locked');
		story_jr_reg.updateHitbox();
		add(story_jr_reg);

		story_jr_doki = new FlxSprite(650, 350);
		story_jr_doki.frames = Paths.getSparrowAtlas('storymenu/load_game/Save_Slots');
		story_jr_doki.animation.addByPrefix('locked', 'Locked', 24);
		story_jr_doki.animation.addByPrefix('idle', 'JR DOKI', 24);
		if (SaveData.dokiJRRoute > 0 || SaveData.dokiJRRouteClear) story_jr_doki.animation.play('idle');
		else story_jr_doki.animation.play('locked');
		story_jr_doki.updateHitbox();
		add(story_jr_doki);

		story_moni_reg = new FlxSprite(950, 150);
		story_moni_reg.frames = Paths.getSparrowAtlas('storymenu/load_game/Save_Slots');
		story_moni_reg.animation.addByPrefix('locked', 'Locked', 24);
		story_moni_reg.animation.addByPrefix('idle', 'MONI REGULAR', 24);
		if (SaveData.monikaRoute > 0 || SaveData.monikaRouteClear) story_moni_reg.animation.play('idle');
		else story_moni_reg.animation.play('locked');
		story_moni_reg.updateHitbox();
		add(story_moni_reg);

		story_moni_doki = new FlxSprite(950, 350);
		story_moni_doki.frames = Paths.getSparrowAtlas('storymenu/load_game/Save_Slots');
		story_moni_doki.animation.addByPrefix('locked', 'Locked', 24);
		story_moni_doki.animation.addByPrefix('idle', 'MONI DOKI', 24);
		if (SaveData.dokiMONIRoute > 0 || SaveData.dokiMONIRouteClear) story_moni_doki.animation.play('idle');
		else story_moni_doki.animation.play('locked');
		story_moni_doki.updateHitbox();
		add(story_moni_doki);
	}

	function loadStars()
	{
		var star1 = new FlxSprite(story_bf_reg.x, story_bf_reg.y);
		star1.frames = Paths.getSparrowAtlas('storymenu/load_game/daStars');
		star1.animation.addByPrefix('blank', 'Uncleared', 24);
		star1.animation.addByPrefix('clear', 'Cleared', 24);
		if (SaveData.bfRouteClear) star1.animation.play('clear');
		else star1.animation.play('blank');
		star1.setGraphicSize(Std.int(star1.width * 0.7));
		star1.updateHitbox();
		add(star1);

		var star2 = new FlxSprite(story_jr_reg.x, story_jr_reg.y);
		star2.frames = Paths.getSparrowAtlas('storymenu/load_game/daStars');
		star2.animation.addByPrefix('blank', 'Uncleared', 24);
		star2.animation.addByPrefix('clear', 'Cleared', 24);
		if (SaveData.jrRouteClear) star2.animation.play('clear');
		else star2.animation.play('blank');
		star2.setGraphicSize(Std.int(star2.width * 0.7));
		star2.updateHitbox();
		add(star2);

		var star3 = new FlxSprite(story_moni_reg.x, story_moni_reg.y);
		star3.frames = Paths.getSparrowAtlas('storymenu/load_game/daStars');
		star3.animation.addByPrefix('blank', 'Uncleared', 24);
		star3.animation.addByPrefix('clear', 'Cleared', 24);
		if (SaveData.monikaRouteClear) star3.animation.play('clear');
		else star3.animation.play('blank');
		star3.setGraphicSize(Std.int(star3.width * 0.7));
		star3.updateHitbox();
		add(star3);

		var star4 = new FlxSprite(story_bf_doki.x, story_bf_doki.y);
		star4.frames = Paths.getSparrowAtlas('storymenu/load_game/daStars');
		star4.animation.addByPrefix('blank', 'Uncleared', 24);
		star4.animation.addByPrefix('clear', 'Cleared', 24);
		if (SaveData.dokiBFRouteClear) star4.animation.play('clear');
		else star4.animation.play('blank');
		star4.setGraphicSize(Std.int(star4.width * 0.7));
		star4.updateHitbox();
		add(star4);

		var star5 = new FlxSprite(story_jr_doki.x, story_jr_doki.y);
		star5.frames = Paths.getSparrowAtlas('storymenu/load_game/daStars');
		star5.animation.addByPrefix('blank', 'Uncleared', 24);
		star5.animation.addByPrefix('clear', 'Cleared', 24);
		if (SaveData.dokiJRRouteClear) star5.animation.play('clear');
		else star5.animation.play('blank');
		star5.setGraphicSize(Std.int(star5.width * 0.7));
		star5.updateHitbox();
		add(star5);

		var star6 = new FlxSprite(story_moni_doki.x, story_moni_doki.y);
		star6.frames = Paths.getSparrowAtlas('storymenu/load_game/daStars');
		star6.animation.addByPrefix('blank', 'Uncleared', 24);
		star6.animation.addByPrefix('clear', 'Cleared', 24);
		if (SaveData.dokiMONIRouteClear) star6.animation.play('clear');
		else star6.animation.play('blank');
		star6.setGraphicSize(Std.int(star6.width * 0.7));
		star6.updateHitbox();
		add(star6);
	}

	function loadTexts()
	{
		var color:FlxColor = 0xFF575757;
		if (TitleState.endEasterEgg) color = 0xFFFFFFFF;

		var routeText1:FlxText = new FlxText(350, 285, 237, "Boyfriend Route (REGULAR)");
		routeText1.setFormat(Paths.font("doki.ttf"), 12, color, CENTER);
		add(routeText1);
		var routeText2:FlxText = new FlxText(650, 285, 237, "Bowser Jr Route (REGULAR)");
		routeText2.setFormat(Paths.font("doki.ttf"), 12, color, CENTER);
		add(routeText2);
		var routeText3:FlxText = new FlxText(950, 285, 237, "Monika Route (REGULAR)");
		routeText3.setFormat(Paths.font("doki.ttf"), 12, color, CENTER);
		add(routeText3);
		var routeText4:FlxText = new FlxText(350, 485, 237, "Boyfriend Route (DOKI DOKI)");
		routeText4.setFormat(Paths.font("doki.ttf"), 12, color, CENTER);
		add(routeText4);
		var routeText5:FlxText = new FlxText(650, 485, 237, "Bowser Jr Route (DOKI DOKI)");
		routeText5.setFormat(Paths.font("doki.ttf"), 12, color, CENTER);
		add(routeText5);
		var routeText6:FlxText = new FlxText(950, 485, 237, "Monika Route (DOKI DOKI)");
		routeText6.setFormat(Paths.font("doki.ttf"), 12, color, CENTER);
		add(routeText6);

		var hideBF:Bool = (SaveData.bfRoute < 1 && !SaveData.bfRouteClear) || (SaveData.lockedRoute != 'BF' && SaveData.lockedRoute != 'None');
		var hideJR:Bool = (SaveData.jrRoute < 1 && !SaveData.jrRouteClear) || (SaveData.lockedRoute != 'JR' && SaveData.lockedRoute != 'None');
		var hideMONI:Bool = (SaveData.monikaRoute < 1 && !SaveData.monikaRouteClear) || (SaveData.lockedRoute != 'MONI' && SaveData.lockedRoute != 'None');
		var hideDOKIBF:Bool = (SaveData.dokiBFRoute < 1 && !SaveData.dokiBFRouteClear) || (SaveData.lockedRoute != 'BFDOKI' && SaveData.lockedRoute != 'None');
		var hideDOKIJR:Bool = (SaveData.dokiJRRoute < 1 && !SaveData.dokiJRRouteClear) || (SaveData.lockedRoute != 'JRDOKI' && SaveData.lockedRoute != 'None');
		var hideDOKIMONI:Bool = (SaveData.dokiMONIRoute < 1 && !SaveData.dokiMONIRouteClear) || (SaveData.lockedRoute != 'MONIDOKI' && SaveData.lockedRoute != 'None');

		if (hideBF)
		{
			routeText1.text = "empty slot";
			story_bf_reg.animation.play('locked', true);
		}
		if (hideJR) 
		{
			routeText2.text = "empty slot";
			story_jr_reg.animation.play('locked', true);
		}
		if (hideMONI) 
		{
			routeText3.text = "empty slot";
			story_moni_reg.animation.play('locked', true);
		}
		if (hideDOKIBF) 
		{
			routeText4.text = "empty slot";
			story_bf_doki.animation.play('locked', true);
		}
		if (hideDOKIJR) 
		{
			routeText5.text = "empty slot";
			story_jr_doki.animation.play('locked', true);
		}
		if (hideDOKIMONI) 
		{
			routeText6.text = "empty slot";
			story_moni_doki.animation.play('locked', true);
		}
	}
}
