package ui
{
	import flash.display.Sprite;
	import com.bit101.components.Text;

	public class TextUI
	{
		private var text:Text;
		
		public function TextUI(sd:Sprite, xp:int, yp:int, str:String, editable:Boolean=false)
		{
			text = new Text(sd, xp, yp, str);
			text.editable = editable;
		}
	}
}