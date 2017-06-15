package com.game.physics 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2World;
	import com.greensock.TweenMax;
	import flash.display.DisplayObjectContainer;
	import math.OpMath;
	/**
	 * ...
	 * @author Wiwit
	 */
	public class CPhysicEnemyAerial extends CBasePhysicEnemy
	{
		protected const AERIAL_HOVER_HEIGHT:int = 0;
		
		protected var buffPos:b2Vec2;
		protected var m_height:int;
		
		public function CPhysicEnemyAerial(ratio:int, world:b2World, container:DisplayObjectContainer) 
		{
			buffPos = new b2Vec2();
			
			m_height = AERIAL_HOVER_HEIGHT + OpMath.randomNumber(100);
			buffPos.Set( 1620 / ratio, m_height / ratio);
			
			super(ratio, world, container);			
		}
		
		override public function update(elapsedTime:int):void 
		{
			super.update(elapsedTime);
			
			
			if ( !m_dead )
			{
				if ( m_state == STATE_MOVING )
				{
					buffPos.Set(m_body.GetPosition().x, m_body.GetPosition().y);
				
					buffPos.x -= elapsedTime * 0.025 / m_ratio;
					buffPos.y = m_height / m_ratio;
					m_body.SetXForm(buffPos, 0);
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
		
		override public function hit():void 
		{
			super.hit();
			m_sprite.sprite.gotoAndStop(2);
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