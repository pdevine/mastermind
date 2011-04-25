package
{

    import flash.display.Sprite;
    import flash.events.Event;

    public class RowBox extends Sprite
    {
        public var targetX:Number;
        public var targetY:Number;

        public function RowBox(color:int = 0xa1bee6)
        {
            var gd:GameData = GameData.getInstance();

            graphics.beginFill(color);
            graphics.drawRect(0, 0, 50 * gd.codeLength, 30);
            graphics.endFill();

            x = 45;
            y = gd.currentRow * 40 + 10;

            targetX = x;
            targetY = y;

            gd.stage.addEventListener(
                GameEvent.GAME_ROW_FINISHED, onRowFinished);
            gd.stage.addEventListener(
                GameEvent.GAME_RESET, onGameReset);
        }

        private function onGameReset(event:GameEvent):void
        {
            onRowFinished(event);
        }

        private function onRowFinished(event:GameEvent):void
        {
            var gd:GameData = GameData.getInstance();
            targetY = gd.currentRow * 40 + 10;
            addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }

        private function onEnterFrame(event:Event):void
        {
            var dx:Number = (targetX - x);
            var dy:Number = (targetY - y);

            x += dx * 0.2;
            y += dy * 0.2;

            if(Math.sqrt(dx*dx + dy*dy) < 1)
            {
                x = targetX;
                y = targetY;

                removeEventListener(Event.ENTER_FRAME, onEnterFrame);
            } 

        }
    }
}
