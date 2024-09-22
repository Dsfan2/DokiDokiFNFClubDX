package backend;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.math.FlxMath;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.text.FlxText;

import haxe.Json;
import haxe.format.JsonParser;

typedef Achievement =
{
	var name:String;
	var description:String;
	var doki:Bool;
	@:optional var hidden:Bool;
	@:optional var secret:Bool;
	@:optional var maxScore:Float;
	@:optional var maxDecimals:Int;
	//handled automatically, ignore this one
	@:optional var ID:Int; 
}

class Achievements {
	public static function init()
	{
		createAchievement('friday_night_play',		{name: "Gettin' Doki", 			    description: "Play on a Friday Night. Duh", 										doki: false, secret: true});
		createAchievement('classic_menu',			{name: "Nostalgic Poem", 		    description: "Get the Classic Menu Easter Egg", 									doki: false, secret: true});
		createAchievement('ghost_menu',				{name: "Creepy...", 		   	    description: "Get the Ghost Menu Easter Egg",										doki: false, secret: true});
		createAchievement('monker_appear',			{name: "She Appears", 		   	    description: "Get the Monker Easter Egg", 											doki: false, secret: true});
		createAchievement("first_clear",			{name: "New Member",			    description: "Clear Story Mode Once", 												doki: false});
		createAchievement("bfRoute_clear",			{name: "Tight Bars Little Man",	    description: "Clear The REGULAR Boyfriend Route", 									doki: false});
		createAchievement("jrRoute_clear",			{name: "Top-Notch Graffiti Artist", description: "Clear The REGULAR Bowser Jr Route", 									doki: false});
		createAchievement("moniRoute_clear",		{name: "Friendship & Literature",   description: "Clear The REGULAR Monika Route", 										doki: false});
		createAchievement("S_nomiss",				{name: "Bundle of Sunshine",	    description: "Clear REGULAR Sayori's Stage with 0 misses", 							doki: false});
		createAchievement("N_nomiss",				{name: "Cute on the Outside",	    description: "Clear REGULAR Natsuki's Stage with 0 misses", 						doki: false});
		createAchievement("Y_nomiss",				{name: "Maiden of Mystery",		    description: "Clear REGULAR Yuri's Stage with 0 misses", 							doki: false,});
		createAchievement("M_nomiss",				{name: "President of the Club",	    description: "Clear REGULAR Monika's Stage with 0 misses", 							doki: false,});
		createAchievement("Sx_nomiss",				{name: "Insxde My Head",		    description: "Clear REGULAR Sxyori's Stage with 0 misses", 							doki: false, hidden: true});
		createAchievement("G_nomiss",				{name: "I'm Gonna Tell Everyone",   description: "Clear REGULAR Glitchsuki's Stage with 0 misses", 						doki: false, hidden: true});
		createAchievement("Yd_nomiss",				{name: "My Heart Pounds",		    description: "Clear REGULAR Yurdere's Stage with 0 misses", 						doki: false, hidden: true});
		createAchievement("JM_nomiss",				{name: "I Love You",			    description: "Clear REGULAR Just Monika's Stage with 0 misses", 					doki: false, hidden: true});
		createAchievement("se_combo",				{name: "System Check Finished",	    description: "Get a max combo of 250 or more in Script Error REGULAR",				doki: false, hidden: true});
		createAchievement("sf_bad",					{name: "A Bad Ending",				description: "Clear System Failure REGULAR with more than 70 misses", 				doki: false, secret: true});
		createAchievement("sf_alt",					{name: "An Alternate Ending",		description: "Clear System Failure REGULAR as Boyfriend or Bowser Jr", 				doki: false, secret: true});
		createAchievement("sf_double",				{name: "She Came to her Senses",	description: "Clear the Final Stage of the REGULAR Monika Route Twice", 			doki: false, hidden: true});
		createAchievement("normal_clear",			{name: "Best of the Club!",			description: "Clear all 3 REGULAR routes", 											doki: false, hidden: true});
		createAchievement("heartz_clear",			{name: "It's Just an Illusion...",	description: "Clear Candy Heartz REGULAR with 90% accuracy or higher", 				doki: false, hidden: true});
		createAchievement("glitcher_clear",			{name: "Wow...Just Wow",			description: "Clear Ultimate Glitcher REGULAR with Instakill Hurt Notes", 			doki: false, hidden: true});
		createAchievement("tfb_clear",				{name: "Sayori Will Never Be Real",	description: "Clear The Final Battle REGULAR with Instakill Hurt Notes", 			doki: false, hidden: true});
		createAchievement("classic_clear",			{name: "All The Old Classics",		description: "Clear every REGULAR Classic Song in the mod", 						doki: false, secret: true});
		createAchievement("supernatural_nomiss",	{name: "Paranormal Conflict",		description: "Clear Supernatural REGULAR with no misses", 							doki: false, hidden: true});
		createAchievement("spiders_combo",			{name: "They Call Me Amy",			description: "Get a max combo of 300 or more in Spiders Of Markov REGULAR", 		doki: false, hidden: true});
		createAchievement("showoff_clear",			{name: "Show-Off",					description: "Dodge 50 times in Roar Of Natsuki REGULAR and win", 					doki: false, hidden: true});
		createAchievement("crossover_clear",		{name: "An Unexpected Crossover",	description: "Clear Crossover Clash Normal Mode with a rank of S or higher", 		doki: false, hidden: true});
		createAchievement("festival_clear",			{name: "A Triple Trouble",			description: "Clear Festival Deluxe with less than 20 misses", 						doki: false, hidden: true});
		createAchievement("bonus_clear",			{name: "Bonus Round Clear",			description: "Clear every Bonus Song in the mod", 									doki: false, secret: true});
		createAchievement("all_clear",				{name: "Breakthrough!",				description: "Clear all 60 main songs in the mod",									doki: false, secret: true});
		createAchievement("all_poems",				{name: "Poem Collector",			description: "Unlock all 11 Special Poems", 										doki: false, secret: true});
		createAchievement("all_secrets",			{name: "Code Breaker",				description: "Unlock all secrets from the Save File menu", 							doki: false, secret: true});
		createAchievement("secret_clear",			{name: "Sorry, No Hidden Dialogue",	description: "Clear Un-welcome To The Club as Monika with Freeplay Cutscenes on", 	doki: false, secret: true});
		createAchievement("nice_clear",				{name: "Nice ;)",					description: "Clear any song with 69% accuracy",									doki: false});

		// Template:
		//createAchievement("",	{name: "",	description: "", doki: false});

		//dont delete this thing below
		_originalLength = _sortID + 1;
	}

