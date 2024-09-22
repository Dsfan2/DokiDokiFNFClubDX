package states.editors;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class MasterEditorMenu extends MusicBeatState
{
	var options:Array<String> = [
		'Character Editor',
		'Chart Editor'
	];
	//private var grpTexts:FlxTypedGroup<Alphabet>;
	private var grpTexts:FlxTypedGroup<FlxText>;
	private var directories:Array<String> = [null];

	private var curSelected = 0;
	private var curDirectory = 0;
	private var directoryTxt:FlxText;

	override function create()
	{
		FlxG.camera.bgColor = FlxColor.BLACK;

		TitleState.setDefaultRGB();
		var menuBg:DDLCBorderBG;
		var menuBorder:DDLCBorder;

		menuBg = new DDLCBorderBG(Paths.image('mainmenu/rgbBg'), -40, -40);
		add(menuBg);

		menuBorder = new DDLCBorder(false);
		add(menuBorder);

		var titleText:FlxText = new FlxText(50, 50, 0, 'Debug Editors Menu', 32);
		titleText.setFormat(Paths.font("dokiUI.ttf"), 40, FlxColor.WHITE, FlxTextAlign.RIGHT);
		titleText.setBorderStyle(OUTLINE, 0xFFBB5599, 6);
		add(titleText);

		grpTexts = new FlxTypedGroup<FlxText>();
		add(grpTexts);

		for (i in 0...options.length)
		{
			var optionText:FlxText = new FlxText(0, (75 * i) + 130, FlxG.width, options[i]);
			optionText.setFormat(Paths.font("dokiUI.ttf"), 38, FlxColor.WHITE, FlxTextAlign.CENTER);
			optionText.setBorderStyle(OUTLINE, 0xFFBB5599, 3.5);
			optionText.screenCenter(X);
			optionText.antialiasing = true;
			optionText.ID = i;
			grpTexts.add(optionText);
		}
		
		changeSelection();

		FlxG.mouse.visible = true;
		MusicBeatState.reloadCursor();
		super.create();
	}

	override function update(elapsed:Float)
	{
		if (controls.UI_UP_P)
		{
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P)
		{
			changeSelection(1);
		}

		if (controls.BACK)
		{
			openSubState(new CustomFadeTransition(0.6, false, new MainMenuState()));
		}

		if (controls.ACCEPT)
		{
			CustomFadeTransition.isHeartTran = true;
			switch(options[curSelected]) {
				case 'Character Editor':
					openSubState(new CustomFadeTransition(0.6, false, new CharacterEditorState(Character.DEFAULT_CHARACTER, false)));
				case 'Chart Editor'://felt it would be cool maybe
					openSubState(new CustomFadeTransition(0.6, false, new ChartingState()));
			}
			FlxG.sound.music.volume = 0;
		}

		grpTexts.forEach(function(txt:FlxText)
		{
			txt.setBorderStyle(OUTLINE, 0xFFBB5599, 3.5);
			txt.alpha = 0.6;
		
			if (txt.ID == curSelected)
			{
				txt.alpha = 1;
				txt.setBorderStyle(OUTLINE, 0xFFFFAACC, 3.5);
			}
		});
		
		var bulltrash:Int = 0;
		super.update(elapsed);
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;
	}
}