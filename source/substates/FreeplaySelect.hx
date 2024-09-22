package substates;

class FreeplaySelect extends MusicBeatSubstate
{
	var grpMenutrash:FlxTypedGroup<FlxText>;

	var menuStuff:Array<String> = ['Normal Songs', 'Classic Songs', 'Bonus Songs'];
	var items:Int = 1;

	var curSelected:Int = 0;

	var selectedSomethin:Bool = false;

	var canInput:Bool = false;

	var box:FlxSprite;
	var boxSuffix:String = '';

	public function new()
	{
		super();
		FlxG.mouse.visible = true;
		MusicBeatState.reloadCursor();
		TitleState.setDefaultRGB();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);

		add(bg);
		bg.alpha = 0.6;

		if (CoolUtil.easterEgg == 'End')
			boxSuffix = '-act3';

		box = new FlxSprite(0, 0).loadGraphic(Paths.image('blankPopup' + boxSuffix));
		box.antialiasing = ClientPrefs.globalAntialiasing;
		box.setGraphicSize(400, 430);
		box.screenCenter();
		add(box);

		var text:FlxText = new FlxText(0, 210, 400, 'Choose A Freeplay Menu');
		text.setFormat(Paths.font("doki.ttf"), 28, FlxColor.BLACK, FlxTextAlign.CENTER);
		text.screenCenter(X);
		add(text);

		grpMenutrash = new FlxTypedGroup<FlxText>();
		add(grpMenutrash);

		if (SaveData.monikaRouteClear || SaveData.dokiMONIRouteClear) items = 2;
		if ((SaveData.bfRouteClear && SaveData.jrRouteClear && SaveData.monikaRouteClear) || (SaveData.dokiBFRouteClear && SaveData.dokiJRRouteClear && SaveData.dokiMONIRouteClear))
			items = 3;

		for (i in 0...items) {
			var item:FlxText = new FlxText(0, (65 * i) + 285, 0, menuStuff[i]);
			item.setFormat(Paths.font("dokiUI.ttf"), 28, FlxColor.WHITE, FlxTextAlign.CENTER);
			item.setBorderStyle(OUTLINE, 0xFFBB5599, 4);
			item.ID = i;
			item.screenCenter(X);
			grpMenutrash.add(item);
		}

		new FlxTimer().start(0.1, function(tmr:FlxTimer){
			canInput = true;
		});
		changeSelection(0, false);
	}

	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		super.update(elapsed);

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
		FlxG.sound.play(Paths.sound('confirmMenu'));
		if (menuStuff[curSelected] != "???")
		{
			selectedSomethin = true;

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
						switch (curSelected)
						{
							case 0: openSubState(new CustomFadeTransition(0.6, false, new FreeplayState()));
							case 1: openSubState(new CustomFadeTransition(0.6, false, new ClassicFreeplayState()));
							case 2: openSubState(new CustomFadeTransition(0.6, false, new BonusFreeplayState()));
						}
					});
				}
			});
		}
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
	}
}
