package
{
    import flash.display.Sprite;

    public class Score extends Sprite
    {
        public const COLORS:Array = [
            0x000000,
            0xff0000,
            0xffff00
        ];

        public const POSITIONS:Array = [
            [-8, -8],
            [ 8, -8],
            [-8,  8],
            [ 8,  8]
        ];

        public var correctPosition:uint = 0;
        public var correctValues:uint = 0;

        public function Score()
        {
            setScore(0, 0);
        }

        public static function computeScore(
            code:Array,
            guess:Array):Array
        {
            var guessCopy:Array = new Array();
            var codeCopy:Array = new Array();

            var correctPosition:uint = 0;
            var correctValue:uint = 0;

            var i:uint;
            var j:uint;

            for(i = 0; i < guess.length; i++)
            {
                if(guess[i] == code[i])
                {
                    correctPosition++;
                }
                else
                {
                    guessCopy.push(guess[i]);
                    codeCopy.push(code[i]);
                }
            }


            for(i = 0; i < guessCopy.length; i++)
            {
                trace("checking for", guessCopy[i]);
                for(j = 0; j < codeCopy.length; j++)
                {
                    trace("looking at", codeCopy[j]);
                    if(guessCopy[i] == codeCopy[j])
                    {
                        correctValue++;
                        delete codeCopy[j];
                        //codeCopy.splice(j, 1);
                        break;
                    }
                }
            }

            return [correctPosition, correctValue];

        }

        public function setScore(
            correctPosition:uint,
            correctValues:uint):void
        {
            this.correctPosition = correctPosition;
            this.correctValues = correctValues;

            graphics.clear();
            var pipCount:uint = 0;

            var x:uint;

            for(x = 0; x < correctPosition; x++)
            {
                drawPip(1, pipCount);
                pipCount++;
            }

            for(x = 0; x < correctValues; x++)
            {
                drawPip(2, pipCount);
                pipCount++;
            }

            for(x = 0; x < 4 - (correctPosition + correctValues); x++)
            {
                drawPip(0, pipCount);
                pipCount++;
            }

        }

        private function drawPip(pipValue:uint, position:uint):void
        {
            var circleRadius:Number = 3;
            if(pipValue)
                circleRadius = 5;

            graphics.beginFill(COLORS[pipValue]);
            var x:int = POSITIONS[position][0];
            var y:int = POSITIONS[position][1];
            graphics.drawCircle(x, y, circleRadius);
        }
    }
}

