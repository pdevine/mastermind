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

        private var gd:GameData;
        private var localPlayer:LocalPlayer;

        public function Game ()
        {
            gd = GameData.getInstance();

            gd.pips = new Array();

            addEventListener(
                starling.events.Event.ADDED_TO_STAGE,
                onAddedToStage);
            addEventListener(starling.events.Event.ENTER_FRAME, onEnterFrame);
        }

        // add or remove a given quantity of pips from the pip array
        private function addPips(totalPips:int):void
        {
            var pip:MovingPip;

            trace("adding ", totalPips, " pips");

            for(var i:int = 0; i < Math.abs(totalPips); i++)
            {
                if(totalPips > 0)
                {
                    pip = new MovingPip();
                    pip.position = new Vector2D(
                        Math.random() * stage.stageWidth,
                        Math.random() * stage.stageHeight);
                    pip.velocity = new Vector2D(
                        Math.random() * 20 - 10,
                        Math.random() * 20 - 10);

                    addChild(pip);
                    gd.pips.push(pip);
                } else if(totalPips < 0)
                {
                    pip = gd.pips.pop();
                    removeChild(pip);
                }
            }
        }


        private function onAddedToStage(event:starling.events.Event):void
        {
            gd.stage = stage;
            gd.nativeStage = Starling.current.nativeStage;

            addPips(100);

            gd.netConnection = new NetConnection();
            gd.netConnection.connect("http://192.168.137.159:8080");

            localPlayer = new LocalPlayer();

            var myMenu:Menu = new Menu();
            gd.nativeStage.addChild(myMenu);

            gd.stage.addEventListener(
                GameEvent.GAME_SELECTED,
                onGameSelected);
        }

        private function onEnterFrame(event:starling.events.Event):void
        {
            for(var i:int = 0; i < gd.pips.length; i++)
            {
                if(gd.pips[i].destination)
                    gd.pips[i].arrive(gd.pips[i].destination);
                else
                    gd.pips[i].wander();

                gd.pips[i].update();
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

            // determine if we need to add/remove any balls
            var needed_pips:int = 
                gd._pips_per_row * gd._total_rows - gd.pips.length;
            addPips(needed_pips);

            trace("stage height: ");
            trace(gd.stage.stageHeight);

            var vSpacing:uint = 
                (gd.stage.stageHeight - VPIXELBUF) / (gd._total_rows + 1);

            // assign a location for each of our pips
            for(var j:int = 0; j < gd._total_rows; j++)
            {
                row = new Array();
                for(var i:int = 0; i < gd._pips_per_row; i++)
                {
                    gd.pips[_pip_count].destination = 
                        new Vector2D(
                            50 * i + 250,
                            j * vSpacing + VPIXELBUF);
                    _pip_count++;
                    row.push(gd.pips[_pip_count]);
                }
                gd.guesses.push(row);
            }

            // Add in the code pips

            var _pip:MovingPip;

            for(j = 0; j < gd._pips_per_row; j++)
            {
                _pip = new MovingPip();
                _pip.showValue = false;
                _pip.edgeBehavior = Pip.IGNORE;
                
                _pip.position =
                    new Vector2D(
                        50 * j + 250,
                        stage.stageHeight + 200 + (j * 70))

                _pip.destination =
                    new Vector2D(
                        50 * j + 250,
                        gd._total_rows * vSpacing + VPIXELBUF);

                addChild(_pip);
                gd.pips.push(_pip);
                gd.code.push(_pip);

            }

            gd.stage.dispatchEvent(new GameEvent(GameEvent.GAME_STARTED));
            gd.stage.dispatchEvent(new GameEvent(GameEvent.GAME_ROW_CHANGED));
        }

    }
}

