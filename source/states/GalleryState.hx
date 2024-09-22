package states;

import flixel.addons.display.FlxBackdrop;
import backend.Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;

class GalleryState extends MusicBeatState
{
	private static var curSelected:Int = 0;

	private var grpPic:FlxTypedGroup<FlxSprite>;
	private var galleryStuff:Array<Array<String>> = [];

	var scroll:DDLCBorderBG;
	var background:FlxSprite;
	var descText:FlxText;

	var pic:FlxSprite;

	var blackBar:FlxSprite;

	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	var picSelector:FlxSprite;

	var picPrev1:FlxSprite;
	var picPrev2:FlxSprite;
	var picPrev3:FlxSprite;
	var picPrev4:FlxSprite;
	var picPrev5:FlxSprite;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Gallery", null);
		#end
		persistentUpdate = persistentDraw = true;

		TitleState.setDefaultRGB();
		scroll = new DDLCBorderBG(Paths.image('gallery/scrollbit'), -10, 0);
		scroll.rValue = 0xFFCD0069;
		scroll.gValue = 0xFFE0639E;
		add(scroll);
		background = new FlxSprite(0, 0).loadGraphic(Paths.image('gallery/galleryBG'));
		add(background);

		var daList:Array<Array<String>> = [ //Image name - Description
			['part1-thumb',						   						   'The mod thumbnail for the V4 Part 1 Release'],
			['deluxe-DDFNFC Thumb',					   			   								'The previous thumbnail'],
			['og-DDFNFC Thumb',						   								'The Thumbnail for the original mod'],
			['plus-DDFNFC Thumb',						 				 'The Thumbnail for the plus version of the mod'],
			['unused-thumb',						 				 	   	'The unused version of the V4 Mod Thumbnail'],
			['logos-old',			  			   			   'The various logos used for previous versions of the mod'],
			['logos-unused',			  			   		      'The various final logo ideas used during development'],
			['ds_logo_ogs',			  			   					   'The old and unused versions of the Team DS Logo'],
			['sepia-splash',   								"The Splash Screen that appears when first starting the mod"],
			['completion',					   					  			   				   '100% Completion Picture'],
			['ghost-menu',			  			 			   								"A title screen easter egg."],
			['getreal',			  								 				 				   "Monika is real 2401"],
			['crimal',			  								 			  "Sayori is secretly a criminal mastermind"],
			['tanooki',			  								 			  "She grabbed a leaf, and is now a raccoon"],
			['buff',			  								 		"Anabolic Steroids (DISCLAIMER: DON'T DO DRUGS)"],
			['bonus-freeplay',			  			   				   			'The old Bonus Freeplay Menu background'],
			['new-bonus-freeplay',			  			   			   'The full background for the Bonus Freeplay Menu'],
			['club-v1',			  	    				 		  'The Clubroom BG from the original version of the mod'],
			['club_placeholder',			  		   'A placeholder for the Clubroom BG used during early development'],
			['club_rough-sketch',			 			  				  'The rough sketch for the Clubroom BG by Dusk'],
			['doki-bg-yea',			  			 	    			 				 'The Clubroom BG that Dusk sent in'],
			['club-v3',			  	    			 	 					 'The Clubroom BG from the previous version'],
			['club-v4',	 			  				  'The brand new Clubroom BG, based on the previous version by Dusk'],
			//['club-x',	 			  				  		   'The alternate Clubroom BG used in the DOKI DOKI Remixes'],
			['hallway-v1',							   			   'The Hallway BG from the original version of the mod'],
			['hallway_st',										 				 'The Hallway BG that BlueSkies sent in'],
			['hallway-v3',				 			  						  'The Hallway BG from the previous version'],
			['hallway-v4',				 						 				 'The brand new Hallway BG by BlueSkies'],
			['s-room-v1',					 				 "The Sayori's Room BG from the original version of the mod"],
			['s-room_st',					  			   				   "The Sayori's Room BG that BlueSkies sent in"],
			['s-room-v3',		   										"The Sayori's Room BG from the previous version"],
			['s-room-v4',		   										"The brand new Sayori's Room BG redone by 5hark"],
			//['s-room-x',		   						  "The alternate Sayori's Room BG used in the DOKI DOKI Remixes"],
			['spaceroom-v1',					 				 "The Spaceroom BG from the original version of the mod"],
			['spaceroom-v3',		   										"The Spaceroom BG from the previous version"],
			['spaceroom-v4',					"The brand new Spaceroom BG, based on the previous version by BlueSkies"],
			//['spaceroom-x',									 "The alternate Spaceroom BG, used in the DOKI DOKI Remixes"],
			['field-old',			  	    				 'The Flowery Field BG from the previous version of the mod'],
			['beehive-old',			  	    				 	   'The Beehive BG from the previous version of the mod'],
			['graveyard-old',			  	    				 'The Graveyard BG from the previous version of the mod'],
			['spider-old',			  	    				 	   'The Spiders BG from the previous version of the mod'],
			['sky-old',			  	    				 	   'The Mario Level BG from the previous version of the mod'],
			['ninja-old',			  	    				 		 'The Ninja BG from the previous version of the mod'],
			['boxing-old',			  	    				   'The Boxing Ring BG from the previous version of the mod'],
			['sayori_st',				 			  				 'The old Sayori Sprites made by SANTIAGO GAMER FAN'],
			['yuri_st',					   							   'The old Yuri Sprites made by SANTIAGO GAMER FAN'],
			['natsuki_st',			  				 				'The old Natsuki Sprites made by SANTIAGO GAMER FAN'],
			['alt-minus',			  		 			  				  "The Minus Versions of The Dokis & Bowser Jr."],
			['jm_outlines',			  			   				   'The sprites for Just Monika in the previous version'],
			//['monika-x_og',			  								  "The original sprites for Monika X by CheezyLover"],
			//['sayori-x_placeholder',			  	 "Placeholder sprites for Sayori X used during development by 5hark"],
			//['natsuki-x_placeholder',			  						   "The original sprites for Natsuki X by 5hark"],
			['various_concepts',			  		 			  				  	 "Various concept sketches by 5hark"],
			['various_concepts_2',			  		 			  				  	 	"More concept sketches by 5hark"],
			//['sayuri_sketch',			  		 			  	 "Concept sketches for Sayori X & Yuri X by CheezyLover"],
			['FreeplaySelectCut',			  							   "The cut version of the Freeplay Select Menu"],
			['jr_evolution',			  			 			  				  "How Bowser Jr's Sprites have changed"],
			['monika_evolution',			  						 				 "How Monika's Sprites have changed"],
			['sayori_evolution',			 						 				 "How Sayori's Sprites have changed"],
			['yuri_evolution',			  			 	  			   				   "How Yuri's Sprites have changed"],
			['natsuki_evolution',					   								"How Natsuki's Sprites have changed"],
			['CommunityGame',			  								 		  "A thumbnail CommunityGame would make"],
			['fanart_mitterry-gamer',					   				   "Some cool looking Monikas by Mitterry Gamer"]
		];

