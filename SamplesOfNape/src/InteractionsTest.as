package
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import ui.*;
	
	public class InteractionsTest extends Sprite
	{
		public function InteractionsTest()
		{
			var lc:int = 0;
			new SliderHUI(this, 10, 15*lc++, "spaceGravityX(0-600)", "gravityX").setParms(600, 0, 0);
			
			lc++;
			new SliderHUI(this, 10, 15*lc++, "floorDensity(0.1-1.0)", "densityFloor").setParms(1.0, 0.1, 0.1);
			new SliderHUI(this, 10, 15*lc++, "floorElasticity(0.1-1.0)", "elasticityFloor").setParms(1.0, 0.1, 1.0);
			
			lc++;
			new SliderHUI(this, 10, 15*lc++, "boxWidth(10-50)", "boxWidth").setParms(50, 10, 16);
			new SliderHUI(this, 10, 15*lc++, "boxHeight(10-50)", "boxHeight").setParms(50, 10, 32);
			new SliderHUI(this, 10, 15*lc++, "boxDdensity(0.1-1.0)", "densityBox").setParms(1.0, 0.1, 0.1);
			new SliderHUI(this, 10, 15*lc++, "boxElasticity(0.1-1.0)", "elasticityBox").setParms(1.0, 0.1, 1.0);
			
			lc++;
			new SliderHUI(this, 10, 15*lc++, "ballRadius(10-50)", "circleRadius").setParms(50, 10, 30);
			new SliderHUI(this, 10, 15*lc++, "ballVelocityX(10-300)", "velocityX").setParms(300, 10, 150);
			new SliderHUI(this, 10, 15*lc++, "ballDensity(0.1-1.0)", "densityBall").setParms(1.0, 0.1, 0.1);
			new SliderHUI(this, 10, 15*lc++, "ballElasticity(0.1-1.0)", "elasticityBall").setParms(1.0, 0.1, 1.0);
			new SliderHUI(this, 10, 15*lc++, "ballAngularVel(0-360)", "angularVel").setParms(360, 0, 10);
			
			var ld:int = 0;
			new CheckBoxUI(this, 310, 15*ld++, "Debug drawCollisionArbiters(true)", "drawCollisionArbiters").setParms(true);
			new CheckBoxUI(this, 310, 15*ld++, "Debug drawSensorArbiters(true)", "drawSensorArbiters").setParms(true);
			new CheckBoxUI(this, 310, 15*ld++, "Debug drawFluidArbiters(true)", "drawFluidArbiters").setParms(true);
			new CheckBoxUI(this, 310, 15*ld++, "Debug drawConstraints(true)", "drawConstraints").setParms(true);
			
			var button:Sprite = new Sprite();
			addChild(button);
			
			var bg:Graphics = button.graphics;
			bg.lineStyle(8, 0xFF0000);
			bg.beginFill(0xFFFF00);
			bg.drawRoundRect(400, 300, 50, 50, 4, 4);
			bg.endFill();
			
			button.addEventListener(MouseEvent.CLICK, start);
		}
		
		private function start(e:MouseEvent):void
		{
			addChild(new SimpleBounding());
		}
	}
}

import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.utils.Timer;

import nape.callbacks.CbType;
import nape.callbacks.InteractionType;
import nape.callbacks.PreCallback;
import nape.callbacks.PreFlag;
import nape.callbacks.PreListener;
import nape.constraint.PivotJoint;
import nape.dynamics.CollisionArbiter;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyList;
import nape.phys.BodyType;
import nape.phys.Interactor;
import nape.phys.Material;
import nape.shape.Circle;
import nape.shape.Polygon;
import nape.space.Space;
import nape.util.BitmapDebug;
import nape.util.Debug;

