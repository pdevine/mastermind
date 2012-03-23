package
{
    import flash.display.Stage;
    import starling.display.Stage;

    import flash.net.NetConnection;

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

        public var _currentRow:Array = [null, null, null, null, null];
        public var _pips_per_row:uint = 5;
        public var _selected_color:uint = 0;
        public var _game_state:String = "initialized";
        public var _color_range:Array = [1, 2, 3, 4, 5, 6, 7, 8];
        public var _total_rows:uint = 10;

        public var netConnection:NetConnection;

        public var stage:starling.display.Stage;
        public var nativeStage:flash.display.Stage;


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
