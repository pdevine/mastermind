package
{
    import MovingPip;
    import Vector2D;
    import Menu;
    import GameEvent;

    import flash.display.Stage;
    import flash.text.TextField;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.net.NetConnection;

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
        public const VPIXELBUF:uint = 20;

        private var _pip:MovingPip;
        private var _pips:Array;

        public var myLabel:Label;
        public var wander:Boolean = true;

        public var gd:GameData;

        public function Game ()
        {
            gd = GameData.getInstance();

            _pips = new Array();

            addEventListener(
                starling.events.Event.ADDED_TO_STAGE,
                onAddedToStage);
            addEventListener(starling.events.Event.ENTER_FRAME, onEnterFrame);
        }

        private function onAddedToStage(event:starling.events.Event):void
        {
            gd.stage = stage;
            gd.nativeStage = Starling.current.nativeStage;

            for(var i:int = 0; i < 60; i++)
            {
                _pip = new MovingPip();
                _pip.position = new Vector2D(
                    Math.random() * stage.stageWidth,
                    Math.random() * stage.stageHeight);
                _pip.velocity = new Vector2D(
                    Math.random() * 20 - 10,
                    Math.random() * 20 - 10);

                addChild(_pip);
                _pips.push(_pip);
            }

            gd.netConnection = new NetConnection();
            gd.netConnection.connect("http://192.168.137.159:8080");

            var myMenu:Menu = new Menu();
            gd.nativeStage.addChild(myMenu);

            gd.nativeStage.addEventListener(
                GameEvent.GAME_SELECTED,
                onGameSelected);
        }

        private function onEnterFrame(event:starling.events.Event):void
        {
            for(var i:int = 0; i < _pips.length; i++)
            {
                if(_pips[i].destination)
                    _pips[i].arrive(_pips[i].destination);
                else
                    _pips[i].wander();

                _pips[i].update();
            }
        }

        private function onGameSelected(event:GameEvent):void
        {
            trace("game selected!");

            gd.guesses = new Array();
            gd.scores = new Array();
            gd.code = new Array();

            var _pip_count:uint = 0;
            var row:Array;

            trace("stage height: ");
            trace(gd.stage.stageHeight);

            var vSpacing:uint = 
                (gd.stage.stageHeight - VPIXELBUF) / (gd._total_rows + 1);

            for(var j:int = 0; j < gd._total_rows; j++)
            {
                row = new Array();
                for(var i:int = 0; i < gd._pips_per_row; i++)
                {
                    _pips[_pip_count].destination = 
                        new Vector2D(
                            50 * i + 250,
                            j * vSpacing + VPIXELBUF);
                    _pip_count++;
                    row.push(_pips[_pip_count]);
                }
                gd.guesses.push(row);
            }

            for(j = 0; j < gd._pips_per_row; j++)
            {
                _pips[_pip_count].destination =
                    new Vector2D(
                        50 * j + 250,
                        gd._total_rows * vSpacing + VPIXELBUF);
                _pips[_pip_count].showValue = false;
                _pip_count++;
                gd.code.push(_pips[_pip_count]);
            }

            //wander = !wander;
        }

    }
}

