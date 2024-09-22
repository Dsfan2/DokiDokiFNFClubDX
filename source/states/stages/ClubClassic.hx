package states.stages;

class ClubClassic extends BaseStage
{
	var bg:BGSprite = null;
	var monikaBack:BGSprite = null;
	var sayoriBack:BGSprite = null;
	var yuriBack:BGSprite = null;
	var natsukiBack:BGSprite = null;

	override function create()
	{
		bg = new BGSprite('stages/club/bg_club-v1', -372, -164, 1.0, 1.0);
		bg.setGraphicSize(Std.int(bg.width * 1.6));
		bg.updateHitbox();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		addToGame(bg);

		monikaBack = new BGSprite('stages/club/monika-back', -270, 160, 1, 1, ['Monika Bop']);
		monikaBack.setGraphicSize(Std.int(monikaBack.width * 0.75));
		monikaBack.updateHitbox();
		monikaBack.antialiasing = ClientPrefs.globalAntialiasing;

		sayoriBack = new BGSprite('stages/club/sayori-back', -70, 190, 1, 1, ['Sayori Bop']);
		sayoriBack.setGraphicSize(Std.int(sayoriBack.width * 0.75));
		sayoriBack.updateHitbox();
		sayoriBack.antialiasing = ClientPrefs.globalAntialiasing;

		yuriBack = new BGSprite('stages/club/yuri-back', 990, 80, 1, 1, ['Yuri Bop']);
		yuriBack.setGraphicSize(Std.int(yuriBack.width * 0.79));
		yuriBack.updateHitbox();
		yuriBack.antialiasing = ClientPrefs.globalAntialiasing;

		natsukiBack = new BGSprite('stages/club/natsuki-back', 1350, 190, 1, 1, ['Natsuki Bop']);
		natsukiBack.setGraphicSize(Std.int(natsukiBack.width * 0.75));
		natsukiBack.updateHitbox();
		natsukiBack.antialiasing = ClientPrefs.globalAntialiasing;

		if (PlayState.songType != 'Normal' && PlayState.SONG.song.toLowerCase() != "fresh literature" && PlayState.SONG.song.toLowerCase() != "cupcakes" && PlayState.SONG.song.toLowerCase() != "poems are forever" && !PlayState.SONG.player2.startsWith('monika'))
			addToGame(monikaBack);
		if (!PlayState.SONG.player2.startsWith('sayori') && !PlayState.SONG.player2.startsWith('sxyori'))
			addToGame(sayoriBack);
		if (!PlayState.SONG.player2.startsWith('yur'))
			addToGame(yuriBack);
		if (!PlayState.SONG.player2.startsWith('natsuki') && PlayState.SONG.player2 != 'glitchsuki')
			addToGame(natsukiBack);
	}

	override function countdownTick(count:Countdown, num:Int) backCharsBop();
	override function beatHit() backCharsBop();

	function backCharsBop() {
		monikaBack.dance();
		sayoriBack.dance();
		yuriBack.dance();
		natsukiBack.dance();
	}

	override function eventCalled(eventName:String, value1:String, value2:String)
	{
		switch(eventName)
		{
			case 'Back Chars Invisible':
				var val1:String = value1.toLowerCase();
				switch (val1)
				{
					case 'monika':
						monikaBack.alpha = 0;
						sayoriBack.alpha = 1;
						yuriBack.alpha = 1;
						natsukiBack.alpha = 1;
					case 'sayori':
						monikaBack.alpha = 1;
						sayoriBack.alpha = 0;
						yuriBack.alpha = 1;
						natsukiBack.alpha = 1;
					case 'yuri':
						monikaBack.alpha = 1;
						sayoriBack.alpha = 1;
						yuriBack.alpha = 0;
						natsukiBack.alpha = 1;
					case 'natsuki':
						monikaBack.alpha = 1;
						sayoriBack.alpha = 1;
						yuriBack.alpha = 1;
						natsukiBack.alpha = 0;
				}
		}
	}

	override function stageMorph()
	{
		remove(bg);
		remove(monikaBack);
		remove(sayoriBack);
		remove(yuriBack);
		remove(natsukiBack);
	}
}