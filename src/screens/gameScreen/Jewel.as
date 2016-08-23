package screens.gameScreen
{
import core.Model;

import interfaces.ITheme;

import starling.animation.Tween;
import starling.core.Starling;
import starling.display.Image;

public class Jewel extends Image
{
	static public const EMPTY:String = "empty";
	static public const BLUE:String = "blue";
	static public const ORANGE:String = "orange";
	static public const MAGENTA:String = "magenta";
	static public const YELLOW:String = "yellow";
	static public const GREEN:String = "green";
	static public const allTypes:Array = [BLUE, ORANGE, MAGENTA, YELLOW, GREEN];

	private var _raw:uint;
	private var _col:int;
	private var _type:String;

	public function Jewel(type:String)
	{
		super (ITheme(Model.getModel(ITheme)).getTexture(type));
		_type = type;
		alignPivot();
	}

	public function get col():int {return _col;}
	public function get type():String {return _type;}
	public function get raw():int {return _raw;}

	public function setPosition(raw:int, column:int, tileSize:int):void
	{
		if (raw >= 0)
			_raw = raw;
		if (column >= 0)
			_col = column;

		var tween:Tween = new Tween(this, 0.3);
		tween.moveTo((_col * tileSize) + tileSize / 2, (_raw * tileSize) + tileSize / 2);
		Starling.juggler.add(tween);
	}

	static public function getRandomJewel():Jewel
	{
		return new Jewel(allTypes[Math.round(Math.random()*(allTypes.length - 1))]);
	}
}
}