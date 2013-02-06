package util
{
	import com.adobe.utils.AGALMiniAssembler;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.DisplayObject;
	import starling.errors.MissingContextError;
	import starling.events.Event;
	import starling.utils.VertexData;
	
	/** This custom display objects renders a regular, n-sided polygon. */
	public class Polygon2 extends DisplayObject
	{
		[Embed(source="../monkey_122.gif")]
		private var hagisan:Class;
		
		/** All filter processing is expected to be done with premultiplied alpha. */
		protected const PMA:Boolean = true;
		
		private static var PROGRAM_NAME:String = "polygon";
		
		// custom members
		private var mRadius:Number;
		private var mNumEdges:int;
		private var mColor:uint;
		
		// vertex data 
		private var mVertexData:VertexData;
		private var mVertexBuffer:VertexBuffer3D;
		
		// index data
		private var mIndexData:Vector.<uint>;
		private var mIndexBuffer:IndexBuffer3D;
		
		// helper objects (to avoid temporary objects)
		private static var sHelperMatrix:Matrix = new Matrix();
		private static var sRenderAlpha:Vector.<Number> = new <Number>[1.0, 1.0, 1.0, 1.0];
		
		private var bitmapdata:BitmapData;
		private var degree:Number;
		
		private var texture:Texture;
		
		/** Creates a regular polygon with the specified redius, number of edges, and color. */
		public function Polygon2(radius:Number, numEdges:int=6, color:uint=0xffffff, degree:Number=0)
		{
			if (numEdges < 3) throw new ArgumentError("Invalid number of edges");
			
			bitmapdata = Bitmap(new hagisan()).bitmapData;
			
			this.degree = degree;
			this.mRadius = radius;
			this.mNumEdges = numEdges;
			this.mColor = color;
			
			setTexure();
			// setup vertex data and prepare shaders
			setupVertices();
			createBuffers();
			registerPrograms();
			
			// handle lost context
			Starling.current.addEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
		}
		
		/** Disposes all resources of the display object. */
		public override function dispose():void
		{
			Starling.current.removeEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
			
			if (mVertexBuffer) mVertexBuffer.dispose();
			if (mIndexBuffer)  mIndexBuffer.dispose();
			
			super.dispose();
		}
		
		private function onContextCreated(event:Event):void
		{
			//var context:Context3D = Starling.context;
			//context.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
			
			// the old context was lost, so we create new buffers and shaders.
			createBuffers();
			registerPrograms();
		}
		
		/** Returns a rectangle that completely encloses the object as it appears in another 
		 * coordinate system. */
		public override function getBounds(targetSpace:DisplayObject, resultRect:Rectangle=null):Rectangle
		{
			if (resultRect == null) resultRect = new Rectangle();
			
			var transformationMatrix:Matrix = targetSpace == this ? 
				null : getTransformationMatrix(targetSpace, sHelperMatrix);
			
			return mVertexData.getBounds(transformationMatrix, 0, -1, resultRect);
		}
		
		/** Creates the required vertex- and index data and uploads it to the GPU. */ 
		private function setupVertices(dx:Number=0, dy:Number=0):void
		{
			var i:int;
			
			// create vertices
			
			mVertexData = new VertexData(mNumEdges+1);
			mVertexData.setUniformColor(mColor);
			
			for (i=0; i<mNumEdges; ++i)
			{
				var edge:Point = Point.polar(mRadius, i*2*Math.PI / mNumEdges + degree);
				mVertexData.setPosition(i, edge.x, edge.y);
				switch(i){
					case 0:mVertexData.setTexCoords(i, 0.0, 1.0);break;
					case 1:mVertexData.setTexCoords(i, 1.0, 1.0);break;
					case 2:mVertexData.setTexCoords(i, 1.0, 0.0);break;
					case 3:mVertexData.setTexCoords(i, 0.0, 0.0);break;
				}
			}
			
			mVertexData.setPosition(mNumEdges, 0.0, 0.0); // center vertex
			mVertexData.setTexCoords(mNumEdges, 0.5 + dx, 0.5 + dy);
			
			// create indices that span up the triangles
			
			mIndexData = new <uint>[];
			
			for (i=0; i<mNumEdges; ++i)
				mIndexData.push(mNumEdges, i, (i+1)%mNumEdges);
		}
		
		private function setTexure():void
		{
			var context:Context3D = Starling.context;
			if (context == null) throw new MissingContextError();

			//[テクスチャ]
			texture = context.createTexture(
				512, 512, Context3DTextureFormat.BGRA, false
			);
			
			texture.uploadFromBitmapData(bitmapdata);
			context.setTextureAt(0, texture);				//fs0:テクスチャ
		}
		
		/** Creates new vertex- and index-buffers and uploads our vertex- and index-data to those
		 *  buffers. */ 
		private function createBuffers():void
		{
			var context:Context3D = Starling.context;
			if (context == null) throw new MissingContextError();
			
			if (mVertexBuffer) mVertexBuffer.dispose();
			if (mIndexBuffer)  mIndexBuffer.dispose();
			
			mVertexBuffer = context.createVertexBuffer(mVertexData.numVertices, VertexData.ELEMENTS_PER_VERTEX);
			mVertexBuffer.uploadFromVector(mVertexData.rawData, 0, mVertexData.numVertices);
			
			mIndexBuffer = context.createIndexBuffer(mIndexData.length);
			mIndexBuffer.uploadFromVector(mIndexData, 0, mIndexData.length);
		}
		
		/** Renders the object with the help of a 'support' object and with the accumulated alpha
		 * of its parent object. */
		public override function render(support:RenderSupport, alpha:Number):void
		{
			// always call this method when you write custom rendering code!
			// it causes all previously batched quads/images to render.
			//support.clear();
			//support.blendMode = BlendMode.NORMAL;
			support.pushMatrix();
			support.finishQuadBatch();
			//support.raiseDrawCount(1);
			//support.pushMatrix();
			//RenderSupport.setBlendFactors(PMA);
			
			sRenderAlpha[0] = sRenderAlpha[1] = sRenderAlpha[2] = Math.sin(getTimer() / 200);
			sRenderAlpha[3] = alpha * this.alpha * Math.sin(getTimer() / 200);
			
			var context:Context3D = Starling.context;
			if (context == null) throw new MissingContextError();

			// apply the current blendmode
			support.applyBlendMode(false);
			
			setupVertices(0.2 * Math.sin(getTimer() / 200), 0.2 * Math.sin(getTimer() / 200));
			createBuffers();
			setTexure();
			
			// activate program (shader) and set the required buffers / constants 
			context.setProgram(Starling.current.getProgram(PROGRAM_NAME));
			context.setVertexBufferAt(0, mVertexBuffer, VertexData.POSITION_OFFSET, Context3DVertexBufferFormat.FLOAT_2); 
			context.setVertexBufferAt(1, mVertexBuffer, VertexData.COLOR_OFFSET,    Context3DVertexBufferFormat.FLOAT_4);
			context.setVertexBufferAt(2, mVertexBuffer, VertexData.TEXCOORD_OFFSET, Context3DVertexBufferFormat.FLOAT_2);
			context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, support.mvpMatrix3D, true);            
			context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, sRenderAlpha, 1);
			
			// finally: draw the object!
			context.drawTriangles(mIndexBuffer, 0, mNumEdges);
			
			// reset buffers
			context.setVertexBufferAt(0, null);
			context.setVertexBufferAt(1, null);
			context.setVertexBufferAt(2, null);
			context.setTextureAt(0, null);
			
			support.popMatrix();
		}
		
		/** Creates vertex and fragment programs from assembly. */
		private static function registerPrograms():void
		{
			var target:Starling = Starling.current;
			if (target.hasProgram(PROGRAM_NAME)) return; // already registered
			
			// va0 -> position
			// va1 -> color
			// vc0 -> mvpMatrix (4 vectors, vc0 - vc3)
			// vc4 -> alpha
			
			var vertexProgramCode:String =
				"m44 op, va0, vc0 \n" + // 4x4 matrix transform to output space
				"mul v0, va1, vc4 \n" +  // multiply color with alpha and pass it to fragment shader
				"mov v1, va2 \n"
			var fragmentProgramCode:String =
				"tex ft3, v1, fs0<2d,linear> \n" +
//				"mul ft3.xyz, ft3.xyz, ft3.www \n"
				"mul oc, v0, ft3 \n"
//				"mov oc, v0";           // just forward incoming color
			
			var vertexProgramAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			vertexProgramAssembler.assemble(Context3DProgramType.VERTEX, vertexProgramCode);
			
			var fragmentProgramAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			fragmentProgramAssembler.assemble(Context3DProgramType.FRAGMENT, fragmentProgramCode);
			
			target.registerProgram(PROGRAM_NAME, vertexProgramAssembler.agalcode,
				fragmentProgramAssembler.agalcode);
		}
		
		/** The radius of the polygon in points. */
		public function get radius():Number { return mRadius; }
		public function set radius(value:Number):void { mRadius = value; /*setupVertices();*/ }
		
		/** The number of edges of the regular polygon. */
		public function get numEdges():int { return mNumEdges; }
		public function set numEdges(value:int):void { mNumEdges = value; /*setupVertices();*/ }
		
		/** The color of the regular polygon. */
		public function get color():uint { return mColor; }
		public function set color(value:uint):void { mColor = value; /*setupVertices();*/ }
	}
}
import flash.display3D.Context3D;
import flash.display3D.Context3DProgramType;
import flash.display3D.Context3DVertexBufferFormat;
import flash.display3D.IndexBuffer3D;
import flash.display3D.VertexBuffer3D;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;