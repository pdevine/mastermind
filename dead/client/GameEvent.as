package
{
    import starling.events.Event;

    public class GameEvent extends starling.events.Event
    {
        public static const GAME_STARTED:String = "gameStarted";
        public static const GAME_RESET:String = "gameReset";
        public static const GAME_ROW_FINISHED:String = "gameRowFinished";
        public static const GAME_ROW_CHANGED:String = "gameRowChanged";
        public static const GAME_CODE_SET:String = "gameCodeSet";
        public static const GAME_SELECTED:String = "gameSelected";

        public function GameEvent(command:String)
        {
            super(command);
        }
    }
}
