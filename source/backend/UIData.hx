package backend;

import haxe.Json;
import sys.io.File;
import haxe.ds.StringMap;

typedef UIFile = {
	var directory:String;
	@:optional var isPixel:Null<Bool>;
	@:optional var preload:Dynamic;
	@:optional var objects:Array<Dynamic>;
	@:optional var _editorMeta:Dynamic;
}

class UIData {
	// Static storage for all loaded UI files
	static var uiMap:StringMap<UIFile> = new StringMap();

	/**
	 * Load a UI JSON file from path and store it under a name
	 */
	public static function load(name:String, path:String):Void {
		try {
			var content = File.getContent(path);
			var parsed:UIFile = Json.parse(content);
			uiMap.set(name, parsed);
		} catch (e) {
			trace('Failed to load UI file "$name" at $path: $e');
		}
	}

	/**
	 * Get a UIFile by name
	 */
	public static function get(name:String):Null<UIFile> {
		return uiMap.get(name);
	}

	/**
	 * Preload multiple UI files if needed
	 */
	public static function preloadAll(files:Array<{name:String, path:String}>):Void {
		for (file in files) {
			load(file.name, file.path);
		}
	}
}
