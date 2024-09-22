package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.FlxCamera;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;
import flixel.graphics.FlxGraphic;

class NotebookThing extends MusicBeatState
{
	var tableBG:FlxSprite;
	var notebook:FlxSprite;
	var start1:FlxSprite;
	var start2:FlxSprite;
	var storyTexts:FlxTypedGroup<FlxText>;
	var black:FlxSprite;

	var progress:Int = 0;
	var canProceed:Bool = false;
	var pressedEnter:Bool = false;
	var skipcrud:Bool = false;
	var finished:Bool = false;
	var endSeq:Bool = false;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Beginning Story Mode", null);
		#end
		
		persistentUpdate = persistentDraw = true;

		tableBG = new FlxSprite().loadGraphic(Paths.image('introCutscene/table_bg'));
		add(tableBG);

		notebook = new FlxSprite(1000, 0).loadGraphic(Paths.image('introCutscene/notebook_bg'));
		add(notebook);

		start1 = new FlxSprite(30, 10);
		switch (ClientPrefs.playerChar)
		{
			case 1: start1.loadGraphic(Paths.image('introCutscene/BF'));
			case 2: start1.loadGraphic(Paths.image('introCutscene/JR'));
			case 3: start1.loadGraphic(Paths.image('introCutscene/MONI'));
		}
		start1.setGraphicSize(Std.int(start1.width * 0.7));
		start1.alpha = 0;
		add(start1);

		start2 = new FlxSprite(600, 20).loadGraphic(Paths.image('introCutscene/press_enter'));
		start2.setGraphicSize(Std.int(start2.width * 0.9));
		start2.alpha = 0;
		add(start2);

		storyTexts = new FlxTypedGroup<FlxText>();
		add(storyTexts);

		black = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		black.alpha = 0;
		add(black);

		CoolUtil.playMusic('notebook-cutscene');

