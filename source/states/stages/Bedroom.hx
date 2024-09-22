package states.stages;

class Bedroom extends BaseStage
{
	var bg:BGSprite = null;

	override function create()
	{
		bg = new BGSprite('stages/s-room/bg', -365, -130, 1.0, 1.0);
		bg.setGraphicSize(Std.int(bg.width * 1.5));
		bg.updateHitbox();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		addToGame(bg);
	}

	override function stageMorph()
	{
		remove(bg);
	}
}