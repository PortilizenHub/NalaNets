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
import flixel.group.FlxGroup.FlxTypedGroup;
import sys.FileSystem;
import sys.io.File as SysFile;
#end

class PlayState extends FlxState
{
	var backgroundGrp:FlxTypedGroup<FlxSprite>;

	var net:FlxSprite;

	var nala:FlxSprite;

	var hiScore:FlxText;
	var scoreT:FlxText;

	var reset:FlxText;

	var offsets:Array<String> = coolTextFile(File.data('stage'));
	var sizes:Array<String> = coolTextFile(File.data('size'));
	var nalaSettings:Array<String> = coolTextFile(File.data('nalaSettings'));
	var scoreFile:Array<String> = coolTextFile(File.data('scoreSettings'));
	#if !web
	var stageAssets:Array<String> = FileSystem.readDirectory('assets/images/stage');
	#end

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
		#if !web
		trace(stageAssets);
		#end

		backgroundGrp = new FlxTypedGroup<FlxSprite>();

		if (scoreFile[2] != null)
			highScore = Std.int(scoreFiles(2));

		for (i in 0...stageAssets.length)
		{
			var animated:Bool = false;
			var asset:String = stageAssets[i];
			asset.split('.png');

			if (asset.contains('_anim'))
				animated = true;

			var sprite:FlxSprite = new FlxSprite();
			sprite.loadGraphic('assets/images/stage/' + asset, animated, 16, 16);
			sprite.ID = i + 1 + i;
			var spriteID2:Int = i;

			trace('assets/images/stage/' + asset);

			try
			{
				// why did u have to take so long
				setPosition(sprite, offset(spriteID2), offset(sprite.ID));
			}
			catch (e)
			{
				setPosition(sprite, 0, 0);
			}
			try
			{
				setSize(sprite, size(spriteID2));
			}
			catch (e)
			{
				setSize(sprite, 2);
			}

			sprite.ID = i;

			backgroundGrp.add(sprite);
		}

		add(backgroundGrp);

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

		setSize(nala, nalaSetting(0));

		offsets = readFile('stage');
		sizes = readFile('size');
		nalaSettings = readFile('nalaSettings');
		scoreFile = readFile('scoreSettings');

		backgroundGrp.forEach(function(sprite:FlxSprite)
		{
			var spriteID2:Int = sprite.ID;

			sprite.ID = sprite.ID + 1 + sprite.ID;

			try
			{
				setSize(sprite, size(spriteID2));
			}
			catch (e)
			{
				setSize(sprite, 2);
			}

			try
			{
				setPosition(sprite, offset(spriteID2), offset(sprite.ID));
			}
			catch (e)
			{
				setPosition(sprite, 0, 0);
			}

			sprite.ID = spriteID2;
		});

		if (!pressedNala)
		{
			canReset = false;

			pressedNala = FlxG.mouse.pressed && mouseOverlapObject(nala);

			time();

			var nalaNewPos:Int = FlxG.random.int(0, FlxG.width);

			nala.flipX = nalaNewPos > nala.x;

			FlxTween.tween(nala, {x: nalaNewPos, y: nalaSetting(2)}, FlxG.random.float(nalaSetting(3), nalaSetting(4)), {
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

			setPosition(nala, scoreFiles(0), scoreFiles(1));
			#end

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
