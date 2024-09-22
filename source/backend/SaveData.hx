package backend;

import openfl.Lib;
import flixel.FlxG;

class SaveData
{
	public static var warningAccept:Bool = false;
	public static var bfRoute:Int = 0;
	public static var jrRoute:Int = 0;
	public static var monikaRoute:Int = 0;
	public static var dokiBFRoute:Int = 0;
	public static var dokiJRRoute:Int = 0;
	public static var dokiMONIRoute:Int = 0;
	public static var actTwo:Bool = false;
	public static var actThree:Bool = false;
	public static var lockedRoute:String = 'None';
	public static var storyCleared:Bool = false;
	public static var bfRouteClear:Bool = false;
	public static var jrRouteClear:Bool = false;
	public static var monikaRouteClear:Bool = false;
	public static var dokiBFRouteClear:Bool = false;
	public static var dokiJRRouteClear:Bool = false;
	public static var dokiMONIRouteClear:Bool = false;
	public static var monikaRouteCrash:Bool = false;
	public static var firstPopup:Bool = false;
	public static var bfClearPopup:Bool = false;
	public static var jrClearPopup:Bool = false;
	public static var monikaClearPopup:Bool = false;
	public static var regularCleared:Array<String> = [];
	public static var dokidokiCleared:Array<String> = [];
	public static var clearAllNormal:Bool = false;
	public static var clearAllClassic:Bool = false;
	public static var clearAllBonus:Bool = false;
	public static var seenCompScreen:Bool = false;
	public static var seenGhost:Bool = false;
	public static var otherRoutesTxt:String = "None";
	public static var songsCleared:Int = 0;
	public static var normalSongs:Int = 0;
	public static var classicSongs:Int = 0;
	public static var bonusSongs:Int = 0;
	public static var sayoriDeaths:Int = 0;
	public static var unlockedSecrets:Array<String> = [];
	public static var unlockedPoems:Array<String> = [];

	public static function saveSwagData()
    {
		FlxG.save.data.warningAccept = warningAccept;
		FlxG.save.data.bfRoute = bfRoute;
		FlxG.save.data.jrRoute = jrRoute;
		FlxG.save.data.monikaRoute = monikaRoute;
		FlxG.save.data.dokiBFRoute = dokiBFRoute;
		FlxG.save.data.dokiJRRoute = dokiJRRoute;
		FlxG.save.data.dokiMONIRoute = dokiMONIRoute;
		FlxG.save.data.actTwo = actTwo;
		FlxG.save.data.actThree = actThree;
		FlxG.save.data.lockedRoute = lockedRoute;
		FlxG.save.data.storyCleared = storyCleared;
		FlxG.save.data.bfRouteClear = bfRouteClear;
		FlxG.save.data.jrRouteClear = jrRouteClear;
		FlxG.save.data.monikaRouteClear = monikaRouteClear;
		FlxG.save.data.dokiBFRouteClear = dokiBFRouteClear;
		FlxG.save.data.dokiJRRouteClear = dokiJRRouteClear;
		FlxG.save.data.dokiMONIRouteClear = dokiMONIRouteClear;
		FlxG.save.data.monikaRouteCrash = monikaRouteCrash;
		FlxG.save.data.regularCleared = regularCleared;
		FlxG.save.data.dokidokiCleared = dokidokiCleared;
		FlxG.save.data.clearAllNormal = clearAllNormal;
		FlxG.save.data.clearAllClassic = clearAllClassic;
		FlxG.save.data.clearAllBonus = clearAllBonus;
		FlxG.save.data.seenCompScreen = seenCompScreen;
		FlxG.save.data.seenGhost = seenGhost;
		FlxG.save.data.otherRoutesTxt = otherRoutesTxt;
		FlxG.save.data.songsCleared = songsCleared;
		FlxG.save.data.normalSongs = normalSongs;
		FlxG.save.data.classicSongs = classicSongs;
		FlxG.save.data.bonusSongs = bonusSongs;
		FlxG.save.data.sayoriDeaths = sayoriDeaths;
		FlxG.save.data.unlockedSecrets = unlockedSecrets;
		FlxG.save.data.unlockedPoems = unlockedPoems;

		FlxG.save.flush();
	}

