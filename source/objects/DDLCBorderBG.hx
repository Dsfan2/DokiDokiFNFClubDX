package objects;

import flixel.addons.display.FlxBackdrop;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxColor;
import flixel.graphics.FlxGraphic;
import flixel.system.FlxAssets;

class DDLCBorderBG extends FlxBackdrop
{
	public var rgbShader:RGBShaderReference;
	public static var globalRgbShaders:RGBPalette;
	public var rValue:FlxColor = 0xFF;
	public var gValue:FlxColor = 0xFF;
	public var bValue:FlxColor = 0xFF;

	public function new(graphic:FlxGraphicAsset, scrollX:Int, scrollY:Int)
	{
		super(graphic);
		//this.graphic = graphic;
		//graphic = Paths.image('mainmenu/rgbBg');
		velocity.set(scrollX, scrollY);
		antialiasing = ClientPrefs.globalAntialiasing;
		rgbShader = new RGBShaderReference(this, initializeGlobalRGBShader());
	}

	function defaultRGB()
	{
		var arr:Array<FlxColor> = TitleState.bgRGB;

		if (TitleState.bgRGB == null || TitleState.bgRGB.length < 1)
			TitleState.bgRGB = [0xFFFFFFFF, 0xFFFFDBF0, 0xFFFFBDE1];

		if (rValue == 0xFF)
			rValue = arr[0];
		if (gValue == 0xFF)
			gValue = arr[1];
		if (bValue == 0xFF)
			bValue = arr[2];

		rgbShader.r = rValue;
		rgbShader.g = gValue;
		rgbShader.b = bValue;
	}

	private static function initializeGlobalRGBShader()
	{
		if(globalRgbShaders == null)
		{
			var newRGB:RGBPalette = new RGBPalette();
			globalRgbShaders = newRGB;

			//CoolUtil.difficultyString() != 'DOKI DOKI'
			var arr:Array<FlxColor> = TitleState.bgRGB;
			newRGB.r = arr[0];
			newRGB.g = arr[1];
			newRGB.b = arr[2];
		}
		return globalRgbShaders;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		defaultRGB();
	}
}