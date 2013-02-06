package ui
{
	import com.bit101.components.NumericStepper;
	
	import flash.display.Sprite;
	import flash.events.Event;

	public class NumericStepperUI
	{
		private var stepper:NumericStepper;
		private var parmname:String;
		
		public function NumericStepperUI(sd:Sprite, xp:int, yp:int, parmname:String)
		{
			this.parmname = parmname;
			
			stepper = new NumericStepper(sd, xp, yp, onChange);
			stepper.addEventListener(Event.CHANGE, onChange);
		}
		
		private function onChange(event:Event):void
		{
			var numericstepper:NumericStepper = event.currentTarget as NumericStepper;
			
			Common[parmname] = numericstepper.value;
		}
		
		public function setParms(value:Number):void
		{
			Common[parmname] = value;
			stepper.value = value;
		}
	}
}