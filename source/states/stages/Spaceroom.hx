package states.stages;

class Spaceroom extends BaseStage
{
	var spaceBG:FlxBackdrop = null;
	var bg:BGSprite = null;
	var table:BGSprite = null;

	override function create()
	{
		if ((ClientPrefs.playerChar == 3 || PlayState.songType == "Classic") && songName != 'festival-deluxe')
			game.defaultCamZoom = 0.5;
		else
			game.defaultCamZoom = 0.75;

		spaceBG = new FlxBackdrop(Paths.image('stages/spaceroom/space-bg'));
		spaceBG.y -= 300;
		spaceBG.x -= 760;
		spaceBG.scrollFactor.set(0.1, 0.1);
		spaceBG.velocity.set(-7, 0);
		spaceBG.scale.set(2, 2);
		spaceBG.antialiasing = ClientPrefs.globalAntialiasing;
		addToGame(spaceBG);

		bg = new BGSprite('stages/spaceroom/bg', -850, -420, 0.4, 0.6);
		bg.setGraphicSize(Std.int(bg.width * 2.3));
		bg.updateHitbox();
		addToGame(bg);

		table = new BGSprite('stages/spaceroom/table', -500, 570, 1.0, 1.0);
		table.setGraphicSize(Std.int(table.width * 2.07));
		table.updateHitbox();
		addToGame(table);
	}

	override function stageMorph()
	{
		remove(spaceBG);
		remove(bg);
		remove(table);
	}
}