package com.game.ai 
{
	import com.game.CBaseTeelos;
	import com.game.CPlayerCaptain;
	import com.game.CPlayerTeelos;
	import math.OpMath;
	/**
	 * ...
	 * @author Wiwit
	 */
	public class AIState_Dead extends AIState
	{
		static private var m_instance:AIState_Dead;
		
		public function AIState_Dead(lock:SingletonLock) 
		{
			m_stateName ="AIState_Dead"
			m_enableTimeOut = false;
		}
		
		override public function enter(npc:CBaseTeelos):void 
		{
			super.enter(npc);
			if (!(npc is CPlayerCaptain) && !(npc is CPlayerTeelos))
			{
				var dice:int = OpMath.randomNumber(6);
				var frame:int = (dice < 3) ? 7 : 8;
				npc.setCurrentFrame(frame);
				npc.onKilled();
			}
			else
			{
				npc.setCurrentFrame(6);
				npc.onKilled();
			}
		}
		
		override public function update(npc:CBaseTeelos, elapsedTime:int):void 
		{
			super.update(npc, elapsedTime);
			if( npc.isAnimationComplete() )
				npc.setInactive();
		}
		
		static public function getInstance() : AIState_Dead 
		{
			if ( m_instance == null )
			{
            	m_instance = new AIState_Dead( new SingletonLock() );
            }
			return m_instance;
		}
		
	}
}

class SingletonLock{}