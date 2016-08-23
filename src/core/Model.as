package core {
import flash.utils.Dictionary;

public class Model
{
    static private var _modelInterfaceToModelClassMap:Dictionary = new Dictionary(true);
    static private var _modelInterfaceToModelInstanceMap:Dictionary = new Dictionary(true);

    static public function register(modelInterface:Class, modelConcreteClass:Class):void
    {
        if(isInterface(modelInterface))
        {
            _modelInterfaceToModelClassMap[modelInterface] = modelConcreteClass;
        }
    }

    static public function getModel(modelInterface:Class):Object
    {
        var modelConcreteClass:Class = _modelInterfaceToModelClassMap[modelInterface];
        if(!modelConcreteClass)
        {
            throw new Error("There no model class mapping for this interface!");
        }
        else
        {
            var model:Object = _modelInterfaceToModelInstanceMap[modelInterface];
            if(!model)
            {
                model = new modelConcreteClass();
                if(!(model is modelInterface)) throw new Error("Model class must implement model interface!");
                _modelInterfaceToModelInstanceMap[modelInterface] = model;
            }
            return model;
        }
        return null;
    }

    static private function isInterface(object:Object):Boolean
    {
        try {new object();}
        catch (e:VerifyError)   {return true;}       // object is interface
        catch (e:Error)         {return false;}      // object is instance of some class
        return false;  // object is class
    }
}
}
