package
{
    import flash.display.Sprite;

    public class Reset extends Sprite
    {
        public function Reset()
        {
            graphics.beginFill(0xfefefe);
            graphics.drawRect(-15, -15, 30, 30);
            graphics.endFill();

            graphics.lineStyle(1, 0x000000);
            graphics.drawRect(-15, -15, 30, 30);
            graphics.drawCircle(0, 0, 10);

            graphics.moveTo(7, 3);
            graphics.lineTo(10, 0);
            graphics.lineTo(13, 3);
        }
    }
}
