package
{
    import MovingPip;
    import Vector2D;
    import Menu;

    import flash.display.Stage;
    import flash.text.TextField;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import com.bit101.components.Component;
    import com.bit101.components.List;
    import com.bit101.components.Label;
    import com.bit101.utils.MinimalConfigurator;

    import starling.core.Starling;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.TouchEvent;

    public class Game extends Sprite
    {
        private var _pip:MovingPip;
        private var _pips:Array;

        public var myLabel:Label;

        public function Game ()
        {
            _pips = new Array();

            addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
            addEventListener(starling.events.Event.ENTER_FRAME, onEnterFrame);
        }

        private function onAddedToStage(event:starling.events.Event):void
        {
            for(var i:int = 0; i < 50; i++)
            {
                _pip = new MovingPip();
                _pip.position = new Vector2D(Math.random() * stage.stageWidth, Math.random() * stage.stageHeight);
                _pip.velocity = new Vector2D(Math.random() * 20 - 10, Math.random() * 20 - 10);

                addChild(_pip);
                _pips.push(_pip);
            }

            var nativeStage:flash.display.Stage;
            nativeStage = Starling.current.nativeStage;

            var myMenu:Menu = new Menu(nativeStage);
            nativeStage.addChild(myMenu);

        }

        private function onEnterFrame(event:starling.events.Event):void
        {
            for(var i:int = 0; i < _pips.length; i++)
            {
                //_pips[i].flock(_pips);
                _pips[i].wander();
                _pips[i].update();
            }
        }

    }
}

