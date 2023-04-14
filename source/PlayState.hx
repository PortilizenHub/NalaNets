package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import openfl.Assets;

using StringTools;

class PlayState extends FlxState
{
	var net:FlxSprite;
	var counch:FlxSprite;

	var offsets:Array<String> = coolTextFile(File.data('stage'));

	var pixelZoom:Int = 4;

	override public function create()
	{
		trace(offsets);

		counch = new FlxSprite(Std.parseFloat(offsets[0]), Std.parseFloat(offsets[1])).loadGraphic(File.image('counch'));
		counch.setGraphicSize(Std.int(counch.width * pixelZoom), Std.int(counch.height * pixelZoom));
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

		offsets = coolTextFile(File.data('stage'));

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
}
