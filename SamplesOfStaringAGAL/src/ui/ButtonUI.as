package ui
{
	import com.bit101.components.PushButton;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class ButtonUI
	{
		private var button:PushButton;
		private var parmname:String;
		private var onMouseClick:Function;
		
		public function ButtonUI(sd:Sprite, xp:int, yp:int, lb:String, parmname:String=null)
		{
			this.parmname = parmname;
			
			button = new PushButton(sd, xp, yp, lb, onMouseClickHandler);
			if(parmname != null) button.toggle = true;
		}
		
		private function onMouseClickHandler(event:MouseEvent):void
		{
			if(parmname != null) Common[parmname] = button.selected;
			onMouseClick();
		}
		
		public function setParms(onMouseClick:Function):void
		{
			this.onMouseClick = onMouseClick;
		}
	}
}