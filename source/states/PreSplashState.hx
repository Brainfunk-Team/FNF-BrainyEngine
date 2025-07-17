package states;

import flixel.FlxState;
import backend.ClientPrefs;
import backend.MusicBeatState;

class PreSplashState extends FlxState
{
    override public function new()
    {
        super();
    }

    override public function create()
    {
        super.create();

		ClientPrefs.loadPrefs();
		Language.reloadPhrases();

        if (!ClientPrefs.data.skipSplash)
            FlxG.switchState(new SplashState("splash", "startup", 1));
        else
            MusicBeatState.switchState(new TitleState());
    }
}