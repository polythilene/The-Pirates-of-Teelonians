package com.game.ai 
{
	import com.game.CBaseTeelos;
	import com.game.UNITCLASS;
	/**
	 * ...
	 * @author Wiwit
	 */
	public class AIState_Player_MediumCannon_Attack extends AIState
	{
		static private var m_instance:AIState_Player_MediumCannon_Attack;
		private var counter:int = 0;
		private var shotCounter:int = 0;

		
		public function AIState_Player_MediumCannon_Attack(lock:SingletonLock) 
		{
			m_stateName ="AIState_Player_MediumCannon_Attack"
			m_enableTimeOut = false;
		}
		
		override public function update(npc:CBaseTeelos, elapsedTime:int):void 
		{
			super.update(npc, elapsedTime);
			
			if ( npc.isAnimationComplete() )
			{
				shotCounter += elapsedTime;
				if (shotCounter > 100)
				{
					if (npc.getProjectileCount() < npc.getMaxProjectile())
					{
						npc.releaseProjectile();
						counter ++;
						npc.projCount = counter;
					}
					else
					{
						counter = 0;
						npc.changeAIState( AIState_Player_MediumCannon_Idle.getInstance() );
					}
					shotCounter = 0;
				}
			}	
		}
		
		static public function getInstance() : AIState_Player_MediumCannon_Attack 
		{
			if ( m_instance == null )
			{
            	m_instance = new AIState_Player_MediumCannon_Attack( new SingletonLock() );
            }
			return m_instance;
		}
		
	}
}

class SingletonLock{}