	public static var achievements:Map<String, Achievement> = new Map<String, Achievement>();
	public static var variables:Map<String, Float> = [];
	public static var unhiddenAchievements:Array<String> = [];
	public static var achievementsUnlocked:Array<String> = [];
	private static var _firstLoad:Bool = true;

	public static function get(name:String):Achievement
		return achievements.get(name);
	public static function exists(name:String):Bool
		return achievements.exists(name);

	public static function load():Void
	{
		if(!_firstLoad) return;

		if(_originalLength < 0) init();

		if(FlxG.save.data != null) {
			if(FlxG.save.data.achievementsUnlocked != null)
				achievementsUnlocked = FlxG.save.data.achievementsUnlocked;

			var savedMap:Map<String, Float> = cast FlxG.save.data.achievementsVariables;
			if(savedMap != null)
			{
				for (key => value in savedMap)
				{
					variables.set(key, value);
				}
			}
			_firstLoad = false;
		}
	}

	public static function save():Void
	{
		FlxG.save.data.achievementsUnlocked = achievementsUnlocked;
		FlxG.save.data.achievementsVariables = variables;
	}
	
	public static function getScore(name:String):Float
		return _scoreFunc(name, 0);

	public static function setScore(name:String, value:Float, saveIfNotUnlocked:Bool = true):Float
		return _scoreFunc(name, 1, value, saveIfNotUnlocked);

