package objects;

import flixel.FlxSprite;
import openfl.utils.Assets as OpenFlAssets;

class HealthBar extends FlxSpriteGroup
{
	//public var sprTracker:FlxSprite;
	private var isDokiDoki:Bool = false;
	private var isEditor:Bool = false;
	
	public var barOPP:FlxSprite;
	public var barPLR:FlxSprite;
	public var meterOPP:FlxSprite;
	public var meterPLR:FlxSprite;

	public var iconP1:HealthIcon;
	public var iconP2:HealthIcon;

	var xPos1:Float = 0.0;
	var xPos2:Float = 0.0;
	var yPos:Float = 0.0;

	public function new(opponent:String = 'dad', player:String = 'bf', isDokiDoki:Bool = false, isEditor:Bool = false)
	{
		super();
		this.isDokiDoki = isDokiDoki;
		this.isEditor = isEditor;
		if (isEditor)
		{
			xPos1 = 24;
			yPos = FlxG.height - 100;

			meterOPP = new FlxSprite(xPos1, yPos).loadGraphic(Paths.image('bars/meter'));
			meterOPP.scrollFactor.set();
			add(meterOPP);

			barOPP = new FlxSprite(xPos1, yPos).loadGraphic(Paths.image('bars/healthBar'));
			barOPP.scrollFactor.set();
			add(barOPP);

			iconP2 = new HealthIcon(opponent, false);
			iconP2.x = -13;
			iconP2.y = yPos - 33;
			iconP2.scale.set(0.66, 0.66);
			iconP2.animation.curAnim.curFrame = 0;
			add(iconP2);
		}
		else
		{
			xPos1 = 24;
			xPos2 = 979;
			if(ClientPrefs.downScroll) yPos = 10;
			else yPos = FlxG.height * 0.87;

			meterOPP = new FlxSprite(xPos1, yPos);
			meterOPP.frames = Paths.getSparrowAtlas('bars/meter');
			meterOPP.scrollFactor.set();
			for (i in 0...101)
			{
				meterOPP.animation.addByPrefix(Std.string(i), Std.string((i - 100) * -1) + ' HP', 24, true);
			}
			add(meterOPP);

			barOPP = new FlxSprite(xPos1, yPos).loadGraphic(Paths.image('bars/healthBar'));
			barOPP.scrollFactor.set();
			add(barOPP);

			meterPLR = new FlxSprite(xPos2, yPos);
			meterPLR.frames = Paths.getSparrowAtlas('bars/meter');
			meterPLR.scrollFactor.set();
			meterPLR.flipX = true;
			for (i in 0...101)
			{
				meterPLR.animation.addByPrefix(Std.string(i), Std.string(i) + ' HP', 24, true);
			}
			add(meterPLR);

			barPLR = new FlxSprite(xPos2, yPos).loadGraphic(Paths.image('bars/healthBar'));
			barPLR.scrollFactor.set();
			barPLR.flipX = true;
			add(barPLR);

			iconP2 = new HealthIcon(opponent, false);
			iconP2.x = -15;
			iconP2.y = yPos - 33;
			add(iconP2);

			iconP1 = new HealthIcon(player, true);
			iconP1.x = 1142;
			iconP1.y = yPos - 33;
			add(iconP1);
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!isEditor)
		{
			var mult:Float = FlxMath.lerp(0.66, iconP1.scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
			iconP1.scale.set(mult, mult);
			iconP1.updateHitbox();

			var mult:Float = FlxMath.lerp(0.66, iconP2.scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
			iconP2.scale.set(mult, mult);
			iconP2.updateHitbox();
		}
	}

	public function reloadHealthBarColors(plrIconColor:Array<Int>, oppIconColor:Array<Int>) {
		if (isEditor)
		{
			meterOPP.color = FlxColor.fromRGB(plrIconColor[0], plrIconColor[1], plrIconColor[2]);
		}
		else
		{
			meterPLR.color = FlxColor.fromRGB(plrIconColor[0], plrIconColor[1], plrIconColor[2]);
			meterOPP.color = FlxColor.fromRGB(oppIconColor[0], oppIconColor[1], oppIconColor[2]);
		}
	}

	public function updateBar(health:Int)
	{
		meterOPP.animation.play(Std.string(health), true);
		meterPLR.animation.play(Std.string(health), true);
		meterPLR.x = (xPos2 + (health - 100) * -2) + 10;

		if (PlayState.instance.dad.curCharacter == 'dad') {
			meterOPP.visible = false;
			barOPP.visible = false;
			iconP2.visible = false;
		}
		else
		{
			meterOPP.visible = true;
			barOPP.visible = true;
			iconP2.visible = true;
		}

		if (PlayState.instance.boyfriend.curCharacter == 'bf-gone') {
			meterPLR.visible = false;
			barPLR.visible = false;
			iconP1.visible = false;
		}
		else
		{
			meterPLR.visible = true;
			barPLR.visible = true;
			iconP1.visible = true;
		}
	}

	public function iconsAnim(state:String = '')
	{
		switch (state)
		{
			case 'win':
				iconP2.animation.curAnim.curFrame = 1;
				iconP1.animation.curAnim.curFrame = 2;
			case 'lose':
				iconP1.animation.curAnim.curFrame = 1;
				iconP2.animation.curAnim.curFrame = 2;
			default:
				iconP1.animation.curAnim.curFrame = 0;
				iconP2.animation.curAnim.curFrame = 0;
		}
	}

	public function changeIcon(player:Int = 1, iconName:String = 'face')
	{
		if (isEditor) player = 2;
		
		if (player == 2) iconP2.changeIcon(iconName);
		else iconP1.changeIcon(iconName);
	}

	public function bopIcons(isDokiDoki:Bool = false, danced:Bool = false)
	{
		iconP1.scale.set(0.86, 0.86);
		iconP2.scale.set(0.86, 0.86);

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (isDokiDoki)
		{
			if (danced)
			{
				iconP1.angle = 15;
				iconP2.angle = -15;
			}
			else
			{
				iconP1.angle = -15;
				iconP2.angle = 15;
			}
	
			FlxTween.tween(iconP1, {angle: 0}, Conductor.stepCrochet * 0.002, {ease: FlxEase.linear});
			FlxTween.tween(iconP2, {angle: 0}, Conductor.stepCrochet * 0.002, {ease: FlxEase.linear});
		}
	}
}
