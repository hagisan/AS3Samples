package tools
{
	import flash.display.BitmapData;
	
	import nape.space.Space;
	import nape.util.BitmapDebug;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	/**
	 * Napeのデバッグ表示をStarlingで行う便利クラス
	 * 
	 * Napeのデバッグ表示は通常DisplayListで行うので、以下のようにnativeOverlay追加する手もあるが、
	 * これではデバッグ表示の描画が1フレーム遅れてしまう。
	 * 
	 * //　init時
	 * napeBitmapDebug = new BitmapDebug(stage.stageWidth, stage.stageHeight, 0x333333, true);
	 * Starling.current.nativeOverlay.addChild(napeBitmapDebug.display);
	 * 
	 * //　roop内で
	 * napeBitmapDebug.clear();
	 * napeBitmapDebug.draw(space);
	 * napeBitmapDebug.flush();
	 * 
	 * @see http://napephys.com/samples.html#as3-BasicSimulation
	 */
	public class NapeDebugImage extends Sprite
	{
		public function NapeDebugImage(imageWidth:Number, imageHeight:Number)
		{
			super();
			
			touchable = false;
			
			napeBitmapDebug = new BitmapDebug(imageWidth, imageHeight, 0x333333, true);
			debugBitmapData = new BitmapData(imageWidth, imageHeight);
		}
		
		private var imageWidth:Number;
		private var imageHeight:Number;
		
		private var napeBitmapDebug:BitmapDebug;
		private var debugBitmapData:BitmapData;
		private var debugImage:Image;
		
		public function update(space:Space):void
		{
			napeBitmapDebug.clear();
			napeBitmapDebug.draw(space);
			napeBitmapDebug.flush();
			
			debugBitmapData.fillRect(debugBitmapData.rect, 0x00000000);
			debugBitmapData.draw(napeBitmapDebug.display);
			
			var debugTexure:Texture = Texture.fromBitmapData(debugBitmapData);
			
			if (!debugImage)
			{
				debugImage = new Image(debugTexure);
				addChild(debugImage);
			}
			else
			{
				debugImage.texture.dispose();
				debugImage.texture = debugTexure;
			}
		}
		
		public function clear():void
		{
			napeBitmapDebug.clear();
			napeBitmapDebug.flush();
			debugImage.texture.dispose();
			removeChild(debugImage, true);
		}
		
		override public function dispose():void
		{
			clear();
			debugBitmapData.dispose();
			super.dispose();
		}
	}
}