package com.game.ai 
{
	import com.game.CBaseTeelos;
	import com.game.CPlayerTeelos;
	/**
	 * ...
	 * @author Wiwit
	 */
	public class AIState_Player_MediumCannon_Enter extends AIState
	{
		static private var m_instance:AIState_Player_MediumCannon_Enter;
		
		public function AIState_Player_MediumCannon_Enter(lock:SingletonLock) 
		{
			m_stateName ="AIState_Player_MediumCannon_Enter"
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
			if (CPlayerTeelos(npc).m_cranePlacing.currentFrame == 2 && CPlayerTeelos(npc).craneAnimationDone())
			{
				CPlayerTeelos(npc).onCraneReleaseBox();
				npc.changeAIState(AIState_Player_MediumCannon_Prepare.getInstance());
				/*npc.getSprite().alpha = 1;
				npc.getSprite().sprite.play();
				trace(npc.isAnimationComplete());
				if (npc.isAnimationComplete())
				{
					trace("A");
					//npc.changeAIState(AIState_Player_Unit_Prepare.getInstance());
				}*/
			}
			else 
			{
			}
			/*if ( !npc.isDestinationReached() )
			{
				npc.x += elapsedTime * npc.speed;
			}
			else
			{
				npc.changeAIState(AIState_Player_Unit_Build.getInstance());
			}*/
		}
		
		static public function getInstance() : AIState_Player_MediumCannon_Enter 
		{
			if ( m_instance == null )
			{
            	m_instance = new AIState_Player_MediumCannon_Enter( new SingletonLock() );
            }
			return m_instance;
		}
	}
}

class SingletonLock{}