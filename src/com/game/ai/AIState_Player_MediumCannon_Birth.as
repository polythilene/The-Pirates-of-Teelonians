package com.game.ai 
{
	import com.game.CBaseTeelos;
	import com.game.CPlayerTeelos;
	/**
	 * ...
	 * @author Wiwit
	 */
	public class AIState_Player_MediumCannon_Birth extends AIState
	{
		static private var m_instance:AIState_Player_MediumCannon_Birth;
		
		public function AIState_Player_MediumCannon_Birth(lock:SingletonLock) 
		{
			m_stateName ="AIState_Player_MediumCannon_Birth"
			m_enableTimeOut = false;
		}
		
		override public function enter(npc:CBaseTeelos):void 
		{
			super.enter(npc);
			npc.setCurrentFrame(6);
			//CPlayerTeelos(npc).onDestinationReached();
		}
		
		override public function update(npc:CBaseTeelos, elapsedTime:int):void 
		{
			super.update(npc, elapsedTime);
			if ( npc.isAnimationComplete() )
			{
				npc.changeAIState(AIState_Player_MediumCannon_Idle.getInstance());
			}
		}
		
		static public function getInstance() : AIState_Player_MediumCannon_Birth
		{
			if ( m_instance == null )
			{
            	m_instance = new AIState_Player_MediumCannon_Birth( new SingletonLock() );
            }
			return m_instance;
		}
	}
}

class SingletonLock{}