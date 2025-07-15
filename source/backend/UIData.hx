package backend;

import haxe.Json;
import sys.io.File;
import haxe.ds.StringMap;

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
	var noteSkin:String;
    var healthBarImage:String;
    var healthBarX:Float;
    var healthBarY:Float;
    var healthBarDownScrollY:Float;
    var centerHealthBarX:Bool;
    var centerHealthBarY:Bool;
    var text:Array<UITextEntry>;
}

class UIData {
}