package states;

import flixel.FlxG;
import flixel.FlxSprite;

import openfl.events.UncaughtErrorEvent;
import haxe.CallStack;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;
import lime.app.Application;

class CrashState extends MusicBeatState
{
    override public function create()
    {
        if (PlayState.crashType == 'Bowser Jr')
        {
            #if !html5
            var errMsg:String = "";
            var errMsg2:String = "";
    		var path:String;
		    var dateNow:String = Date.now().toString();

	    	dateNow = StringTools.replace(dateNow, " ", "_");
    		dateNow = StringTools.replace(dateNow, ":", "'");

		    path = "./crash/" + "DDFNFCDX_" + dateNow + ".txt";

            if (ClientPrefs.playerChar == 1)
            {
		        errMsg += "Uncaught Error: [line.utils.Assets] ERROR: Cannot find 'bowserjr.chr'. File is missing or corrupted\nPlease report this error to the GitHub page: https://github.com/Dsfan2/DokiDokiFNFClubDX \n\n> Crash Handler written by: sqirra-rng";
                errMsg2 += "Uncaught Error: [line.utils.Assets] ERROR: Cannot find 'bowserjr.chr'. File is missing or corrupted\nOkay... you got this... very carefully... don't screw this up this time...\nPlease report this error to the GitHub page: https://github.com/Dsfan2/DokiDokiFNFClubDX \n\n> Crash Handler written by: sqirra-rng";
            }
            else
            {
                errMsg += "Uncaught Error: [line.utils.Assets] ERROR: Cannot find 'boyfriend.chr'. File is missing or corrupted\nPlease report this error to the GitHub page: https://github.com/Dsfan2/DokiDokiFNFClubDX \n\n> Crash Handler written by: sqirra-rng";
                errMsg2 += "Uncaught Error: [line.utils.Assets] ERROR: Cannot find 'boyfriend.chr'. File is missing or corrupted\nOkay... you got this... very carefully... don't screw this up this time...\nPlease report this error to the GitHub page: https://github.com/Dsfan2/DokiDokiFNFClubDX \n\n> Crash Handler written by: sqirra-rng";
            }

	    	if (!FileSystem.exists("./crash/"))
    			FileSystem.createDirectory("./crash/");

		    File.saveContent(path, errMsg2 + "\n");

	    	Sys.println(errMsg);
    		Sys.println("Crash dump saved in " + Path.normalize(path));

		    Application.current.window.alert(errMsg, "Error!");
	    	DiscordClient.shutdown();
    		Sys.exit(1);
            #end
        }
        else
        {
            #if !html5
            Sys.exit(0);
            #end
        }
    }
}
