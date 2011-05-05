package
{
    import flash.events.Event;

    public class GameEvent extends flash.events.Event
    {
        public static const GAME_STARTED:String = "gameStarted";
        public static const GAME_RESET:String = "gameReset";
        public static const GAME_ROW_FINISHED:String = "gameRowFinished";
        public static const GAME_ROW_CHANGED:String = "gameRowChanged";
        public static const GAME_CODE_SET:String = "gameCodeSet";

        public function GameEvent(command:String)
        {
            super(command);
        }
    }
}
