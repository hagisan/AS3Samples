package ui
{
	import com.bit101.components.HUISlider;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class SliderHUI
	{
		private var slider:HUISlider;
		private var parmname:String;

		public function SliderHUI(sd:Sprite, xp:int, yp:int, lb:String, parmname:String)
		{
			this.parmname = parmname;
			
			slider = new HUISlider(sd, xp, yp, lb, onChange);
		}
		
		private function onChange(event:Event):void
		{
			Common[parmname] = event.currentTarget.value;
		}
		
		public function setParms(maximum:Number, minimum:Number, value:Number):void
		{
			slider.maximum = maximum;
			slider.minimum = minimum;
			slider.value = Common[parmname] =value;
		}
	}
}