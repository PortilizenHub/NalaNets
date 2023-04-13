package;

class File
{
	public function getFile(file:String, type:String, folder:String)
	{
		if (folder.length > 0)
			folder += '/';

		return 'assets/$folder$file.$type';
	}

	public function data(file:String, ?type:String = '.txt', ?folder:String)
	{
		return getFile(file, type, 'data/$folder');
	}

	public function image(file:String, ?folder:String)
	{
		return getFile(file, '.png', 'images/$folder');
	}

	public function sound(file:String, ?folder:String)
	{
		return getFile(file, '.wav', 'sounds/$folder');
	}

	public function music(file:String, ?folder:String)
	{
		return getFile(file, '.wav', 'music/$folder');
	}
}
