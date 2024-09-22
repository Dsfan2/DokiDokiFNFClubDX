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

class ControlsSubState extends MusicBeatSubstate {
	private static var curSelected:Int = -1;
	private static var curAlt:Bool = false;

	private static var defaultKey:String = 'Reset to Default Keys';
	private var bindLength:Int = 0;

	//var menuBg:FlxBackdrop;
	//var menuBorder:FlxSprite;
	var menuBg:DDLCBorderBG;
	var menuBorder:DDLCBorder;

	var blackBG:FlxSprite;

	var optiontrash:Array<Dynamic> = [
		['NOTES'],
		['Left', 'note_left'],
		['Down', 'note_down'],
		['Up', 'note_up'],
		['Right', 'note_right'],
		['Dodge', 'dodge'],
		[''],
		['UI'],
		['Left', 'ui_left'],
		['Down', 'ui_down'],
		['Up', 'ui_up'],
		['Right', 'ui_right'],
		[''],
		['Reset', 'reset'],
		['Accept', 'accept'],
		['Back', 'back'],
		['Pause', 'pause'],
		#if debug
		[''],
		['DEBUG'],
		['Key 1', 'debug_1'],
		['Key 2', 'debug_2'],
		#end
		[''],
		['VOLUME'],
		['Mute', 'volume_mute'],
		['Up', 'volume_up'],
		['Down', 'volume_down']
	];
	private var grpOptions:FlxTypedGroup<CoolScrollText>;
	private var grpInputs:Array<AttachedDokiText> = [];
	private var grpInputsAlt:Array<AttachedDokiText> = [];
	var rebindingKey:Bool = false;
	var nextAccept:Int = 5;

	public function new() {
		super();

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

		var titleText:FlxText = new FlxText(50, 50, 0, "Controls", 32);
		titleText.setFormat(Paths.font("dokiUI.ttf"), 40, FlxColor.WHITE, FlxTextAlign.RIGHT);
		titleText.setBorderStyle(OUTLINE, 0xFFBB5599, 6);
		add(titleText);

		blackBG = new FlxSprite(385, 347).makeGraphic(500, 50, FlxColor.BLACK);
		blackBG.alpha = 0.4;
		add(blackBG);

		grpOptions = new FlxTypedGroup<CoolScrollText>();
		add(grpOptions);

		optiontrash.push(['']);
		optiontrash.push([defaultKey]);

		for (i in 0...optiontrash.length) {
			var isCentered:Bool = false;
			var isDefaultKey:Bool = (optiontrash[i][0] == defaultKey);
			if(unselectableCheck(i, true)) {
				isCentered = true;
			}

			var optionText:CoolScrollText = new CoolScrollText(600, (110 * i) + 200, 0, optiontrash[i][0]);
			if(isCentered) {
				optionText.screenCenter(X);
				optionText.yAdd = 0;
			} else {
				optionText.x = 400;
			}
			optionText.yMult = 60;
			optionText.targetY = i;
			optionText.ID = i;
			grpOptions.add(optionText);

			if(!isCentered) {
				addBindTexts(optionText, i);
				bindLength++;
				if(curSelected < 0) curSelected = i;
			}
		}
		changeSelection();
	}

	var leaving:Bool = false;
	var bindingTime:Float = 0;
	override function update(elapsed:Float) {
		if(!rebindingKey) {
			if (controls.UI_UP_P) {
				changeSelection(-1);
			}
			if (controls.UI_DOWN_P) {
				changeSelection(1);
			}
			if (controls.UI_LEFT_P || controls.UI_RIGHT_P) {
				changeAlt();
			}

			if (controls.BACK) {
				ClientPrefs.reloadControls();
				close();
				FlxG.sound.play(Paths.sound('cancelMenu'));
			}

			if(controls.ACCEPT && nextAccept <= 0) {
				if(optiontrash[curSelected][0] == defaultKey) {
					ClientPrefs.keyBinds = ClientPrefs.defaultKeys.copy();
					reloadKeys();
					changeSelection();
					FlxG.sound.play(Paths.sound('confirmMenu'));
				} else if(!unselectableCheck(curSelected)) {
					bindingTime = 0;
					rebindingKey = true;
					if (curAlt) {
						grpInputsAlt[getInputTextNum()].alpha = 0;
					} else {
						grpInputs[getInputTextNum()].alpha = 0;
					}
					FlxG.sound.play(Paths.sound('scrollMenu'));
				}
			}
		} else {
			var keyPressed:Int = FlxG.keys.firstJustPressed();
			if (keyPressed > -1) {
				var keysArray:Array<FlxKey> = ClientPrefs.keyBinds.get(optiontrash[curSelected][1]);
				keysArray[curAlt ? 1 : 0] = keyPressed;

				var opposite:Int = (curAlt ? 0 : 1);
				if(keysArray[opposite] == keysArray[1 - opposite]) {
					keysArray[opposite] = NONE;
				}
				ClientPrefs.keyBinds.set(optiontrash[curSelected][1], keysArray);

				reloadKeys();
				FlxG.sound.play(Paths.sound('confirmMenu'));
				rebindingKey = false;
			}

			bindingTime += elapsed;
			if(bindingTime > 5) {
				if (curAlt) {
					grpInputsAlt[curSelected].alpha = 1;
				} else {
					grpInputs[curSelected].alpha = 1;
				}
				FlxG.sound.play(Paths.sound('scrollMenu'));
				rebindingKey = false;
				bindingTime = 0;
			}
		}

		if(nextAccept > 0) {
			nextAccept -= 1;
		}

		grpOptions.forEach(function(txt:CoolScrollText)
		{
			if (txt.ID == curSelected)
				txt.isSelected = true;
			else
				txt.isSelected = false;
		});

		super.update(elapsed);
	}

