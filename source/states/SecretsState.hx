package states;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.tweens.FlxEase;
import flixel.FlxSubState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class SecretsState extends MusicBeatState
{
	public static var code:String = '';
	var specialPoem:Bool = false;

	var canExit:Bool = false;
	
	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Secret", null);
		#end

		//transIn = FlxTransitionableState.defaultTransIn;
		//transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		switch (code)
		{
			case 'Amanda':
				var spr:FlxSprite = new FlxSprite().loadGraphic('assets/secrets/images/Amanda.png');
				add(spr);
				FlxG.sound.playMusic('assets/secrets/music/birfday.ogg');
			case 'Kinito':
				var spr:FlxSprite = new FlxSprite().loadGraphic('assets/secrets/images/Kinito.png');
				add(spr);
				FlxG.sound.playMusic('assets/secrets/music/hill.ogg');
			case 'Spam':
				var spr:FlxSprite = new FlxSprite().loadGraphic('assets/secrets/images/Spam.png');
				add(spr);
				FlxG.sound.playMusic('assets/secrets/music/Spam.ogg');
			case 'Pomni':
				var spr:FlxSprite = new FlxSprite().loadGraphic('assets/secrets/images/pomni.png');
				add(spr);
				FlxG.sound.playMusic('assets/secrets/music/pomni.ogg');
			case 'Cyn':
				var spr:FlxSprite = new FlxSprite().loadGraphic('assets/secrets/images/cyn.png');
				add(spr);
				FlxG.sound.playMusic('assets/secrets/music/cyn.ogg');
			case 'Funkin':
				var spr:FlxSprite = new FlxSprite().loadGraphic('assets/secrets/images/funkin.png');
				add(spr);
			case 'Hallyboo':
				var spr:FlxSprite = new FlxSprite().loadGraphic('assets/secrets/images/hallyboo.png');
				add(spr);
				FlxG.sound.playMusic('assets/secrets/music/piracy.ogg');
			case 'Sunshine':
				var white:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFFFFFFFF);
				add(white);
				var spr:FlxSprite = new FlxSprite();
				spr.frames = FlxAtlasFrames.fromSparrow('assets/secrets/images/Monker.png', 'assets/secrets/images/Monker.xml');
				spr.animation.addByPrefix('dance', 'Jam', 60, true);
				spr.animation.play('dance', true);
				spr.screenCenter();
				add(spr);
				FlxG.sound.playMusic('assets/secrets/music/sunshine.ogg');
			case 'JustArt':
				var spr:FlxSprite = new FlxSprite().loadGraphic('assets/secrets/images/justart.png');
				add(spr);
				FlxG.sound.playMusic('assets/secrets/music/tea.ogg');
			default:
				specialPoem = true;
				openSubState(new DDLCPrompt('You\'ve unlocked a Special Poem!\nWould you like to read it?', 0, function(){showPoem(getPoemID(code));}, function(){exit();}, 'Yes', 'No'));
		}

		if (!SaveData.unlockedSecrets.contains(code))
		{
			SaveData.unlockedSecrets.push(code);
			if (specialPoem) SaveData.unlockedPoems.push(code);
			SaveData.saveSwagData();
		}

		trace(SaveData.unlockedSecrets);
		var secnum:Int = 0;
		for (i in CoolUtil.secretsList)
		{
			if (SaveData.unlockedSecrets.contains(i)) secnum++;
			if (secnum >= 9) {
				Achievements.unlock('all_secrets');
			}
		}
		var poemnum:Int = 0;
		for (i in CoolUtil.poemsList)
		{
			if (SaveData.unlockedPoems.contains(i)) poemnum++;
			if (poemnum >= 11) {
				Achievements.unlock('all_poems');
			}
		}
		super.create();
	}

	override function update(elapsed:Float)
	{
		if (!specialPoem && (FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE))
		{
			exit();
		}
		if (specialPoem && canExit)
		{
			if (FlxG.mouse.justPressed)
			{
				exit();
			}
		}
		super.update(elapsed);
	}

	override function closeSubState() {
		super.closeSubState();
	}

	function showPoem(id:Int)
	{
		if (id == 2)
		{
			var poem1:FlxSprite = new FlxSprite().loadGraphic('assets/secrets/images/special_poems/2a.png');
			poem1.alpha = 0;
			add(poem1);
			var poem2:FlxSprite = new FlxSprite().loadGraphic('assets/secrets/images/special_poems/2b.png');
			poem2.alpha = 0;
			add(poem2);
			FlxTween.tween(poem1, {alpha: 1}, 0.55, {
				ease:FlxEase.linear,
				onComplete: function(twn:FlxTween)
				{
					new FlxTimer().start(10, function(tmr:FlxTimer){
						FlxTween.tween(poem2, {alpha: 1}, 0.55, {
							ease:FlxEase.linear,
							onComplete: function(twn:FlxTween)
							{
								canExit = true;
							}
						});
					});
				}
			});
		}
		else
		{
			var poem:FlxSprite = new FlxSprite().loadGraphic('assets/secrets/images/special_poems/' + id + '.png');
			poem.alpha = 0;
			add(poem);
			FlxTween.tween(poem, {alpha: 1}, 0.55, {
				ease:FlxEase.linear,
				onComplete: function(twn:FlxTween)
				{
					canExit = true;
				}
			});
		}
	}

	function exit()
	{
		FlxG.sound.music.stop();
		CoolUtil.playMusic(CoolUtil.getTitleTheme());
		openSubState(new CustomFadeTransition(0.6, false, new SaveFileState()));
	}

	function getPoemID(code):Int
	{
		switch (code)
		{
			case 'SP1': return 1;
			case 'SP2': return 2;
			case 'SP3': return 3;
			case 'SP4': return 4;
			case 'SP5': return 5;
			case 'SP6': return 6;
			case 'SP7': return 7;
			case 'SP8': return 8;
			case 'SP9': return 9;
			case 'SP10': return 10;
			case 'SP11': return 11;
			default: return 1;
		}
	}
}
