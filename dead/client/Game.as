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

        private var rowBox:Sprite;

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

            var pip_count:uint = 0;
            var row:Array;

            // determine if we need to add/remove any balls
            var needed_pips:int = 
                gd._pips_per_row * gd._total_rows - gd.pips.length;
            addPips(needed_pips);

            trace("stage height: ");
            trace(gd.stage.stageHeight);


            // assign a location for each of our pips
            for(var j:int = 0; j < gd._total_rows; j++)
            {
                row = new Array();
                for(var i:int = 0; i < gd._pips_per_row; i++)
                {
                    gd.pips[pip_count].destination = 
                        new Vector2D(
                            50 * i + 250,
                            j * vSpacing() + VPIXELBUF);
                    row.push(gd.pips[pip_count]);
                    pip_count++;
                }
                gd.guesses.push(row);
            }

            // Add in the code pips

            var pip:MovingPip;

            for(j = 0; j < gd._pips_per_row; j++)
            {
                pip = new MovingPip();
                pip.showValue = false;
                pip.edgeBehavior = Pip.IGNORE;
                
                pip.position =
                    new Vector2D(
                        50 * j + 250,
                        stage.stageHeight + 200 + (j * 70))

                pip.destination =
                    new Vector2D(
                        50 * j + 250,
                        gd._total_rows * vSpacing() + VPIXELBUF);

                addChild(pip);
                gd.pips.push(pip);
                gd.code.push(pip);

            }

            gd.stage.dispatchEvent(new GameEvent(GameEvent.GAME_STARTED));
            gd.stage.dispatchEvent(new GameEvent(GameEvent.GAME_ROW_CHANGED));
            gd.stage.addEventListener(
                GameEvent.GAME_ROW_FINISHED, onRowFinished);

            rowBox = new RowBox(0xa1bee6, vSpacing());
            addChildAt(rowBox, 0);
        }

        public function vSpacing():int
        {
            return (gd.stage.stageHeight - VPIXELBUF) / (gd._total_rows + 1);
        }

        private function onRowFinished(event:GameEvent):void
        {
            gd.currentRow++;
            gd.stage.dispatchEvent(new GameEvent(GameEvent.GAME_ROW_CHANGED));
        }
    }
}

