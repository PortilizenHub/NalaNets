package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import haxe.Json;
import openfl.Assets;

using StringTools;

#if !web
import openfl.net.FileReference;
import sys.FileSystem;
import sys.io.File as SysFile;
#end

class PlayState extends FlxState
{
	var net:FlxSprite;
	var counch:FlxSprite;
	var floor:FlxSprite;

	var nala:FlxSprite;

	var hiScore:FlxText;
	var scoreT:FlxText;

	var reset:FlxText;

	var offsets:Array<String> = coolTextFile(File.data('stage'));
	var sizes:Array<String> = coolTextFile(File.data('size'));
	var nalaSettings:Array<String> = coolTextFile(File.data('nalaSettings'));
	var scoreFile:Array<String> = coolTextFile(File.data('scoreSettings'));

	var pressedNala:Bool = false;

	var canReset:Bool = false;

	var pixelZoom:Int = 4;

	var nalaRandom:Int = 0;

	var highScore:Int = Std.int(10000);
	var score:Int = 0;
	var timer:Int = 60;
	var timerXX:Int = 120;

	override public function create()
	{
		trace(offsets);
		trace(sizes);
		trace(nalaSettings);
		trace(scoreFile);

		if (scoreFile[2] != null)
			highScore = Std.int(Std.parseFloat(scoreFile[2]));

		floor = new FlxSprite(Std.parseFloat(offsets[2]), Std.parseFloat(offsets[3])).loadGraphic(File.image('floor'));
		floor.setGraphicSize(Std.int(floor.width * (pixelZoom + Std.int(Std.parseFloat(sizes[1])))),
			Std.int(floor.height * (pixelZoom + Std.int(Std.parseFloat(sizes[1])))));
		add(floor);

		counch = new FlxSprite(Std.parseFloat(offsets[0]), Std.parseFloat(offsets[1])).loadGraphic(File.image('counch'));
		counch.setGraphicSize(Std.int(counch.width * (pixelZoom + Std.int(Std.parseFloat(sizes[0])))),
			Std.int(counch.height * (pixelZoom + Std.int(Std.parseFloat(sizes[0])))));
		add(counch);

		// the x and y is the START positions
		nala = new FlxSprite(Std.parseFloat(nalaSettings[1]), Std.parseFloat(nalaSettings[2])).loadGraphic(File.image('nala'), true, 16, 16);
		nala.animation.add('idle', [0]);
		nala.animation.add('jump', [1]);
		nala.setGraphicSize(Std.int(nala.width * (pixelZoom + Std.parseFloat(nalaSettings[0]))),
			Std.int(nala.height * (pixelZoom + Std.parseFloat(nalaSettings[0]))));
		nala.animation.play('idle');
		add(nala);

		net = new FlxSprite(FlxG.mouse.x, FlxG.mouse.y).loadGraphic(File.image('net'));
		net.setGraphicSize(Std.int(net.width * pixelZoom), Std.int(net.height * pixelZoom));
		add(net);

		#if !web
		hiScore = new FlxText(20, 0, 0, Std.string(highScore), 16);
		add(hiScore);
		#end

		scoreT = new FlxText(20, 40, 0, Std.string(score), 16);
		add(scoreT);

		reset = new FlxText(0, 0, 0, 'PRESS R TO RESET', 32);
		reset.visible = canReset;
		reset.screenCenter();
		reset.color = 0xff0000;
		add(reset);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		reset.visible = canReset;

		#if !web
		hiScore.text = Std.string(highScore);
		#end
		scoreT.text = Std.string(score);

		FlxG.mouse.visible = false;
		net.setPosition(FlxG.mouse.x, FlxG.mouse.y);

		floor.setPosition(Std.parseFloat(offsets[2]), Std.parseFloat(offsets[3]));
		floor.setGraphicSize(Std.int(floor.width * (pixelZoom + Std.int(Std.parseFloat(sizes[1])))),
			Std.int(floor.height * (pixelZoom + Std.int(Std.parseFloat(sizes[1])))));

		counch.setPosition(Std.parseFloat(offsets[0]), Std.parseFloat(offsets[1]));
		counch.setGraphicSize(Std.int(counch.width * (pixelZoom + Std.int(Std.parseFloat(sizes[0])))),
			Std.int(counch.height * (pixelZoom + Std.int(Std.parseFloat(sizes[0])))));

		nala.setGraphicSize(Std.int(nala.width * (pixelZoom + Std.parseFloat(nalaSettings[0]))),
			Std.int(nala.height * (pixelZoom + Std.parseFloat(nalaSettings[0]))));

		#if !web
		offsets = coolTextFile(File.data('stage'));
		sizes = coolTextFile(File.data('size'));
		nalaSettings = coolTextFile(File.data('nalaSettings'));
		scoreFile = coolTextFile(File.data('scoreSettings'));
		#end

		if (!pressedNala)
		{
			canReset = false;

			pressedNala = FlxG.mouse.pressed && mouseOverlapObject(nala);

			timerXX--;

			if (timerXX > 1)
			{
				timerXX = 120;
				timer--;

				if (timer > 1)
				{
					timer = 60;
					score++;
				}
			}

			FlxTween.tween(nala, {x: FlxG.random.int(0, FlxG.width), y: Std.parseFloat(nalaSettings[2])}, FlxG.random.float(0.1, 2), {
				onComplete: function(twn:FlxTween)
				{
					nala.animation.play('idle');
				}
			});
		}
		else
		{
			canReset = true;

			#if !web
			if (score < highScore)
				highScore = score;

			if (FileSystem.exists('assets/data'))
			{
				SysFile.saveContent('assets/data/scoreSettings.txt', Std.string(nala.x + '\n' + nala.y + '\n' + highScore));
			}
			#end

			nala.setPosition(Std.parseFloat(scoreFile[0]), Std.parseFloat(scoreFile[1]));
			nala.animation.play('idle');

			if (canReset)
			{
				if (FlxG.keys.justReleased.R)
					FlxG.resetState();
			}
		}

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
