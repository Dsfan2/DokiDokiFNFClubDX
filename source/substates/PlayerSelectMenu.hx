package substates;

import flixel.addons.display.FlxBackdrop;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class PlayerSelectMenu extends MusicBeatSubstate
{
	var charFile:Array<String> = [];
	var options:Array<String> = ['Boyfriend', 'Bowser Jr', 'Monika'];

	private var grpTexts:FlxTypedGroup<FlxText>;
 	var descBox:FlxSprite;
	private var descText:FlxText;
	var playerName:String = "";
	var nextAccept:Int = 5;

	var player1Sprite:FlxSprite;
	var player2Sprite:FlxSprite;
	var player3Sprite:FlxSprite;
	var cursor:FlxSprite;

	var hovering:Bool = false;

	var bg:FlxSprite;

	private var curSelected = 0;

	var selectedSomethin:Bool = false;

	override function create()
	{
		if (ClientPrefs.playerChar == 1)
            playerName = options[0];	
        if (ClientPrefs.playerChar == 2)
            playerName = options[1];
        if (ClientPrefs.playerChar == 3)
            playerName = options[2];

		bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
		bg.alpha = 0.6;
		add(bg);
		
		cursor = new FlxSprite(100, 200);
		cursor.frames = Paths.getSparrowAtlas('player-select/SlotFrame');
		cursor.animation.addByPrefix('static', 'Static', 24, true);
		cursor.animation.addByPrefix('confirm', 'Selected', 24, false);
		cursor.animation.play('static');
	    cursor.setGraphicSize(Std.int(cursor.width * 0.5));
		cursor.updateHitbox();
		cursor.antialiasing = ClientPrefs.globalAntialiasing;
		add(cursor);

		loadJunk();

		grpTexts = new FlxTypedGroup<FlxText>();
		add(grpTexts);

		for (i in 0...options.length)
		{
			var leText:FlxText = new FlxText((400 * i) + 100, 530, 305, options[i]);
			leText.setFormat(Paths.font("dokiUI.ttf"), 38, FlxColor.WHITE, FlxTextAlign.CENTER);
			leText.setBorderStyle(OUTLINE, 0xFFBB5599, 3.5);
			leText.antialiasing = true;
			leText.ID = i;
			grpTexts.add(leText);
		}

		descText = new FlxText(50, 600, 1180, "", 32);
		descText.setFormat(Paths.font("doki.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 1.5;
		descText.text = "Curent Player Character: " + playerName;
		add(descText);

		var titleText:FlxText = new FlxText(50, 50, 0, "Player Character Select", 32);
		titleText.setFormat(Paths.font("dokiUI.ttf"), 40, FlxColor.WHITE, FlxTextAlign.RIGHT);
		titleText.setBorderStyle(OUTLINE, 0xFFBB5599, 6);
		add(titleText);

		changeSelection();

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (!selectedSomethin)
		{
			if (controls.UI_LEFT_P)
			{
				changeSelection(-1);
			}
			if (controls.UI_RIGHT_P)
			{
				changeSelection(1);
			}

			if (controls.BACK)
			{
				close();
				FlxG.sound.play(Paths.sound('cancelMenu'));
			}

			if (controls.ACCEPT && nextAccept <= 0)
			{
				changeCharacter();
			}
		
			var bulltrash:Int = 0;
			grpTexts.forEach(function(txt:FlxText)
			{
				txt.setBorderStyle(OUTLINE, 0xFFBB5599, 3.5);
		
				if (txt.ID == curSelected)
				{
					txt.setBorderStyle(OUTLINE, 0xFFFFAACC, 3.5);
				}
			});

			if (FlxG.mouse.overlaps(player1Sprite))
			{
				curSelected = 0;
				if (!hovering) {
					changeSelection();
					hovering = true;
				}
				if (FlxG.mouse.justPressed)
					changeCharacter();
			}
			else if (FlxG.mouse.overlaps(player2Sprite))
			{
				curSelected = 1;
				if (!hovering) {
					changeSelection();
					hovering = true;
				}
				if (FlxG.mouse.justPressed)
					changeCharacter();
			}
			else if (FlxG.mouse.overlaps(player3Sprite))
			{
				curSelected = 2;
				if (!hovering) {
					changeSelection();
					hovering = true;
				}
				if (FlxG.mouse.justPressed)
					changeCharacter();
			}
			if (!FlxG.mouse.overlaps(player1Sprite) && !FlxG.mouse.overlaps(player2Sprite) && !FlxG.mouse.overlaps(player3Sprite)) {
				hovering = false;
			}

			if(nextAccept > 0) {
				nextAccept -= 1;
			}

		}

		super.update(elapsed);
	}

	function changeCharacter()
	{
		if (curSelected + 1 == ClientPrefs.playerChar) CoolUtil.makeSecretFile("What runs but doesn't move?"+ '\n' + "What leaks but isn't a Zelda Game?" + '\n' + "My hands are dirty. Time to was 'em.", 'A Riddle');
		switch(curSelected) 
		{
			case 0:
				FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
				ClientPrefs.playerChar = 1;
				player1Sprite.animation.play('select', true);
				player2Sprite.animation.play('idle', true);
				player3Sprite.animation.play('idle', true);
			case 1:
				FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
				ClientPrefs.playerChar = 2;
				player1Sprite.animation.play('idle', true);
				player2Sprite.animation.play('select', true);
				player3Sprite.animation.play('idle', true);
			case 2:
				FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
				ClientPrefs.playerChar = 3;
				player1Sprite.animation.play('idle', true);
				player2Sprite.animation.play('idle', true);
				player3Sprite.animation.play('select', true);
		}

		if (ClientPrefs.playerChar == 1)
            playerName = options[0];	
        if (ClientPrefs.playerChar == 2)
            playerName = options[1];
        if (ClientPrefs.playerChar == 3)
            playerName = options[2];

		cursor.animation.play('confirm');

		descText.text = "Curent Player Character: " + playerName;

		new FlxTimer().start(0.7, function(tmr:FlxTimer)
		{
			ClientPrefs.saveSettings();
			close();
		});
	}

	function changeSelection(change:Int = 0)
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		cursor.animation.play('static');

		switch (curSelected)
		{
			case 0:
				cursor.x = player1Sprite.x;
			case 1:
				cursor.x = player2Sprite.x;
			case 2:
				cursor.x = player3Sprite.x;
		}

		descText.text = "Curent Player Character: " + playerName;
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
	}

	function loadJunk()
	{
		player1Sprite = new FlxSprite(100, 200);
		player1Sprite.frames = Paths.getSparrowAtlas('player-select/PlayerChar_1');
		player1Sprite.animation.addByPrefix('idle', 'Idle Anim', 24, true);
		player1Sprite.animation.addByPrefix('select', 'Hey Anim', 24, false);
		player1Sprite.animation.play('idle');
	    player1Sprite.setGraphicSize(Std.int(player1Sprite.width * 0.5));
		player1Sprite.updateHitbox();
		player1Sprite.antialiasing = ClientPrefs.globalAntialiasing;
		add(player1Sprite);

		player2Sprite = new FlxSprite(500, 200);
		player2Sprite.frames = Paths.getSparrowAtlas('player-select/PlayerChar_2');
		player2Sprite.animation.addByPrefix('idle', 'Idle Anim', 24, true);
		player2Sprite.animation.addByPrefix('select', 'Hey Anim', 24, false);
		player2Sprite.animation.play('idle');
	    player2Sprite.setGraphicSize(Std.int(player2Sprite.width * 0.5));
		player2Sprite.updateHitbox();
		player2Sprite.antialiasing = ClientPrefs.globalAntialiasing;
		add(player2Sprite);

		player3Sprite = new FlxSprite(900, 200);
		player3Sprite.frames = Paths.getSparrowAtlas('player-select/PlayerChar_3');
		player3Sprite.animation.addByPrefix('idle', 'Idle Anim', 24, true);
		player3Sprite.animation.addByPrefix('select', 'Hey Anim', 24, false);
		player3Sprite.animation.play('idle');
	    player3Sprite.setGraphicSize(Std.int(player3Sprite.width * 0.5));
		player3Sprite.updateHitbox();
		player3Sprite.antialiasing = ClientPrefs.globalAntialiasing;
		add(player3Sprite);
	}
}