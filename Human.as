package
{
    import flash.events.MouseEvent;

    public class Human
    {
        public function Human()
        {
            var gd:GameData = GameData.getInstance();
            gd.stage.addEventListener(GameEvent.GAME_RESET, onGameReset);
            gd.stage.addEventListener(GameEvent.GAME_ROW_CHANGED, onRowChange);
            gd.stage.addEventListener(
                GameEvent.GAME_ROW_FINISHED, onRowFinished);
        }

        private function onGameReset(event:GameEvent):void
        {
            onRowChange(event);
        }

        private function setCodeRowActive():void
        {
            var gd:GameData = GameData.getInstance();

            for(var i:uint = 0; i < gd.code.length; i++)
            {
                gd.code[i].showValue = false;
                gd.code[i].addEventListener(MouseEvent.MOUSE_DOWN, onCodeClick);
            }
        }

        private function onRowChange(event:GameEvent):void
        {
            var gd:GameData = GameData.getInstance();

            for(var i:uint = 0; i < gd.guesses[gd.currentRow].length; i++)
            {
                gd.guesses[gd.currentRow][i].addEventListener(
                    MouseEvent.MOUSE_DOWN, onPipClick);
            }
        }

        private function onRowFinished(event:GameEvent):void
        {
            var gd:GameData = GameData.getInstance();

            for(var i:uint = 0; i < gd.guesses[gd.currentRow].length; i++)
            {
                gd.guesses[gd.currentRow][i].removeEventListener(
                    MouseEvent.MOUSE_DOWN, onPipClick)
            }
        }

        private function onPipClick(event:MouseEvent):void
        {
            var gd:GameData = GameData.getInstance();

            event.target.value = gd.currentValue;

            var guessedRow:Boolean = true;

            for(var i:uint = 0; i < gd.guesses[gd.currentRow].length; i++)
            {
                if(!gd.guesses[gd.currentRow][i].value)
                {
                    guessedRow = false;
                    break;
                }
            }

            if(guessedRow)
                gd.stage.dispatchEvent(
                    new GameEvent(GameEvent.GAME_ROW_FINISHED));

        }

        private function onCodeClick(event:MouseEvent):void
        {
            var gd:GameData = GameData.getInstance();

            event.target.value = gd.currentValue;
            event.target.showValue = true;

            var codeSet:Boolean = true;

            for(var i:uint = 0; i < gd.code.length; i++)
            {
                if(!gd.code[i].value)
                {
                    codeSet = false;
                    break;
                }
            }

            if(codeSet)
            {
                for(i = 0; i < gd.code.length; i++)
                {
                    gd.code[i].removeEventListener(
                        MouseEvent.MOUSE_DOWN,
                        onCodeClick);
                }


            }
        }


    }
}
