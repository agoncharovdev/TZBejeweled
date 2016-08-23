package interfaces {
public interface IUser
{
    function increaseScore(value:int):void;
    function get score():int;
    function get level():ILevel
}
}
