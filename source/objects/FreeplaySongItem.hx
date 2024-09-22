package objects;

class FreeplaySongItem extends FlxSpriteGroup
{
	var songName:String = '';
	public var isFav:Bool = false;
	public var barThing:FlxSprite;
	public var diffHeart:FlxSprite;
	public var name:FlxText;
	public var favHeart:FlxSprite;
	public var newTxt:FlxSprite;
	public var composerTxt:FlxText;
	public var difficultyNum:FlxText;
	public var lock:FlxSprite;

	public var diffRank:String = 'easy';
	public var difficulty:Int = 0;

	public var targetY:Float = 0;
	public var yMult:Float = 95;
	public var yAdd:Float = 0;
	//public var targetX:Float = 0;
	public var xMult:Float = 10;
	public var xAdd:Float = 0;
	public var isSelected:Bool = false;

	public var tooLong:Bool = false;

	public function new(songName:String, difficulty:Int)
	{
		this.songName = songName;
		super();
		barThing = new FlxSprite().loadGraphic(Paths.image('freeplay/Normal/songItem/songThing'));
		barThing.setGraphicSize(Std.int(barThing.width * 0.7));
		barThing.updateHitbox();
		add(barThing);

		name = new FlxText(80, 35, 0, songName, 26);
		name.setFormat(Paths.font("doki.ttf"), 26, 0xFF000000, LEFT);
		add(name);

		composerTxt = new FlxText(80, 74, 456, '', 13);
		composerTxt.setFormat(Paths.font("doki.ttf"), 13, 0xFF000000, RIGHT);
		add(composerTxt);
		updateCompText();

		favHeart = new FlxSprite(500, -5);
		favHeart.frames = Paths.getSparrowAtlas('freeplay/Normal/songItem/favHeart');
		favHeart.animation.addByPrefix('anim', 'Appear', 24, false);
		favHeart.animation.addByPrefix('rev', 'Disappear', 24, false);
		favHeart.animation.play('anim', true);
		favHeart.setGraphicSize(Std.int(favHeart.width * 0.4));
		favHeart.updateHitbox();
		favHeart.visible = false;
		add(favHeart);
		favHeart.animation.finishCallback = function(name:String)
		{
			if (name == 'rev') favHeart.visible = false;
		}

		diffHeart = new FlxSprite(0, -90);
		diffHeart.frames = Paths.getSparrowAtlas('freeplay/Normal/songItem/diffHeart');
		diffHeart.animation.addByPrefix('easy', 'Easy', 24, true);
		diffHeart.animation.addByPrefix('normal', 'Normal', 24, true);
		diffHeart.animation.addByPrefix('hard', 'Hard', 24, true);
		diffHeart.animation.addByPrefix('extreme', 'Extreme', 24, true);
		diffHeart.setGraphicSize(Std.int(diffHeart.width * 0.6));
		diffHeart.updateHitbox();
		add(diffHeart);

		difficultyNum = new FlxText(18, 24, 50, '', 30);
		difficultyNum.setFormat(Paths.font("dokiUI.ttf"), 30, 0xFF000000, CENTER);
		add(difficultyNum);

		lock = new FlxSprite(230, 0).loadGraphic(Paths.image('freeplay/Normal/locked'));
		lock.visible = false;
		add(lock);

		if (difficulty > 20) difficulty = 20;
		if (difficulty < 1) difficulty = 1;

		reloadDiff(difficulty);
	}

	override function update(elapsed:Float)
	{
		var scaledY = FlxMath.remapToRange(targetY, 0, 1, 0, 1.3);
		var lerpY:Float = FlxMath.bound(elapsed * 9.6, 0, 1);
		y = FlxMath.lerp(y, (scaledY * yMult) + (FlxG.height * 0.4) + yAdd, lerpY);

		var scaledX = FlxMath.remapToRange(targetY, 0, 1, 0, 1.3);
		var lerpX:Float = FlxMath.bound(elapsed * 9.6, 0, 1);
		x = FlxMath.lerp(x, (scaledX * xMult) + 30 + xAdd, lerpX);

		super.update(elapsed);
	}

	public function reloadDiff(number:Int = 0)
	{
		if (number > 20) number = 20;
		if (number < 1) number = 1;

		if (number > 15) diffRank = 'extreme';
		else if (number > 10) diffRank = 'hard';
		else if (number > 5) diffRank = 'normal';
		else diffRank = 'easy';

		diffHeart.animation.play(diffRank, true);
		difficultyNum.text = Std.string(number);
	}

	public function heartAnim(?normal:Bool = true)
	{
		if (normal)
		{
			favHeart.animation.play('anim', true);
			favHeart.visible = true;
		}
		else
		{
			favHeart.animation.play('rev', true);
		}
	}

	public function updateCompText(?isDokiDoki:Bool = false)
	{
		var composer:String = CoolSongBlurb.getMainComposer(songName);
		composerTxt.text = composer;
	}

	public function selected()
	{
		if (favHeart.visible == false)
		{
			remove(favHeart);
		}
		if (lock.visible == false)
		{
			remove(lock);
		}
	}

	public function lockStatus(?unlocked:Bool = false)
	{
		if (!unlocked)
		{
			lock.visible = true;
			composerTxt.text = "???";
			name.text = "???";
			diffHeart.animation.play('hard', true);
			difficultyNum.text = '?';
		}
	}
}