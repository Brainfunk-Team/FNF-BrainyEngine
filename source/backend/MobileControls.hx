package backend;

import flixel.FlxSprite;
import flixel.FlxG;

class MobileControls extends FlxSprite
{
    public var type:String; // e.g., "left", "right", etc.

    public function new(type:String)
    {
        super();

        this.type = type;

        // Load the atlas with XML
        loadGraphic(Paths.image("mobileControls"), true, FlxG.width, FlxG.height);
        frames = Paths.getSparrowAtlas("mobileControls"); // assumes mobileControls.png + .xml

        // Add animations using frame names like "left idle", "left press"
        animation.addByPrefix("idle", type + " idle", 0, false);
        animation.addByPrefix("press", type + " press", 0, false);
        animation.play("idle");

        scrollFactor.set(0, 0);
        setPositionForType(type);
    }

    function setPositionForType(type:String):Void
    {
        switch (type)
        {
            case "left": setPosition(0, FlxG.height / 2);
            case "down": setPosition(FlxG.width / 2, FlxG.height / 2);
            case "up":   setPosition(0, 0);
            case "right":setPosition(FlxG.width / 2, 0);
        }
    }

    public function updateState(touching:Bool):Void
    {
        animation.play(touching ? "press" : "idle");
    }
}
