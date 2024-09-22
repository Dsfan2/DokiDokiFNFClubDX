package substates;

import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;

class GameOverSubstate extends MusicBeatSubstate
{
	public var boyfriend:Character;
	var camFollow:FlxObject;
	var updateCamera:Bool = false;
	var playingDeathSound:Bool = false;

	var stageSuffix:String = "";

	public static var characterName:String = 'bf-dead';
	public static var deathSoundName:String = 'fnf_loss_sfx';
	public static var loopSoundName:String = 'gameOver';
	public static var endSoundName:String = 'gameOverEnd';

	public static var gotPunched:Bool = false;

	public static var instance:GameOverSubstate;

	public static function resetVariables() {
		characterName = 'bf-dead';
		deathSoundName = 'fnf_loss_sfx';
		loopSoundName = 'gameOver';
		endSoundName = 'gameOverEnd';
	}

	override function create()
	{
		instance = this;

		super.create();
	}

	public function new(x:Float, y:Float, camX:Float, camY:Float)
	{
		super();

		Conductor.songPosition = 0;

		boyfriend = new Character(x, y, characterName, true);
		boyfriend.x += boyfriend.positionArray[0];
		boyfriend.y += boyfriend.positionArray[1];
		boyfriend.screenCenter();
		add(boyfriend);

		FlxG.sound.play(Paths.sound(deathSoundName));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		boyfriend.playAnim('firstDeath');

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollow.setPosition(boyfriend.getGraphicMidpoint().x, boyfriend.getGraphicMidpoint().y);
		FlxG.camera.focusOn(new FlxPoint(boyfriend.getGraphicMidpoint().x, boyfriend.getGraphicMidpoint().y));
		add(camFollow);

		if (PlayState.SONG.song.toLowerCase() == 'spiders of markov') CoolUtil.makeSecretFile('fountain', 'The Key');
		if (PlayState.SONG.song.toLowerCase() == 'roar of natsuki' && gotPunched) CoolUtil.makeSecretFile('(2.) CAN A MATCH BOX?', 'impossible_quiz_q2');
		if (PlayState.SONG.player1 == 'bf-gone') CoolUtil.makeSecretFile('The tiny round balls that grow on trees and reflect light that\'s the same color as their name.', 'Fruity Clue');

		gotPunched = false;
	}

	public var startedDeath:Bool = false;
	var isFollowingAlready:Bool = false;
	override function update(elapsed:Float)
	{
		super.update(elapsed);


		if (controls.ACCEPT)
		{
			endBulltrash();
		}

		if (controls.BACK && !SaveData.actThree)
		{
			#if desktop DiscordClient.resetClientID(); #end
			FlxG.sound.music.stop();
			PlayState.deathCounter = 0;
			PlayState.seenCutscene = false;
			PlayState.chartingMode = false;
			CustomFadeTransition.isHeartTran = true;

			if(PlayState.isStoryMode) {
				if (PlayState.storyFreeplay) openSubState(new CustomFadeTransition(0.4, false, new StoryContinueState()));
				else openSubState(new CustomFadeTransition(0.4, false, new MainMenuState()));
				
				CoolUtil.playMusic(CoolUtil.getTitleTheme());
			} else {
				FlxG.sound.music.stop();
				switch (PlayState.songType)
				{
					case 'Normal': openSubState(new CustomFadeTransition(0.4, false, new FreeplayState()));
					case 'Classic': openSubState(new CustomFadeTransition(0.4, false, new ClassicFreeplayState()));
					case 'Bonus': openSubState(new CustomFadeTransition(0.4, false, new BonusFreeplayState()));
				}
			}
		}
		
		if (boyfriend.animation.curAnim != null)
		{
			if (boyfriend.animation.curAnim.name == 'firstDeath' && boyfriend.animation.curAnim.finished && startedDeath)
				boyfriend.playAnim('deathLoop');

			if(boyfriend.animation.curAnim.name == 'firstDeath')
			{
				if(boyfriend.animation.curAnim.curFrame >= 12 && !isFollowingAlready)
				{
					isFollowingAlready = true;
				}

				if (boyfriend.animation.curAnim.finished && !playingDeathSound)
				{
					startedDeath = true;
					if (PlayState.SONG.stage == 'tank')
					{
						playingDeathSound = true;
						coolStartDeath(0.2);
						
						var exclude:Array<Int> = [];

						FlxG.sound.play(Paths.sound('jeffGameover/jeffGameover-' + FlxG.random.int(1, 25, exclude)), 1, false, null, true, function() {
							if(!isEnding)
							{
								FlxG.sound.music.fadeIn(0.2, 1, 4);
							}
						});
					}
					else coolStartDeath();
				}
			}
		}

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
	}

	var isEnding:Bool = false;

	function coolStartDeath(?volume:Float = 1):Void
	{
		CoolUtil.playMusic(loopSoundName, volume);
	}

	function endBulltrash():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			boyfriend.playAnim('deathConfirm', true);
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music(endSoundName));
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					FlxG.resetState();
				});
			});
		}
	}

	override function destroy()
	{
		instance = null;
		super.destroy();
	}
}