package states.stages;

class Graveyard extends BaseStage
{
	var bg:BGSprite = null;
	var fg:BGSprite = null;

	override function create()
	{
		bg = new BGSprite('stages/graveyard/bg', -200, -200, 0.4, 0.4);
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		addToGame(bg);

		fg = new BGSprite('stages/graveyard/fg', -300, -95, 1, 1);
		fg.antialiasing = ClientPrefs.globalAntialiasing;
		fg.setGraphicSize(Std.int(fg.width * 1.05));
		fg.updateHitbox();
		addToGame(fg);
	}

	override function stageMorph()
	{
		remove(bg);
		remove(fg);
	}
}