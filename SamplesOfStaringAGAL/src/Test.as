package
{
	import flash.display.Bitmap;
	import flash.display3D.textures.Texture;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	import util.*;
	import starling.display.DisplayObject;
	
	public class Test extends Sprite
	{
		[Embed(source="monkey_122.gif")]
		private var Hagisan:Class;
		[Embed(source="basketball.png")]
		private var Basketball:Class;
		
		public function Test()
		{
			var hagisan:starling.textures.Texture = starling.textures.Texture.fromBitmap (new Hagisan());
			var texture:starling.textures.Texture = starling.textures.Texture.fromBitmap (new Basketball()); 
			var image:Image = new Image(texture); 
			
			if(Common.selectbasket) addChild(image);
			var polygon:DisplayObject;
			switch(Common.selectprogram.selectedItem)
			{
				case "DrawQuad":
					polygon = new Polygon1(200, 4, 0xFF0000, Math.PI / 4.0);
					break;
				case "TorturedFace1":
					polygon = new Polygon2(200, 4, 0xFFFF00, Math.PI / 4.0);
					break;
				case "TorturedFace2":
					polygon = new Polygon3(hagisan.base as flash.display3D.textures.Texture
						,200, 4, 0xFFFF00, Math.PI / 4.0);
					break;
				case "TorturedFace3":
					polygon = new Polygon4(hagisan.base as flash.display3D.textures.Texture
						,200, 4, 0xFFFF00, Math.PI / 4.0);
					break;
			}
			polygon.x =  Common.positionX; polygon.y = Common.positionY;
			addChild(polygon);
		}
	}
}