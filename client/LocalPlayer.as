package
{
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.events.Touch;

    public class LocalPlayer
    {
        private var gd:GameData;

        public function LocalPlayer()
        {
            gd = GameData.getInstance();
            gd.stage.addEventListener(GameEvent.GAME_STARTED, onGameStarted);
        }

        private function onGameStarted(event:GameEvent):void
        {
            trace("LocalPlayer: onGameStarted");
            gd.stage.addEventListener(
                GameEvent.GAME_ROW_CHANGED, onRowChange);
        }

        private function onRowChange(event:GameEvent):void
        {
            trace("LocalPlayer: onRowChange");

            for(var i:uint = 0; i < gd.guesses[gd.currentRow].length; i++)
            {
                trace("adding pip " + gd.guesses[gd.currentRow][i]);

                gd.guesses[gd.currentRow][i].addEventListener(
                    TouchEvent.TOUCH, onPipClick);
            }
        }

        private function onPipClick(event:TouchEvent):void
        {
            var touch:Touch = event.getTouch(gd.stage);
            if(touch.phase != TouchPhase.BEGAN)
                return;

            var guessedRow:Boolean = true;

            trace("Pip click!");
            trace("target: " + event.target);
            trace("currentTarget: " + event.currentTarget);

            var pip:MovingPip = event.currentTarget as MovingPip;

            // set whatever pip was clicked to the current selected value
            //event.currentTarget._pipValue = gd.currentValue;
            pip.pipValue = gd.currentValue;

            for(var i:uint = 0; i < gd.guesses[gd.currentRow].length; i++)
            {
                if(!gd.guesses[gd.currentRow][i].pipValue)
                {
                    guessedRow = false;
                    break;
                }
            }

            if(guessedRow)
            {
                for(i = 0; i < gd.guesses[gd.currentRow].length; i++)
                {
                    gd.guesses[gd.currentRow][i].removeEventListener(
                        TouchEvent.TOUCH, onPipClick);
                }

                gd.stage.dispatchEvent(
                    new GameEvent(GameEvent.GAME_ROW_FINISHED));
            }

        }

    }
}