	public static function loadSaveData()
	{
		if (FlxG.save.data.warningAccept != null) warningAccept = FlxG.save.data.warningAccept;
		if (FlxG.save.data.bfRoute != null) bfRoute = FlxG.save.data.bfRoute;
		if (FlxG.save.data.jrRoute != null) jrRoute = FlxG.save.data.jrRoute;
		if (FlxG.save.data.monikaRoute != null) monikaRoute = FlxG.save.data.monikaRoute;
		if (FlxG.save.data.dokiBFRoute != null) dokiBFRoute = FlxG.save.data.dokiBFRoute;
		if (FlxG.save.data.dokiJRRoute != null) dokiJRRoute = FlxG.save.data.dokiJRRoute;
		if (FlxG.save.data.dokiMONIRoute != null) dokiMONIRoute = FlxG.save.data.dokiMONIRoute;
		if (FlxG.save.data.actTwo != null) actTwo = FlxG.save.data.actTwo;
		if (FlxG.save.data.actThree != null) actThree = FlxG.save.data.actThree;
		if (FlxG.save.data.lockedRoute != null) lockedRoute = FlxG.save.data.lockedRoute;
		if (FlxG.save.data.storyCleared != null) storyCleared = FlxG.save.data.storyCleared;
		if (FlxG.save.data.bfRouteClear != null) bfRouteClear = FlxG.save.data.bfRouteClear;
		if (FlxG.save.data.jrRouteClear != null) jrRouteClear = FlxG.save.data.jrRouteClear;
		if (FlxG.save.data.monikaRouteClear != null) monikaRouteClear = FlxG.save.data.monikaRouteClear;
		if (FlxG.save.data.dokiBFRouteClear != null) dokiBFRouteClear = FlxG.save.data.dokiBFRouteClear;
		if (FlxG.save.data.dokiJRRouteClear != null) dokiJRRouteClear = FlxG.save.data.dokiJRRouteClear;
		if (FlxG.save.data.dokiMONIRouteClear != null) dokiMONIRouteClear = FlxG.save.data.dokiMONIRouteClear;
		if (FlxG.save.data.monikaRouteCrash != null) monikaRouteCrash = FlxG.save.data.monikaRouteCrash;
		if (FlxG.save.data.regularCleared != null) regularCleared = FlxG.save.data.regularCleared;
		if (FlxG.save.data.dokidokiCleared != null) dokidokiCleared = FlxG.save.data.dokidokiCleared;
		if (FlxG.save.data.clearAllNormal != null) clearAllNormal = FlxG.save.data.clearAllNormal;
		if (FlxG.save.data.clearAllClassic != null) clearAllClassic = FlxG.save.data.clearAllClassic;
		if (FlxG.save.data.clearAllBonus != null) clearAllBonus = FlxG.save.data.clearAllBonus;
		if (FlxG.save.data.seenCompScreen != null) seenCompScreen = FlxG.save.data.seenCompScreen;
		if (FlxG.save.data.seenGhost != null) seenGhost = FlxG.save.data.seenGhost;
		if (FlxG.save.data.otherRoutesTxt != null) otherRoutesTxt = FlxG.save.data.otherRoutesTxt;
		if (FlxG.save.data.songsCleared != null) songsCleared = FlxG.save.data.songsCleared;
		if (FlxG.save.data.normalSongs != null) normalSongs = FlxG.save.data.normalSongs;	
		if (FlxG.save.data.classicSongs != null) classicSongs = FlxG.save.data.classicSongs;
		if (FlxG.save.data.bonusSongs != null) bonusSongs = FlxG.save.data.bonusSongs;
		if (FlxG.save.data.sayoriDeaths != null) sayoriDeaths = FlxG.save.data.sayoriDeaths;
		if (FlxG.save.data.unlockedSecrets != null) unlockedSecrets = FlxG.save.data.unlockedSecrets;
		if (FlxG.save.data.unlockedPoems != null) unlockedPoems = FlxG.save.data.unlockedPoems;
	}

	public static function deleteREGULARStoryData()
	{
		bfRoute = 0;
		jrRoute = 0;
		monikaRoute = 0;
		bfRouteClear = false;
		jrRouteClear = false;
		monikaRouteClear = false;
		actTwo = false;
		actThree = false;
		lockedRoute = 'None';
		saveSwagData();
	}

	public static function deleteDOKIDOKIStoryData()
	{
		dokiBFRoute = 0;
		dokiJRRoute = 0;
		dokiMONIRoute = 0;
		dokiBFRouteClear = false;
		dokiJRRouteClear = false;
		dokiMONIRouteClear = false;
		actTwo = false;
		actThree = false;
		lockedRoute = 'None';
		saveSwagData();
	}

	public static function deleteSystem32()
	{
		FlxG.save.erase();
		#if !html5
		Sys.exit(0);
		#else
		FlxG.switchState(new CrashState());
		#end
	}

	public static function cheatTheSystem()
	{
		warningAccept = true;
		bfRoute = 10;
		jrRoute = 10;
		monikaRoute = 6;
		//dokiBFRoute = 10;
		//dokiJRRoute = 10;
		//dokiMONIRoute = 6;
		actTwo = false;
		actThree = false;
		lockedRoute = 'None';
		storyCleared = true;
		bfRouteClear = true;
		jrRouteClear = true;
		monikaRouteClear = true;
		//dokiBFRouteClear = true;
		//dokiJRRouteClear = true;
		//dokiMONIRouteClear = true;
		monikaRouteCrash = false;
		regularCleared = CoolUtil.songsList;
		//dokidokiCleared = CoolUtil.songsList;
		clearAllNormal = true;
		clearAllClassic = true;
		clearAllBonus = true;
		seenCompScreen = true;
		seenGhost = false;
		otherRoutesTxt = 'Others';
		songsCleared = 60;
		normalSongs = 33;
		classicSongs = 17;
		bonusSongs = 10;
		sayoriDeaths = 1;
		saveSwagData();
		if (FlxG.save.data.yourVoice == null) ClientPrefs.yourVoice = 'Masculine';
		ClientPrefs.saveSettings();
	}
}