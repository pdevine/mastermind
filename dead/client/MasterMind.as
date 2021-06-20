package
{
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import starling.core.Starling;

    [SWF(width="1280", height="752", frameRate="60", backgroundColor="#ffffff")]
    public class MasterMind extends Sprite
    {
        private var _starling:Starling;

        public function MasterMind()
        {
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;

            _starling = new Starling(Game, stage);
            _starling.start();
        }
    }
}
