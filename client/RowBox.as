package
{

    import flash.display.Sprite;
    import flash.display.BitmapData;

    import starling.display.Sprite;
    import starling.textures.Texture;
    import starling.display.Image;
    import starling.events.Event;

    public class RowBox extends starling.display.Sprite
    {
        public var targetX:Number;
        public var targetY:Number;

        private var gd:GameData;
        private var spacing:uint;
        private var started:Boolean = false;

        public function RowBox(color:int = 0xa1bee6, spacing:uint = 20)
        {
            gd = GameData.getInstance();
            this.spacing = spacing;

            var box:flash.display.Sprite = new flash.display.Sprite();

            box.graphics.beginFill(color);
            box.graphics.drawRect(0, 0, 50 * gd._pips_per_row, 40);
            box.graphics.endFill();

            var bmd:BitmapData = new BitmapData(
                50 * gd._pips_per_row, 40, true, 0x000000);
            bmd.draw(box);

            var texture:Texture = Texture.fromBitmapData(bmd, false, false);
            var image:Image = new Image(texture);

            addChild(image);

            x = 240;
            y = gd.stage.stageHeight + 50;

            targetX = x;
            targetY = gd.currentRow * spacing + 15;

            gd.stage.addEventListener(
                GameEvent.GAME_ROW_FINISHED, onRowFinished);
            gd.stage.addEventListener(
                GameEvent.GAME_RESET, onGameReset);
            addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }

        private function onGameReset(event:GameEvent):void
        {
            onRowFinished(event);
        }

        private function onRowFinished(event:GameEvent):void
        {
            targetY = gd.currentRow * spacing + 15;
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
