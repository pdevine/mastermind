package
{
    import flash.display.Stage;

    public class GameData
    {

        private static var instance:GameData;
        private static var allowInstantiation:Boolean;

        public static const PLAYER_HUMAN:uint = 0;
        public static const PLAYER_COMPUTER:uint = 1;

        public var player:uint;

        public var pips:Array;

        public var guesses:Array;
        public var scores:Array;
        public var code:Array;

        public var currentRow:uint = 0;
        public var currentValue:uint = 1;

        public var rows:uint = 8;
        public var codeLength:uint = 4;

        public var stage:Stage;

        public static function getInstance():GameData
        {
            if(instance == null)
            {
                allowInstantiation = true;
                instance = new GameData();
                allowInstantiation = false;
            }
            return instance;
        }

        public function GameData():void
        {
            if(!allowInstantiation)
                throw new Error(
                    "Error: Instantiation failed.  Use getInstance")
        }
    }
}
