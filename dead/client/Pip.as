package
{
    import flash.display.Sprite;
    import flash.display.BitmapData;

    import starling.display.Sprite;
    import starling.textures.Texture;
    import starling.display.Image;

    public class Pip extends starling.display.Sprite
    {
        protected var _edgeBehavior:String = BOUNCE;
        protected var _mass:Number = 1.0;
        protected var _maxSpeed:Number = 10;
        protected var _position:Vector2D;
        protected var _velocity:Vector2D;

        public var destination:Vector2D;

        public static const WRAP:String = "wrap";
        public static const BOUNCE:String = "bounce";
        public static const IGNORE:String = "ignore";

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

        private var _pipValue:int = 0;
        private var _showValue:Boolean;
        private var _selected:Boolean = false;

        private static const EMPTY_COLOR:uint = 0xb0b0b0;
        private static const EMPTY_RADIUS:uint = 7;
        private static const COLORED_RADIUS:uint = 12;

        public function Pip(pipValue:uint=0, _showValue:Boolean=true)
        {
            this._showValue = _showValue;
            this.pipValue = pipValue;

            _position = new Vector2D();
            _velocity = new Vector2D();

            destination = null;
        }
        
        private function drawEmptyPip():void
        {
            var pip:flash.display.Sprite = new flash.display.Sprite();

            pip.graphics.beginFill(EMPTY_COLOR);
            pip.graphics.drawCircle(16, 16, EMPTY_RADIUS);
            pip.graphics.endFill();

            var bmd:BitmapData = new BitmapData(
                    16*2,
                    16*2,
                    true, 0x00000000);
            bmd.draw(pip);

            var texture:Texture = Texture.fromBitmapData(bmd, false, false);
            var image:Image = new Image(texture);

            addChild(image);
            
        }

        private function drawColoredPip():void
        {
            var pip:flash.display.Sprite = new flash.display.Sprite();

            pip.graphics.clear();
            pip.graphics.beginFill(COLORS[_pipValue]);
            pip.graphics.drawCircle(0, 0, COLORED_RADIUS);
            pip.graphics.endFill();

            // XXX - pulse this?
            if(_selected)
            {
                pip.graphics.lineStyle(1);
                pip.graphics.drawCircle(0, 0, COLORED_RADIUS);
            }

        }

        private function drawHiddenPip():void
        {
            var pip:flash.display.Sprite = new flash.display.Sprite();

            // clean up anything which was displayed before
            removeChildAt(0);

            pip.graphics.clear();

            // can this be transparent?
            //pip.graphics.beginFill(0xffffff);
            //pip.graphics.drawRect(0, 0, 20, 20);
            //pip.graphics.endFill();

            pip.graphics.lineStyle(2);
            pip.graphics.beginFill(0x000000);
            pip.graphics.moveTo(6, 6);
            pip.graphics.lineTo(26, 26);
            pip.graphics.moveTo(6, 26);
            pip.graphics.lineTo(26, 6);
            pip.graphics.endFill();

            var bmd:BitmapData = new BitmapData(32, 32, true, 0x00000000);
            bmd.draw(pip);

            var texture:Texture = Texture.fromBitmapData(bmd, false, false);
            var image:Image = new Image(texture);

            addChild(image);
        }

        public function set showValue(b:Boolean):void
        {
            _showValue = b;

            if(_showValue)
                drawColoredPip();
            else
                drawHiddenPip();
        }

        public function set pipValue(pipValue:uint):void
        {
            _pipValue = pipValue;

            //graphics.clear();

            if(!pipValue)
                drawEmptyPip();
            else
                drawHiddenPip();

        }

        public function get pipValue():uint
        {
            return _pipValue;
        }

        public function set selected(b:Boolean):void
        {
            _selected = b;
            drawColoredPip();
        }

        public function get selected():Boolean
        {
            return _selected;
        }

        public function update():void
        {
            _velocity.truncate(_maxSpeed);

            _position = _position.add(_velocity);

            if(_edgeBehavior == WRAP)
                wrap();
            else if (_edgeBehavior == BOUNCE)
                bounce();

            x = position.x;
            y = position.y;

            //rotation = _velocity.angle * 180 / Math.PI;
        }

        private function bounce():void
        {
            if(stage != null)
            {
                if(position.x > stage.stageWidth)
                {
                    position.x = stage.stageWidth;
                    velocity.x *= -1;
                }
                else if(position.x < 0)
                {
                    position.x = 0;
                    velocity.x *= -1;
                }

                if(position.y > stage.stageHeight)
                {
                    position.y = stage.stageHeight;
                    velocity.y *= -1;
                }
                else if(position.y < 0)
                {
                    position.y = 0;
                    velocity.y *= -1;
                }
            }
        }

        private function wrap():void
        {
            if(stage != null)
            {
                if(position.x > stage.stageWidth)
                    position.x = 0;
                else if(position.x < 0)
                    position.x = stage.stageWidth;

                if(position.y > stage.stageHeight)
                    position.y = 0;
                else if (position.y < 0)
                    position.y = stage.stageHeight;
            }
        }

        public function set edgeBehavior(value:String):void
        {
            _edgeBehavior = value;
        }

        public function get edgeBehavior():String
        {
            return _edgeBehavior;
        }

        public function set mass(value:Number):void
        {
            _mass = value;
        }

        public function get mass():Number
        {
            return _mass;
        }

        public function set maxSpeed(value:Number):void
        {
            _maxSpeed = value;
        }

        public function get maxSpeed():Number
        {
            return _maxSpeed;
        }

        public function set position(value:Vector2D):void
        {
            _position = value;
            x = _position.x;
            y = _position.y;
        }

        public function get position():Vector2D
        {
            return _position;
        }

        public function set velocity(value:Vector2D):void
        {
            _velocity = value;
        }

        public function get velocity():Vector2D
        {
            return _velocity;
        }

        override public function set x(value:Number):void
        {
            super.x = value;
            _position.x = x;
        }

        override public function set y(value:Number):void
        {
            super.y = value;
            _position.y = y;
        }
    }
}
