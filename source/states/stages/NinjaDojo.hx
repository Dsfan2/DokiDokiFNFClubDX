package states.stages;

class NinjaDojo extends BaseStage
{
	var bg:BGSprite = null;

	override function create()
	{
		bg = new BGSprite('stages/ninja-hideaway/bg', -470, -170, 1, 1);
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		bg.setGraphicSize(Std.int(bg.width * 1.2));
		bg.updateHitbox();
		addToGame(bg);
	}

	override function stageMorph()
	{
		remove(bg);
	}
}