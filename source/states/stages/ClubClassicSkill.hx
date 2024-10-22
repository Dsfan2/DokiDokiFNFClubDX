package states.stages;

class ClubClassicSkill extends BaseStage
{
	var bg:BGSprite = null;

	override function create()
	{
		bg = new BGSprite('stages/club/bg_skill-v1', -372, -164, 1.0, 1.0);
		bg.setGraphicSize(Std.int(bg.width * 1.6));
		bg.updateHitbox();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		addToGame(bg);
	}

	override function stageMorph()
	{
		remove(bg);
	}
}