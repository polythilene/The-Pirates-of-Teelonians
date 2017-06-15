package com.game.physics 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2World;
	import com.greensock.TweenMax;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author Wiwit
	 */
	public class CPhysicEnemyGround extends CBasePhysicEnemy
	{
		
		public function CPhysicEnemyGround(ratio:int, world:b2World, container:DisplayObjectContainer) 
		{
			super(ratio, world, container);
		}
		
		override public function update(elapsedTime:int):void 
		{
			super.update(elapsedTime);
			
			if ( !m_dead )
			{
				if ( m_state == STATE_MOVING )
				{
					var angle:Number = (m_body.GetAngle() * 180 / Math.PI) + 180;
					var power:Number = 20;
					
					var forceX:Number = Math.cos(degreeToRadian(angle)) * power;
					var forceY:Number = Math.sin(degreeToRadian(angle)) * power;
					
					var velocity:b2Vec2 = new b2Vec2(forceX / m_ratio, forceY / m_ratio);
					velocity.Multiply(m_body.GetMass());
					m_body.SetLinearVelocity(velocity);
				}
				
				updateSprite();
			}
			else
			{
				m_sprite.y += 0.02 + elapsedTime;
			}
			
			checkBound();
		}
		
		
		override protected function updateSprite():void 
		{
			super.updateSprite();
			
			m_sprite.x = m_body.GetPosition().x * m_ratio;
			m_sprite.y = m_body.GetPosition().y * m_ratio;
			m_sprite.rotation = m_body.GetAngle() * 180 / Math.PI;
		}
		
		override protected function kill():void 
		{
			super.kill();
			
			m_dead = true;
			
			var bx:int = m_sprite.x;
			var by:int = m_sprite.y;
			
			GlobalVars.MINIGAME_SCORE += 25;
			
			TweenMax.to( m_sprite, 1, { bezier:[ { x:bx, y:by - 250 }, { x:bx + 25, y:700 } ], 
										onComplete:function():void 
										{
											m_active = false;
										} 
									  } );
		}
	}

}