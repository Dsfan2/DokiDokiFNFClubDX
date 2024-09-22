package substates;

import flixel.addons.display.FlxBackdrop;
import openfl.geom.Matrix;
import openfl.display.BitmapData;
import flixel.util.FlxAxes;
import flixel.FlxSubState;
import flixel.input.FlxInput;
import flixel.input.keyboard.FlxKey;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.text.FlxTypeText;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import lime.utils.Assets;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.input.FlxKeyManager;
import flixel.util.FlxTimer;

class ResultsScreen extends MusicBeatSubstate
{
    var poemPaper:FlxSprite;
    public static var newHighscore:Bool = false;
    var clearPercentSmall:ClearPercentCounter;
    var storyMode:Bool = PlayState.isStoryMode;

    var songName:String = "";
    var songDifficulty:String = "";
    var songRanking:String = "";
    var songAccuracy:Int = 0;
    var songScore:Int = 0;
    var songMisses:Int = 0;
    var highestCombo:Int = 0;
    var notesHit:Int = 0;
    var sicks:Int = 0;
    var goods:Int = 0;
    var bads:Int = 0;
    var trashes:Int = 0;
    var accNum:Float = 0.00;

    var rankName:String = '';

    var songNameText:FlxTypeText;
    var composerName:FlxTypeText;
    var difficulty:FlxSprite;

    var playerSound:String = "";

    var canExit:Bool = false;
    var resultsStarted:Bool = false;

    var musicFile:String = '';

    public var charSprite:FlxSprite;
    var type:String = "";

    var ratingsPopin:FlxSprite;
    var resultsAnim:FlxSprite;
    var scorePopin:FlxSprite;
    var highscoreNew:FlxSprite;
    var score:ResultScore;

    var monikaTip:FlxSprite;
    var tipTextThing:FlxTypeText;

    var tipFull:String = '';

    var flashShader:PureColor;

    public var drumroll:FlxSound;

    public static var customSprString:String = "player";

    public static var instance:ResultsScreen;

