package states.stages;

class Void extends BaseStage
{
	var bg:BGSprite = null;

	override function create()
	{
		bg = new BGSprite('stages/void/bg', -600, -200, 0.9, 0.9);
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		addToGame(bg);
	}

	override function stageMorph()
	{
		remove(bg);
	}
}