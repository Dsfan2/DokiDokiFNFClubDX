package states;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import lime.utils.Assets;
import flixel.effects.FlxFlicker;
import flixel.graphics.FlxGraphic;
import flixel.tweens.FlxEase;
import openfl.utils.Assets as OpenFlAssets;

class BonusFreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadatathree> = [];

	var selector:FlxText;
	private static var curSelected:Int = 0;
	var curDifficulty:Int = -1;
	private static var lastDifficultyName:String = '';

	var scoreBG:FlxSprite;
	var composerText:FlxText;
	var scoreText:FlxText;
	var rankLetter:FlxSprite;
	var diffRatings:FlxSprite;
	var accuracyText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var lerpRating:Float = 0;
	var lerpRank:String = "";
	var intendedScore:Int = 0;
	var intendedRating:Float = 0;
	var intendedRank:String = "";

	private var diffTextPos:Array<Float> = [0.0, 0.0, 0.0];

	private var grpSongs:FlxSpriteGroup;
	private var curPlaying:Bool = false;
	private var grpTexts:FlxTypedGroup<FlxText>;

	var bg:FlxSprite;
	var ddtoClub:FlxSprite;
	var staticLock:FlxSprite;
	var glitchBorder:FlxSprite;

	var shells:FlxSprite;
	var flower:FlxSprite;
	var hive:FlxSprite;
	var grave:FlxSprite;
	var spider:FlxSprite;
	var superLeaf:FlxSprite;
	var ninjaStar:FlxSprite;
	var boxingGloves:FlxSprite;
	var monikaDDTO:FlxSprite;
	var monikaX:FlxSprite;

	var textMI:FlxText;
	var textPP:FlxText;
	var textHC:FlxText;
	var textSN:FlxText;
	var textSOM:FlxText;
	var textYIAR:FlxText;
	var textALN:FlxText;
	var textRON:FlxText;
	var textCC:FlxText;
	var textFDX:FlxText;

	var isDebug:Bool = false;

	var unlockHC:Bool = false;
	var unlockSN:Bool = false;
	var unlockSOM:Bool = false;
	var unlockYIAR:Bool = false;
	var unlockALN:Bool = false;
	var unlockRON:Bool = false;
	var unlockRONDD:Bool = false;
	var unlockCC:Bool = false;
	var unlockFDX:Bool = false;
	var unlockFF:Bool = false;

	var difficultyTitle:String = '';

	override function create()
	{	
		persistentUpdate = true;
		PlayState.isStoryMode = false;
		FlxG.mouse.visible = true;
		MusicBeatState.reloadCursor();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		#if debug
		isDebug = true;
		#end

		if (SaveData.regularCleared.contains('mon-ika') && SaveData.regularCleared.contains('flower power'))
		{
			unlockHC = true;
			unlockSN = true;
		}
		if (SaveData.regularCleared.contains('honeycomb') && SaveData.regularCleared.contains('supernatural'))
		{
			unlockSOM = true;
			unlockYIAR = true;
		}
		if (SaveData.regularCleared.contains('spiders of markov') && SaveData.regularCleared.contains('yuri is a raccoon'))
		{
			unlockALN = true;
			unlockRON = true;
		}
		if (SaveData.regularCleared.contains('amy likes ninjas') && SaveData.regularCleared.contains('roar of natsuki'))
		{
			unlockCC = true;
		}
		if (SaveData.regularCleared.contains('crossover clash'))
		{
			unlockFDX = true;
		}

		if (isDebug)
		{
			unlockHC = true;
			unlockSN = true;
			unlockSOM = true;
			unlockYIAR = true;
			unlockALN = true;
			unlockRONDD = true;
			unlockCC = true;
			unlockFF = true;
		}

		addSong('Mon-Ika', 				'Monika', 	'Normal,Doki Doki', ['4', '8']);
		addSong('Flower Power', 		'Monika', 	'Normal,Doki Doki', ['5', '9']);
		addSong('Honeycomb', 			'Sayori', 	'Normal,Doki Doki', ['6', '7']);
		addSong('Supernatural', 		'Sayori', 	'Normal,Doki Doki', ['7', '10']);
		addSong('Spiders Of Markov', 	'Yuri', 	'Normal,Doki Doki', ['8', '15']);
		addSong('Yuri Is A Raccoon', 	'Yuri', 	'Normal,Doki Doki', ['9', '11']);
		addSong('Amy Likes Ninjas', 	'Natsuki', 	'Normal,Doki Doki', ['8', '12']);
		addSong('Roar Of Natsuki', 		'Natsuki', 	'Normal,Doki Doki', ['12', '18']);
		addSong('Crossover Clash', 		'All', 		'Normal,Doki Doki', ['7', '16']);
		addSong('Festival Deluxe', 		'All', 		'Normal,Doki Doki', ['15', '20']);

		bg = new FlxSprite().loadGraphic(Paths.image('freeplay/Bonus/BonusFreeplayBG'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);
		bg.screenCenter();

		ddtoClub = new FlxSprite(667, 0).loadGraphic(Paths.image('freeplay/Bonus/DokiDokiTakeover'));
		ddtoClub.antialiasing = ClientPrefs.globalAntialiasing;
		add(ddtoClub);
		if (!unlockCC)
			ddtoClub.alpha = 0;

		staticLock = new FlxSprite(667, 0);
		staticLock.frames = Paths.getSparrowAtlas('freeplay/Bonus/LockedStatic');
		staticLock.animation.addByPrefix('static', 'no epilepsy thank you', 24, true);
		staticLock.animation.play('static');
		staticLock.antialiasing = ClientPrefs.globalAntialiasing;
		add(staticLock);
		if (unlockCC)
			staticLock.alpha = 0;

		grpSongs = new FlxSpriteGroup();
		add(grpSongs);

		glitchBorder = new FlxSprite(588, 0).loadGraphic(Paths.image('freeplay/Bonus/GlitchBorder'));
		glitchBorder.antialiasing = ClientPrefs.globalAntialiasing;
		add(glitchBorder);

		grpTexts = new FlxTypedGroup<FlxText>();
		add(grpTexts);

		//grpHearts = new FlxSpriteGroup();
		//add(grpHearts);

		shells = new FlxSprite(257, 603);
		shells.frames = Paths.getSparrowAtlas('freeplay/Bonus/Mon-Ika');
		shells.animation.addByPrefix('locked', 'Locked', 24, true);
		shells.animation.addByPrefix('idle', 'Idle', 24, true);
		shells.animation.addByPrefix('select', 'Selected', 24, true);
		shells.animation.play('idle');
		shells.antialiasing = ClientPrefs.globalAntialiasing;
		grpSongs.insert(1, shells);

		flower = new FlxSprite(11, 469);
		flower.frames = Paths.getSparrowAtlas('freeplay/Bonus/Flower Power');
		flower.animation.addByPrefix('locked', 'Locked', 24, true);
		flower.animation.addByPrefix('idle', 'Idle', 24, true);
		flower.animation.addByPrefix('select', 'Selected', 24, true);
		flower.animation.play('idle');
		flower.antialiasing = ClientPrefs.globalAntialiasing;
		grpSongs.insert(2, flower);

		hive = new FlxSprite(170, 143);
		hive.frames = Paths.getSparrowAtlas('freeplay/Bonus/Honeycomb');
		hive.animation.addByPrefix('locked', 'Locked', 24, true);
		hive.animation.addByPrefix('idle', 'Idle', 24, true);
		hive.animation.addByPrefix('select', 'Selected', 24, true);
		if (unlockHC)
			hive.animation.play('idle');
		else
			hive.animation.play('locked');
		hive.antialiasing = ClientPrefs.globalAntialiasing;
		grpSongs.insert(2, hive);

		grave = new FlxSprite(332, 417);
		grave.frames = Paths.getSparrowAtlas('freeplay/Bonus/Supernatural');
		grave.animation.addByPrefix('locked', 'Locked', 24, true);
		grave.animation.addByPrefix('idle', 'Idle', 24, true);
		grave.animation.addByPrefix('select', 'Selected', 24, true);
		if (unlockSN)
			grave.animation.play('idle');
		else
			grave.animation.play('locked');
		grave.antialiasing = ClientPrefs.globalAntialiasing;
		grpSongs.insert(2, grave);

		spider = new FlxSprite(41, -16);
		spider.frames = Paths.getSparrowAtlas('freeplay/Bonus/Spiders Of Markov');
		spider.animation.addByPrefix('locked', 'Locked', 24, true);
		spider.animation.addByPrefix('idle', 'Idle', 24, true);
		spider.animation.addByPrefix('select', 'Selected', 24, true);
		if (unlockSOM)
			spider.animation.play('idle');
		else
			spider.animation.play('locked');
		spider.antialiasing = ClientPrefs.globalAntialiasing;
		grpSongs.insert(2, spider);

		superLeaf = new FlxSprite(369, 118);
		superLeaf.frames = Paths.getSparrowAtlas('freeplay/Bonus/Yuri Is A Raccoon');
		superLeaf.animation.addByPrefix('locked', 'Locked', 24, true);
		superLeaf.animation.addByPrefix('idle', 'Idle', 24, true);
		superLeaf.animation.addByPrefix('select', 'Selected', 24, true);
		if (unlockYIAR)
			superLeaf.animation.play('idle');
		else
			superLeaf.animation.play('locked');
		superLeaf.antialiasing = ClientPrefs.globalAntialiasing;
		grpSongs.insert(2, superLeaf);

		ninjaStar = new FlxSprite(515, 543);
		ninjaStar.frames = Paths.getSparrowAtlas('freeplay/Bonus/Amy Likes Ninjas');
		ninjaStar.animation.addByPrefix('locked', 'Locked', 24, true);
		ninjaStar.animation.addByPrefix('idle', 'Idle', 24, true);
		ninjaStar.animation.addByPrefix('select', 'Selected', 24, true);
		if (unlockALN)
			ninjaStar.animation.play('idle');
		else
			ninjaStar.animation.play('locked');
		ninjaStar.antialiasing = ClientPrefs.globalAntialiasing;
		grpSongs.insert(2, ninjaStar);

		boxingGloves = new FlxSprite(16, 265);
		boxingGloves.frames = Paths.getSparrowAtlas('freeplay/Bonus/Roar Of Natsuki');
		boxingGloves.animation.addByPrefix('locked', 'Locked', 24, true);
		boxingGloves.animation.addByPrefix('idle', 'Idle', 24, true);
		boxingGloves.animation.addByPrefix('select', 'Selected', 24, true);
		if (unlockRON || unlockRONDD)
			boxingGloves.animation.play('idle');
		else
			boxingGloves.animation.play('locked');
		boxingGloves.antialiasing = ClientPrefs.globalAntialiasing;
		grpSongs.insert(2, boxingGloves);

		monikaDDTO = new FlxSprite(781, 181);
		monikaDDTO.frames = Paths.getSparrowAtlas('freeplay/Bonus/Crossover Clash');
		monikaDDTO.animation.addByPrefix('locked', 'Locked', 24, true);
		monikaDDTO.animation.addByPrefix('idle', 'Idle', 24, true);
		monikaDDTO.animation.addByPrefix('select', 'Selected', 24, true);
		if (unlockCC)
		{
			monikaDDTO.alpha = 1;
			monikaDDTO.animation.play('idle');
		}
		else
		{
			monikaDDTO.alpha = 0;
			monikaDDTO.animation.play('locked');
		}
		monikaDDTO.antialiasing = ClientPrefs.globalAntialiasing;
		grpSongs.insert(2, monikaDDTO);

		monikaX = new FlxSprite(982, 185);
		monikaX.frames = Paths.getSparrowAtlas('freeplay/Bonus/Festival Deluxe');
		monikaX.animation.addByPrefix('locked', 'Locked', 24, true);
		monikaX.animation.addByPrefix('idle', 'Idle', 24, true);
		monikaX.animation.addByPrefix('select', 'Selected', 24, true);
		if (unlockFDX || unlockFF)
			monikaX.animation.play('idle');
		else
			monikaX.animation.play('locked');
		monikaX.antialiasing = ClientPrefs.globalAntialiasing;
		grpSongs.insert(2, monikaX);
		if (!unlockCC)
			monikaX.alpha = 0;
		else
			monikaX.alpha = 1;

		textMI = new FlxText(shells.x - 64, shells.y + 3, 300, 'Mon-Ika', 32);
		textMI.setFormat(Paths.font("doki.ttf"), 28, FlxColor.WHITE, FlxTextAlign.CENTER);
		textMI.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
		grpTexts.add(textMI);

		textPP = new FlxText(flower.x - 10, flower.y + 20, 300, 'Flower Power', 32);
		textPP.setFormat(Paths.font("doki.ttf"), 28, FlxColor.WHITE, FlxTextAlign.CENTER);
		textPP.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
		grpTexts.add(textPP);

		textHC = new FlxText(hive.x - 32, hive.y + 38, 300, '???', 32);
		textHC.setFormat(Paths.font("doki.ttf"), 28, FlxColor.WHITE, FlxTextAlign.CENTER);
		textHC.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
		if (unlockHC)
			textHC.text = "Honeycomb";
		grpTexts.add(textHC);

		textSN = new FlxText(grave.x - 30, grave.y + 30, 300, '???', 32);
		textSN.setFormat(Paths.font("doki.ttf"), 28, FlxColor.WHITE, FlxTextAlign.CENTER);
		textSN.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
		if (unlockSN)
			textSN.text = "Supernatural";
		grpTexts.add(textSN);

		textSOM = new FlxText(spider.x - 40, spider.y + 75, 300, '???', 32);
		textSOM.setFormat(Paths.font("doki.ttf"), 28, FlxColor.WHITE, FlxTextAlign.CENTER);
		textSOM.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
		if (unlockSOM)
			textSOM.text = "Spiders Of Markov";
		grpTexts.add(textSOM);

		textYIAR = new FlxText(superLeaf.x - 12, superLeaf.y + 135, 300, '???', 32);
		textYIAR.setFormat(Paths.font("doki.ttf"), 28, FlxColor.WHITE, FlxTextAlign.CENTER);
		textYIAR.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
		if (unlockYIAR)
			textYIAR.text = "Yuri Is A Raccoon";
		grpTexts.add(textYIAR);

		textALN = new FlxText(ninjaStar.x - 20, ninjaStar.y + 20, 300, '???', 32);
		textALN.setFormat(Paths.font("doki.ttf"), 28, FlxColor.WHITE, FlxTextAlign.CENTER);
		textALN.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
		if (unlockALN)
			textALN.text = "Amy Likes Ninjas";
		grpTexts.add(textALN);

		textRON = new FlxText(boxingGloves.x - 12, boxingGloves.y + 49, 300, '???', 32);
		textRON.setFormat(Paths.font("doki.ttf"), 28, FlxColor.WHITE, FlxTextAlign.CENTER);
		textRON.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
		if (unlockRON || unlockRONDD)
			textRON.text = "Roar Of Natsuki";
		grpTexts.add(textRON);

		textCC = new FlxText(monikaDDTO.x + 40, monikaDDTO.y + 170, 300, 'Crossover Clash', 32);
		textCC.setFormat(Paths.font("doki.ttf"), 28, FlxColor.WHITE, FlxTextAlign.CENTER);
		textCC.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
		if (!unlockCC)
			textCC.alpha = 0;
		grpTexts.add(textCC);

		textFDX = new FlxText(monikaX.x + 39, monikaX.y + 205, 300, '???', 32);
		textFDX.setFormat(Paths.font("doki.ttf"), 28, FlxColor.WHITE, FlxTextAlign.CENTER);
		textFDX.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
		if (unlockFDX || unlockFF)
			textFDX.text = "Festival Deluxe";
		if (!unlockCC)
			textFDX.alpha = 0;
		grpTexts.add(textFDX);

		diffText = new FlxText(diffTextPos[0], diffTextPos[1], diffTextPos[2], "", 24);
		diffText.setFormat(Paths.font("doki.ttf"), 24, FlxColor.WHITE, CENTER);
		diffText.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.4);
		add(diffText);

		var scoreBG:FlxSprite = new FlxSprite(963, 0).loadGraphic(Paths.image('freeplay/Bonus/scoreInfo-Bonus'));
		add(scoreBG);

		composerText = new FlxText(1068, 22, 0, "", 19);
		composerText.setFormat(Paths.font("led.ttf"), 19, FlxColor.WHITE, LEFT);
		add(composerText);

		scoreText = new FlxText(1068, 52, 0, "", 21);
		scoreText.setFormat(Paths.font("led.ttf"), 21, FlxColor.WHITE, LEFT);
		add(scoreText);

		accuracyText = new FlxText(1068, 79, 0, "", 21);
		accuracyText.setFormat(Paths.font("led.ttf"), 21, FlxColor.WHITE, LEFT);
		add(accuracyText);

		rankLetter = new FlxSprite(1066, 107);
		rankLetter.frames = Paths.getSparrowAtlas('freeplay/Bonus/ranks');
		rankLetter.animation.addByPrefix('P', 'PERFECT rank', 24, true);
		rankLetter.animation.addByPrefix('S+', 'SPECTACULAR rank', 24, true);
		rankLetter.animation.addByPrefix('S', 'SUPER rank', 24, true);
		rankLetter.animation.addByPrefix('A', 'AWESOME rank', 24, true);
		rankLetter.animation.addByPrefix('B', 'BEAUTIFUL rank', 24, true);
		rankLetter.animation.addByPrefix('C', 'COOL rank', 24, true);
		rankLetter.animation.addByPrefix('D', 'DUMB rank', 24, true);
		rankLetter.animation.addByPrefix('E', 'EMBARRASSING rank', 24, true);
		rankLetter.animation.addByPrefix('F', 'FAILURE rank', 24, true);
		rankLetter.animation.addByPrefix('G', 'GARBAGE rank', 24, true);
		rankLetter.animation.addByPrefix('H', 'HORRIBLE rank', 24, true);
		rankLetter.animation.addByPrefix('L', 'LOSER rank', 24, true);
		rankLetter.visible = false;
		add(rankLetter);

		diffRatings = new FlxSprite(1174, 99);
		diffRatings.frames = Paths.getSparrowAtlas('freeplay/Bonus/difficultyLevels');
		diffRatings.animation.addByPrefix('1', 'Diff 01', 24, true);
		diffRatings.animation.addByPrefix('2', 'Diff 02', 24, true);
		diffRatings.animation.addByPrefix('3', 'Diff 03', 24, true);
		diffRatings.animation.addByPrefix('4', 'Diff 04', 24, true);
		diffRatings.animation.addByPrefix('5', 'Diff 05', 24, true);
		diffRatings.animation.addByPrefix('6', 'Diff 06', 24, true);
		diffRatings.animation.addByPrefix('7', 'Diff 07', 24, true);
		diffRatings.animation.addByPrefix('8', 'Diff 08', 24, true);
		diffRatings.animation.addByPrefix('9', 'Diff 09', 24, true);
		diffRatings.animation.addByPrefix('10', 'Diff 10', 24, true);
		diffRatings.animation.addByPrefix('11', 'Diff 11', 24, true);
		diffRatings.animation.addByPrefix('12', 'Diff 12', 24, true);
		diffRatings.animation.addByPrefix('13', 'Diff 13', 24, true);
		diffRatings.animation.addByPrefix('14', 'Diff 14', 24, true);
		diffRatings.animation.addByPrefix('15', 'Diff 15', 24, true);
		diffRatings.animation.addByPrefix('16', 'Diff 16', 24, true);
		diffRatings.animation.addByPrefix('17', 'Diff 17', 24, true);
		diffRatings.animation.addByPrefix('18', 'Diff 18', 24, true);
		diffRatings.animation.addByPrefix('19', 'Diff 19', 24, true);
		diffRatings.animation.addByPrefix('20', 'Diff 20', 24, true);
		add(diffRatings);


		if(curSelected >= songs.length) curSelected = 0;

		if(lastDifficultyName == '')
		{
			lastDifficultyName = CoolUtil.defaultDifficulty;
		}
		curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(lastDifficultyName)));
		
		changeSelection(false);

		var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
		textBG.alpha = 0.6;
		add(textBG);

		var leText:String = "Press CTRL to open the Gameplay Changers Menu";
		var size:Int = 18;
		var text:FlxText = new FlxText(textBG.x, textBG.y + 2, FlxG.width, leText, size);
		text.setFormat(Paths.font("doki.ttf"), size, FlxColor.WHITE, CENTER);
		text.scrollFactor.set();
		add(text);

		super.create();
	}

	override function closeSubState() {
		changeSelection(false);
		persistentUpdate = true;
		super.closeSubState();
	}

	public function addSong(songName:String, owner:String, songDifficulties:String, ratings:Array<String>)
	{
		songs.push(new SongMetadatathree(songName, owner, songDifficulties, ratings));
	}

	var selectedSomethin:Bool = false;
	var instPlaying:Int = -1;
	var holdTime:Float = 0;
	//var diffselect:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, CoolUtil.boundTo(elapsed * 24, 0, 1)));
		lerpRating = FlxMath.lerp(lerpRating, intendedRating, CoolUtil.boundTo(elapsed * 12, 0, 1));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;
		if (Math.abs(lerpRating - intendedRating) <= 0.01)
			lerpRating = intendedRating;

		var ratingSplit:Array<String> = Std.string(Highscore.floorDecimal(lerpRating * 100, 2)).split('.');
		if(ratingSplit.length < 2) { //No decimals, add an empty space
			ratingSplit.push('');
		}
		
		while(ratingSplit[1].length < 2) { //Less than 2 decimals in it, add decimals then
			ratingSplit[1] += '0';
		}

		scoreText.text = Std.string(lerpScore);
		accuracyText.text = Std.string(Highscore.floorDecimal(lerpRating * 100, 0)) + "%";
		composerText.text = CoolSongBlurb.getMainComposer(songs[curSelected].songName);

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var leftP = controls.UI_LEFT_P;
		var rightP = controls.UI_RIGHT_P;
		var accepted = controls.ACCEPT;
		var space = FlxG.keys.justPressed.SPACE;
		var ctrl = FlxG.keys.justPressed.CONTROL;

		if (!selectedSomethin){
			if (FlxG.mouse.overlaps(shells)){
				if (curSelected != 0){
					curSelected = 0;
					changeSelection();
				}
				if (FlxG.mouse.justPressed)
					selectSong();
			}
			else if (FlxG.mouse.overlaps(flower)){
				if (curSelected != 1){
					curSelected = 1;
					changeSelection();
				}
				if (FlxG.mouse.justPressed)
					selectSong();
			}
			else if (FlxG.mouse.overlaps(hive)){
				if (curSelected != 2){
					curSelected = 2;
					changeSelection();
				}
				if (FlxG.mouse.justPressed)
					selectSong();
			}
			else if (FlxG.mouse.overlaps(grave)){
				if (curSelected != 3){
					curSelected = 3;
					changeSelection();
				}
				if (FlxG.mouse.justPressed)
					selectSong();
			}
			else if (FlxG.mouse.overlaps(spider)){
				if (curSelected != 4){
					curSelected = 4;
					changeSelection();
				}
				if (FlxG.mouse.justPressed)
					selectSong();
			}
			else if (FlxG.mouse.overlaps(superLeaf)){
				if (curSelected != 5){
					curSelected = 5;
					changeSelection();
				}
				if (FlxG.mouse.justPressed)
					selectSong();
			}
			else if (FlxG.mouse.overlaps(ninjaStar)){
				if (curSelected != 6){
					curSelected = 6;
					changeSelection();
				}
				if (FlxG.mouse.justPressed)
					selectSong();
			}
			else if (FlxG.mouse.overlaps(boxingGloves)){
				if (curSelected != 7){
					curSelected = 7;
					changeSelection();
				}
				if (FlxG.mouse.justPressed)
					selectSong();
			}
			else if (FlxG.mouse.overlaps(monikaDDTO) && unlockCC){
				if (curSelected != 8){
					curSelected = 8;
					changeSelection();
				}
				if (FlxG.mouse.justPressed)
					selectSong();
			}
			else if (FlxG.mouse.overlaps(monikaX) && unlockCC){
				if (curSelected != 9){
					curSelected = 9;
					changeSelection();
				}
				if (FlxG.mouse.justPressed)
					selectSong();
			}
		}

		if(ctrl)
		{
			persistentUpdate = false;
			openSubState(new GameplayChangersSubstate());
		}
		else if(space)
		{
			if(instPlaying != curSelected)
			{
				#if PRELOAD_ALL
				FlxG.sound.music.volume = 0;
				var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
				PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
		
				FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0.7);
				instPlaying = curSelected;
				#end
			}
		}
		else if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			persistentUpdate = false;
			CoolUtil.playMusic(CoolUtil.getTitleTheme(), 0);
			openSubState(new CustomFadeTransition(0.6, false, new ExtraStuffState()));
		}
		else if (accepted)
		{
			selectSong();
		}
		super.update(elapsed);
	}

	function selectSong()
	{
		selectedSomethin = true;
		FlxG.sound.play(Paths.sound('confirmMenu'));
		persistentUpdate = false;
		var songLowercase:String = Paths.formatToSongPath(songs[curSelected].songName);
		var poop:String = Highscore.formatSong(songLowercase, curDifficulty);

		PlayState.SONG = Song.loadFromJson(poop, songLowercase);
		PlayState.isStoryMode = false;
		PlayState.storyDifficulty = curDifficulty;

		CustomFadeTransition.isHeartTran = true;

		openSubState(new CustomFadeTransition(0.4, false, new LoadingState(new PlayState(), true, false)));
		FlxG.sound.music.stop();
		FlxG.sound.music.volume = 0;
	}

	var tweenDifficulty:FlxTween;
	function changeDiff(change:Int = 0, changeMusic:Bool = true)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = CoolUtil.difficulties.length-1;
		if (curDifficulty >= CoolUtil.difficulties.length)
			curDifficulty = 0;

		lastDifficultyName = CoolUtil.difficulties[curDifficulty];

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		switch (Std.int(Highscore.floorDecimal(intendedRating * 100, 0)))
		{
			case 100:
				intendedRank = "P";
			case 99 | 98:
				intendedRank = "S+";
			case 97 | 96| 95:
				intendedRank = "S";
			case 94 | 93 | 92 | 91 | 90:
				intendedRank = "A";
			case 89 | 88 | 87:
				intendedRank = "B";
			case 86 | 85 | 84:
				intendedRank = "C";
			case 83 | 82 | 81 | 80:
				intendedRank = "D";
			case 79 | 78 | 77 | 76 | 75:
				intendedRank = "E";
			case 74 | 73 | 72 | 71 | 70:
				intendedRank = "F";
			case 69 | 68 | 67 | 66 | 65:
				intendedRank = "G";
			case 64 | 63 | 62 | 61 | 60:
				intendedRank = "H";
			default:
				intendedRank = "L";
		}
		if (intendedRating <= 0) rankLetter.visible = false;
		else rankLetter.visible = true;
		rankLetter.animation.play(intendedRank, true);
		#end

		PlayState.storyDifficulty = curDifficulty;
		switch (CoolUtil.difficultyString())
		{
			case 'DOKI DOKI':
				difficultyTitle = 'DOKI DOKI REMIX';
			default:
				difficultyTitle = 'REGULAR';
		}
		diffText.text = '< ' + difficultyTitle + ' >';
		diffRatings.animation.play(songs[curSelected].ratings[curDifficulty]);
		
		if (changeMusic) playDaMusic(CoolUtil.difficultyString() == 'DOKI DOKI');
	}

	function changeSelection(playSound:Bool = true)
	{
		if(playSound) FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		shells.animation.play('idle');
		flower.animation.play('idle');
		if (unlockHC)
			hive.animation.play('idle');
		if (unlockSN)
			grave.animation.play('idle');
		if (unlockSOM)
			spider.animation.play('idle');
		if (unlockYIAR)
			superLeaf.animation.play('idle');
		if (unlockALN)
			ninjaStar.animation.play('idle');
		if (unlockRON || unlockRONDD)
			boxingGloves.animation.play('idle');
		if (unlockCC)
			monikaDDTO.animation.play('idle');
		if (unlockFDX || unlockFF)
			monikaX.animation.play('idle');

		textMI.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
		textPP.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
		textHC.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
		textSN.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
		textSOM.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
		textYIAR.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
		textALN.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
		textRON.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
		textCC.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
		textFDX.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);

		switch (curSelected)
		{
			case 0:
				textMI.setBorderStyle(OUTLINE, 0xFF400080, 1.5);
				shells.animation.play('select');
				diffTextPos = [textMI.x, textMI.y + 32, textMI.fieldWidth];
			case 1:
				textPP.setBorderStyle(OUTLINE, 0xFF400080, 1.5);
				flower.animation.play('select');
				diffTextPos = [textPP.x, textPP.y + 32, textPP.fieldWidth];
			case 2:
				textHC.setBorderStyle(OUTLINE, 0xFF400080, 1.5);
				if (unlockHC)
				{
					hive.animation.play('select');
					diffTextPos = [textHC.x, textHC.y + 32, textHC.fieldWidth];
					diffText.visible = true;
				}
				else
					diffText.visible = false;
			case 3:
				textSN.setBorderStyle(OUTLINE, 0xFF400080, 1.5);
				if (unlockSN)
				{
					grave.animation.play('select');
					diffTextPos = [textSN.x, textSN.y + 32, textSN.fieldWidth];
					diffText.visible = true;
				}
				else
					diffText.visible = false;
			case 4:
				textSOM.setBorderStyle(OUTLINE, 0xFF400080, 1.5);
				if (unlockSOM)
				{
					spider.animation.play('select');
					diffTextPos = [textSOM.x, textSOM.y + 32, textSOM.fieldWidth];
					diffText.visible = true;
				}
				else
					diffText.visible = false;
			case 5:
				textYIAR.setBorderStyle(OUTLINE, 0xFF400080, 1.5);
				if (unlockYIAR)
				{
					superLeaf.animation.play('select');
					diffTextPos = [textYIAR.x, textYIAR.y + 32, textYIAR.fieldWidth];
					diffText.visible = true;
				}
				else
					diffText.visible = false;
			case 6:
				textALN.setBorderStyle(OUTLINE, 0xFF400080, 1.5);
				if (unlockALN)
				{
					ninjaStar.animation.play('select');
					diffTextPos = [textALN.x, textALN.y + 32, textALN.fieldWidth];
					diffText.visible = true;
				}
				else
					diffText.visible = false;
			case 7:
				textRON.setBorderStyle(OUTLINE, 0xFF400080, 1.5);
				if (unlockRON || unlockRONDD)
				{
					boxingGloves.animation.play('select');
					if (unlockRONDD)
					{
						diffTextPos = [textRON.x, textRON.y + 32, textRON.fieldWidth];
						diffText.visible = true;
					}
					else
						diffText.visible = false;
				}
				else
					diffText.visible = false;
			case 8:
				textCC.setBorderStyle(OUTLINE, 0xFF400080, 1.5);
				if (unlockCC)
				{
					monikaDDTO.animation.play('select');
					diffTextPos = [textCC.x, textCC.y + 32, textCC.fieldWidth];
					diffText.visible = true;
				}
				else
					diffText.visible = false;
			case 9:
				textFDX.setBorderStyle(OUTLINE, 0xFF400080, 1.5);
				if (unlockFDX || unlockFF)
				{
					monikaX.animation.play('select');
					if (unlockFF)
					{
						diffTextPos = [textFDX.x, textFDX.y + 32, textFDX.fieldWidth];
						diffText.visible = true;
					}
					else
						diffText.visible = false;
				}
				else
					diffText.visible = false;
		}

		diffText.fieldWidth = diffTextPos[2];
		diffText.x = diffTextPos[0];
		diffText.y = diffTextPos[1];
		
		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		var diffStr:String = songs[curSelected].songDifficulties;
		if(diffStr != null) diffStr = diffStr.trim();

		if(diffStr != null && diffStr.length > 0)
		{
			var diffs:Array<String> = diffStr.split(',');
			var i:Int = diffs.length - 1;
			while (i > 0)
			{
				if(diffs[i] != null)
				{
					diffs[i] = diffs[i].trim();
					if(diffs[i].length < 1) diffs.remove(diffs[i]);
				}
				--i;
			}

			if(diffs.length > 0 && diffs[0].length > 0)
			{
				CoolUtil.difficulties = diffs;
			}
		}
		
		if(CoolUtil.difficulties.contains(CoolUtil.defaultDifficulty))
		{
			curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(CoolUtil.defaultDifficulty)));
		}
		else
		{
			curDifficulty = 0;
		}

		var newPos:Int = CoolUtil.difficulties.indexOf(lastDifficultyName);
		if(newPos > -1)
		{
			curDifficulty = newPos;
		}
		#if PRELOAD_ALL
		playDaMusic(CoolUtil.difficultyString() == 'DOKI DOKI');
		#end

		changeDiff();
	}

	function playDaMusic(?doki:Bool = false)
	{
		if (doki) FlxG.sound.playMusic(Paths.music('previews/doki-doki/' + Paths.formatToSongPath(songs[curSelected].songName)), 0);
		else FlxG.sound.playMusic(Paths.music('previews/default/' + Paths.formatToSongPath(songs[curSelected].songName)), 0);
	}
}

class SongMetadatathree
{
	public var songName:String = "";
	public var owner:String = "";
	public var songDifficulties:String = '';
	public var ratings:Array<String> = [];

	public function new(song:String, owner:String, songDifficulties:String, ratings:Array<String>)
	{
		this.songName = song;
		this.owner = owner;
		this.songDifficulties = songDifficulties;
		this.ratings = ratings;
	}
}