	override function create()
	{
        flashShader = new PureColor(FlxColor.WHITE);
        flashShader.colorSet = false;

        if (storyMode)
        {
            songName = WeekData.weekID;
            songAccuracy = Std.int(PlayState.campaignAccuracy);
            songRanking = CoolUtil.getRankLetter(songAccuracy);
            notesHit = PlayState.totalNotesHit;
            songScore = PlayState.campaignScore;
            songMisses = PlayState.campaignMisses;
            highestCombo = PlayState.highestCombo;
            sicks = PlayState.campaignSicks;
            goods = PlayState.campaignGoods;
            bads = PlayState.campaignBads;
            trashes = PlayState.campaignTrashes;
        }
        else
        {
            songName = PlayState.SONG.song;
            songAccuracy = PlayState.songAccuracy;
            songRanking = PlayState.instance.ratingName;
            notesHit = PlayState.instance.notesPressed;
            songScore = PlayState.instance.songScore;
            songMisses = PlayState.instance.songMisses;
            highestCombo = PlayState.highestCombo;
            sicks = PlayState.sicks;
            goods = PlayState.goods;
            bads = PlayState.bads;
            trashes = PlayState.trashs;
        }

        if (CoolUtil.difficultyString() == 'DOKI DOKI')
            songDifficulty = 'DOKIDOKI';
        else
            songDifficulty = 'REGULAR';

        var name:String = songName;
        if (name.toLowerCase() == 'welcome to the club (boyfriend)' || name.toLowerCase() == 'welcome to the club (bowser jr)' || name.toLowerCase() == 'welcome to the club (monika)')
            name = 'Welcome To The Club';
        var tips:Array<String> = CoolUtil.coolTextFile(Paths.txt('meta/' + Paths.formatToSongPath(name) + '/ResultsTips'));
        
        rankName = CoolUtil.getRankName(songRanking);
        switch (songRanking)
        {
            case "P":
                type = 'Perfect';
                tipFull = tips[0];
            case "S+" | "S":
                type = 'Cool';
                tipFull = tips[1];
            case "A" | "B" | "C":
                type = 'Good';
                tipFull = tips[2];
            case "D" | "E" | "F" | "G" | "H":
                type = 'Bad';
                tipFull = tips[3];
            default:
                type = 'Awful';
                tipFull = tips[4];
        }

        poemPaper = new FlxSprite();
        switch (PlayState.SONG.song.toLowerCase())
		{
			case "un-welcome to the club" | 'depression' | 'hxppy thxughts' | 'cxnnamon bxn' | 'malnourished' | 'pale' | 'glitch' | 'yandere' | 'obsessed' | 'psychopath' | 'candy heartz' | 'play with me' | 'poem panic' | 'supernatural' | 'spiders of markov' | 'roar of natsuki':
				poemPaper.loadGraphic(Paths.image('results/PoemA2'));
			case "revelation" | 'lines of code' | 'self-aware' | 'elevated access' | 'script error' | 'system failure' | 'just monika' | 'doki forever' | 'dark star' | "you can't run" | 'ultimate glitcher' | 'the final battle' | 'festival deluxe':
				poemPaper.loadGraphic(Paths.image('results/PoemA3'));
			default:
				poemPaper.loadGraphic(Paths.image('results/PoemA1'));
		}
        poemPaper.screenCenter();
        add(poemPaper);

        difficulty = new FlxSprite(714, 42);
        difficulty.loadGraphic(Paths.image("results/diff" + songDifficulty));
        add(difficulty);

        clearPercentSmall = new ClearPercentCounter(834, 79, 100, true);
        clearPercentSmall.visible = false;
        add(clearPercentSmall);

        songNameText = new FlxTypeText(388, 113, 500, "");
		songNameText.setFormat(Paths.font("m1.ttf"), 32, FlxColor.BLACK, FlxTextAlign.RIGHT);
		add(songNameText);

        composerName = new FlxTypeText(388, 147, 500, "");
		composerName.setFormat(Paths.font("m1.ttf"), 32, FlxColor.BLACK, FlxTextAlign.RIGHT);
		add(composerName);

        resultsAnim = new FlxSprite(387, 26);
        resultsAnim.frames = Paths.getSparrowAtlas("results/results");
        resultsAnim.animation.addByPrefix("result", "results instance 1", 24, false);
        resultsAnim.animation.play("result");
        add(resultsAnim);

        ratingsPopin = new FlxSprite(406, 113);
        ratingsPopin.frames = Paths.getSparrowAtlas("results/ratingsPopin");
        ratingsPopin.animation.addByPrefix("idle", "Categories", 24, false);
        ratingsPopin.visible = false;
        add(ratingsPopin);

        scorePopin = new FlxSprite(403, 366);
        scorePopin.frames = Paths.getSparrowAtlas("results/scorePopin");
        scorePopin.animation.addByPrefix("score", "tally score", 24, false);
        scorePopin.visible = false;
        add(scorePopin);

        highscoreNew = new FlxSprite(529, 368);
        highscoreNew.frames = Paths.getSparrowAtlas("results/highscoreNew");
        highscoreNew.animation.addByPrefix("new", "highscoreAnim", 24, false);
        highscoreNew.animation.addByPrefix("loop", "highscoreLoop", 24, true);
        highscoreNew.visible = false;
        add(highscoreNew);

        var ratingGrp:FlxTypedGroup<TallyCounter> = new FlxTypedGroup<TallyCounter>();
        add(ratingGrp);

        var tallyNotes:TallyCounter = new TallyCounter(501, 118, notesHit, 0xFF000000);
        ratingGrp.add(tallyNotes);

        var maxCombo:TallyCounter = new TallyCounter(508, 152, highestCombo, 0xFF000000);
        ratingGrp.add(maxCombo);

        var extraYOffset:Float = 5;
        var tallySick:TallyCounter = new TallyCounter(449, 185, sicks, 0xFF529620);
        ratingGrp.add(tallySick);

        var tallyGood:TallyCounter = new TallyCounter(452, 222, goods, 0xFF00A187);
        ratingGrp.add(tallyGood);

        var tallyBad:TallyCounter = new TallyCounter(447, 256, bads, 0xFF8800A9);
        ratingGrp.add(tallyBad);

        var tallyTrash:TallyCounter = new TallyCounter(440, 291, trashes, 0xFFD5005F);
        ratingGrp.add(tallyTrash);

        var tallyMissed:TallyCounter = new TallyCounter(472, 326, songMisses, 0xFFB00000);
        ratingGrp.add(tallyMissed);

        score = new ResultScore(222, 205, 10, songScore);
        score.visible = false;
        add(score);

        charSprite = new FlxSprite(530, 489);
        charSprite.frames = Paths.getSparrowAtlas('results/Chibis/' + customSprString + '_Chib');
        charSprite.animation.addByPrefix('P', 'P Rank', 24, true);
        charSprite.animation.addByPrefix('S', 'S Rank', 24, true);
        charSprite.animation.addByPrefix('A', 'A Rank', 24, true);
        charSprite.animation.addByPrefix('D', 'D Rank', 24, true);
        charSprite.animation.addByPrefix('L', 'L Rank', 24, true);
        charSprite.setGraphicSize(Std.int(charSprite.width * 1));
        charSprite.updateHitbox();
        charSprite.visible = false;
        charSprite.shader = flashShader;
        add(charSprite);

        monikaTip = new FlxSprite(402, 472);
        monikaTip.frames = Paths.getSparrowAtlas('results/tipTextThing');
        monikaTip.animation.addByPrefix('anim', "Writing Tip Of The Day", 24, false);
        monikaTip.visible = false;

        tipTextThing = new FlxTypeText(394, 531, 497, "");
		tipTextThing.setFormat(Paths.font("m1.ttf"), 32, FlxColor.BLACK, FlxTextAlign.LEFT);

        for (ind => rating in ratingGrp.members)
        {
            rating.visible = false;
            new FlxTimer().start((0.3 * ind) + 0.55, function(tmr:FlxTimer) {
                rating.visible = true;
                FlxTween.tween(rating, {curNumber: rating.neededNumber}, 0.5, {ease: FlxEase.quartOut});
            });
        }

        drumroll = FlxG.sound.play(Paths.sound('results/Drumroll'));
        switch (type)
        {
            case "Perfect":
                musicFile = 'results/PRankResults';
                playerSound = "results/PRank";
                charSprite.animation.play('P', true);
            case "Cool":
                musicFile = 'results/SRankResults';
                playerSound = "results/SRank";
                charSprite.animation.play('S', true);
            case "Good":
                musicFile = 'results/CRankResults';
                playerSound = "results/CRank";
                charSprite.animation.play('A', true);
            case "Bad":
                musicFile = 'results/HRankResults';
                playerSound = "results/HRank";
                charSprite.animation.play('D', true);
            case "Awful":
                musicFile = 'results/LRankResults';
                playerSound = "results/LRank";
                charSprite.animation.play('L', true);
        }

        songNameText.resetText(songName);
        songNameText.start(0.04);
        new FlxTimer().start(0.5, function(tmr:FlxTimer) {
            ratingsPopin.animation.play("idle");
            ratingsPopin.visible = true;

            composerName.resetText(PlayState.instance.composerName);
            composerName.start(0.04);
      
            ratingsPopin.animation.finishCallback = function(name:String) {
                scorePopin.animation.play("score");
                scorePopin.animation.finishCallback = function(name:String) {
                    score.visible = true;
                    score.animateNumbers();
                };
                scorePopin.visible = true;
      
                if (newHighscore)
                {
                    highscoreNew.visible = true;
                    highscoreNew.animation.play("new");
                    highscoreNew.animation.finishCallback = function(name:String) {
                        highscoreNew.animation.play('loop', true);
                    };
                }
                else
                {
                    highscoreNew.visible = false;
                }
            };

            new FlxTimer().start((37 / 24), function(tmr:FlxTimer) {
                startRankTallySequence();
            });
        });

        cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

		super.create();
	}

