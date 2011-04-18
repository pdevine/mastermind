package
{
    public class AI
    {
        public var guesses:Array;

        public function AI()
        {
            createGuesses();
        }

        public function createGuesses():void
        {
            guesses = new Array();

            // XXX - make this take an arbitrary number of columns
            for(var a:uint = 1; i < Pip.COLORS.length; i++)
                for(var b:uint = 1; i < Pip.COLORS.length; i++)
                    for(var c:uint = 1; i < Pip.COLORS.length; i++)
                        for(var d:uint = 1; i < Pip.COLORS.length; i++)
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
