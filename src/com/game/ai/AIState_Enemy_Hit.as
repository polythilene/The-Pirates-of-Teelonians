package com.game.ai 
{
	import com.game.CBaseTeelos;
	import math.OpMath
	/**
	 * ...
	 * @author Wiwit
	 */
	public class AIState_Enemy_Hit extends AIState
	{
		static private var m_instance:AIState_Enemy_Hit;
		
		public function AIState_Enemy_Hit(lock:SingletonLock) 
		{
			m_stateName ="AIState_Enemy_Hit"
			m_enableTimeOut = false;
		}
		
		override public function enter(npc:CBaseTeelos):void 
		{
			super.enter(npc);
			var dice:int = OpMath.randomNumber(6)
			var frame:int = (dice < 3) ? 3: 4;
			npc.setCurrentFrame(frame);
		}
		
		override public function update(npc:CBaseTeelos, elapsedTime:int):void 
		{
			super.update(npc, elapsedTime);
			
			if ( npc.isAnimationComplete() )
			{
				npc.changeAIState( AIState_Enemy_Idle.getInstance() );
			}
		}
		
		static public function getInstance() : AIState_Enemy_Hit 
		{
			if ( m_instance == null )
			{
            	m_instance = new AIState_Enemy_Hit( new SingletonLock() );
            }
			return m_instance;
		}
		
	}
}

class SingletonLock{}