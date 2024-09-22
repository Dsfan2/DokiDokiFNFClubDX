package objects;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;
import flixel.FlxG;
import tjson.TJSON as Json;

typedef SongBlurbData =
{
	var displayName:String;
    var mainComposer:String;
    var composerList:Array<String>;
    var charterList:Array<String>;
    var artistList:Array<String>;
    var specialThanks:Array<String>;
}

class CoolSongBlurb extends FlxSpriteGroup
{
    public var songName:String = '';
    public var composerName:String = '';
    public var composerList:Array<String> = [];
    public var charterList:Array<String> = [];
    public var artistList:Array<String> = [];
    public var specialThanks:Array<String> = [];
    
    public var box:FlxSprite;
    public var dataName:FlxText;
    public var compTxt:FlxText;
    public var dataComp:FlxText;
    public var chartTxt:FlxText;
    public var dataChart:FlxText;
    public var artTxt:FlxText;
    public var dataArt:FlxText;
    public var thxTxt:FlxText;
    public var dataThx:FlxText;

    public var blurbData:SongBlurbData;

    public function new(name:String, isDokiDoki:Bool = false, buffnwild:Bool = false)
    {
        super();

        var file:String = 'Composer';
        if (isDokiDoki) file = 'Composer-doki';
		else
		{
			if (buffnwild) file = 'Composer-wild';
			else
			{
				if (name == 'Welcome To The Club')
				{
					switch (ClientPrefs.playerChar)
					{
						case 1: file = 'Composer-bf';
						case 2: file = 'Composer-jr';
						case 3: file = 'Composer-moni';
					}
				}
			}
		}
        blurbData = parseJSON(Paths.blurbJSON(Paths.formatToSongPath(name) + '/' + file));

        songName = blurbData.displayName;
        composerName = blurbData.mainComposer;
        composerList = blurbData.composerList;
        charterList = blurbData.charterList;
        artistList = blurbData.artistList;
        specialThanks = blurbData.specialThanks;

        box = new FlxSprite(10, 0).loadGraphic(Paths.image('songThing'));
        box.setGraphicSize(Std.int(box.width * 1));
        box.updateHitbox();
        box.scrollFactor.set();
        box.alpha = 0;
        add(box);

        // Set up song name
        dataName = new FlxText(18, 5, FlxG.width, "", 23);
		dataName.setFormat(Paths.font('dokiUI.ttf'), 23, FlxColor.WHITE, LEFT);
		dataName.setBorderStyle(OUTLINE, 0xFFBB5599, 4);
        dataName.text = songName;
        dataName.updateHitbox();
        dataName.scrollFactor.set();
        dataName.alpha = 0;

        compTxt = new FlxText(18, 40, FlxG.width, "", 18);
		compTxt.setFormat(Paths.font('dokiUI.ttf'), 18, FlxColor.WHITE, LEFT);
		compTxt.setBorderStyle(OUTLINE, 0xFFBB5599, 4);
        compTxt.updateHitbox();
        compTxt.scrollFactor.set();
        compTxt.alpha = 0;
        if (composerList.length > 1) compTxt.text = "Composers:";
        else compTxt.text = "Composer:";

        // Set up artist(s)
        //dataComp = new FlxText(50, 60, FlxG.width, "", 12);
        dataComp = new FlxText(125, 43, FlxG.width, "", 14);
        dataComp.setFormat(Paths.font('doki.ttf'), 14, FlxColor.WHITE, LEFT);
		dataComp.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.4);
        var num:Int = composerList.length;
        for (i in composerList) 
        {
            num--;
            if (num <= 0) dataComp.text += i;
            else dataComp.text += i + ', ';
        }
        dataComp.updateHitbox();
        dataComp.scrollFactor.set();
        dataComp.alpha = 0;

        //chartTxt = new FlxText(18, 80, FlxG.width, "", 18);
        chartTxt = new FlxText(18, 70, FlxG.width, "", 18);
		chartTxt.setFormat(Paths.font('dokiUI.ttf'), 18, FlxColor.WHITE, LEFT);
		chartTxt.setBorderStyle(OUTLINE, 0xFFBB5599, 4);
        chartTxt.updateHitbox();
        chartTxt.scrollFactor.set();
        chartTxt.alpha = 0;
        if (charterList.length > 1) chartTxt.text = "Charters:";
        else chartTxt.text = "Charter:";

