package states;

class CreditsState extends MusicBeatState
{
	var curSelected:Int = -1;
	var curGrid:Int = -1;

	private var grpOptions:FlxTypedGroup<MemberCard>;
	private var creditsStuff:Array<Array<String>> = [];
	private var gridsList:Array<String> = ['Team DS Members'];

	private var selectedSomethin:Bool = false;

	var cardCloseup:MemberCard;
	var black:FlxSprite;

	var specialThanks:FlxText;

	var MAX_PER_ROW:Int = 5;
	var gridTitle:FlxText;
	var bottomText:FlxText;

	public var camMain:FlxCamera;
	public var camText:FlxCamera;

	private var teamds:Array<Array<String>> = [ //Header - Name - Icon name - Role - Social Media - Link - Favorite Word(s) - Chibi Doki - Stickers Image name
		['Team DS Member',				'Dsfan2',			'ds',				'Director, Writter, Musician, Programmer',		'YouTube',		'https://www.youtube.com/channel/UC5ll8qg39youNX11mCCwI7Q',	'Mîoeika',				'moni',	  	  	  'ds'],
		['Team DS Member',				'5hark',			'shark',			'Co-Director, Artist/Animator, Writter',		'GameBanana',	'https://gamebanana.com/members/2282488',					'Parfait',				'nat',	 	   'shark'],
		['Team DS Member',				'CheezyLover',		'cheeze',			'Artist/Animator',								'Twitter',		'https://x.com/cheezekisser',								'Dazzle',				'sayo',	  	  'cheeze'],
		['Team DS Member',				'Monika_Fan',		'monika_fan',		'Artist/Animator',								'YouTube',		'https://www.youtube.com/@Monika_Fan160',					'M nik',				'moni',	   'monikafan'],
		['Team DS Member',				'Kronekusss',		'kron',				'Background Artist,  Charter',					'YouTube',		'https://www.youtube.com/@Kronniee',						'Boop',					'nat',	    	'kron'],
		['Team DS Member',				'Mitterry Gamer',	'mitterry',			'Artist/Animator',								'Twitter',		'https://x.com/MitterryGamer',								'Ambient',				'yuyu',	    'mitterry'],
		['Team DS Member',				'MagicMemeMan69',	'mememan',			'Artist',										'YouTube',		'https://www.youtube.com/@magicmememan69',					'Uncanny',				'yuyu',	     'mememan'],
		['Team DS Member',				'Red Impostor',		'red',				'Programmer',									'YouTube',		'https://www.youtube.com/channel/UCwggkn9448JjS52rkLiXt0Q',	'Defeat',				'sayo',	    	 'red'],
		['Team DS Member',				'HQC',				'hqc',				'Musician',										'Bandcamp',		'https://hqcs.bandcamp.com',								'Lavender',				'yuyu',	    	 'hqc'],
		['Team DS Member',				'Cotito',			'cotito',			'Musician',										'YouTube',		'https://www.youtube.com/@Cotito77',						'Anime',				'nat',	      'cotito'],
		['Team DS Member',				'Martin5910',		'martin',			'Musician',										'YouTube',		'https://www.youtube.com/@Martin5910.',						'Fun',					'sayo',	      'martin'],
		['Team DS Member',				'SummerChartsStuff','summer',			'Charter',										'YouTube',		'https://www.youtube.com/@SlipstreamMuzzle',				'Sunset',				'sayo',	      'summer'],
		['Team DS Member',				'YaperPaper',		'yaper',			'Charter',										'YouTube',		'https://www.youtube.com/channel/UC83ZYEVyC2235JmceKcTePQ',	'Headphones',			'nat',	       'yaper'],
		['Team DS Member',				'StormRhys',		'storm',			'Charter',										'YouTube',		'https://www.youtube.com/channel/UCXnLFbkbXH7-NG2kY0R1gDA',	'Heartbeat',			'nat',	       'storm'],		
	];
	private var classics:Array<Array<String>> = [
		['Classic Song Composer',		'Dsfan2',			'ds',				'New Arrangements & Mashups',					'YouTube',		'https://www.youtube.com/channel/UC5ll8qg39youNX11mCCwI7Q',	'Mîoeika',				'moni',	  	  	  'ds'],
		['Classic Song Composer',		'Jayson Hayes',		'sayo',				'Candy Hearts, Candy Heartz',					'Twitter',		'https://x.com/TeamSalvato',								'Memories',				'sayo',	  	  	'ddlc'],
		['Classic Song Composer',		'Nikki Kaelar',		'nat',				'Various DDLC Bonus & Plus Songs',				'Twitter',		'https://x.com/TeamSalvato',								'Strawberry',			'nat',	  	    'ddlc'],
		['Classic Song Composer',		'Dan Salvato',		'moni',				'Original DDLC Songs',							'Twitter',		'https://x.com/dansalvato',									'onika',				'moni',	  	  	'ddlc'],
		['Classic Song Composer',		'RandomEncounters',	're',				'Just Monika',									'YouTube',		'https://www.youtube.com/channel/UCroJ5uxmGr-WOtXUPyqeh6g',	'Vibrant',				'yuyu',	  	      'yt'],
		['Classic Song Composer',		'OR30',				'or3o',				'Doki Forever',									'YouTube',		'https://www.youtube.com/@OR3Omusic/featured',				'Bliss',				'sayo',	  	      'yt'],
		['Classic Song Composer',		'Yoko Shimomura',	'yoko',				'Dark Star, The Final Battle',					'Twitter',		'https://x.com/midiplex',									'Dream',				'yuyu',	  	   'mario'],
		['Classic Song Composer',		'Wildy',			'wildy',			"You Can't Run",								'GameBanana',	'https://gamebanana.com/members/1663640',					'Silly',				'sayo',	  	  	 'fnf'],
		['Classic Song Composer',		'YingYang48',		'ying',				'Ultimate Glitcher',							'GameBanana',	'https://gamebanana.com/members/1782271',					'Email',				'nat',	  	  	 'fnf'],
		['Classic Song Composer',		'Kawai Sprite',		'kawaisprite',		'Fresh (Base FNF)',								'YouTube',		'https://www.youtube.com/@KawaiSprite',						'Kawaii',				'nat',	  	  	 'fnf'],
		['Classic Song Composer',		'shoji',			'yuri',				'Poems Are Forever',							'Twitter',		'https://x.com/TeamSalvato',								'Eternity',				'yuyu',	  	  	'ddlc'],
	];
	private var sf2chroms:Array<Array<String>> = [
		['Chromatic/Soundfont Maker',	'Dsfan2',			'ds',				'Various Soundfonts & Some Chromatics',			'YouTube',		'https://www.youtube.com/channel/UC5ll8qg39youNX11mCCwI7Q',	'Mîoeika',				'moni',	  	  	  'ds'],
		['Chromatic/Soundfont Maker',	'CheezyLover',		'cheeze',			'Sayori & Natsuki Chromatics',					'Twitter',		'https://x.com/cheezekisser',								'Dazzle',				'sayo',	  	  'cheeze'],
		['Chromatic/Soundfont Maker',	'HQC',				'hqc',				'Yuri Chromatic',								'Bandcamp',		'https://hqcs.bandcamp.com',								'Lavender',				'yuyu',	    	 'hqc'],
		['Chromatic/Soundfont Maker',	'LoganMcOof',		'loof',				'Male Player Soundfont',						'GameBanana',	'https://gamebanana.com/members/1807144',					'Milk',					'nat',	    	 'fnf'],
		['Chromatic/Soundfont Maker',	'Carof',			'carof',			'Female Player Chromatic',						'Twitter',		'https://x.com/xCarof',										'Disaster',				'yuyu',	  	  	'ddlc'],
		['Chromatic/Soundfont Maker',	'objectshowmaster',	'osm',				'DDTO Monika Soundfont',						'GameBanana',	'https://gamebanana.com/members/2013618',					'Heart',				'sayo',	    	 'fnf'],
		['Chromatic/Soundfont Maker',	'Kitsuism',			'blank',			'Sayori With More Range Chromatic',				'GameBanana',	'https://x.com/xCarof',										'sugar',				'nat',	  	  	 'fnf'],
		['Chromatic/Soundfont Maker',	'JM505',			'jm505',			'DDTO Sayori Soundfont (More Range)',			'GameBanana',	'https://gamebanana.com/members/1774949',					'Cage',					'yuyu',	    	 'fnf'],
		['Chromatic/Soundfont Maker',	'SuperStamps',		'stamps',			'DDTO Yuri & DDTO Natsuki Soundfonts',			'Twitter',		'https://www.youtube.com/@SuperStamps/featured',			'Charm',				'sayo',	    	 'fnf'],
	];
	private var spthx:Array<Array<String>> = [
		['Special Thanks',				'Carof',				'carof',		'Moral Support from Doki Doki Disaster',		'Twitter',		'https://x.com/xCarof',										'Disaster',				'yuyu',	  	  	'ddlc'],
		['Special Thanks',				'NooBZiiTo',			'monker',		'Moral Support from Doki Doki Bean Club',		'Twitter',		'https://x.com/NooBZiiTo1',									'Doki-Doki',			'nat',	  	  	'ddlc'],
		['Special Thanks',				'SANTIAGO GAMER FAN',	'santiago',		'Former Artist for the mod',					'GameBanana',	'https://gamebanana.com/members/1796601',					'Extraordinary',		'sayo',	  	  	 'fnf'],
		['Special Thanks',				'BlueSkies',			'blank',		'Former Artist for the mod',					'DeviantArt',	'https://www.deviantart.com/blueskies432',					'Nature',				'sayo',	  	  	 'fnf'],
		['Special Thanks',				'Dusk',					'blank',		'Former Artist for the mod',					'YouTube',		'https://www.youtube.com/channel/UCdk1LZWOYMauUagUA5qEexg',	'Summer',				'nat',	  	  	 'fnf'],
		['Special Thanks',				'Team TBD',				'tbd',			'Inspiration & Devs of Doki Doki Takeover',		'Twitter',		'https://x.com/SirDusterBuster',							'Moni a',				'moni',	  	  	 'fnf'],
		['Special Thanks',				'JJGamerYT',			'jjgamer',		'Inspiration & Developer of FNF X DDLC',		'Twitter',		'https://x.com/JJGOnlineIdiot',								'Crimson',				'yuyu',	  	  	 'fnf'],
		['Special Thanks',				"Funkin' Crew Inc", 	'funkin',		"Developers of Vanilla Friday Night Funkin'",	'Twitter',		'https://x.com/FNF_Developers',								'Climax',				'yuyu',	  	  	 'fnf'],
		['Special Thanks',				"Shadow Mario",	 		'shadowmario',	"Created base Psych Engine",					'GameBanana',	'https://gamebanana.com/members/1735892',					'Color',				'sayo',	  	  	 'fnf'],
		['Special Thanks',				'Nintendo',				'mario',		'Owners of Super Mario characters',				'YouTube',		'https://www.youtube.com/@NintendoAmerica/featured',		'Jump',					'nat',	  	   'mario'],
		['Special Thanks',				'Team Salvato',			'moni',			'Developers of Doki Doki Literature Club',		'Twitter',		'https://x.com/TeamSalvato',								'Monika',				'moni',	  	  	'ddlc'],
	];

