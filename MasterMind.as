package
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;

    public class MasterMind extends Sprite
    {
        public const Rows:int = 8;
        public const CodeLength:int = 4;

        public var guesses:Array;
        public var scores:Array;

        public var currentRow:uint = 0;
        public var currentValue:uint = 1;

        public function MasterMind()
        {
            init();

        }

        private function init():void
        {
            createSelectionBox();

            guesses = new Array();
            scores = new Array();

            var pip:Pip;
            var row:Array;

            for(var j:uint = 0; j < Rows; j++)
            {

                row = new Array();
                for(var i:int = 0; i < CodeLength; i++)
                {
                    pip = new Pip();
                    pip.x = 50 * i + 50;
                    pip.y = j * 40 + 25;

                    addChild(pip);
                    row.push(pip);
                }

                var score:Score = new Score();
                score.x = 50 * CodeLength + 100;
                score.y = j * 40 + 25;
                addChild(score);

                guesses.push(row);
                scores.push(score);
            }
            setRowActive();
        }

        private function createSelectionBox():void
        {
            var y:Number = 20;

            for(var i:uint = 1; i < Pip.COLORS.length; i++)
            {

                var pip:Pip = new Pip(i);
                pip.x = 10;
                pip.y = i * 30 + 20;
                
                pip.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
                addChild(pip);
                
            }
            
        }

        private function setRowActive():void
        {
            var i:uint = 0;

            if(currentRow > 0)
            {
                for(i = 0; i < guesses[currentRow-1].length; i++)
                {
                    guesses[currentRow-1][i].removeEventListener(
                        MouseEvent.MOUSE_DOWN, onPipClick)
                }
            }

            for(i = 0; i < guesses[currentRow].length; i++)
            {
                guesses[currentRow][i].addEventListener(
                    MouseEvent.MOUSE_DOWN, onPipClick);
                
            }
        }

        private function onMouseDown(event:MouseEvent):void
        {
            currentValue = event.target.value;
            trace("Set value to:", currentValue);
        }

        private function onPipClick(event:MouseEvent):void
        {
            event.target.value = currentValue;

            var guessedRow:Boolean = true;

            for(var i:uint = 0; i < guesses[currentRow].length; i++)
            {
                if(!guesses[currentRow][i].value)
                {
                    guessedRow = false;
                    break;
                }
            }

            if(guessedRow)
            {
                currentRow++;
                setRowActive();
            }
        }
    }
}
