package states.stages.objects;

import states.stages.objects.ABotSpeaker;

//TODO: FINISH THIS CLASS

class ABotSpeakerPixel extends ABotSpeaker
{
    function new(x:Float = 0, y:Float = 0, ?scale:Float = 6)
    {
        super(x, y);
        bg = new FlxSprite(90, 20).loadGraphic(Paths.image('abotPixel/aBotPixelBack'));
		bg.antialiasing = antialias;
        bg.scale.x = scale;
		bg.scale.y = scale;
		add(bg);

        var vizX:Float = 0;
		var vizY:Float = 0;
		var vizFrames = Paths.getSparrowAtlas('abot/aBotVizPixel');
		for (i in 1...VIZ_MAX+1)
		{
			volumes.push(0.0);
			vizX += VIZ_POS_X[i-1];
			vizY += VIZ_POS_Y[i-1];
			var viz:FlxSprite = new FlxSprite(vizX + 140, vizY + 74);
			viz.frames = vizFrames;
			viz.animation.addByPrefix('VIZ', 'viz$i', 0);
			viz.animation.play('VIZ', true);
			viz.animation.curAnim.finish(); //make it go to the lowest point
			viz.antialiasing = false;
			vizSprites.push(viz);
			viz.updateHitbox();
			viz.centerOffsets();
            viz.scale.x = scale;
            viz.scale.y = scale;
			add(viz);
		}
    }
}