	public static function addScore(name:String, value:Float = 1, saveIfNotUnlocked:Bool = true):Float
		return _scoreFunc(name, 2, value, saveIfNotUnlocked);

	public static function unhideAchievement(?name:String = '')
	{
		if(achievements.exists(name) && name != '')
			unhiddenAchievements.push(name);
	}

	//mode 0 = get, 1 = set, 2 = add
	static function _scoreFunc(name:String, mode:Int = 0, addOrSet:Float = 1, saveIfNotUnlocked:Bool = true):Float
	{
		if(!variables.exists(name))
			variables.set(name, 0);

		if(achievements.exists(name))
		{
			var achievement:Achievement = achievements.get(name);
			if(achievement.maxScore < 1) throw 'Achievement has score disabled or is incorrectly configured: $name';

			if(achievementsUnlocked.contains(name)) return achievement.maxScore;

			var val = addOrSet;
			switch(mode)
			{
				case 0: return variables.get(name); //get
				case 2: val += variables.get(name); //add
			}

			if(val >= achievement.maxScore)
			{
				unlock(name);
				val = achievement.maxScore;
			}
			variables.set(name, val);

			Achievements.save();
			if(saveIfNotUnlocked || val >= achievement.maxScore) FlxG.save.flush();
			return val;
		}
		return -1;
	}

	static var _lastUnlock:Int = -999;
	public static function unlock(name:String, autoStartPopup:Bool = true):String {
		if(!achievements.exists(name))
		{
			FlxG.log.error('Achievement "$name" does not exists!');
			throw 'Achievement "$name" does not exists!';
			return null;
		}

		if(Achievements.isUnlocked(name)) return null;

		trace('Completed achievement "$name"');
		achievementsUnlocked.push(name);

		// earrape prevention
		var time:Int = openfl.Lib.getTimer();
		if(Math.abs(time - _lastUnlock) >= 100) //If last unlocked happened in less than 100 ms (0.1s) ago, then don't play sound
		{
			FlxG.sound.play(Paths.sound('achievementUnlocked'), 0.7); // Making the achievement get sound a seperate file so you can easily add your own
			_lastUnlock = time;
		}

		Achievements.save();
		FlxG.save.flush();

		if(autoStartPopup) startPopup(name);
		return name;
	}

	inline public static function isUnlocked(name:String)
		return achievementsUnlocked.contains(name);

	@:allow(objects.AchievementPopup)
	private static var _popups:Array<AchievementPopup> = [];

	public static var showingPopups(get, never):Bool;
	public static function get_showingPopups()
		return _popups.length > 0;

	public static function startPopup(achieve:String, endFunc:Void->Void = null) {
		for (popup in _popups)
		{
			if(popup == null) continue;
			popup.intendedY += 150;
		}

		var newPop:AchievementPopup = new AchievementPopup(achieve, endFunc);
		_popups.push(newPop);
	}

	// Map sorting cuz haxe is physically incapable of doing that by itself
	static var _sortID = 0;
	static var _originalLength = -1;
	public static function createAchievement(name:String, data:Achievement)
	{
		data.ID = _sortID;
		achievements.set(name, data);
		_sortID++;
	}

	public static function resetAchievements()
	{
		var listToDelete:Array<String> = 
		['S_nomiss', 'N_nomiss', 'Y_nomiss','M_nomiss', 'Sx_nomiss', 'G_nomiss', 'Yd_nomiss', 'JM_nomiss', 'se_combo',
		'sf_bad', 'sf_alt', 'heartz_clear', 'glitcher_clear', 'tfb_clear', 'supernatural_nomiss', 'spiders_combo',
		'showoff_clear','crossover-clear', 'festival-clear', 'nice_clear'];
		for (i in listToDelete)
		{
			variables.remove(i);
			achievementsUnlocked.remove(i);
		}
		save();
		FlxG.save.flush();
	}
}