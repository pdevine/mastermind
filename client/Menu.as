package
{
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.MouseEvent;

    import com.bit101.components.Component;
    import com.bit101.utils.MinimalConfigurator;
    import com.bit101.components.Label;
    import com.bit101.components.PushButton;
    import com.bit101.components.List;

    import flash.net.*;

    public class Menu extends Sprite
    {

        public var myLabel:Label;
        public var pushButton:PushButton;
        public var gameList:List;

        public var netConnection:NetConnection;
        public var responder:Responder;

        public var gd:GameData;

        public function Menu():void
        {
            gd = GameData.getInstance();

            Component.initStage(gd.nativeStage);

            netConnection = new NetConnection();
            netConnection.connect("http://192.168.137.156:8080");


            var xml:XML = <comps>
                <Panel x="10" y="10" width="200" height="500"/>
                    <VBox x="20" y="10">
                        <Label id="myLabel" text="Current Games"/>
                        <List id="gameList" width="170"/>
                        <PushButton id="pushButton" label="Select Game"/>
                    </VBox>
                </comps>;

            var config:MinimalConfigurator = new MinimalConfigurator(this);
            config.parseXML(xml);

            responder = new Responder(onComplete, onFail);
            netConnection.call("mastermind.listGames", responder);

            pushButton.addEventListener(MouseEvent.CLICK, onClick);
        }

        public function onClick(event:MouseEvent):void
        {
            trace("I'm clicked!");
            gd.nativeStage.dispatchEvent(
                new GameEvent(GameEvent.GAME_SELECTED));
        }

        public function onComplete(results):void
        {
            trace("success!");
            for each (var thisGame in results)
            {
                trace(thisGame['_key'])
                trace(thisGame);
                gameList.addItem(thisGame['_key']);
            }
        }

        public function onFail(results):void
        {
            trace("failed!");
            trace(results);
        }

    }
}
