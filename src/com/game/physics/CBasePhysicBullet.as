package com.game.physics 
{
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2World;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Wiwit
	 */
	public class CBasePhysicBullet 
	{
		protected var m_world:b2World;
		protected var m_velocity:int;
		protected var m_active:Boolean;
		protected var m_bulletBody:b2Body;
		protected var m_container:DisplayObjectContainer;
		protected var m_sprite:Sprite;
		protected var m_ratio:int;
		
		public function CBasePhysicBullet(world:b2World, ratio:int, container:DisplayObjectContainer) 
		{
			m_active = true;
			m_ratio = ratio;
			m_container = container;
			m_velocity = 1000;
			m_world = world;
		}
		
		protected function createSprite():void {}
		
		protected function updateSprite():void
		{
			m_sprite.x = m_bulletBody.GetPosition().x * m_ratio;
			m_sprite.y = m_bulletBody.GetPosition().y * m_ratio;
			m_sprite.rotation = m_bulletBody.GetAngle() * 180 / Math.PI;
		}
		
		public function update(elapsedTime:int):void
		{
			if ( m_active )
			{
				updateSprite();
			}
		}
		
		public function get active():Boolean 
		{
			return m_active;
		}
		
		public function remove():void
		{
			m_container.removeChild(m_sprite);
			m_world.DestroyBody(m_bulletBody);
		}
		
		public function hit():void	{ }
	}
}