	// Card Example:
	// ['Literature Club Member Card',	'Monika',	'moni',	'Club President',							'Twitter',	'https://x.com/lilmonix3',									'Harmony, Visualize, Value',	'moni',	'ddlc'],

	private var blk:Array<Array<String>> = [];

	private var thanksList:String = 
	"JustArt,
	GameToons Gaming, Game Theory, ArchiAce, fan_de_fridaynight, 
	Wattrix Moon, Hanii, Squichikiti, LinTheHufflepuff, Garnelus, 
	adamsaustra, xiushan, fazelfarrokhi20, Mr. Whom, Kata Shichimo, 
	JakeLeB, andrea2279, Nickfrye256, highjackslayer, Monika.chr, 
	FelixFNFGaming, Senpai 5, Solzala Insock, Luminous7, 
	Everyone who enjoyed all my FNF Mods\n\n
	...And you!";

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		persistentUpdate = true;

		camMain = new FlxCamera();
		camText = new FlxCamera();
		camText.bgColor.alpha = 0;

		FlxG.cameras.reset(camMain);
		FlxG.cameras.add(camText, false);
		FlxG.cameras.setDefaultDrawTarget(camMain, true);

		TitleState.setDefaultRGB();
		var titleBg:DDLCBorderBG;
		titleBg = new DDLCBorderBG(Paths.image('mainmenu/rgbBg'), -40, -40);
		titleBg.scrollFactor.set();
		add(titleBg);

