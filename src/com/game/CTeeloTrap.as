///////////////////////////////////////////////////////////
//  CTeeloTrap.as
//  Macromedia ActionScript Implementation of the Class CTeeloTrap
//  Generated by Enterprise Architect
//  Created on:      20-Dec-2010 3:24:27 PM
//  Original author: poof!
///////////////////////////////////////////////////////////

package com.game
{
	import com.game.ai.AIState;
	import com.game.ai.AIState_Player_Trap_Broken;
	import com.game.ai.AIState_Player_Trap_Enter;
	import com.game.CBaseTeelos;
	import com.game.CPlayerTeelos;
	import flash.display.DisplayObjectContainer;

	/**
	 * @author poof!
	 * @version 1.0
	 * @created 20-Dec-2010 3:24:27 PM
	 */
	public class CTeeloTrap extends CTeeloBaseBuilding
	{
	    /**
	     * this will decrease every attack, if this counter reach zero, class will kill it
	     * self
	     */
		
		private const MAX_TRIGGER:int = 5;
		
	    private var m_attackCount:int;
		private var m_attackTimeCtr:int;

		public function CTeeloTrap(){
			
		}
		
		override public function initialize():void 
		{
			super.initialize();
			
			m_baseAttack = 500; //siom, 23jan011 12:09: sementara untuk mengganti CB yang ga jalan
			m_defense = 0;
			m_maxLife = 3;						//siput
			m_unitClass = UNITCLASS.NONE;
			m_counterClass = UNITCLASS.SIEGE; 	//siput
			m_counterBonus = 500;			//siput //siom, 23jan011 12:09
			m_baseSpeed = 0.05;
			m_baseCooldownTime = 2000;
			m_stealthUnit = true;
			m_trainCost = 250;
		}
		
		override protected function createSprite():void 
		{
			super.createSprite();
			m_sprite = new mcTeelo_Trap();
		}
		
		override public function onCreate(lane:int, targetPosX:int, container:DisplayObjectContainer):void 
		{
			super.onCreate(lane, targetPosX, container);
			
			m_attackCount = 0;
			m_attackTimeCtr = 0;
			changeAIState( AIState_Player_Trap_Enter.getInstance() );
		}
		
		override public function update(elapsedTime:int):void 
		{
			super.update(elapsedTime);
			
			var attacking:Boolean = false;
			
			if ( m_sprite.currentFrame == 4 && isAnimationComplete() )
			{
				setCurrentFrame(3);
			}
			
			if ( m_active && !m_dead && isBuildComplete() )
			{
				m_attackTimeCtr += elapsedTime;
				
				var list:Array = NPCManager.getInstance().getListOfUnit(m_lane, NPCManager.FACTION_ENEMY);
				
				if ( list.length > 0 )
				{
					for ( var i:int = 0; i < list.length; i++ )
					{
						var enemy:CBaseTeelos = CBaseTeelos(list[i]);
						var dist:int = Math.abs(m_sprite.x - enemy.x);
						if ( !enemy.isDead() &&	
							 dist < 40 && m_attackTimeCtr > 2000 && 
							 m_attackCount < MAX_TRIGGER &&
							 !(enemy is IInvulnerable) &&
							 !(enemy is IJumper && !IJumper(enemy).hasLanded()) )
						{
							var bonus:int = ( m_counterClass == enemy.unitClass ) ? m_counterBonus : 0; //siput
							enemy.damage(m_baseAttack + bonus , this);									  	//
							
							m_attackTimeCtr = 0;
							attacking = true;
							m_attackCount++;
						}
					}
				}	
				
				if ( attacking )
				{
					setCurrentFrame(4);
					m_attackTimeCtr = 0;
				}
				
				if ( m_attackCount >= MAX_TRIGGER )
				{
					m_dead = true;
					changeAIState(AIState_Player_Trap_Broken.getInstance());
				}
			}
		}
		
		override public function attack(target:CBaseTeelos):void 
		{
			// do nothing
		}
		
		override public function onBuildComplete():void 
		{
			super.onBuildComplete();
			NPCManager.getInstance().add( CTeeloWorkerReturn, m_lane, m_sprite.x, m_container );
		}
		
		override public function changeAIState(newState:AIState):void 
		{
			super.changeAIState(newState);
			trace("Trap AI:", newState.getStateName());
		}
		
		override public function damage(value:int, source:CBaseTeelos):void 
		{
			if ( value > 0 )
			{
				var def:int = Math.ceil( defense / 2 );
				var dmg:int = (def > value) ? 1 : value - def;
			}
			else
			{
				dmg = value;
			}
			if (dmg == 0) dmg = 1;
			
			m_currLife -= dmg;
			if( m_currLife < 0 )
			{
				m_dead = true;
				changeAIState( AIState_Player_Trap_Broken.getInstance() );
			}
			
			m_currLife = Math.min(m_currLife, m_maxLife);		// cap value when unit is healed
			
			// tint sprite
			var col:int = (value > 0) ? 0xFF0000 : 0x00FF00;
			tintOnHit(col);
		}
		
	}//end CTeeloTrap

}