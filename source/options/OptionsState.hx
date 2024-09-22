package options;

import flixel.addons.display.FlxBackdrop;
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
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;

class OptionsState extends MusicBeatState
{
	var options:Array<String> = ['Note Colors', 'Controls', 'Adjust Delay and Combo', 'Graphics & Audio', 'Visuals and UI', 'Gameplay'];
	private var grpOptions:FlxTypedGroup<FlxText>;
	private static var curSelected:Int = 0;
	public static var onPlayState:Bool = false;
	public static var actNumber:Int = 1;
	var menuBg:DDLCBorderBG;
	var menuBorder:DDLCBorder;

	function openSelectedSubstate(label:String) {
		switch(label) {
			case 'Note Colors':
				openSubState(new options.NotesSubState());
			case 'Controls':
				openSubState(new options.ControlsSubState());
			case 'Graphics & Audio':
				openSubState(new options.GraphicsSettingsSubState());
			case 'Visuals and UI':
				openSubState(new options.VisualsUISubState());
			case 'Gameplay':
				openSubState(new options.GameplaySettingsSubState());
			case 'Adjust Delay and Combo':
				CustomFadeTransition.isHeartTran = true;
				openSubState(new CustomFadeTransition(0.4, false, new NoteOffsetState()));
		}
	}

	var selectorLeft:FlxText;
	var selectorRight:FlxText;

	override function create() {
		FlxG.mouse.visible = true;
		MusicBeatState.reloadCursor();

		menuBg = new DDLCBorderBG(Paths.image('mainmenu/rgbBg'), -40, -40);
		add(menuBg);

		menuBorder = new DDLCBorder(false);
		add(menuBorder);

		if (!onPlayState)
			actNumber = 1;

		if (TitleState.endEasterEgg)
			actNumber = 3;

		switch (actNumber) {
			case 1:
				menuBg.rValue = 0xFFFFFFFF;
				menuBg.gValue = 0xFFFFDBF0;
				menuBg.bValue = 0xFFFFBDE1;
				menuBorder.rValue = 0xFFFFFFFF;
				menuBorder.gValue = 0xFFFFDBF0;
				menuBorder.bValue = 0xFFFFBDE1;
			case 2:
				menuBg.rValue = 0xFF1B1B1B;
				menuBg.gValue = 0xFFCE4A7E;
				menuBg.bValue = 0xFFCE4A7E;
				menuBorder.rValue = 0xFF1B1B1B;
				menuBorder.gValue = 0xFF1B1B1B;
				menuBorder.bValue = 0xFFCE4A7E;
			case 3:
				menuBg.rValue = 0xFFCA1616;
				menuBg.gValue = 0xFF950000;
				menuBg.bValue = 0xFF560000;
				menuBorder.rValue = 0xFFCA1616;
				menuBorder.gValue = 0xFF950000;
				menuBorder.bValue = 0xFF560000;
		}

		var freeplayTxt:FlxText = new FlxText(50, 50, 0, "Options", 32);
		freeplayTxt.setFormat(Paths.font("dokiUI.ttf"), 40, FlxColor.WHITE, FlxTextAlign.RIGHT);
		freeplayTxt.setBorderStyle(OUTLINE, 0xFFBB5599, 6);
		add(freeplayTxt);

		grpOptions = new FlxTypedGroup<FlxText>();
		add(grpOptions);

		for (i in 0...options.length)
		{
			var optionText:FlxText = new FlxText(0, (75 * i) + 130, 480, options[i]);
			optionText.setFormat(Paths.font("dokiUI.ttf"), 38, FlxColor.WHITE, FlxTextAlign.CENTER);
			optionText.setBorderStyle(OUTLINE, 0xFFBB5599, 3.5);
			optionText.screenCenter(X);
			optionText.antialiasing = true;
			optionText.ID = i;
			grpOptions.add(optionText);
		}
		selectorLeft = new FlxText(0, 0, 0, '>', 38);
		selectorLeft.setFormat(Paths.font("dokiUI.ttf"), 38, FlxColor.WHITE, FlxTextAlign.CENTER);
		selectorLeft.setBorderStyle(OUTLINE, 0xFFFFAACC, 3.5);
		selectorLeft.antialiasing = true;
		add(selectorLeft);
		selectorRight = new FlxText(0, 0, 0, '<', 38);
		selectorRight.setFormat(Paths.font("dokiUI.ttf"), 38, FlxColor.WHITE, FlxTextAlign.CENTER);
		selectorRight.setBorderStyle(OUTLINE, 0xFFFFAACC, 3.5);
		selectorRight.antialiasing = true;
		add(selectorRight);

		changeSelection();
		ClientPrefs.saveSettings();

		super.create();
	}

	override function closeSubState() {
		super.closeSubState();
		ClientPrefs.saveSettings();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (controls.UI_UP_P) {
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P) {
			changeSelection(1);
		}

		if (controls.BACK) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			if(onPlayState)
			{
				CustomFadeTransition.isHeartTran = true;
				StageData.loadDirectory(PlayState.SONG);
				openSubState(new CustomFadeTransition(0.4, false, new PlayState()));
				FlxG.sound.music.volume = 0;
			}
			else openSubState(new CustomFadeTransition(0.6, false, new MainMenuState()));
		}

		if (controls.ACCEPT) {
			openSelectedSubstate(options[curSelected]);
		}
		grpOptions.forEach(function(txt:FlxText)
		{
			if (FlxG.mouse.overlaps(txt)){
				if (curSelected != txt.ID){
					curSelected = txt.ID;
					changeSelection();
				}
				if (FlxG.mouse.justPressed)
					openSelectedSubstate(options[curSelected]);
			}
		});
	}
	
	function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		var bulltrash:Int = 0;

		grpOptions.forEach(function(txt:FlxText)
		{
			txt.setBorderStyle(OUTLINE, 0xFFBB5599, 3.5);
	
			if (txt.ID == curSelected)
			{
				txt.setBorderStyle(OUTLINE, 0xFFFFAACC, 3.5);
				selectorLeft.x = txt.x - 30;
				selectorRight.x = txt.x + txt.fieldWidth + 15;
				selectorLeft.y = txt.y;
				selectorRight.y = txt.y;
			}
		});
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}
}