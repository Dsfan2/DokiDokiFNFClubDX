package options;

#if desktop
//import Discord.DiscordClient;
#end
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

class VisualsUISubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Visuals and UI';

		var option:Option = new Option('Note Splashes',
			"If unchecked, hitting \"Sick!\" notes won't show particles.",
			'noteSplashes',
			'bool',
			true);
		option.xPos = 420;
		option.yPos = 120;
		addOption(option);

		var option:Option = new Option('Flashing Lights',
			"Uncheck this if you're sensitive to flashing lights!",
			'flashing',
			'bool',
			true);
		option.xPos = 420;
		option.yPos = 170;
		addOption(option);

		var option:Option = new Option('Camera Zooms',
			"If unchecked, the camera won't zoom in on a beat hit.",
			'camZooms',
			'bool',
			true);
		option.xPos = 420;
		option.yPos = 220;
		addOption(option);

		var option:Option = new Option('Score Text Zoom on Hit',
			"If unchecked, disables the Score text zooming\neverytime you hit a note.",
			'scoreZoom',
			'bool',
			true);
		option.xPos = 800;
		option.yPos = 120;
		addOption(option);

		var option:Option = new Option('Song Blurb At Start',
			"If checked, displays a blurb when a song begins.",
			'songBlurb',
			'bool',
			true);
		option.xPos = 800;
		option.yPos = 170;
		addOption(option);
		
		#if !mobile
		var option:Option = new Option('FPS Counter',
			'If unchecked, hides FPS Counter.',
			'showFPS',
			'bool',
			true);
		option.xPos = 800;
		option.yPos = 220;
		addOption(option);
		option.onChange = onChangeFPSCounter;
		#end

		var option:Option = new Option('Time Bar:',
			"What should the Time Bar display? (Does not apply to the Doki Doki Remixes)",
			'timeBarType',
			'string',
			'Time Left',
			['Time Left', 'Time Elapsed', 'Song Name', 'Disabled']);
		option.xPos = 420;
		option.yPos = 300;
		addOption(option);

		/*var option:Option = new Option('DOKI Time Bar:',
			"What should the Time Bar display for DOKI DOKI Remixes?",
			'dokiTimeBarType',
			'string',
			'Time Left',
			['Song Name (Time Elapsed / Song Duration)', '(Time Elapsed) Song Name (Time Remaining)', 'Time Elapsed / Song Duration / Time Remaining', 'Disabled']);
		option.xPos = 600;
		option.yPos = 300;
		addOption(option);*/

		var option:Option = new Option('Custom Cursor:',
			"Which custom cursor sprite do you prefer?",
			'customCursor',
			'string',
			'DDLC+',
			['DDLC+', 'Super Mario Maker 2', 'FNF', 'None']);
		option.xPos = 420;
		option.yPos = 400;
		addOption(option);
		option.onChange = reloadCursor;

		super();
	}

	override function destroy()
	{
		super.destroy();
	}

	#if !mobile
	function onChangeFPSCounter()
	{
		if(Main.fpsVar != null)
			Main.fpsVar.visible = ClientPrefs.showFPS;
	}
	#end

	function reloadCursor(){
		var sprite:FlxSprite = new FlxSprite();
		FlxG.mouse.visible = true;
		switch (ClientPrefs.customCursor){
			case 'DDLC+':
				FlxG.mouse.useSystemCursor = false;
				sprite.loadGraphic(Paths.image('cursor-DDLC'));
				FlxG.mouse.load(sprite.pixels);
			case 'Super Mario Maker 2':
				FlxG.mouse.useSystemCursor = false;
				sprite.loadGraphic(Paths.image('cursor-SMM2'));
				FlxG.mouse.load(sprite.pixels);
			case 'FNF':
				FlxG.mouse.useSystemCursor = false;
				sprite.loadGraphic(Paths.image('cursor-FNF'));
				FlxG.mouse.load(sprite.pixels);
			case 'None':
				FlxG.mouse.useSystemCursor = true;
		}
	}
}