	function getInputTextNum() {
		var num:Int = 0;
		for (i in 0...curSelected) {
			if(optiontrash[i].length > 1) {
				num++;
			}
		}
		return num;
	}
	
	function changeSelection(change:Int = 0) {
		do {
			curSelected += change;
			if (curSelected < 0)
				curSelected = optiontrash.length - 1;
			if (curSelected >= optiontrash.length)
				curSelected = 0;
		} while(unselectableCheck(curSelected));

		var bulltrash:Int = 0;

		for (i in 0...grpInputs.length) {
			grpInputs[i].alpha = 0.6;
		}
		for (i in 0...grpInputsAlt.length) {
			grpInputsAlt[i].alpha = 0.6;
		}

		for (item in grpOptions.members) {
			item.targetY = bulltrash - curSelected;
			bulltrash++;

			if(!unselectableCheck(bulltrash-1)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
					if(curAlt) {
						for (i in 0...grpInputsAlt.length) {
							if(grpInputsAlt[i].sprTracker == item) {
								grpInputsAlt[i].alpha = 1;
								break;
							}
						}
					} else {
						for (i in 0...grpInputs.length) {
							if(grpInputs[i].sprTracker == item) {
								grpInputs[i].alpha = 1;
								break;
							}
						}
					}
				}
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}

	function changeAlt() {
		curAlt = !curAlt;
		for (i in 0...grpInputs.length) {
			if(grpInputs[i].sprTracker == grpOptions.members[curSelected]) {
				grpInputs[i].alpha = 0.6;
				if(!curAlt) {
					grpInputs[i].alpha = 1;
				}
				break;
			}
		}
		for (i in 0...grpInputsAlt.length) {
			if(grpInputsAlt[i].sprTracker == grpOptions.members[curSelected]) {
				grpInputsAlt[i].alpha = 0.6;
				if(curAlt) {
					grpInputsAlt[i].alpha = 1;
				}
				break;
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}

	private function unselectableCheck(num:Int, ?checkDefaultKey:Bool = false):Bool {
		if(optiontrash[num][0] == defaultKey) {
			return checkDefaultKey;
		}
		return optiontrash[num].length < 2 && optiontrash[num][0] != defaultKey;
	}

	private function addBindTexts(optionText:CoolScrollText, num:Int)
	{
		var keys:Array<Dynamic> = ClientPrefs.keyBinds.get(optiontrash[num][1]);
		var text1 = new AttachedDokiText(InputFormatter.getKeyName(keys[0]), 200, 0);
		text1.setPosition(optionText.x + 200, optionText.y - 0);
		text1.sprTracker = optionText;
		grpInputs.push(text1);
		add(text1);
	
		var text2 = new AttachedDokiText(InputFormatter.getKeyName(keys[1]), 350, 0);
		text2.setPosition(optionText.x + 350, optionText.y - 0);
		text2.sprTracker = optionText;
		grpInputsAlt.push(text2);
		add(text2);
	}

	function reloadKeys() {
		while(grpInputs.length > 0) {
			var item:AttachedDokiText = grpInputs[0];
			item.kill();
			grpInputs.remove(item);
			item.destroy();
		}
		while(grpInputsAlt.length > 0) {
			var item:AttachedDokiText = grpInputsAlt[0];
			item.kill();
			grpInputsAlt.remove(item);
			item.destroy();
		}

		trace('Reloaded keys: ' + ClientPrefs.keyBinds);

		for (i in 0...grpOptions.length) {
			if(!unselectableCheck(i, true)) {
				addBindTexts(grpOptions.members[i], i);
			}
		}


		var bulltrash:Int = 0;
		for (i in 0...grpInputs.length) {
			grpInputs[i].alpha = 0.6;
		}
		for (i in 0...grpInputsAlt.length) {
			grpInputsAlt[i].alpha = 0.6;
		}

		for (item in grpOptions.members) {
			item.targetY = bulltrash - curSelected;
			bulltrash++;

			if(!unselectableCheck(bulltrash-1)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
					if(curAlt) {
						for (i in 0...grpInputsAlt.length) {
							if(grpInputsAlt[i].sprTracker == item) {
								grpInputsAlt[i].alpha = 1;
							}
						}
					} else {
						for (i in 0...grpInputs.length) {
							if(grpInputs[i].sprTracker == item) {
								grpInputs[i].alpha = 1;
							}
						}
					}
				}
			}
		}
	}
}