		for(i in daList){
			galleryStuff.push(i);
		}

		pic = new FlxSprite(0, 30).loadGraphic(Paths.image('gallery/img/' + galleryStuff[curSelected][0]));
		pic.setGraphicSize(Std.int(pic.width * 0.75));
		pic.updateHitbox();
		pic.screenCenter(X);
		add(pic);
		pic.antialiasing = true;

		blackBar = new FlxSprite(pic.x, pic.y + 480).loadGraphic(Paths.image('gallery/blackBar'));
		blackBar.setGraphicSize(Std.int(blackBar.width * 0.75));
		blackBar.updateHitbox();
		blackBar.screenCenter(X);
		blackBar.alpha = 0.6;
		add(blackBar);

		descText = new FlxText(50, FlxG.height - 200, 1180, "", 32);
		descText.setFormat(Paths.font("doki.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 1.5;
		add(descText);

		leftArrow = new FlxSprite(200, 630).loadGraphic(Paths.image('gallery/galleryArrow'));
		add(leftArrow);

		rightArrow = new FlxSprite(1050, 630).loadGraphic(Paths.image('gallery/galleryArrow'));
		rightArrow.flipX = true;
		add(rightArrow);

		picSelector = new FlxSprite(0, 700).loadGraphic(Paths.image('gallery/gallerySelector'));
		picSelector.setGraphicSize(Std.int(picSelector.width * 0.1));
		picSelector.updateHitbox();
		picSelector.screenCenter(X);
		add(picSelector);

		picPrev3 = new FlxSprite(0, 620).loadGraphic(Paths.image('gallery/img/' + galleryStuff[curSelected][0]));
		picPrev3.setGraphicSize(Std.int(picPrev3.width * 0.1));
		picPrev3.updateHitbox();
		picPrev3.screenCenter(X);
		add(picPrev3);

		picPrev2 = new FlxSprite(picPrev3.x - 150, 620).loadGraphic(Paths.image('gallery/img/' + galleryStuff[curSelected][0]));
		picPrev2.setGraphicSize(Std.int(picPrev2.width * 0.1));
		picPrev2.updateHitbox();
		add(picPrev2);

		picPrev1 = new FlxSprite(picPrev2.x - 150, 620).loadGraphic(Paths.image('gallery/img/' + galleryStuff[curSelected][0]));
		picPrev1.setGraphicSize(Std.int(picPrev1.width * 0.1));
		picPrev1.updateHitbox();
		add(picPrev1);

		picPrev4 = new FlxSprite(picPrev3.x + 150, 620).loadGraphic(Paths.image('gallery/img/' + galleryStuff[curSelected][0]));
		picPrev4.setGraphicSize(Std.int(picPrev4.width * 0.1));
		picPrev4.updateHitbox();
		add(picPrev4);

		picPrev5 = new FlxSprite(picPrev4.x + 150, 620).loadGraphic(Paths.image('gallery/img/' + galleryStuff[curSelected][0]));
		picPrev5.setGraphicSize(Std.int(picPrev5.width * 0.1));
		picPrev5.updateHitbox();
		add(picPrev5);

		changeSelection();

		super.create();
	}

	var quitting:Bool = false;
	var holdTime:Float = 0;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}
	