		var menuTxt:FlxText = new FlxText(5, 10, 0, "Credits", 32);
		menuTxt.setFormat(Paths.font("dokiUI.ttf"), 40, FlxColor.WHITE, FlxTextAlign.RIGHT);
		menuTxt.setBorderStyle(OUTLINE, 0xFFBB5599, 6);
		menuTxt.scrollFactor.set();
		add(menuTxt);

		gridTitle = new FlxText(5, 15, FlxG.width, "", 32);
		gridTitle.setFormat(Paths.font("dokiUI.ttf"), 40, FlxColor.WHITE, FlxTextAlign.CENTER);
		gridTitle.setBorderStyle(OUTLINE, 0xFFBB5599, 6);
		gridTitle.scrollFactor.set();
		add(gridTitle);

		specialThanks = new FlxText(5, 115, FlxG.width, thanksList, 26);
		specialThanks.setFormat(Paths.font("doki.ttf"), 26, 0xFF000000, CENTER);
		specialThanks.scrollFactor.set();
		specialThanks.visible = false;
		add(specialThanks);

		if (SaveData.clearAllNormal && SaveData.clearAllClassic && SaveData.clearAllBonus)
		{
			gridsList = ['Team DS Members', 'Classic Songs Composers', 'Soundfonts & Chromatics', 'Special Thanks P1', 'Special Thanks P2'];
		}
		
		grpOptions = new FlxTypedGroup<MemberCard>();
		add(grpOptions);

		reloadCards();

