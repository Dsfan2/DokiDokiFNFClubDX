package states.stages;

class Hive extends BaseStage
{
	var bg:BGSprite = null;
	var honeyLake1:BGSprite = null;
	var honeyLake2:BGSprite = null;
	var fg:BGSprite = null;

	override function create()
	{
		bg = new BGSprite('stages/beehive/bg', -200, -200, 0.4, 0.4);
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		addToGame(bg);

		honeyLake1 = new BGSprite('stages/beehive/honey-back', -300, -200, 0.8, 0.8);
		honeyLake1.antialiasing = ClientPrefs.globalAntialiasing;
		addToGame(honeyLake1);

		fg = new BGSprite('stages/beehive/fg', -200, -200, 1, 1);
		fg.antialiasing = ClientPrefs.globalAntialiasing;
		fg.setGraphicSize(Std.int(fg.width * 1.05));
		fg.updateHitbox();
		addToGame(fg);

		honeyLake2 = new BGSprite('stages/beehive/honey-front', -200, -200, 1.2, 0.95);
		honeyLake2.antialiasing = ClientPrefs.globalAntialiasing;
		honeyLake2.setGraphicSize(Std.int(honeyLake2.width * 1.05));
		honeyLake2.updateHitbox();
		addToGame(honeyLake2);
	}

	override function stageMorph()
	{
		remove(bg);
		remove(fg);
		remove(honeyLake1);
		remove(honeyLake2);
	}
}