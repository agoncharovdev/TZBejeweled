package theme {
import assets.EmbeddedAssets;

import core.Notificator;

import flash.media.Sound;

import interfaces.ITheme;

import starling.textures.Texture;

import starling.utils.AssetManager;

public class ThemeModel implements ITheme
{
    [Embed(source="../assets/particle.pex",mimeType="application/octet-stream")]
    private static const particle:Class;
    [Embed(source="../assets/atlas.xml",mimeType="application/octet-stream")]
    private static const atlasXML:Class;
    [Embed(source="../assets/atlas.png")]
    private static const atlasPNG:Class;
    [Embed(source="../assets/click.mp3")]
    public static const click:Class;

    static public const THEME_CREATED:String = "ThemeModel.THEME_CREATED";

    static public const SOUND_CLICK:String = "ThemeModel.SOUND_CLICK";

    private var _assetManager:AssetManager;

    public function initAssets():void
    {
        _assetManager = new AssetManager();
        _assetManager.enqueue("assets/particle.pex", "assets/atlas.xml", "assets/atlas.png", "assets/click.mp3");
        _assetManager.loadQueue(onAssetsLoadProgess);
    }

    public function getTexture(name:String):Texture
    {
        return _assetManager.getTexture(name);
    }

    public function getXML(name:String):XML
    {
        return _assetManager.getXml(name);
    }

    public function addTexture(name:String, texture:Texture):void
    {
        _assetManager.addTexture(name, texture);
    }

    public function disposeTexture(name:String):void
    {
        _assetManager.removeTexture(name, true);
    }

    public function playSound(name:String):void
    {
        var sound:Sound = _assetManager.getSound(name);
        if(sound)
        {
            sound.play();
        }
    }

    private function onAssetsLoadProgess(progress:Number):void
    {
        if(progress < 1)
            return;

        Notificator.broadcast(THEME_CREATED);
    }
}
}
