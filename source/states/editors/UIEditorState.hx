package states.editors;

import backend.UIData;
import objects.Bar;

import flixel.FlxG;
import flixel.util.FlxSpriteUtil;

import openfl.utils.ByteArray;

import haxe.io.Bytes;
import haxe.Json;

import flash.net.FileReference;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.FileFilter;

//Code entirely by Brainy7890 :o

class UIEditorState extends MusicBeatState implements PsychUIEventHandler.PsychUIEvent
{
    var fileRef:FileReference;
    var rawJSON:String;
    var uiData:UIFile;

    var healthBar:Bar;
    var downScroll:Bool;
    var selected:String;
    var text:Array<FlxText> = new Array();
    var selectBox:FlxSprite;
    var positionTxt:FlxText;

    var fileBox:PsychUIBox;
    var saveButton:PsychUIButton;
    var loadButton:PsychUIButton;

    var textBox:PsychUIBox;
    var newButton:PsychUIButton;
    var setTextField:PsychUIInputText;

    var propertiesBox:PsychUIBox;
    var downScrollButton:PsychUIButton;

    var curText:Int = -1;

    var moveMod:Int = 1;
    var moveMode:Int = 0;

    var downScrollStr:String;

    var deselect:Bool = true;

    public function new() {
        super();
        downScroll = false;
        selected = "";
        uiData = UIData.dummy();
        selectBox = new FlxSprite();
        positionTxt = new FlxText(0, 0, FlxG.width, "None selected", 24);
    }

    //function loadUI(uiName):UIFile {} //this is left over, i'll keep it here for memories sake.

    override function create() {
        super.create();
        FlxG.camera.bgColor = FlxColor.fromHSL(0, 0, 0.5);
        loadHealthBar();
        FlxG.mouse.visible = true;
        positionTxt.setFormat(Paths.font("vcr.ttf"), 30, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(positionTxt);

        fileBox = new PsychUIBox(1000, 500, 220, 220, ['Save/Load']);
		fileBox.scrollFactor.set();

        saveButton = new PsychUIButton(30, 15, "Save");
        loadButton = new PsychUIButton(30, 40, "Load");
		
		fileBox.getTab('Save/Load').menu.add(saveButton);
        fileBox.getTab('Save/Load').menu.add(loadButton);
		add(fileBox);

        textBox = new PsychUIBox(1000, 280, 220, 220, ['Text Objects', 'Change Properties']);

        newButton = new PsychUIButton(30, 15, "Add Text");
        setTextField = new PsychUIInputText(30, 15); 

        textBox.getTab("Text Objects").menu.add(newButton);
        textBox.getTab("Change Properties").menu.add(setTextField);

        add(textBox);

        propertiesBox = new PsychUIBox(0, 270, 220, 200, ["Properties"]);
        downScrollButton = new PsychUIButton(30, 15, "Toggle Downscroll");

        propertiesBox.getTab("Properties").menu.add(downScrollButton);
        add(propertiesBox);
    }

    function setText(index, string)
    {
        var str = string;
        if (str == "") str = "Empty!";

        text[index].text = str;
        uiData.text[index][7] = str;

        text[index].updateHitbox();
    }

    function addText(x, y, content)
    {
        text.push(new FlxText(x, y, FlxG.width, content));
        uiData.text.push([x-FlxG.width/2, y, y, false, false, 0, 0, content]);
        curText = text.length - 1;
        selected = "text";
        text[curText].updateHitbox();
        add(text[curText]);
    }

   function load():Void {
        fileRef = new FileReference();

        fileRef.addEventListener(Event.SELECT, function(_) {
            fileRef.addEventListener(Event.COMPLETE, function(_) {
                try {
                    var raw:String = fileRef.data.toString();
                    uiData = cast Json.parse(raw);
                    trace("Successfully loaded UI data!");
                    loadHealthBar();
                } catch (e) {
                    trace("Error parsing JSON: " + e);
                }
            });

            fileRef.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent) {
                trace("Failed to read file: " + e.text);
            });

            fileRef.load();
        });

        fileRef.browse([new FileFilter("JSON UI Files", "*.json")]);

