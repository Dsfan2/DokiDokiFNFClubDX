package states.stages;

class MarioStage extends BaseStage
{
	var bg:BGSprite = null;
	var backclouds:BGSprite = null;
	var vines:BGSprite = null;
	var mg:BGSprite = null;
	var frontclouds:BGSprite = null;
	var fg:BGSprite = null;

	override function create()
	{
		bg = new BGSprite('stages/mario-level/bg', -190, -200, 0.1, 0.1);
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		bg.setGraphicSize(Std.int(bg.width * 1.35));
		bg.updateHitbox();
		addToGame(bg);

		backclouds = new BGSprite('stages/mario-level/clouds1', -200, -200, 0.1, 0.2);
		backclouds.antialiasing = ClientPrefs.globalAntialiasing;
		backclouds.setGraphicSize(Std.int(backclouds.width * 1.3));
		backclouds.updateHitbox();
		addToGame(backclouds);

		vines = new BGSprite('stages/mario-level/vines', -200, -200, 0.35, 0.35);
		vines.antialiasing = ClientPrefs.globalAntialiasing;
		vines.setGraphicSize(Std.int(vines.width * 1.2));
		vines.updateHitbox();
		addToGame(vines);

		mg = new BGSprite('stages/mario-level/mushrooms', -200, -95, 0.5, 0.5);
		mg.antialiasing = ClientPrefs.globalAntialiasing;
		mg.setGraphicSize(Std.int(mg.width * 1.25));
		mg.updateHitbox();
		addToGame(mg);

		frontclouds = new BGSprite('stages/mario-level/clouds2', -100, -120, 0.55, 0.55);
		frontclouds.antialiasing = ClientPrefs.globalAntialiasing;
		frontclouds.setGraphicSize(Std.int(frontclouds.width * 1.3));
		frontclouds.updateHitbox();
		addToGame(frontclouds);

		fg = new BGSprite('stages/mario-level/fg', -280, -200, 1, 1);
		fg.antialiasing = ClientPrefs.globalAntialiasing;
		fg.setGraphicSize(Std.int(fg.width * 1.35));
		fg.updateHitbox();
		addToGame(fg);
	}

	override function stageMorph()
	{
		remove(bg);
		remove(mg);
		remove(fg);
	}
}