package com.game.physics 
{
	import Box2D.Collision.Shapes.b2CircleDef;
	import Box2D.Collision.Shapes.b2ShapeDef;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2World;
	import com.game.fx.CEffect_FireExplosion;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author Wiwit
	 */
	public class CCannonBullet extends CBasePhysicBullet
	{
		static private var m_bulletSD:b2CircleDef;
		static private var m_bulletBD:b2BodyDef;
		
		public function CCannonBullet(x:int, y:int, angle:Number, power:Number, ratio:int, bodyDef:b2BodyDef, shapeDef:b2ShapeDef, world:b2World, container:DisplayObjectContainer) 
		{
			super(world, ratio, container);
			
			// shape def
			if ( !m_bulletSD || !m_bulletBD )
			{
				setupBulletDefinition();
			}
				
			var cannonLaunchX:Number = x + (Math.cos(degreeToRadian(angle)) * 70);
			var cannonLaunchY:Number = y + (Math.sin(degreeToRadian(angle)) * 70);
			
			bodyDef.position.Set( cannonLaunchX / ratio, cannonLaunchY / ratio );
			
			m_bulletBody = world.CreateBody(bodyDef);
			m_bulletBody.CreateShape(shapeDef);
			m_bulletBody.SetMassFromShapes();
			m_bulletBody.SetBullet(true);
			m_bulletBody.SetUserData(this);
			
			var bulletPower:int = m_velocity * power;
			var forceX:Number = Math.cos(degreeToRadian(angle)) * bulletPower;
			var forceY:Number = Math.sin(degreeToRadian(angle)) * bulletPower;
			
			var velocity:b2Vec2 = new b2Vec2(forceX / ratio, forceY / ratio);
			velocity.Multiply(m_bulletBody.GetMass());
			
			m_bulletBody.ApplyImpulse(velocity, m_bulletBody.GetWorldCenter());
			
			createSprite();
		}
		
		override protected function createSprite():void
		{
			m_sprite = new mcCannonBall();
			m_container.addChild(m_sprite);
			updateSprite();
		}
		
		protected function degreeToRadian(angle:Number):Number
		{
			return angle * Math.PI / 180;
		}
		
		override public function hit():void 
		{
			ParticleManager.getInstance().add( CEffect_FireExplosion, 
											   m_sprite.x,
											   m_sprite.y + 30 );
			m_active = false;
		}
		
		private function setupBulletDefinition():void 
		{
			// bullet definition
			m_bulletSD = new b2CircleDef();
				
			m_bulletSD.radius = 13 / m_ratio;
			m_bulletSD.density = 1;
			m_bulletSD.friction = 0.5;
			m_bulletSD.restitution = 0.4;
			
			m_bulletBD = new b2BodyDef();
		}
	}

}