package
{
    import flash.display.Sprite;
    import flash.display.Graphics;

    public class Pip extends Sprite
    {
        private var _value:int = 0;
        private var _showValue:Boolean;
        private var _selected:Boolean = false;

/*
        public static const COLORS:Array = [
            0x000000,
            0xff0000,
            0xff9900,
            0xffff00, 
            0x00ff00,
            0x0000ff,
            0x4b0082,
            0xae8ceb
        ];
*/

        public static const COLORS:Array = [
            0xecd078,
            0xd95b43,
            0xc02942,
            0x542437,
            0x53777a,
            0x9ead6a,
            0xe3933c,
            0xce30c3,
        ];

        public static const RED:uint = 1;
        public static const ORANGE:uint = 2;
        public static const YELLOW:uint = 3;
        public static const GREEN:uint = 4;
        public static const BLUE:uint = 5;
        public static const INDIGO:uint = 6;
        public static const VIOLET:uint = 7;


        public function Pip(pipValue:uint = 0, _showValue:Boolean = true)
        {
            this._showValue = _showValue;
            value = pipValue;
        }

        public function get value():uint
        {
            return _value;
        }

        private function drawEmptyPip():void
        {
            graphics.clear();
            graphics.beginFill(0xb0b0b0);
            graphics.drawCircle(0, 0, 5);
            graphics.endFill();
        }

        private function drawColoredPip():void
        {
            graphics.clear();
            graphics.beginFill(COLORS[_value]);
            graphics.drawCircle(0, 0, 10);
            graphics.endFill();

            if(_selected)
            {
                graphics.lineStyle(1);
                graphics.drawCircle(0, 0, 10);
            }
        }

        private function drawX():void
        {
            graphics.clear();

            graphics.beginFill(0xffffff);
            graphics.drawRect(-5, -5, 10, 10);
            graphics.endFill();

            graphics.lineStyle(1);
            graphics.beginFill(0x000000);
            graphics.moveTo(-5, -5);
            graphics.lineTo(5, 5);
            graphics.moveTo(-5, 5);
            graphics.lineTo(5, -5);
            graphics.endFill();
        }

        public function set showValue(b:Boolean):void
        {
            _showValue = b;

            if(_showValue)
                drawColoredPip();
            else
                drawX();
        }

        public function set value(pipValue:uint):void
        {
            _value = pipValue;

            graphics.clear();

            if(!pipValue)
                drawEmptyPip();
            else
            {
                if(_showValue)
                    drawColoredPip();
                else
                    drawX();
            }
        }

        public function set selected(b:Boolean):void
        {
            _selected = b;
            drawColoredPip();
        }
    }

}