    var rankTallyTimer:Null<FlxTimer> = null;
    var clearPercentTarget:Int = 100;
    var clearPercentLerp:Int = 0;

    function startRankTallySequence():Void
    {
        clearPercentTarget = songAccuracy;
        clearPercentLerp = Std.int(Math.max(0, clearPercentTarget - 36));


        var clearPercentCounter:ClearPercentCounter = new ClearPercentCounter(600, 150, clearPercentLerp);
        FlxTween.tween(clearPercentCounter, {curNumber: clearPercentTarget}, 58 / 24, 
        {
            ease: FlxEase.quartOut,
            onUpdate: function(twn:FlxTween) {
                // Only play the tick sound if the number increased.
                if (clearPercentLerp != clearPercentCounter.curNumber)
                {
                    clearPercentLerp = clearPercentCounter.curNumber;
                    FlxG.sound.play(Paths.sound('scrollMenu'));
                }
            },
            onComplete: function(twn:FlxTween) {
                // Play confirm sound.
                drumroll.stop();
                FlxG.sound.play(Paths.sound(playerSound));
                CoolUtil.playMusic(musicFile, 1);

                // Just to be sure that the lerp didn't mess things up.
                clearPercentCounter.curNumber = clearPercentTarget;

                clearPercentCounter.flash(true);
                new FlxTimer().start(0.4, function(tmr:FlxTimer) {
                    tipTextThing.resetText(tipFull);
                    tipTextThing.start(0.02);
                    clearPercentCounter.flash(false);
                });
                displayRankText();
                afterRankTallySequence();

                monikaTip.animation.play('anim', true);
                monikaTip.visible = true;

                // previously 2.0 seconds
                new FlxTimer().start(0.25, function(tmr:FlxTimer) {
                    FlxTween.tween(clearPercentCounter, {alpha: 0}, 0.5,
                    {
                        startDelay: 0.5,
                        ease: FlxEase.quartOut,
                        onComplete: function(twn:FlxTween) {
                            remove(clearPercentCounter);
                        }
                    });
                });
                canExit = true;
            }
        });
        add(clearPercentCounter);
    }