		if(!quitting)
		{
			var leftP = controls.UI_LEFT_P || (FlxG.mouse.justPressed && FlxG.mouse.overlaps(leftArrow));
			var rightP = controls.UI_RIGHT_P || (FlxG.mouse.justPressed && FlxG.mouse.overlaps(rightArrow));

			if (leftP)
			{
				changeSelection(-1);
				holdTime = 0;
			}
			if (rightP)
			{
				changeSelection(1);
				holdTime = 0;
			}

			if(controls.UI_RIGHT || controls.UI_LEFT)
			{
				var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
				holdTime += elapsed;
				var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);
				
				if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
				{
					changeSelection((checkNewHold - checkLastHold) * (controls.UI_LEFT ? -1 : 1));
				}
			}

			if (controls.BACK)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				openSubState(new CustomFadeTransition(0.6, false, new ExtraStuffState()));
				quitting = true;
			}
		}
		super.update(elapsed);
	}

	var moveTween:FlxTween = null;

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'));

		curSelected += change;
		if (curSelected < 0)
			curSelected = galleryStuff.length - 1;
		if (curSelected >= galleryStuff.length)
			curSelected = 0;

		remove(pic);
		pic = new FlxSprite(0, 30).loadGraphic(Paths.image('gallery/img/' + galleryStuff[curSelected][0]));
		pic.setGraphicSize(Std.int(pic.width * 0.75));
		pic.updateHitbox();
		pic.screenCenter(X);
		add(pic);
		pic.antialiasing = true;

		remove(blackBar);
		blackBar = new FlxSprite(pic.x, pic.y + 480).loadGraphic(Paths.image('gallery/blackBar'));
		blackBar.setGraphicSize(Std.int(blackBar.width * 0.75));
		blackBar.updateHitbox();
		blackBar.screenCenter(X);
		blackBar.alpha = 0.6;
		add(blackBar);

		remove(descText);
		descText = new FlxText(50, FlxG.height - 200, 1180, galleryStuff[curSelected][1], 32);
		descText.setFormat(Paths.font("doki.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 1.5;
		add(descText);

		changePreviewPics();
	}

	function changePreviewPics()
	{
		remove(picPrev1);
		remove(picPrev2);
		remove(picPrev3);
		remove(picPrev4);
		remove(picPrev5);

		picPrev3 = new FlxSprite(0, 620).loadGraphic(Paths.image('gallery/img/' + galleryStuff[curSelected][0]));
		picPrev3.setGraphicSize(Std.int(picPrev3.width * 0.1));
		picPrev3.updateHitbox();
		picPrev3.screenCenter(X);
		add(picPrev3);

		if (curSelected - 1 < 0)
		{
			picPrev2 = new FlxSprite(picPrev3.x - 150, 620).loadGraphic(Paths.image('gallery/img/' + galleryStuff[0][0]));
			picPrev2.visible = false;
		}
		else
		{
			picPrev2 = new FlxSprite(picPrev3.x - 150, 620).loadGraphic(Paths.image('gallery/img/' + galleryStuff[curSelected - 1][0]));
			picPrev2.visible = true;
		}
		picPrev2.setGraphicSize(Std.int(picPrev2.width * 0.1));
		picPrev2.updateHitbox();
		add(picPrev2);

		if (curSelected - 2 < 0)
		{
			picPrev1 = new FlxSprite(picPrev2.x - 150, 620).loadGraphic(Paths.image('gallery/img/' + galleryStuff[0][0]));
			picPrev1.visible = false;
		}
		else
		{
			picPrev1 = new FlxSprite(picPrev2.x - 150, 620).loadGraphic(Paths.image('gallery/img/' + galleryStuff[curSelected - 2][0]));
			picPrev1.visible = true;
		}
		picPrev1.setGraphicSize(Std.int(picPrev1.width * 0.1));
		picPrev1.updateHitbox();
		add(picPrev1);

		if (curSelected + 1 >= galleryStuff.length)
		{
			picPrev4 = new FlxSprite(picPrev3.x + 150, 620).loadGraphic(Paths.image('gallery/img/' + galleryStuff[0][0]));
			picPrev4.visible = false;
		}
		else
		{
			picPrev4 = new FlxSprite(picPrev3.x + 150, 620).loadGraphic(Paths.image('gallery/img/' + galleryStuff[curSelected + 1][0]));
			picPrev4.visible = true;
		}
		picPrev4.setGraphicSize(Std.int(picPrev4.width * 0.1));
		picPrev4.updateHitbox();
		add(picPrev4);

		if (curSelected + 2 >= galleryStuff.length)
		{
			picPrev5 = new FlxSprite(picPrev4.x + 150, 620).loadGraphic(Paths.image('gallery/img/' + galleryStuff[0][0]));
			picPrev5.visible = false;
		}
		else
		{
			picPrev5 = new FlxSprite(picPrev4.x + 150, 620).loadGraphic(Paths.image('gallery/img/' + galleryStuff[curSelected + 2][0]));
			picPrev5.visible = true;
		}
		picPrev5.setGraphicSize(Std.int(picPrev5.width * 0.1));
		picPrev5.updateHitbox();
		add(picPrev5);
	}
}