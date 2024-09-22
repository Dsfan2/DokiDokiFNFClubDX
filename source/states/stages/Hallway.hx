package states.stages;

class Hallway extends BaseStage
{
	var bg:BGSprite = null;
	var sayoriBack:BGSprite = null;
	var yuriBack:BGSprite = null;
	var natsukiBack:BGSprite = null;

	override function create()
	{
		bg = new BGSprite('stages/hallway/bg', -240, -180, 1.0, 1.0);
		bg.setGraphicSize(Std.int(bg.width * 1.5));
		bg.updateHitbox();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		addToGame(bg);

		if (ClientPrefs.playerChar == 3)
		{
			sayoriBack = new BGSprite('stages/club/sayori-back', 350, 110, 1, 1, ['Sayori Bop']);
			sayoriBack.setGraphicSize(Std.int(sayoriBack.width * 0.75));
			sayoriBack.updateHitbox();
			sayoriBack.antialiasing = ClientPrefs.globalAntialiasing;
			addToGame(sayoriBack);

			yuriBack = new BGSprite('stages/club/yuri-back', 990, 40, 1, 1, ['Yuri Bop']);
			yuriBack.setGraphicSize(Std.int(yuriBack.width * 0.79));
			yuriBack.updateHitbox();
			yuriBack.antialiasing = ClientPrefs.globalAntialiasing;
			addToGame(yuriBack);

			natsukiBack = new BGSprite('stages/club/natsuki-back', 1350, 180, 1, 1, ['Natsuki Bop']);
			natsukiBack.setGraphicSize(Std.int(natsukiBack.width * 0.75));
			natsukiBack.updateHitbox();
			natsukiBack.antialiasing = ClientPrefs.globalAntialiasing;
			addToGame(natsukiBack);
		}
	}

	override function stageMorph()
	{
		remove(bg);
		if (ClientPrefs.playerChar == 3)
		{
			remove(sayoriBack);
			remove(yuriBack);
			remove(natsukiBack);
		}
	}

	override function countdownTick(count:Countdown, num:Int) {
		if (ClientPrefs.playerChar == 3) backCharsBop();
	}
	override function beatHit() {
		if (ClientPrefs.playerChar == 3) backCharsBop();
	}

	function backCharsBop() {
		sayoriBack.dance();
		yuriBack.dance();
		natsukiBack.dance();
	}
}