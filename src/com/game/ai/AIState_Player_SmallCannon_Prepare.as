package com.game.ai 
{
	import com.game.CBaseTeelos;
	import com.game.CPlayerTeelos;
	/**
	 * ...
	 * @author Wiwit
	 */
	public class AIState_Player_SmallCannon_Prepare extends AIState
	{
		static private var m_instance:AIState_Player_SmallCannon_Prepare;
		
		public function AIState_Player_SmallCannon_Prepare(lock:SingletonLock) 
		{
			m_stateName ="AIState_Player_SmallCannon_Prepare"
			m_enableTimeOut = false;
		}
		
		override public function enter(npc:CBaseTeelos):void 
		{
			super.enter(npc);
			npc.getSprite().alpha = 1;
			npc.getSprite().sprite.gotoAndPlay(2);
			//npc.setCurrentFrame(2);
			//CPlayerTeelos(npc).onDestinationReached();
		}
		
		override public function update(npc:CBaseTeelos, elapsedTime:int):void 
		{
			super.update(npc, elapsedTime);
			if ( npc.isAnimationComplete() )
			{
				npc.changeAIState(AIState_Player_SmallCannon_Build.getInstance());
			}
		}
		
		static public function getInstance() : AIState_Player_SmallCannon_Prepare
		{
			if ( m_instance == null )
			{
            	m_instance = new AIState_Player_SmallCannon_Prepare( new SingletonLock() );
            }
			return m_instance;
		}
	}
}

class SingletonLock{}