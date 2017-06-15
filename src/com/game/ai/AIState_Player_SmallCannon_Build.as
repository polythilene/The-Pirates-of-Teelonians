package com.game.ai 
{
	import com.game.CBaseTeelos;
	import com.game.CPlayerTeelos;
	import com.game.CTeeloSmallCannon;
	/**
	 * ...
	 * @author Wiwit
	 */
	public class AIState_Player_SmallCannon_Build extends AIState
	{
		static private var m_instance:AIState_Player_SmallCannon_Build;
		
		public function AIState_Player_SmallCannon_Build(lock:SingletonLock) 
		{
			m_stateName ="AIState_Player_SmallCannon_Build"
			m_enableTimeOut = false;
		}
		
		override public function enter(npc:CBaseTeelos):void 
		{
			super.enter(npc);
			npc.setCurrentFrame(2);
			CTeeloSmallCannon(npc).buildReady();
		}
		
		override public function update(npc:CBaseTeelos, elapsedTime:int):void 
		{
			super.update(npc, elapsedTime);
			
			var tower:CTeeloSmallCannon = CTeeloSmallCannon(npc);
			if ( tower.isBuildComplete() )
			{
				//CPlayerTeelos(npc).onDestinationReached();
				tower.buildFinished();
				tower.changeAIState( AIState_Player_SmallCannon_Birth.getInstance() );
			}
		}
		
		static public function getInstance() : AIState_Player_SmallCannon_Build 
		{
			if ( m_instance == null )
			{
            	m_instance = new AIState_Player_SmallCannon_Build( new SingletonLock() );
            }
			return m_instance;
		}
	}
}

class SingletonLock{}