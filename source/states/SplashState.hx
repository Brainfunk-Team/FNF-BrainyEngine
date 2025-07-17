package states;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;
import backend.MusicBeatState;

import backend.ClientPrefs;

class SplashState extends MusicBeatState
{
    var splash:FlxSprite;
    var timer:FlxTimer;
    var splashImage:String;
    var splashSound:String;
    var time:Float;

    override public function new(splashImage:String, ?splashSound:String="", ?time:Float=0.6) {
        super();

        this.splashImage = splashImage;
        this.splashSound = splashSound;
        this.time = time;

        timer = new FlxTimer();
    }

    override function create()
    {
        super.create();
        
        if (!ClientPrefs.data.skipSplash)
        {
            if (splashSound != "")
                FlxG.sound.play(Paths.sound(splashSound));

            splash = new FlxSprite().loadGraphic(Paths.image(splashImage));
            add(splash);

            timer.start(time, function(tmr:FlxTimer)
            {
                MusicBeatState.switchState(new TitleState());
            });
        }
        else
            MusicBeatState.switchState(new TitleState());
    }
}