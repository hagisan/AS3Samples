<<<<<<< HEAD
package ui
{
	import com.bit101.components.ColorChooser;
	
	import flash.display.Sprite;
	import flash.events.Event;

	public class ColorChooserUI
	{
		private var color:ColorChooser;
		private var parmname:String;
		
		public function ColorChooserUI(sd:Sprite, xp:int, yp:int, clr:int, parmname:String)
		{
			this.parmname = parmname;
			
			color = new ColorChooser(sd, xp, yp, clr, onChange);
		}
		
		private function onChange(event:Event):void
		{
			var selectedcolor:ColorChooser = event.currentTarget as ColorChooser;
			
			//trace(selectedcolor.value.toString(16).toUpperCase()); // 色(16進数で表示される)
			Common[parmname] = selectedcolor.value;
		}
		
		public function setParms(usepopup:Boolean):void
		{
			color.usePopup = usepopup;
		}
	}
=======
package ui
{
	import com.bit101.components.ColorChooser;
	
	import flash.display.Sprite;
	import flash.events.Event;

	public class ColorChooserUI
	{
		private var color:ColorChooser;
		private var parmname:String;
		
		public function ColorChooserUI(sd:Sprite, xp:int, yp:int, clr:int, parmname:String)
		{
			this.parmname = parmname;
			
			color = new ColorChooser(sd, xp, yp, clr, onChange);
		}
		
		private function onChange(event:Event):void
		{
			var selectedcolor:ColorChooser = event.currentTarget as ColorChooser;
			
			//trace(selectedcolor.value.toString(16).toUpperCase()); // 色(16進数で表示される)
			Common[parmname] = selectedcolor.value;
		}
		
		public function setParms(usepopup:Boolean):void
		{
			color.usePopup = usepopup;
		}
	}
>>>>>>> 5659ba273b1364a538682d471863db951cac3709
}