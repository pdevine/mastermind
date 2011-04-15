package
{
    import flash.display.Sprite;
    import flash.display.Graphics;

    public class Pip extends Sprite
    {
        public var _value:int = 0;

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

        public static const RED:uint = 1;
        public static const ORANGE:uint = 2;
        public static const YELLOW:uint = 3;
        public static const GREEN:uint = 4;
        public static const BLUE:uint = 5;
        public static const INDIGO:uint = 6;
        public static const VIOLET:uint = 7;

        public function Pip(pipValue:uint = 0)
        {
            value = pipValue;
        }

        public function get value():uint
        {
            return _value;
        }

        public function set value(pipValue:uint):void
        {
            _value = pipValue;

            graphics.clear();

            if(!pipValue)
            {
                graphics.beginFill(0xb0b0b0);
                graphics.drawCircle(0, 0, 5);
                graphics.endFill();
            }
            else
            {
                graphics.beginFill(COLORS[pipValue]);
                graphics.drawCircle(0, 0, 10);
                graphics.endFill();
            }

        }

    }

}
