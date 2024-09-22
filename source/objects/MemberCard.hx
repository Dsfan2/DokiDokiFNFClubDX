package objects;

class MemberCard extends FlxSpriteGroup
{
	public var card:FlxSprite;
	public var icon:FlxSprite;
	public var chibi:FlxSprite;
	public var stickers:FlxSprite;
	public var headerTxt:FlxText;
	public var nameTxt:FlxText;
	public var roleTxt:FlxText;
	public var linkTxt:FlxText;
	public var wordTxt:FlxText;

	public var redirectToHere:String;
	public var isSelected:Bool = false;
	public var linkHover:Bool = false;

	public var iconName:String = '';

	public function new(selectd:Bool = false, header:String = 'Literature Club Member Card', name:String = 'Monika', iconName:String = 'moni', role:String = 'Club President', social:String = 'Twitter', link:String = 'https://x.com/lilmonix3', favoriteWords:String = "Harmony, Visualize, Value", chibiIMG:String = 'moni', stickersIMG:String = 'ddlc')
	{
		super();
		isSelected = selectd;
		this.iconName = iconName;
		if (isSelected) {
			card = new FlxSprite(0, 0).loadGraphic(Paths.image('credits/card'));
			card.setGraphicSize(Std.int(card.width * 1.5));
			card.updateHitbox();
			add(card);

			nameTxt = new FlxText(42, 148, 0, name, 21);
			nameTxt.setFormat(Paths.font("Halogen.ttf"), 21, FlxColor.BLACK, LEFT);
			add(nameTxt);

			roleTxt = new FlxText(42, 202, 0, role, 21);
			roleTxt.setFormat(Paths.font("Halogen.ttf"), 21, FlxColor.BLACK, LEFT);
			add(roleTxt);

			linkTxt = new FlxText(42, 257, 0, social, 21);
			linkTxt.setFormat(Paths.font("Halogen.ttf"), 21, FlxColor.BLUE, LEFT);
			add(linkTxt);

			wordTxt = new FlxText(42, 310, 0, favoriteWords, 21);
			wordTxt.setFormat(Paths.font("Halogen.ttf"), 21, FlxColor.BLACK, LEFT);
			add(wordTxt);

			icon = new FlxSprite(431, 146).loadGraphic(Paths.image('credits/icons/' + iconName));
			icon.setGraphicSize(Std.int(icon.width * 1.5));
			icon.updateHitbox();
			add(icon);

			stickers = new FlxSprite(0, 0).loadGraphic(Paths.image('credits/stickers/' + stickersIMG));
			stickers.setGraphicSize(Std.int(stickers.width * 1.5));
			stickers.updateHitbox();
			add(stickers);

			chibi = new FlxSprite(367, 273).loadGraphic(Paths.image('credits/' + chibiIMG));
			chibi.setGraphicSize(Std.int(chibi.width * 1.5));
			chibi.updateHitbox();
			add(chibi);

			headerTxt = new FlxText(60, 35, 0, header, 36);
			headerTxt.setFormat(Paths.font('dokiUI.ttf'), 36, 0xFFEB3E91, LEFT);
			headerTxt.setBorderStyle(OUTLINE, 0xFFFFFFFF, 1.5);
			add(headerTxt);
		} else {
			card = new FlxSprite(0, 0).loadGraphic(Paths.image('credits/card'));
			card.setGraphicSize(Std.int(card.width * 0.5));
			card.updateHitbox();
			add(card);

			nameTxt = new FlxText(15, 49, 0, name, 7);
			nameTxt.setFormat(Paths.font("Halogen.ttf"), 7, FlxColor.BLACK, LEFT);
			add(nameTxt);

			roleTxt = new FlxText(15, 67, 0, role, 7);
			roleTxt.setFormat(Paths.font("Halogen.ttf"), 7, FlxColor.BLACK, LEFT);
			add(roleTxt);

			linkTxt = new FlxText(15, 85, 0, social, 7);
			linkTxt.setFormat(Paths.font("Halogen.ttf"), 7, FlxColor.BLUE, LEFT);
			add(linkTxt);

			wordTxt = new FlxText(15, 103, 0, favoriteWords, 7);
			wordTxt.setFormat(Paths.font("Halogen.ttf"), 7, FlxColor.BLACK, LEFT);
			add(wordTxt);

			icon = new FlxSprite(143, 48).loadGraphic(Paths.image('credits/icons/' + iconName));
			icon.setGraphicSize(Std.int(icon.width * 0.5));
			icon.updateHitbox();
			add(icon);

			stickers = new FlxSprite(0, 0).loadGraphic(Paths.image('credits/stickers/' + stickersIMG));
			stickers.setGraphicSize(Std.int(stickers.width * 0.5));
			stickers.updateHitbox();
			add(stickers);

			chibi = new FlxSprite(124, 92).loadGraphic(Paths.image('credits/' + chibiIMG));
			chibi.setGraphicSize(Std.int(chibi.width * 0.5));
			chibi.updateHitbox();
			add(chibi);

			headerTxt = new FlxText(20, 10, 0, header, 10);
			headerTxt.setFormat(Paths.font('dokiUI.ttf'), 10, 0xFFEB3E91, LEFT);
			headerTxt.setBorderStyle(OUTLINE, 0xFFFFFFFF, 1.25);
			add(headerTxt);
		}
		redirectToHere = link;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (isSelected) {
			if (FlxG.mouse.overlaps(linkTxt) && !linkHover){
				linkHover = true;
				linkTxt.setFormat(Paths.font("Halogen.ttf"), 21, FlxColor.CYAN, LEFT);
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);
			}
			else if (!FlxG.mouse.overlaps(linkTxt) && linkHover)
			{
				linkHover = false;
				linkTxt.setFormat(Paths.font("Halogen.ttf"), 21, FlxColor.BLUE, LEFT);
			}

			if (FlxG.mouse.overlaps(linkTxt) && FlxG.mouse.justPressed){
				CoolUtil.browserLoad(redirectToHere);
			}

			if (FlxG.mouse.overlaps(roleTxt) && FlxG.mouse.justPressed && iconName == 'cheeze') CoolUtil.makeSecretFile('LAST4CHEEZE', 'Free Code');
			if (FlxG.mouse.overlaps(icon) && FlxG.mouse.justPressed && iconName == 'or3o') CoolUtil.makeSecretFile('What do you think of, "XDDCC"?', 'Pick a name');
			if (FlxG.mouse.overlaps(nameTxt) && FlxG.mouse.justPressed && iconName == 'shark') CoolUtil.makeSecretFile('5hark was here xoxo', 'Dev Note 12-11-2023');
			if (FlxG.mouse.overlaps(wordTxt) && FlxG.mouse.justPressed && iconName == 'yaper') CoolUtil.makeSecretFile('Migrane', 'Another Free Code');
		}
	}
}