package states.stages;

class DDTOClub extends BaseStage
{
	var ddtoCloset:BGSprite = null;
	var ddtoDesks:BGSprite = null;
	var bg:BGSprite = null;
	var monikaBack:BGSprite = null;
	var sayoriBack:BGSprite = null;
	var yuriBack:BGSprite = null;
	var natsukiBack:BGSprite = null;
	var ddtoMonikaBack:BGSprite = null;
	var ddtoSayoriBack:BGSprite = null;
	var ddtoYuriBack:BGSprite = null;
	var ddtoNatsukiBack:BGSprite = null;

	override function create()
	{
		ddtoCloset = new BGSprite('stages/ddto/DDLCfarbg', -700, -520, 0.9, 0.9);
		ddtoCloset.setGraphicSize(Std.int(ddtoCloset.width * 1.6));
		ddtoCloset.updateHitbox();
		addToGame(ddtoCloset);

		bg = new BGSprite('stages/ddto/DDLCbg', -700, -520, 1.0, 0.9);
		bg.setGraphicSize(Std.int(bg.width * 1.6));
		bg.updateHitbox();
		addToGame(bg);

		monikaBack = new BGSprite('stages/club/monika-back', -270, 190, 1, 1, ['Monika Bop']);
		monikaBack.setGraphicSize(Std.int(monikaBack.width * 0.69));
		monikaBack.updateHitbox();
		monikaBack.alpha = 0;

		sayoriBack = new BGSprite('stages/club/sayori-back', 210, 160, 1, 1, ['Sayori Bop']);
		sayoriBack.setGraphicSize(Std.int(sayoriBack.width * 0.67));
		sayoriBack.updateHitbox();

		yuriBack = new BGSprite('stages/club/yuri-back', 680, 135, 1, 1, ['Yuri Bop']);
		yuriBack.setGraphicSize(Std.int(yuriBack.width * 0.67));
		yuriBack.updateHitbox();
		yuriBack.flipX = true;

		natsukiBack = new BGSprite('stages/club/natsuki-back', 1300, 200, 1, 1, ['Natsuki Bop']);
		natsukiBack.setGraphicSize(Std.int(natsukiBack.width * 0.67));
		natsukiBack.updateHitbox();

		ddtoMonikaBack = new BGSprite('stages/ddto/monika', -70, 125, 1, 1, ['Moni BG']);
		ddtoMonikaBack.setGraphicSize(Std.int(ddtoMonikaBack.width * 0.7));
		ddtoMonikaBack.updateHitbox();
		ddtoMonikaBack.alpha = 0;

		ddtoSayoriBack = new BGSprite('stages/ddto/sayori', 480, 200, 1, 1, ['Sayori BG']);
		ddtoSayoriBack.setGraphicSize(Std.int(ddtoSayoriBack.width * 0.7));
		ddtoSayoriBack.updateHitbox();

		ddtoYuriBack = new BGSprite('stages/ddto/yuri', 940, 125, 1, 1, ['Yuri BG']);
		ddtoYuriBack.setGraphicSize(Std.int(ddtoYuriBack.width * 0.7));
		ddtoYuriBack.updateHitbox();

		ddtoNatsukiBack = new BGSprite('stages/ddto/natsuki', 1150, 250, 1, 1, ['Natsu BG']);
		ddtoNatsukiBack.setGraphicSize(Std.int(ddtoNatsukiBack.width * 0.7));
		ddtoNatsukiBack.updateHitbox();

		addToGame(ddtoMonikaBack);
		addToGame(monikaBack);
		addToGame(ddtoSayoriBack);
		addToGame(sayoriBack);
		addToGame(ddtoYuriBack);
		addToGame(yuriBack);
		addToGame(ddtoNatsukiBack);
		addToGame(natsukiBack);

		ddtoDesks = new BGSprite('stages/ddto/DesksFront', -700, -520, 1.3, 0.9);
		ddtoDesks.setGraphicSize(Std.int(ddtoDesks.width * 1.6));
		ddtoDesks.updateHitbox();
		add(ddtoDesks);
	}

	override function countdownTick(count:Countdown, num:Int) backCharsBop();
	override function beatHit() backCharsBop();

	function backCharsBop() {
		monikaBack.dance();
		sayoriBack.dance();
		yuriBack.dance();
		natsukiBack.dance();
		ddtoMonikaBack.dance();
		ddtoSayoriBack.dance();
		ddtoYuriBack.dance();
		ddtoNatsukiBack.dance();
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
						ddtoMonikaBack.alpha = 0;
						sayoriBack.alpha = 1;
						ddtoSayoriBack.alpha = 1;
						yuriBack.alpha = 1;
						ddtoYuriBack.alpha = 1;
						natsukiBack.alpha = 1;
						ddtoNatsukiBack.alpha = 1;
					case 'sayori':
						monikaBack.alpha = 1;
						ddtoMonikaBack.alpha = 1;
						sayoriBack.alpha = 0;
						ddtoSayoriBack.alpha = 0;
						yuriBack.alpha = 1;
						ddtoYuriBack.alpha = 1;
						natsukiBack.alpha = 1;
						ddtoNatsukiBack.alpha = 1;
					case 'yuri':
						monikaBack.alpha = 1;
						ddtoMonikaBack.alpha = 1;
						sayoriBack.alpha = 1;
						ddtoSayoriBack.alpha = 1;
						yuriBack.alpha = 0;
						ddtoYuriBack.alpha = 0;
						natsukiBack.alpha = 1;
						ddtoNatsukiBack.alpha = 1;
					case 'natsuki':
						monikaBack.alpha = 1;
						ddtoMonikaBack.alpha = 1;
						sayoriBack.alpha = 1;
						ddtoSayoriBack.alpha = 1;
						yuriBack.alpha = 1;
						ddtoYuriBack.alpha = 1;
						natsukiBack.alpha = 0;
						ddtoNatsukiBack.alpha = 0;
				}
		}
	}

	override function stageMorph()
	{
		remove(ddtoCloset);
		remove(ddtoDesks);
		remove(bg);
		remove(monikaBack);
		remove(sayoriBack);
		remove(yuriBack);
		remove(natsukiBack);
		remove(ddtoMonikaBack);
		remove(ddtoSayoriBack);
		remove(ddtoYuriBack);
		remove(ddtoNatsukiBack);
	}
}