package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import openfl.Assets;

using StringTools;

class PlayState extends FlxState
{
	var net:FlxSprite;
	var counch:FlxSprite;
	var floor:FlxSprite;

	var offsets:Array<String> = coolTextFile(File.data('stage'));
	var sizes:Array<String> = coolTextFile(File.data('size'));

	var pixelZoom:Int = 4;

	override public function create()
	{
		trace(offsets);
		trace(sizes);

		floor = new FlxSprite(Std.parseFloat(offsets[2]), Std.parseFloat(offsets[3])).loadGraphic(File.image('floor'));
		floor.setGraphicSize(Std.int(floor.width * (pixelZoom + Std.int(Std.parseFloat(sizes[1])))),
			Std.int(floor.height * (pixelZoom + Std.int(Std.parseFloat(sizes[1])))));
		add(floor);

		counch = new FlxSprite(Std.parseFloat(offsets[0]), Std.parseFloat(offsets[1])).loadGraphic(File.image('counch'));
		counch.setGraphicSize(Std.int(counch.width * (pixelZoom + Std.int(Std.parseFloat(sizes[0])))),
			Std.int(counch.height * (pixelZoom + Std.int(Std.parseFloat(sizes[0])))));
		add(counch);

		net = new FlxSprite(FlxG.mouse.x, FlxG.mouse.y).loadGraphic(File.image('net'));
		net.setGraphicSize(Std.int(net.width * pixelZoom), Std.int(net.height * pixelZoom));
		add(net);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		FlxG.mouse.visible = false;
		net.setPosition(FlxG.mouse.x, FlxG.mouse.y);

		floor.setPosition(Std.parseFloat(offsets[2]), Std.parseFloat(offsets[3]));
		floor.setGraphicSize(Std.int(floor.width * (pixelZoom + Std.int(Std.parseFloat(sizes[1])))),
			Std.int(floor.height * (pixelZoom + Std.int(Std.parseFloat(sizes[1])))));

		counch.setPosition(Std.parseFloat(offsets[0]), Std.parseFloat(offsets[1]));
		counch.setGraphicSize(Std.int(counch.width * (pixelZoom + Std.int(Std.parseFloat(sizes[0])))),
			Std.int(counch.height * (pixelZoom + Std.int(Std.parseFloat(sizes[0])))));

		offsets = coolTextFile(File.data('stage'));
		sizes = coolTextFile(File.data('size'));

		// net.animation.play(Std.string(mouseOverlapObject(floor) || mouseOverlapObject(counch)));

		super.update(elapsed);
	}

	// taken from friday night funkin
	// thank you ninjamuffin99
	public static function coolTextFile(path:String):Array<String>
	{
		var daList:Array<String> = Assets.getText(path).trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}

	public function mouseOverlapObject(obj:FlxBasic)
	{
		return net.overlaps(obj);
	}
}
