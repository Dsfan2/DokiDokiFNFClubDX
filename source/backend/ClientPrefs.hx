package backend;

class ClientPrefs {
	public static var downScroll:Bool = false;
	public static var middleScroll:Bool = false;
	public static var showFPS:Bool = false;
	public static var flashing:Bool = true;
	public static var globalAntialiasing:Bool = true;
	public static var noteSplashes:Bool = true;
	public static var lowQuality:Bool = false;
	public static var framerate:Int = 120;
	public static var camZooms:Bool = true;
	public static var noteOffset:Int = 0;
	public static var arrowRGB:Array<Array<FlxColor>> = [
		[0xFFD18AFA, 0xFF714989, 0xFF412BB0],
		[0xFFBBF5FF, 0xFF719197, 0xFF412BB0],
		[0xFF8DFFA4, 0xFF538F5F, 0xFF412BB0],
		[0xFFFFBAE3, 0xFF8C657C, 0xFF412BB0]];
	public static var arrowRGBX:Array<Array<FlxColor>> = [
		[0xFFBD52FB, 0xFFFFFFFF, 0xFF8F05DE],
		[0xFF8EE6F5, 0xFFFFFFFF, 0xFF084D59],
		[0xFF7DFF98, 0xFFFFFFFF, 0xFF00941E],
		[0xFFFF97D5, 0xFFFFFFFF, 0xFFFF84CD]];
	public static var imagesPersist:Bool = false;
	public static var ghostTapping:Bool = true;
	public static var timeBarType:String = 'Time Left';
	public static var dokiTimeBarType:String = 'Song Name (Time Elapsed / Song Duration)';
	public static var scoreZoom:Bool = true;
	public static var noReset:Bool = false;
	public static var shaders:Bool = true;
	public static var hitsoundVolume:Float = 0;
	public static var misssoundVolume:Float = 0;
	public static var playerChar:Int = 1;
	public static var songBlurb:Bool = true;
	public static var freeplayCutscenes:Bool = false;
	public static var resultsScreen:Bool = true;
	public static var customCursor:String = 'DDLC+';
	public static var gameplaySettings:Map<String, Dynamic> = [
		'scrollspeed' => 1.0,
		'scrolltype' => 'multiplicative', 
		// anyone reading this, amod is multiplicative speed mod, cmod is constant speed mod, and xmod is bpm based speed mod.
		// an amod example would be chartSpeed * multiplier
		// cmod would just be constantSpeed = chartSpeed
		// and xmod basically works by basing the speed on the bpm.
		// iirc (beatsPerSecond * (conductorToNoteDifference / 1000)) * noteSize (110 or something like that depending on it, prolly just use note.height)
		// bps is calculated by bpm / 60
		// oh yeah and you'd have to actually convert the difference to seconds which I already do, because this is based on beats and stuff. but it should work
		// just fine. but I wont implement it because I don't know how you handle sustains and other stuff like that.
		// oh yeah when you calculate the bps divide it by the songSpeed or rate because it wont scroll correctly when speeds exist.
		'songspeed' => 1.0,
		'healthgain' => 1.0,
		'healthloss' => 1.0,
		'instakill' => false,
		'hurtkills' => false,
		'practice' => false,
		'botplay' => false,
		'healthdrain' => false,
		'opponentplay' => false
	];

	public static var comboOffset:Array<Int> = [0, 0, 0, 0];
	public static var ratingOffset:Int = 0;
	public static var sickWindow:Int = 45;
	public static var goodWindow:Int = 90;
	public static var badWindow:Int = 135;
	public static var safeFrames:Float = 10;

	//Every key has two binds, add your key bind down here and then add your control on options/ControlsSubState.hx and Controls.hx
	public static var keyBinds:Map<String, Array<FlxKey>> = [
		//Key Bind, Name for ControlsSubState
		'note_left'		=> [D, LEFT],
		'note_down'		=> [F, DOWN],
		'note_up'		=> [J, UP],
		'note_right'	=> [K, RIGHT],
		'dodge'			=> [SPACE, NONE],
		
		'ui_left'		=> [A, LEFT],
		'ui_down'		=> [S, DOWN],
		'ui_up'			=> [W, UP],
		'ui_right'		=> [D, RIGHT],
		
		'accept'		=> [ENTER, SPACE],
		'back'			=> [ESCAPE, NONE],
		'pause'			=> [ENTER, ESCAPE],
		'reset'			=> [BACKSPACE, NONE],
		
		'volume_mute'	=> [ZERO, NONE],
		'volume_up'		=> [NUMPADPLUS, PLUS],
		'volume_down'	=> [NUMPADMINUS, MINUS],
		
		'debug_1'		=> [SEVEN, NONE],
		'debug_2'		=> [EIGHT, NONE]
	];
	public static var defaultKeys:Map<String, Array<FlxKey>> = null;
	public static var defaultRGB:Array<Array<FlxColor>> = [
		[0xFFD18AFA, 0xFF714989, 0xFF412BB0],
		[0xFFBBF5FF, 0xFF719197, 0xFF412BB0],
		[0xFF8DFFA4, 0xFF538F5F, 0xFF412BB0],
		[0xFFFFBAE3, 0xFF8C657C, 0xFF412BB0]];
	public static var defaultRGBX:Array<Array<FlxColor>> = [
		[0xFFBD52FB, 0xFFFFFFFF, 0xFF8F05DE],
		[0xFF8EE6F5, 0xFFFFFFFF, 0xFF084D59],
		[0xFF7DFF98, 0xFFFFFFFF, 0xFF00941E],
		[0xFFFF97D5, 0xFFFFFFFF, 0xFFFF84CD]];