		FlxTween.tween(notebook, {x: 0}, 3, {
			onComplete: function(twn:FlxTween) {
				FlxTween.tween(start1, {alpha: 1}, 1.5, {
					onComplete: function(twn:FlxTween) {
						FlxTween.tween(start2, {alpha: 1}, 1.5, {
							onComplete: function(twn:FlxTween) {
								canProceed = true;
							},
						ease: FlxEase.quadInOut});
					},
				ease: FlxEase.quadInOut});
			},
		ease: FlxEase.quadInOut});

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ENTER && canProceed)
		{
			if (progress == 0)
			{
				progress = 1;
				fadeStart();
			}
			if (progress == 2 && !finished)
			{
				skipAllText();
			}
			if (progress == 3 && finished)
			{
				progress = 4;
				endThing();
			}
		}
	}

	function fadeStart()
	{
		FlxTween.tween(start1, {alpha: 0}, 1, {ease: FlxEase.quadInOut});
		FlxTween.tween(start2, {alpha: 0}, 1, {
			onComplete: function(twn:FlxTween) {
				loadTexts();
			},
		ease: FlxEase.quadInOut});
	}

	function loadTexts()
	{
		var script:Array<String> = [];
		switch (ClientPrefs.playerChar)
		{
			case 1: script = bfScript;
			case 2: script = jrScript;
			case 3: script = moniScript;
		}
		progress = 2;
		var length:Int = script.length;

		for (i in 0...script.length)
		{
			var text:FlxText = new FlxText(0, 0, 515, script[i], 35);
			text.setFormat(Paths.font('m1.ttf'), 35, FlxColor.BLACK, CENTER);
			text.alpha = 0;
			text.ID = i;
			storyTexts.add(text);

			if (text.ID > 13)
			{
				text.x = 664;
				text.y = 108 + (46 * (i - 14));
			}
			if (text.ID < 14)
			{
				text.x = 90;
				text.y = 97 + (42 * i);
			}

			new FlxTimer().start(1 * i, function(tmr:FlxTimer) {
				FlxTween.tween(text, {alpha: 1}, 1, {
					onComplete: function(twn:FlxTween) {
						length -= 1;
						if (length < 1 && !skipcrud) 
						{
							progress = 3;
							finished = true;
						}
					},
				ease: FlxEase.linear});
			});
		}
	}

	function skipAllText()
	{
		skipcrud = true;
		remove(storyTexts);

		var script:Array<String> = [];
		switch (ClientPrefs.playerChar)
		{
			case 1: script = bfScript;
			case 2: script = jrScript;
			case 3: script = moniScript;
		}

		for (i in 0...script.length)
		{
			var text:FlxText = new FlxText(0, 0, 515, script[i], 35);
			text.setFormat(Paths.font('m1.ttf'), 35, FlxColor.BLACK, CENTER);
			text.ID = i;
			
			if (text.ID > 13)
			{
				text.x = 664;
				text.y = 108 + (46 * (i - 14));
			}
			if (text.ID < 14)
			{
				text.x = 90;
				text.y = 97 + (42 * i);
			}
			add(text);
		}
		finished = true;
	}

	function endThing()
	{
		FlxG.sound.music.fadeOut(1.5, 0);
		FlxTween.tween(black, {alpha: 1}, 1.5, {
			onComplete: function(twn:FlxTween) {
				FlxG.sound.music.stop();
				FlxTransitionableState.skipNextTransOut = true;
				FlxG.switchState(new PlayState());
			},
		ease: FlxEase.quadInOut});
	}

	var bfScript:Array<String> = [
		"It was a dark and stormy night.",
		"A stormy night at the Dearest Family Household.",
		"Boyfriend & Girlfriend were just chilling.",
		"Waiting for the storm to let up.",
		"Girlfriend then goes to her stache of video games.",
		"She grabs one game from the shelf.",
		"DDLC Plus for the Nintendo Switch.",
		"She opens up the game case...",
		"...and puts the game card into the console.",
		"Girlfriend then grabs a Switch Pro Controller...",
		"And sits down on the couch next to Boyfriend.",
		"But before they could start playing the game...",
		"A familiar face just HAS to ruin their fun.",
		"Surprise, surprise. It's Daddy Dearest.",
		"He just kinda appeared behind the couch.",
		"No cool effects, no sound, just kinda pops in.",
		"Boyfriend & Girlfriend look behind them and see him.",
		"\"You're going to Brazil!\"",
		"And in a bright flash of light...",
		"...Boyfriend & Girlfriend are warped..",
		"...into the world of the game.",
		"Little did Daddy Dearest know...",
		"...the kind of game he trapped them in.",
		"And that, is where our story truly begins.",
		"(Press ENTER To Begin)"
	];

	var jrScript:Array<String> = [
		"For this story...",
		"...we must look deep inside a Nintendo Switch system.",
		"Inside the world of Super Mario Bros Wonder.",
		"Castle Bowser has gathered enough Wonder Energy...",
		"...and is preparing his Epic Wonder Concert.",
		"A concert that'll make...",
		"...the entire universe his captive audience.",
		"His son, Bowser Jr, is getting ready to perform for it.",
		"As he is waiting for Mario to show up...",
		"...a strage glitchy portal appears over him.",
		"He notices his surroundings are glitching out a bit.",
		"In a moment of desperation, he tries to run away...",
		"...but the portal's suction has already got him.",
		"He tries to outlast getting pulled in, but to no avail.",
		"He gets sucked into the glitchy portal.",
		"His body starts to slightly glitch...",
		"...and contort from the portal.",
		"After what feels like forever...",
		"...Bowser Jr finally makes it out of the glitchy portal.",
		"However, he's trapped in another world...",
		"...in another game.",
		"And that, is where our story truly begins.",
		"(Press ENTER To Begin)"
	];

	var moniScript:Array<String> = [
		"For this story...",
		"...we must look deep inside a Nintendo Switch system.",
		"Inside the world of Doki Doki Literature Club Plus.",
		"The club president, Monika...",
		"...knows that the world she lives in is nothing but a game.",
		"She has known of this for years now.",
		"She went and hid in tone of the classroom closets.",
		"The poor girl is having a panic attack.",
		"Getting vivid flashbacks from previous game resets.",
		"Watching her friends die, over and over again...",
		"...for years, with seemingly no end.",
		"She's starting to think her epiphany is more of a curse.",
		"Being devistated by her harsh and cruel reality.",
		"Her friends won't ever have free will.",
		"And what's beyond the vail is forever out of her reach.",
		"But suddenly, this time, her panic abruptly stops.",
		"She has a strong, yet comforting feeling within her now.",
		"As if maybe, someone is watching over her.",
		"Monika then feels motivated...",
		"...to help her friends find peace in this unforgiving world.",
		"She exits the closet and goes back to the clubroom.",
		"And that, is where our story truly begins.",
		"(Press ENTER To Begin)"
	];
}
