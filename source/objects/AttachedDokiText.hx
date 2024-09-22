package objects;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class AttachedDokiText extends FlxText
{
	public var offsetX:Float = 0;
	public var offsetY:Float = 0;
	public var sprTracker:FlxSprite;
	public var copyVisible:Bool = true;
	public var copyAlpha:Bool = false;
	public var isSelected:Bool = false;
	var boldText:Bool = false;

	public function new(textValue:String = "", ?offsetX:Float = 0, ?offsetY:Float = 0, ?bold = false) 
	{
		super();
		x = 0;
		y = 0;
		fieldWidth = 0;
		text = textValue;
		if (bold)
		{
			setFormat(Paths.font("dokiUI.ttf"), 28, FlxColor.WHITE, FlxTextAlign.CENTER);
			setBorderStyle(OUTLINE, 0xFFBB5599, 3.5);
			boldText = true;
		}
		else
		{
			setFormat(Paths.font("doki.ttf"), 28, FlxColor.WHITE, FlxTextAlign.CENTER);
			setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
			boldText = false;
		}
		//isMenuItem = false;
		this.offsetX = offsetX;
		this.offsetY = offsetY;
	}

	override function update(elapsed:Float) {
		if (sprTracker != null) {
			setPosition(sprTracker.x + offsetX, sprTracker.y + offsetY);
			if(copyVisible) {
				visible = sprTracker.visible;
			}
			if(copyAlpha) {
				alpha = sprTracker.alpha;
			}
		}

		if (boldText)
		{
			if (isSelected)
				setBorderStyle(OUTLINE, 0xFFFFAACC, 3.5);
			else
				setBorderStyle(OUTLINE, 0xFFBB5599, 3.5);
		}

		super.update(elapsed);
	}
}