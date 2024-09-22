package states.stages;

class Endgame extends BaseStage
{
	var glitchin:BGSprite = null;
	var fg:BGSprite = null;
	var err:BGSprite = null;

	var hall:BGSprite = null;
	var sroom:BGSprite = null;
	var deadgirls:BGSprite = null;

	var glitchSpr1:BGSprite = null;
	var glitchSpr2:BGSprite = null;
	var glitchSpr3:BGSprite = null;

	var glitchScrollBack:FlxBackdrop;
	var glitchScrollFront:FlxBackdrop;

	var sfCG:FlxSprite;

	override function create()
	{
		glitchin = new BGSprite('stages/finale/bg_static', 0, 0, 0, 0, ['static'], true);
		glitchin.setGraphicSize(Std.int(glitchin.width * 2.5));
		glitchin.updateHitbox();
		glitchin.screenCenter();
		glitchin.y = -360;
		glitchin.antialiasing = ClientPrefs.globalAntialiasing;
		addToGame(glitchin);

		if (!ClientPrefs.lowQuality)
		{
			err = new BGSprite('stages/finale/err', 0, 0, 0, 0);
			err.setGraphicSize(Std.int(err.width * 1.3));
			err.updateHitbox();
			err.screenCenter();
			err.x += 170;
			err.y = -500;
			err.antialiasing = ClientPrefs.globalAntialiasing;
			addToGame(err);
		}

		glitchScrollBack = new FlxBackdrop(Paths.image('stages/finale/backGlitchScroll'), X);
		glitchScrollBack.y = -140;
		glitchScrollBack.scrollFactor.set(0.1, 0.1);
		glitchScrollBack.velocity.set(-50, 0);
		glitchScrollBack.antialiasing = ClientPrefs.globalAntialiasing;
		addToGame(glitchScrollBack);

		hall = new BGSprite('stages/finale/hall', -900, -300, 0.3, 0.2);
		hall.setGraphicSize(Std.int(hall.width * 0.7));
		hall.updateHitbox();
		hall.angle = -10;
		hall.alpha = 0;
		addToGame(hall);

		sroom = new BGSprite('stages/finale/s-room', 910, -300, 0.3, 0.2);
		sroom.setGraphicSize(Std.int(hall.width * 0.8));
		sroom.updateHitbox();
		sroom.angle = 10;
		sroom.alpha = 0;
		addToGame(sroom);

		deadgirls = new BGSprite('stages/finale/deadgirls', -300, -780, 0.5, 0.4);
		deadgirls.setGraphicSize(Std.int(deadgirls.width * 0.95));
		deadgirls.updateHitbox();
		deadgirls.alpha = 0;
		addToGame(deadgirls);

		if (!ClientPrefs.lowQuality)
		{
			glitchSpr1 = new BGSprite('stages/finale/glitch3', -880, -25, 0.8, 0.8);
			glitchSpr1.setGraphicSize(Std.int(glitchSpr1.width * 1));
			glitchSpr1.updateHitbox();
			glitchSpr1.alpha = 0;
			addToGame(glitchSpr1);
		}

		fg = new BGSprite('stages/finale/fg', -850, -420, 1.0, 1.0);
		fg.setGraphicSize(Std.int(fg.width * 1.6));
		fg.updateHitbox();
		addToGame(fg);

		if (!ClientPrefs.lowQuality)
		{
			glitchSpr2 = new BGSprite('stages/finale/glitch2', 450, 160, 1.1, 1.1);
			glitchSpr2.setGraphicSize(Std.int(glitchSpr2.width * 1));
			glitchSpr2.updateHitbox();
			glitchSpr2.alpha = 0;
			add(glitchSpr2);

			glitchSpr3 = new BGSprite('stages/finale/glitch1', -710, 517, 1.25, 1.25);
			glitchSpr3.setGraphicSize(Std.int(glitchSpr3.width * 1));
			glitchSpr3.updateHitbox();
			glitchSpr3.alpha = 0;
			add(glitchSpr3);
		}

		glitchScrollFront = new FlxBackdrop(Paths.image('stages/finale/frontGlitchScroll'), X);
		glitchScrollFront.y = 70;
		glitchScrollFront.scrollFactor.set(1.5, 1.5);
		glitchScrollFront.velocity.set(-100, 0);
		glitchScrollFront.scale.set(2, 2);
		glitchScrollFront.antialiasing = ClientPrefs.globalAntialiasing;
		glitchScrollFront.alpha = 0;
		add(glitchScrollFront);

		sfCG = new FlxSprite(0, 0).loadGraphic(Paths.image('sf_cgs/Respect'));
		sfCG.cameras = [game.camHUD];
		sfCG.antialiasing = ClientPrefs.globalAntialiasing;
		sfCG.alpha = 0;
		addToGame(sfCG);
	}

