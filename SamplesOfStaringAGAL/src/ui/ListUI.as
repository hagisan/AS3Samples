package ui
{
	import com.bit101.components.ComboBox;
	import com.bit101.components.List;
	
	import flash.display.Sprite;
	import flash.events.Event;

	public class ListUI
	{
		private var list:List;
		private var parmname:String;
		
		public function ListUI(sd:Sprite, xp:int, yp:int, parmname:String)
		{
			this.parmname = parmname;
			
			list = new List(sd, xp, yp);
			list.addEventListener(Event.SELECT, onSelect);
		}
		
		private function onSelect(event:Event):void
		{
			var selectedlist:List = event.currentTarget as List;
			
			Common[parmname] = {selectedIndex:selectedlist.selectedIndex, selectedItem:selectedlist.selectedItem};
		}
		
		public function setParms(lbl:Array):void
		{
			for(var i:int = 0; i < lbl.length; i++)
			{
				list.addItem(lbl[i]);
			}
		}
	}
}