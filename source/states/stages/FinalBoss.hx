package states.stages;

class FinalBoss extends BaseStage
{
	var bg:BGSprite = null;

	override function create()
	{
		bg = new BGSprite('stages/spaceroom/animatedClubroomGlitch', -300, -160, 1.0, 1.0, ['background 2'], true, 48);
		bg.setGraphicSize(Std.int(bg.width * 2.2));
		bg.updateHitbox();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		addToGame(bg);
	}

	override function stageMorph()
	{
		remove(bg);
	}
}