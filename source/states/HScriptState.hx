package states;

import backend.MusicBeatState;
import psychlua.HScript;

import backend.Mods;

import sys.io.File;

//this is stuff just required by debug print bruh, if for any reason you want to remove debug print, these are safe to remove.
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
class HScriptState extends MusicBeatState
{
    var stateFile:String; //state file under modsfolder/states
    var state:HScript;
    var code:String;
    var debugPrints:Array<FlxText>;

    public function hasFunction(func:String)
        return code.contains(func); //lazy...   TODO: MAKE THIS FUNCTION BETTER

    public function callFunction(func:String, ?args:Array<Dynamic>=null):Dynamic {

        if (hasFunction(func)) //this just prevents those annoying errors in the console
        {
            if (args == null)
                return state.call(func, []);
            else
                return state.call(func, args);
        }
        else
            return null; //bozo tried to run a non existing function lol
    }

    public function debugPrint(text:String, ?color:Int=FlxColor.WHITE)
    {
        if (debugPrints.length < 1)
            debugPrints = new Array();

        debugPrints.push(new FlxText(0, debugPrints.length*10, FlxG.width, text));

        var curText:Int = debugPrints.length;
        debugPrints[curText].setFormat("vcr", 8, color, );
        add(debugPrints[curText]);

        var timer:FlxTimer = new FlxTimer().start(10, function(timer:FlxTimer) {
            FlxTween.tween(debugPrints[curText], {alpha: 0}, 0.5, {
                onComplete: deleteLastPrint
            });
        });
    }

    public function deleteLastPrint(tween:FlxTween)
        debugPrints.pop();
    
    override public function new(stateFile)
    {
        this.stateFile = stateFile;

        var directories:Array<String> = Mods.directoriesWithFile("", "states/" + stateFile + ".hx", true);

        code = File.getContent(directories[0]);

        state = new HScript(null, directories[0], null, false);
        state.set("state", this);

        super();
    }

    override function create()
    {
        super.create();
        callFunction("onCreate");
        //create logic here
        callFunction("onCreatePost");
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
        callFunction("onUpdate", [elapsed]);
        //update logic here
        callFunction("onUpdatePost", [elapsed]);
    }
}