		black = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		black.alpha = 0.4;

		var bottomTextBG:FlxSprite = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
		bottomTextBG.alpha = 0.6;
		bottomTextBG.cameras = [camText];
		add(bottomTextBG);

		var leText:String = "Click on a card to view it more closely. Press Left or Right to change categories.";
		var size:Int = 16;
		bottomText = new FlxText(bottomTextBG.x, bottomTextBG.y + 4, FlxG.width, leText, size);
		bottomText.setFormat(Paths.font("vcr.ttf"), size, FlxColor.WHITE, CENTER);
		bottomText.scrollFactor.set();
		bottomText.cameras = [camText];
		add(bottomText);

		super.create();
	}

	var quitting:Bool = false;
	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		if(!quitting)
		{
			if (controls.BACK)
			{
				if (!selectedSomethin) {
					FlxG.sound.play(Paths.sound('cancelMenu'));
					openSubState(new CustomFadeTransition(0.6, false, new ExtraStuffState()));
					quitting = true;
				}
				else {
					goBack();
				}
			}

			if (controls.UI_LEFT_P){
				reloadCards(-1);
			}
			if (controls.UI_RIGHT_P){
				reloadCards(1);
			}

			if (!selectedSomethin)
			{
				grpOptions.forEach(function(spr:MemberCard)
				{
					if (FlxG.mouse.overlaps(spr)){
						if (curSelected != spr.ID){
							curSelected = spr.ID;
							changeSelection();
						}
						else {
							if (FlxG.mouse.justPressed){
								selectedSomethin = true;
								cardZoom(creditsStuff[curSelected]);
								FlxG.sound.play(Paths.sound('confirmMenu'), 0.6);
							}
						}
					}
				});
			}
			else {
				if (!FlxG.mouse.overlaps(cardCloseup) && FlxG.mouse.justPressed) {
					goBack();
				}
			}
		}
		super.update(elapsed);
	}

	var moveTween:FlxTween = null;
	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);
		curSelected += change;
		if (curSelected < 0)
			curSelected = grpOptions.length - 1;
		if (curSelected >= grpOptions.length)
			curSelected = 0;

		for (item in grpOptions.members)
		{
			item.alpha = 0.6;
			if (item.ID == curSelected) {
				item.alpha = 1;
			}
		}
	}

	function reloadCards(change:Int = 0)
	{
		curGrid += change;
		if (curGrid < 0)
			curGrid = 0;
		if (curGrid >= gridsList.length)
			curGrid = gridsList.length - 1;

		if (curGrid == 0) gridTitle.text = gridsList[curGrid] + ' >';
		else if (curGrid == gridsList.length - 1) gridTitle.text = '< ' + gridsList[curGrid];
		else if (gridsList.length == 0) gridTitle.text = gridsList[curGrid];
		else gridTitle.text = '< ' + gridsList[curGrid] + ' >';

		grpOptions.clear();
		switch (curGrid)
		{
			case 0: creditsStuff = teamds;
			case 1: creditsStuff = classics;
			case 2: creditsStuff = sf2chroms;
			case 3: creditsStuff = spthx;
			case 4: creditsStuff = blk;
		}

		if (curGrid == 4) specialThanks.visible = true;
		else specialThanks.visible = false;
	
		for (i in 0...creditsStuff.length)
		{
			var card:MemberCard = new MemberCard(false, creditsStuff[i][0], creditsStuff[i][1], creditsStuff[i][2], creditsStuff[i][3], creditsStuff[i][4], creditsStuff[i][5], creditsStuff[i][6], creditsStuff[i][7], creditsStuff[i][8]);
			card.y = (Math.floor(grpOptions.members.length / MAX_PER_ROW) * 180) + 85;
			card.screenCenter(X);
			card.x += 230 * ((grpOptions.members.length % MAX_PER_ROW) - MAX_PER_ROW/2) + card.width / 2 + 15;
			card.ID = grpOptions.members.length;
			card.antialiasing = ClientPrefs.globalAntialiasing;
			grpOptions.add(card);
		}
		changeSelection();
	}

	function cardZoom(data:Array<String>)
	{
		bottomText.text = "Click on the blue-colored text to open the social link in a web browser. Press ESCAPE or click away from the card to go back.";
		add(black);
		cardCloseup = new MemberCard(true, data[0], data[1], data[2], data[3], data[4], data[5], data[6], data[7], data[8]);
		cardCloseup.screenCenter();
		cardCloseup.antialiasing = ClientPrefs.globalAntialiasing;
		add(cardCloseup);
	}

	function goBack()
	{
		bottomText.text = "Click on a card to view it more closely. Press Left or Right to change categories.";
		FlxG.sound.play(Paths.sound('cancelMenu'));
		remove(cardCloseup);
		remove(black);
		selectedSomethin = false;
	}
}