	override function countdownTick(count:Countdown, num:Int) gf.alpha = 0;

	override function stageMorph()
	{
		remove(glitchin);
		remove(fg);
	}

	override function stepHit()
	{
		if (songName == 'system-failure' && !game.endingSong)
		{
			if (curStep == 1360 || curStep == 2704 || curStep == 3680 || curStep == 4064)
			{
				glitchin.visible = false;
				glitchScrollBack.visible = false;
				hall.visible = false;
				sroom.visible = false;
				deadgirls.visible = false;
				fg.visible = false;
				glitchScrollFront.visible = false;
				if (!ClientPrefs.lowQuality)
				{
					err.visible = false;
					glitchSpr1.visible = false;
					glitchSpr2.visible = false;
					glitchSpr3.visible = false;
				}
			}
			if (curStep == 1792)
			{
				glitchin.visible = true;
				glitchScrollBack.visible = true;
				hall.visible = true;
				sroom.visible = true;
				deadgirls.visible = true;
				fg.visible = true;
				glitchScrollFront.visible = true;
				hall.alpha = 1;
				sroom.alpha = 1;
				if (!ClientPrefs.lowQuality)
				{
					err.visible = true;
					glitchSpr1.visible = true;
					glitchSpr2.visible = true;
					glitchSpr3.visible = true;
					glitchSpr1.alpha = 1;
				}
			}
			if (curStep == 3168)
			{
				glitchin.visible = true;
				glitchScrollBack.visible = true;
				hall.visible = true;
				sroom.visible = true;
				deadgirls.visible = true;
				fg.visible = true;
				glitchScrollFront.visible = true;
				deadgirls.alpha = 1;
				glitchScrollFront.alpha = 1;
				if (!ClientPrefs.lowQuality)
				{
					err.visible = true;
					glitchSpr1.visible = true;
					glitchSpr2.visible = true;
					glitchSpr3.visible = true;
					glitchSpr2.alpha = 1;
					glitchSpr3.alpha = 1;
				}
			}
			if (curStep == 3744 || curStep == 4192)
			{
				glitchin.visible = true;
				glitchScrollBack.visible = true;
				hall.visible = true;
				sroom.visible = true;
				deadgirls.visible = true;
				fg.visible = true;
				glitchScrollFront.visible = true;
				if (!ClientPrefs.lowQuality)
				{
					err.visible = true;
					glitchSpr1.visible = true;
					glitchSpr2.visible = true;
					glitchSpr3.visible = true;
				}
			}
			if (curStep == 4320)
			{
				FlxTween.tween(glitchin, {alpha: 0}, 2, {ease: FlxEase.linear});
				FlxTween.tween(glitchScrollBack, {alpha: 0}, 2, {ease: FlxEase.linear});
				FlxTween.tween(hall, {alpha: 0}, 2, {ease: FlxEase.linear});
				FlxTween.tween(sroom, {alpha: 0}, 2, {ease: FlxEase.linear});
				FlxTween.tween(deadgirls, {alpha: 0}, 2, {ease: FlxEase.linear});
				FlxTween.tween(fg, {alpha: 0}, 2, {ease: FlxEase.linear});
				FlxTween.tween(glitchScrollFront, {alpha: 0}, 2, {ease: FlxEase.linear});
				if (!ClientPrefs.lowQuality)
				{
					FlxTween.tween(err, {alpha: 0}, 2, {ease: FlxEase.linear});
					FlxTween.tween(glitchSpr1, {alpha: 0}, 2, {ease: FlxEase.linear});
					FlxTween.tween(glitchSpr2, {alpha: 0}, 2, {ease: FlxEase.linear});
					FlxTween.tween(glitchSpr3, {alpha: 0}, 2, {ease: FlxEase.linear});
				}
			}
			switch (curStep)
			{
				case 1504:
					sfCG.loadGraphic(Paths.image('sf_cgs/Parfait Girls'));
					sfCG.alpha = 0.5;
					FlxTween.tween(sfCG, {alpha: 0}, 2.5, {ease: FlxEase.linear});
				case 1536:
					sfCG.loadGraphic(Paths.image('sf_cgs/Portrait Of Markov'));
					sfCG.alpha = 0.5;
					FlxTween.tween(sfCG, {alpha: 0}, 2.5, {ease: FlxEase.linear});
				case 1568:
					sfCG.loadGraphic(Paths.image('sf_cgs/Manga Box'));
					sfCG.alpha = 0.5;
					FlxTween.tween(sfCG, {alpha: 0}, 2.5, {ease: FlxEase.linear});
				case 1600:
					sfCG.loadGraphic(Paths.image('sf_cgs/Choco Stick'));
					sfCG.alpha = 0.5;
					FlxTween.tween(sfCG, {alpha: 0}, 2.5, {ease: FlxEase.linear});
				case 1632:
					sfCG.loadGraphic(Paths.image('sf_cgs/Banner'));
					sfCG.alpha = 0.5;
					FlxTween.tween(sfCG, {alpha: 0}, 2.5, {ease: FlxEase.linear});
				case 1664:
					sfCG.loadGraphic(Paths.image('sf_cgs/Blazer'));
					sfCG.alpha = 0.5;
					FlxTween.tween(sfCG, {alpha: 0}, 2.5, {ease: FlxEase.linear});
				case 1696:
					sfCG.loadGraphic(Paths.image('sf_cgs/Headshot'));
					sfCG.alpha = 0.5;
					FlxTween.tween(sfCG, {alpha: 0}, 2.5, {ease: FlxEase.linear});
				case 1728:
					sfCG.loadGraphic(Paths.image('sf_cgs/Just Monika'));
					sfCG.alpha = 0.5;
					FlxTween.tween(sfCG, {alpha: 0}, 2.5, {ease: FlxEase.linear});
				case 2848:
					sfCG.loadGraphic(Paths.image('sf_cgs/Self-Love'));
					sfCG.alpha = 0.5;
					FlxTween.tween(sfCG, {alpha: 0}, 2.5, {ease: FlxEase.linear});
				case 2880:
					sfCG.loadGraphic(Paths.image('sf_cgs/Balance'));
					sfCG.alpha = 0.5;
					FlxTween.tween(sfCG, {alpha: 0}, 2.5, {ease: FlxEase.linear});
				case 2912:
					sfCG.loadGraphic(Paths.image('sf_cgs/Respect'));
					sfCG.alpha = 0.5;
					FlxTween.tween(sfCG, {alpha: 0}, 2.5, {ease: FlxEase.linear});
				case 2944:
					sfCG.loadGraphic(Paths.image('sf_cgs/Understanding'));
					sfCG.alpha = 0.5;
					FlxTween.tween(sfCG, {alpha: 0}, 2.5, {ease: FlxEase.linear});
				case 2976:
					sfCG.loadGraphic(Paths.image('sf_cgs/Reflection'));
					sfCG.alpha = 0.5;
					FlxTween.tween(sfCG, {alpha: 0}, 2.5, {ease: FlxEase.linear});
				case 3008:
					sfCG.loadGraphic(Paths.image('sf_cgs/Equals'));
					sfCG.alpha = 0.5;
					FlxTween.tween(sfCG, {alpha: 0}, 2.5, {ease: FlxEase.linear});
				case 3040:
					sfCG.loadGraphic(Paths.image('sf_cgs/Dearest Friend'));
					sfCG.alpha = 0.5;
					FlxTween.tween(sfCG, {alpha: 0}, 2.5, {ease: FlxEase.linear});
				case 3072:
					sfCG.loadGraphic(Paths.image('sf_cgs/Trust'));
					sfCG.alpha = 0.5;
					FlxTween.tween(sfCG, {alpha: 0}, 2.5, {ease: FlxEase.linear});
			}
		}
	}
}