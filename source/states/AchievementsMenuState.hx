package states;

import flixel.FlxObject;
import flixel.util.FlxSort;
import flixel.addons.display.FlxBackdrop;
#if desktop
import backend.Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;

import flixel.ui.FlxBar;

class AchievementsMenuState extends MusicBeatState
{
	#if ACHIEVEMENTS_ALLOWED
	public var options:Array<Dynamic> = [];
	public var grpOptions:FlxSpriteGroup;
	public var achText:FlxText;
	public var descText:FlxText;
	private static var curSelected:Int = 0;

	var MAX_PER_ROW:Int = 4;

	var camFollow:FlxObject;

	override function create() {
		#if desktop
		DiscordClient.changePresence("Achievements Menu", null);
		#end

		// prepare achievement list
		for (achievement => data in Achievements.achievements)
		{
			var unlocked:Bool = Achievements.isUnlocked(achievement);
			if(data.doki != true)
				options.push(makeAchievement(achievement, data, unlocked));
		}

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		TitleState.setDefaultRGB();
		var titleBg:DDLCBorderBG;
		titleBg = new DDLCBorderBG(Paths.image('mainmenu/rgbBg'), -40, -40);
		titleBg.scrollFactor.set();
		add(titleBg);

		var menuTxt:FlxText = new FlxText(5, 10, 0, "Achievements", 32);
		menuTxt.setFormat(Paths.font("dokiUI.ttf"), 40, FlxColor.WHITE, FlxTextAlign.RIGHT);
		menuTxt.setBorderStyle(OUTLINE, 0xFFBB5599, 6);
		menuTxt.scrollFactor.set();
		add(menuTxt);

		grpOptions = new FlxSpriteGroup();
		grpOptions.scrollFactor.x = 0;

		options.sort(sortByID);
		for (option in options)
		{
			var hasAntialias:Bool = ClientPrefs.globalAntialiasing;
			var graphic = null;
			if(option.unlocked)
			{
				var image:String = 'achievements/' + option.name;
				if(Paths.fileExists('images/$image-pixel.png', IMAGE))
				{
					graphic = Paths.image('$image-pixel');
					hasAntialias = false;
				}
				else graphic = Paths.image(image);

				if(graphic == null) graphic = Paths.image('unknownMod');
			}
			else graphic = Paths.image('achievements/lockedachievement');

			var spr:FlxSprite = new FlxSprite(0, Math.floor(grpOptions.members.length / MAX_PER_ROW) * 180).loadGraphic(graphic);
			spr.scrollFactor.x = 0;
			spr.screenCenter(X);
			spr.x += 180 * ((grpOptions.members.length % MAX_PER_ROW) - MAX_PER_ROW/2) + spr.width / 2 + 15;
			spr.ID = grpOptions.members.length;
			spr.antialiasing = hasAntialias;
			grpOptions.add(spr);
		}

		var box:FlxSprite = new FlxSprite(0, -30).makeGraphic(1, 1, FlxColor.BLACK);
		box.scale.set(grpOptions.width + 60, grpOptions.height + 60);
		box.updateHitbox();
		box.alpha = 0.6;
		box.scrollFactor.x = 0;
		box.screenCenter(X);
		add(box);
		add(grpOptions);

		var box:FlxSprite = new FlxSprite(0, 570).makeGraphic(1, 1, FlxColor.BLACK);
		box.scale.set(FlxG.width, FlxG.height - box.y);
		box.updateHitbox();
		box.alpha = 0.6;
		box.scrollFactor.set();
		add(box);

		achText = new FlxText(50, box.y + 10, FlxG.width - 100, "", 32);
		achText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER);
		achText.scrollFactor.set();

