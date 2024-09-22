package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

class AntiCheatState extends MusicBeatState
{
    var noCheating:FlxSprite;

    override public function create()
    {
        FlxG.sound.music.stop();
        if (PlayState.SONG.song.toLowerCase() == "script error" || PlayState.SONG.song.toLowerCase() == "system failure" || PlayState.SONG.song.toLowerCase() == "the final battle" || PlayState.SONG.song.toLowerCase() == "festival deluxe")
            noCheating = new FlxSprite(0, 0).loadGraphic(Paths.image('nocheating_sayori'));
        else
            noCheating = new FlxSprite(0, 0).loadGraphic(Paths.image('nocheating'));
        add(noCheating);

        super.create();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
        if (FlxG.keys.justPressed.ENTER)
        {
            openSubState(new CustomFadeTransition(0.4, false, new PlayState()));
            //MusicBeatState.switchState(new PlayState());
        }
    }
}
