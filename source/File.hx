package;

using StringTools;

class File
{
	public static function getFile(file:String, type:String, folder:String)
	{
		trace('assets/$folder$file.$type');

		return 'assets/$folder$file.$type';
	}

	public static function data(file:String, ?type:String = 'txt', ?folder:String = 'data/')
	{
		return getFile(file, type, '$folder');
	}

	public static function image(file:String, ?folder:String = 'images/')
	{
		return getFile(file, 'png', '$folder');
	}

	public static function sound(file:String, ?folder:String = 'sounds/')
	{
		return getFile(file, 'wav', '$folder');
	}

	public function music(file:String, ?folder:String = 'music/')
	{
		return getFile(file, 'wav', '$folder');
	}
}
