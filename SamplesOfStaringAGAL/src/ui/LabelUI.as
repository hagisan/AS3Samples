package ui
{
	import com.bit101.components.Label;
	
	import flash.display.Sprite;

	public class LabelUI
	{
		private var label:Label;
		
		public function LabelUI(sd:Sprite, xp:int, yp:int, lb:String, sX:Number, sY:Number)
		{
			label = new Label(sd, xp, yp, lb);
			label.scaleX = sX;
			label.scaleY = sY;
		}
	}
}