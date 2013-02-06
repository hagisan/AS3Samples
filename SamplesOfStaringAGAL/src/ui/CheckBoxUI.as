package ui
{
	import com.bit101.components.CheckBox;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class CheckBoxUI
	{
		private var checkbox:CheckBox;
		private var parmname:String;

		public function CheckBoxUI(sd:Sprite, xp:int, yp:int, lb:String, parmname:String)
		{
			this.parmname = parmname;
			checkbox = new CheckBox(sd, xp, yp, lb, onChange);
		}
		
		private function onChange(event:Event):void
		{
			Common[parmname] = event.currentTarget.selected;
		}
		
		public function setParms(value:Boolean):void
		{
			checkbox.selected = Common[parmname] =value;
		}
	}
}