package com.game.physics 
{
	import Box2D.Collision.Shapes.b2MassData;
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2World;
	import com.greensock.TweenMax;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author Wiwit
	 */
	public class CEnemyPhysicBalonBotak extends CPhysicEnemyAerial
	{
		
		public function CEnemyPhysicBalonBotak(ratio:int, world:b2World, container:DisplayObjectContainer)  
		{
			super(ratio, world, container);
			m_life = 3;
		}
		
		override protected function createSprite():void 
		{
			super.createSprite();
			
			m_sprite.gotoAndStop(5);
		}
		
		override protected function createBody():void 
		{
			super.createBody();
			
			// body
			var polyDef:b2PolygonDef = new b2PolygonDef();
			polyDef.density = 1.0;
			polyDef.friction = 0.6;
			polyDef.restitution = 0;
			polyDef.vertexCount = 8;
						
			var scale:Number = 2.0;
			
		    polyDef.vertices[0].Set(-0.45 * scale, 0.0 * scale);
			polyDef.vertices[1].Set(-0.55 * scale, -0.05 * scale);
			polyDef.vertices[2].Set(-0.65 * scale, -0.15 * scale);
			polyDef.vertices[3].Set(-0.45 * scale, -0.75 * scale);
			polyDef.vertices[4].Set(0.45 * scale, -0.75 * scale);
			polyDef.vertices[5].Set(0.65 * scale, -0.15 * scale);
			polyDef.vertices[6].Set(0.55 * scale, -0.05 * scale);
			polyDef.vertices[7].Set(0.45 * scale, 0.0 * scale);
			
			var bodyDef:b2BodyDef = new b2BodyDef();
			//bodyDef.position.Set(1709 / m_ratio, 350 / m_ratio);
			//bodyDef.position.Set(1500 / m_ratio, 350 / m_ratio);
			bodyDef.position.Set( buffPos.x, buffPos.y );
			
			m_body = m_world.CreateBody(bodyDef);
			m_body.CreateShape(polyDef);
			//m_body.SetMassFromShapes();
			m_body.m_type = b2Body.e_dynamicType;
			
			m_body.SetUserData(this);
		}
	}
}