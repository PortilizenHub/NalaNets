package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import openfl.Assets;

using StringTools;

#if !web
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
			highScore = Std.int(scoreFiles(2));

		floor = new FlxSprite().loadGraphic(File.image('floor'));
		add(floor);

		counch = new FlxSprite().loadGraphic(File.image('counch'));
		add(counch);

		// the x and y is the START positions
		nala = new FlxSprite(nalaSetting(1), nalaSetting(2)).loadGraphic(File.image('nala'), true, 16, 16);
		nala.animation.add('idle', [0]);
		nala.animation.add('jump', [1]);
		nala.animation.play('idle');
		add(nala);

		net = new FlxSprite(FlxG.mouse.x, FlxG.mouse.y).loadGraphic(File.image('net'));
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
		setPosition(net, FlxG.mouse.x, FlxG.mouse.y);

		setSize(net, 0);

		setPosition(floor, offset(2), offset(3));
		setSize(floor, size(1));

		setPosition(counch, offset(), offset(1));
		setSize(counch, size(0));

		setSize(nala, nalaSetting(0));

		offsets = readFile('stage');
		sizes = readFile('size');
		nalaSettings = readFile('nalaSettings');
		scoreFile = readFile('scoreSettings');

		if (!pressedNala)
		{
			canReset = false;

			pressedNala = FlxG.mouse.pressed && mouseOverlapObject(nala);

			time()
			l

			FlxTween.tween(nala, {x: FlxG.random.int(0, FlxG.width), y: nalaSetting(2)}, FlxG.random.float(0.1, 2), {
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

			setPosition(nala, scoreFiles(0), scoreFiles(1));
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

	public function setPosition(obj:FlxSprite, x:Dynamic, y:Dynamic)
	{
		obj.setPosition(x, y);
	}

	public function offset(itemValue:Int = 0)
	{
		return turnToFloat(arrayValue(offsets, itemValue));
	}

	public function size(itemValue:Int = 0)
	{
		return turnToFloat(arrayValue(sizes, itemValue));
	}

	public function nalaSetting(itemValue:Int = 0)
	{
		return turnToFloat(arrayValue(nalaSettings, itemValue));
	}

	public function scoreFiles(itemValue:Int = 0)
	{
		return turnToFloat(arrayValue(scoreFile, itemValue));
	}

	public function arrayValue(array:Array<Dynamic>, value:Int = 0)
	{
		return array[value];
	}

	public function turnToFloat(value:Dynamic)
	{
		return Std.parseFloat(value);
	}

	public function setSize(obj:FlxSprite, addSize:Dynamic)
	{
		obj.setGraphicSize(Std.int(obj.width * (pixelZoom + addSize)), Std.int(obj.height * (pixelZoom + addSize)));
	}

	public function readFile(file:String)
	{
		return coolTextFile(File.data(file));
	}

	public function time()
	{
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
	}
}
