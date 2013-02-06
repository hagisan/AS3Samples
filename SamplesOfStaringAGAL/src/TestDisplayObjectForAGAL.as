package
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	
	import ui.*;
	
	public class TestDisplayObjectForAGAL extends Sprite
	{
		[SWF(frameRate=60, backgroundColor=0x000000)]
		
		public function TestDisplayObjectForAGAL()
		{
			// autoOrients をサポート
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var lc:int = 1;
			new SliderHUI(this, 10, 15*lc++, "positionX(0-400)", "positionX").setParms(400, 0, 100);
			new SliderHUI(this, 10, 15*lc++, "positionY(0-800)", "positionY").setParms(800, 0, 170);
			lc++
			new ComboBoxUI(this, 10, 15*lc++, "SelectProgram", "selectprogram",
				["TorturedFace1", "TorturedFace2", "TorturedFace3", "DrawQuad"]);
			lc++
			new CheckBoxUI(this, 10, 15*lc++, "Selectbasket(Check-> BasketballOff)", "selectbasket").setParms(true);
			
			var button:Sprite = new Sprite();
			addChild(button);
			
			var bg:Graphics = button.graphics;
			bg.lineStyle(8, 0xFF0000);
			bg.beginFill(0xFFFF00);
			bg.drawRoundRect(400, 300, 50, 50, 4, 4);
			bg.endFill();
			
			button.addEventListener(MouseEvent.CLICK, start);
		}
		
		private function start(e:MouseEvent=null):void
		{
			var viewPort:Rectangle = new Rectangle();
			viewPort.height = stage.fullScreenHeight;
			viewPort.width = stage.fullScreenWidth;
			
			Starling.handleLostContext = true;
			var startStarling:Starling = new Starling(Test, stage, viewPort, stage.stage3Ds[0], "auto", "baseline");
			startStarling.start();
		}
	}
}