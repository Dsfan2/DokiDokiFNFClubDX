package states.stages;

class Field extends BaseStage
{
	var bg:BGSprite = null;
	var fg:BGSprite = null;

	override function create()
	{
		bg = new BGSprite('stages/field/bg', -200, -200, 0.4, 0.4);
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		addToGame(bg);

		fg = new BGSprite('stages/field/fg', -350, -105, 1, 1);
		fg.antialiasing = ClientPrefs.globalAntialiasing;
		fg.setGraphicSize(Std.int(fg.width * 1.2));
		fg.updateHitbox();
		addToGame(fg);
	}
	override function stageMorph()
	{
		remove(bg);
		remove(fg);
	}
}