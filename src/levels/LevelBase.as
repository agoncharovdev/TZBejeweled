package levels {
import interfaces.ILevel;

public class LevelBase implements ILevel
{
    protected var _rows:int = 0;
    protected var _cols:int = 0;
    protected var _tileSize:int = 0;

    public function get rows():int {
        return _rows;
    }

    public function set rows(value:int):void {
        _rows = value;
    }

    public function get cols():int {
        return _cols;
    }

    public function set cols(value:int):void {
        _cols = value;
    }

    public function get tileSize():int {
        return _tileSize;
    }

    public function set tileSize(value:int):void {
        _tileSize = value;
    }
}
}
