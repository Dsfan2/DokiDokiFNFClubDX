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

class BaseOptionsMenu extends MusicBeatSubstate
{
	private var curOption:Option = null;
	private var curSelected:Int = 0;
	private var optionsArray:Array<Option>;

	private var grpOptions:FlxTypedGroup<FlxText>;
	private var checkboxGroup:FlxTypedGroup<CheckboxThingie>;
	private var grpTexts:FlxTypedGroup<AttachedDokiText>;

	private var boyfriend:Character = null;
	private var descBox:FlxSprite;
	private var descText:FlxText;

	public var title:String;
	public var rpcTitle:String;

	private var player1:Character = null;
	private var player2:Character = null;
	private var player3:Character = null;

	var menuBg:DDLCBorderBG;
	var menuBorder:DDLCBorder;

	public function new()
	{
		super();

		if(title == null) title = 'Options';
		if(rpcTitle == null) rpcTitle = 'Options Menu';
		
		menuBg = new DDLCBorderBG(Paths.image('mainmenu/rgbBg'), -40, -40);
		add(menuBg);

		menuBorder = new DDLCBorder(false);
		add(menuBorder);

		switch (OptionsState.actNumber) {
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

		grpOptions = new FlxTypedGroup<FlxText>();
		add(grpOptions);

		grpTexts = new FlxTypedGroup<AttachedDokiText>();
		add(grpTexts);

		checkboxGroup = new FlxTypedGroup<CheckboxThingie>();
		add(checkboxGroup);

		descBox = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
		descBox.alpha = 0.6;
		add(descBox);

		var titleText:FlxText = new FlxText(50, 50, 0, title, 32);
		titleText.setFormat(Paths.font("dokiUI.ttf"), 40, FlxColor.WHITE, FlxTextAlign.RIGHT);
		titleText.setBorderStyle(OUTLINE, 0xFFBB5599, 6);
		add(titleText);

		descText = new FlxText(50, 600, 1180, "", 32);
		descText.setFormat(Paths.font("doki.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 1.5;
		add(descText);

		for (i in 0...optionsArray.length)
		{
			var optionText:FlxText = new FlxText(optionsArray[i].xPos, optionsArray[i].yPos, 0, optionsArray[i].name);
			optionText.setFormat(Paths.font("dokiUI.ttf"), 28, FlxColor.WHITE, FlxTextAlign.LEFT);
			optionText.setBorderStyle(OUTLINE, 0xFFBB5599, 3.5);
			optionText.antialiasing = true;
			optionText.ID = i;
			grpOptions.add(optionText);

			if(optionsArray[i].type == 'bool') {
				var checkbox:CheckboxThingie = new CheckboxThingie(optionText.x, optionText.y, optionsArray[i].getValue() == true);
				checkbox.sprTracker = optionText;
				checkbox.offsetY = -60;
				checkbox.offsetX = 50;
				checkbox.ID = i;
				checkbox.scale.set(0.7, 0.7);
				checkboxGroup.add(checkbox);
			} else {
				var valueText:AttachedDokiText = new AttachedDokiText('' + optionsArray[i].getValue(), optionText.width + 40);
				valueText.sprTracker = optionText;
				valueText.copyAlpha = true;
				valueText.offsetX -= (optionText.width + 20);
				valueText.offsetY += 35;
				valueText.ID = i;
				grpTexts.add(valueText);
				optionsArray[i].setChild(valueText);
			}

			if(optionsArray[i].showBoyfriend && boyfriend == null)
			{
				reloadBoyfriend();
			}

			if(optionsArray[i].showP1 && player1 == null)
			{
				reloadP1();
			}

			if(optionsArray[i].showP2 && player2 == null)
			{
				reloadP2();
			}

			if(optionsArray[i].showP3 && player3 == null)
			{
				reloadP3();
			}
			updateTextFrom(optionsArray[i]);
		}

		changeSelection();
		reloadCheckboxes();
	}

	public function addOption(option:Option) {
		if(optionsArray == null || optionsArray.length < 1) optionsArray = [];
		optionsArray.push(option);
	}

	var nextAccept:Int = 5;
	var holdTime:Float = 0;
	var holdValue:Float = 0;
	override function update(elapsed:Float)
	{
		if (controls.BACK) {
			close();
			FlxG.sound.play(Paths.sound('cancelMenu'));
		}

		if(nextAccept <= 0)
		{
			var usesCheckbox = true;
			if(curOption.type != 'bool')
			{
				usesCheckbox = false;
			}

			if(controls.ACCEPT) {
				if (usesCheckbox)
				{
					FlxG.sound.play(Paths.sound('confirmMenu'));
					curOption.setValue((curOption.getValue() == true) ? false : true);
					curOption.change();
					reloadCheckboxes();
				}
			}

			if(controls.UI_LEFT || controls.UI_RIGHT) {
				var pressed = (controls.UI_LEFT_P || controls.UI_RIGHT_P);
				if(holdTime > 0.5 || pressed) {
					if(pressed) {
						var add:Dynamic = null;
						if(curOption.type != 'string') {
							add = controls.UI_LEFT ? -curOption.changeValue : curOption.changeValue;
						}

						switch(curOption.type)
						{
							case 'int' | 'float' | 'percent':
								holdValue = curOption.getValue() + add;
								if(holdValue < curOption.minValue) holdValue = curOption.minValue;
								else if (holdValue > curOption.maxValue) holdValue = curOption.maxValue;

								switch(curOption.type)
								{
									case 'int':
										holdValue = Math.round(holdValue);
										curOption.setValue(holdValue);

									case 'float' | 'percent':
										holdValue = FlxMath.roundDecimal(holdValue, curOption.decimals);
										curOption.setValue(holdValue);
								}

							case 'string':
								var num:Int = curOption.curOption; //lol
								if(controls.UI_LEFT_P) --num;
								else num++;

								if(num < 0) {
									num = curOption.options.length - 1;
								} else if(num >= curOption.options.length) {
									num = 0;
								}

								curOption.curOption = num;
								curOption.setValue(curOption.options[num]); //lol
						}
						updateTextFrom(curOption);
						curOption.change();
						FlxG.sound.play(Paths.sound('scrollMenu'));
					} else if(curOption.type != 'string') {
						holdValue += curOption.scrollSpeed * elapsed * (controls.UI_LEFT ? -1 : 1);
						if(holdValue < curOption.minValue) holdValue = curOption.minValue;
						else if (holdValue > curOption.maxValue) holdValue = curOption.maxValue;

						switch(curOption.type)
						{
							case 'int':
								curOption.setValue(Math.round(holdValue));
							
							case 'float' | 'percent':
								curOption.setValue(FlxMath.roundDecimal(holdValue, curOption.decimals));
						}
						updateTextFrom(curOption);
						curOption.change();
					}
				}

				if(curOption.type != 'string') {
					holdTime += elapsed;
				}
			} else if(controls.UI_LEFT_R || controls.UI_RIGHT_R) {
				clearHold();
			}

			if(controls.RESET)
			{
				for (i in 0...optionsArray.length)
				{
					var leOption:Option = optionsArray[i];
					leOption.setValue(leOption.defaultValue);
					if(leOption.type != 'bool')
					{
						if(leOption.type == 'string')
						{
							leOption.curOption = leOption.options.indexOf(leOption.getValue());
						}
						updateTextFrom(leOption);
					}
					leOption.change();
				}
				FlxG.sound.play(Paths.sound('cancelMenu'));
				reloadCheckboxes();
			}
		}

		if(boyfriend != null && boyfriend.animation.curAnim.finished) {
			boyfriend.dance();
		}

		if(player1 != null && player1.animation.curAnim.finished) {
			player1.dance();
		}
		if(player2 != null && player2.animation.curAnim.finished) {
			player2.dance();
		}
		if(player3 != null && player3.animation.curAnim.finished) {
			player3.dance();
		}

		if(nextAccept > 0) {
			nextAccept -= 1;
		}

		grpOptions.forEach(function(txt:FlxText)
		{
			txt.setBorderStyle(OUTLINE, 0xFFBB5599, 4);
	
			if (txt.ID == curSelected)
				txt.setBorderStyle(OUTLINE, 0xFFFFAACC, 4);
		});

		grpOptions.forEach(function(txt:FlxText)
		{
			if (FlxG.mouse.overlaps(txt)){
				if (curSelected != txt.ID){
					curSelected = txt.ID;
					changeSelection();
				}
				if (FlxG.mouse.justPressed) {
					if (curOption.type == 'bool') {
						FlxG.sound.play(Paths.sound('confirmMenu'));
						curOption.setValue((curOption.getValue() == true) ? false : true);
						curOption.change();
						reloadCheckboxes();
					}
				}
			}
		});

		super.update(elapsed);
	}

	function updateTextFrom(option:Option) {
		var text:String = option.displayFormat;
		var val:Dynamic = option.getValue();
		if(option.type == 'percent') val *= 100;
		var def:Dynamic = option.defaultValue;
		option.text = text.replace('%v', val).replace('%d', def);
	}

	function clearHold()
	{
		if(holdTime > 0.5) {
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		holdTime = 0;
	}
	
	function changeSelection(change:Int = 0)
	{
		curSelected += change;
		if (curSelected < 0)
			curSelected = optionsArray.length - 1;
		if (curSelected >= optionsArray.length)
			curSelected = 0;

		descText.text = optionsArray[curSelected].description;
		descText.screenCenter(Y);
		descText.y += 270;

		for (text in grpTexts) {
			text.alpha = 0.6;
			if(text.ID == curSelected) {
				text.alpha = 1;
			}
		}

		descBox.setPosition(descText.x - 10, descText.y - 10);
		descBox.setGraphicSize(Std.int(descText.width + 20), Std.int(descText.height + 25));
		descBox.updateHitbox();

		if(boyfriend != null)
		{
			boyfriend.visible = optionsArray[curSelected].showBoyfriend;
		}
		if(player1 != null)
		{
			player1.visible = optionsArray[curSelected].showP1;
		}
		if(player2 != null)
		{
			player2.visible = optionsArray[curSelected].showP2;
		}
		if(player3 != null)
		{
			player3.visible = optionsArray[curSelected].showP3;
		}
		curOption = optionsArray[curSelected]; //shorter lol
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}

	public function reloadBoyfriend()
	{
		var wasVisible:Bool = false;
		if(boyfriend != null) {
			wasVisible = boyfriend.visible;
			boyfriend.kill();
			remove(boyfriend);
			boyfriend.destroy();
		}

		boyfriend = new Character(840, 70, 'bf', true);
		boyfriend.setGraphicSize(Std.int(boyfriend.width * 0.75));
		boyfriend.updateHitbox();
		boyfriend.dance();
		insert(1, boyfriend);
		boyfriend.visible = wasVisible;
	}

	public function reloadP1()
	{
		var wasVisible:Bool = false;
		if(player1 != null) {
			wasVisible = player1.visible;
			player1.kill();
			remove(player1);
			player1.destroy();
		}
	
		player1 = new Character(840, 70, 'player1', true);
		player1.setGraphicSize(Std.int(player1.width * 0.75));
		player1.updateHitbox();
		player1.dance();
		insert(1, player1);
		player1.visible = wasVisible;
	}

	public function reloadP2()
	{
		var wasVisible:Bool = false;
		if(player2 != null) {
			wasVisible = player2.visible;
			player2.kill();
			remove(player2);
			player2.destroy();
		}
		
		player2 = new Character(840, 170, 'player2', true);
		player2.setGraphicSize(Std.int(player2.width * 0.75));
		player2.updateHitbox();
		player2.dance();
		insert(1, player2);
		player2.visible = wasVisible;
	}

	public function reloadP3()
	{
		var wasVisible:Bool = false;
		if(player3 != null) {
			wasVisible = player3.visible;
			player3.kill();
			remove(player3);
			player3.destroy();
		}
			
		player3 = new Character(840, 70, 'player3', true);
		player3.setGraphicSize(Std.int(player3.width * 0.75));
		player3.updateHitbox();
		player3.dance();
		insert(1, player3);
		player3.visible = wasVisible;
	}


	function reloadCheckboxes() {
		for (checkbox in checkboxGroup) {
			checkbox.daValue = (optionsArray[checkbox.ID].getValue() == true);
		}
	}
}