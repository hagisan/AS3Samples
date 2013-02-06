package ui
{
	import com.bit101.components.ComboBox;
	
	import flash.display.Sprite;
	import flash.events.Event;

	public class ComboBoxUI
	{
		private var box:ComboBox;
		private var parmname:String;
		
		public function ComboBoxUI(sd:Sprite, xp:int, yp:int, str:String, parmname:String, comboarray:Array)
		{
			this.parmname = parmname;
			
			box = new ComboBox(sd, xp, yp, str, comboarray);
			box.selectedIndex = 0; onSelect();
			box.addEventListener(Event.SELECT, onSelect);
		}
		
		private function onSelect(event:Event=null):void
		{
			//var cbox:ComboBox = event.currentTarget as ComboBox;
			
			Common[parmname] = {selectedIndex:box.selectedIndex, selectedItem:box.selectedItem};
		}
		
		public function setParms(lbl:Array):void
		{
			for(var i:int = 0; i < lbl.length; i++)
			{
				box.addItem(lbl[i]);
			}
		}
	}
}