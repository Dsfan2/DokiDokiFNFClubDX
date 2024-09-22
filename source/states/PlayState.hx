package states;

import flixel.graphics.FlxGraphic;
#if desktop
import backend.Discord.DiscordClient;
#end
import backend.Section.SwagSection;
import backend.Song.SwagSong;
import shaders.WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.Lib;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.BitmapFilter;
import openfl.utils.Assets as OpenFlAssets;
import states.editors.ChartingState;
import states.editors.CharacterEditorState;
import flixel.group.FlxSpriteGroup;
import flixel.input.keyboard.FlxKey;
import objects.Note.EventNote;
import openfl.events.KeyboardEvent;
import flixel.util.FlxSave;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import flixel.addons.display.FlxRuntimeShader;
import flixel.addons.effects.chainable.FlxGlitchEffect;
import flixel.addons.effects.chainable.FlxEffectSprite;
#if sys
import sys.FileSystem;
import sys.io.File;
#end
import hxcodec.VideoSprite;

class PlayState extends MusicBeatState
{
	public static var STRUM_X = 42;
	public static var STRUM_X_MIDDLESCROLL = -278;

	public static var ratingStuff:Array<Dynamic> = [
		['L', 0.6], //From 0% to 59%
		['H', 0.65], //From 60% to 64%
		['G', 0.7], //From 65% to 69%
		['F', 0.75], //From 70% to 74%
		['E', 0.8], //From 75% to 79%
		['D', 0.84], //From 80% to 83%
		['C', 0.87], //From 84% to 86%
		['B', 0.9], //From 87% to 89%
		['A', 0.95], //From 90% to 94%
		['S', 0.98], //From 95% to 97%
		['S+', 1], //From 98% to 99%
		['P', 1] //The value on this one isn't used actually, since Perfect is always "1"
	];
	public var composerName:String = "";

	var achievesList:Array<String> = ['first_clear', 'dokidoki_nomiss', 'bfRoute_clear', 'jrRoute_clear', 'moniRoute_clear', 'S_nomiss',
	'N_nomiss', 'Y_nomiss', 'M_nomiss', 'Sx_nomiss', 'G_nomiss', 'Yd_nomiss', 'JM_nomiss', 'ld_nomiss', 'se_combo', 'sf_doklear', 
	'sf_double', 'normal_clear', 'heartz_clear', 'glitcher_clear', 'tfb_clear', 'classic_clear', 'supernatural_nomiss', 'spiders_combo', 
	'mk_win', 'showoff_clear', 'crossover_clear', 'festival_clear', 'bonus_clear', 'goodbye_fnf', 'all_clear', 
	'secret_clear', 'nice_clear', 'epiphany_clear', 'rematch_clear', 'dokiverse_clear'];

	//event variables
	private var isCameraOnForcedPos:Bool = false;
	#if (haxe >= "4.0.0")
	public var boyfriendMap:Map<String, Character> = new Map();
	public var dadMap:Map<String, Character> = new Map();
	public var gfMap:Map<String, Character> = new Map();
	public var boyfriend2Map:Map<String, Character> = new Map();
	public var dad2Map:Map<String, Character> = new Map();
	public var boyfriend3Map:Map<String, Character> = new Map();
	public var dad3Map:Map<String, Character> = new Map();
	public var boyfriend4Map:Map<String, Character> = new Map();
	public var dad4Map:Map<String, Character> = new Map();
	#else
	public var boyfriendMap:Map<String, Character> = new Map<String, Character>();
	public var dadMap:Map<String, Character> = new Map<String, Character>();
	public var gfMap:Map<String, Character> = new Map<String, Character>();
	public var boyfriend2Map:Map<String, Character> = new Map<String, Character>();
	public var dad2Map:Map<String, Character> = new Map<String, Character>();
	public var boyfriend3Map:Map<String, Character> = new Map<String, Character>();
	public var dad3Map:Map<String, Character> = new Map<String, Character>();
	public var boyfriend4Map:Map<String, Character> = new Map<String, Character>();
	public var dad4Map:Map<String, Character> = new Map<String, Character>();
	#end

	public static var songsPlayed:Map<String, Bool> = new Map<String, Bool>();

	var currentStage = null;
	public var stageGroup:FlxGroup;

	var hasBackChars:Bool = false;
	public var songName:String;

	public var BF_X:Float = 770;
	public var BF_Y:Float = 100;
	public var DAD_X:Float = 100;
	public var DAD_Y:Float = 100;
	public var GF_X:Float = 400;
	public var GF_Y:Float = 130;
	public var EX_X:Float = 0;
	public var EX_Y:Float = 0;

	public var songSpeedTween:FlxTween;
	public var songSpeed(default, set):Float = 1;
	public var songSpeedType:String = "multiplicative";
	public var noteKillOffset:Float = 350;
	
	public var boyfriendGroup:FlxSpriteGroup;
	public var dadGroup:FlxSpriteGroup;
	public var gfGroup:FlxSpriteGroup;
	public var exGroup:FlxSpriteGroup;

	public static var curStage:String = '';
	public static var isPixelStage:Bool = false;
	public static var SONG:SwagSong = null;
	public static var isStoryMode:Bool = false;
	public static var storyFreeplay:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;

	public var vocals:FlxSound;
	public var playervox:FlxSound;

	public var dad:Character = null;
	public var gf:Character = null;
	public var boyfriend:Character = null;

	public var dad2:Character = null;
	public var dad3:Character = null;
	public var dad4:Character = null;

	public var boyfriend2:Character = null;
	public var boyfriend3:Character = null;
	public var boyfriend4:Character = null;

	public var notes:FlxTypedGroup<Note>;
	public var unspawnNotes:Array<Note> = [];
	public var eventNotes:Array<EventNote> = [];

	private var strumLine:FlxSprite;
	public var notesPressed:Int = 0;

	//Handles the new epic mega sexy cam code that i've done
	private var camFollow:FlxPoint;
	private var camFollowPos:FlxObject;
	private static var prevCamFollow:FlxPoint;
	private static var prevCamFollowPos:FlxObject;

	public var strumLineNotes:FlxTypedGroup<StrumNote>;
	public var opponentStrums:FlxTypedGroup<StrumNote>;
	public var playerStrums:FlxTypedGroup<StrumNote>;
	public var grpNoteSplashes:FlxTypedGroup<NoteSplash>;

	public var camZooming:Bool = false;
	private var curSong:String = "";

	public var gfSpeed:Int = 1;
	public var health:Float = 1;
	public var healthPercent:Int = 0;
	public var combo:Int = 0;
	public static var highestCombo:Int = 0;

	private var healthBar:HealthBar;

	var songPercent:Float = 0;

	private var timeBarBG:AttachedSprite;
	public var timeBar:FlxBar;
	
	public static var sicks:Int = 0;
	public static var goods:Int = 0;
	public static var bads:Int = 0;
	public static var trashs:Int = 0;
	
	private var generatedMusic:Bool = false;
	public var endingSong:Bool = false;
	public var startingSong:Bool = false;
	private var updateTime:Bool = true;
	public static var changedDifficulty:Bool = false;
	public static var chartingMode:Bool = false;

	var outroBlack:FlxSprite;
	var ppMusic:Bool = false;

	//Gameplay settings
	public var healthGain:Float = 1;
	public var healthLoss:Float = 1;
	public var instakillOnMiss:Bool = false;
	public var cpuControlled:Bool = false;
	public var practiceMode:Bool = false;
	public var instaKillNotes:Bool = true;
	public var forceHealthDrain:Bool = false;

	public var botplaySine:Float = 0;
	public var practiceSine:Float = 0;
	public var botplaySpr:FlxSprite;
	public var practiceSpr:FlxSprite;

	public var camHUD:FlxCamera;
	public var camGame:FlxCamera;
	public var camOther:FlxCamera;
	public var camDialogue:FlxCamera;

	public var cameraSpeed:Float = 1;

	public var bfDodging:Bool = false;
	public var dodginTime:Bool = false;
	public static var bfCanDodge:Bool = false;
	public var bfDodgeCooldown:Float = 0.1125; //0.1125 for single dodge events (most forgiving), reduce it if you want double dodge events
	public var bfDodgeTiming:Float = 0.425; //0.425 for single dodge events (most forgiving), reduce it if you want double dodge events
	public var dodgeCount:Int = 0;
	public var warningSign:FlxSprite;

	public static var songType:String = "";
	public static var crashType:String = "";

	var hasDialogue:Bool = false;

	var dialogue:Array<String> = [];
	var extra:Array<String> = [];

	var introDialogue:String = '';
	var endDialogue:String = '';

	var camZoomBeat:Bool = false;
	var camBounce:Bool = false;

	var heyTimer:Float;

	public var songScore:Int = 0;
	public var songHits:Int = 0;
	public var songMisses:Int = 0;
	public var scoreTxt:FlxText;
	var missTxt:FlxText;
	var timeTxt:FlxText;
	var scoreTxtTween:FlxTween;

	var whiteFade:FlxSprite;
	var yandereMode:Bool = false;
	var tvStatic:FlxSprite;
	var funnyComment:FlxSprite;

	var monikaScreenA:FlxSprite;
	var monikaScreenB:FlxSprite;
	var monikaScreenC:FlxSprite;
	private var blueScreen:FlxSprite;
	var black:FlxSprite;
	var blackFade:FlxSprite;
	private var frontMonika:FlxSprite;
	private var endScreen:FlxSprite;

	var vingetteThing:FlxSprite;

	//public static var storyWeekName:String = '';
	public static var campaignScore:Int = 0;
	public static var campaignMisses:Int = 0;
	public static var campaignNotes:Int = 0;
	public static var campaignHits:Float = 0.0;
	public static var campaignAccuracy:Float = 0.0;
	public static var campaignSicks:Int = 0;
	public static var campaignGoods:Int = 0;
	public static var campaignBads:Int = 0;
	public static var campaignTrashes:Int = 0;

	public static var seenCutscene:Bool = false;
	public static var deathCounter:Int = 0;

	public var defaultCamZoom:Float = 1.05;

	// how big to stretch the pixel art assets
	public static var daPixelZoom:Float = 6;
	private var singAnimations:Array<String> = ['singLEFT', 'singDOWN', 'singUP', 'singRIGHT'];

	public var inCutscene:Bool = false;
	public var skipCountdown:Bool = false;
	public var noCountdown:Bool = false;
	var songLength:Float = 0;

	public var boyfriendCameraOffset:Array<Float> = null;
	public var opponentCameraOffset:Array<Float> = null;
	public var girlfriendCameraOffset:Array<Float> = null;

	#if desktop
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	public var lyricText:FlxText;

	//Achievement trash
	var keysPressed:Array<Bool> = [];
	var boyfriendIdleTime:Float = 0.0;
	var boyfriendIdled:Bool = false;

	public static var instance:PlayState;
	public var introSoundsSuffix:String = '';

	// Debug buttons
	private var debugKeysChart:Array<FlxKey>;
	private var debugKeysCharacter:Array<FlxKey>;
	
	// Less laggy controls
	private var keysArray:Array<Dynamic>;

	var doof:DialogueBoxRegular;
	var doof2:DialogueBoxRegular;
	var isAct3:Bool = false;
	var seenEndDialogue:Bool = false;
	var resultsShow:Bool = false;

	public var unlockNextWeek:Bool = true;
	public var pixeltrashPart1:String = "defaultUI/";
	public var pixeltrashPart2:String = '';

	public var skipSongBlurb:Bool = false;
	public var opponentNoteVisible:Bool = true;
	public var forceMiddlescroll:Bool = false;

	public static var isMiddleScroll:Bool = false;

	public var noteTexture:String = 'Regular';
	public var splashTexture:String = 'Regular';

	private var floatTrash:Float = 0;
	var stageData:StageFile;

	var staticlol:StaticShader;
	private var staticAlpha:Float = 0;
	var shaderEffect:FlxSprite;
	var shader0:FlxRuntimeShader;

	var gfStillVisible:Bool = false;

	var defaultPlayerStrumX1:Float;
	var defaultPlayerStrumX2:Float;
	var defaultPlayerStrumX3:Float;
	var defaultPlayerStrumX4:Float;

	var defaultOpponentStrumX1:Float;
	var defaultOpponentStrumX2:Float;
	var defaultOpponentStrumX3:Float;
	var defaultOpponentStrumX4:Float;

	var defaultPlayerStrumY1:Float;
	var defaultPlayerStrumY2:Float;
	var defaultPlayerStrumY3:Float;
	var defaultPlayerStrumY4:Float;

	var defaultOpponentStrumY1:Float;
	var defaultOpponentStrumY2:Float;
	var defaultOpponentStrumY3:Float;
	var defaultOpponentStrumY4:Float;

	public var bfFloating:Bool = false;
	public var dadFloating:Bool = false;
	public var healthDrain:Bool = false;

	public var nonexistantGF:Bool = true;
	public static var isDokiDoki:Bool = false;

	var songBlurbStuff:CoolSongBlurb = null;

	public var precacheList:Map<String, String> = new Map<String, String>();
	var phillyLightsColors:Array<FlxColor> = [0xFF31A2FD, 0xFF31FD8C, 0xFFFB33F5, 0xFFFD4531, 0xFFFBA633];

	var interlopeAngle:Bool = false;
	var interlopeTweenThing:Bool = false;
	var interlopeNoteSwap:Bool = false;
	var downOnUp:Bool = false;

	public static var dadChar:String = '';
	public static var bfChar:String = '';
	public static var gfChar:String = '';

	public var curGlowColor:FlxColor = 0xFFFFFFFF;