		descText = new FlxText(50, achText.y + 38, FlxG.width - 100, "", 24);
		descText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER);
		descText.scrollFactor.set();

		add(descText);
		add(achText);

		if (SaveData.bfRouteClear || SaveData.jrRouteClear)
		{
			Achievements.unhideAchievement('Sx_nomiss'); //Insxde My Head
			Achievements.unhideAchievement('G_nomiss'); //I'm Gonna Tell Everyone
			Achievements.unhideAchievement('Yd_nomiss'); //My Heart Pounds
			Achievements.unhideAchievement('se_combo'); //System Check Finished
		}
		if (SaveData.bfRouteClear || SaveData.jrRouteClear || SaveData.monikaRouteClear)
		{
			Achievements.unhideAchievement('JM_nomiss'); //I Love You
			Achievements.unhideAchievement('normal_clear'); //Best of the Club!
		}
		if (SaveData.monikaRouteClear)
		{
			Achievements.unhideAchievement('sf_double'); //She Came to her Senses
			Achievements.unhideAchievement('heartz_clear'); //It's Just an Illusion...
			Achievements.unhideAchievement('glitcher_clear'); //Wow...Just Wow
			Achievements.unhideAchievement('tfb_clear'); //Sayori Will Never Be Real
		}
		if (SaveData.bfRouteClear && SaveData.jrRouteClear && SaveData.monikaRouteClear)
		{
			Achievements.unhideAchievement('supernatural_nomiss'); //Paranormal Conflict
			Achievements.unhideAchievement('spiders_combo'); //They Call Me Amy
			Achievements.unhideAchievement('showoff_clear'); //Show-Off
			Achievements.unhideAchievement('crossover_clear'); //An Unexpected Crossover
			Achievements.unhideAchievement('festival_clear'); //A Triple Trouble
		}

		changeSelection();

		super.create();
		FlxG.camera.follow(camFollow, null, 0.15);
		FlxG.camera.scroll.y = -FlxG.height;
	}

	function makeAchievement(achievement:String, data:Achievement, unlocked:Bool)
	{
		var unlocked:Bool = Achievements.isUnlocked(achievement);
		return {
			name: achievement,
			displayName: unlocked ? data.name : '???',
			description: data.description,
			curProgress: data.maxScore > 0 ? Achievements.getScore(achievement) : 0,
			maxProgress: data.maxScore > 0 ? data.maxScore : 0,
			decProgress: data.maxScore > 0 ? data.maxDecimals : 0,
			doki: data.doki,
			secret: data.secret,
			hidden: data.hidden,
			unlocked: unlocked,
			ID: data.ID
		};
	}

	public static function sortByID(Obj1:Dynamic, Obj2:Dynamic):Int
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.ID, Obj2.ID);

	var goingBack:Bool = false;
	override function update(elapsed:Float) {
		super.update(elapsed);

		if(!goingBack && options.length > 1)
		{
			var add:Int = 0;
			if (controls.UI_LEFT_P) add = -1;
			else if (controls.UI_RIGHT_P) add = 1;

			if(add != 0)
			{
				var oldRow:Int = Math.floor(curSelected / MAX_PER_ROW);
				var rowSize:Int = Std.int(Math.min(MAX_PER_ROW, options.length - oldRow * MAX_PER_ROW));
				
				curSelected += add;
				var curRow:Int = Math.floor(curSelected / MAX_PER_ROW);
				if(curSelected >= options.length) curRow++;

				if(curRow != oldRow)
				{
					if(curRow < oldRow) curSelected += rowSize;
					else curSelected = curSelected -= rowSize;
				}
				changeSelection();
			}

			if(options.length > MAX_PER_ROW)
			{
				var add:Int = 0;
				if (controls.UI_UP_P) add = -1;
				else if (controls.UI_DOWN_P) add = 1;

				if(add != 0)
				{
					var diff:Int = curSelected - (Math.floor(curSelected / MAX_PER_ROW) * MAX_PER_ROW);
					curSelected += add * MAX_PER_ROW;
					if(curSelected < 0)
					{
						curSelected += Math.ceil(options.length / MAX_PER_ROW) * MAX_PER_ROW;
						if(curSelected >= options.length) curSelected -= MAX_PER_ROW;
					}
					if(curSelected >= options.length)
					{
						curSelected = diff;
					}
					changeSelection();
				}
			}
		}

		if (controls.BACK) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			openSubState(new CustomFadeTransition(0.6, false, new ExtraStuffState()));
			goingBack = true;
		}

		grpOptions.forEach(function(spr:FlxSprite)
		{
			if (FlxG.mouse.overlaps(spr) && FlxG.mouse.justPressed){
				if (curSelected != spr.ID){
					curSelected = spr.ID;
					changeSelection();
				}
			}
		});
	}

	function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		achText.text = options[curSelected].displayName;

		var maxRows = Math.floor(grpOptions.members.length / MAX_PER_ROW);
		if(maxRows > 0)
		{
			var camY:Float = FlxG.height / 2 + (Math.floor(curSelected / MAX_PER_ROW) / maxRows) * Math.max(0, grpOptions.height - FlxG.height / 2 - 50) - 100;
			camFollow.setPosition(0, camY);
		}
		else camFollow.setPosition(0, grpOptions.members[curSelected].getGraphicMidpoint().y - 100);

		grpOptions.forEach(function(spr:FlxSprite) {
			spr.alpha = 0.6;
			if(spr.ID == curSelected) spr.alpha = 1;
		});

		if (!options[curSelected].hidden || options[curSelected].unlocked || Achievements.unhiddenAchievements.contains(options[curSelected].name))
		{
			descText.text = options[curSelected].description;
		}
		else
		{
			descText.text = "Play the game more to reveal the description on how to unlock this achievement.";
		}

		if (options[curSelected].secret && !options[curSelected].unlocked)
		{
			descText.text = "This is a secret achievement! No hints! Do your best to find it!";
		}
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
	}
	#end
}