class SimpleBounding extends Sprite
{
	private var space:Space;
	private var debug:Debug;
	private var handJoint:PivotJoint;
	private var myTimer:Timer = new Timer(2000, 100);
	private var oneWayType:CbType;
	private var teleporterType:CbType;
	private var w:int;
	private var h:int;
	
	
	public function SimpleBounding()
	{
		if (stage != null) init(null);
		else addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	private function init(e:Event):void
	{
		if (e != null) removeEventListener(Event.ADDED_TO_STAGE, init);
		
		oneWayType = new CbType();
		w = stage.stageWidth;
		h = stage.stageHeight;
				
		// Create a new simulation Space.
		var gravity:Vec2 = Vec2.weak(0, Common.gravityX);
		space = new Space(gravity);
		
		// Create a new BitmapDebug screen matching stage dimensions and background colour.
		debug = new BitmapDebug(stage.stageWidth, stage.stageHeight, stage.color);
		addChild(debug.display);
		
		// Set debug draw to draw all interaction types.
		debug.drawCollisionArbiters = Common.drawCollisionArbiters;
		debug.drawSensorArbiters = Common.drawSensorArbiters;
		debug.drawFluidArbiters = Common.drawFluidArbiters;
		debug.drawConstraints = Common.drawConstraints;
		
		setUp();
		
		stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		
		handJoint = new PivotJoint(space.world, null, Vec2.weak(), Vec2.weak());
		handJoint.space = space;
		handJoint.active = false;
		handJoint.stiff = false;
		
		space.listeners.add(new PreListener(
			InteractionType.COLLISION,
			oneWayType,
			CbType.ANY_BODY,
			oneWayHandler,
			0,
			true
		));
	}
	
	private function oneWayHandler(cb:PreCallback):PreFlag
	{
		var firstObject:Interactor = cb.int1;
		var secondObject:Interactor = cb.int2;
		var colArb:CollisionArbiter = cb.arbiter.collisionArbiter;
		
		trace("COLLISION!", firstObject.id, secondObject.id, firstObject.userData.name, secondObject.userData.name);
		
		if ((colArb.normal.y > 0) != cb.swapped)
		{
			return PreFlag.IGNORE;
		}
		else
		{
			return PreFlag.ACCEPT;
		}
	}

	private function setUp():void
	{
		var materialFloor:Material = new Material(Common.densityFloor,null,null,Common.elasticityFloor);
		var materialBox  :Material = new Material(Common.densityBox,null,null,Common.elasticityBox);
		var materialBall :Material = new Material(Common.densityBall,null,null,Common.elasticityBall);
		
		// Create the floor for the simulation.
		var floor:Body = new Body(BodyType.STATIC);
		floor.userData.name = "floor";
		floor.shapes.add(new Polygon(Polygon.rect(0, 0, w, -1), materialFloor));
		floor.shapes.add(new Polygon(Polygon.rect(0, h, w, 1), materialFloor));
		floor.shapes.add(new Polygon(Polygon.rect(0, 0, -1, h), materialFloor));
		floor.shapes.add(new Polygon(Polygon.rect(w, 0, 1, h), materialFloor));
		floor.space = space;
		
		// Create a tower of boxes.
		//trace(Common.densityBox, Common.elasticityBox);
		var cnt:int = int(h / Common.boxHeight) + 1;
		for (var i:int = 0; i < cnt; i++)
		{
			var box:Body = new Body(BodyType.DYNAMIC);
			box.userData.name = "box";
			box.shapes.add(new Polygon(Polygon.box(Common.boxWidth, Common.boxHeight), materialBox));
			box.position.setxy((w / 2), ((h - 50) - Common.boxHeight * (i + 0.5)));
			box.space = space;
		}
		
		// Create the rolling ball.
		var ball:Body = new Body(BodyType.DYNAMIC);
		ball.userData.name = "ball";
		ball.shapes.add(new Circle(Common.circleRadius, Vec2.get(0,0), materialBall));
		ball.position.setxy(50, h / 2);		//初期位置
		ball.angularVel = Common.angularVel;				//初期回転角
		ball.space = space;
		ball.velocity = Vec2.get(Common.velocityX, 0);	//初速度
		ball.cbTypes.add(oneWayType);
		
		// In each case we have used for adding a Shape to a Body body.shapes.add(shape);
	}
	
	private function enterFrameHandler(ev:Event):void
	{
		// Step forward in simulation by the required number of seconds.
		space.step(1 / stage.frameRate);
		
		if (handJoint.active)
		{
			handJoint.anchor1.setxy(mouseX, mouseY);
		}
		
		// Render Space to the debug draw.
		debug.clear();
		debug.draw(space);
		debug.flush();
	}
	
	private function mouseDownHandler(ev:MouseEvent):void {
		// Allocate a Vec2 from object pool.
		var mousePoint:Vec2 = Vec2.get(mouseX, mouseY);
		
		// Determine the set of Body's which are intersecting mouse point.
		var bodies:BodyList = space.bodiesUnderPoint(mousePoint);
		for (var i:int = 0; i < bodies.length; i++)
		{
			var body:Body = bodies.at(i);
			
			if (!body.isDynamic())
			{
				continue;
			}
			
			// Configure hand joint to drag this body.
			handJoint.body2 = body;
			handJoint.anchor2.set(body.worldPointToLocal(mousePoint, true));
			
			// Enable hand joint!
			handJoint.active = true;
			
			break;
		}
		
		// Release Vec2 back to object pool.
		mousePoint.dispose();
	}
	
	private function mouseUpHandler(ev:MouseEvent):void {
		// Disable hand joint (if not already disabled).
		handJoint.active = false;
	}
	
	private function keyDownHandler(ev:KeyboardEvent):void
	{
		if (ev.keyCode == 82) { // 'R'
			// space.clear() removes all bodies (and constraints of
			// which we have none) from the space.
			space.clear();
			
			setUp();
		}
	}
}
