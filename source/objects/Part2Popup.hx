package objects;

import flixel.*;
import flixel.FlxSubState;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUIPopup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;

class Part2Popup extends MusicBeatSubstate
{
	var box:FlxSprite;
    var white:FlxSprite;
    var button1:FlxText;
	var overlap1:Bool = false;

	public function new() 
	{
		super();	
	}
	
	override public function create():Void 
	{
		super.create();
		
		white = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
        white.alpha = 0.5;
		add(white);

        box = new FlxSprite(0, 0).loadGraphic(Paths.image('part2Popup'));
		box.antialiasing = ClientPrefs.globalAntialiasing;
		box.screenCenter();
		add(box);

		button1 = new FlxText(0, 604, 0, 'OK');
		button1.setFormat(Paths.font("dokiUI.ttf"), 32, FlxColor.WHITE, FlxTextAlign.CENTER);
		button1.setBorderStyle(OUTLINE, 0xFFBB5599, 3);
        button1.screenCenter(X);
		add(button1);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (FlxG.mouse.overlaps(button1))
        {
           	if (!overlap1)
           	{
            	overlap1 = true;
            	FlxG.sound.play(Paths.sound('scrollMenu'));
	            button1.setBorderStyle(OUTLINE, 0xFFFFAACC, 3.5);
            }
        	if (FlxG.mouse.justPressed)
            {
	            FlxG.sound.play(Paths.sound('confirmMenu'));
				close();
	        }
    	}
        else
        {
           	overlap1 = false;
            button1.setBorderStyle(OUTLINE, 0xFFBB5599, 3.5);
        }
	}
}