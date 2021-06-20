package
{
    import flash.display.Sprite;

    public class Toggle extends Sprite
    {
        public function Toggle()
        {
            player = GameData.PLAYER_HUMAN;
        }

        public function set player(playerType:uint):void
        {
            graphics.clear();

            if(playerType == GameData.PLAYER_HUMAN)
            {
                drawPerson(0x000000, 0xffffff);
                drawComputer(0xffffff, 0x000000);
            }
            else
            {
                drawPerson(0xffffff, 0x000000);
                drawComputer(0x000000, 0xffffff);
            }
            
        }

        public function drawPerson(bgColor:int, fgColor:int):void
        {
            graphics.beginFill(bgColor);
            graphics.drawRect(-15, -30, 30, 30);
            graphics.endFill();

            graphics.lineStyle(1, 0x000000);
            graphics.drawRect(-15, -30, 30, 30);

            graphics.lineStyle(1, fgColor);
            graphics.drawCircle(0, -23, 3);
            graphics.moveTo(0, -19);
            graphics.lineTo(0, -12);
            graphics.lineTo(4, -7);
            graphics.moveTo(0, -12);
            graphics.lineTo(-4, -7);

            graphics.moveTo(-6, -13);
            graphics.lineTo(-3, -16);
            graphics.lineTo(3, -16);
            graphics.lineTo(6, -19);
        }

        public function drawComputer(bgColor:int, fgColor:int):void
        {
            graphics.beginFill(bgColor);
            graphics.drawRect(-15, 0, 30, 30);
            graphics.endFill();

            graphics.lineStyle(1, 0x000000);
            graphics.drawRect(-15, 0, 30, 30);

            graphics.lineStyle(1, fgColor);
            graphics.moveTo(-3, 16);
            graphics.lineTo(10, 16);
            graphics.lineTo(10, 3);
            graphics.lineTo(-3, 3);
            graphics.lineTo(-3, 16);

            graphics.lineTo(-12, 26);
            graphics.lineTo(1, 26);
            graphics.lineTo(10, 16); 
        }
    }
}
