package ui
{
	import com.bit101.components.InputText;
	
	import flash.display.Sprite;
	import flash.events.Event;

	public class InputTextUI
	{
		private var input:InputText;
		private var parmname:String;
		
		public function InputTextUI(sd:Sprite, xp:int, yp:int, str:String, parmname:String)
		{
			this.parmname = parmname;
			
			input = new InputText(sd, xp, yp, str, onChange);
		}
		
		private function onChange(event:Event):void
		{
			Common[parmname] = event.currentTarget.text;
		}
		
		public function setParms(maxchars:int):void
		{
			input.maxChars = maxchars;
		}
	}
}