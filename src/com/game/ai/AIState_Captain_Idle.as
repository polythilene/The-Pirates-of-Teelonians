package com.game.ai 
{
	import com.game.CBaseTeelos;
	import com.game.CPlayerTeelos;
	import com.game.CTeeloBaseBuilding;
	import com.game.CTeeloTrap;
	import com.game.CTeeloUgee;
	import com.game.IInvulnerable;
	import com.game.IJumper;
	import com.game.IRangeAttacker;
	/**
	 * ...
	 * @author Wiwit
	 */
	public class AIState_Captain_Idle extends AIState
	{
		static private var m_instance:AIState_Captain_Idle;
		
		public function AIState_Captain_Idle(lock:SingletonLock) 
		{
			m_stateName ="AIState_Captain_Idle"
			m_enableTimeOut = false;
		}
		
		override public function enter(npc:CBaseTeelos):void 
		{
			super.enter(npc);
			npc.setCurrentFrame(1);
			//trace("Idle");
			//CPlayerTeelos(npc).onDestinationReached();
		}
		
		override public function update(npc:CBaseTeelos, elapsedTime:int):void 
		{
			super.update(npc, elapsedTime);
		
			var enemy:CBaseTeelos = npc.getNearestEnemy();
			//trace(npc.isCoolingDown());
			//trace(enemy);
			if ( !npc.isCoolingDown() && enemy && 
				 !(enemy is IJumper && !IJumper(enemy).hasLanded()) && 
				 !(enemy is IInvulnerable) )
			{
				
				if ( !npc.isProjectileReleased() && !npc.isWalking() )
				{
					//trace("SHOT");
					npc.attack( enemy );
					npc.changeAIState( AIState_Captain_AttackRanged.getInstance() );
				}
			}
			/*if ( !npc.isDestinationReached() )
			{
				npc.changeAIState( AIState_Player_Walk.getInstance() );
			}*/
		}
		
		static public function getInstance() : AIState_Captain_Idle 
		{
			if ( m_instance == null )
			{
            	m_instance = new AIState_Captain_Idle( new SingletonLock() );
            }
			return m_instance;
		}
		
	}
}

class SingletonLock{}