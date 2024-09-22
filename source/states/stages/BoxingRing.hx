package states.stages;

class BoxingRing extends BaseStage
{
	var bg:BGSprite = null;
	var fg:BGSprite = null;
	var jumbotron:FlxSprite;
	var jumbotext1:FlxBackdrop;
	var jumbotext2:FlxBackdrop;
	var spaceBG:FlxBackdrop;

	override function create()
	{
		jumbotron = new FlxSprite(310, -60);
		jumbotron.frames = Paths.getSparrowAtlas('stages/boxing-ring/jumbotron/screens');
		jumbotron.animation.addByPrefix('0', 'Blank', 24, true);
		jumbotron.animation.addByPrefix('1', 'One', 24, true);
		jumbotron.animation.addByPrefix('2', 'Two', 24, true);
		jumbotron.animation.addByPrefix('3', 'Three', 24, true);
		jumbotron.animation.addByPrefix('4', 'Four', 24, true);
		jumbotron.animation.addByPrefix('5', 'Five', 24, true);
		jumbotron.animation.addByPrefix('6', 'Six', 24, true);
		jumbotron.animation.play('0', true);
		jumbotron.scrollFactor.set(0.1, 0.1);
		jumbotron.antialiasing = ClientPrefs.globalAntialiasing;
		addToGame(jumbotron);

		jumbotext1 = new FlxBackdrop(Paths.image('stages/boxing-ring/jumbotron/1text1'), X);
		jumbotext1.y = -60;
		jumbotext1.x = 310;
		jumbotext1.scrollFactor.set(0.1, 0.1);
		jumbotext1.velocity.set(-222, 0);
		jumbotext1.antialiasing = ClientPrefs.globalAntialiasing;
		jumbotext1.visible = false;
		addToGame(jumbotext1);

		jumbotext2 = new FlxBackdrop(Paths.image('stages/boxing-ring/jumbotron/1text2'), X);
		jumbotext2.y = 138;
		jumbotext2.x = 310;
		jumbotext2.scrollFactor.set(0.1, 0.1);
		jumbotext2.velocity.set(222, 0);
		jumbotext2.antialiasing = ClientPrefs.globalAntialiasing;
		jumbotext2.visible = false;
		addToGame(jumbotext2);

		bg = new BGSprite('stages/boxing-ring/bg', -286, -390, 0.1, 0.1);
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		addToGame(bg);

		fg = new BGSprite('stages/boxing-ring/fg', -500, -187, 1, 1);
		fg.antialiasing = ClientPrefs.globalAntialiasing;
		fg.setGraphicSize(Std.int(fg.width * 1.2));
		fg.updateHitbox();
		addToGame(fg);
	}

	override function eventCalled(eventName:String, value1:String, value2:String)
	{
		switch(eventName)
		{
			case "Change Boxing Screen":
				switch (value1)
				{
					case '1':
						jumbotron.animation.play('1', true);
						jumbotext1.visible = true;
						jumbotext2.visible = true;
						jumbotext1.graphic = Paths.image('stages/boxing-ring/jumbotron/1text1');
						jumbotext2.graphic = Paths.image('stages/boxing-ring/jumbotron/1text2');
					case '2':
						jumbotron.animation.play('2', true);
						jumbotext1.visible = true;
						jumbotext2.visible = true;
						jumbotext1.graphic = Paths.image('stages/boxing-ring/jumbotron/2text1');
						jumbotext2.graphic = Paths.image('stages/boxing-ring/jumbotron/2text2');
					case '3':
						jumbotron.animation.play('3', true);
						jumbotext1.visible = true;
						jumbotext2.visible = true;
						jumbotext1.graphic = Paths.image('stages/boxing-ring/jumbotron/3text1');
						jumbotext2.graphic = Paths.image('stages/boxing-ring/jumbotron/3text2');
					case '4':
						jumbotron.animation.play('4', true);
						jumbotext1.visible = false;
						jumbotext2.visible = false;
					case '5':
						jumbotron.animation.play('5', true);
						jumbotext1.visible = true;
						jumbotext2.visible = true;
						jumbotext1.graphic = Paths.image('stages/boxing-ring/jumbotron/5text1');
						jumbotext2.graphic = Paths.image('stages/boxing-ring/jumbotron/5text2');
					case '6':
						jumbotron.animation.play('6', true);
						jumbotext1.visible = true;
						jumbotext2.visible = true;
						jumbotext1.graphic = Paths.image('stages/boxing-ring/jumbotron/6text1');
						jumbotext2.graphic = Paths.image('stages/boxing-ring/jumbotron/6text2');
					default:
						jumbotron.animation.play('0', true);
						jumbotext1.visible = false;
						jumbotext2.visible = false;
				}
		}
	}

	override function stageMorph()
	{
		remove(bg);
		remove(fg);
		remove(jumbotron);
		remove(jumbotext1);
		remove(jumbotext2);
	}
}