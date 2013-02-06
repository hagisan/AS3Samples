package
{
	public class Common
	{
		static public var gravityX:uint = 0;
		static public var circleRadius:uint = 50;
		static public var velocityX:uint = 150;
		static public var densityFloor:Number = 0.1;
		static public var elasticityFloor:Number = 1.0;
		static public var densityBox:Number = 0.1;
		static public var elasticityBox:Number = 1.0;
		static public var densityBall:Number = 0.1;
		static public var elasticityBall:Number = 1.0;
		static public var angularVel:uint = 10;
		static public var boxWidth:uint = 16;
		static public var boxHeight:uint = 32;

		static public var drawCollisionArbiters:Boolean = true;
		static public var drawSensorArbiters:Boolean = true;
		static public var drawFluidArbiters:Boolean = true;
		static public var drawConstraints:Boolean = true;
		public static var density:Number;
		public static var elasticity:Number;

		public function Common()
		{
		}
	}
}