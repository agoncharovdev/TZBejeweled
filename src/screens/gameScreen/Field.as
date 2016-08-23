package screens.gameScreen {
import command.UserCommand;

import core.Command;
import core.Model;

import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.utils.setTimeout;

import interfaces.ILevel;
import interfaces.ITheme;

import starling.animation.Tween;
import starling.core.Starling;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.extensions.PDParticleSystem;
import starling.textures.Texture;

public class Field extends starling.display.Sprite
{
    static private const FIELD_BG_TEXTURE_NAME:String = "BG_TEXTURE_NAME";

    private var _theme:ITheme;
    private var _level:ILevel;

    private var _bg:Image;
    private var _selection:Image;
    private var _jewelsMap:Vector.<Vector.<Jewel>>;

    public function Field(level:ILevel)
    {
        _level = level;
        _theme = Model.getModel(ITheme) as ITheme;

        createFieldBg();
        createSelection();

        addEventListener(TouchEvent.TOUCH, onTouch);
    }

    private function createSelection():void
    {
        _selection = new Image(_theme.getTexture("selecting"));
        _selection.pivotX = _selection.width / 2;
        _selection.pivotY = _selection.height / 2;
        _selection.visible = false;
        addChild(_selection);
    }
    
    private function createFieldBg():void
    {
        _bg = new Image(getBoardBg());
        _bg.alpha = .5;
        _bg.touchable = false;
        addChild(_bg);
    }

    private function getBoardBg():Texture
    {
        var blackTile:flash.display.Sprite = new flash.display.Sprite();
        blackTile.graphics.beginFill(0x808080);
        blackTile.graphics.drawRect(0, 0, _level.tileSize, _level.tileSize);
        var whiteTile:flash.display.Sprite = new flash.display.Sprite();
        whiteTile.graphics.beginFill(0xffffff);
        whiteTile.graphics.drawRect(0, 0, _level.tileSize, _level.tileSize);

        var currentTile:flash.display.Sprite = blackTile;
        var boardBitmapData:BitmapData = new BitmapData(_level.tileSize * _level.cols, _level.tileSize * _level.rows, true, 0x00000000);

        var matrix:Matrix = new Matrix();
        matrix.tx = 0;
        matrix.ty = 0;

        for (var ay:int = 0; ay < _level.cols; ay++)
        {
            if (currentTile == blackTile)
                currentTile = whiteTile;
            else if (currentTile == whiteTile)
                currentTile = blackTile;

            for (var ax:int = 0; ax < _level.rows; ax++)
            {
                boardBitmapData.draw(currentTile, matrix);
                matrix.tx += _level.tileSize;

                if (currentTile == blackTile)
                    currentTile = whiteTile;
                else if (currentTile == whiteTile)
                    currentTile = blackTile;
            }
            matrix.ty += _level.tileSize;
            matrix.tx = 0;
        }

        var bgTexture:Texture = Texture.fromBitmapData(boardBitmapData);
        _theme.disposeTexture(FIELD_BG_TEXTURE_NAME);
        _theme.addTexture(FIELD_BG_TEXTURE_NAME, bgTexture);
        return bgTexture;
    }

    // слушаем клик на доске и выбираем кристалл для перестановки
    private var _currentJewel:Jewel;
    private var _nextJewel:Jewel;
    private function onTouch(e:TouchEvent):void
    {
        // определяем точку клика
        var touches:Vector.<Touch> = e.getTouches(this, TouchPhase.ENDED);
        if (touches.length == 0)
            return;
        var touch:Touch = touches[0];
        var touchPoint:Point = touch.getLocation(this);

        // прячем выделялку (красная рамочка) и определяем, какой кристал был под кликом
        _selection.visible = false;
        var clickedJewel:Jewel = getJewelAt(touchPoint.x, touchPoint.y);

        // если кристалов не выбранно - делаем этот текущим
        if (_currentJewel == null)
        {
            _currentJewel = clickedJewel;

            // переводим выделялку на него
            _selection.visible = true;
            _selection.x = _currentJewel.x;
            _selection.y = _currentJewel.y;
            return;
        }

        // если выбранный и тот по которому кликнули - это один и тот же, то выходим
        if (_currentJewel == clickedJewel)
            return;

        // если дошли до сюда - значит есть выбранный кристалл и следующий кристалл, по которому кликнули второй раз - это другой
        // и для этого второго делаем проверку, подходит ли он по условию перестановки (только соседние)
        if (isNearPlaced(_currentJewel, clickedJewel))
        {
            _nextJewel = clickedJewel;
            swapItems(_currentJewel, _nextJewel);
        }
        else _currentJewel = null;
    }

    // меняем местами кристалы на поле и в массиве
    private function swapItems(current:Jewel, next:Jewel, callBack:Function=null):void
    {
        touchable = false;

        var tempRaw:int = current.raw;
        var tempCol:int = current.col;

        _jewelsMap[current.raw][current.col].setPosition(next.raw, next.col, _level.tileSize);
        _jewelsMap[next.raw][next.col].setPosition(tempRaw, tempCol, _level.tileSize);

        setTimeout(function():void
        {
            var temp:* = _jewelsMap[current.raw][current.col];
            _jewelsMap[current.raw][current.col] = _jewelsMap[next.raw][next.col];
            _jewelsMap[next.raw][next.col] = temp;

            touchable = true;

            // после анимации перестановки - делаем проверку на совпадения
            findCombinations();
        }, 400);
    }

    private var _combinations:int;
    private function findCombinations():void
    {
        _combinations = 0;

        // ищем гориз. и верт. комбинации по три и больше кристала одного типа, и удаляем эти кристалы
        for (var i:int = 0; i < _level.cols; i++)
        {
            for (var j:int = 0; j < _level.rows; j++)
            {
                deleteVertical(i, j);
                deleteHorizontal(i, j);
            }
        }

        // если комбинации были, то, так как мы добавили на место удалённых кристалов новые, делаем контрольную проверку
        // если не было - значит этим кристалом ходить нельзя и возвращаем его на место
        if (_combinations > 0 )
        {
            _theme.playSound("click");
            _currentJewel = null;
            _nextJewel = null;

            increaseScore(_combinations);
            findCombinations();
            return;
        }
        else if (_combinations == 0 && _currentJewel && _nextJewel)
            swapItems(_currentJewel, _nextJewel);

        _currentJewel = null;
        _nextJewel = null;
    }

    // для каждого кристалла ищем соседей с таким же типом
    private function deleteHorizontal(i:int, j:int):void
    {
        var item:Jewel = _jewelsMap[i][j]; // текущий кристалл, для которого делаем проверку
        var count:int = 0;	// счётчик совпадений
        var nextIndex:uint = j + 1;	// индекс соседа по горизонтали

        if (!_jewelsMap[i] || _jewelsMap[i].length <= nextIndex)
            return;

        var nextItem:Jewel = _jewelsMap[i][nextIndex];	// кристал сосед
        // если сосед - кристал с таким же типом, то проверяем следующий после соседа кристал.
        // пока есть соседи с таим же типом - увеличиваеи счётчик
        while (_jewelsMap[i].length-1 > nextIndex && item.type == nextItem.type)
        {
            nextIndex++;
            nextItem = _jewelsMap[i][nextIndex];
            count++;
        }

        // после проверки соседей - смотрим, были ли соседи с таким же типом. Если таких больше или равно двум (то есть с нашим текущим
        // кристаллом это будет три и больше), то у нас есть комбинация и её мы и удаляем
        if (count >= 2)
        {
            while (count >= 0)
            {
                _jewelsMap[i][j + count].removeFromParent(true);	// удаляем кристал с поля
                shiftItemsAfterMath(i, j + count );	// сдвигаем верхние кристалы на пустое место и добавляем один сверху

                if(_needEmitter)
                    addEmmiter(i, j + count);	// запускаем анимацию звёздочек
                count--;
                _combinations++;
            }
        }
    }

    // то же самое что и для deleteHorizontal...
    private function deleteVertical(i:int, j:int):void
    {
        var item:Jewel = _jewelsMap[i][j];
        var count:int = 0;
        var nextIndex:uint = i + 1;

        if (_jewelsMap[i].length <= nextIndex)
            return;

        var nextItem:Jewel = _jewelsMap[nextIndex][j];
        while (_jewelsMap[i].length-1 >= nextIndex && item.type == nextItem.type)
        {
            nextItem = _jewelsMap[nextIndex][j];
            nextIndex++;
            count++;
        }

        if (count >= 2)
        {
            // индекс кристала по вертикали, по которому будем делать сдвиг
            var verticalShiftIndex:int = i;
            while (count >= 0)
            {
                _jewelsMap[verticalShiftIndex][j].removeFromParent(true);
                shiftItemsAfterMath(verticalShiftIndex, j);

                _combinations++;
                verticalShiftIndex++;
                if(_needEmitter)
                    addEmmiter(verticalShiftIndex, j);
                count--;
            }
        }
    }

    // сдвигает все кристаллы сверху на одно место (которое мы перед этим удаляем)
    // и сверху добавляет один случайный кристалл
    private function shiftItemsAfterMath(i:int, j:int):void
    {
        var curI:int = i;
        // для всех элементов в столбике
        while (curI > 0)
        {
            curI--;
            if (_jewelsMap[curI][j] != undefined)
            {
                // берём предыдущий кристалл
                var prevItem:Jewel = _jewelsMap[curI][j];
                if (_jewelsMap[curI + 1] == null)
                    break;

                // и ставим его на место текущего
                _jewelsMap[curI + 1][j] = prevItem;
                prevItem.setPosition(curI + 1, j, _level.tileSize);
            }
        }

        // так как все кристалы сдвигаются на один по вертикали, остаётся одно пустое место ссверху, куда мы и добавляем рандомный кристал
        var randomItem:Jewel = Jewel.getRandomJewel();
        _jewelsMap[0][j] = randomItem;
        randomItem.x = (j * _level.tileSize) + _level.tileSize / 2;
        randomItem.y = - _level.tileSize * 2;
        addChild(randomItem);
        randomItem.setPosition(0, j, _level.tileSize);
    }

    // эммитер частиц для анимации удаления комбинаций кристалов
    private var _needEmitter:Boolean;
    private function addEmmiter(i:int, j:int):void
    {
        var pSystem:PDParticleSystem = new PDParticleSystem(_theme.getXML("particle"), _theme.getTexture("particle"));
        pSystem.emitterX = (j * _level.tileSize) + _level.tileSize/2;
        pSystem.emitterY = (i * _level.tileSize) + _level.tileSize/2 ;
        pSystem.start();
        addChild(pSystem);
        Starling.juggler.add(pSystem);

        var tween:Tween = new Tween(pSystem, 0.3);
        tween.onComplete = function():void
        {
            pSystem.stop();
            pSystem.removeFromParent(true);
            Starling.juggler.remove(pSystem);
            pSystem.removeFromParent(true);
        };
        tween.animate("alpha", 0);
        Starling.juggler.add(tween);
    }

    // проверка кристалов - являются ли они соседями
    private function isNearPlaced(currentJewel:Jewel, nextJewel:Jewel):Boolean
    {
        return ((nextJewel.raw == currentJewel.raw && ((nextJewel.col == currentJewel.col + 1) || (nextJewel.col == currentJewel.col - 1))) ||
                (nextJewel.col == currentJewel.col && ((nextJewel.raw == currentJewel.raw + 1) || (nextJewel.raw == currentJewel.raw - 1))));
    }

    // возвращает кристал по координатам области клика
    private function getJewelAt(x:Number, y:Number):Jewel
    {
        for (var i:int = 0; i < _level.cols; i++)
        {
            for (var j:int = 0; j < _level.rows; j++)
            {
                var jewel:Jewel = _jewelsMap[i][j];

                // если текущий кристал в поле клика - возвращаем его
                if (x <= (jewel.x + _level.tileSize/2) && (jewel.y + _level.tileSize/2) >= y)
                    return jewel;
            }
        }
        return null;
    }

    // увеличиваем очки на заданное число
    private function increaseScore(addScore:int):void
    {
        Command.execute(UserCommand.INCRESE_SCORE, addScore);
    }

    // начать заново (все кристалы удалить и заново заполнить новыми)
    public function restart():void
    {
        if(_jewelsMap)
        {
            for (var i:int = 0; i < _level.cols; i++)
            {
                for (var j:int = 0; j < _level.rows; j++)
                {
                    var jewel:Jewel = _jewelsMap[i][j];
                    if(jewel) jewel.removeFromParent(true);
                }
            }
        }

        _jewelsMap = new Vector.<Vector.<Jewel>>(_level.cols, true);

        for (var i:int = 0; i < _level.cols; i++)
        {
            _jewelsMap[i] = new Vector.<Jewel>(_level.rows, true);

            for (var j:int = 0; j < _level.rows; j++)
            {
                var jewel:Jewel = Jewel.getRandomJewel();
                jewel.x = (j * _level.tileSize) + _level.tileSize / 2 ;
                jewel.y = - _level.tileSize * 2;
                jewel.setPosition(i,j, _level.tileSize);
                addChild(jewel);

                _jewelsMap[i][j] = jewel;
            }
        }

        // как заполнили - ищем комбинации
        _needEmitter = false;
        findCombinations();
        _needEmitter = true;
    }
}
}
