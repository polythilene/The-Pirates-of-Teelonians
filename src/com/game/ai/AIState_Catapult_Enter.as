package com.game.ai 
{
	import com.game.CBaseTeelos;
	
	/**
	 * ...
	 * @author Wiwit
	 */
	public class AIState_Catapult_Enter extends AIState
	{
		static private var m_instance:AIState_Catapult_Enter;
		
		public function AIState_Catapult_Enter(lock:SingletonLock) 
		{
			m_stateName = "AIState_Catapult_Enter";
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
			
			if( !npc.isDestinationReached() && !npc.isDead() )
			{
				var length:Number = elapsedTime * npc.speed;
				npc.x -= length - (length * npc.slowFactor);
			}
			else
			{
				npc.changeAIState(AIState_Catapult_Throw.getInstance());
			}
		}
		
		static public function getInstance() : AIState_Catapult_Enter 
		{
			if ( m_instance == null )
			{
            	m_instance = new AIState_Catapult_Enter( new SingletonLock() );
            }
			return m_instance;
		}
		
	}
}

class SingletonLock{}