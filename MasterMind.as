package
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;

    public class MasterMind extends Sprite
    {
        public var computer:AI;
        public var human:Human;

        public function MasterMind()
        {
            init();

        }

        private function init():void
        {
            var gd:GameData = GameData.getInstance();

            gd.stage = stage;

            computer = new AI();
            human = new Human();

            createSelectionBox();

            var resetButton:Reset = new Reset();
            resetButton.x = 10;
            resetButton.y = 10;
            resetButton.addEventListener(MouseEvent.MOUSE_DOWN, onReset);
            addChild(resetButton);

            var toggleButton:Toggle = new Toggle();
            toggleButton.x = 10;
            toggleButton.y = 290;
            addChild(toggleButton);

            gd.guesses = new Array();
            gd.scores = new Array();

            var pip:Pip;
            var row:Array;

            for(var j:uint = 0; j < gd.rows; j++)
            {

                row = new Array();
                for(var i:int = 0; i < gd.codeLength; i++)
                {
                    pip = new Pip();
                    pip.x = 50 * i + 70;
                    pip.y = j * 40 + 25;

                    addChild(pip);
                    row.push(pip);
                }

                var score:Score = new Score();
                score.x = 50 * gd.codeLength + 100;
                score.y = j * 40 + 25;
                addChild(score);

                gd.guesses.push(row);
                gd.scores.push(score);
            }

            gd.code = new Array();

            for(i = 0; i < gd.codeLength; i++)
            {
                pip = new Pip(0, false);
                pip.x = 50 * i + 70;
                pip.y = gd.rows * 40 + 25;
                addChild(pip);
                gd.code.push(pip);
            }

            gd.stage.dispatchEvent(new GameEvent(GameEvent.GAME_STARTED));
            gd.stage.dispatchEvent(new GameEvent(GameEvent.GAME_ROW_CHANGED));
            gd.stage.addEventListener(
                GameEvent.GAME_ROW_FINISHED, onRowFinished);

            //createCode();
            //setRowActive();
            //setCodeRowActive();
        }


        private function createSelectionBox():void
        {
            var y:Number = 20;

            for(var i:uint = 1; i < Pip.COLORS.length; i++)
            {

                var pip:Pip = new Pip(i, true);
                pip.x = 10;
                pip.y = i * 30 + 20;
                
                pip.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
                addChild(pip);
                
            }
            
        }

        private function setRowActive():void
        {
            var gd:GameData = GameData.getInstance();

            stage.dispatchEvent(new GameEvent(GameEvent.GAME_ROW_CHANGED));

            // XXX - this is silly.  add it to a new class
            //var rowBox:Sprite = new Sprite();

            //rowBox.graphics.beginFill(0xa1bee6);
            //rowBox.graphics.drawRect(0, 0, 50 * gd.codeLength, 30);
            //rowBox.graphics.endFill();
            //rowBox.x = 45;
            //rowBox.y = gd.currentRow * 40 + 10;
            //addChildAt(rowBox, 0);
        }

        private function onReset(event:MouseEvent):void
        {
            var gd:GameData = GameData.getInstance();

            trace("reset!");
            graphics.clear();
            gd.currentRow = 0;
            gd.currentValue = 1;

            for(var r:uint = 0; r < gd.rows; r++)
            {
                for(var c:uint = 0; c < gd.guesses[r].length; c++)
                {
                    gd.guesses[r][c].value = 0;
                }
                gd.scores[r].setScore(0, 0);
            }

            stage.dispatchEvent(new GameEvent("gameReset"));

            //createCode();

            // clean up the pip bar
            //setRowActive();
        }

        private function onMouseDown(event:MouseEvent):void
        {
            var gd:GameData = GameData.getInstance();

            gd.currentValue = event.target.value;
            trace("Set value to:", gd.currentValue);
        }


        private function onRowFinished(event:GameEvent):void
        {
            var gd:GameData = GameData.getInstance();

            var guess:Array = new Array();
            var codeValues:Array = new Array();
            var guessText:String = new String();
            var codeText:String = new String();
            for(var i:uint = 0; i < gd.guesses[gd.currentRow].length; i++)
            {
                guess.push(gd.guesses[gd.currentRow][i].value);
                codeValues.push(gd.code[i].value);
                guessText += guess[guess.length-1];
                codeText += codeValues[codeValues.length-1];
            }

            trace("guess is:", guessText);
            trace("code is:", codeText);

            var score:Array = Score.computeScore(guess, codeValues);
            trace("score = ", score[0], score[1]);
            gd.scores[gd.currentRow].setScore(score[0], score[1]);

            if(score[0] == 4)
                gameOver();
            else
            {
                gd.currentRow++;
                if(gd.currentRow == gd.rows)
                    gameOver();
                else
                    setRowActive();
            }
        }

        private function gameOver():void
        {
            var gd:GameData = GameData.getInstance();

            for(var i:uint = 0; i < gd.code.length; i++)
                gd.code[i].showValue = true;

            stage.dispatchEvent(new GameEvent("gameOver"));
        }
    }
}