    function displayRankText():Void
    {
        var rankText:FlxSprite = new FlxSprite(668, 207).loadGraphic(Paths.image('results/rankText/rankText' + rankName));
        add(rankText);
    }

    function afterRankTallySequence():Void
    {
        showSmallClearPercent();
        charSprite.visible = true;    
    }

    function showSmallClearPercent():Void
    {
        if (clearPercentSmall != null)
        {
            clearPercentSmall.visible = true;
            charFlash(true);
            new FlxTimer().start(0.4, function(tmr:FlxTimer) {
                charFlash(false);
            });
      
            clearPercentSmall.curNumber = clearPercentTarget;
            clearPercentSmall.visible = true;
        }
      
        new FlxTimer().start(2.5, function(tmr:FlxTimer) {
            // none
        });
    }

    public function charFlash(enabled:Bool):Void
    {
        flashShader.colorSet = enabled;
    }

    var frames = 0;

	override function update(elapsed:Float)
	{
        if (FlxG.keys.justPressed.ENTER && canExit)
        {
            canExit = false;
            newHighscore = false;
            PlayState.deathCounter = 0;
            FlxG.sound.music.stop();

            FlxG.sound.music.volume = 0;
            if (storyMode) 
            {
                openSubState(new CustomFadeTransition(0.4, false, new StoryContinueState()));
                CoolUtil.playMusic(CoolUtil.getTitleTheme());
                FlxG.sound.music.volume = 1;
            }
            else
            {
                switch (PlayState.songType)
	    		{
		    		case 'Normal': openSubState(new CustomFadeTransition(0.4, false, new FreeplayState()));
			    	case 'Classic': openSubState(new CustomFadeTransition(0.4, false, new ClassicFreeplayState()));
		    		case 'Bonus': openSubState(new CustomFadeTransition(0.4, false, new BonusFreeplayState()));
    		    }
            }
        }
		super.update(elapsed);
	}

    override function destroy()
	{
		instance = null;
		super.destroy();
	}
}
