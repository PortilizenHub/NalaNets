package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

class PlayState extends FlxState
{
	var net:FlxSprite;
	var counch:FlxSprite;

	var pixelZoom:Int = 4;

	override public function create()
	{
		counch = new FlxSprite(120, 540).loadGraphic(File.image('counch'));
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

		super.update(elapsed);
	}
}
