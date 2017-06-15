package com.game.physics 
{
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2World;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author Wiwit
	 */
	public class CBasePhysicEnemy 
	{
		protected var m_active:Boolean;
		protected var m_dead:Boolean;
		protected var m_sprite:mcEnemies;
		protected var m_body:b2Body;
		protected var m_ratio:int;
		protected var m_world:b2World;
		protected var m_container:DisplayObjectContainer;
		protected var m_bodyDestroyed:Boolean;
		protected var m_life:int;
		
		static protected const STATE_MOVING:int 	= 100;
		static protected const STATE_STUNNED:int 	= 200;
		static protected const STATE_DIE:int 		= 300;
		
		protected var m_state:int;
		protected var m_stunDelay:int;
		
		public function CBasePhysicEnemy(ratio:int, world:b2World, container:DisplayObjectContainer) 
		{
			m_active = true;
			m_dead = false;
			m_ratio = ratio;
			m_world = world;
			m_container = container;
			m_bodyDestroyed = false;
			m_life = 1;
			m_state = STATE_MOVING;
			m_stunDelay = 0;
			
			createSprite();
			createBody();
		}
		
		protected function createSprite():void 
		{
			m_sprite = new mcEnemies();
			m_sprite.cacheAsBitmap = true;
			m_container.addChild( m_sprite );
		}
		
		protected function createBody():void 
		{
			// to be inherited
		}
		
		public function update(elapsedTime:int):void
		{
			if( !m_dead )
			{
				if ( m_state == STATE_STUNNED )
				{
					m_stunDelay -= elapsedTime;
					if( m_stunDelay <= 0 )
						m_state = STATE_MOVING;
				}
			}
		}
		
		protected function checkBound():void 
		{
			if ( m_sprite.x < -20 || m_sprite.y > 700 )
			{
				m_active = false;
			}
		}
		
		protected function updateSprite():void 
		{
			// to be inherited
		}
		
		protected function degreeToRadian(angle:Number):Number
		{
			return angle * Math.PI / 180;
		}
		
		public function get active():Boolean 
		{
			return m_active;
		}
		
		public function hit():void 
		{
			m_life--;
			//trace("Current Life is:", m_life);
		
			
			if ( m_life <= 0 )
			{
				m_dead = true;
				kill();
			}
			else
			{
				m_stunDelay = 1000;
				m_state = STATE_STUNNED;
			}
		}
		
		public function remove():void
		{
			m_container.removeChild(m_sprite);
			m_world.DestroyBody(m_body);
		}
		
		protected function kill():void
		{
			m_state = STATE_DIE;
		}
	}
}