	override public function create()
	{
		isDokiDoki = CoolUtil.difficultyString() == 'DOKI DOKI';
		bfCanDodge = false;
		highestCombo = 0;
		Paths.clearStoredMemory();

		instance = this;

		debugKeysChart = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));
		debugKeysCharacter = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_2'));
		PauseSubState.songName = null; //Reset to default

		keysArray = [
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_left')),
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_down')),
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_up')),
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_right'))
		];

		// For the "Just the Two of Us" achievement
		for (i in 0...keysArray.length)
		{
			keysPressed.push(false);
		}

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		// Gameplay settings
		if (isStoryMode)
		{
			healthGain = 1;
			healthLoss = 1;
			instakillOnMiss = false;
			practiceMode = false;
			cpuControlled = false;
			instaKillNotes = false;
			forceHealthDrain = false;
		}
		else
		{
			healthGain = ClientPrefs.getGameplaySetting('healthgain', 1);
			healthLoss = ClientPrefs.getGameplaySetting('healthloss', 1);
			instakillOnMiss = ClientPrefs.getGameplaySetting('instakill', false);
			practiceMode = ClientPrefs.getGameplaySetting('practice', false);
			cpuControlled = ClientPrefs.getGameplaySetting('botplay', false);
			instaKillNotes = ClientPrefs.getGameplaySetting('hurtkills', true);
			forceHealthDrain = ClientPrefs.getGameplaySetting('healthdrain', true);
		}

		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camOther = new FlxCamera();
		camDialogue = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		camOther.bgColor.alpha = 0;
		camDialogue.bgColor.alpha = 0;

		camGame.filtersEnabled = false;
		camHUD.filtersEnabled = false;

		//Kinda cruddy but it works
		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD, false);
		FlxG.cameras.add(camOther, false);
		FlxG.cameras.add(camDialogue, false);

		grpNoteSplashes = new FlxTypedGroup<NoteSplash>();

		FlxCamera.defaultCameras = [camGame];
		//CustomFadeTransition.nextCamera = camOther;
		//FlxG.cameras.setDefaultDrawTarget(camGame, true);

		persistentUpdate = true;
		persistentDraw = true;

		sicks = 0;
		goods = 0;
		bads = 0;
		trashs = 0;

		//blurbData = cast Json.parse(Paths.json('charts/${Paths.formatToSongPath(SONG.song)}/songBlurb'));

		if (isStoryMode && WeekData.weekID == "Final MONI" && !SaveData.monikaRouteClear)
		{
			if (SaveData.bfRouteClear && !SaveData.jrRouteClear)
				SaveData.otherRoutesTxt = "BF";
			if (SaveData.jrRouteClear && !SaveData.bfRouteClear)
				SaveData.otherRoutesTxt = "JR";
			if (SaveData.bfRouteClear && SaveData.jrRouteClear)
				SaveData.otherRoutesTxt = "Others";
			if (!SaveData.bfRouteClear && !SaveData.jrRouteClear)
				SaveData.otherRoutesTxt = "None";
			SaveData.saveSwagData();
		}

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		switch (SONG.song.toLowerCase())
		{
			case 'candy hearts' | 'lavender mist' | 'strawberry peppermint' | 'candy heartz' | 
			'my song your note' | 'play with me' | 'poem panic' | 'just monika' | 'doki forever'| 'dark star'|
			"you can't run" | 'ultimate glitcher' | 'fresh literature' | 'cupcakes' | 'poems are forever' | 'the final battle' | 'your reality':
				songType = 'Classic';
			case 'mon-ika' | 'flower power' | 'honeycomb' | 'supernatural' | 
			'spiders of markov' | 'yuri is a raccoon' | 'amy likes ninjas' | 'roar of natsuki' | 'crossover clash' | 'festival deluxe':
				songType = 'Bonus';
			default:
				songType = 'Normal';
		}

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		#if desktop
		switch (CoolUtil.difficulties[storyDifficulty])
		{
			case 'Doki Doki':
				storyDifficultyText = 'DOKI DOKI Remix';
			default:
				storyDifficultyText = 'Regular';
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: " + WeekData.weekID;
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;
		#end

		GameOverSubstate.resetVariables();
		songName = Paths.formatToSongPath(SONG.song);

		curStage = PlayState.SONG.stage;
		if(PlayState.SONG.stage == null || PlayState.SONG.stage.length < 1) {
			switch (songName)
			{
				default:
					curStage = 'void';
			}
		}

		switch (songName)
		{
			case 'welcome-to-the-club' | 'welcome-to-the-club-(boyfriend)' | 'welcome-to-the-club-(bowser-jr)' | 'welcome-to-the-club-(monika)' | 'un-welcome-to-the-club' | 'roar-of-natsuki':
			{
				forceMiddlescroll = true;
				opponentNoteVisible = false;
			}
			case 'script-error':
			{
				if (ClientPrefs.playerChar == 3)
					noCountdown = true;
			}
			case 'system-failure' | 'flower-power' | 'candy-heartz':
			{
				noCountdown = true;
			}
			case 'your-reality':
			{
				noCountdown = true;
				forceMiddlescroll = true;
				opponentNoteVisible = false;
			}
			case 'supernatural':
			{
				opponentNoteVisible = false;
			}
		}

		vingetteThing = new FlxSprite(0, 0).loadGraphic(Paths.image('vingette'));
		vingetteThing.screenCenter();
		vingetteThing.scrollFactor.set();
		vingetteThing.cameras = [camOther];
		vingetteThing.alpha = 0.8;

		var loadGlitchBG:FlxSprite = new FlxSprite();
		loadGlitchBG.frames = Paths.getSparrowAtlas('stages/spaceroom/animatedClubroomGlitch');
		loadGlitchBG.animation.addByPrefix('idle', "background2", 60, false);

		//Stage data is defined when Stage Morph is activated

		stageGroup = new FlxGroup();
		add(stageGroup);

		boyfriendGroup = new FlxSpriteGroup(BF_X, BF_Y);
		dadGroup = new FlxSpriteGroup(DAD_X, DAD_Y);
		gfGroup = new FlxSpriteGroup(GF_X, GF_Y);
		exGroup = new FlxSpriteGroup(EX_X, EX_Y);

		if (SONG.song.toLowerCase() == 'yuri is a raccoon')
		{
			dad2 = new Character(0, 0, 'ath-sayo');
			dad2.scrollFactor.set(0.5, 0.5);
			exGroup.add(dad2);
			startCharacterPos(dad2);
	
			dad3 = new Character(0, 0, 'ath-nat');
			dad3.scrollFactor.set(0.5, 0.5);
			exGroup.add(dad3);
			startCharacterPos(dad3);
	
			boyfriend2 = new Character(0, 0, 'ath-moni', true);
			boyfriend2.scrollFactor.set(0.5, 0.5);
			exGroup.add(boyfriend2);
			startCharacterPos(boyfriend2);
		}

		add(exGroup);
		if (SONG.song.toLowerCase() == 'system failure')
		{
			add(dadGroup);
			add(gfGroup);
			add(boyfriendGroup);
		}
		else if (SONG.song.toLowerCase() == 'roar of natsuki')
		{
			add(gfGroup);
			add(boyfriendGroup);
			add(dadGroup);
		}
		else
		{
			add(gfGroup); //Needed for blammed lights
			add(boyfriendGroup);
			add(dadGroup);
		}
		stageMorph(curStage);

		staticlol = new StaticShader();
		staticlol.alpha.value = [staticAlpha];
		shader0 = new FlxRuntimeShader();

		if (PlayState.SONG.arrowSkin != null && PlayState.SONG.arrowSkin.length > 0)	
			noteTexture = PlayState.SONG.arrowSkin;
		else
		{
			noteTexture = 'Regular';
		}
		if (PlayState.SONG.splashSkin != null && PlayState.SONG.splashSkin.length > 0)	
			splashTexture = PlayState.SONG.splashSkin;
		else
		{
			splashTexture = 'Regular';
		}

		var gfVersion:String = SONG.gfVersion;

		if (ClientPrefs.playerChar == 3)
		{
			if (SONG.song.toLowerCase() == 'poetry' || SONG.song.toLowerCase() == 'writing tip' || SONG.song.toLowerCase() == 'i advise') gfStillVisible = true;
		}

		if (SONG.song.toLowerCase() == 'last dual' || songType != 'Normal' || ClientPrefs.playerChar == 1) gfStillVisible = true;

		if (SONG.song.toLowerCase() == 'crossover clash') gfStillVisible = false;

		if (gfStillVisible)
		{
			if (SONG.song.toLowerCase() != 'system failure') gfVersion = 'gf';
		}
		else
		{
			if (SONG.song.toLowerCase() != 'system failure') gfVersion = 'speakers';
		}

		if(gfVersion == null || gfVersion.length < 1) 
		{
			SONG.gfVersion = gfVersion; //Fix for the Chart Editor
		}

		if (songType == "Normal")
		{
			switch (ClientPrefs.playerChar)
			{
				case 2:
					if (SONG.player1 == 'bf')
						SONG.player1 = 'jr';
					if (SONG.player1 == 'bf-scared')
						SONG.player1 = 'jr-scared';
					if (SONG.player1 == 'bf-angry')
						SONG.player1 = 'jr-angry';
					if (SONG.player2 == 'jr-opponent')
						SONG.player2 = 'bf-opponent';
				case 3:
					if (SONG.player1 == 'bf')
						SONG.player1 = 'monika';
					if (SONG.player1 == 'bf-scared')
						SONG.player1 = 'monika-scared';
					if (SONG.player1 == 'bf-angry')
					{
						if (curStage == 'final-boss' || curStage == 'true-final-boss')
							SONG.player1 = 'monika-neo';
						else
							SONG.player1 = 'bf-gone';
					}
					if (SONG.player2 == 'monika-opponent')
					{
						if (SONG.song.toLowerCase() == 'i advise')
							SONG.player2 = 'jr-opponent';
						else
							SONG.player2 = 'bf-opponent';
					}
			}
		}

		if (!stageData.hide_girlfriend)
		{
			gf = new Character(0, 0, gfVersion);
			startCharacterPos(gf);
			gf.scrollFactor.set(0.95, 0.95);
			gfGroup.add(gf);
			nonexistantGF = false;
		}

		dad = new Character(0, 0, SONG.player2);
		startCharacterPos(dad, true);
		dadGroup.add(dad);
		
		boyfriend = new Character(0, 0, SONG.player1, true);
		startCharacterPos(boyfriend);
		boyfriendGroup.add(boyfriend);

		if (SONG.song.toLowerCase() == 'roar of natsuki')
		{
			dad.alpha = 0;
			camHUD.alpha = 0;
		}
		
		var camPos:FlxPoint = new FlxPoint(girlfriendCameraOffset[0], girlfriendCameraOffset[1]);
		if(gf != null)
		{
			camPos.x += gf.getGraphicMidpoint().x + gf.cameraPosition[0];
			camPos.y += gf.getGraphicMidpoint().y + gf.cameraPosition[1];
		}
		else
		{
			camPos.set(dad.getMidpoint().x - 120, dad.getMidpoint().y - 190);
		}

		if(dad.curCharacter.startsWith('gf')) {
			dad.setPosition(GF_X, GF_Y);
			if(gf != null)
				gf.visible = false;
		}

		// goes unused for now
		/*switch(curStage)
		{
			case 'final-boss':
				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069); //nice
				insert(members.indexOf(dadGroup) - 1, evilTrail);
		}*/

		var file:String = Paths.txt(songName + '/' + songName + 'Dialogue'); //Checks for vanilla/Senpai dialogue
		var file2:String = Paths.txt(songName + '/' + songName + 'Dialogue');
		switch (ClientPrefs.playerChar)
		{
			case 1:
				switch (SONG.song.toLowerCase())
				{
					case 'welcome to the club (boyfriend)':
						file = Paths.dialogueTxt('bf/bfRouteStart');
						hasDialogue = true;
					case 'daydream':
						file = Paths.dialogueTxt('bf/bfSayori1');
						hasDialogue = true;
					case 'happy thoughts':
						file = Paths.dialogueTxt('bf/bfSayori2');
						hasDialogue = true;
					case 'manga':
						file = Paths.dialogueTxt('bf/bfNatsuki1');
						hasDialogue = true;
					case 'tsundere':
						file = Paths.dialogueTxt('bf/bfNatsuki2');
						hasDialogue = true;
					case 'novelty':
						file = Paths.dialogueTxt('bf/bfYuri1');
						hasDialogue = true;
					case 'shy':
						file = Paths.dialogueTxt('bf/bfYuri2');
						hasDialogue = true;
					case 'poetry':
						file = Paths.dialogueTxt('bf/bfMonika1');
						hasDialogue = true;
					case 'writing tip':
						file = Paths.dialogueTxt('bf/bfMonika2');
						hasDialogue = true;
					case 'last dual':
						file = Paths.dialogueTxt('bf/bfMonika3');
						hasDialogue = true;
					case 'un-welcome to the club':
						file = Paths.dialogueTxt('bf/bfAct2');
						hasDialogue = true;
					case 'depression':
						file = Paths.dialogueTxt('bf/bfSayonara1');
						hasDialogue = true;
					case 'hxppy thxughts':
						file = Paths.dialogueTxt('bf/bfSayonara2');
						hasDialogue = true;
					case 'malnourished':
						file = Paths.dialogueTxt('bf/bfGlitchsuki1');
						hasDialogue = true;
					case 'glitch':
						file = Paths.dialogueTxt('bf/bfGlitchsuki2');
						hasDialogue = true;
					case 'yandere':
						file = Paths.dialogueTxt('bf/bfYurdere1');
						hasDialogue = true;
					case 'obsessed':
						file = Paths.dialogueTxt('bf/bfYurdere2');
						file2 = Paths.dialogueTxt('bf/bfAct2End');
						hasDialogue = true;
					case 'lines of code':
						file = Paths.dialogueTxt('bf/bfFinalMoni1');
						hasDialogue = true;
					case 'self-aware':
						file = Paths.dialogueTxt('bf/bfFinalMoni2');
						file2 = Paths.dialogueTxt('bf/bfFinalMoni3');
						hasDialogue = true;
					case 'script error':
						file = Paths.dialogueTxt('bf/bfFinalSayori');
						file2 = Paths.dialogueTxt('bf/bfRouteEnding');
						hasDialogue = true;
				}
			case 2:
				switch (SONG.song.toLowerCase())
				{
					case 'welcome to the club (bowser jr)':
						file = Paths.dialogueTxt('jr/jrRouteStart');
						hasDialogue = true;
					case 'daydream':
						file = Paths.dialogueTxt('jr/jrSayori1');
						hasDialogue = true;
					case 'cinnamon bun':
						file = Paths.dialogueTxt('jr/jrSayori2');
						hasDialogue = true;
					case 'anime':
						file = Paths.dialogueTxt('jr/jrNatsuki1');
						hasDialogue = true;
					case 'tsundere':
						file = Paths.dialogueTxt('jr/jrNatsuki2');
						hasDialogue = true;
					case 'novelty':
						file = Paths.dialogueTxt('jr/jrYuri1');
						hasDialogue = true;
					case 'cup of tea':
						file = Paths.dialogueTxt('jr/jrYuri2');
						hasDialogue = true;
					case 'poetry':
						file = Paths.dialogueTxt('jr/jrMonika1');
						hasDialogue = true;
					case 'i advise':
						file = Paths.dialogueTxt('jr/jrMonika2');
						hasDialogue = true;
					case 'last dual':
						file = Paths.dialogueTxt('jr/jrMonika3');
						hasDialogue = true;
					case 'un-welcome to the club':
						file = Paths.dialogueTxt('jr/jrAct2');
						hasDialogue = true;
					case 'depression':
						file = Paths.dialogueTxt('jr/jrSayonara1');
						hasDialogue = true;
					case 'cxnnamon bxn':
						file = Paths.dialogueTxt('jr/jrSayonara2');
						hasDialogue = true;
					case 'pale':
						file = Paths.dialogueTxt('jr/jrGlitchsuki1');
						hasDialogue = true;
					case 'glitch':
						file = Paths.dialogueTxt('jr/jrGlitchsuki2');
						hasDialogue = true;
					case 'yandere':
						file = Paths.dialogueTxt('jr/jrYurdere1');
						hasDialogue = true;
					case 'psychopath':
						file = Paths.dialogueTxt('jr/jrYurdere2');
						file2 = Paths.dialogueTxt('jr/jrAct2End');
						hasDialogue = true;
					case 'lines of code':
						file = Paths.dialogueTxt('jr/jrFinalMoni1');
						hasDialogue = true;
					case 'elevated access':
						file = Paths.dialogueTxt('jr/jrFinalMoni2');
						file2 = Paths.dialogueTxt('jr/jrFinalMoni3');
						hasDialogue = true;
					case 'script error':
						file = Paths.dialogueTxt('jr/jrFinalSayori');
						file2 = Paths.dialogueTxt('jr/jrRouteEnding');
						hasDialogue = true;
				}
			case 3:
				switch (SONG.song.toLowerCase())
				{
					case 'welcome to the club (monika)':
						file = Paths.dialogueTxt('moni/moniRouteStart');
						hasDialogue = true;
					case 'daydream':
						file = Paths.dialogueTxt('moni/moniSayori1');
						hasDialogue = true;
					case 'happy thoughts':
						file = Paths.dialogueTxt('moni/moniSayori2');
						hasDialogue = true;
					case 'trust':
						file = Paths.dialogueTxt('moni/moniSayori3');
						hasDialogue = true;
					case 'manga':
						file = Paths.dialogueTxt('moni/moniNatsuki1');
						hasDialogue = true;
					case 'anime':
						file = Paths.dialogueTxt('moni/moniNatsuki2');
						hasDialogue = true;
					case 'respect':
						file = Paths.dialogueTxt('moni/moniNatsuki3');
						hasDialogue = true;
					case 'novelty':
						file = Paths.dialogueTxt('moni/moniYuri1');
						hasDialogue = true;
					case 'cup of tea':
						file = Paths.dialogueTxt('moni/moniYuri2');
						hasDialogue = true;
					case 'reflection':
						file = Paths.dialogueTxt('moni/moniYuri3');
						hasDialogue = true;
					case 'writing tip':
						file = Paths.dialogueTxt('moni/moniBF');
						hasDialogue = true;
					case 'i advise':
						file = Paths.dialogueTxt('moni/moniJR');
						file2 = Paths.dialogueTxt('moni/moniAct1End');
						hasDialogue = true;
					case 'un-welcome to the club':
						file = Paths.dialogueTxt('moni/moniNoEE');
						hasDialogue = true;
					case 'revelation':
						file = Paths.dialogueTxt("moni/justMoni1/1");
						isAct3 = true;
						hasDialogue = true;
					case 'self-aware':
						file = Paths.dialogueTxt('moni/justMoni2');
						isAct3 = true;
						hasDialogue = true;
					case 'elevated access':
						file = Paths.dialogueTxt('moni/justMoni3');
						file2 = Paths.dialogueTxt('moni/justMoni4');
						isAct3 = true;
						hasDialogue = true;
					case 'script error':
						file = Paths.dialogueTxt('moni/sayorivil1');
						isAct3 = true;
						hasDialogue = true;
					case 'system failure':
						file = Paths.dialogueTxt('moni/sayorivil2');
						isAct3 = true;
						hasDialogue = true;
				}
		}
		switch (SONG.song.toLowerCase())
		{
			case 'crossover clash':
				file = Paths.dialogueTxt('moni/crossover');
				hasDialogue = true;
		}
		if (OpenFlAssets.exists(file)) {
			dialogue = CoolUtil.coolTextFile(file);
		}
		if (OpenFlAssets.exists(file2)) {
			extra = CoolUtil.coolTextFile(file2);
		}

		doof = new DialogueBoxRegular(dialogue, PlayState.SONG.song.toLowerCase() == 'revelation');
		doof.isAct3 = isAct3;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		doof2 = new DialogueBoxRegular(extra, false);
		doof2.isAct3 = isAct3;
		doof2.scrollFactor.set();

		doof.cameras = [camDialogue];
		doof2.cameras = [camDialogue];
		//doof.cameras = FlxG.cameras.list;
		//doof2.cameras = FlxG.cameras.list;

		if (isStoryMode)
			doof2.finishThing = endSong;
		else
			doof2.finishThing = showResults;

		Conductor.songPosition = -5000;

		strumLine = new FlxSprite(isMiddleScroll ? STRUM_X_MIDDLESCROLL : STRUM_X, 50).makeGraphic(FlxG.width, 10);
		if(ClientPrefs.downScroll) strumLine.y = FlxG.height - 150;
		strumLine.scrollFactor.set();

		var showTime:Bool = true;
		showTime = (ClientPrefs.timeBarType != 'Disabled');
		timeTxt = new FlxText(STRUM_X + (FlxG.width / 2) - 248, 19, 400, "", 32);
		timeTxt.setFormat(Paths.font("doki.ttf"), 32, FlxColor.WHITE, CENTER);
		timeTxt.borderColor = 0xFF000000;
		timeTxt.borderStyle = OUTLINE;
		timeTxt.scrollFactor.set();
		timeTxt.alpha = 0;
		timeTxt.borderSize = 2;

		timeTxt.visible = showTime;
		updateTime = showTime;

		if(ClientPrefs.downScroll) timeTxt.y = FlxG.height - 44;

		if(ClientPrefs.timeBarType == 'Song Name')
		{
			timeTxt.text = SONG.song;
		}

		timeBarBG = new AttachedSprite('bars/timeBar');
		timeBarBG.x = timeTxt.x;
		timeBarBG.y = timeTxt.y + (timeTxt.height / 4);
		timeBarBG.scrollFactor.set();
		timeBarBG.alpha = 0;
		timeBarBG.visible = showTime;
		timeBarBG.color = FlxColor.BLACK;
		timeBarBG.xAdd = -4;
		timeBarBG.yAdd = -4;

		timeBar = new FlxBar(timeBarBG.x - 4, timeBarBG.y - 4, LEFT_TO_RIGHT, Std.int(timeBarBG.width - 8), Std.int(timeBarBG.height - 8), this,
			'songPercent', 0, 1);
		timeBar.scrollFactor.set();

		timeBar.createFilledBar(FlxColor.GRAY, FlxColor.WHITE);
		timeBar.numDivisions = 800; //How much lag this causes?? Should i tone it down to idk, 400 or 200?
		timeBar.alpha = 0;
		timeBar.visible = showTime;
		add(timeBarBG);
		add(timeBar);
		add(timeTxt);
		timeBarBG.sprTracker = timeBar;

		strumLineNotes = new FlxTypedGroup<StrumNote>();
		add(strumLineNotes);
		add(grpNoteSplashes);

		timeBarBG.x += 7;
		timeBar.x += 7;
		if (ClientPrefs.downScroll)
		{
			timeTxt.y -= 8;
			timeBarBG.y += 4;
			timeBar.y += 4;
		}
		else
		{
			timeBarBG.y -= 4;
			timeBar.y -= 4;
			timeTxt.y -= 12;
		}

		if(ClientPrefs.timeBarType == 'Song Name')
		{
			timeTxt.size = 24;
			timeTxt.y += 3;
		}

		var splash:NoteSplash = new NoteSplash(100, 100, 0);
		grpNoteSplashes.add(splash);
		splash.alpha = 0.0;

		opponentStrums = new FlxTypedGroup<StrumNote>();
		playerStrums = new FlxTypedGroup<StrumNote>();

		generateSong(SONG.song);
		noteTypeMap.clear();
		noteTypeMap = null;
		eventPushedMap.clear();
		eventPushedMap = null;

		// After all characters being loaded, it makes then invisible 0.01s later so that the player won't freeze when you change characters

		camFollow = new FlxPoint();
		camFollowPos = new FlxObject(0, 0, 1, 1);

		snapCamFollowToPos(camPos.x, camPos.y);
		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}
		if (prevCamFollowPos != null)
		{
			camFollowPos = prevCamFollowPos;
			prevCamFollowPos = null;
		}
		add(camFollowPos);

		FlxG.camera.follow(camFollowPos, LOCKON, 1);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow);

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;
		moveCameraSection(0);

		healthBar = new HealthBar(dad.healthIcon, boyfriend.healthIcon, isDokiDoki, false);
		healthBar.reloadHealthBarColors(boyfriend.healthColorArray, dad.healthColorArray);
		add(healthBar);

		scoreTxt = new FlxText(0, healthBar.barOPP.y + 62, FlxG.width, "", 20);
		scoreTxt.setFormat(Paths.font("doki.ttf"), 25, FlxColor.WHITE, FlxTextAlign.CENTER);
		scoreTxt.borderColor = 0xFF000000;
		scoreTxt.borderStyle = OUTLINE;
		scoreTxt.alignment = CENTER;
		scoreTxt.scrollFactor.set();
		scoreTxt.borderSize = 1.25;
		add(scoreTxt);

		missTxt = new FlxText(0, 10, FlxG.width, "", 20);
		missTxt.setFormat(Paths.font("doki.ttf"), 16, FlxColor.WHITE, FlxTextAlign.CENTER);
		missTxt.borderColor = 0xFF000000;
		missTxt.borderStyle = OUTLINE;
		missTxt.alignment = CENTER;
		missTxt.scrollFactor.set();
		missTxt.borderSize = 1.25;
		missTxt.alpha = 0;
		add(missTxt);

		var botplayPath:String = 'hudFolders/' + pixeltrashPart1 + 'botplay';
		var practicePath:String = 'hudFolders/' + pixeltrashPart1 + 'practice';

		botplaySpr = new FlxSprite(-31, 540).loadGraphic(Paths.image(botplayPath));
		botplaySpr.scrollFactor.set();
		botplaySpr.scale.set(0.6, 0.6);
		botplaySpr.visible = cpuControlled;
		add(botplaySpr);
		if (ClientPrefs.downScroll)
		{
			botplaySpr.y = 12;
		}

		practiceSpr = new FlxSprite(900, 540).loadGraphic(Paths.image(practicePath));
		practiceSpr.scrollFactor.set();
		practiceSpr.scale.set(0.6, 0.6);
		practiceSpr.visible = practiceMode;
		add(practiceSpr);
		if (ClientPrefs.downScroll)
		{
			practiceSpr.y = 12;
		}

		if (SONG.song.toLowerCase() == 'supernatural')
		{
			dad.alpha = 0;
			healthBar.iconP2.alpha = 0;
			healthBar.barOPP.alpha = 0;
			healthBar.meterOPP.alpha = 0;
		}

		warningSign = new FlxSprite(500, 200);
		warningSign.frames = Paths.getSparrowAtlas('Warning_Thing');
		warningSign.animation.addByPrefix('alert', "Show", 60, false);
		warningSign.antialiasing = true;
		warningSign.setGraphicSize(Std.int(warningSign.width * 1));
		warningSign.updateHitbox();
		warningSign.cameras = [camHUD];
		add(warningSign);
		warningSign.visible = false;

		outroBlack = new FlxSprite(0, 0).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
		outroBlack.screenCenter(X);
		outroBlack.scrollFactor.set();
		outroBlack.cameras = [camDialogue];

		black = new FlxSprite(0, 0).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
		black.screenCenter(X);
		black.scrollFactor.set();
		black.cameras = [camOther];
		if (SONG.song.toLowerCase() == 'system failure' || SONG.song.toLowerCase() == 'flower power')
			add(black);
		else
		{
			if (SONG.song.toLowerCase() == 'script error' && ClientPrefs.playerChar == 3)
				add(black);
		}

		blueScreen = new FlxSprite(0, 0);
		blueScreen.frames = Paths.getSparrowAtlas('Blue-Screen-Of-Death');
		blueScreen.animation.addByPrefix('show', 'BSOD', 24, false);
		blueScreen.animation.play('show');
		blueScreen.screenCenter(X);
		blueScreen.antialiasing = true;
		blueScreen.scrollFactor.set();
		blueScreen.cameras = [camDialogue];

		tvStatic = new FlxSprite(0, 0);
		tvStatic.frames = Paths.getSparrowAtlas('static');
		tvStatic.animation.addByPrefix('idle', 'static', 48, true);
		tvStatic.animation.play('idle');
		tvStatic.screenCenter(X);
		tvStatic.scrollFactor.set();
		tvStatic.cameras = [camOther];
		add(tvStatic);
		tvStatic.alpha = 0;
		if (curSong.toLowerCase() == 'glitch' || curSong.toLowerCase() == 'play with me')
		{
			tvStatic.alpha = 0.2;
		}

		frontMonika = new FlxSprite(0, 0).loadGraphic(Paths.image('oops'));
		frontMonika.screenCenter(X);
		frontMonika.scrollFactor.set();
		frontMonika.cameras = [camDialogue];
		frontMonika.alpha = 0;
		add(frontMonika);

		blackFade = new FlxSprite(0, 0).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
		blackFade.screenCenter(X);
		blackFade.scrollFactor.set();
		blackFade.cameras = [camOther];
		add(blackFade);
		blackFade.alpha = 0;
		if (curSong.toLowerCase() == "obsessed" || curSong.toLowerCase() == "psychopath" || curSong.toLowerCase() == 'poem panic')
		{
			blackFade.alpha = 0.75;
			yandereMode = true;
			timeTxt.visible = false;
			timeBar.visible = false;
		}
		if (curSong.toLowerCase() == "candy heartz" || curSong.toLowerCase() == "your reality")
			blackFade.alpha = 1;

		whiteFade = new FlxSprite(0, 0).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.WHITE);
		whiteFade.screenCenter(X);
		whiteFade.scrollFactor.set();
		whiteFade.cameras = [camOther];
		add(whiteFade);
		whiteFade.alpha = 0;

		endScreen = new FlxSprite(0, 0).loadGraphic(Paths.image('end_screen'));
		endScreen.screenCenter(X);
		endScreen.scrollFactor.set();
		endScreen.cameras = [camOther];
		add(endScreen);
		endScreen.alpha = 0;

		funnyComment = new FlxSprite(0, 0).loadGraphic(Paths.image('haha_funny'));
		funnyComment.screenCenter();
		funnyComment.scrollFactor.set();
		funnyComment.cameras = [camDialogue];

		lyricText = new FlxText(0, 480, FlxG.width, "", 24);
		lyricText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		lyricText.scrollFactor.set();
		lyricText.borderSize = 1.25;
		lyricText.cameras = [camDialogue];
		add(lyricText);

		strumLineNotes.cameras = [camHUD];
		grpNoteSplashes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		missTxt.cameras = [camHUD];
		botplaySpr.cameras = [camHUD];
		practiceSpr.cameras = [camHUD];
		timeBar.cameras = [camHUD];
		timeBarBG.cameras = [camHUD];
		timeTxt.cameras = [camHUD];

		startingSong = true;

		if (Paths.formatToSongPath(SONG.song) == 'roar-of-natsuki')
			dodginTime = true;
		
		var daSong:String = Paths.formatToSongPath(curSong);
		var usedPractice:Bool = (ClientPrefs.getGameplaySetting('practice', false) || ClientPrefs.getGameplaySetting('botplay', false));
		var canPlayCutscene:Bool = isStoryMode || ClientPrefs.freeplayCutscenes;

		if (daSong == 'crossover-clash')
		{
			if (!SaveData.regularCleared.contains('crossover clash'))
				canPlayCutscene = true;
		}

		if (canPlayCutscene && !seenCutscene && hasDialogue)
		{
			switch (daSong)
			{
				case 'script-error':
					startVideo('sayorivil');
				default:
					defIntro();
			}
			seenCutscene = true;
		}
		else
		{
			startCountdown();
		}
		RecalculateRating();

		//PRECACHING MISS SOUNDS BECAUSE I THINK THEY CAN LAG PEOPLE AND PECK THEM UP IDK HOW HAXE WORKS
		if(ClientPrefs.hitsoundVolume > 0) precacheList.set('hitsound', 'sound');
		if (ClientPrefs.misssoundVolume > 0)
		{
			precacheList.set('missnote1', 'sound');
			precacheList.set('missnote2', 'sound');
			precacheList.set('missnote3', 'sound');
		}

		if (PauseSubState.pausesongname != null) {
			precacheList.set(PauseSubState.pausesongname, 'music');
		}

		#if desktop
		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", healthBar.iconP2.getCharacter());
		#end

		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
		FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyRelease);

		Conductor.safeZoneOffset = (ClientPrefs.safeFrames / 60) * 1000;

		for (key => type in precacheList)
		{
			switch(type)
			{
				case 'image':
					Paths.image(key);
				case 'sound':
					Paths.sound(key);
				case 'music':
					Paths.music(key);
			}
		}

		FlxG.mouse.visible = false;
		
		super.create();

		Paths.clearUnusedMemory();
	}

	//Made this to easily swap between stages
	function stageMorph(stage:String)
	{
		stagesFunc(function(stage:BaseStage) stage.stageMorph());
		stageGroup.remove(currentStage);

		stageData = StageData.getStageFile(stage);
		if(stageData == null) {
			stageData = {
				directory: "",
				defaultZoom: 0.9,
				isPixelStage: false,
			
				boyfriend: [770, 100],
				girlfriend: [400, 130],
				opponent: [100, 100],
				hide_girlfriend: false,
			
				camera_boyfriend: [0, 0],
				camera_opponent: [0, 0],
				camera_girlfriend: [0, 0],
				camera_speed: 1
			};
		}

		defaultCamZoom = stageData.defaultZoom;
		//isPixelStage = stageData.isPixelStage;
		BF_X = stageData.boyfriend[0];
		BF_Y = stageData.boyfriend[1];
		GF_X = stageData.girlfriend[0];
		GF_Y = stageData.girlfriend[1];
		DAD_X = stageData.opponent[0];
		DAD_Y = stageData.opponent[1];

		boyfriendGroup.x = BF_X;
		boyfriendGroup.y = BF_Y;
		dadGroup.x = DAD_X;
		dadGroup.y = DAD_Y;
		gfGroup.x = GF_X;
		gfGroup.y = GF_Y;

		if(stageData.camera_speed != null)
			cameraSpeed = stageData.camera_speed;

		boyfriendCameraOffset = stageData.camera_boyfriend;
		if(boyfriendCameraOffset == null)
			boyfriendCameraOffset = [0, 0];

		opponentCameraOffset = stageData.camera_opponent;
		if(opponentCameraOffset == null)
			opponentCameraOffset = [0, 0];
		
		girlfriendCameraOffset = stageData.camera_girlfriend;
		if(girlfriendCameraOffset == null)
			girlfriendCameraOffset = [0, 0];

		curStage = stage;

		switch (curStage)
		{
			case 'clubroom': currentStage = new states.stages.Club();
			case 'hallway': currentStage = new states.stages.Hallway();
			case 's-bedroom': currentStage = new states.stages.Bedroom();
			case 'clubroom-skill': currentStage = new states.stages.ClubSkill();
			case 'spaceroom': currentStage = new states.stages.Spaceroom();
			case 'spaceroom-glitch': currentStage = new states.stages.GlitchSpaceroom();
			case 'final-boss':	currentStage = new states.stages.FinalBoss();
			case 'true-final-boss': currentStage = new states.stages.Endgame();
			case 'clubroom-classic': currentStage = new states.stages.ClubClassic();
			case 'clubroom-classic-skill': currentStage = new states.stages.ClubClassicSkill();
			case 'void': currentStage = new states.stages.Void();
			case 'beach': currentStage = new states.stages.Beach();
			case 'field': currentStage = new states.stages.Field();
			case 'beehive': currentStage = new states.stages.Hive();
			case 'graveyard': currentStage = new states.stages.Graveyard();
			case 'pyramid': currentStage = new states.stages.PyramidCaverns();
			case 'mario-level': currentStage = new states.stages.MarioStage();
			case 'ninja-hideaway': currentStage = new states.stages.NinjaDojo();
			case 'boxing-ring': currentStage = new states.stages.BoxingRing();
			case 'ddto_club': currentStage = new states.stages.DDTOClub();
		}
		stageGroup.add(currentStage);
	}

	#if sys
	public var runtimeShaders:Map<String, Array<String>> = new Map<String, Array<String>>();
	public function createRuntimeShader(name:String):FlxRuntimeShader
	{
		if(!ClientPrefs.shaders) return new FlxRuntimeShader();

		#if sys
		if(!runtimeShaders.exists(name) && !initShader(name))
		{
			FlxG.log.warn('Shader $name is missing!');
			return new FlxRuntimeShader();
		}

		var arr:Array<String> = runtimeShaders.get(name);
		return new FlxRuntimeShader(arr[0], arr[1]);
		#else
		FlxG.log.warn("Platform unsupported for Runtime Shaders!");
		return null;
		#end
	}

	public function initShader(name:String, ?glslVersion:Int = 120)
	{
		if(!ClientPrefs.shaders) return false;

		if(runtimeShaders.exists(name))
		{
			return true;
		}

		var frag:String = Paths.shaderFragment(name);
		var vert:String = Paths.shaderVertex(name);
		var found:Bool = false;
		if(FileSystem.exists(frag))
		{
			frag = File.getContent(frag);
			found = true;
		}
		else frag = null;

		if (FileSystem.exists(vert))
		{
			vert = File.getContent(vert);
			found = true;
		}
		else vert = null;

		if(found)
		{
			runtimeShaders.set(name, [frag, vert]);
			//trace('Found shader $name!');
			return true;
		}
		
		FlxG.log.warn('Missing shader $name .frag AND .vert files!');
		return false;
	}
	#end

	function set_songSpeed(value:Float):Float
	{
		if(generatedMusic)
		{
			var ratio:Float = value / songSpeed; //funny word huh
			for (note in notes)
			{
				if(note.isSustainNote && !note.animation.curAnim.name.endsWith('end'))
				{
					note.scale.y *= ratio;
					note.updateHitbox();
				}
			}
			for (note in unspawnNotes)
			{
				if(note.isSustainNote && !note.animation.curAnim.name.endsWith('end'))
				{
					note.scale.y *= ratio;
					note.updateHitbox();
				}
			}
		}
		songSpeed = value;
		noteKillOffset = 350 / songSpeed;
		return value;
	}

	public function addCharacterToList(newCharacter:String, type:Int) {
		switch(type) {
			case 0:
				if(!boyfriendMap.exists(newCharacter)) {
					var newBoyfriend:Character = new Character(0, 0, newCharacter, true);
					boyfriendMap.set(newCharacter, newBoyfriend);
					boyfriendGroup.add(newBoyfriend);
					startCharacterPos(newBoyfriend);
					newBoyfriend.alpha = 0.00001;
				}

			case 1:
				if(!dadMap.exists(newCharacter)) {
					var newDad:Character = new Character(0, 0, newCharacter);
					dadMap.set(newCharacter, newDad);
					dadGroup.add(newDad);
					startCharacterPos(newDad, true);
					newDad.alpha = 0.00001;
				}

			case 2:
				if(gf != null && !gfMap.exists(newCharacter)) {
					var newGf:Character = new Character(0, 0, newCharacter);
					newGf.scrollFactor.set(0.95, 0.95);
					gfMap.set(newCharacter, newGf);
					gfGroup.add(newGf);
					startCharacterPos(newGf);
					newGf.alpha = 0.00001;
				}
			case 3:
				if(dad2 != null && !dad2Map.exists(newCharacter)) {
					var newDad2:Character = new Character(0, 0, newCharacter);
					dad2Map.set(newCharacter, newDad2);
					exGroup.add(newDad2);
					startCharacterPos(newDad2);
					newDad2.alpha = 0.00001;
				}
			case 4:
				if(dad3 != null && !dad3Map.exists(newCharacter)) {
					var newDad3:Character = new Character(0, 0, newCharacter);
					dad3Map.set(newCharacter, newDad3);
					exGroup.add(newDad3);
					startCharacterPos(newDad3);
					newDad3.alpha = 0.00001;
				}
			case 5:
				if(dad4 != null && !dad4Map.exists(newCharacter)) {
					var newDad4:Character = new Character(0, 0, newCharacter);
					dad4Map.set(newCharacter, newDad4);
					exGroup.add(newDad4);
					startCharacterPos(newDad4);
					newDad4.alpha = 0.00001;
				}
			case 6:
				if(boyfriend2 != null && !boyfriend2Map.exists(newCharacter)) {
					var newBoyfriend2:Character = new Character(0, 0, newCharacter, true);
					boyfriend2Map.set(newCharacter, newBoyfriend2);
					exGroup.add(newBoyfriend2);
					startCharacterPos(newBoyfriend2);
					newBoyfriend2.alpha = 0.00001;
				}
			case 7:
				if(boyfriend3 != null && !boyfriend3Map.exists(newCharacter)) {
					var newBoyfriend3:Character = new Character(0, 0, newCharacter, true);
					boyfriend3Map.set(newCharacter, newBoyfriend3);
					exGroup.add(newBoyfriend3);
					startCharacterPos(newBoyfriend3);
					newBoyfriend3.alpha = 0.00001;
				}
			case 8:
				if(boyfriend4 != null && !boyfriend4Map.exists(newCharacter)) {
					var newBoyfriend4:Character = new Character(0, 0, newCharacter, true);
					boyfriend4Map.set(newCharacter, newBoyfriend4);
					exGroup.add(newBoyfriend4);
					startCharacterPos(newBoyfriend4);
					newBoyfriend4.alpha = 0.00001;
				}
		}
	}
	
	function startCharacterPos(char:Character, ?gfCheck:Bool = false) {
		if(gfCheck && char.curCharacter.startsWith('gf')) { //IF DAD IS GIRLFRIEND, HE GOES TO HER POSITION
			char.setPosition(GF_X, GF_Y);
			char.scrollFactor.set(0.95, 0.95);
			char.danceEveryNumBeats = 2;
		}
		if (char.curCharacter.startsWith('ath-')){
			char.scrollFactor.set(0.5, 0.5);
		}
		if (char.curCharacter.startsWith('ja-')){
			char.scrollFactor.set(0.9, 0.9);
		}
		char.x += char.positionArray[0];
		char.y += char.positionArray[1];
	}

	public function startVideo(name:String):Void 
	{
		var usedPractice:Bool = (ClientPrefs.getGameplaySetting('practice', false) || ClientPrefs.getGameplaySetting('botplay', false));
		if (!usedPractice)
		{
			#if VIDEOS_ALLOWED
			var foundFile:Bool = false;
			var fileName:String = '';
			#if sys
			if(FileSystem.exists(fileName)) {
				foundFile = true;
			}
			#end

			if(!foundFile) {
				fileName = Paths.video(name);
				#if sys
				if(FileSystem.exists(fileName)) 
				{
					foundFile = true;
				}
				#else
				if(OpenFlAssets.exists(fileName)) 
				{
					foundFile = true;
				}
				#end
			}

			if(foundFile) {
				inCutscene = true;
				var filepath:String = Paths.video(name);
				#if sys
				if(!FileSystem.exists(filepath))
				#else
				if(!OpenFlAssets.exists(filepath))
				#end
				{
					FlxG.log.warn('Couldnt find video file: ' + name);
					startAndEnd();
					return;
				}

				var bg = new FlxSprite(-FlxG.width, -FlxG.height).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
				bg.scrollFactor.set();
				bg.cameras = [camDialogue];
				add(bg);

				var video:VideoSprite = new VideoSprite();
				video.scrollFactor.set();
				video.setGraphicSize(Std.int(video.width / 1));
				video.updateHitbox();
				video.antialiasing = ClientPrefs.globalAntialiasing;
				video.cameras = [camDialogue];
				video.bitmap.canSkip = false;
				video.playVideo(filepath, false);
				video.finishCallback = function()
				{
					remove(bg);
					remove(video);
					startAndEnd();
				}
				add(video);
				return;
			}
			else
			{
				FlxG.log.warn('Couldnt find video file: ' + fileName);
				startAndEnd();
			}
			#end
			startAndEnd();
		}
		else
			startAndEnd();
	}

	function startAndEnd()
	{
		if(endingSong)
			endSong();
		else
		{
			if (curSong.toLowerCase() == 'script error')
			{
				defIntro();
			}
			else
				startCountdown();
		}
	}

	var dialogueCount:Int = 0;

	function defIntro()
	{
		var usedPractice:Bool = (ClientPrefs.getGameplaySetting('practice', false) || ClientPrefs.getGameplaySetting('botplay', false));

		if (!usedPractice && doof != null && dialogue != null)
		{
			inCutscene = true;
			add(doof);
		}
		else
			startCountdown();
	}
	
	function defOutro()
	{
		var usedPractice:Bool = (ClientPrefs.getGameplaySetting('practice', false) || ClientPrefs.getGameplaySetting('botplay', false));

		if (extra != null)
		{
			inCutscene = true;
			add(outroBlack);
			add(doof2);
		}
		else
			endSong();
	}
	
	function actOneEnd()
	{
		var blankscreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width * 1, FlxG.height * 1, FlxColor.BLACK);
		blankscreen.scrollFactor.set();
		blankscreen.cameras = [camHUD];
		add(blankscreen);
		FlxG.sound.play(Paths.sound('ActOneEnd'), 1, false, null, true, function()
		{
			endSong();
		});
	}

	var startTimer:FlxTimer;
	var finishTimer:FlxTimer = null;

	public var countdownOnYourMarks:FlxSprite;
	public var countdownReady:FlxSprite;
	public var countdownSet:FlxSprite;
	public var countdownGo:FlxSprite;
	public static var startOnTime:Float = 0;

	function showResults():Void
	{
		resultsShow = true;
		endSong();
	}

	function leCoolSongName(?buffnwild:Bool = false)
	{
		var name:String = SONG.song;

		if (songName == 'welcome-to-the-club-(boyfriend)' || songName == 'welcome-to-the-club-(bowser-jr)' || songName == 'welcome-to-the-club-(monika)')
			name = 'Welcome To The Club';

		songBlurbStuff = new CoolSongBlurb(name, isDokiDoki, buffnwild);
		add(songBlurbStuff);
		songBlurbStuff.cameras = [camOther];
		songBlurbStuff.tweenIn();

		new FlxTimer().start(5, function(tmr:FlxTimer)
		{
			songBlurbStuff.tweenOut();
		});
		composerName = songBlurbStuff.composerName;
	}

	public function startCountdown():Void
	{
		if(startedCountdown) {
			return;
		}

		if (SONG.song.toLowerCase() == 'revelation' && isStoryMode) playervox.loadEmbedded(Paths.playervoices(PlayState.SONG.song));

		if (ClientPrefs.middleScroll || forceMiddlescroll)
		{
			isMiddleScroll = true;
		}
		else
		{
			isMiddleScroll = false;
		}

		inCutscene = false;
		
		if (skipCountdown || startOnTime > 0) skipArrowStartTween = true;

		generateStaticArrows(0);
		generateStaticArrows(1);

		defaultPlayerStrumX1 = playerStrums.members[0].x;
		defaultPlayerStrumX2 = playerStrums.members[1].x;
		defaultPlayerStrumX3 = playerStrums.members[2].x;
		defaultPlayerStrumX4 = playerStrums.members[3].x;

		defaultPlayerStrumY1 = playerStrums.members[0].y;
		defaultPlayerStrumY2 = playerStrums.members[1].y;
		defaultPlayerStrumY3 = playerStrums.members[2].y;
		defaultPlayerStrumY4 = playerStrums.members[3].y;

		defaultOpponentStrumX1 = opponentStrums.members[0].x;
		defaultOpponentStrumX2 = opponentStrums.members[1].x;
		defaultOpponentStrumX3 = opponentStrums.members[2].x;
		defaultOpponentStrumX4 = opponentStrums.members[3].x;

		defaultOpponentStrumY1 = opponentStrums.members[0].y;
		defaultOpponentStrumY2 = opponentStrums.members[1].y;
		defaultOpponentStrumY3 = opponentStrums.members[2].y;
		defaultOpponentStrumY4 = opponentStrums.members[3].y;

		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		if (skipCountdown || startOnTime > 0) {
			clearNotesBefore(startOnTime);
			setSongTime(startOnTime - 500);
			return;
		}

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			if (gf != null && tmr.loopsLeft % Math.round(gfSpeed * gf.danceEveryNumBeats) == 0 && !gf.stunned && gf.animation.curAnim.name != null && !gf.animation.curAnim.name.startsWith("sing") && !gf.stunned)
			{
				if (gfStillVisible)
				{
					if (yandereMode)
					{
						gf.playAnim('scared', true);
					}
					else
						gf.dance();
				}
			}
			if (tmr.loopsLeft % boyfriend.danceEveryNumBeats == 0 && boyfriend.animation.curAnim != null && !boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.stunned && !bfDodging)
			{
				boyfriend.dance();
			}
			if (tmr.loopsLeft % dad.danceEveryNumBeats == 0 && dad.animation.curAnim != null && !dad.animation.curAnim.name.startsWith('sing') && !dad.stunned && !dad.animation.curAnim.name.startsWith('punch'))
			{
				dad.dance();
			}
			if (SONG.song.toLowerCase() == 'yuri is a raccoon')
			{
				if (tmr.loopsLeft % dad2.danceEveryNumBeats == 0 && dad2.animation.curAnim != null && !dad2.animation.curAnim.name.startsWith('sing') && !dad2.stunned)
				{
					dad2.dance();
				}
				if (tmr.loopsLeft % dad3.danceEveryNumBeats == 0 && dad3.animation.curAnim != null && !dad3.animation.curAnim.name.startsWith('sing') && !dad3.stunned)
				{
					dad3.dance();
				}
				if (tmr.loopsLeft % boyfriend2.danceEveryNumBeats == 0 && boyfriend2.animation.curAnim != null && !boyfriend2.animation.curAnim.name.startsWith('sing') && !boyfriend2.stunned)
				{
					boyfriend2.dance();
				}
			}

			var antialias:Bool = ClientPrefs.globalAntialiasing;

			var tick:Countdown = THREE;

			if (!noCountdown)
			{
				switch (swagCounter)
				{
					case 0:
						FlxG.sound.play(Paths.sound('intro3' + introSoundsSuffix), 0.6);
						tick = THREE;
					case 1:
						countdownReady = new FlxSprite().loadGraphic(Paths.image('hudFolders/' + pixeltrashPart1 + 'ready' + pixeltrashPart2));
						countdownReady.scrollFactor.set();
						countdownReady.updateHitbox();
						countdownReady.cameras = [camDialogue];
						
						countdownReady.screenCenter();
						countdownReady.antialiasing = antialias;
						add(countdownReady);
						FlxTween.tween(countdownReady, {alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								remove(countdownReady);
								countdownReady.destroy();
							}
						});
						FlxG.sound.play(Paths.sound('intro2' + introSoundsSuffix), 0.6);
						if (ClientPrefs.songBlurb && !skipSongBlurb)
						{
							leCoolSongName();
						}
						tick = TWO;
					case 2:
						countdownSet = new FlxSprite().loadGraphic(Paths.image('hudFolders/' + pixeltrashPart1 + 'set' + pixeltrashPart2));
						countdownSet.scrollFactor.set();
						countdownSet.cameras = [camDialogue];

						countdownSet.screenCenter();
						countdownSet.antialiasing = antialias;
						add(countdownSet);
						FlxTween.tween(countdownSet, {alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								remove(countdownSet);
								countdownSet.destroy();
							}
						});
						FlxG.sound.play(Paths.sound('intro1' + introSoundsSuffix), 0.6);
						tick = ONE;
					case 3:
						countdownGo = new FlxSprite().loadGraphic(Paths.image('hudFolders/' + pixeltrashPart1 + 'go' + pixeltrashPart2));
						countdownGo.scrollFactor.set();
						countdownGo.cameras = [camDialogue];

						countdownGo.screenCenter();
						countdownGo.antialiasing = antialias;
						add(countdownGo);
						FlxTween.tween(countdownGo, {alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								remove(countdownGo);
								countdownGo.destroy();
							}
						});
						FlxG.sound.play(Paths.sound('introGo' + introSoundsSuffix), 0.6);
						tick = GO;
					case 4:
						
				}
			}

			notes.forEachAlive(function(note:Note) {
				note.copyAlpha = false;
				note.alpha = note.multAlpha;
				if(isMiddleScroll && !note.mustPress) 
				{
					note.alpha *= 0.5;
				}
				if (!opponentNoteVisible && !note.mustPress)
				{
					note.alpha = 0;
				}
			});
			stagesFunc(function(stage:BaseStage) stage.countdownTick(tick, swagCounter));

			swagCounter += 1;
		}, 5);
	}

	public function clearNotesBefore(time:Float)
	{
		var i:Int = unspawnNotes.length - 1;
		while (i >= 0) {
			var daNote:Note = unspawnNotes[i];
			if(daNote.strumTime - 500 < time)
			{
				daNote.active = false;
				daNote.visible = false;
				daNote.ignoreNote = true;

				daNote.kill();
				unspawnNotes.remove(daNote);
				daNote.destroy();
			}
			--i;
		}

		i = notes.length - 1;
		while (i >= 0) {
			var daNote:Note = notes.members[i];
			if(daNote.strumTime - 500 < time)
			{
				daNote.active = false;
				daNote.visible = false;
				daNote.ignoreNote = true;

				daNote.kill();
				notes.remove(daNote, true);
				daNote.destroy();
			}
			--i;
		}
	}

	public function setSongTime(time:Float)
	{
		if(time < 0) time = 0;

		FlxG.sound.music.pause();
		vocals.pause();
		playervox.pause();

		FlxG.sound.music.time = time;
		FlxG.sound.music.play();

		vocals.time = time;
		vocals.play();

		playervox.time = time;
		playervox.play();
		Conductor.songPosition = time;
	}

	function startNextDialogue() {
		dialogueCount++;
	}

	function skipDialogue() {
		// Nothing happens here lol...
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		startingSong = false;

		if (dodginTime && !ClientPrefs.getGameplaySetting('botplay', false))
			bfCanDodge = true;
		else
			bfCanDodge = false;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		FlxG.sound.music.onComplete = onSongComplete;
		vocals.play();
		playervox.play();

		if(startOnTime > 0)
		{
			setSongTime(startOnTime - 500);
		}
		startOnTime = 0;

		if(paused) {
			FlxG.sound.music.pause();
			vocals.pause();
			playervox.pause();
		}

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;
		if (curSong.toLowerCase() != 'candy heartz')
		{
			FlxTween.tween(timeBar, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
			FlxTween.tween(timeTxt, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
		}
		
		#if desktop
		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", healthBar.iconP2.getCharacter(), true, songLength);
		#end
	}

	var debugNum:Int = 0;
	private var noteTypeMap:Map<String, Bool> = new Map<String, Bool>();
	private var eventPushedMap:Map<String, Bool> = new Map<String, Bool>();
	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());
		songSpeedType = ClientPrefs.getGameplaySetting('scrolltype','multiplicative');

		switch(songSpeedType)
		{
			case "multiplicative":
				songSpeed = SONG.speed * ClientPrefs.getGameplaySetting('scrollspeed', 1);
			case "constant":
				songSpeed = ClientPrefs.getGameplaySetting('scrollspeed', 1);
		}
		
		var songData = SONG;
		Conductor.changeBPM(songData.bpm);
		
		curSong = songData.song;

		if (SONG.needsVoices)
		{
			vocals = new FlxSound().loadEmbedded(Paths.opponentvoices(PlayState.SONG.song));
			playervox = new FlxSound().loadEmbedded(Paths.playervoices(PlayState.SONG.song));
		}
		else
		{
			vocals = new FlxSound();
			playervox = new FlxSound();
		}

		FlxG.sound.list.add(vocals);
		FlxG.sound.list.add(playervox);
		FlxG.sound.list.add(new FlxSound().loadEmbedded(Paths.inst(PlayState.SONG.song)));

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW trash
		noteData = songData.notes;

		var playerCounter:Int = 0;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped

		var file:String = Paths.json('charts/' + songName + '/events');
		#if sys
		if (FileSystem.exists(file)) 
		{
			var eventsData:Array<Dynamic> = Song.loadFromJson('events', songName).events;
			for (event in eventsData) //Event Notes
			{
				for (i in 0...event[1].length)
				{
					var newEventNote:Array<Dynamic> = [event[0], event[1][i][0], event[1][i][1], event[1][i][2]];
					var subEvent:EventNote = {
						strumTime: newEventNote[0] + ClientPrefs.noteOffset,
						event: newEventNote[1],
						value1: newEventNote[2],
						value2: newEventNote[3]
					};
					subEvent.strumTime -= eventNoteEarlyTrigger(subEvent);
					eventNotes.push(subEvent);
					eventPushed(subEvent);
				}
			}
		}
		#else
		if (OpenFlAssets.exists(file)) 
		{
			var eventsData:Array<Dynamic> = Song.loadFromJson('events', songName).events;
			for (event in eventsData) //Event Notes
			{
				for (i in 0...event[1].length)
				{
					var newEventNote:Array<Dynamic> = [event[0], event[1][i][0], event[1][i][1], event[1][i][2]];
					var subEvent:EventNote = {
						strumTime: newEventNote[0] + ClientPrefs.noteOffset,
						event: newEventNote[1],
						value1: newEventNote[2],
						value2: newEventNote[3]
					};
					subEvent.strumTime -= eventNoteEarlyTrigger(subEvent);
					eventNotes.push(subEvent);
					eventPushed(subEvent);
				}
			}
		}
		#end

		for (section in noteData)
		{
			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);
				swagNote.mustPress = gottaHitNote;
				swagNote.sustainLength = songNotes[2];
				swagNote.gfNote = (section.gfSection && (songNotes[1]<4));
				swagNote.noteType = songNotes[3];
				if(!Std.isOfType(songNotes[3], String)) swagNote.noteType = states.editors.ChartingState.noteTypeList[songNotes[3]]; //Backward compatibility + compatibility with Week 7 charts
				
				swagNote.scrollFactor.set();

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				var floorSus:Int = Math.floor(susLength);
				if(floorSus > 0) {
					for (susNote in 0...floorSus+1)
					{
						oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

						var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + (Conductor.stepCrochet / FlxMath.roundDecimal(songSpeed, 2)), daNoteData, oldNote, true);
						sustainNote.mustPress = gottaHitNote;
						sustainNote.gfNote = (section.gfSection && (songNotes[1]<4));
						sustainNote.noteType = swagNote.noteType;
						sustainNote.scrollFactor.set();
						unspawnNotes.push(sustainNote);

						if (sustainNote.mustPress)
						{
							sustainNote.x += FlxG.width / 2; // general offset
						}
						//else if(ClientPrefs.middleScroll)
						else if (isMiddleScroll)
						{
							sustainNote.x += 310;
							if(daNoteData > 1) //Up and Right
							{
								sustainNote.x += FlxG.width / 2 + 25;
							}
						}
					}
				}

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else if (isMiddleScroll)
				{
					swagNote.x += 310;
					if(daNoteData > 1) //Up and Right
					{
						swagNote.x += FlxG.width / 2 + 25;
					}
				}

				if(!noteTypeMap.exists(swagNote.noteType)) {
					noteTypeMap.set(swagNote.noteType, true);
				}
			}
			daBeats += 1;
		}
		for (event in songData.events) //Event Notes
		{
			for (i in 0...event[1].length)
			{
				var newEventNote:Array<Dynamic> = [event[0], event[1][i][0], event[1][i][1], event[1][i][2]];
				var subEvent:EventNote = {
					strumTime: newEventNote[0] + ClientPrefs.noteOffset,
					event: newEventNote[1],
					value1: newEventNote[2],
					value2: newEventNote[3]
				};
				subEvent.strumTime -= eventNoteEarlyTrigger(subEvent);
				eventNotes.push(subEvent);
				eventPushed(subEvent);
			}
		}

		unspawnNotes.sort(sortBytrash);
		if(eventNotes.length > 1) { //No need to sort if there's a single one or none at all
			eventNotes.sort(sortByTime);
		}
		checkEventNote();
		generatedMusic = true;
	}

	function eventPushed(event:EventNote) {
		switch(event.event) {
			case 'Change Character':
				var charType:Int = 0;
				switch(event.value1.toLowerCase()) {
					case 'gf' | 'girlfriend' | '1':
						charType = 2;
					case 'dad' | 'opponent' | '0':
						charType = 1;
					case 'dad2' | 'opponent2':
						charType = 3;
					case 'dad3' | 'opponent3':
						charType = 4;
					case 'dad4' | 'opponent4':
						charType = 5;
					case 'bf2' | 'player2':
						charType = 6;
					case 'bf3' | 'player3':
						charType = 7;
					case 'bf4' | 'player4':
						charType = 8;
					default:
						charType = Std.parseInt(event.value1);
						if(Math.isNaN(charType)) charType = 0;
				}

				var newCharacter:String = event.value2;
				addCharacterToList(newCharacter, charType);
		}

		stagesFunc(function(stage:BaseStage) stage.eventPushed(event));

		if(!eventPushedMap.exists(event.event)) {
			eventPushedMap.set(event.event, true);
		}
	}

	function eventNoteEarlyTrigger(event:EventNote):Float {
		switch(event.event) {
			case 'Kill Henchmen': //Better timing so that the kill sound matches the beat intended
				return 280; //Plays 280ms before the actual position
		}
		return 0;
	}

	function sortBytrash(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	function sortByTime(Obj1:EventNote, Obj2:EventNote):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	public var skipArrowStartTween:Bool = false;
	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			var targetAlpha:Float = 1;
			if (player < 1 && isMiddleScroll) targetAlpha = 0.35;

			if (player < 1 && !opponentNoteVisible)
				targetAlpha = 0;

			var babyArrow:StrumNote = new StrumNote(isMiddleScroll ? STRUM_X_MIDDLESCROLL : STRUM_X, strumLine.y, i, player);
			babyArrow.downScroll = ClientPrefs.downScroll;
			if (!isStoryMode && !skipArrowStartTween)
			{
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {alpha: targetAlpha}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}
			else
			{
				babyArrow.alpha = targetAlpha;
			}

			if (player == 1)
			{
				playerStrums.add(babyArrow);
			}
			else
			{
				if (isMiddleScroll)
				{
					babyArrow.x += 310;
					if(i > 1) { //Up and Right
						babyArrow.x += FlxG.width / 2 + 25;
					}
				}
				opponentStrums.add(babyArrow);
			}

			strumLineNotes.add(babyArrow);
			babyArrow.postAddedToGroup();
		}
	}

	override function openSubState(SubState:FlxSubState)
	{
		stagesFunc(function(stage:BaseStage) stage.openSubState(SubState));
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
				playervox.pause();
			}

			for (video in members)
			{
				var video:Dynamic = video;
				var video:VideoSprite = video;
	
				if (video != null && video is VideoSprite)
					video.bitmap.pause();
			}

			if (startTimer != null && !startTimer.finished)
				startTimer.active = false;
			if (finishTimer != null && !finishTimer.finished)
				finishTimer.active = false;
			if (songSpeedTween != null)
				songSpeedTween.active = false;

			var chars:Array<Character> = [boyfriend, gf, dad];
			for (char in chars) {
				if(char != null && char.colorTween != null) {
					char.colorTween.active = false;
				}
			}
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		stagesFunc(function(stage:BaseStage) stage.closeSubState());
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			for (video in members)
			{
				var video:Dynamic = video;
				var video:VideoSprite = video;
	
				if (video != null && video is VideoSprite)
					video.bitmap.resume();
			}

			if (startTimer != null && !startTimer.finished)
				startTimer.active = true;
			if (finishTimer != null && !finishTimer.finished)
				finishTimer.active = true;
			if (songSpeedTween != null)
				songSpeedTween.active = true;

			var chars:Array<Character> = [boyfriend, gf, dad];
			for (char in chars) {
				if(char != null && char.colorTween != null) {
					char.colorTween.active = true;
				}
			}
			
			paused = false;

			#if desktop
			if (startTimer != null && startTimer.finished)
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", healthBar.iconP2.getCharacter(), true, songLength - Conductor.songPosition - ClientPrefs.noteOffset);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", healthBar.iconP2.getCharacter());
			}
			#end
		}

		super.closeSubState();
	}

	override public function onFocus():Void
	{
		#if desktop
		if (health > 0 && !paused)
		{
			if (Conductor.songPosition > 0.0)
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", healthBar.iconP2.getCharacter(), true, songLength - Conductor.songPosition - ClientPrefs.noteOffset);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", healthBar.iconP2.getCharacter());
			}
		}
		#end

		super.onFocus();
	}
	
	override public function onFocusLost():Void
	{
		#if desktop
		if (health > 0 && !paused)
		{
			DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", healthBar.iconP2.getCharacter());
		}
		#end

		super.onFocusLost();
	}

	function resyncVocals():Void
	{
		if(finishTimer != null) return;

		vocals.pause();
		playervox.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();
		playervox.time = Conductor.songPosition;
		playervox.play();
	}

	public var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;
	var limoSpeed:Float = 0;

	override public function update(elapsed:Float)
	{
		floatTrash += 0.1;

		dadChar = dad.curCharacter;
		bfChar = boyfriend.curCharacter;
		if (gf != null)
			gfChar = gf.curCharacter;

		if (songName == 'system-failure') gf.color = 0x824444;
			
		if(interlopeTweenThing)
		{
			if (downOnUp)
			{
				playerStrums.members[1].x = playerStrums.members[0].x - 112;
				playerStrums.members[2].x = playerStrums.members[1].x - 112;
				playerStrums.members[3].x = playerStrums.members[2].x - 112;
			}
			else
			{
				playerStrums.members[1].x = playerStrums.members[0].x + 112;
				playerStrums.members[2].x = playerStrums.members[1].x + 112;
				playerStrums.members[3].x = playerStrums.members[2].x + 112;
			}
		}

		switch (boyfriend.curCharacter)
		{
			case 'jr':
				GameOverSubstate.deathSoundName = 'gameOvers/fnf_loss_sfx-jr';
				GameOverSubstate.characterName = 'jr-dead';
				GameOverSubstate.loopSoundName = 'gameOvers/NormalGameOver';
				GameOverSubstate.endSoundName = 'gameOvers/NormalGameOverEnd';
				ResultsScreen.customSprString = 'JR';
			case 'monika':
				GameOverSubstate.deathSoundName = 'gameOvers/fnf_loss_sfx-monika';
				GameOverSubstate.characterName = 'monika-dead';
				GameOverSubstate.loopSoundName = 'gameOvers/NormalGameOver';
				GameOverSubstate.endSoundName = 'gameOvers/NormalGameOverEnd';
				ResultsScreen.customSprString = 'MONI';
			case 'bf-angry':
				GameOverSubstate.deathSoundName = 'gameOvers/fnf_loss_sfx';
				GameOverSubstate.characterName = 'bf-dead';
				GameOverSubstate.loopSoundName = 'gameOvers/AngryGameOver';
				GameOverSubstate.endSoundName = 'gameOvers/AngryGameOverEnd';
				ResultsScreen.customSprString = 'BF';
			case 'jr-angry':
				GameOverSubstate.deathSoundName = 'gameOvers/fnf_loss_sfx-jr';
				GameOverSubstate.characterName = 'jr-dead';
				GameOverSubstate.loopSoundName = 'gameOvers/AngryGameOver';
				GameOverSubstate.endSoundName = 'gameOvers/AngryGameOverEnd';
				ResultsScreen.customSprString = 'JR';
			case 'monika-neo':
				GameOverSubstate.deathSoundName = 'gameOvers/fnf_loss_sfx-monika-angry';
				GameOverSubstate.characterName = 'monika-neo-dead';
				GameOverSubstate.loopSoundName = 'gameOvers/AngryGameOver';
				GameOverSubstate.endSoundName = 'gameOvers/AngryGameOverEnd';
				ResultsScreen.customSprString = 'MONI';
			case 'monika-neo-mk2':
				GameOverSubstate.deathSoundName = 'gameOvers/fnf_loss_sfx-monika-angry';
				GameOverSubstate.characterName = 'monika-neo-mk2-dead';
				GameOverSubstate.loopSoundName = 'gameOvers/AngryGameOver';
				GameOverSubstate.endSoundName = 'gameOvers/AngryGameOverEnd';
				ResultsScreen.customSprString = 'MONI';
			case 'bf-gone':
				GameOverSubstate.deathSoundName = 'gameOvers/fnf_loss_sfx-player';
				GameOverSubstate.characterName = 'player-dead';
				GameOverSubstate.loopSoundName = 'gameOvers/PlayerGameOver';
				GameOverSubstate.endSoundName = 'gameOvers/PlayerGameOverEnd';
				ResultsScreen.customSprString = 'BLANK';
			case 'mer-bf':
				GameOverSubstate.deathSoundName = 'gameOvers/fnf_loss_sfx-spider';
				GameOverSubstate.characterName = 'mer-bf';
				GameOverSubstate.loopSoundName = 'gameOvers/NormalGameOver';
				GameOverSubstate.endSoundName = 'gameOvers/NormalGameOverEnd';
				ResultsScreen.customSprString = 'BF';
			case 'stuck-bf':
				GameOverSubstate.deathSoundName = 'gameOvers/fnf_loss_sfx-spider';
				GameOverSubstate.characterName = 'stuck-bf-dead';
				GameOverSubstate.loopSoundName = 'gameOvers/SpiderGameOver';
				GameOverSubstate.endSoundName = 'gameOvers/SpiderGameOverEnd';
				ResultsScreen.customSprString = 'BF';
			case 'bf-x' | 'bf-scared-x':
				GameOverSubstate.deathSoundName = 'gameOvers/fnf_loss_sfx-x';
				GameOverSubstate.characterName = 'bf-x-dead';
				GameOverSubstate.loopSoundName = 'gameOvers/NormalGameOver';
				GameOverSubstate.endSoundName = 'gameOvers/NormalGameOverEnd';
				ResultsScreen.customSprString = 'BF';
			case 'jr-x':
				GameOverSubstate.deathSoundName = 'gameOvers/fnf_loss_sfx-x';
				GameOverSubstate.characterName = 'jr-x-dead';
				GameOverSubstate.loopSoundName = 'gameOvers/NormalGameOver';
				GameOverSubstate.endSoundName = 'gameOvers/NormalGameOverEnd';
				ResultsScreen.customSprString = 'JR';
			case 'monika-x':
				GameOverSubstate.deathSoundName = 'gameOvers/fnf_loss_sfx-x';
				GameOverSubstate.characterName = 'monika-x-dead';
				GameOverSubstate.loopSoundName = 'gameOvers/NormalGameOver';
				GameOverSubstate.endSoundName = 'gameOvers/NormalGameOverEnd';
				ResultsScreen.customSprString = 'MONI';
			case 'bf-angry-x':
				GameOverSubstate.deathSoundName = 'gameOvers/fnf_loss_sfx-x';
				GameOverSubstate.characterName = 'bf-x-dead';
				GameOverSubstate.loopSoundName = 'gameOvers/AngryGameOver';
				GameOverSubstate.endSoundName = 'gameOvers/AngryGameOverEnd';
				ResultsScreen.customSprString = 'BF';
			case 'jr-angry-x':
				GameOverSubstate.deathSoundName = 'gameOvers/fnf_loss_sfx-x';
				GameOverSubstate.characterName = 'jr-x-dead';
				GameOverSubstate.loopSoundName = 'gameOvers/AngryGameOver';
				GameOverSubstate.endSoundName = 'gameOvers/AngryGameOverEnd';
				ResultsScreen.customSprString = 'JR';
			case 'bf-pixel':
				GameOverSubstate.deathSoundName = 'gameOvers/fnf_loss_sfx-pixel';
				GameOverSubstate.characterName = 'bf-pixel-dead';
				GameOverSubstate.loopSoundName = 'gameOvers/PixelGameOver';
				GameOverSubstate.endSoundName = 'gameOvers/PixelGameOverEnd';
				ResultsScreen.customSprString = 'BF';
			case 'jr-pixel':
				GameOverSubstate.deathSoundName = 'gameOvers/fnf_loss_sfx-jr-pixel';
				GameOverSubstate.characterName = 'jr-pixel-dead';
				GameOverSubstate.loopSoundName = 'gameOvers/PixelGameOver';
				GameOverSubstate.endSoundName = 'gameOvers/PixelGameOverEnd';
				ResultsScreen.customSprString = 'JR';
			case 'monika-pixel':
				GameOverSubstate.deathSoundName = 'gameOvers/fnf_loss_sfx-monika-pixel';
				GameOverSubstate.characterName = 'monika-pixel-dead';
				GameOverSubstate.loopSoundName = 'gameOvers/PixelGameOver';
				GameOverSubstate.endSoundName = 'gameOvers/PixelGameOverEnd';
				ResultsScreen.customSprString = 'MONI';
			case 'monika_ddto' | 'sayori_ddto' | 'yuri_ddto' | 'natsuki_ddto':
				GameOverSubstate.deathSoundName = 'gameOvers/fnf_loss_sfx-ddto';
				GameOverSubstate.characterName = 'ddto_gameover';
				GameOverSubstate.loopSoundName = 'gameOvers/ddtoGameOver';
				GameOverSubstate.endSoundName = 'gameOvers/ddtoGameOverEnd';
				ResultsScreen.customSprString = 'MONI';
			case 'monika_moniexe' | 'sayori_ddto-be' | 'yuri_fnf-x-ddlc' | 'natsuki_sayo-notebook':
				GameOverSubstate.deathSoundName = 'gameOvers/fnf_loss_sfx-ddto';
				GameOverSubstate.characterName = 'ddto_gameover';
				GameOverSubstate.loopSoundName = 'gameOvers/DokiverseGameOver';
				GameOverSubstate.endSoundName = 'gameOvers/DokiverseGameOverEnd';
				ResultsScreen.customSprString = 'MONI';
			case 'bf-kart':
				GameOverSubstate.deathSoundName = 'gameOvers/fnf_loss_sfx-mkt';
				GameOverSubstate.characterName = 'bf-kart-dead';
				GameOverSubstate.loopSoundName = 'gameOvers/mktGameOver';
				GameOverSubstate.endSoundName = 'gameOvers/mktGameOverEnd';
				ResultsScreen.customSprString = 'BF';
			default:
				GameOverSubstate.deathSoundName = 'gameOvers/fnf_loss_sfx';
				GameOverSubstate.characterName = 'bf-dead';
				GameOverSubstate.loopSoundName = 'gameOvers/NormalGameOver';
				GameOverSubstate.endSoundName = 'gameOvers/NormalGameOverEnd';
				ResultsScreen.customSprString = 'BF';
		}
		switch (SONG.song.toLowerCase())
		{
			case 'roar of natsuki' | 'festival deluxe':
				GameOverSubstate.loopSoundName = 'gameOvers/AngryGameOver';
				GameOverSubstate.endSoundName = 'gameOvers/AngryGameOverEnd';
		}

		if (staticlol != null)
			staticlol.alpha.value = [staticAlpha];

		if (camGame.filtersEnabled)
			shader0.setFloat('iTime', FlxG.random.int(1, 129));

		if(!inCutscene) {
			var lerpVal:Float = CoolUtil.boundTo(elapsed * 2.4 * cameraSpeed, 0, 1);
			camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));
			if(!startingSong && !endingSong && boyfriend.animation.curAnim.name.startsWith('idle')) {
				boyfriendIdleTime += elapsed;
				if(boyfriendIdleTime >= 0.15) { // Kind of a mercy thing for making the achievement easier to get as it's apparently frustrating to some playerss
					boyfriendIdled = true;
				}
			} else {
				boyfriendIdleTime = 0;
			}
		}

		super.update(elapsed);

		if (isStoryMode)
		{
			scoreTxt.text = 'Score: ' + songScore
			+ ' | Misses: ' + songMisses
			+ ' | Rank: ' + ratingName
			+ (ratingName != '?' ? ' (${Highscore.floorDecimal(ratingPercent * 100, 0)}%) - $ratingFC' : '');
		}
		else
		{
			scoreTxt.text = 'Score: ' + songScore
			+ ' | Misses: ' + songMisses
			+ ' | Accuracy: ' + (ratingName != '?' ? '${Highscore.floorDecimal(ratingPercent * 100, 0)}% - $ratingFC' : '?');
		}
		missTxt.text = 'Misses: ' + songMisses + '/70';
		if (songMisses >= 70) missTxt.color = FlxColor.RED;

		if(botplaySpr.visible) {
			botplaySine += 180 * elapsed;
			botplaySpr.alpha = 1 - Math.sin((Math.PI * botplaySine) / 180);
		}

		if(practiceSpr.visible) {
			practiceSine += 180 * elapsed;
			practiceSpr.alpha = 1 - Math.sin((Math.PI * practiceSine) / 180);
		}

		if (controls.PAUSE && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			if(FlxG.sound.music != null) {
				FlxG.sound.music.pause();
				vocals.pause();
				playervox.pause();
			}
			openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		
			#if desktop
			DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", healthBar.iconP2.getCharacter());
			#end
		}

		if (FlxG.keys.anyJustPressed(debugKeysChart) && !endingSong && !inCutscene)
		{
			#if debug
			openChartEditor();
			#else
			openSubState(new CustomFadeTransition(0.4, false, new AntiCheatState()));
			//MusicBeatState.switchState(new AntiCheatState());
			#end
		}

		switch (boyfriend.curCharacter)
		{
			case 'mer-bf' | 'mer-bf-x':
				bfFloating = true;
			default:
				bfFloating = false;
		}
		switch (dad.curCharacter)
		{
			case 'bee-sayori' | 'ghost-sayori' | 'squid-monika':
				dadFloating = true;
			default:
				dadFloating = false;
		}

		if (bfFloating && !endingSong)
		{
			boyfriend.y += Math.sin(floatTrash);
		}

		if (dadFloating && !endingSong)
		{
			dad.y += Math.sin(floatTrash);
		}

		if (health > 2) health = 2;
		if (health < 0) health = 0;

		healthPercent = Std.int((health / 2) * 100);
		healthBar.updateBar(healthPercent);

		if (healthPercent < 20) healthBar.iconsAnim('lose')
		else if (healthPercent >= 20 && healthPercent <= 80) healthBar.iconsAnim();
		else if (healthPercent > 80) healthBar.iconsAnim('win');

		#if debug
		if (FlxG.keys.anyJustPressed(debugKeysCharacter) && !endingSong && !inCutscene) {
			persistentUpdate = false;
			paused = true;
			cancelMusicFadeTween();
			openSubState(new CustomFadeTransition(0.4, false, new CharacterEditorState(SONG.player2)));
		}
		#end

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			Conductor.songPosition += FlxG.elapsed * 1000;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
				}

				if(updateTime) {
					var nameOfSong:String = SONG.song;

					var curTime:Float = Conductor.songPosition - ClientPrefs.noteOffset;
					if(curTime < 0) curTime = 0;
					songPercent = (curTime / songLength);

					var songCalc:Float = (songLength - curTime);
					switch (nameOfSong)
					{
						case 'Hxppy Thxughts':
							songLength = 174939;
						case 'Cxnnamon Bxn':
							songLength = 126856;
						case 'Pale':
							songLength = 92996;
						case 'Yandere':
							songLength = 152723;
						case 'System Failure':
							songLength = 99999999;
						case 'Roar Of Natsuki':
							if (!ppMusic) songLength = 153658;
							else songLength = FlxG.sound.music.length;
					}
					if(ClientPrefs.timeBarType == 'Time Elapsed') songCalc = curTime;

					var secondsTotal:Int = Math.floor(songCalc / 1000);
					if(secondsTotal < 0) secondsTotal = 0;

					var totalTime:Int = Math.floor(songLength / 1000);
					var timeElapsed:Int = Math.floor(curTime / 1000);
					if(timeElapsed < 0) timeElapsed = 0;

					if(ClientPrefs.timeBarType != 'Song Name')
					{
						if (nameOfSong != 'System Failure') timeTxt.text = FlxStringUtil.formatTime(secondsTotal, false);
						else {
							if (ClientPrefs.timeBarType == 'Time Elapsed') timeTxt.text = '-Infinity';
							else timeTxt.text = 'Infinity';
						}
					}
				}
			}
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, CoolUtil.boundTo(1 - (elapsed * 3.125), 0, 1));
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, CoolUtil.boundTo(1 - (elapsed * 3.125), 0, 1));
		}

		FlxG.watch.addQuick("beattrash", curBeat);
		FlxG.watch.addQuick("steptrash", curStep);

		// RESET = Quick Game Over Screen
		if (!ClientPrefs.noReset && controls.RESET && !inCutscene && !endingSong)
		{
			health = 0;
			trace("RESET = True");
		}
		doDeathCheck();

		if (unspawnNotes[0] != null)
		{
			var time:Float = 3000;//trash be werid on 4:3
			if(songSpeed < 1) time /= songSpeed;

			while (unspawnNotes.length > 0 && unspawnNotes[0].strumTime - Conductor.songPosition < time)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.insert(0, dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
		{
			if (!inCutscene) {
				if(!cpuControlled) 
				{
					keytrash();
				} 
				else 
				{
					if(boyfriend.holdTimer > Conductor.stepCrochet * 0.001 * boyfriend.singDuration && boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss') && !bfDodging)
						boyfriend.dance();
					if(boyfriend2 != null && boyfriend2.holdTimer > Conductor.stepCrochet * 0.001 * boyfriend2.singDuration && boyfriend2.animation.curAnim.name.startsWith('sing') && !boyfriend2.animation.curAnim.name.endsWith('miss'))
						boyfriend2.dance();
					if(boyfriend3 != null && boyfriend3.holdTimer > Conductor.stepCrochet * 0.001 * boyfriend3.singDuration && boyfriend3.animation.curAnim.name.startsWith('sing') && !boyfriend3.animation.curAnim.name.endsWith('miss'))
						boyfriend3.dance();
					if(boyfriend4 != null && boyfriend4.holdTimer > Conductor.stepCrochet * 0.001 * boyfriend4.singDuration && boyfriend4.animation.curAnim.name.startsWith('sing') && !boyfriend4.animation.curAnim.name.endsWith('miss'))
						boyfriend4.dance();
				}
			}

			var fakeCrochet:Float = (60 / SONG.bpm) * 1000;
			notes.forEachAlive(function(daNote:Note)
			{
				var strumGroup:FlxTypedGroup<StrumNote> = playerStrums;
				if(!daNote.mustPress) strumGroup = opponentStrums;

				var strumX:Float = strumGroup.members[daNote.noteData].x;
				var strumY:Float = strumGroup.members[daNote.noteData].y;
				var strumAngle:Float = strumGroup.members[daNote.noteData].angle;
				var strumDirection:Float = strumGroup.members[daNote.noteData].direction;
				var strumAlpha:Float = strumGroup.members[daNote.noteData].alpha;
				var strumScroll:Bool = strumGroup.members[daNote.noteData].downScroll;

				strumX += daNote.offsetX;
				strumY += daNote.offsetY;
				strumAngle += daNote.offsetAngle;
				strumAlpha *= daNote.multAlpha;

				if (strumScroll) //Downscroll
				{
					//daNote.y = (strumY + 0.45 * (Conductor.songPosition - daNote.strumTime) * songSpeed);
					daNote.distance = (0.45 * (Conductor.songPosition - daNote.strumTime) * songSpeed);
				}
				else //Upscroll
				{
					//daNote.y = (strumY - 0.45 * (Conductor.songPosition - daNote.strumTime) * songSpeed);
					daNote.distance = (-0.45 * (Conductor.songPosition - daNote.strumTime) * songSpeed);
				}

				var angleDir = strumDirection * Math.PI / 180;
				if (daNote.copyAngle)
					daNote.angle = strumDirection - 90 + strumAngle;

				if(daNote.copyAlpha)
					daNote.alpha = strumAlpha;
				
				if(daNote.copyX)
					daNote.x = strumX + Math.cos(angleDir) * daNote.distance;

				if(daNote.copyY)
				{
					daNote.y = strumY + Math.sin(angleDir) * daNote.distance;

					//Jesus fuck this took me so much mother fucking time AAAAAAAAAA
					if(strumScroll && daNote.isSustainNote)
					{
						if (daNote.animation.curAnim.name.endsWith('end')) {
							daNote.y += 10.5 * (fakeCrochet / 400) * 1.5 * songSpeed + (46 * (songSpeed - 1));
							daNote.y -= 46 * (1 - (fakeCrochet / 600)) * songSpeed;
							daNote.y -= 19;
						} 
						daNote.y += (Note.swagWidth / 2) - (60.5 * (songSpeed - 1));
						daNote.y += 27.5 * ((SONG.bpm / 100) - 1) * (songSpeed - 1);
					}
				}

				if (!daNote.mustPress && daNote.wasGoodHit && !daNote.hitByOpponent && !daNote.ignoreNote)
				{
					opponentNoteHit(daNote);
				}

				if(!daNote.blockHit && daNote.mustPress && cpuControlled && daNote.canBeHit) {
					if(daNote.isSustainNote) {
						if(daNote.canBeHit) {
							goodNoteHit(daNote);
						}
					} else if(daNote.strumTime <= Conductor.songPosition || (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress)) {
						goodNoteHit(daNote);
					}
				}
				
				var center:Float = strumY + Note.swagWidth / 2;
				if(strumGroup.members[daNote.noteData].sustainReduce && daNote.isSustainNote && (daNote.mustPress || !daNote.ignoreNote) &&
					(!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
				{
					if (strumScroll)
					{
						if(daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= center)
						{
							var swagRect = new FlxRect(0, 0, daNote.frameWidth, daNote.frameHeight);
							swagRect.height = (center - daNote.y) / daNote.scale.y;
							swagRect.y = daNote.frameHeight - swagRect.height;

							daNote.clipRect = swagRect;
						}
					}
					else
					{
						if (daNote.y + daNote.offset.y * daNote.scale.y <= center)
						{
							var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
							swagRect.y = (center - daNote.y) / daNote.scale.y;
							swagRect.height -= swagRect.y;

							daNote.clipRect = swagRect;
						}
					}
				}

				// Kill extremely late notes and cause misses
				if (Conductor.songPosition > noteKillOffset + daNote.strumTime)
				{
					if (daNote.mustPress && !cpuControlled &&!daNote.ignoreNote && !endingSong && (daNote.tooLate || !daNote.wasGoodHit)) {
						noteMiss(daNote);
					}

					daNote.active = false;
					daNote.visible = false;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			});
		}
		checkEventNote();
		
		#if debug
		if(!endingSong && !startingSong) {
			if (FlxG.keys.justPressed.ONE) {
				KillNotes();
				FlxG.sound.music.onComplete();
			}
			if(FlxG.keys.justPressed.TWO) { //Go 10 seconds into the future :O
				setSongTime(Conductor.songPosition + 10000);
				clearNotesBefore(Conductor.songPosition);
			}
		}
		#end

		if (dad.curCharacter == 'yurdere')
		{
			if (dad.animation.curAnim.name == 'knife' && dad.animation.curAnim.finished) {
				dad.playAnim('knife-loop');
			}
			if (dad.animation.curAnim.name == 'laugh' && dad.animation.curAnim.finished) {
				dad.playAnim('laugh-loop');
			}
			if (dad.animation.curAnim.name == 'pre-stab' && dad.animation.curAnim.finished) {
				dad.playAnim('stab');
			}
			if (dad.animation.curAnim.name == 'stab' && dad.animation.curAnim.finished) {
				dad.playAnim('stab-loop');
			}
			if (dad.animation.curAnim.name == 'killed' && dad.animation.curAnim.finished) {
				dad.playAnim('killed-loop');
			}
		}
	}

	function openChartEditor()
	{
		persistentUpdate = false;
		paused = true;
		cancelMusicFadeTween();
		openSubState(new CustomFadeTransition(0.4, false, new ChartingState()));
		//MusicBeatState.switchState(new ChartingState());
		chartingMode = true;

		#if desktop
		DiscordClient.changePresence("Chart Editor", null, null, true);
		#end
	}

	public var isDead:Bool = false; //Don't mess with this!!!
	function doDeathCheck(?skipHealthCheck:Bool = false) {
		if (((skipHealthCheck && instakillOnMiss) || health <= 0) && !practiceMode && !isDead)
		{
			boyfriend.stunned = true;
			deathCounter++;

			paused = true;

			vocals.stop();
			playervox.stop();
			FlxG.sound.music.stop();

			persistentUpdate = false;
			persistentDraw = false;
				
			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x - boyfriend.positionArray[0], boyfriend.getScreenPosition().y - boyfriend.positionArray[1], camFollowPos.x, camFollowPos.y));
				
			#if desktop
			// Game Over doesn't get his own variable because it's only used here
			DiscordClient.changePresence("Game Over - " + detailsText, SONG.song + " (" + storyDifficultyText + ")", healthBar.iconP2.getCharacter());
			#end
			isDead = true;
			return true;
		}
		return false;
	}

	public function checkEventNote() {
		while(eventNotes.length > 0) {
			var leStrumTime:Float = eventNotes[0].strumTime;
			if(Conductor.songPosition < leStrumTime) {
				break;
			}

			var value1:String = '';
			if(eventNotes[0].value1 != null)
				value1 = eventNotes[0].value1;

			var value2:String = '';
			if(eventNotes[0].value2 != null)
				value2 = eventNotes[0].value2;

			triggerEventNote(eventNotes[0].event, value1, value2);
			eventNotes.shift();
		}
	}

	public function getControl(key:String) {
		var pressed:Bool = Reflect.getProperty(controls, key);
		//trace('Control result: ' + pressed);
		return pressed;
	}

	public function triggerEventNote(eventName:String, value1:String = '', value2:String = '') {
		switch(eventName) {
			case 'Hey!':
				var value:Int = 2;
				switch(value1.toLowerCase().trim()) {
					case 'bf' | 'boyfriend' | '0':
						value = 0;
					case 'gf' | 'girlfriend' | '1':
						value = 1;
				}

				var time:Float = Std.parseFloat(value2);
				if(Math.isNaN(time) || time <= 0) time = 0.6;

				if(value != 0) {
					if(dad.curCharacter.startsWith('gf')) { //Tutorial GF is actually Dad! The GF is an imposter!! ding ding ding ding ding ding ding, dindinding, end my suffering
						dad.playAnim('cheer', true);
						dad.specialAnim = true;
						dad.heyTimer = time;
					} else if (gf != null) {
						gf.playAnim('cheer', true);
						gf.specialAnim = true;
						gf.heyTimer = time;
					}
				}
				if(value != 1) {
					boyfriend.playAnim('hey', true);
					boyfriend.specialAnim = true;
					boyfriend.heyTimer = time;
				}

			case 'Set GF Speed':
				var value:Int = Std.parseInt(value1);
				if(Math.isNaN(value) || value < 1) value = 1;
				gfSpeed = value;

			case 'Add Camera Zoom':
				if(ClientPrefs.camZooms && FlxG.camera.zoom < 1.35) {
					var camZoom:Float = Std.parseFloat(value1);
					var hudZoom:Float = Std.parseFloat(value2);
					if(Math.isNaN(camZoom)) camZoom = 0.015;
					if(Math.isNaN(hudZoom)) hudZoom = 0.03;

					FlxG.camera.zoom += camZoom;
					camHUD.zoom += hudZoom;
				}

			case 'Play Animation':
				//trace('Anim to play: ' + value1);
				var char:Character = dad;
				switch(value2.toLowerCase().trim()) {
					case 'bf' | 'boyfriend':
						char = boyfriend;
					case 'gf' | 'girlfriend':
						char = gf;
					default:
						var val2:Int = Std.parseInt(value2);
						if(Math.isNaN(val2)) val2 = 0;
		
						switch(val2) {
							case 1: char = boyfriend;
							case 2: char = gf;
						}
				}

				if (char != null)
				{
					char.playAnim(value1, true);
					char.specialAnim = true;
				}

			case 'Camera Follow Pos':
				var val1:Float = Std.parseFloat(value1);
				var val2:Float = Std.parseFloat(value2);
				if(Math.isNaN(val1)) val1 = 0;
				if(Math.isNaN(val2)) val2 = 0;

				isCameraOnForcedPos = false;
				if(!Math.isNaN(Std.parseFloat(value1)) || !Math.isNaN(Std.parseFloat(value2))) {
					camFollow.x = val1;
					camFollow.y = val2;
					isCameraOnForcedPos = true;
				}

			case 'Adv. Camera Follow':
				var val1:String = value1.toLowerCase();
				var val2:Float = Std.parseFloat(value2);
				//if(val1 != 'dad' && val1 != 'gf' && val1 != 'bf') val1 = '';
				if(Math.isNaN(val2)) val2 = stageData.camera_speed;
				if (val1 == 'gf' && gf == null) val1 = '';

				isCameraOnForcedPos = false;
				if (val1 == 'dad') {
					camFollow.set(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
					camFollow.x += dad.cameraPosition[0] + opponentCameraOffset[0];
					camFollow.y += dad.cameraPosition[1] + opponentCameraOffset[1];
					isCameraOnForcedPos = true;
				}
				else if (val1 == 'gf')
				{
					camFollow.set(gf.getMidpoint().x, gf.getMidpoint().y);
					camFollow.x += gf.cameraPosition[0] + girlfriendCameraOffset[0];
					camFollow.y += gf.cameraPosition[1] + girlfriendCameraOffset[1];
					isCameraOnForcedPos = true;
				}
				else if (val1 == 'bf')
				{
					camFollow.set(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);
					camFollow.x -= boyfriend.cameraPosition[0] - boyfriendCameraOffset[0];
					camFollow.y += boyfriend.cameraPosition[1] + boyfriendCameraOffset[1];
					isCameraOnForcedPos = true;
				}
				cameraSpeed = val2;

			case 'Alt Idle Animation':
				var char:Character = dad;
				switch(value1.toLowerCase()) {
					case 'gf' | 'girlfriend':
						char = gf;
					case 'boyfriend' | 'bf':
						char = boyfriend;
					default:
						var val:Int = Std.parseInt(value1);
						if(Math.isNaN(val)) val = 0;

						switch(val) {
							case 1: char = boyfriend;
							case 2: char = gf;
						}
				}

				if (char != null)
				{
					char.idleSuffix = value2;
					char.recalculateDanceIdle();
				}

			case 'Screen Shake':
				var valuesArray:Array<String> = [value1, value2];
				var targetsArray:Array<FlxCamera> = [camGame, camHUD];
				for (i in 0...targetsArray.length) {
					var split:Array<String> = valuesArray[i].split(',');
					var duration:Float = 0;
					var intensity:Float = 0;
					if(split[0] != null) duration = Std.parseFloat(split[0].trim());
					if(split[1] != null) intensity = Std.parseFloat(split[1].trim());
					if(Math.isNaN(duration)) duration = 0;
					if(Math.isNaN(intensity)) intensity = 0;

					if(duration > 0 && intensity != 0) {
						targetsArray[i].shake(intensity, duration);
					}
				}


			case 'Change Character':
				var charType:Int = 0;
				switch(value1) {
					case 'gf' | 'girlfriend':
						charType = 2;
					case 'dad' | 'opponent':
						charType = 1;
					case 'dad2' | 'opponent2':
						charType = 3;
					case 'dad3' | 'opponent3':
						charType = 4;
					case 'dad4' | 'opponent4':
						charType = 5;
					case 'bf2' | 'player2':
						charType = 6;
					case 'bf3' | 'player3':
						charType = 7;
					case 'bf4' | 'player4':
						charType = 8;
					default:
						charType = Std.parseInt(value1);
						if(Math.isNaN(charType)) charType = 0;
				}

				switch(charType) {
					case 0:
						if(boyfriend.curCharacter != value2) {
							if(!boyfriendMap.exists(value2)) {
								addCharacterToList(value2, charType);
							}

							var lastAlpha:Float = boyfriend.alpha;
							boyfriend.alpha = 0.00001;
							boyfriend = boyfriendMap.get(value2);
							boyfriend.alpha = lastAlpha;
							healthBar.changeIcon(1, boyfriend.healthIcon);
						}

					case 1:
						if(dad.curCharacter != value2) {
							if(!dadMap.exists(value2)) {
								addCharacterToList(value2, charType);
							}

							var wasGf:Bool = dad.curCharacter.startsWith('gf');
							var lastAlpha:Float = dad.alpha;
							dad.alpha = 0.00001;
							dad = dadMap.get(value2);
							if(!dad.curCharacter.startsWith('gf')) {
								if(wasGf && gf != null) {
									gf.visible = true;
								}
							} else if(gf != null) {
								gf.visible = false;
							}
							dad.alpha = lastAlpha;
							healthBar.changeIcon(2, dad.healthIcon);
						}

					case 2:
						if(gf != null)
						{
							if(gf.curCharacter != value2)
							{
								if(!gfMap.exists(value2))
								{
									addCharacterToList(value2, charType);
								}

								var lastAlpha:Float = gf.alpha;
								gf.alpha = 0.00001;
								gf = gfMap.get(value2);
								gf.alpha = lastAlpha;
							}
						}

					case 3:
						if(dad2.curCharacter != value2) {
							if(!dad2Map.exists(value2)) {
								addCharacterToList(value2, charType);
							}

							var lastAlpha:Float = dad2.alpha;
							dad2.alpha = 0.00001;
							dad2 = dad2Map.get(value2);
							dad2.alpha = lastAlpha;
						}

					case 4:
						if(dad3.curCharacter != value2) {
							if(!dad3Map.exists(value2)) {
								addCharacterToList(value2, charType);
							}
	
							var lastAlpha:Float = dad3.alpha;
							dad3.alpha = 0.00001;
							dad3 = dad3Map.get(value2);
							dad3.alpha = lastAlpha;
						}

					case 5:
						if(dad4.curCharacter != value2) {
							if(!dad4Map.exists(value2)) {
								addCharacterToList(value2, charType);
							}
	
							var lastAlpha:Float = dad4.alpha;
							dad4.alpha = 0.00001;
							dad4 = dad4Map.get(value2);
							dad4.alpha = lastAlpha;
						}

					case 6:
						if(boyfriend2.curCharacter != value2) {
							if(!boyfriend2Map.exists(value2)) {
								addCharacterToList(value2, charType);
							}

							var lastAlpha:Float = boyfriend2.alpha;
							boyfriend2.alpha = 0.00001;
							boyfriend2 = boyfriend2Map.get(value2);
							boyfriend2.alpha = lastAlpha;
						}

					case 7:
						if(boyfriend3.curCharacter != value2) {
							if(!boyfriend3Map.exists(value2)) {
								addCharacterToList(value2, charType);
							}

							var lastAlpha:Float = boyfriend3.alpha;
							boyfriend3.alpha = 0.00001;
							boyfriend3 = boyfriend3Map.get(value2);
							boyfriend3.alpha = lastAlpha;
						}

					case 8:
						if(boyfriend4.curCharacter != value2) {
							if(!boyfriend4Map.exists(value2)) {
								addCharacterToList(value2, charType);
							}

							var lastAlpha:Float = boyfriend4.alpha;
							boyfriend4.alpha = 0.00001;
							boyfriend4 = boyfriend4Map.get(value2);
							boyfriend4.alpha = lastAlpha;
						}
				}
				healthBar.reloadHealthBarColors(boyfriend.healthColorArray, dad.healthColorArray);
			
			case 'Change Scroll Speed':
				if (songSpeedType == "constant")
					return;
				var val1:Float = Std.parseFloat(value1);
				var val2:Float = Std.parseFloat(value2);
				if(Math.isNaN(val1)) val1 = 1;
				if(Math.isNaN(val2)) val2 = 0;

				var newValue:Float = SONG.speed * ClientPrefs.getGameplaySetting('scrollspeed', 1) * val1;

				if(val2 <= 0)
				{
					songSpeed = newValue;
				}
				else
				{
					songSpeedTween = FlxTween.tween(this, {songSpeed: newValue}, val2, {ease: FlxEase.linear, onComplete:
						function (twn:FlxTween)
						{
							songSpeedTween = null;
						}
					});
				}

			case 'Warning':
				bfDodgeCooldown = 0.1125;
				bfDodgeTiming = 0.425;
				warningSign.visible = true;
				warningSign.animation.play('alert');
				FlxG.sound.play(Paths.sound('Warning'), 1);

			case 'Dodge Event':
				var val1:Float = Std.parseFloat(value1);
				var val2:Float = Std.parseFloat(value2);
				if(Math.isNaN(val1) || val1 >= 1) val1 = 0.17;
				if(Math.isNaN(val2) || val2 >= 2) val2 = 2;
				warningSign.visible = false;
				if (songName == 'roar-of-natsuki') triggerEventNote('Buffsuki Punch', '', '');

				if (cpuControlled)
				{
					boyfriend.playAnim('dodge');
					bfDodging = true;
					new FlxTimer().start(bfDodgeTiming, function(tmr:FlxTimer)
					{
						bfDodging=false;
						boyfriend.dance();
					});
				}
				new FlxTimer().start(val1, function(tmr:FlxTimer)
				{
					if(!bfDodging && !ClientPrefs.getGameplaySetting('practice', false) && !cpuControlled)
					{
						boyfriend.playAnim('hurt');
						health -= val2;
						if (health <= val2) GameOverSubstate.gotPunched = true;
					}
				});

			case 'Buffsuki Punch':
				dad.playAnim('punchLeft', true);
				dad.specialAnim = true;

			case 'Stage Morph':
				if (curStage != value1)
					stageMorph(value1);
			
			case 'Epic Cam Beat':
				var val1:Int = Std.parseInt(value1);
				if(Math.isNaN(val1) || val1 <= 0) val1 = 0;
				if (val1 == 1)
				{
					camZoomBeat = true;
					camZooming = true;
				}
				else
					camZoomBeat = false;

			case 'Camera Bounce':
				var val1:Int = Std.parseInt(value1);
				if(Math.isNaN(val1) || val1 <= 0 || val1 > 1) val1 = 0;
				if (val1 == 1)
					camBounce = true;
				else
					camBounce = false;

			case 'Black Screen Fade':
				var val1:Float = Std.parseFloat(value1);
				var val2:Float = Std.parseFloat(value2);
				if(Math.isNaN(val1) || val1 > 1 || val1 < 0) val1 = 0;
				if(Math.isNaN(val2) || val2 < 0) val2 = 0;
				FlxTween.cancelTweensOf(blackFade);
				if (val2 > 0)
					FlxTween.tween(blackFade, {alpha: val1}, val2, {ease: FlxEase.linear});
				else
					blackFade.alpha = val1;

			case 'Static Fade':
				var val1:Float = Std.parseFloat(value1);
				var val2:Float = Std.parseFloat(value2);
				if(Math.isNaN(val1) || val1 > 1 || val1 < 0) val1 = 0;
				if(Math.isNaN(val2) || val2 < 0) val2 = 0;
				FlxTween.cancelTweensOf(tvStatic);
				if (val2 > 0)
					FlxTween.tween(tvStatic, {alpha: val1}, val2, {ease: FlxEase.linear});
				else
					tvStatic.alpha = val1;

			case "DefaultCamZoom Change":
				var val1:Float = Std.parseFloat(value1);
				var val2:Float = Std.parseFloat(value2);
				if(Math.isNaN(val1) || val1 <= 0) val1 = stageData.defaultZoom;
				if(Math.isNaN(val2) || val2 < 0) val2 = 0;
				FlxTween.cancelTweensOf(FlxG.camera);
				if (val2 > 0)
				{
					FlxTween.tween(FlxG.camera, {zoom: val1}, val2, {
						ease: FlxEase.linear,
						onComplete: function(twn:FlxTween)
						{
							defaultCamZoom = val1;
						}
					});
				}
				else
				{
					FlxTween.tween(FlxG.camera, {zoom: val1}, 0.001, {
						ease: FlxEase.linear,
						onComplete: function(twn:FlxTween)
						{
							defaultCamZoom = val1;
						}
					});
				}

			case 'Show End Screen':
				var val1:Float = Std.parseFloat(value1);
				if(Math.isNaN(val1)) val1 = 0;
				endScreen.angle = val1;
				FlxTween.tween(endScreen, {alpha: 1}, 1.4, {ease: FlxEase.linear});

			case 'Glitch Effect':
				var val1:Int = Std.parseInt(value1);
				var val2:Float = Std.parseFloat(value2);
				if(Math.isNaN(val1) || val1 <= 0 || val1 >= 4) val1 = FlxG.random.int(1, 3);
				if(Math.isNaN(val2) || val2 <= 0) val2 = 1;

				funnyGlitch(val1, val2);
			case 'Popup Appear':
				var val1:Float = Std.parseFloat(value1);

				var xVal:Float = 0;
				var yVal:Float = 0;
				xVal = FlxG.random.int(0, 880);
				yVal = FlxG.random.int(0, 320);
				if(Math.isNaN(val1)) val1 = 1;

				var screenBlocker:PopupBlocker = new PopupBlocker(xVal, yVal, isDokiDoki, val1);
				screenBlocker.cameras = [camHUD];
				add(screenBlocker);

			case 'White Screen Fade':
				var val1:Float = Std.parseFloat(value1);
				var val2:Float = Std.parseFloat(value2);
				if(Math.isNaN(val1) || val1 > 1 || val1 < 0) val1 = 0;
				if(Math.isNaN(val2) || val2 < 0) val2 = 0;
				FlxTween.cancelTweensOf(whiteFade);
				if (val2 > 0)
					FlxTween.tween(whiteFade, {alpha: val1}, val2, {ease: FlxEase.linear});
				else
					whiteFade.alpha = val1;

			case 'Play Sound':
				var val1:String = value1;
				FlxG.sound.play(Paths.sound(val1), 1);

			case 'Hud Fade':
				var val1:Float = Std.parseFloat(value1);
				var val2:Float = Std.parseFloat(value2);
				if(Math.isNaN(val1) || val1 > 1 || val1 < 0) val1 = 0;
				if(Math.isNaN(val2) || val2 < 0) val2 = 0;
				FlxTween.cancelTweensOf(camHUD);
				if (val2 > 0)
					FlxTween.tween(camHUD, {alpha: val1}, val2, {ease: FlxEase.linear});
				else
					camHUD.alpha = val1;

			case 'Distractions':
				var val1:Int = Std.parseInt(value1);
				if(Math.isNaN(val1) || val1 > 3 || val1 < 0) val1 = 0;
				switch (val1)
				{
					case 0:
						remove(monikaScreenA);
						remove(monikaScreenB);
						remove(monikaScreenC);
					case 1:
						add(monikaScreenA);
						remove(monikaScreenB);
						remove(monikaScreenC);
					case 2:
						remove(monikaScreenA);
						add(monikaScreenB);
						remove(monikaScreenC);
					case 3:
						remove(monikaScreenA);
						remove(monikaScreenB);
						add(monikaScreenC);
				}
			case 'Down on Up':
				var val1:Int = Std.parseInt(value1);
				if(Math.isNaN(val1) || val1 <= 0 || val1 > 1) val1 = 0;
				if (val1 == 1)
				{
					FlxTween.tween(camHUD, {angle: 180}, 0.1, {ease: FlxEase.linear});
					FlxTween.tween(playerStrums.members[0], {angle: 180}, 0.1, {ease: FlxEase.linear});
					FlxTween.tween(playerStrums.members[1], {angle: 180}, 0.1, {ease: FlxEase.linear});
					FlxTween.tween(playerStrums.members[2], {angle: 180}, 0.1, {ease: FlxEase.linear});
					FlxTween.tween(playerStrums.members[3], {angle: 180}, 0.1, {ease: FlxEase.linear});
					FlxTween.tween(playerStrums.members[0], {x: defaultPlayerStrumX4}, 0.1, {ease: FlxEase.linear});
					FlxTween.tween(playerStrums.members[1], {x: defaultPlayerStrumX3}, 0.1, {ease: FlxEase.linear});
					FlxTween.tween(playerStrums.members[2], {x: defaultPlayerStrumX2}, 0.1, {ease: FlxEase.linear});
					FlxTween.tween(playerStrums.members[3], {x: defaultPlayerStrumX1}, 0.1, {ease: FlxEase.linear});
					downOnUp = true;
				}
				else
				{
					FlxTween.tween(camHUD, {angle: 0}, 0.1, {ease: FlxEase.linear});
					FlxTween.tween(playerStrums.members[0], {angle: 0}, 0.1, {ease: FlxEase.linear});
					FlxTween.tween(playerStrums.members[1], {angle: 0}, 0.1, {ease: FlxEase.linear});
					FlxTween.tween(playerStrums.members[2], {angle: 0}, 0.1, {ease: FlxEase.linear});
					FlxTween.tween(playerStrums.members[3], {angle: 0}, 0.1, {ease: FlxEase.linear});
					FlxTween.tween(playerStrums.members[0], {x: defaultPlayerStrumX1}, 0.1, {ease: FlxEase.linear});
					FlxTween.tween(playerStrums.members[1], {x: defaultPlayerStrumX2}, 0.1, {ease: FlxEase.linear});
					FlxTween.tween(playerStrums.members[2], {x: defaultPlayerStrumX3}, 0.1, {ease: FlxEase.linear});
					FlxTween.tween(playerStrums.members[3], {x: defaultPlayerStrumX4}, 0.1, {ease: FlxEase.linear});
					downOnUp = false;
				}

			case 'Front Monika':
				var val1:Float = Std.parseFloat(value1);
				if(Math.isNaN(val1) || val1 > 1 || val1 < 0) val1 = 0;
				frontMonika.alpha = val1;

			case 'Hud Angle':
				var val1:Float = Std.parseFloat(value1);
				var val2:Float = Std.parseFloat(value2);
				if(Math.isNaN(val1) || val1 < 0) val1 = 0;
				if(Math.isNaN(val2) || val2 < 0) val2 = 0;

				if (val2 > 0)
					FlxTween.tween(camHUD, {angle: val1}, val2, {ease: FlxEase.linear});
				else
					camHUD.angle = val1;

			case 'Heath Drain':
				var val1:Int = Std.parseInt(value1);
				if(Math.isNaN(val1) || val1 < 0 || val1 > 1) val1 = 0;
				if (val1 == 1)
					healthDrain = true;
				else
					healthDrain = false;

			case 'Vingette Appear':
				var val1:Int = Std.parseInt(value1);
				if(Math.isNaN(val1) || val1 < 0 || val1 > 1) val1 = 0;
				if (val1 == 1)
					add(vingetteThing);
				else
					remove(vingetteThing);

			case 'Screen Flash':
				var val1:Int = Std.parseInt(value1);
				if(Math.isNaN(val1) || val1 < 1 || val1 > 3) val1 = 1;
				switch (val1)
				{
					case 1:
						whiteFade.alpha = 1;
						FlxTween.tween(whiteFade, {alpha: 0}, 0.2, {ease: FlxEase.linear});
					case 2:
						blackFade.alpha = 1;
						FlxTween.tween(blackFade, {alpha: 0}, 0.2, {ease: FlxEase.linear});
					case 3:
						tvStatic.alpha = 1;
						FlxTween.tween(tvStatic, {alpha: 0}, 0.2, {ease: FlxEase.linear});
				}
			case 'Song Blurb':
				if (curSong.toLowerCase() == 'roar of natsuki')
					leCoolSongName(true);
				else
					leCoolSongName();

			case 'Lyric Text Event':
				var val1:String = value1;
				var val2:FlxColor = 0xFFFFFFFF;
				if (value2 != '' && value2 != null)
					val2 = FlxColor.fromString(value2);
				lyricText.text = val1;
				lyricText.color = val2;

			case 'Change Note Skin':
				var val1:String = value1;
				var val2:String = value2;

				if (val1 == null || val1 == "")
				{
					if (PlayState.SONG.arrowSkin != null && PlayState.SONG.arrowSkin != '')
						val1 = PlayState.SONG.arrowSkin;
					else
					{
						val1 = 'Regular';
					}
				}
				noteTexture = val1;

				var strumGroup:FlxTypedGroup<StrumNote> = playerStrums;
				switch (val2.toLowerCase())
				{
					case 'dad':
						strumGroup = opponentStrums;
					case 'bf':
						strumGroup = playerStrums;
					default:
						strumGroup = strumLineNotes;
				}

				for (strum in strumGroup)
				{
					strum.texture = 'noteSkins/' + val1;
					strum.reloadNote();
				}

				if(generatedMusic)
				{
					for (note in notes)
					{
						switch (val2.toLowerCase())
						{
							case 'dad':
								if (!note.mustPress)
								{
									note.texture = 'noteSkins/' + val1;
									note.reloadNote('', 'noteSkins/' + val1);
								}
							case 'bf':
								if (note.mustPress)
								{
									note.texture = 'noteSkins/' + val1;
									note.reloadNote('', 'noteSkins/' + val1);
								}
							default:
								note.texture = 'noteSkins/' + val1;
								note.reloadNote('', 'noteSkins/' + val1);	
						}
					}
					for (note in unspawnNotes)
					{
						switch (val2.toLowerCase())
						{
							case 'dad':
								if (!note.mustPress)
								{
									note.texture = 'noteSkins/' + val1;
									note.reloadNote('', 'noteSkins/' + val1);
								}
							case 'bf':
								if (note.mustPress)
								{
									note.texture = 'noteSkins/' + val1;
									note.reloadNote('', 'noteSkins/' + val1);
								}
							default:
								note.texture = 'noteSkins/' + val1;
								note.reloadNote('', 'noteSkins/' + val1);	
						}
					}
				}

			case 'Change Splash Skin':
				var val1:String = value1;
				if (val1 == null || val1 == '') 
				{
					if (PlayState.SONG.splashSkin != null && PlayState.SONG.splashSkin.length > 0)	
						val1 = PlayState.SONG.splashSkin;
					else
					{
						val1 = 'Regular';
					}
				}
				splashTexture = val1;
		}
		stagesFunc(function(stage:BaseStage) stage.eventCalled(eventName, value1, value2));
	}

	function moveCameraSection(?id:Int = 0):Void {
		if(SONG.notes[id] == null) return;

		if (gf != null && SONG.notes[id].gfSection)
		{
			camFollow.set(gf.getMidpoint().x, gf.getMidpoint().y);
			camFollow.x += gf.cameraPosition[0] + girlfriendCameraOffset[0];
			camFollow.y += gf.cameraPosition[1] + girlfriendCameraOffset[1];
			tweenCamIn();
			return;
		}

		if (!SONG.notes[id].mustHitSection)
		{
			moveCamera(true);
		}
		else
		{
			moveCamera(false);
		}
	}

	var cameraTwn:FlxTween;
	public function moveCamera(isDad:Bool)
	{
		if(isDad)
		{
			camFollow.set(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
			camFollow.x += dad.cameraPosition[0] + opponentCameraOffset[0];
			camFollow.y += dad.cameraPosition[1] + opponentCameraOffset[1];
		}
		else
		{
			camFollow.set(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);
			camFollow.x -= boyfriend.cameraPosition[0] - boyfriendCameraOffset[0];
			camFollow.y += boyfriend.cameraPosition[1] + boyfriendCameraOffset[1];

			if (Paths.formatToSongPath(SONG.song) == 'tutorial' && cameraTwn == null && FlxG.camera.zoom != 1)
			{
				cameraTwn = FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut, onComplete:
					function (twn:FlxTween)
					{
						cameraTwn = null;
					}
				});
			}
		}
	}

	function tweenCamIn() {
		if (Paths.formatToSongPath(SONG.song) == 'tutorial' && cameraTwn == null && FlxG.camera.zoom != 1.3) {
			cameraTwn = FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut, onComplete:
				function (twn:FlxTween) {
					cameraTwn = null;
				}
			});
		}
	}

	function snapCamFollowToPos(x:Float, y:Float) {
		camFollow.set(x, y);
		camFollowPos.setPosition(x, y);
	}

	function checkSongClear():Void
	{
		switch (curSong.toLowerCase())
		{
			case 'welcome to the club (boyfriend)' | 'welcome to the club (bowser jr)' | 'welcome to the club (monika)':
				if (!SaveData.regularCleared.contains('welcome to the club'))
				{
					SaveData.songsCleared++;
					SaveData.normalSongs++;
					SaveData.regularCleared.push('welcome to the club');
				}
			default:
				if (!SaveData.regularCleared.contains(curSong.toLowerCase()))
				{
					SaveData.songsCleared++;
					switch (songType)
					{
						case 'Normal': SaveData.normalSongs++;
						case 'Classic': SaveData.classicSongs++;
						case 'Bonus': SaveData.bonusSongs++;
					}
					SaveData.regularCleared.push(curSong.toLowerCase());
				}
		}
		var normnum:Int = 0;
		for (i in CoolUtil.normalSongs)
		{
			if (SaveData.regularCleared.contains(i)) normnum++;
			if (normnum >= 33) {
				SaveData.clearAllNormal = true;
				SaveData.normalSongs = 33;
			}
		}
		var classnum:Int = 0;
		for (i in CoolUtil.classicSongs)
		{
			if (SaveData.regularCleared.contains(i)) classnum++;
			if (classnum >= 16) {
				SaveData.clearAllClassic = true;
				SaveData.classicSongs = 16;
			}
		}
		var bonnum:Int = 0;
		for (i in CoolUtil.bonusSongs)
		{
			if (SaveData.regularCleared.contains(i)) bonnum++;
			if (bonnum >= 16) {
				SaveData.clearAllBonus = true;
				SaveData.bonusSongs = 10;
			}
		}
		SaveData.saveSwagData();
		return;
	}

	function routeCheck():Void
	{
		switch (curSong.toLowerCase())
		{
			case 'welcome to the club (boyfriend)' | 'welcome to the club (bowser jr)' | 'welcome to the club (monika)':
				if (ClientPrefs.playerChar == 1 && SaveData.bfRoute == 0) SaveData.bfRoute = 1;
				else if (ClientPrefs.playerChar == 2 && SaveData.jrRoute == 0) SaveData.jrRoute = 1;
				else if (ClientPrefs.playerChar == 3 && SaveData.monikaRoute == 0) SaveData.monikaRoute = 1;
			case 'happy thoughts':
				if (ClientPrefs.playerChar == 1 && SaveData.bfRoute == 1) SaveData.bfRoute = 2;
			case 'cinnamon bun':
				if (ClientPrefs.playerChar == 2 && SaveData.jrRoute == 1) SaveData.jrRoute = 2;
			case 'trust':
				if (ClientPrefs.playerChar == 3 && SaveData.monikaRoute == 1) SaveData.monikaRoute = 2;
			case 'tsundere':
				if (ClientPrefs.playerChar == 1 && SaveData.bfRoute == 2) SaveData.bfRoute = 3;
				else if (ClientPrefs.playerChar == 2 && SaveData.jrRoute == 2) SaveData.jrRoute = 3;
			case 'respect':
				if (ClientPrefs.playerChar == 3 && SaveData.monikaRoute == 2) SaveData.monikaRoute = 3;				
			case 'shy':
				if (ClientPrefs.playerChar == 1 && SaveData.bfRoute == 3) SaveData.bfRoute = 4;
			case 'cup of tea':
				if (ClientPrefs.playerChar == 2 && SaveData.jrRoute == 3) SaveData.jrRoute = 4;
			case 'reflection':
				if (ClientPrefs.playerChar == 3 && SaveData.monikaRoute == 3) SaveData.monikaRoute = 4;
			case 'i advise':
				if (ClientPrefs.playerChar == 3)
				{
					if (SaveData.monikaRoute == 4 && !SaveData.monikaRouteClear)
					{
						SaveData.monikaRoute = 5;
						SaveData.actThree = true;
						SaveData.lockedRoute = 'MONI';
					}
				}
			case 'last dual':
				if (ClientPrefs.playerChar == 1 && SaveData.bfRoute == 4 && !SaveData.bfRouteClear)
				{
					crashType = "Bowser Jr";
					SaveData.actTwo = true;
					SaveData.bfRoute = 5;
					SaveData.lockedRoute = 'BF';
				}
				if (ClientPrefs.playerChar == 2 && SaveData.jrRoute == 4 && !SaveData.jrRouteClear)
				{
					crashType = "Bowser Jr";
					SaveData.actTwo = true;
					SaveData.jrRoute = 5;
					SaveData.lockedRoute = 'JR';
				}
			case 'un-welcome to the club':
				if (ClientPrefs.playerChar == 1 && SaveData.bfRoute == 5) SaveData.bfRoute = 6;
				else if (ClientPrefs.playerChar == 2 && SaveData.jrRoute == 5) SaveData.jrRoute = 6;
			case 'hxppy thxughts':
				if (ClientPrefs.playerChar == 1 && SaveData.bfRoute == 6) SaveData.bfRoute = 7;
			case 'cxnnamon bxn':
				if (ClientPrefs.playerChar == 2 && SaveData.jrRoute == 6) SaveData.jrRoute = 7;
			case 'glitch':
				if (ClientPrefs.playerChar == 1 && SaveData.bfRoute == 7) SaveData.bfRoute = 8;
				else if (ClientPrefs.playerChar == 2 && SaveData.jrRoute == 7) SaveData.jrRoute = 8;
			case 'obsessed':
				if (ClientPrefs.playerChar == 1 && SaveData.bfRoute == 8)
				{
					SaveData.actTwo = false;
					SaveData.actThree = true;
					SaveData.bfRoute = 9;
				}
			case 'psychopath':
				if (ClientPrefs.playerChar == 2 && SaveData.jrRoute == 8)
				{
					SaveData.actTwo = false;
					SaveData.actThree = true;
					SaveData.jrRoute = 9;
				}
			case 'script error':
				if (ClientPrefs.playerChar != 3)
				{
					if (ClientPrefs.playerChar == 1 && SaveData.bfRoute == 9)
					{
						SaveData.actThree = false;
						SaveData.bfRoute = 10;
						SaveData.bfRouteClear = true;
						SaveData.lockedRoute = 'None';
					}
					else if (ClientPrefs.playerChar == 2 && SaveData.jrRoute == 9)
					{
						SaveData.actThree = false;
						SaveData.jrRoute = 10;
						SaveData.jrRouteClear = true;
						SaveData.lockedRoute = 'None';
					}
				}
			case 'system failure':
				if (ClientPrefs.playerChar == 3 && SaveData.monikaRoute == 5)
				{
					SaveData.actThree = false;
					SaveData.monikaRoute = 6;
					SaveData.monikaRouteClear = true;
					SaveData.lockedRoute = 'None';
				}
		}
		SaveData.saveSwagData();
	}

	//Any way to do this without using a different function? kinda dumb
	private function onSongComplete()
	{
		if (SONG.song.toLowerCase() == 'system failure')
		{
			updateTime = false;
			FlxG.sound.music.volume = 0;
			vocals.volume = 0;
			vocals.stop();
			playervox.volume = 0;
			playervox.stop();
			canPause = false;
		}
		else finishSong(false);
	}

	public function finishSong(?ignoreNoteOffset:Bool = false):Void
	{
		var usedPractice:Bool = (ClientPrefs.getGameplaySetting('practice', false) || ClientPrefs.getGameplaySetting('botplay', false));
		var finishCallback:Void->Void = endSong; //In case you want to change it in a specific song.

		if ((!isStoryMode || storyFreeplay) && ClientPrefs.freeplayCutscenes)
			finishCallback = showResults;

		updateTime = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		vocals.stop();
		playervox.volume = 0;
		playervox.stop();
		canPause = false;

		if (!usedPractice && !changedDifficulty)
		{
			checkSongClear();
			if (isStoryMode && !storyFreeplay)
				routeCheck();
		}

		var canPlayCutscene:Bool = isStoryMode || ClientPrefs.freeplayCutscenes;
		if (canPlayCutscene && !seenEndDialogue)
		{
			endingSong = true;
			switch (curSong.toLowerCase())
			{
				case 'i advise':
					if (ClientPrefs.playerChar == 3 && !changedDifficulty && !usedPractice)
					{
						defOutro();
					}
					else
					{
						if(ClientPrefs.noteOffset <= 0 || ignoreNoteOffset) {
							finishCallback();
						} else {
							finishTimer = new FlxTimer().start(ClientPrefs.noteOffset / 1000, function(tmr:FlxTimer) {
								finishCallback();
							});
						}
					}
				case 'last dual':
					if (ClientPrefs.playerChar != 3 && !changedDifficulty && !usedPractice)
						actOneEnd();
					else
					{
						if(ClientPrefs.noteOffset <= 0 || ignoreNoteOffset) {
							finishCallback();
						} else {
							finishTimer = new FlxTimer().start(ClientPrefs.noteOffset / 1000, function(tmr:FlxTimer) {
								finishCallback();
							});
						}
					}
				case 'obsessed':
					if (ClientPrefs.playerChar == 1 && !changedDifficulty && !usedPractice)
					{
						defOutro();
					}
					else
					{
						if(ClientPrefs.noteOffset <= 0 || ignoreNoteOffset) {
							finishCallback();
						} else {
							finishTimer = new FlxTimer().start(ClientPrefs.noteOffset / 1000, function(tmr:FlxTimer) {
								finishCallback();
							});
						}
					}
				case 'psychopath':
					if (ClientPrefs.playerChar == 2 && !changedDifficulty && !usedPractice)
					{
						defOutro();
					}
					else
					{
						if(ClientPrefs.noteOffset <= 0 || ignoreNoteOffset) {
							finishCallback();
						} else {
							finishTimer = new FlxTimer().start(ClientPrefs.noteOffset / 1000, function(tmr:FlxTimer) {
								finishCallback();
							});
						}
					}
				case 'self-aware':
					if (ClientPrefs.playerChar == 1 && !changedDifficulty && !usedPractice)
					{
						defOutro();
					}
					else
					{
						if(ClientPrefs.noteOffset <= 0 || ignoreNoteOffset) {
							finishCallback();
						} else {
							finishTimer = new FlxTimer().start(ClientPrefs.noteOffset / 1000, function(tmr:FlxTimer) {
								finishCallback();
							});
						}
					}
				case 'elevated access':
					if ((ClientPrefs.playerChar == 2 || ClientPrefs.playerChar == 3) && !changedDifficulty && !usedPractice)
					{
						defOutro();
					}
					else
					{
						if(ClientPrefs.noteOffset <= 0 || ignoreNoteOffset) {
							finishCallback();
						} else {
							finishTimer = new FlxTimer().start(ClientPrefs.noteOffset / 1000, function(tmr:FlxTimer) {
								finishCallback();
							});
						}
					}
				case 'script error':
					if ((ClientPrefs.playerChar == 1 || ClientPrefs.playerChar == 2) && !changedDifficulty && !usedPractice)
					{
						defOutro();
					}
					else
					{
						if(ClientPrefs.noteOffset <= 0 || ignoreNoteOffset) {
							finishCallback();
						} else {
							finishTimer = new FlxTimer().start(ClientPrefs.noteOffset / 1000, function(tmr:FlxTimer) {
								finishCallback();
							});
						}
					}
				default:
					if(ClientPrefs.noteOffset <= 0 || ignoreNoteOffset) {
						finishCallback();
					} else {
						finishTimer = new FlxTimer().start(ClientPrefs.noteOffset / 1000, function(tmr:FlxTimer) {
							finishCallback();
						});
					}
			}
		}
		else
		{
			if(ClientPrefs.noteOffset <= 0 || ignoreNoteOffset) {
				finishCallback();
			} else {
				finishTimer = new FlxTimer().start(ClientPrefs.noteOffset / 1000, function(tmr:FlxTimer) {
					finishCallback();
				});
			}
		}
	}


	public var transitioning = false;
	public function endSong():Void
	{
		songAccuracy = Std.int(Highscore.floorDecimal(ratingPercent * 100, 0));

		//Should kill you if you tried to cheat
		if(!startingSong) {
			notes.forEach(function(daNote:Note) {
				if(daNote.strumTime < songLength - Conductor.safeZoneOffset) {
					health -= 0.05 * healthLoss;
				}
			});
			for (daNote in unspawnNotes) {
				if(daNote.strumTime < songLength - Conductor.safeZoneOffset) {
					health -= 0.05 * healthLoss;
				}
			}

			if(doDeathCheck()) {
				return;
			}
		}

		if (!songsPlayed.exists(SONG.song)) {
			songsPlayed.set(SONG.song, true);
			FlxG.save.data.songsPlayed = songsPlayed;
			FlxG.save.flush();
		}
		
		timeBarBG.visible = false;
		timeBar.visible = false;
		timeTxt.visible = false;
		canPause = false;
		camZooming = false;
		inCutscene = false;
		updateTime = false;
		endingSong = true;

		seenCutscene = false;

		#if ACHIEVEMENTS_ALLOWED
		checkForAchievement(achievesList);
		#end

		if(!transitioning) {
			if (SONG.validScore)
			{
				#if !switch
				var percent:Float = Highscore.floorDecimal(ratingPercent, 2);
				if(Math.isNaN(percent)) percent = 0;
				Highscore.saveScore(SONG.song, songScore, storyDifficulty, percent);
				#end
			}

			if (chartingMode)
			{
				openChartEditor();
				return;
			}

			CustomFadeTransition.isHeartTran = true;

			if (songName == 'respect' && songMisses < 1) CoolUtil.makeSecretFile('PoemCupcake\n\n\nI don\'t ship Monika with the other Dokis btw...', 'Monsuki');
			if (songName == 'malnourished' && songMisses < 1) CoolUtil.makeSecretFile('IT\'S THE [File name] YOU [Funky] LITTLE [Worm]!', '1997');
			if (songName == 'revelation') CoolUtil.makeSecretFile('What was Revelation called in the previous version of this mod?', 'A question');

			if (isStoryMode)
			{
				deathCounter = 0;
				campaignScore += songScore;
				campaignMisses += songMisses;
				campaignNotes += totalPlayed;
				campaignHits += totalNotetrash;
				campaignSicks += sicks;
				campaignGoods += goods;
				campaignBads += bads;
				campaignTrashes += trashs;
				totalNotesHit += notesPressed;

				storyPlaylist.remove(storyPlaylist[0]);

				if (storyPlaylist.length <= 0)
				{
					campaignAccuracy = Highscore.floorDecimal(Math.min(1, Math.max(0, campaignHits / campaignNotes)) * 100, 0);

					cancelMusicFadeTween();

					if(!ClientPrefs.getGameplaySetting('practice', false) && !ClientPrefs.getGameplaySetting('botplay', false)) 
					{
						if (SONG.validScore)
						{
							Highscore.saveWeekScore(WeekData.weekID, campaignScore, storyDifficulty);
						}

						FlxG.save.flush();
					}
					changedDifficulty = false;

					if (storyFreeplay)
					{
						if (ClientPrefs.resultsScreen) openSubState(new ResultsScreen());
						else 
						{
							openSubState(new CustomFadeTransition(0.4, false, new StoryContinueState()));
							CoolUtil.playMusic(CoolUtil.getTitleTheme());
						}
					}
					else
					{
						if (curSong.toLowerCase() != 'script error' && curSong.toLowerCase() != 'system failure')
						{
							if (crashType == "Bowser Jr")
							{
								CoolUtil.playMusic('ActThreeMenu');
							}
							else
							{
								FlxG.sound.music.stop();
								vocals.stop();
								playervox.stop();
							}
						}

						if (ClientPrefs.playerChar != 3 && curSong.toLowerCase() == 'script error')
						{
							if (ClientPrefs.playerChar == 1) CoolUtil.makeSecretFile('Not bad, for an _________!', 'Funkin Clue');
							if (ClientPrefs.playerChar == 2) CoolUtil.makeSecretFile('Game of origin: Bowser\'s Block Party', 'Mario Clue');
							openSubState(new CustomFadeTransition(0.4, false, new CreditsState()));
						}
						else
						{
							if (SaveData.actThree)
							{
								FlxTransitionableState.skipNextTransIn = true;
								FlxTransitionableState.skipNextTransOut = true;
								FlxG.switchState(new TeamDSIntro());
							}
							else
							{
								if (curSong.toLowerCase() == 'system failure')
								{
									CoolUtil.makeSecretFile('Monika\'s favorite song', 'Monika\'s Clue');
									FlxG.sound.music.stop();
									vocals.stop();
									playervox.stop();
								}
								else
								{
									if (curSong.toLowerCase() == 'last dual' && SaveData.actTwo)
									{
										openSubState(new CustomFadeTransition(0.4, false, new CrashState()));
									}
									else
									{
										switch (ClientPrefs.playerChar)
										{
											default:
												var num:Int = CoolUtil.difficultyString() == 'DOKI DOKI' ? SaveData.dokiBFRoute : SaveData.bfRoute;
												WeekData.weekID = WeekData.boyfriendRouteList[num][1];
												PlayState.storyPlaylist = WeekData.boyfriendRouteList[num][2];
											case 2:
												var num:Int = CoolUtil.difficultyString() == 'DOKI DOKI' ? SaveData.dokiJRRoute : SaveData.jrRoute;
												WeekData.weekID = WeekData.bowserJrRouteList[num][1];
												PlayState.storyPlaylist = WeekData.bowserJrRouteList[num][2];
											case 3:
												var num:Int = CoolUtil.difficultyString() == 'DOKI DOKI' ? SaveData.dokiMONIRoute : SaveData.monikaRoute;
												WeekData.weekID = WeekData.monikaRouteList[num][1];
												PlayState.storyPlaylist = WeekData.monikaRouteList[num][2];
										}

										isStoryMode = true;
										storyFreeplay = false;
										var diffic = CoolUtil.getDifficultyFilePath(storyDifficulty);
										if(diffic == null) diffic = '';

										PlayState.SONG = Song.loadFromJson(storyPlaylist[0].toLowerCase() + diffic, storyPlaylist[0].toLowerCase());
										campaignScore = 0;
										campaignMisses = 0;
										openSubState(new CustomFadeTransition(0.4, false, new LoadingState(new PlayState(), true, true)));
									}
								}
							}
						}
					}
					FlxG.save.flush();
				}
				else
				{
					var difficulty:String = CoolUtil.getDifficultyFilePath();

					trace('LOADING NEXT SONG');
					trace(Paths.formatToSongPath(PlayState.storyPlaylist[0]) + difficulty);

					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;

					prevCamFollow = camFollow;
					prevCamFollowPos = camFollowPos;

					if (storyDifficulty == 1) PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + '-doki-doki', PlayState.storyPlaylist[0].toLowerCase());
					else PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase(), PlayState.storyPlaylist[0].toLowerCase());
					FlxG.sound.music.stop();

					cancelMusicFadeTween();
					FlxTransitionableState.skipNextTransOut = true;
					FlxG.resetState();
				}
			}
			else
			{
				trace('WENT BACK TO FREEPLAY??');
				cancelMusicFadeTween();

				if (!ClientPrefs.getGameplaySetting('practice', false) && !ClientPrefs.getGameplaySetting('botplay', false))
				{
					if (songName == 'poem-panic' && songMisses < 1) CoolUtil.makeSecretFile('{ERROR: Contents of file redacted by admin. Contact admin "darkXwolf17"}', 'solver_install');
					if (songName == 'your-reality' && songMisses < 1) CoolUtil.makeSecretFile('Congratulations! You\'re one year older! Wishing you all the best!\nMay your year be filled with many blessings!\n-Love, Blabbot\n\nC C D C F E', 'Birthday Card');
					if (songName == 'yuri-is-a-raccoon' && songMisses < 1) CoolUtil.makeSecretFile('I\'ve been watching this skateboard YouTuber, skaterboi360.\nIn his latest video, he was trying to do some skateboarding tricks, but his shoelace got caught on one of the wheels and he ended up falling off.\nFunniest thing I\'ve seen today lol XD', 'Funny Video');
					if (SaveData.clearAllNormal && SaveData.clearAllClassic && SaveData.clearAllBonus) CoolUtil.makeSecretFile('The most popular DDLC Mod that isn\'t Blue Skies.', 'The story ends');
				}

				if (!ClientPrefs.freeplayCutscenes)
					resultsShow = true;

				if (resultsShow)
				{
					var usedPractice:Bool = (ClientPrefs.getGameplaySetting('practice', false) || ClientPrefs.getGameplaySetting('botplay', false));

					if (SaveData.clearAllNormal && SaveData.clearAllClassic && SaveData.clearAllBonus && !SaveData.seenCompScreen)
					{
						CoolUtil.playMusic('AFreshTrailer');
						openSubState(new CustomFadeTransition(0.4, false, new CompletionScreen()));
					}
					else
					{
						if (ClientPrefs.resultsScreen && !ClientPrefs.getGameplaySetting('botplay', false) && !ClientPrefs.getGameplaySetting('practice', false))
						{
							openSubState(new ResultsScreen());
						}
						else
						{
							FlxG.sound.music.stop();
							deathCounter = 0;
							PlayState.totalNotesHit = 0;
							switch (songType)
							{
								case 'Normal':
									openSubState(new CustomFadeTransition(0.4, false, new FreeplayState()));
								case 'Classic':
									openSubState(new CustomFadeTransition(0.4, false, new ClassicFreeplayState()));
								case 'Bonus':
									openSubState(new CustomFadeTransition(0.4, false, new BonusFreeplayState()));
							}
						}
					}
				}
				changedDifficulty = false;
			}
			transitioning = true;
		}
	}

	function triggerEnding(route:Int, misses:Int):Void
	{
		var isBadEnding:Bool = false;
		var filename:String = '';
		if (misses >= 70) isBadEnding = true;
		switch (route)
		{
			case 1:
				if (isBadEnding) filename = 'BF-Bad-Ending';
				else filename = 'BF-Good-Ending';
			case 2:
				if (isBadEnding) filename = 'JR-Bad-Ending';
				else filename = 'JR-Good-Ending';
			case 3:
				if (isBadEnding) filename = 'MONI-Bad-Ending';
				else filename = 'MONI-Good-Ending';
		}
		var endingVid:VideoSprite = new VideoSprite();
		endingVid.playVideo(Paths.video('endings/' + filename), false);
		endingVid.bitmap.canSkip = false;
		endingVid.scrollFactor.set();
		endingVid.antialiasing = ClientPrefs.globalAntialiasing;
		endingVid.cameras = [camDialogue];
		endingVid.finishCallback = function()
		{
			if (isBadEnding)
			{
				#if !html5
				Sys.exit(0);
				#else
				FlxG.switchState(new CrashState());
				#end
			}
			else if (route == 3 && isStoryMode && !storyFreeplay)
			{
				remove(endingVid);
				FlxG.sound.play(Paths.sound('end_program'), 1, false, null, true, function()
				{
					#if !html5
					Sys.exit(0);
					#else
					FlxG.switchState(new CrashState());
					#end
				});
				if (!FlxG.fullscreen)
					FlxG.fullscreen = !FlxG.fullscreen;
				add(blueScreen);
				blueScreen.animation.play('show');
			}
			else
			{
				remove(endingVid);
				endSong();
			}
		}
		add(endingVid);

		if (!isBadEnding)
		{
			#if !switch
			var percent:Float = Highscore.floorDecimal(ratingPercent, 2);
			if(Math.isNaN(percent)) percent = 0;
			Highscore.saveScore(SONG.song, songScore, storyDifficulty, percent);
			#end
			deathCounter = 0;
		}

		if (route == 3 && isStoryMode && !isBadEnding)
		{
			SaveData.sayoriDeaths++;
			checkSongClear();
			if (!storyFreeplay) routeCheck();
			#if ACHIEVEMENTS_ALLOWED
			checkForAchievement(achievesList);
			#end

			campaignScore += songScore;
			campaignMisses += songMisses;
			campaignNotes += totalPlayed;
			campaignHits += totalNotetrash;
			campaignSicks += sicks;
			campaignGoods += goods;
			campaignBads += bads;
			campaignTrashes += trashs;
			totalNotesHit += notesPressed;

			storyPlaylist.remove(storyPlaylist[0]);

			campaignAccuracy = Highscore.floorDecimal(Math.min(1, Math.max(0, campaignHits / campaignNotes)) * 100, 0);

			if(!ClientPrefs.getGameplaySetting('practice', false) && !ClientPrefs.getGameplaySetting('botplay', false)) 
			{
				if (SONG.validScore)
				{
					Highscore.saveWeekScore(WeekData.weekID, campaignScore, storyDifficulty);
				}
				FlxG.save.flush();
			}
			changedDifficulty = false;
		}
		if (route != 3 && !isBadEnding) Achievements.unlock('sf_alt');
		if (isBadEnding) Achievements.unlock('sf_bad');
	}

	public function KillNotes() {
		while(notes.length > 0) {
			var daNote:Note = notes.members[0];
			daNote.active = false;
			daNote.visible = false;

			daNote.kill();
			notes.remove(daNote, true);
			daNote.destroy();
		}
		unspawnNotes = [];
		eventNotes = [];
	}

	public var totalPlayed:Int = 0;
	public var totalNotetrash:Float = 0.0;
	public static var totalNotesHit:Int = 0;

	public var showCombo:Bool = true;
	public var showRating:Bool = true;

	private function popUpScore(note:Note = null):Void
	{
		var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition + ClientPrefs.ratingOffset);
		
		playervox.volume = 1;

		var placement:Float =  FlxG.width * 0.35;
		//

		var rating:FlxSprite = new FlxSprite();
		var score:Int = 350;

		//tryna do MS based judgment due to popular demand
		var daRating:String = Conductor.judgeNote(note, noteDiff);

		switch (daRating)
		{
			case "trash": // trash
				totalNotetrash += 0;
				note.ratingMod = 0;
				score = 50;
				if(!note.ratingDisabled) trashs++;
			case "bad": // bad
				totalNotetrash += 0.5;
				note.ratingMod = 0.5;
				score = 100;
				if(!note.ratingDisabled) bads++;
			case "good": // good
				totalNotetrash += 0.85;
				note.ratingMod = 0.85;
				score = 200;
				if(!note.ratingDisabled) goods++;
			case "sick": // sick
				totalNotetrash += 1;
				note.ratingMod = 1;
				if(!note.ratingDisabled) sicks++;
		}
		note.rating = daRating;
		notesPressed++;

		if(daRating == 'sick' && !note.noteSplashData.disabled)
		{
			spawnNoteSplashOnNote(note);
		}

		if(!practiceMode && !cpuControlled) {
			songScore += score;
			if(!note.ratingDisabled)
			{
				songHits++;
				totalPlayed++;
				RecalculateRating();
			}

			if(ClientPrefs.scoreZoom)
			{
				if(scoreTxtTween != null) {
					scoreTxtTween.cancel();
				}
				scoreTxt.scale.x = 1.075;
				scoreTxt.scale.y = 1.075;
				scoreTxtTween = FlxTween.tween(scoreTxt.scale, {x: 1, y: 1}, 0.2, {
					onComplete: function(twn:FlxTween) {
						scoreTxtTween = null;
					}
				});
			}
		}

		rating.loadGraphic(Paths.image('hudFolders/' + pixeltrashPart1 + daRating + pixeltrashPart2));
		rating.cameras = [camHUD];
		rating.screenCenter();
		rating.x = placement - 40;
		rating.y -= 60;
		rating.x += ClientPrefs.comboOffset[0];
		rating.y -= ClientPrefs.comboOffset[1];

		var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image('hudFolders/' + pixeltrashPart1 + 'combo' + pixeltrashPart2));
		comboSpr.cameras = [camHUD];
		comboSpr.screenCenter();
		comboSpr.x = placement;
		comboSpr.x += ClientPrefs.comboOffset[0];
		comboSpr.y -= ClientPrefs.comboOffset[1];

		insert(members.indexOf(strumLineNotes), rating);

		rating.setGraphicSize(Std.int(rating.width * 0.7));
		rating.antialiasing = ClientPrefs.globalAntialiasing;
		comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
		comboSpr.antialiasing = ClientPrefs.globalAntialiasing;

		comboSpr.updateHitbox();
		rating.updateHitbox();

		var seperatedScore:Array<Int> = [];

		if(combo >= 1000) {
			seperatedScore.push(Math.floor(combo / 1000) % 10);
		}
		seperatedScore.push(Math.floor(combo / 100) % 10);
		seperatedScore.push(Math.floor(combo / 10) % 10);
		seperatedScore.push(combo % 10);

		if (combo > highestCombo)
			highestCombo = combo;

		var daLoop:Int = 0;
		var xThing:Float = 0;
		var yThing:Float = 0;

		if (showCombo)
		{
			insert(members.indexOf(strumLineNotes), comboSpr);
		}

		for (i in seperatedScore)
		{
			var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image('hudFolders/' + pixeltrashPart1 + 'num' + Std.int(i) + pixeltrashPart2));
			numScore.cameras = [camHUD];
			numScore.screenCenter();
			numScore.x = placement + (43 * daLoop) - 90;
			numScore.y += 80;

			numScore.x += ClientPrefs.comboOffset[2];
			numScore.y -= ClientPrefs.comboOffset[3];

			numScore.antialiasing = ClientPrefs.globalAntialiasing;
			numScore.setGraphicSize(Std.int(numScore.width * 0.5));	
			numScore.updateHitbox();

			insert(members.indexOf(strumLineNotes), numScore);

			FlxTween.tween(numScore, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					numScore.destroy();
				},
				startDelay: Conductor.crochet * 0.001
			});

			daLoop++;
			xThing = numScore.x;
			yThing = numScore.y;
			FlxTween.tween(numScore.scale, {x: numScore.scale.x / 1.2, y: numScore.scale.y / 1.2}, 0.2, {
				onComplete: function(twn:FlxTween) {
				}
			});
		}
		comboSpr.x = xThing + 50;
		comboSpr.y = yThing - 11;

		rating.scale.x *= 1.2;
		rating.scale.y *= 1.2;
		FlxTween.tween(rating.scale, {x: rating.scale.x / 1.2, y: rating.scale.y / 1.2}, 0.2, {
			onComplete: function(twn:FlxTween) {
			}
		});
		comboSpr.scale.x *= 1.2;
		comboSpr.scale.y *= 1.2;
		FlxTween.tween(comboSpr.scale, {x: comboSpr.scale.x / 1.2, y: comboSpr.scale.y / 1.2}, 0.2, {
			onComplete: function(twn:FlxTween) {
			}
		});

		FlxTween.tween(rating, {alpha: 0}, 0.2, {
			startDelay: Conductor.crochet * 0.001
		});

		FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween)
			{
				comboSpr.destroy();
				rating.destroy();
			},
			startDelay: Conductor.crochet * 0.001
		});
	}

	public var strumsBlocked:Array<Bool> = [];
	private function onKeyPress(event:KeyboardEvent):Void
	{
		var eventKey:FlxKey = event.keyCode;
		var key:Int = getKeyFromEvent(eventKey);

		if (!cpuControlled && !paused && key > -1 && (FlxG.keys.checkStatus(eventKey, JUST_PRESSED)))
		{
			if(!boyfriend.stunned && generatedMusic && !endingSong)
			{
				//more accurate hit time for the ratings?
				var lastTime:Float = Conductor.songPosition;
				Conductor.songPosition = FlxG.sound.music.time;

				var canMiss:Bool = !ClientPrefs.ghostTapping;

				// heavily based on my own code LOL if it aint broke dont fix it
				var pressNotes:Array<Note> = [];
				var notesStopped:Bool = false;

				var sortedNotesList:Array<Note> = [];
				notes.forEachAlive(function(daNote:Note)
				{
					if (strumsBlocked[daNote.noteData] != true && daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit && !daNote.isSustainNote && !daNote.blockHit)
					{
						if(daNote.noteData == key)
						{
							sortedNotesList.push(daNote);
						}
						canMiss = true;
					}
				});
				sortedNotesList.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

				if (sortedNotesList.length > 0) {
					for (epicNote in sortedNotesList)
					{
						for (doubleNote in pressNotes) {
							if (Math.abs(doubleNote.strumTime - epicNote.strumTime) < 1) {
								doubleNote.kill();
								notes.remove(doubleNote, true);
								doubleNote.destroy();
							} else
								notesStopped = true;
						}
							
						// eee jack detection before was not super good
						if (!notesStopped) {
							goodNoteHit(epicNote);
							pressNotes.push(epicNote);
						}

					}
				}
				else if (canMiss) {
					noteMissPress(key);
				}

				keysPressed[key] = true;

				//more accurate hit time for the ratings? part 2 (Now that the calculations are done, go back to the time it was before for not causing a note stutter)
				Conductor.songPosition = lastTime;
			}

			var spr:StrumNote = playerStrums.members[key];
			if(strumsBlocked[key] != true && spr != null && spr.animation.curAnim.name != 'confirm')
			{
				spr.playAnim('pressed');
				spr.resetAnim = 0;
			}
		}
	}
	
	private function onKeyRelease(event:KeyboardEvent):Void
	{
		var eventKey:FlxKey = event.keyCode;
		var key:Int = getKeyFromEvent(eventKey);
		if(!cpuControlled && !paused && key > -1)
		{
			var spr:StrumNote = playerStrums.members[key];
			if(spr != null)
			{
				spr.playAnim('static');
				spr.resetAnim = 0;
			}
		}
	}

	private function getKeyFromEvent(key:FlxKey):Int
	{
		if(key != NONE)
		{
			for (i in 0...keysArray.length)
			{
				for (j in 0...keysArray[i].length)
				{
					if(key == keysArray[i][j])
					{
						return i;
					}
				}
			}
		}
		return -1;
	}

	// Hold notes
	private function keytrash():Void
	{
		if (controls.DODGE && !bfDodging && bfCanDodge)
		{
			bfDodging = true;
			bfCanDodge = false;
			dodgeCount++;
			boyfriend.playAnim('dodge');
	
			//Wait, then set bfDodging back to false.
			new FlxTimer().start(bfDodgeTiming, function(tmr:FlxTimer)
			{
				bfDodging=false;
				boyfriend.dance();
				//Cooldown timer so you can't keep spamming it.
				new FlxTimer().start(bfDodgeCooldown, function(tmr:FlxTimer)
				{
					bfCanDodge=true;
				});
			});
		}
		// HOLDING
		var up = controls.NOTE_UP;
		var right = controls.NOTE_RIGHT;
		var down = controls.NOTE_DOWN;
		var left = controls.NOTE_LEFT;
		var controlHoldArray:Array<Bool> = [left, down, up, right];

		if (!boyfriend.stunned && generatedMusic)
		{
			// rewritten inputs???
			notes.forEachAlive(function(daNote:Note)
			{
				// hold note functions
				if (strumsBlocked[daNote.noteData] != true && daNote.isSustainNote && controlHoldArray[daNote.noteData] && daNote.canBeHit 
				&& daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit && !daNote.blockHit) {
					goodNoteHit(daNote);
				}
			});

			if (controlHoldArray.contains(true) && !endingSong) {
				// none
			}
			else
			{
				if (boyfriend.holdTimer > Conductor.stepCrochet * 0.001 * boyfriend.singDuration && boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss') && !bfDodging)
					boyfriend.dance();
				if (boyfriend2 != null && boyfriend2.holdTimer > Conductor.stepCrochet * 0.001 * boyfriend2.singDuration && boyfriend2.animation.curAnim.name.startsWith('sing') && !boyfriend2.animation.curAnim.name.endsWith('miss'))
					boyfriend2.dance();
				if (boyfriend3 != null && boyfriend3.holdTimer > Conductor.stepCrochet * 0.001 * boyfriend3.singDuration && boyfriend3.animation.curAnim.name.startsWith('sing') && !boyfriend3.animation.curAnim.name.endsWith('miss'))
					boyfriend3.dance();
				if (boyfriend4 != null && boyfriend4.holdTimer > Conductor.stepCrochet * 0.001 * boyfriend4.singDuration && boyfriend4.animation.curAnim.name.startsWith('sing') && !boyfriend4.animation.curAnim.name.endsWith('miss'))
					boyfriend4.dance();
			}
		}
	}

	function noteMiss(daNote:Note):Void { //You didn't hit the key and let it go offscreen, also used by Hurt Notes
		//Dupe note remove
		notes.forEachAlive(function(note:Note) {
			if (daNote != note && daNote.mustPress && daNote.noteData == note.noteData && daNote.isSustainNote == note.isSustainNote && Math.abs(daNote.strumTime - note.strumTime) < 1) {
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
		});
		combo = 0;

		health -= daNote.missHealth * healthLoss;
		if(instakillOnMiss)
		{
			playervox.volume = 0;
			doDeathCheck(true);
		}

		//For testing purposes
		songMisses++;
		playervox.volume = 0;
		if(!practiceMode) songScore -= 10;
		
		totalPlayed++;
		RecalculateRating();

		var char:Character = boyfriend;
		if(daNote.gfNote) {
			char = gf;
		}
		if(daNote.char2 && boyfriend2 != null) {
			char = boyfriend2;
		}
		if(daNote.char3 && boyfriend3 != null) {
			char = boyfriend3;
		}
		if(daNote.char4 && boyfriend4 != null) {
			char = boyfriend4;
		}

		if(char != null && char.hasMissAnimations)
		{
			var daAlt = '';
			if(daNote.noteType == 'Alt Animation') daAlt = '-alt';

			var animToPlay:String = singAnimations[Std.int(Math.abs(daNote.noteData))] + 'miss' + daAlt;
			char.playAnim(animToPlay, true);
		}
		FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), ClientPrefs.misssoundVolume);
	}

	function noteMissPress(direction:Int = 1):Void //You pressed a key when there was no notes to press for this key
	{
		if (!boyfriend.stunned)
		{
			if(ClientPrefs.ghostTapping) return;
			if(instakillOnMiss)
			{
				playervox.volume = 0;
				doDeathCheck(true);
			}
			health -= 0.05 * healthLoss;

			if (combo > 5 && gf != null && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;

			if(!practiceMode) songScore -= 10;
			if(!endingSong) {
				songMisses++;
			}
			totalPlayed++;
			RecalculateRating();

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), ClientPrefs.misssoundVolume);
			
			if(boyfriend.hasMissAnimations && !bfDodging) {
				boyfriend.playAnim(singAnimations[Std.int(Math.abs(direction))] + 'miss', true);
			}
			playervox.volume = 0;
		}
	}

	function opponentNoteHit(note:Note):Void
	{
		if (Paths.formatToSongPath(SONG.song) != 'tutorial')
			camZooming = true;

		if(note.noteType == 'Hey!' && dad.animOffsets.exists('hey')) {
			dad.playAnim('hey', true);
			dad.specialAnim = true;
			dad.heyTimer = 0.6;
		} else if(!note.noAnimation) {
			var altAnim:String = "";

			var curSection:Int = Math.floor(curStep / 16);
			if (SONG.notes[curSection] != null)
			{
				if (SONG.notes[curSection].altAnim || note.noteType == 'Alt Animation') {
					altAnim = '-alt';
				}
			}

			var char:Character = dad;
			var animToPlay:String = singAnimations[Std.int(Math.abs(note.noteData))] + altAnim;
			if(note.gfNote) {
				char = gf;
			}

			if(char != null && !char.animation.curAnim.name.startsWith('punch'))
			{
				char.playAnim(animToPlay, true);
				char.holdTimer = 0;
			}
		}
		if (note.char2)
		{
			var char:Character = dad2;
			var animToPlay:String = singAnimations[Std.int(Math.abs(note.noteData))];

			if(char != null)
			{
				char.playAnim(animToPlay, true);
				char.holdTimer = 0;
			}
		}
		if (note.char3)
		{
			var char:Character = dad3;
			var animToPlay:String = singAnimations[Std.int(Math.abs(note.noteData))];
	
			if(char != null)
			{
				char.playAnim(animToPlay, true);
				char.holdTimer = 0;
			}
		}
		if (note.char4)
		{
			var char:Character = dad4;
			var animToPlay:String = singAnimations[Std.int(Math.abs(note.noteData))];
	
			if(char != null)
			{
				char.playAnim(animToPlay, true);
				char.holdTimer = 0;
			}
		}

		if (healthDrain || forceHealthDrain)
		{
			health -= 0.016;
			if (health <= 0.04)
				health = 0.04;
		}

		if (SONG.needsVoices)
			vocals.volume = 1;

		var time:Float = 0.15;
		if(note.isSustainNote && !note.animation.curAnim.name.endsWith('end')) {
			time += 0.15;
		}
		StrumPlayAnim(true, Std.int(Math.abs(note.noteData)) % 4, time);
		note.hitByOpponent = true;

		if (!note.isSustainNote)
		{
			note.kill();
			notes.remove(note, true);
			note.destroy();
		}
	}

	function goodNoteHit(note:Note):Void
	{
		if (!note.wasGoodHit)
		{
			if (ClientPrefs.hitsoundVolume > 0 && !note.hitsoundDisabled)
			{
				FlxG.sound.play(Paths.sound('hitsound'), ClientPrefs.hitsoundVolume);
			}

			if(cpuControlled && (note.ignoreNote || note.hitCausesMiss)) return;

			if(note.hitCausesMiss) {
				noteMiss(note);
				if(!note.noteSplashData.disabled && !note.isSustainNote) {
					spawnNoteSplashOnNote(note);
				}

				switch(note.noteType) {
					case 'Hurt Note': //Hurt note
						if(boyfriend.animation.getByName('hurt') != null) {
							boyfriend.playAnim('hurt', true);
							boyfriend.specialAnim = true;
						}
				}
				
				note.wasGoodHit = true;
				if (!note.isSustainNote)
				{
					note.kill();
					notes.remove(note, true);
					note.destroy();
				}
				return;
			}

			if (!note.isSustainNote)
			{
				combo += 1;
				popUpScore(note);
				if(combo > 9999) combo = 9999;
			}
			health += note.hitHealth * healthGain;

			if(!note.noAnimation) {
				var daAlt = '';
				if(note.noteType == 'Alt Animation') daAlt = '-alt';
	
				var animToPlay:String = singAnimations[Std.int(Math.abs(note.noteData))];

				if(note.gfNote) 
				{
					if(gf != null)
					{
						gf.playAnim(animToPlay + daAlt, true);
						gf.holdTimer = 0;
					}
				}
				else
				{
					if (!bfDodging)
					{
						boyfriend.playAnim(animToPlay + daAlt, true);
						boyfriend.holdTimer = 0;
					}
				}

				if(note.noteType == 'Hey!') {
					if(boyfriend.animOffsets.exists('hey')) {
						boyfriend.playAnim('hey', true);
						boyfriend.specialAnim = true;
						boyfriend.heyTimer = 0.6;
					}
	
					if(gf != null && gf.animOffsets.exists('cheer')) {
						gf.playAnim('cheer', true);
						gf.specialAnim = true;
						gf.heyTimer = 0.6;
					}
				}
			}
			if (note.char2 && boyfriend2 != null)
			{
				var animToPlay:String = singAnimations[Std.int(Math.abs(note.noteData))];
				boyfriend2.playAnim(animToPlay, true);
				boyfriend2.holdTimer = 0;
			}
			if (note.char3 && boyfriend3 != null)
			{
				var animToPlay:String = singAnimations[Std.int(Math.abs(note.noteData))];
				boyfriend3.playAnim(animToPlay, true);
				boyfriend3.holdTimer = 0;
			}
			if (note.char4 && boyfriend4 != null)
			{
				var animToPlay:String = singAnimations[Std.int(Math.abs(note.noteData))];
				boyfriend4.playAnim(animToPlay, true);
				boyfriend4.holdTimer = 0;
			}

			if(cpuControlled) {
				var time:Float = 0.15;
				if(note.isSustainNote && !note.animation.curAnim.name.endsWith('end')) {
					time += 0.15;
				}
				StrumPlayAnim(false, Std.int(Math.abs(note.noteData)) % 4, time);
			} else {
				playerStrums.forEach(function(spr:StrumNote)
				{
					if (Math.abs(note.noteData) == spr.ID)
					{
						spr.playAnim('confirm', true);
					}
				});
			}
			note.wasGoodHit = true;
			playervox.volume = 1;

			var isSus:Bool = note.isSustainNote; //AMONGUS
			var leData:Int = Math.round(Math.abs(note.noteData));
			var leType:String = note.noteType;

			if (!note.isSustainNote)
			{
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
		}
	}

	public function spawnNoteSplashOnNote(note:Note) {
		if(ClientPrefs.noteSplashes && note != null) {
			var strum:StrumNote = playerStrums.members[note.noteData];
			if(strum != null)
				spawnNoteSplash(strum.x, strum.y, note.noteData, note);
		}
	}

	public function spawnNoteSplash(x:Float, y:Float, data:Int, ?note:Note = null) {
		var skin:String = 'noteSplashes/' + splashTexture;
		if(PlayState.SONG.splashSkin != null && PlayState.SONG.splashSkin.length > 0) skin = PlayState.SONG.splashSkin;

		if(note != null) {
			skin = note.noteSplashData.texture;
		}

		var splash:NoteSplash = grpNoteSplashes.recycle(NoteSplash);
		splash.setupNoteSplash(x, y, data, note, skin);
		grpNoteSplashes.add(splash);
	}

	override function destroy() {
		FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
		FlxG.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyRelease);
		FlxG.mouse.visible = true;
		MusicBeatState.reloadCursor();
		super.destroy();
	}

	public static function cancelMusicFadeTween() {
		if(FlxG.sound.music.fadeTween != null) {
			FlxG.sound.music.fadeTween.cancel();
		}
		FlxG.sound.music.fadeTween = null;
	}

	function funnyGlitch(value:Int, duration:Float):Void
	{
		if (duration <= 0)
			return;

		shaderEffect = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height);
		shaderEffect.scrollFactor.set(0, 0);
		shaderEffect.screenCenter();
		shaderEffect.cameras = [camHUD];

		var shaderName:String = "";
		switch (value)
		{
			case 3:
				shaderName = "glitchC";
			case 2:
				shaderName = "glitchB";
			default:
				shaderName = "glitchA";
		}
        initShader(shaderName);
        
        shader0 = createRuntimeShader(shaderName);
        camGame.setFilters([new ShaderFilter(shader0)]);
        shaderEffect.shader = shader0;
        camHUD.setFilters([new ShaderFilter(shaderEffect.shader)]);
		camGame.filtersEnabled = true;
		camHUD.filtersEnabled = true;
		new FlxTimer().start(duration, function(tmr:FlxTimer)
		{
			camGame.filtersEnabled = false;
			camHUD.filtersEnabled = false;
		});
	}

	function funnyGlitchLegacy(duration:Float):Void
	{
		//Got this from DDTO Bad Ending, and I have no regrets.
		if (duration <= 0)
			return;
	
		camGame.filtersEnabled = true;
		FlxTween.tween(this, {staticAlpha: 1}, 0.5, {ease:FlxEase.circOut});
	
		new FlxTimer().start(duration, function(tmr:FlxTimer)
		{
			camGame.filtersEnabled = false;
		});
	}

	var lastStepHit:Int = -1;

	override function stepHit()
	{
		super.stepHit();
		if (Math.abs(FlxG.sound.music.time - (Conductor.songPosition - Conductor.offset)) > 20
			|| (SONG.needsVoices && Math.abs(vocals.time - (Conductor.songPosition - Conductor.offset)) > 20)
			|| (SONG.needsVoices && Math.abs(playervox.time - (Conductor.songPosition - Conductor.offset)) > 20))
		{
			resyncVocals();
		}

		if(curStep == lastStepHit) {
			return;
		}

		lastStepHit = curStep;

		if (camBounce)
		{
			if (curStep % 4 == 0)
			{
				FlxTween.tween(camHUD, {y: -12}, Conductor.stepCrochet * 0.002, {ease: FlxEase.circOut});
				FlxTween.tween(camGame.scroll, {y: 12}, Conductor.stepCrochet * 0.002, {ease: FlxEase.sineIn});
			}
			if (curStep % 4 == 2)
			{
				FlxTween.tween(camHUD, {y: 0}, Conductor.stepCrochet * 0.002, {ease: FlxEase.sineIn});
				FlxTween.tween(camGame.scroll, {y: 0}, Conductor.stepCrochet * 0.002, {ease: FlxEase.sineIn});
			}
		}

		if(interlopeAngle)
		{
			if(curStep % 2 == 0){
				for (i in 0...playerStrums.length) {
					playerStrums.members[i].angle += 22.5;

					if(playerStrums.members[i].angle >= 360){
						playerStrums.members[i].angle = (playerStrums.members[i].angle % 360) * 360;
					}
					opponentStrums.members[i].angle = playerStrums.members[i].angle;
				}
			}
		}

		if (curSong.toLowerCase() == 'hxppy thxughts' && !endingSong)
		{
			if ((curStep >= 880 && curStep < 994) || curStep > 1984)
				canPause = false;
			if (curStep >= 994 || curStep < 1985)
				canPause = true;
			if (curStep == 900)
				sayonaraLoser();
		}

		if (curSong.toLowerCase() == 'cxnnamon bxn' && !endingSong)
		{
			if ((curStep >= 601 && curStep < 784) || curStep > 1696)
				canPause = false;
			if (curStep >= 784 && curStep < 1697)
				canPause = true;
			if (curStep == 620)
				sayonaraLoser();
		}

		if (curSong.toLowerCase() == 'glitch' && !endingSong)
		{
			if (curStep >= 1536)
				canPause = false;
		}

		if (curSong.toLowerCase() == 'yandere' && !endingSong)
		{
			if (curStep >= 576 && curStep < 616)
				canPause = false;
			if (curStep >= 616)
				canPause = true;
			if (curStep == 588) {
				timeBar.visible = false;
				timeTxt.visible = false;
			}
			if (curStep == 604)
				yuriGoesCuckcoo();
		}

		if (curSong.toLowerCase() == 'obsessed' && !endingSong)
		{
			if (curStep >= 1440)
				canPause = false;
		}

		if (curSong.toLowerCase() == 'psychopath' && !endingSong)
		{
			if (curStep >= 1472)
				canPause = false;
		}

		if (curSong.toLowerCase() == 'script error' && !endingSong)
		{
			if (curStep >= 3008)
				canPause = false;

			if (curStep == 4 && ClientPrefs.playerChar == 3)
			{
				FlxG.sound.play(Paths.sound('monikaTransform'));
				whiteFade.alpha = 0;
				FlxTween.tween(whiteFade, {alpha: 1}, 4.776, {ease: FlxEase.linear});
			}
			if (curStep == 64 && ClientPrefs.playerChar == 3)
			{
				remove(black);
				FlxTween.cancelTweensOf(whiteFade);
				whiteFade.alpha = 0;
				timeBarBG.visible = true;
				timeBar.visible = true;
				timeTxt.visible = true;
				leCoolSongName();
			}
		}
	
		if (curSong.toLowerCase() == 'system failure' && !endingSong)
		{
			if (curStep > 1 && isStoryMode)
				canPause = false;
			if (curStep == 48){
				remove(black);
				timeBarBG.visible = true;
				timeBar.visible = true;
				timeTxt.visible = true;
			}
			if (curStep == 752){
				opponentStrums.members[0].x = defaultPlayerStrumX1;
				opponentStrums.members[1].x = defaultPlayerStrumX2;
				opponentStrums.members[2].x = defaultPlayerStrumX3;
				opponentStrums.members[3].x = defaultPlayerStrumX4;
				playerStrums.members[0].x = defaultOpponentStrumX1;
				playerStrums.members[1].x = defaultOpponentStrumX2;
				playerStrums.members[2].x = defaultOpponentStrumX3;
				playerStrums.members[3].x = defaultOpponentStrumX4;
			}
			if (curStep == 1008){
				opponentStrums.members[0].x = defaultOpponentStrumX1;
				opponentStrums.members[1].x = defaultOpponentStrumX2;
				opponentStrums.members[2].x = defaultOpponentStrumX3;
				opponentStrums.members[3].x = defaultOpponentStrumX4;
				playerStrums.members[0].x = defaultPlayerStrumX1;
				playerStrums.members[1].x = defaultPlayerStrumX2;
				playerStrums.members[2].x = defaultPlayerStrumX3;
				playerStrums.members[3].x = defaultPlayerStrumX4;
			}
			if (curStep == 1360){
				scoreTxt.alpha = 0;
				healthBar.alpha = 0;
				timeBarBG.alpha = 0;
				timeBar.alpha = 0;
				timeTxt.alpha = 0;
				dad.alpha = 0;
				boyfriend.alpha = 0;
				gf.alpha = 1;
				for (i in 0...4)
				{
					opponentStrums.members[i].alpha = 0;
					playerStrums.members[i].alpha = 0;
				}
				if (!isMiddleScroll)
				{
					defaultPlayerStrumX1 = 415;
					defaultPlayerStrumX2 = 523;
					defaultPlayerStrumX3 = 637;
					defaultPlayerStrumX4 = 745;
					playerStrums.members[0].x = 415;
					playerStrums.members[1].x = 523;
					playerStrums.members[2].x = 637;
					playerStrums.members[3].x = 745;
				}
			}
			if (curStep == 1792){
				gf.alpha = 0;
				boyfriend.alpha = 1;
				dad.alpha = 1;
				scoreTxt.alpha = 1;
				healthBar.alpha = 1;
				for (i in 0...4)
				{
					playerStrums.members[i].alpha = 1;
				}
			}
			if (curStep == 2700){
				scoreTxt.alpha = 0;
				healthBar.alpha = 0;
				dad.alpha = 0;
			}
			if (curStep == 3104){
				FlxTween.tween(gf, {alpha: 1}, 6, {ease: FlxEase.linear});
			}
			if (curStep == 3168){
				missTxt.alpha = 1;
				gf.x -= 200;
				gf.alpha = 0;
				dad.alpha = 1;
			}
			if (curStep == 3680){
				missTxt.alpha = 0;
				boyfriend.alpha = 0;
				dad.alpha = 0;
				FlxTween.tween(gf, {alpha: 1}, 6, {ease: FlxEase.linear});
				for (i in 0...4)
				{
					playerStrums.members[i].alpha = 0;
				}
			}
			if (curStep == 3741){
				dad.alpha = 1;
				gf.alpha = 0;
			}
			if (curStep == 3742){
				dad.alpha = 0;
				gf.alpha = 1;
			}
			if (curStep == 3743){
				dad.alpha = 1;
				gf.alpha = 0;
			}
			if (curStep == 3744){
				missTxt.alpha = 1;
				boyfriend.alpha = 1;
				for (i in 0...4)
				{
					playerStrums.members[i].alpha = 1;
				}
			}
			if (curStep == 4064) {
				dad.alpha = 0;
				boyfriend.alpha = 0;
				FlxTween.tween(boyfriend, {alpha: 1}, 0.7, {ease: FlxEase.linear});
				FlxTween.tween(gf, {alpha: 1}, 0.7, {ease: FlxEase.linear});
			}
			if (curStep == 4096) {
				gf.alpha = 0;
				dad.alpha = 1;
			}
			if (curStep == 4224 || curStep == 4288) {
				FlxTween.tween(gf, {alpha: 0.5}, 0.5, {ease: FlxEase.linear});
			}
			if (curStep == 4256) {
				FlxTween.tween(gf, {alpha: 0}, 0.5, {ease: FlxEase.linear});
			}
			if (curStep == 4352) {
				dad.alpha = 0;
				boyfriend.alpha = 0;
				gf.alpha = 0;
			}
			if (curStep == 4368) {
				triggerEnding(ClientPrefs.playerChar, songMisses);
			}
		}

		if (curSong.toLowerCase() == 'candy heartz' && !endingSong)
		{
			if (curStep >= 52)
			{
				timeTxt.alpha = 1;
				timeBar.alpha = 1;
				timeBarBG.alpha = 1;
				canPause = false;
			}
		}

		if (curSong.toLowerCase() == 'ultimate glitcher' && !endingSong)
		{
			if (curStep == 320){
				for (i in 0...4)
				{
					FlxTween.cancelTweensOf(opponentStrums.members[i]);
					FlxTween.tween(opponentStrums.members[i], {alpha: 0}, 1.5, {ease: FlxEase.linear});
				}
			}
			if (curStep == 448){
				FlxTween.tween(scoreTxt, {alpha: 0}, 1.5, {ease: FlxEase.linear});
				FlxTween.tween(timeBarBG, {alpha: 0}, 1.5, {ease: FlxEase.linear});
				FlxTween.tween(timeBar, {alpha: 0}, 1.5, {ease: FlxEase.linear});
				FlxTween.tween(timeTxt, {alpha: 0}, 1.5, {ease: FlxEase.linear});
			}
			if (curStep == 576){
				FlxTween.tween(healthBar, {alpha: 0}, 1.5, {ease: FlxEase.linear});
			}
			if (curStep >= 1600)
				strumLineNotes.visible = false;
			if (curStep == 1856){
				health = 0.1;
				notes.visible = false;
				healthBar.visible = false;
				scoreTxt.visible = false;
				strumLineNotes.visible = false;
				camZooming = false;
				camHUD.visible = false;
			}
			if (curStep == 1872){
				camHUD.visible = true;
				add(blueScreen);
				blueScreen.animation.play('show');
			}
		}

		if (curSong.toLowerCase() == 'the final battle' && !endingSong)
		{
			if (curStep == 480){
				for (i in 0...4)
				{
					FlxTween.cancelTweensOf(opponentStrums.members[i]);
					FlxTween.tween(opponentStrums.members[i], {alpha: 0}, 1.5, {ease: FlxEase.linear});
				}
			}
			if (curStep == 848){
				FlxTween.tween(scoreTxt, {alpha: 0}, 1.5, {ease: FlxEase.linear});
				FlxTween.tween(timeBarBG, {alpha: 0}, 1.5, {ease: FlxEase.linear});
				FlxTween.tween(timeBar, {alpha: 0}, 1.5, {ease: FlxEase.linear});
				FlxTween.tween(timeTxt, {alpha: 0}, 1.5, {ease: FlxEase.linear});
			}
			if (curStep == 864 && health > 1.8)
				health = 1.8;
			if (curStep >= 1392)
				canPause = false;
			if (curStep == 1408){
				FlxTween.tween(healthBar, {alpha: 0}, 1.5, {ease: FlxEase.linear});
			}
			if (curStep == 1504){
				FlxTween.tween(playerStrums.members[0], {angle: 90}, 0.1, {ease: FlxEase.linear});
				FlxTween.tween(playerStrums.members[1], {angle: 90}, 0.1, {ease: FlxEase.linear});
				FlxTween.tween(playerStrums.members[2], {angle: 90}, 0.1, {ease: FlxEase.linear});
				FlxTween.tween(playerStrums.members[3], {angle: 90}, 0.1, {ease: FlxEase.linear});
				if (health > 1.5)
					health = 1.5;
			}
			if (curStep == 1760){
				FlxTween.tween(playerStrums.members[0], {angle: 0}, 0.1, {ease: FlxEase.linear});
				FlxTween.tween(playerStrums.members[1], {angle: 0}, 0.1, {ease: FlxEase.linear});
				FlxTween.tween(playerStrums.members[2], {angle: 0}, 0.1, {ease: FlxEase.linear});
				FlxTween.tween(playerStrums.members[3], {angle: 0}, 0.1, {ease: FlxEase.linear});
			}
			if (curStep == 1888 && health > 1)
				health = 1;
			if (curStep == 2144 && health > 0.8)
				health = 0.8;
			if (curStep == 2272){
				if (!isMiddleScroll)
				{
					playerStrums.members[0].x = 412;
					playerStrums.members[1].x = 524;
					playerStrums.members[2].x = 636;
					playerStrums.members[3].x = 748;
				}
				if (health > 0.3)
					health = 0.3;
			}
			if (curStep >= 2816)
				camZooming = false;
			if (curStep == 2828){
				add(blueScreen);
				blueScreen.animation.play('show');
			}
		}

		if (curSong.toLowerCase() == 'flower power' && !endingSong)
		{
			if (curStep >= 4 && curStep < 128)
				add(funnyComment);
			if (curStep >= 128){
				remove(funnyComment);
				remove(black);
			}
		}

		if (curSong.toLowerCase() == 'supernatural' && !endingSong)
		{
			if (curStep == 224){
				dad.alpha = 0.5;
				healthBar.iconP2.alpha = 1;
				healthBar.barOPP.alpha = 1;
				healthBar.meterOPP.alpha = 1;
				health = 0.5;
				for (i in 0...4)
				{
					FlxTween.cancelTweensOf(opponentStrums.members[i]);
					opponentStrums.members[i].alpha = 0.3;
				}
			}
			if (curStep == 1936){
				FlxTween.tween(dad, {alpha: 0}, 8, {ease: FlxEase.linear});
				FlxTween.tween(healthBar.iconP2, {alpha: 0}, 8, {ease: FlxEase.linear});
				FlxTween.tween(healthBar.barOPP, {alpha: 0}, 8, {ease: FlxEase.linear});
				FlxTween.tween(healthBar.meterOPP, {alpha: 0}, 8, {ease: FlxEase.linear});
				for (i in 0...4)
				{
					FlxTween.tween(opponentStrums.members[i], {alpha: 0}, 8, {ease: FlxEase.linear});
				}
			}
		}

		if (curSong.toLowerCase() == 'roar of natsuki' && !endingSong)
		{
			if (curStep >= 64) dad.alpha = 1;
			if (curStep >= 1696) ppMusic = true;
		}
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	var lastBeatHit:Int = -1;
	
	override function beatHit()
	{
		super.beatHit();

		if(lastBeatHit >= curBeat) {
			return;
		}

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, ClientPrefs.downScroll ? FlxSort.ASCENDING : FlxSort.DESCENDING);
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
			}
		}
		
		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null && !endingSong && !isCameraOnForcedPos)
		{
			moveCameraSection(Std.int(curStep / 16));
		}
	
		if (camZooming && FlxG.camera.zoom < 1.35 && ClientPrefs.camZooms && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		healthBar.bopIcons(isDokiDoki, curBeat % 2 == 0);
		
		if (gf != null && curBeat % Math.round(gfSpeed * gf.danceEveryNumBeats) == 0 && !gf.stunned && gf.animation.curAnim.name != null && !gf.animation.curAnim.name.startsWith("sing") && !gf.stunned)
		{
			if (yandereMode && gfStillVisible)
			{
				gf.playAnim('scared', true);
			}
			else
				gf.dance();
		}
		if (curBeat % boyfriend.danceEveryNumBeats == 0 && boyfriend.animation.curAnim != null && !boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.stunned && !bfDodging)
		{
			boyfriend.dance();
		}
		if (curBeat % dad.danceEveryNumBeats == 0 && dad.animation.curAnim != null && !dad.animation.curAnim.name.startsWith('sing') && !dad.stunned && !dad.animation.curAnim.name.startsWith('punch'))
		{
			dad.dance();
		}

		if (SONG.song.toLowerCase() == 'yuri is a raccoon')
		{
			if (curBeat % dad2.danceEveryNumBeats == 0 && dad2.animation.curAnim != null && !dad2.animation.curAnim.name.startsWith('sing') && !dad2.stunned)
			{
				dad2.dance();
			}
			if (curBeat % dad3.danceEveryNumBeats == 0 && dad3.animation.curAnim != null && !dad3.animation.curAnim.name.startsWith('sing') && !dad3.stunned)
			{
				dad3.dance();
			}
			if (curBeat % boyfriend2.danceEveryNumBeats == 0 && boyfriend2.animation.curAnim != null && !boyfriend2.animation.curAnim.name.startsWith('sing') && !boyfriend2.stunned)
			{
				boyfriend2.dance();
			}
		}

		if (camZoomBeat)
			triggerEventNote("Add Camera Zoom", "0.015", "0.03");

		if(interlopeTweenThing)
		{
			if (downOnUp)
			{
				if(curBeat % 8 == 0){
					FlxTween.tween(playerStrums.members[0], {x: 428}, 1.5, {ease: FlxEase.linear});
				}
				if(curBeat % 8 == 4){
					FlxTween.tween(playerStrums.members[0], {x: 1068}, 1.5, {ease: FlxEase.linear});
				}
			}
			else
			{
				if(curBeat % 8 == 0){
					FlxTween.tween(playerStrums.members[0], {x: 92}, 1.5, {ease: FlxEase.linear});
				}
				if(curBeat % 8 == 4){
					FlxTween.tween(playerStrums.members[0], {x: 732}, 1.5, {ease: FlxEase.linear});
				}
			}
		}

		if (interlopeNoteSwap)
		{
			if (curBeat % 2 == 0)
			{
				opponentStrums.members[0].x = 92;
				opponentStrums.members[1].x = 204;
				opponentStrums.members[2].x = 316;
				opponentStrums.members[3].x = 428;
				playerStrums.members[0].x = 732;
				playerStrums.members[1].x = 844;
				playerStrums.members[2].x = 956;
				playerStrums.members[3].x = 1068;
			}
			else
			{
				opponentStrums.members[0].x = 732;
				opponentStrums.members[1].x = 844;
				opponentStrums.members[2].x = 956;
				opponentStrums.members[3].x = 1068;
				playerStrums.members[0].x = 92;
				playerStrums.members[1].x = 204;
				playerStrums.members[2].x = 316;
				playerStrums.members[3].x = 428;
			}
		}
	
		lastBeatHit = curBeat;
	}

	function justartBop() {
		boyfriend.y += 20;
		dad.y += 20;
		boyfriend2.y += 25;
		dad2.y += 25;
		dad3.y += 25;
		FlxTween.tween(boyfriend, {y:boyfriend.y - 20}, (Conductor.stepCrochet * 3 / 1000), {ease:FlxEase.circInOut});
		FlxTween.tween(dad, {y:dad.y - 20}, (Conductor.stepCrochet * 3 / 1000), {ease:FlxEase.circInOut});
		FlxTween.tween(boyfriend2, {y:boyfriend2.y - 25}, (Conductor.stepCrochet * 3 / 1000), {ease:FlxEase.circInOut});
		FlxTween.tween(dad2, {y:dad2.y - 25}, (Conductor.stepCrochet * 3 / 1000), {ease:FlxEase.circInOut});
		FlxTween.tween(dad3, {y:dad3.y - 25}, (Conductor.stepCrochet * 3 / 1000), {ease:FlxEase.circInOut});
	}

	function StrumPlayAnim(isDad:Bool, id:Int, time:Float) {
		var spr:StrumNote = null;
		if(isDad) {
			spr = strumLineNotes.members[id];
		} else {
			spr = playerStrums.members[id];
		}

		if(spr != null) {
			spr.playAnim('confirm', true);
			spr.resetAnim = time;
		}
	}

	public var ratingName:String = '?';
	public var ratingPercent:Float;
	public static var songAccuracy:Int;
	public var ratingFC:String;
	public function RecalculateRating() {
		if(totalPlayed < 1) //Prevent divide by 0
			ratingName = '?';
		else
		{
			// Rating Percent
			ratingPercent = Math.min(1, Math.max(0, totalNotetrash / totalPlayed));
				
			if(ratingPercent >= 1)
			{
				ratingName = ratingStuff[ratingStuff.length-1][0]; //Uses last string
			}
			else
			{
				for (i in 0...ratingStuff.length-1)
				{
					if(ratingPercent < ratingStuff[i][1])
					{
						ratingName = ratingStuff[i][0];
						break;
					}
				}
			}
		}

		// Rating FC
		ratingFC = "";
		if (sicks > 0 && goods < 1 && bads < 1 && trashs < 1 && songMisses < 1) ratingFC = "SFC";
		if (goods > 0 && bads < 1 && trashs < 1 && songMisses < 1) ratingFC = "GFC";
		if (bads > 0 || trashs > 0 && songMisses < 1) ratingFC = "FC";

		if (songMisses > 0 && songMisses < 10) ratingFC = "SDCB";
		else if (songMisses >= 10) ratingFC = "Clear";
	}

	function sayonaraLoser()
	{
		timeBarBG.visible = false;
		timeBar.visible = false;
		timeTxt.visible = false;
		gf.alpha = 0;
		if (health > 0.5)
			health = 0.5;
		switch (ClientPrefs.playerChar)
		{
			case 1:
				triggerEventNote("Change Character", "bf", "bf-scared");
			case 2:
				triggerEventNote("Change Character", "bf", "jr-scared");
			case 3:
				triggerEventNote("Change Character", "bf", "monika-scared");
		}
	}

	function yuriGoesCuckcoo()
	{
		if (health > 0.5)
			health = 0.5;
		yandereMode = true;
		switch (ClientPrefs.playerChar)
		{
			case 1:
				triggerEventNote("Change Character", "bf", "bf-scared");
			case 2:
				triggerEventNote("Change Character", "bf", "jr-scared");
			case 3:
				triggerEventNote("Change Character", "bf", "monika-scared");
		}
	}

	#if ACHIEVEMENTS_ALLOWED
	private function checkForAchievement(achievesToCheck:Array<String> = null)
	{
		if(chartingMode) return null;

		var usedPractice:Bool = (ClientPrefs.getGameplaySetting('practice', false) || ClientPrefs.getGameplaySetting('botplay', false));
		if(cpuControlled) return;

		for (name in achievesToCheck)
		{
			var unlock:Bool = false;
			switch(name)
			{
				case 'S_nomiss' | 'N_nomiss' | 'Y_nomiss' | 'M_nomiss' | 'Sx_nomiss' | 'G_nomiss' | 'Yd_nomiss' | 'JM_nomiss':
					if(isStoryMode && campaignMisses + songMisses < 1 && storyPlaylist.length <= 1 && !changedDifficulty && !usedPractice)
					{
						var weekName:String = WeekData.weekID;
						switch(weekName) //I know this is a lot of duplicated code, but it's easier readable and you can add weeks with different names than the achievement tag
						{
							case 'Sayori BF' | 'Sayori JR' | 'Sayori MONI':
								if(name == 'S_nomiss') unlock = true;
							case 'Natsuki BF' | 'Natsuki JR' | 'Natsuki MONI':
								if(name == 'N_nomiss') unlock = true;
							case 'Yuri BF' | 'Yuri JR' | 'Yuri MONI':
								if(name == 'Y_nomiss') unlock = true;
							case 'Monika BF' | 'Monika JR':
								if(name == 'M_nomiss') unlock = true;
							case 'Sxyori BF' | 'Sxyori JR':
								if(name == 'Sx_nomiss') unlock = true;
							case 'Glitchsuki BF' | 'Glitchsuki JR':
								if(name == 'G_nomiss') unlock = true;
							case 'Yurdere BF' | 'Yurdere JR':
								if(name == 'Yd_nomiss') unlock = true;
							case 'Final BF' | 'Final JR' | 'Final MONI':
								if(name == 'JM_nomiss') unlock = true;
						}
					}
				case 'bfRoute_clear' | 'jrRoute_clear' | 'moniRoute_clear':
					if (isStoryMode && storyPlaylist.length <= 1 && !changedDifficulty && !usedPractice)
					{
						switch (ClientPrefs.playerChar)
						{
							case 1:
								if (curSong.toLowerCase() == 'script error')
									if(name == 'bfRoute_clear') unlock = true;
							case 2:
								if (curSong.toLowerCase() == 'script error')
									if(name == 'jrRoute_clear') unlock = true;
							case 3:
								if (curSong.toLowerCase() == 'system failure')
									if(name == 'moniRoute_clear') unlock = true;
						}
					}
				case 'first_clear':
					if (SaveData.bfRouteClear || SaveData.jrRouteClear || SaveData.monikaRouteClear) unlock = true;
				case 'normal_clear':
					if (SaveData.bfRouteClear && SaveData.jrRouteClear && SaveData.monikaRouteClear) unlock = true;
				case 'classic_clear':
					if (SaveData.clearAllClassic) unlock = true;
				case 'bonus_clear':
					if (SaveData.clearAllBonus) unlock = true;
				case 'all_clear':
					if (SaveData.clearAllNormal && SaveData.clearAllClassic && SaveData.clearAllBonus) unlock = true;
				case 'nice_clear':
					if (songAccuracy >= 69 && songAccuracy < 70 && !usedPractice) unlock = true;
				case 'se_combo':
					if (curSong.toLowerCase() == 'script error' && highestCombo >= 250 && !changedDifficulty && !usedPractice) unlock = true;
				case 'sf_double':
					if (SaveData.sayoriDeaths >= 2) unlock = true;
				case 'heartz_clear':
					if (curSong.toLowerCase() == 'candy heartz' && songAccuracy >= 90 && !changedDifficulty && !usedPractice) unlock = true;
				case 'glitcher_clear':
					if (curSong.toLowerCase() == 'ultimate glitcher' && instaKillNotes && !changedDifficulty && !usedPractice) unlock = true;
				case 'tfb_clear':
					if (curSong.toLowerCase() == 'the final battle' && instaKillNotes && !changedDifficulty && !usedPractice) unlock = true;
				case 'supernatural_nomiss':
					if (curSong.toLowerCase() == 'supernatural' && songMisses < 1 && !changedDifficulty && !usedPractice) unlock = true;
				case 'spiders_combo':
					if (curSong.toLowerCase() == 'spiders of markov' && highestCombo >= 300 && !changedDifficulty && !usedPractice) unlock = true;
				case 'secret_clear':
					if (curSong.toLowerCase() == 'un-welcome to the club' && ClientPrefs.playerChar == 3 && ClientPrefs.freeplayCutscenes  && !changedDifficulty && !usedPractice) unlock = true;
				case 'showoff_clear':
					if (curSong.toLowerCase() == 'roar of natsuki' && dodgeCount >= 50 && !changedDifficulty && !usedPractice) unlock = true;
				case 'crossover_clear':
					if (curSong.toLowerCase() == 'crossover clash' && songAccuracy >= 94 && !changedDifficulty && !usedPractice) unlock = true;
				case 'festival_clear':
					if (curSong.toLowerCase() == 'festival deluxe' && songMisses < 20 && !changedDifficulty && !usedPractice) unlock = true;
			}
			if(unlock) Achievements.unlock(name);
		}
	}
	#end

	function mixUpNotePositions(?angleToo:Bool = false)
	{
		if (!ClientPrefs.downScroll)
		{
			playerStrums.members[0].y = FlxG.random.int(20, 385);
			playerStrums.members[1].y = FlxG.random.int(20, 385);
			playerStrums.members[2].y = FlxG.random.int(20, 385);
			playerStrums.members[3].y = FlxG.random.int(20, 385);
		}
		else
		{
			playerStrums.members[0].y = FlxG.random.int(250, 580);
			playerStrums.members[1].y = FlxG.random.int(250, 580);
			playerStrums.members[2].y = FlxG.random.int(250, 580);
			playerStrums.members[3].y = FlxG.random.int(250, 580);
		}
		playerStrums.members[0].x = FlxG.random.int(30, 200);
		playerStrums.members[1].x = FlxG.random.int(210, 500);
		playerStrums.members[2].x = FlxG.random.int(510, 700);
		playerStrums.members[3].x = FlxG.random.int(710, 1000);

		if (angleToo)
		{
			playerStrums.members[0].angle = FlxG.random.int(0, 359);
			playerStrums.members[1].angle = FlxG.random.int(0, 359);
			playerStrums.members[2].angle = FlxG.random.int(0, 359);
			playerStrums.members[3].angle = FlxG.random.int(0, 359);
		}
	}

	var curLight:Int = 0;
	var curLightEvent:Int = 0;
}
