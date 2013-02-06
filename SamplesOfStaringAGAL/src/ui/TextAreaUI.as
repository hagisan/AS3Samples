package ui
{
	import flash.display.Sprite;
	import com.bit101.components.TextArea;
	
	public class TextAreaUI
	{
		private var area:TextArea;
		
		public function TextAreaUI(sd:Sprite, xp:int, yp:int, str:String)
		{
			area = new TextArea(sd, xp, yp, str);
		}
	}
}