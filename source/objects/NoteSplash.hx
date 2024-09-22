package objects;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxColor;
import flixel.system.FlxAssets.FlxShader;
import flixel.graphics.frames.FlxFrame;

class NoteSplash extends FlxSprite
{
	public var rgbShader:PixelSplashShaderRef;
	private var idleAnim:String;
	private var textureLoaded:String = null;

	public function new(x:Float = 0, y:Float = 0, ?note:Int = 0) {
		super(x, y);

		var skin:String = 'noteSplashes/' + PlayState.instance.splashTexture;
		if(PlayState.SONG.splashSkin != null && PlayState.SONG.splashSkin.length > 0) skin = 'noteSplashes/' +  PlayState.SONG.splashSkin;

		loadAnims(skin);

		rgbShader = new PixelSplashShaderRef();
		shader = rgbShader.shader;

		setupNoteSplash(x, y, note);
		if (!PlayState.isPixelStage)
			antialiasing = ClientPrefs.globalAntialiasing;
		else
			antialiasing = false;
	}

	public function setupNoteSplash(x:Float, y:Float, direction:Int = 0, ?note:Note = null, texture:String = null) {
		setPosition(x - Note.swagWidth * 0.95, y - Note.swagWidth);
		alpha = 1;

		if(texture == null) 
		{
			if (CoolUtil.difficultyString() == 'DOKI DOKI')
				texture = "noteSplashes/X-Splash";
			else
				texture = 'noteSplashes/Regular';

			if(PlayState.SONG.splashSkin != null && PlayState.SONG.splashSkin.length > 0) texture = PlayState.SONG.splashSkin;
		}

		if (!PlayState.isPixelStage)
			antialiasing = ClientPrefs.globalAntialiasing;
		else
			antialiasing = false;

		if(textureLoaded != texture) {
			loadAnims(texture);
		}
		
		var tempShader:RGBPalette = null;
		if(note != null && !note.noteSplashData.useGlobalShader)
		{				
			if(note.noteSplashData.r != -1) note.rgbShader.r = note.noteSplashData.r;
			if(note.noteSplashData.g != -1) note.rgbShader.g = note.noteSplashData.g;
			if(note.noteSplashData.b != -1) note.rgbShader.b = note.noteSplashData.b;
			tempShader = note.rgbShader.parent;
		}
		else tempShader = Note.globalRgbShaders[direction];
		rgbShader.copyValues(tempShader);

		offset.set(-35, -35);

		var animNum:Int = FlxG.random.int(1, 2);
		animation.play('note' + direction + '-' + animNum, true);
		if(animation.curAnim != null)
			animation.curAnim.frameRate = 24 + FlxG.random.int(-2, 2);
	}

	function loadAnims(skin:String) {
		frames = Paths.getSparrowAtlas(skin);
		for (i in 1...3) {
			animation.addByPrefix("note1-" + i, "note splash anim", 24, false);
			animation.addByPrefix("note2-" + i, "note splash anim", 24, false);
			animation.addByPrefix("note0-" + i, "note splash anim", 24, false);
			animation.addByPrefix("note3-" + i, "note splash anim", 24, false);
		}
	}

	override function update(elapsed:Float) {
		if(animation.curAnim != null)if(animation.curAnim.finished) kill();

		super.update(elapsed);
	}
}

class PixelSplashShaderRef {
	public var shader:PixelSplashShader = new PixelSplashShader();

	public function copyValues(tempShader:RGBPalette)
	{
		var enabled:Bool = false;
		if(tempShader != null)
			enabled = true;

		if(enabled)
		{
			for (i in 0...3)
			{
				shader.r.value[i] = tempShader.shader.r.value[i];
				shader.g.value[i] = tempShader.shader.g.value[i];
				shader.b.value[i] = tempShader.shader.b.value[i];
			}
			shader.mult.value[0] = tempShader.shader.mult.value[0];
		}
		else shader.mult.value[0] = 0.0;
	}

	public function new()
	{
		shader.r.value = [0, 0, 0];
		shader.g.value = [0, 0, 0];
		shader.b.value = [0, 0, 0];
		shader.mult.value = [1];

		var pixel:Float = 1;
		if(PlayState.isPixelStage) pixel = PlayState.daPixelZoom;
		shader.uBlocksize.value = [pixel, pixel];
	}
}

class PixelSplashShader extends FlxShader
{
	@:glFragmentHeader('
		#pragma header
		
		uniform vec3 r;
		uniform vec3 g;
		uniform vec3 b;
		uniform float mult;
		uniform vec2 uBlocksize;

		vec4 flixel_texture2DCustom(sampler2D bitmap, vec2 coord) {
			vec2 blocks = openfl_TextureSize / uBlocksize;
			vec4 color = flixel_texture2D(bitmap, floor(coord * blocks) / blocks);
			if (!hasTransform) {
				return color;
			}

			if(color.a == 0.0 || mult == 0.0) {
				return color * openfl_Alphav;
			}

			vec4 newColor = color;
			newColor.rgb = min(color.r * r + color.g * g + color.b * b, vec3(1.0));
			newColor.a = color.a;
			
			color = mix(color, newColor, mult);
			
			if(color.a > 0.0) {
				return vec4(color.rgb, color.a);
			}
			return vec4(0.0, 0.0, 0.0, 0.0);
		}')

	@:glFragmentSource('
		#pragma header

		void main() {
			gl_FragColor = flixel_texture2DCustom(bitmap, openfl_TextureCoordv);
		}')

	public function new()
	{
		super();
	}
}