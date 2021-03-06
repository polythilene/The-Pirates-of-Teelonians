package com.game.ai 
{
	import com.game.CBaseTeelos;
	import com.game.IJumper;
	
	/**
	 * ...
	 * @author Wiwit
	 */
	public class AIState_Player_MediumCannon_Idle extends AIState
	{
		static private var m_instance:AIState_Player_MediumCannon_Idle;
		
		public function AIState_Player_MediumCannon_Idle(lock:SingletonLock) 
		{
			m_stateName ="AIState_Player_MediumCannon_Idle"
			m_enableTimeOut = false;
		}
		
		override public function enter(npc:CBaseTeelos):void 
		{
			super.enter(npc);
			npc.setCurrentFrame(3);
			npc.projCount = 0;
		}
		
		override public function update(npc:CBaseTeelos, elapsedTime:int):void 
		{
			super.update(npc, elapsedTime);
			
			if ( !npc.isCoolingDown() )
			{
				var enemy:CBaseTeelos = npc.getNearestEnemy();
				if( enemy && !npc.isProjectileReleased() )
				{
					if ( enemy )
					{
						if( enemy is IJumper && !IJumper(enemy).hasLanded() )
							return;					
					
						npc.attack(enemy);
						npc.changeAIState( AIState_Player_MediumCannon_Attack.getInstance() );
					}
				}
			}
		}
		
		static public function getInstance() : AIState_Player_MediumCannon_Idle 
		{
			if ( m_instance == null )
			{
            	m_instance = new AIState_Player_MediumCannon_Idle( new SingletonLock() );
            }
			return m_instance;
		}
	}
}

class SingletonLock{}