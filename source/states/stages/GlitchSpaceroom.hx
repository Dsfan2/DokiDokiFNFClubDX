package states.stages;

class GlitchSpaceroom extends BaseStage
{
	var bg:BGSprite = null;
	var table:BGSprite = null;
	var monikaScreenA:FlxSprite;
	var monikaScreenB:FlxSprite;
	var monikaScreenC:FlxSprite;

	override function create()
	{
		if (ClientPrefs.playerChar == 3 || PlayState.songType == "Classic" || songName == 'festival-deluxe')
			game.defaultCamZoom = 0.5;
		else
			game.defaultCamZoom = 0.75;

		bg = new BGSprite('stages/spaceroom/animatedClubroomGlitch', -880, -420, 1.0, 1.0, ['background 2'], true, 48);
		bg.setGraphicSize(Std.int(bg.width * 3.5));
		bg.updateHitbox();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		addToGame(bg);

		table = new BGSprite('stages/spaceroom/table', -500, 570, 1.0, 1.0);
		table.setGraphicSize(Std.int(table.width * 2.07));
		table.updateHitbox();
		addToGame(table);

		monikaScreenA = new FlxSprite(0, 0).loadGraphic(Paths.image('hacks/moniA'));
		monikaScreenA.cameras = [game.camHUD];
		monikaScreenA.alpha = 0.6;

		monikaScreenB = new FlxSprite(0, 0).loadGraphic(Paths.image('hacks/moniB'));
		monikaScreenB.cameras = [game.camHUD];
		monikaScreenB.alpha = 0.6;

		monikaScreenC = new FlxSprite(0, 0).loadGraphic(Paths.image('hacks/moniC'));
		monikaScreenC.cameras = [game.camHUD];
		monikaScreenC.alpha = 0.6;
	}

	override function stepHit()
	{
		if (songName == 'ultimate-glitcher') {
			if (curStep == 1856){
				bg.animation.paused = true;
			}
		}
	}

	override function eventCalled(eventName:String, value1:String, value2:String)
	{
		switch(eventName)
		{
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
		}
	}
	override function stageMorph()
	{
		remove(bg);
		remove(table);
		remove(monikaScreenA);
		remove(monikaScreenB);
		remove(monikaScreenC);
	}
}