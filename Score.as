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

        public function Score()
        {
            setScore(0, 0);
        }

        public function setScore(
            correctPosition:uint,
            correctValues:uint):void
        {
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
            graphics.beginFill(COLORS[pipValue]);
            var x:int = POSITIONS[position][0];
            var y:int = POSITIONS[position][1];
            trace("color=", COLORS[pipValue]);
            trace("x=", x, "y=", y);
            graphics.drawCircle(x, y, 3);
        }
    }
}

