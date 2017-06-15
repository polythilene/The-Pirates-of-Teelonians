package com.game.ai 
{
	import com.game.CBaseTeelos;
	import com.game.CTeeloSummoned_Infantro;
	
	/**
	 * ...
	 * @author Wiwit
	 */
	public class AIState_Fly extends AIState
	{
		static private var m_instance:AIState_Fly;
		
		public function AIState_Fly(lock:SingletonLock) 
		{
			m_stateName ="AIState_Fly"
			m_enableTimeOut = false;
		}
		
		override public function enter(npc:CBaseTeelos):void 
		{
			super.enter(npc);
			npc.setCurrentFrame(7);
			CTeeloSummoned_Infantro(npc).fly();
		}
		
		override public function update(npc:CBaseTeelos, elapsedTime:int):void 
		{
			super.update(npc, elapsedTime);
			
			if ( CTeeloSummoned_Infantro(npc).hasLanded() )
			{
				npc.changeAIState(AIState_Player_Walk.getInstance());
			}
		}
		
		static public function getInstance() : AIState_Fly 
		{
			if ( m_instance == null )
			{
            	m_instance = new AIState_Fly( new SingletonLock() );
            }
			return m_instance;
		}
	}
}

class SingletonLock{}