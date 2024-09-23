package states;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.FlxSubState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;

class CompletionScreen extends MusicBeatState
{
	var completeScreen:FlxSprite;
	var completeText:FlxText;

	override function create()
	{
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		CoolUtil.playMusic('AFreshTrailer');

		persistentUpdate = persistentDraw = true;

		completeScreen = new FlxSprite(0, 0).loadGraphic(Paths.image('gallery/img/completion'));
		add(completeScreen);

		completeText = new FlxText(0, 17, FlxG.width, "Congratulations! You've cleared every REGULAR song!\nThe Gallery has been unlocked as your 100% completion prize!", 40);
		completeText.setFormat(Paths.font("dokiUI.ttf"), 40, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, 0xFFBB5599);
		completeText.scrollFactor.set();
		completeText.borderSize = 3.5;
		completeText.antialiasing = true;
		add(completeText);

		SaveData.seenCompScreen = true;
		SaveData.saveSwagData();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (FlxG.keys.justPressed.ENTER)
		{
			FlxG.sound.music.stop();
			CoolUtil.playMusic(CoolUtil.getTitleTheme());
			openSubState(new CustomFadeTransition(0.4, false, new MainMenuState()));
		}

		super.update(elapsed);
	}
}
