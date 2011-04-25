package
{
    public class AI
    {
        public var guesses:Array;

        public function AI()
        {
            var gd:GameData = GameData.getInstance();
            gd.stage.addEventListener(GameEvent.GAME_STARTED, onGameStarted);
            gd.stage.addEventListener(GameEvent.GAME_RESET, onGameReset);
        }

        private function onGameStarted(event:GameEvent):void
        {
            createCode();
        }

        private function onGameReset(event:GameEvent):void
        {
            createCode();
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

        public function guessCode():Array
        {
            var guess:Array =
                guesses[Math.floor(Math.random() * guesses.length)]

            return guess;
        }

        public function reduceGuesses(
            guess:Array,
            correctPosition:uint,
            correctValue:uint):void
        {
            for(var g:uint = 0; g < guesses.length; g++)
            {
                var score:Array;
                score = Score.computeScore(guess, guesses[g]);
                if(score[0] != correctPosition && score[1] != correctValue)
                {
                    guesses.splice(g, 1);
                }
            }
        }

    }
}
