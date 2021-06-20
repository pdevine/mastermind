package
{
    import starling.display.Sprite;

    public class MovingPip extends Pip
    {
        private var _maxForce:Number = 1;
        private var _steeringForce:Vector2D;
        private var _arrivalThreshold:Number = 100;
        private var _wanderAngle:Number = 0;
        private var _wanderDistance:Number = 10;
        private var _wanderRadius:Number = 5;
        private var _wanderRange:Number = 1;
        private var _inSightDist:Number = 200;

        public function MovingPip()
        {
            _steeringForce = new Vector2D();
            super();
        }

        public function set maxForce(value:Number):void
        {
            _maxForce = value;
        }

        public function get maxForce():Number
        {
            return _maxForce;
        }

        public function set arrivalThreshold(value:Number):void
        {
            _arrivalThreshold = value;
        }

        public function get arrivalThreshold():Number
        {
            return _arrivalThreshold;
        }

        public function set wanderDistance(value:Number):void
        {
            _wanderDistance = value;
        }

        public function get wanderDistance():Number
        {
            return _wanderRadius;
        }

        public function set wanderRange(value:Number):void
        {
            _wanderRange = value;
        }

        public function get wanderRange():Number
        {
            return _wanderRange;
        }

        override public function update():void
        {
            _steeringForce.truncate(_maxForce);
            _steeringForce = _steeringForce.divide(_mass);
            _velocity = _velocity.add(_steeringForce);
            _steeringForce = new Vector2D();
            super.update();
        }

        public function seek(target:Vector2D):void
        {
            var desiredVelocity:Vector2D = target.subtract(_position);
            desiredVelocity.normalize();
            desiredVelocity = desiredVelocity.multiply(_maxSpeed);
            var force:Vector2D = desiredVelocity.subtract(_velocity);
            _steeringForce = _steeringForce.add(force);
        }

        public function flee(target:Vector2D):void
        {
            var desiredVelocity:Vector2D = target.subtract(_position);
            desiredVelocity.normalize();
            desiredVelocity = desiredVelocity.multiply(_maxSpeed);
            var force:Vector2D = desiredVelocity.subtract(_velocity);
            _steeringForce = _steeringForce.subtract(force);
        }

        public function arrive(target:Vector2D):void
        {
            var desiredVelocity:Vector2D = target.subtract(_position);
            desiredVelocity.normalize();

            var dist:Number = _position.dist(target);
            if(dist > arrivalThreshold)
                desiredVelocity = desiredVelocity.multiply(_maxSpeed);
            else
                desiredVelocity =
                    desiredVelocity.multiply(
                        _maxSpeed * dist / arrivalThreshold);

            var force:Vector2D = desiredVelocity.subtract(_velocity);
            _steeringForce = _steeringForce.add(force);
        }

        public function flock(pips:Array):void
        {
            var averageVelocity:Vector2D = _velocity.clone();
            var averagePosition:Vector2D = new Vector2D();
            var inSightCount:int = 0;

            for(var i:int = 0; i < pips.length; i++)
            {
                var pip:Pip = pips[i] as Pip;
                if(pip != this && inSight(pip))
                {
                    averageVelocity = averageVelocity.add(pip.velocity);
                    averagePosition = averagePosition.add(pip.position);
                    inSightCount++;
                }
            }
            if(inSightCount > 0)
            {
                averageVelocity = averageVelocity.divide(inSightCount);
                averagePosition = averagePosition.divide(inSightCount);
                seek(averagePosition);
                _steeringForce.add(averageVelocity.subtract(_velocity));
            }
        }

        public function inSight(pip:Pip):Boolean
        {
            if(_position.dist(pip.position) > _inSightDist)
                return false;
            var heading:Vector2D = _velocity.clone().normalize();
            var difference:Vector2D = pip.position.subtract(_position);
            var dotProd:Number = difference.dotProd(heading);

            if(dotProd < 0)
                return false;
            
            return true;
        }

        public function wander():void
        {
            var center:Vector2D = 
                velocity.clone().normalize().multiply(_wanderDistance);
            var offset:Vector2D = new Vector2D(0);
            offset.length = _wanderRadius;
            offset.angle = _wanderAngle;
            _wanderAngle += Math.random() * _wanderRange - _wanderRange * .5;
            var force:Vector2D = center.add(offset);
            _steeringForce = _steeringForce.add(force);
        }
    }
}
