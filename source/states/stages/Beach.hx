package states.stages;

class Beach extends BaseStage
{
	var bg:BGSprite = null;
	var sky:BGSprite = null;
	var clouds:BGSprite = null;
	var ship:BGSprite = null;
	var ocean:BGSprite = null;
	var fg:BGSprite = null;
	var waves:BGSprite = null;
	var trees:BGSprite = null;

	override function create()
	{
		if (ClientPrefs.lowQuality)
		{
			bg = new BGSprite('stages/beach/bg-lowquality', -450, -100, 1, 1);
			bg.antialiasing = ClientPrefs.globalAntialiasing;
			bg.setGraphicSize(Std.int(bg.width * 1.1));
			bg.updateHitbox();
			addToGame(bg);
		}
		else
		{
			sky = new BGSprite('stages/beach/sky', -450, -100, 0.1, 0.1);
			sky.antialiasing = ClientPrefs.globalAntialiasing;
			sky.setGraphicSize(Std.int(sky.width * 1.1));
			sky.updateHitbox();
			addToGame(sky);

			clouds = new BGSprite('stages/beach/clouds', -500, -100, 0.1, 0.1);
			clouds.active = true;
			clouds.velocity.x = 0.7;
			addToGame(clouds);

			ship = new BGSprite('stages/beach/ship', -380, -260, 0.78, 0.89);
			ship.antialiasing = ClientPrefs.globalAntialiasing;
			ship.setGraphicSize(Std.int(ship.width * 1.1));
			ship.updateHitbox();
			addToGame(ship);

			ocean = new BGSprite('stages/beach/ocean', -380, -260, 1, 1);
			ocean.antialiasing = ClientPrefs.globalAntialiasing;
			ocean.setGraphicSize(Std.int(ocean.width * 1.1));
			ocean.updateHitbox();
			addToGame(ocean);

			fg = new BGSprite('stages/beach/fg', -380, -260, 1.0, 1.0);
			fg.antialiasing = ClientPrefs.globalAntialiasing;
			fg.setGraphicSize(Std.int(fg.width * 1.1));
			fg.updateHitbox();
			addToGame(fg);

			waves = new BGSprite('stages/beach/waves-animated', -380, -260, 1.0, 1.0, ['Waves Loop'], true, 24);
			waves.setGraphicSize(Std.int(waves.width * 1.1));
			waves.updateHitbox();
			waves.antialiasing = ClientPrefs.globalAntialiasing;
			addToGame(waves);

			trees = new BGSprite('stages/beach/trees', -380, -260, 1.3, 1.1);
			trees.antialiasing = ClientPrefs.globalAntialiasing;
			trees.setGraphicSize(Std.int(trees.width * 1.1));
			trees.updateHitbox();
			add(trees);
		}
	}

	override function stageMorph()
	{
		remove(bg);
		remove(sky);
		remove(clouds);
		remove(ship);
		remove(ocean);
		remove(fg);
		remove(waves);
		remove(trees);
	}
}