	public static var yourVoice:String = null;

	public static function loadDefaultKeys() {
		defaultKeys = keyBinds.copy();
	}

	public static function saveSettings() {
		FlxG.save.data.downScroll = downScroll;
		FlxG.save.data.middleScroll = middleScroll;
		FlxG.save.data.showFPS = showFPS;
		FlxG.save.data.flashing = flashing;
		FlxG.save.data.globalAntialiasing = globalAntialiasing;
		FlxG.save.data.noteSplashes = noteSplashes;
		FlxG.save.data.lowQuality = lowQuality;
		FlxG.save.data.framerate = framerate;
		FlxG.save.data.camZooms = camZooms;
		FlxG.save.data.noteOffset = noteOffset;
		FlxG.save.data.arrowRGB = arrowRGB;
		FlxG.save.data.arrowRGBX = arrowRGBX;
		FlxG.save.data.imagesPersist = imagesPersist;
		FlxG.save.data.ghostTapping = ghostTapping;
		FlxG.save.data.timeBarType = timeBarType;
		FlxG.save.data.dokiTimeBarType = dokiTimeBarType;
		FlxG.save.data.scoreZoom = scoreZoom;
		FlxG.save.data.noReset = noReset;
		FlxG.save.data.comboOffset = comboOffset;
		Achievements.save();

		FlxG.save.data.ratingOffset = ratingOffset;
		FlxG.save.data.sickWindow = sickWindow;
		FlxG.save.data.goodWindow = goodWindow;
		FlxG.save.data.badWindow = badWindow;
		FlxG.save.data.safeFrames = safeFrames;
		FlxG.save.data.gameplaySettings = gameplaySettings;
		FlxG.save.data.shaders = shaders;
		FlxG.save.data.hitsoundVolume = hitsoundVolume;
		FlxG.save.data.misssoundVolume = misssoundVolume;
		FlxG.save.data.songBlurb = songBlurb;
		FlxG.save.data.freeplayCutscenes = freeplayCutscenes;
		FlxG.save.data.resultsScreen = resultsScreen;
		FlxG.save.data.customCursor = customCursor;

		FlxG.save.data.playerChar = playerChar;
		FlxG.save.data.yourVoice = yourVoice;
	
		FlxG.save.flush();

		var save:FlxSave = new FlxSave(); 
		save.bind('ddfnfcdx_controls', 'TeamDS/DDFNFCDX-V4');//Placing this in a separate save so that it can be manually deleted without removing your Score and stuff
		save.data.customControls = keyBinds;
		save.flush();
		FlxG.log.add("Settings saved!");
	}

	public static function saveCharacter()
	{
		FlxG.save.data.playerChar = playerChar;
		FlxG.save.flush();
	}