        //dataChart = new FlxText(50, 105, FlxG.width, "", 12);
        dataChart = new FlxText(110, 73, FlxG.width, "", 14);
        dataChart.setFormat(Paths.font('doki.ttf'), 14, FlxColor.WHITE, LEFT);
		dataChart.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.4);
        var num:Int = charterList.length;
        for (i in charterList) 
        {
            num--;
            if (num <= 0) dataChart.text += i;
            else dataChart.text += i + ', ';
        }
        dataChart.updateHitbox();
        dataChart.scrollFactor.set();
        dataChart.alpha = 0;

        artTxt = new FlxText(18, 100, FlxG.width, "Artists:", 18);
		artTxt.setFormat(Paths.font('dokiUI.ttf'), 18, FlxColor.WHITE, LEFT);
		artTxt.setBorderStyle(OUTLINE, 0xFFBB5599, 4);
        artTxt.updateHitbox();
        artTxt.scrollFactor.set();
        artTxt.alpha = 0;
        //if (artistList.length > 1) artTxt.text = "Artists:";
        //else artTxt.text = "Artist:";

        dataArt = new FlxText(103, 103, FlxG.width, "", 14);
        dataArt.setFormat(Paths.font('doki.ttf'), 14, FlxColor.WHITE, LEFT);
		dataArt.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.4);
        var num:Int = artistList.length;
        for (i in artistList) 
        {
            num--;
            if (num <= 0) dataArt.text += i;
            else dataArt.text += i + ', ';
        }
        dataArt.updateHitbox();
        dataArt.scrollFactor.set();
        dataArt.alpha = 0;

        //thxTxt = new FlxText(18, 125, FlxG.width, "", 18);
        thxTxt = new FlxText(18, 130, FlxG.width, "", 18);
		thxTxt.setFormat(Paths.font('dokiUI.ttf'), 18, FlxColor.WHITE, LEFT);
		thxTxt.setBorderStyle(OUTLINE, 0xFFBB5599, 4);
        thxTxt.updateHitbox();
        thxTxt.scrollFactor.set();
        thxTxt.alpha = 0;
        thxTxt.text = "Special Thanks:";

        //dataThx = new FlxText(50, 150, FlxG.width, "", 12);
        dataThx = new FlxText(165, 133, FlxG.width, "", 14);
        dataThx.setFormat(Paths.font('doki.ttf'), 14, FlxColor.WHITE, LEFT);
		dataThx.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.4);
        var num:Int = specialThanks.length;
        for (i in specialThanks) 
        {
            num--;
            if (num <= 0) dataThx.text += i;
            else dataThx.text += i + ', ';
        }
        dataThx.updateHitbox();
        dataThx.scrollFactor.set();
        dataThx.alpha = 0;
        
        // Finally, add them into this sprite group
        add(dataName);
        add(compTxt);
        add(chartTxt);
        add(artTxt);
        add(dataComp);
        add(dataChart);
        add(dataArt);
        if (specialThanks.length > 0 && specialThanks[0] != '')
        {
            add(thxTxt);
            add(dataThx);
        }
        
    }

    public function tweenIn()
    {
        FlxTween.tween(box, {alpha: 0.8, y: 40}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(dataName, {alpha: 1, y: dataName.y + 40}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
        FlxTween.tween(compTxt, {alpha: 1, y: compTxt.y + 40}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
        FlxTween.tween(chartTxt, {alpha: 1, y: chartTxt.y + 40}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
        FlxTween.tween(artTxt, {alpha: 1, y: artTxt.y + 40}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
        FlxTween.tween(thxTxt, {alpha: 1, y: thxTxt.y + 40}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(dataComp, {y: dataComp.y + 40}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
        FlxTween.tween(dataComp, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.4});
        FlxTween.tween(dataChart, {y: dataChart.y + 40}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
        FlxTween.tween(dataChart, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.4});
        FlxTween.tween(dataArt, {y: dataArt.y + 40}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
        FlxTween.tween(dataArt, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.4});
        FlxTween.tween(dataThx, {y: dataThx.y + 40}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
        FlxTween.tween(dataThx, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.4});
    }

    public function tweenOut()
    {
        FlxTween.tween(box, {alpha: 0, y: 0}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(dataName, {alpha: 0, y: dataName.y - 40}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
        FlxTween.tween(compTxt, {alpha: 0, y: compTxt.y - 40}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
        FlxTween.tween(chartTxt, {alpha: 0, y: chartTxt.y - 40}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
        FlxTween.tween(artTxt, {alpha: 0, y: artTxt.y - 40}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
        FlxTween.tween(thxTxt, {alpha: 0, y: thxTxt.y - 40}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(dataComp, {alpha: 0, y: dataComp.y - 40}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
        FlxTween.tween(dataChart, {alpha: 0, y: dataChart.y - 40}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
        FlxTween.tween(dataArt, {alpha: 0, y: dataArt.y - 40}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
        FlxTween.tween(dataThx, {alpha: 0, y: dataThx.y - 40}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
    }

    public static function parseJSON(path:String):SongBlurbData {
		return cast Json.parse(Assets.getText(path));
	}

    public static function getMainComposer(name:String):String {
        var file:String = 'Composer';
        if (name == 'Welcome To The Club')
		{
			switch (ClientPrefs.playerChar)
			{
				case 1: file = 'Composer-bf';
				case 2: file = 'Composer-jr';
				case 3: file = 'Composer-moni';
			}
		}
        var dat:SongBlurbData = parseJSON(Paths.blurbJSON(Paths.formatToSongPath(name) + '/' + file));
        return dat.mainComposer;
    }
}