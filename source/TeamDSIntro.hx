package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class TeamDSIntro extends MusicBeatState
{
	public static var leftState:Bool = false;

	var teamDSVideo:VideoSprite;

	override function create()
	{
		super.create();
		PlayerSettings.init();
		FlxG.save.bind('ddfnfcdx', 'TeamDS/DDFNFCDX-V4');
		SaveData.loadSaveData();
		ClientPrefs.loadPrefs();
		Highscore.load();

		if ((!FlxG.save.data.warningAccept || FlxG.save.data.warningAccept == null) && !WarningState.doneWarning)
		{
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			FlxG.switchState(new WarningState());
		}
		else
		{
			new FlxTimer().start(1, function(tmr:FlxTimer) {

				teamDSVideo = new VideoSprite();
				if (SaveData.actThree) teamDSVideo.playVideo(Paths.video('team-ds-intro/glitch'), false);
				else teamDSVideo.playVideo(Paths.video('team-ds-intro/ds'), false);
				teamDSVideo.scrollFactor.set();
				teamDSVideo.updateHitbox();
				teamDSVideo.antialiasing = ClientPrefs.globalAntialiasing;
				add(teamDSVideo);
				teamDSVideo.finishCallback = function() {
					leftState = true;
					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;
					if (SaveData.actThree)
					{
						CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
						if (ClientPrefs.playerChar == 1)
						{
							PlayState.storyPlaylist = WeekData.boyfriendRouteList[9][2];
							WeekData.weekID = "Final BF";
						}
						else if (ClientPrefs.playerChar == 2)
						{
							PlayState.storyPlaylist = WeekData.bowserJrRouteList[9][2];
							WeekData.weekID = "Final JR";
						}
						else if (ClientPrefs.playerChar == 3)
						{
							PlayState.storyPlaylist = WeekData.monikaRouteList[5][2];
							WeekData.weekID = "Final MONI";
						}
						PlayState.isStoryMode = true;
						PlayState.storyFreeplay = false;
		
						var difficulty:Int = 0;
								
						if (SaveData.lockedRoute.endsWith('DOKI')) difficulty = 1;

						PlayState.storyDifficulty = difficulty;
							
						var diffic = CoolUtil.getDifficultyFilePath(difficulty);
						if(diffic == null) diffic = '';
						
						PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
						PlayState.campaignScore = 0;
						PlayState.campaignMisses = 0;
							
						PlayState.campaignScore = 0;
						FlxTransitionableState.skipNextTransIn = true;
						FlxTransitionableState.skipNextTransOut = true;
						FlxG.switchState(new LoadingState(new PlayState(), true, true));
					}
					else FlxG.switchState(new TitleState());
				}
				if (FlxG.keys.justPressed.ENTER)
				{
					remove(teamDSVideo);
					leftState = true;
					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;
					FlxG.switchState(new TitleState());

				}
			});
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
