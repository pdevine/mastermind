package
{
    public class AI
    {
        public var guesses:Array;
        public var lastGuess:Array;

        public function AI()
        {
            var gd:GameData = GameData.getInstance();
            gd.stage.addEventListener(GameEvent.GAME_STARTED, onGameStarted);
            gd.stage.addEventListener(GameEvent.GAME_RESET, onGameReset);

            lastGuess = new Array();
        }

        private function onGameStarted(event:GameEvent):void
        {
            onGameReset(event);
        }

        private function onGameReset(event:GameEvent):void
        {
            var gd:GameData = GameData.getInstance();

            if(gd.player == GameData.PLAYER_HUMAN)
                createCode();
            else
            {
                createGuesses();
                gd.stage.addEventListener(
                    GameEvent.GAME_CODE_SET, onCodeSet);
            }
        }

        public static function createCode():void
        {
            var gd:GameData = GameData.getInstance();

            trace("Code set to:");
            for(var i:uint = 0; i < gd.codeLength; i++)
            {
                gd.code[i].showValue = false;
                gd.code[i].value =
                    Math.floor(Math.random() * (Pip.COLORS.length-1)) + 1;
            }

        }

        public function createGuesses():void
        {
            guesses = new Array();

            // XXX - make this take an arbitrary number of columns
            for(var a:uint = 1; a < Pip.COLORS.length; a++)
                for(var b:uint = 1; b < Pip.COLORS.length; b++)
                    for(var c:uint = 1; c < Pip.COLORS.length; c++)
                        for(var d:uint = 1; d < Pip.COLORS.length; d++)
                            guesses.push([a, b, c, d]);
        }

        private function onCodeSet(event:GameEvent):void
        {
            trace("AI: onCodeSet");
            var gd:GameData = GameData.getInstance();

            gd.stage.addEventListener(
                GameEvent.GAME_ROW_CHANGED, onRowChanged);
            gd.stage.removeEventListener(GameEvent.GAME_CODE_SET, onCodeSet);

            onRowChanged(event);

        }

        private function onRowChanged(event:GameEvent):void
        {
            trace("AI: onRowChanged");
            var gd:GameData = GameData.getInstance();

            if(gd.currentRow > 0)
            {
                var lastScore:Score = gd.scores[gd.currentRow-1];
                reduceGuesses(
                    lastGuess,
                    lastScore.correctPosition,
                    lastScore.correctValues);
            }

            var guess:Array = guessCode();
            for(var i:uint; i < gd.guesses[gd.currentRow].length; i++)
            {
                gd.guesses[gd.currentRow][i].value = guess[i];
                lastGuess[i] = guess[i];
            }

            gd.stage.dispatchEvent(new GameEvent(GameEvent.GAME_ROW_FINISHED));

        }

        public function guessCode():Array
        {
            var guess:Array =
                guesses[Math.floor(Math.random() * guesses.length)]

            return guess;
        }

        public function reduceGuesses(
            guess:Array,
            correctPosition:uint,
            correctValues:uint):void
        {
            var newGuesses:Array = new Array();

            for(var g:uint = 0; g < guesses.length; g++)
            {
                var score:Array;
                score = Score.computeScore(guess, guesses[g]);
                if(score[0] == correctPosition && score[1] == correctValues)
                    newGuesses.push(guesses[g]);
            }

            guesses = newGuesses;
        }

    }
}
