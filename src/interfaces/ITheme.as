package interfaces {
import starling.textures.Texture;

public interface ITheme
{
    function initAssets():void;
    function getTexture(id:String):Texture;
    function playSound(name:String):void
    function addTexture(name:String, texture:Texture):void
    function disposeTexture(name:String):void
    function getXML(name:String):XML
}
}
