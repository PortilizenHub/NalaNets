package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class MenuState extends FlxState
{
	public static var menuOpt_load:Array<String>;
	public static var menuOpt_Options:Array<String> = ["speedrun timer"];
	public static var menuOpt_Default:Array<String> = ["play"];

	var menuOpt:Array<String>;
	var menuGrp:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();

	var current:Int = 0;

	override public function create()
	{
		if (menuOpt_load == null)
			menuOpt_load = menuOpt_Default;

		menuOpt = menuOpt_load;

		trace(menuOpt);

		for (i in 0...menuOpt.length)
		{
			var text:FlxText = new FlxText(0, 0, 0, menuOpt[i], Math.floor(128 / menuOpt.length));
			text.ID = i;
			text.screenCenter();
			text.x -= 20 * i;
			text.y = 20 * i;
			menuGrp.add(text);
		}

		add(menuGrp);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		if (FlxG.keys.justReleased.LEFT)
		{
			current -= 1;
		}
		if (FlxG.keys.justReleased.RIGHT)
		{
			current += 1;
		}

		if (current < 0)
			current = 0;
		if (current > menuOpt.length - 1)
			current = menuOpt.length - 1;

		menuGrp.forEach(function(txt:FlxText)
		{
			txt.color = FlxColor.WHITE;

			if (txt.ID == current)
				txt.color = FlxColor.YELLOW;
		});

		if (FlxG.keys.justReleased.ENTER)
		{
			switch (menuOpt[current].toLowerCase())
			{
				case 'play':
					FlxG.switchState(new PlayState());

				case 'settings':
					trace('unused');
			}
		}

		super.update(elapsed);
	}
}
