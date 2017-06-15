package com.game.ai 
{
	import com.game.CBaseTeelos;
	import com.game.UNITCLASS;
	import math.OpMath;
	/**
	 * ...
	 * @author Wiwit
	 */
	public class AIState_Enemy_HybridAttack extends AIState
	{
		static private var m_instance:AIState_Enemy_HybridAttack;
		
		public function AIState_Enemy_HybridAttack(lock:SingletonLock) 
		{
			m_stateName ="AIState_Enemy_HybridAttack"
			m_enableTimeOut = false;
		}
		
		override public function enter(npc:CBaseTeelos):void 
		{
			super.enter(npc);
			npc.setCurrentFrame(1);
		}
		
		override public function update(npc:CBaseTeelos, elapsedTime:int):void 
		{
			super.update(npc, elapsedTime);
			
			var length:Number = elapsedTime * npc.speed;
			
			if ( npc.isAnimationComplete())
			{
				if ((!(npc.isDestinationReached()) && npc.isCoolingDown()))
				{
					npc.setCurrentFrame(2);
					npc.x -= (length - (length * npc.slowFactor));
				}
			}
			else
			{
			
			}
		}
		
		static public function getInstance() : AIState_Enemy_HybridAttack 
		{
			if ( m_instance == null )
			{
            	m_instance = new AIState_Enemy_HybridAttack( new SingletonLock() );
            }
			return m_instance;
		}
	}
}

class SingletonLock{}