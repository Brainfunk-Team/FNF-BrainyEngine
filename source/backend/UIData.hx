package backend;

import haxe.Json;
import sys.io.File;
import haxe.ds.StringMap;

import backend.Paths;
import backend.Song;

import states.PlayState;

//This code is heavily based on StageData.hx.

typedef UITextEntry = {
    var x:Float;
    var y:Float;
    var centerX:Bool;
    var centerY:Bool;
    var scrollFactorX:Float;
    var scrollFactorY:Float;
    var text:String;
    var tag:String;
}

typedef UIFile = {
    var directory:String;
    var healthBarImage:String;
    var healthBarX:Float;
    var healthBarY:Float;
    var healthBarDownScrollY:Float;
    var centerHealthBarX:Bool;
    var centerHealthBarY:Bool;
    var healthBarScrollFactorX:Float;
    var healthBarScrollFactorY:Float;
    var healthBarVisible:Bool;
    var text:Array<Dynamic>;
}

class UIData {
    public static var instance:UIData;
    private var SONG:SwagSong = PlayState.SONG;

    public function new() {
        instance = this;
    }

    public static function dummy():UIFile
    {
        return {
            "directory": "",
            "healthBarImage": "healthBar",
            "healthBarX": 0,
            "healthBarY": 640.8,
            "healthBarDownScrollY": 79.2,
            "centerHealthBarX": true,
            "centerHealthBarY": false,
            "healthBarScrollFactorX": 0,
            "healthBarScrollFactorY": 0,
            "healthBarVisible": true,
            "text": [
                [0, 680.8, 79.2, true, false, 0, 0, "Score: {score} | Misses: {misses} | Rating: {rating}% - {ratingFC}", "scoreTxt"]
            ]
        };
    }

    public static var forceNextDirectory:String = null;

    public static function loadDirectory(SONG:SwagSong) {
        var ui:String = '';

        trace("SONG.ui = " + SONG.ui);

        if(SONG.ui != null)
            ui = SONG.ui;
        else if(Song.loadedSongName != null)
            ui = vanillaUI(Paths.formatToSongPath(Song.loadedSongName));
        else
            ui = 'default';


        // Force UI to your custom one during debugging:
        // Uncomment this line to force loading your custom UI JSON
        ui = "defaulttest";

        var uiFile:UIFile = getUIFile(ui);
        forceNextDirectory = (uiFile != null) ? uiFile.directory : '';
        trace("[UIData] Loaded UI directory: " + forceNextDirectory);
    }

    public static function getUIFile(ui:String):UIFile {
        try
        {
            var path:String;
            #if MODS_ALLOWED
            path = Paths.getPath('ui/' + ui + '.json', TEXT, null, true);
            #else
            path = Paths.getPath('ui/' + ui + '.json', TEXT, null, false);
            #end
            
            trace("[UIData] Trying to load UI JSON from path: " + path);

            #if MODS_ALLOWED
            if(FileSystem.exists(path)) {
                return cast tjson.TJSON.parse(File.getContent(path));
            }
            #else
            if(Assets.exists(path)) {
                return cast tjson.TJSON.parse(Assets.getText(path));
            }
            #end
        }
        catch(e:Dynamic) {
            trace("[UIData] Error loading UI JSON: " + e);
        }
        trace("[UIData] Falling back to dummy UI.");
        return dummy();
    }

    public static function vanillaUI(songName):String
    {
        return 'default';
    }

    public function formatText(string:String):String {

        var ratingFCString:String = PlayState.instance.ratingFC;

        if (ratingFCString == "")
            ratingFCString = "???";

        var replacements = [
            "{score}" => Std.string(PlayState.instance.songScore),
            "{rating}" => Std.string(Math.round((PlayState.instance.ratingPercent * 100)*100)/100),
            "{ratingFC}" => ratingFCString,
            "{misses}" => Std.string(PlayState.instance.songMisses)
        ];

        for (key in replacements.keys()) {
            string = string.replace(key, replacements.get(key));
        }

        return string;
    }
}
