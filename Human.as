package
{
    import flash.events.MouseEvent;

    public class Human
    {
        public function Human()
        {
            var gd:GameData = GameData.getInstance();
            gd.stage.addEventListener(GameEvent.GAME_STARTED, onGameStarted);
            gd.stage.addEventListener(GameEvent.GAME_RESET, onGameReset);
        }

        private function onGameStarted(event:GameEvent):void
        {
            trace("HUMAN: onGameStarted");
            var gd:GameData = GameData.getInstance();

            if(gd.player == GameData.PLAYER_HUMAN)
            {
                gd.stage.addEventListener(
                    GameEvent.GAME_ROW_CHANGED, onRowChange);
            }
            else
                setCodeRowActive();

        }

        private function onGameReset(event:GameEvent):void
        {
            trace("HUMAN: onGameReset");
            var gd:GameData = GameData.getInstance();

            if(gd.player == GameData.PLAYER_HUMAN)
            {
                onRowChange(event);
            }
            else
                setCodeRowActive();
        }

        private function setCodeRowActive():void
        {
            trace("HUMAN: setCodeRowActive");
            var gd:GameData = GameData.getInstance();

            for(var i:uint = 0; i < gd.code.length; i++)
            {
                gd.code[i].showValue = false;
                gd.code[i].addEventListener(MouseEvent.MOUSE_DOWN, onCodeClick);
            }
        }

        private function onRowChange(event:GameEvent):void
        {
            trace("HUMAN: onRowChange");
            var gd:GameData = GameData.getInstance();

            for(var i:uint = 0; i < gd.guesses[gd.currentRow].length; i++)
            {
                gd.guesses[gd.currentRow][i].addEventListener(
                    MouseEvent.MOUSE_DOWN, onPipClick);
            }

        }

        private function onPipClick(event:MouseEvent):void
        {
            var gd:GameData = GameData.getInstance();
            var i:uint;

            event.target.value = gd.currentValue;

            var guessedRow:Boolean = true;

            for(i = 0; i < gd.guesses[gd.currentRow].length; i++)
            {
                if(!gd.guesses[gd.currentRow][i].value)
                {
                    guessedRow = false;
                    break;
                }
            }

            trace("Guessed row:", guessedRow);

            if(guessedRow)
            {
                for(i = 0; i < gd.guesses[gd.currentRow].length; i++)
                {
                    gd.guesses[gd.currentRow][i].removeEventListener(
                        MouseEvent.MOUSE_DOWN, onPipClick)
                }

                gd.stage.dispatchEvent(
                    new GameEvent(GameEvent.GAME_ROW_FINISHED));

            }
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

                gd.stage.dispatchEvent(
                    new GameEvent(GameEvent.GAME_CODE_SET));

            }
        }


    }
}
