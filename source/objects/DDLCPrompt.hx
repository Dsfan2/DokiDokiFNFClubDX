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

/**
 * ...
 * @author 
 */
class DDLCPrompt extends MusicBeatSubstate
{
	var selected = 0;
	public var okc:Void->Void;
	public var cancelc:Void->Void;

	var box:FlxSprite;
	var text:FlxText;
	var theText:String = '';
    var white:FlxSprite;
    var goAnyway:Bool = false;
	var op1:String = 'YES';
	var op2:String = null;
    var button1:FlxText;
	var button2:FlxText;
	var overlap1:Bool = false;
	var overlap2:Bool = false;

	public function new(promptText:String='', defaultSelected:Int = 0, okCallback:Void->Void, ?cancelCallback:Void->Void=null,?acceptOnDefault:Bool=false,option1:String=null,?option2:String=null) 
	{
		selected = defaultSelected;
		okc = okCallback;
		cancelc = cancelCallback;
		theText = promptText;
		goAnyway = acceptOnDefault;
		
		if (option1 != null) op1 = option1;
		if (option2 != null) op2 = option2;
		super();	
	}
	
	override public function create():Void 
	{
		super.create();
		if (goAnyway){
			
			
				if(okc != null)okc();
			close();
			
		}else{
			white = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
        	white.alpha = 0.5;
			add(white);

        	box = new FlxSprite(0, 0).loadGraphic(Paths.image('blankPopup'));
			box.antialiasing = ClientPrefs.globalAntialiasing;
			box.screenCenter();
			add(box);

        	text = new FlxText(0, box.y + 76, box.width * 0.95, theText);
			text.setFormat(Paths.font('doki.ttf'), 32, FlxColor.BLACK, FlxTextAlign.CENTER);
			text.screenCenter(X);
			text.antialiasing = ClientPrefs.globalAntialiasing;
			add(text);

			button1 = new FlxText(0, box.y + 240, 0, op1);
			button1.setFormat(Paths.font("dokiUI.ttf"), 32, FlxColor.WHITE, FlxTextAlign.CENTER);
			button1.setBorderStyle(OUTLINE, 0xFFBB5599, 3);
        	button1.screenCenter(X);
			if (op2 != null) button1.x -= 100;
			add(button1);

			button2 = new FlxText(0, box.y + 240, 0, op2);
			button2.setFormat(Paths.font("dokiUI.ttf"), 32, FlxColor.WHITE, FlxTextAlign.CENTER);
			button2.setBorderStyle(OUTLINE, 0xFFBB5599, 3);
        	button2.screenCenter(X);
			button2.x += 100;
			if (op2 != null) add(button2);
		}
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (!goAnyway){
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
    	            if(okc != null)okc();
					close();
	            }
    	    }
        	else
        	{
            	overlap1 = false;
            	button1.setBorderStyle(OUTLINE, 0xFFBB5599, 3.5);
        	}
			if (FlxG.mouse.overlaps(button2) && op2 != null)
        	{
            	if (!overlap2)
            	{
            	    overlap2 = true;
                	FlxG.sound.play(Paths.sound('scrollMenu'));
	                button2.setBorderStyle(OUTLINE, 0xFFFFAACC, 3.5);
    	        }
        	    if (FlxG.mouse.justPressed)
            	{
	                FlxG.sound.play(Paths.sound('confirmMenu'));
    	            if(cancelc != null)cancelc();
					close();
	            }
    	    }
        	else
        	{
            	overlap2 = false;
            	button2.setBorderStyle(OUTLINE, 0xFFBB5599, 3.5);
        	}
		}
	}
	
}