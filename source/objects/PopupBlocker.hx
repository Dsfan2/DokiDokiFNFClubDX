package objects;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.group.FlxSpriteGroup;

class PopupBlocker extends FlxSpriteGroup
{
	var popUp:FlxSprite;
	var dokiPopup:Bool = false;
	var text:FlxText;
	var popupText:String = 'Just Monika';
    var okko:FlxText;
	var popUpClosed:Bool = false;
	//time:Float = 1;
	public function new(x:Float, y:Float, ?isDoki:Bool = false, ?duration:Float = 1)
	{
		super();

		if (isDoki)
		{
			dokiPopup = true;
			popUpClosed = false;
			popUp = new FlxSprite(x, y);
			popUp.frames = Paths.getSparrowAtlas('hacks/glitchPopUp');
			popUp.animation.addByPrefix('glitch', 'glitch', 30, true);
			popUp.animation.play('glitch');
			popUp.antialiasing = ClientPrefs.globalAntialiasing;
			popUp.scrollFactor.set();

			text = new FlxText(popUp.x + 14, popUp.y + 82, popUp.width * 0.95, popupText);
			text.setFormat(Paths.font('doki.ttf'), 32, FlxColor.BLACK, FlxTextAlign.CENTER);
			//text.screenCenter(X);
			text.antialiasing = ClientPrefs.globalAntialiasing;

	        okko = new FlxText(popUp.x + 167, popUp.y + 220, 60, "OK");
			okko.setFormat(Paths.font("dokiUI.ttf"), 32, FlxColor.WHITE, FlxTextAlign.CENTER);
			okko.setBorderStyle(OUTLINE, 0xFFBB5599, 3);
    	    //okko.screenCenter(X);

			add(popUp);
			add(text);
            add(okko);
			new FlxTimer().start(10, function(tmr:FlxTimer)
			{
				if (!popUpClosed)
				{
					popUpClosed = true;
					remove(text);
					remove(okko);
					remove(popUp);
					kill();
				}
			});
		}
		else
		{
			popUp = new FlxSprite(x, y);
			popUp.frames = Paths.getSparrowAtlas('hacks/popUp');
			popUp.animation.addByPrefix('open', 'popIn', 24, false);
			popUp.animation.addByPrefix('close', 'popOut', 24, false);
			popUp.antialiasing = ClientPrefs.globalAntialiasing;
			popUp.scrollFactor.set();
			add(popUp);
			popUp.animation.play('open');
			new FlxTimer().start(duration, function(tmr:FlxTimer)
			{
				popUp.animation.play('close');
				new FlxTimer().start(0.3, function(tmr:FlxTimer)
				{
					remove(popUp);
					kill();
				});
			});
		}
	}

	override function update(elapsed:Float)
	{
		if (dokiPopup)
		{
			if (FlxG.mouse.overlaps(popUp) && FlxG.mouse.justPressed && !popUpClosed)
			{
				popUpClosed = true;
				FlxG.sound.play(Paths.sound('confirmMenu'));
				remove(text);
				remove(okko);
				remove(popUp);
				kill();
			}
		}
		super.update(elapsed);
	}
}