	public static function loadPrefs() {
		if(FlxG.save.data.downScroll != null) downScroll = FlxG.save.data.downScroll;
		if(FlxG.save.data.middleScroll != null) middleScroll = FlxG.save.data.middleScroll;
		if(FlxG.save.data.showFPS != null) {
			showFPS = FlxG.save.data.showFPS;
			if(Main.fpsVar != null) {
				Main.fpsVar.visible = showFPS;
			}
		}
		if(FlxG.save.data.flashing != null) flashing = FlxG.save.data.flashing;
		if(FlxG.save.data.globalAntialiasing != null) globalAntialiasing = FlxG.save.data.globalAntialiasing;
		if(FlxG.save.data.noteSplashes != null) noteSplashes = FlxG.save.data.noteSplashes;
		if(FlxG.save.data.lowQuality != null) lowQuality = FlxG.save.data.lowQuality;
		if(FlxG.save.data.playerChar != null) playerChar = FlxG.save.data.playerChar;
		if(FlxG.save.data.framerate != null) {
			framerate = FlxG.save.data.framerate;
			if(framerate > FlxG.drawFramerate) {
				FlxG.updateFramerate = framerate;
				FlxG.drawFramerate = framerate;
			} else {
				FlxG.drawFramerate = framerate;
				FlxG.updateFramerate = framerate;
			}
		}
		if(FlxG.save.data.camZooms != null) camZooms = FlxG.save.data.camZooms;
		if(FlxG.save.data.noteOffset != null) noteOffset = FlxG.save.data.noteOffset;
		if(FlxG.save.data.arrowRGB != null) arrowRGB = FlxG.save.data.arrowRGB;
		if(FlxG.save.data.arrowRGBX != null) arrowRGBX = FlxG.save.data.arrowRGBX;
		if(FlxG.save.data.ghostTapping != null) ghostTapping = FlxG.save.data.ghostTapping;
		if(FlxG.save.data.timeBarType != null) timeBarType = FlxG.save.data.timeBarType;
		if(FlxG.save.data.dokiTimeBarType != null) dokiTimeBarType = FlxG.save.data.dokiTimeBarType;
		if(FlxG.save.data.scoreZoom != null) scoreZoom = FlxG.save.data.scoreZoom;
		if(FlxG.save.data.noReset != null) noReset = FlxG.save.data.noReset;
		if(FlxG.save.data.comboOffset != null) comboOffset = FlxG.save.data.comboOffset;
		
		if(FlxG.save.data.ratingOffset != null) ratingOffset = FlxG.save.data.ratingOffset;
		if(FlxG.save.data.sickWindow != null) sickWindow = FlxG.save.data.sickWindow;
		if(FlxG.save.data.goodWindow != null) goodWindow = FlxG.save.data.goodWindow;
		if(FlxG.save.data.badWindow != null) badWindow = FlxG.save.data.badWindow;
		if(FlxG.save.data.safeFrames != null) safeFrames = FlxG.save.data.safeFrames;
		if(FlxG.save.data.shaders != null) shaders = FlxG.save.data.shaders;
		if(FlxG.save.data.hitsoundVolume != null) hitsoundVolume = FlxG.save.data.hitsoundVolume;
		if(FlxG.save.data.misssoundVolume != null) misssoundVolume = FlxG.save.data.misssoundVolume;
		if(FlxG.save.data.songBlurb != null) songBlurb = FlxG.save.data.songBlurb;
		if(FlxG.save.data.freeplayCutscenes != null) freeplayCutscenes = FlxG.save.data.freeplayCutscenes;
		if(FlxG.save.data.resultsScreen != null) resultsScreen = FlxG.save.data.resultsScreen;
		if(FlxG.save.data.customCursor != null) customCursor = FlxG.save.data.customCursor;
		if(FlxG.save.data.yourVoice != null) yourVoice = FlxG.save.data.yourVoice;
		if(FlxG.save.data.gameplaySettings != null)
		{
			var savedMap:Map<String, Dynamic> = FlxG.save.data.gameplaySettings;
			for (name => value in savedMap)
			{
				gameplaySettings.set(name, value);
			}
		}
		
		// flixel automatically saves your volume!
		if(FlxG.save.data.volume != null) FlxG.sound.volume = FlxG.save.data.volume;
		if (FlxG.save.data.mute != null) FlxG.sound.muted = FlxG.save.data.mute;

		Achievements.load();

		var save:FlxSave = new FlxSave();
		save.bind('ddfnfcdx_controls', 'TeamDS/DDFNFCDX-V4');
		if(save != null && save.data.customControls != null) {
			var loadedControls:Map<String, Array<FlxKey>> = save.data.customControls;
			for (control => keys in loadedControls) {
				keyBinds.set(control, keys);
			}
			reloadControls();
		}
	}

	inline public static function getGameplaySetting(name:String, defaultValue:Dynamic):Dynamic {
		return (gameplaySettings.exists(name) ? gameplaySettings.get(name) : defaultValue);
	}

	public static function reloadControls() {
		PlayerSettings.player1.controls.setKeyboardScheme(KeyboardScheme.Solo);

		TitleState.muteKeys = copyKey(keyBinds.get('volume_mute'));
		TitleState.volumeDownKeys = copyKey(keyBinds.get('volume_down'));
		TitleState.volumeUpKeys = copyKey(keyBinds.get('volume_up'));
		FlxG.sound.muteKeys = TitleState.muteKeys;
		FlxG.sound.volumeDownKeys = TitleState.volumeDownKeys;
		FlxG.sound.volumeUpKeys = TitleState.volumeUpKeys;
	}
	public static function copyKey(arrayToCopy:Array<FlxKey>):Array<FlxKey> {
		var copiedArray:Array<FlxKey> = arrayToCopy.copy();
		var i:Int = 0;
		var len:Int = copiedArray.length;

		while (i < len) {
			if(copiedArray[i] == NONE) {
				copiedArray.remove(NONE);
				--i;
			}
			i++;
			len = copiedArray.length;
		}
		return copiedArray;
	}
}