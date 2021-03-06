///////////////////////////////////////////////////////////
//  CMissileArrow_Feela.as
//  Macromedia ActionScript Implementation of the Class CMissileArrow_Feela
//  Generated by Enterprise Architect
//  Created on:      14-Dec-2010 3:28:58 PM
//  Original author: Kurniawan Fitriadi
///////////////////////////////////////////////////////////

package com.game
{
	import com.game.ai.AIState_Enemy_Hit;
	import com.game.CBaseLinearMissile;
	import com.game.CBaseTeelos;
	import flash.display.DisplayObjectContainer;

	/**
	 * @author Kurniawan Fitriadi
	 * @version 1.0
	 * @created 14-Dec-2010 3:28:58 PM
	 */
	public class CMissileCannon_Small extends CBaseLinearMissile implements IRangeAttacker
	{
		private var m_victims:Array;
		
		public function CMissileCannon_Small(){
		}
		
		override public function initialize():void 
		{
			super.initialize();
			
			m_speed = 0.5;
			m_sprite = new mc_MissileCannon_small();
			m_sprite.cacheAsBitmap = true;
		}
		
		override public function onCreate(container:DisplayObjectContainer, x:int, y:int, direction:int, faction:int, lane:int, damage:int, counterOf:int, counterDamage:int, level:int, detectInvisible:Boolean, owner:CBaseTeelos, exParams:Object = null):void 
		{
			//sound fx play
			SoundManager.getInstance().playSFX("SN08");
			m_victims = [];
			
			super.onCreate(container, x, y, direction, faction, lane, damage, counterOf, 
							counterDamage, level, detectInvisible, owner, exParams);
		}
		
		override protected function onHit(target:CBaseTeelos):void 
		{
			super.onHit(target);
			m_targetTimes --;
		}
		
		override public function update(elapsedTime:int):void 
		{
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
		}
	}

}