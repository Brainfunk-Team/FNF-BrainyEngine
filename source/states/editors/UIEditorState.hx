package states.editors;

import backend.UIData;
import backend.PsychCamera;
import objects.Character;
import psychlua.LuaUtils;

import flixel.FlxObject;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import flixel.math.FlxRect;
import flixel.util.FlxDestroyUtil;

import openfl.utils.Assets;

import openfl.display.Sprite;

import openfl.net.FileReference;

import openfl.events.Event;
import openfl.events.IOErrorEvent;

import psychlua.ModchartSprite;
import flash.net.FileFilter;

import states.editors.content.Prompt;
import states.editors.content.PreloadListSubState;

class UIEditorState extends MusicBeatState implements PsychUIEventHandler.PsychUIEvent {

    var uiData:UIFile;

    function new() {
        super();

        uiData = UIData.dummy();
    }

    function create() {
        super();
    }
}