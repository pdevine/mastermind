package
{
    import flash.events.Event;

    public class GameEvent extends flash.events.Event
    {
        public static const GAME_STARTED:String = "gameStarted";
        public static const GAME_ROW_FINISHED:String = "gameRowEntered";
        public static const GAME_ROW_CHANGED:String = "gameRowChanged";

        public function GameEvent(command:String)
        {
            super(command);
        }
    }
}
