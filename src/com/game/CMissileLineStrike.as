package com.game
{
	import com.game.CBaseLinearMissile;
	import com.game.CBaseTeelos;
	import com.game.fx.CEffect_Barrage;
	import com.game.fx.CEffect_FireExplosion;
	import flash.display.DisplayObjectContainer;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import math.OpMath;

	/**
	 * @author poof!
	 * @version 1.0
	 * @created 16-Des-2010 0:08:49
	 */
	public class CMissileLineStrike extends CBaseLinearMissile
	{
		private var enemy_gotHit:Array = new Array() //siput
		
		//private var m_grenadeDelay:int;
		//private var m_isOnGround:Boolean;

		private var m_shotDelay:int;
		private var m_victims:Array;
		private var m_readyShot:Boolean;
		
		
		public function CMissileLineStrike(){}
		
		override public function initialize():void 
		{
			super.initialize();
			
			m_victims = [];
			
			m_readyShot = false;
			m_speed = 1.1;
			m_sprite = new mc_LineShot();
			m_sprite.cacheAsBitmap = true;
			m_sprite.visible = false;
		}
		
		override public function onCreate(container:DisplayObjectContainer, x:int, y:int, direction:int, faction:int, lane:int, damage:int, counterOf:int, counterDamage:int, level:int, detectInvisible:Boolean, owner:CBaseTeelos, exParams:Object = null):void 
		{
			// copy from CBaseMissile
			super.onCreate(container, x, y, direction, faction, lane, damage, counterOf, 
								counterDamage, level, detectInvisible, owner, exParams);
							
			m_targetTimes = 100;
			
			if( m_victims )
				m_victims.splice(0, m_victims.length);
		}
		
		private function delayShot(time:int):void
		{
			m_shotDelay += time;
			if (m_shotDelay > 300)
			{
				m_readyShot = true;
				m_shotDelay = 0;
			}
		}
		
		override public function update(elapsedTime:int):void 
		{
			m_sprite.visible = true;
			move(elapsedTime);
			
			if ( m_sprite.x > 1200 )
			{
				m_active = false;
			}
			
			if ( m_active )
			{
				var list:Array = NPCManager.getInstance().getListOfUnit(m_lane, NPCManager.FACTION_ENEMY);
				if( list.length > 0 )
				{
					for( var i:int = 0; i < list.length; i++ )
					{
						var teelo:CBaseTeelos = CBaseTeelos( list[i] );
						
						if ( !teelo.isDead() && teelo.isStealthUnit() == m_detectInvisible && 
							  m_sprite.hitTestObject( teelo.getSprite() ) && !(teelo is IInvulnerable) &&
							  !(teelo is IJumper && !IJumper(teelo).hasLanded()) && m_victims.indexOf(teelo) < 0 )
						{
							m_victims.push(teelo);
							teelo.animationHit();
							onHit(teelo);
						}
					}
				}
			}
			/*if (m_readyShot)
			{
				
			}
			else
			{
				delayShot(elapsedTime);
			}*/
		}
		

	}//end CMissileFireball_Elonee

}