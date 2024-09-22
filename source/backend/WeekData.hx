package backend;

import lime.utils.Assets;
import openfl.utils.Assets as OpenFlAssets;
import haxe.Json;
import haxe.format.JsonParser;
import sys.io.File;

class WeekData {
	public static var weekID:String;

	// Week Name - Week ID - List Of Songs
	public static var boyfriendRouteList:Array<Dynamic> = [
		["Boyfriend's Solo",	"Start BF", 		['Welcome To The Club']],
		["Sayori", 				"Sayori BF", 		["Daydream", "Happy Thoughts"]],
		["Natsuki",				"Natsuki BF", 		["Manga", "Tsundere"]],
		["Yuri",				"Yuri BF", 			["Novelty", "Shy"]],
		["Monika",				"Monika BF", 		["Poetry", "Writing Tip", "Last Dual"]],
		["Boyfriend's Zolo",	"Midway BF", 		["Un-welcome To The Club"]],
		["Sxyori",				"Sxyori BF", 		["Depression", "Hxppy Thxughts"]],
		["Glitchsuki",			"Glitchsuki BF",	["Malnourished", "Glitch"]],
		["Yurdere",				"Yurdere BF", 		["Yandere", "Obsessed"]],
		["Just Monika",			"Final BF", 		["Lines Of Code", "Self-Aware", "Script Error"]]
	];
	public static var bowserJrRouteList:Array<Dynamic> = [
		["Bowser Jr's Solo",	"Start JR", 		['Welcome To The Club']],
		["Sayori", 				"Sayori JR", 		["Daydream", "Cinnamon Bun"]],
		["Natsuki",				"Natsuki JR", 		["Anime", "Tsundere"]],
		["Yuri",				"Yuri JR", 			["Novelty", "Cup Of Tea"]],
		["Monika",				"Monika JR", 		["Poetry", "I Advise", "Last Dual"]],
		["Bowser Jr's Zolo",	"Midway JR", 		["Un-welcome To The Club"]],
		["Sxyori",				"Sxyori JR", 		["Depression", "Cxnnamon Bxn"]],
		["Glitchsuki",			"Glitchsuki JR",	["Pale", "Glitch"]],
		["Yurdere",				"Yurdere JR", 		["Yandere", "Psychopath"]],
		["Just Monika",			"Final JR", 		["Lines Of Code", "Elevated Access", "Script Error"]]
	];
	public static var monikaRouteList:Array<Dynamic> = [
		["Monika's Solo",			"Start MONI", 		['Welcome To The Club']],
		["Sayori", 					"Sayori MONI", 		["Daydream", "Happy Thoughts", "Trust"]],
		["Natsuki",					"Natsuki MONI", 	["Manga", "Anime", "Respect"]],
		["Yuri",					"Yuri MONI", 		["Novelty", "Cup Of Tea", "Reflection"]],
		["Boyfriend & Bowser Jr",	"Others Moni", 		["Writing Tip", "I Advise"]],
		["Just Monika",				"Final MONI", 		["Revelation", "Self-Aware", "Elevated Access", "Script Error", "System Failure"]]
	];
}