        for (text in uiData.text) {
            text[0] += FlxG.width;
        }
    }

    function save(uiData:UIFile):Void {
        fileRef = new FileReference();
        rawJSON = UIData.saveUIFile(uiData);

        fileRef.addEventListener(Event.COMPLETE, function(e:Event) {
            trace("Saved UI file!");
        });

        fileRef.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent) {
            trace("Failed to save UI file: " + e.text);
        });

        var jsonBytes = Bytes.ofString(rawJSON);
        var jsonBlob = new ByteArray();
        jsonBlob.writeBytes(jsonBytes.getData());

        fileRef.save(jsonBlob, "default.json");
    }

    function placeSelectBox(x:Float, y:Float, width:Float, height:Float) {
        selectBox = new FlxSprite();
        selectBox.makeGraphic(100, 50, 0x00000000);
        FlxSpriteUtil.drawRect(selectBox, x, y, width+4, height+4, FlxColor.GREEN, { thickness: 4 });
        add(selectBox);
    }

    function loadHealthBar() {
        var healthBarImage:String = uiData.healthBarImage;
		var healthBarX:Float = uiData.healthBarX;
		var healthBarY:Float;
		var centerHealthBarX:Bool = uiData.centerHealthBarX;
    	var centerHealthBarY:Bool = uiData.centerHealthBarY;
		var healthBarVisible:Bool = uiData.healthBarVisible;
		var healthBarScrollFactorX:Float = uiData.healthBarScrollFactorX;
		var healthBarScrollFactorY:Float = uiData.healthBarScrollFactorY;

		if (!downScroll)
			healthBarY = uiData.healthBarY;
		else
			healthBarY = uiData.healthBarDownScrollY;

		healthBar = new Bar(healthBarX, healthBarY, healthBarImage, function() return 1, 0, 2);
		
		if (centerHealthBarX)
			healthBar.screenCenter(X);
		if (centerHealthBarY)
			healthBar.screenCenter(Y);

		healthBar.leftToRight = false;
		healthBar.scrollFactor.set(healthBarScrollFactorX, healthBarScrollFactorY);

		if (!healthBar.visible)
			healthBar.visible = !healthBarVisible;

        add(healthBar);
    }

    function arrayToString(array:Array<String>):String
    {
        var str:String = "";

        for (string in array)
        {
            str = str + string + "\n";
        }

        return str;
    }

    function getClickedTextIndex():Int
    {
        var idx:Int = 0;
        for (textObj in text)
        {
            if (textObj.overlapsPoint(FlxG.mouse.getWorldPosition())) {
                if (selected == "text") {
                    selected = "";
                }
                return idx;
            }
            idx += 1;
        }
        return -1;
    }

    override function update(elapsed:Float) {

        downScrollStr = "Disabled";
        if (downScroll) downScrollStr = "Enabled";

        if (selected == "healthBar")
        {    
             if (controls.UI_UP_P)
                if (moveMode == 0)
                    moveHealthBar(0, -10*moveMod, downScroll);
                else
                    moveHealthBar(-10/moveMod, downScroll);

            if (controls.UI_DOWN_P)
                if (moveMode == 0)
                    moveHealthBar(0, 10*moveMod, downScroll);
                else
                    moveHealthBar(0, 10/moveMod, downScroll);

            if (controls.UI_RIGHT_P)
                if (moveMode == 0)
                    moveHealthBar(10*moveMod, 0, downScroll);
                else
                    moveHealthBar(10*moveMod, 0, downScroll);

            if (controls.UI_LEFT_P)
                if (moveMode == 0)
                    moveHealthBar(-10*moveMod, 0, downScroll);
                else
                    moveHealthBar(-10*moveMod, 0, downScroll);

            placeSelectBox(healthBar.x, healthBar.y, healthBar.width, healthBar.height);

            positionTxt.text = arrayToString([
                "Selected: Health Bar",
                "X: " + uiData.healthBarX,
                "Y: " + uiData.healthBarY,
                "Downscroll Y: " +  uiData.healthBarDownScrollY,
                "Scroll Factor X: " + uiData.healthBarScrollFactorX,
                "Scroll Factor Y: " + uiData.healthBarScrollFactorY,
                "Image: " + uiData.healthBarImage,
                "Visible?: " + uiData.healthBarVisible,
                "",
                "Downscroll Mode: " + downScrollStr
            ]);
        }
        else if (selected == "text") 
        {
            if (curText != -1) {
                if (controls.UI_UP_P)
                    if (moveMode == 0)
                        moveText(curText, 0, -10*moveMod, downScroll);
                    else
                        moveText(curText, -10/moveMod, downScroll);

                if (controls.UI_DOWN_P)
                    if (moveMode == 0)
                        moveText(curText, 0, 10*moveMod, downScroll);
                    else
                        moveText(curText, 0, 10/moveMod, downScroll);

                if (controls.UI_RIGHT_P)
                    if (moveMode == 0)
                        moveText(curText, 10*moveMod, 0, downScroll);
                    else
                        moveText(curText, 10*moveMod, 0, downScroll);

                if (controls.UI_LEFT_P)
                    if (moveMode == 0)
                        moveText(curText, -10*moveMod, 0, downScroll);
                    else
                        moveText(curText, -10*moveMod, 0, downScroll);

                positionTxt.text = arrayToString([
                    "Selected: Text Object " + curText,
                    "X: " + uiData.healthBarX,
                    "Y: " + uiData.healthBarY,
                    "Downscroll Y: " +  uiData.healthBarDownScrollY,
                    "Scroll Factor X: " + uiData.healthBarScrollFactorX,
                    "Scroll Factor Y: " + uiData.healthBarScrollFactorY,
                    "",
                    "Downscroll Mode: " + downScrollStr
                ]);
            }
        }
        else
        {
            selectBox.visible = false;
            positionTxt.text = "None selected :(";
            setTextField.text = "";
        }

        if (FlxG.mouse.justPressed)
        {
            if (healthBar.overlapsPoint(FlxG.mouse.getWorldPosition())) {
                if (selected == "healthBar") {
                    selectHealthBar(false);
                    return;
                }
                else {
                    selectHealthBar(true);
                    return;
                } 
            }
            
            curText = getClickedTextIndex();

            if (curText == -1)
                selected == "";
            else
                setTextField.text = text[curText].text;
        }

        if (controls.BACK)
		{
			FlxG.mouse.visible = false;
            FlxG.camera.bgColor = FlxColor.BLACK;
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}
        if (FlxG.keys.justPressed.P) positionTxt.visible = !positionTxt.visible;

        if (FlxG.keys.justPressed.SHIFT)
        {
            moveMod = 2;
            moveMode = 0;
        }
        else if (FlxG.keys.justPressed.CONTROL)
        {
            moveMod = 10;
            moveMode = 1;
        }
        else
        {
            moveMode = 0;
            moveMod = 1;
        }

        super.update(elapsed);
    }

    function selectHealthBar(select:Bool)
    {
        if (select) {
            selected = "healthBar";
            selectBox.visible = true;
        }
        else
            selected = "";
    }

    function moveText(index, ?x:Float = 0, ?y:Float = 0, ?downScroll:Bool = false):Array<Float>
    {
        text[index].x += x;
        text[index].y += y;

        uiData.text[index][0] = text[index].x - FlxG.width/2;

        if (!downScroll)
            uiData.text[index][1] = text[index].y;
        else
             uiData.text[index][2] = text[index].y;

        return [uiData.text[index][0], uiData.text[index][1], uiData.text[index][2]];
    }

    function moveHealthBar(?x:Float = 0, ?y:Float = 0, ?downScroll:Bool = false):Array<Float>
    {
        healthBar.x += x;
        healthBar.y += y;

        uiData.healthBarX = healthBar.x;

        if (!downScroll)
            uiData.healthBarY = healthBar.y;
        else
            uiData.healthBarDownScrollY = healthBar.y;

        return [uiData.healthBarX, uiData.healthBarY, uiData.healthBarDownScrollY];
    }

    function setDownscroll(downScroll:Bool)
    {
        if (downScroll)
        {
            healthBar.y = uiData.healthBarDownScrollY;
        }
        else
        {
            healthBar.y = uiData.healthBarY;
        }
    }

    function flipDownScroll() downScroll = !downScroll;

    public function UIEvent(id:String, sender:Dynamic) {
        switch (id) {
            case PsychUIButton.CLICK_EVENT:
                deselect = false;
                if (sender == saveButton) save(uiData);
                else if (sender == loadButton) load();
                else if (sender == downScrollButton) flipDownScroll();
                else if (sender == newButton) addText(FlxG.width/2, FlxG.height/2, "Sample Text");
            case PsychUIInputText.CHANGE_EVENT:
                deselect = false;
                if (sender == setTextField)
                {
                    if (selected == "text")
                        setText(curText, setTextField.text);
                }
                deselect = false;
            default:
                deselect = true;
        }
    }

    //stolen from PlayState.hx
    public function reloadHealthBarColors() {
		healthBar.setColors(FlxColor.fromRGB(175, 102, 206),
			FlxColor.fromRGB(49, 176, 209));
	}
}