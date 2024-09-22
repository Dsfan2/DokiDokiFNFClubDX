package states.stages;

class PyramidCaverns extends BaseStage
{
	var bg:BGSprite = null;
	var fg:BGSprite = null;
	var pillars:BGSprite = null;
	var web:BGSprite = null;
	var vingette:BGSprite = null;
	var torchA:BGSprite = null;
	var torchB:BGSprite = null;

	override function create()
	{
		bg = new BGSprite('stages/pyramid/bg', -520, -80, 1, 1);
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		bg.setGraphicSize(Std.int(bg.width * 1.65));
		bg.updateHitbox();
		addToGame(bg);

		torchA = new BGSprite('stages/pyramid/torch', -300, 160, 1, 1, ['anim'], true);
		torchA.antialiasing = ClientPrefs.globalAntialiasing;
		torchA.setGraphicSize(Std.int(torchA.width * 1.65));
		torchA.updateHitbox();
		addToGame(torchA);

		fg = new BGSprite('stages/pyramid/fg', -520, -80, 1, 1);
		fg.antialiasing = ClientPrefs.globalAntialiasing;
		fg.setGraphicSize(Std.int(fg.width * 1.65));
		fg.updateHitbox();
		addToGame(fg);

		torchB = new BGSprite('stages/pyramid/torch', -450, 230, 1, 1, ['anim'], true);
		torchB.antialiasing = ClientPrefs.globalAntialiasing;
		torchB.setGraphicSize(Std.int(torchB.width * 1.65));
		torchB.updateHitbox();
		addToGame(torchB);

		web = new BGSprite('stages/pyramid/web', -520, -80, 1, 1);
		web.antialiasing = ClientPrefs.globalAntialiasing;
		web.setGraphicSize(Std.int(web.width * 1.65));
		web.updateHitbox();
		addToGame(web);

		pillars = new BGSprite('stages/pyramid/pillars', -580, -150, 1.1, 1);
		pillars.antialiasing = ClientPrefs.globalAntialiasing;
		pillars.setGraphicSize(Std.int(pillars.width * 1.7));
		pillars.updateHitbox();
		add(pillars);

		vingette = new BGSprite('stages/pyramid/weird-vingette', -520, -80, 1, 1);
		vingette.antialiasing = ClientPrefs.globalAntialiasing;
		vingette.setGraphicSize(Std.int(vingette.width * 1.6));
		vingette.updateHitbox();
		add(vingette);
	}

	override function stageMorph()
	{
		remove(bg);
		remove(fg);
		remove(torchA);
		remove(torchB);
		remove(pillars);
		remove(web);
		remove(vingette);
	}
}