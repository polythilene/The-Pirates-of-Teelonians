package com.game.ai 
{
	import com.game.CBaseTeelos;
	import com.game.CEnemyTeelos;
	import com.game.CPlayerTeelos;
	import com.game.IHybridAttacker;
	import com.game.IInvulnerable;
	import com.game.IRangeAttacker;
	import com.game.IStationary;
	import math.OpMath;
	
	/**
	 * ...
	 * @author Wiwit
	 */
	public class AIState_Enemy_Walk extends AIState
	{
		static private var m_instance:AIState_Enemy_Walk;
		
		public function AIState_Enemy_Walk(lock:SingletonLock) 
		{
			m_stateName ="AIState_Enemy_Walk"
			m_enableTimeOut = false;
		}
		
		override public function enter(npc:CBaseTeelos):void 
		{
			super.enter(npc);
			npc.setCurrentFrame(2);
		}
		
		override public function update(npc:CBaseTeelos, elapsedTime:int):void 
		{
			super.update(npc, elapsedTime);
			
			var player:CBaseTeelos = npc.getNearestEnemy();	// get nearest enemy
			if ( player && npc.x <= 750 && !(npc is IStationary) )
			{
				//trace("ABCDEF");
				if ( !npc.isCoolingDown() )
				{
					/*if ( !(npc is IStationary) )
					{*/
						npc.attack(player);
						if ( !(npc is IRangeAttacker) && !(npc is IHybridAttacker))
						{
							//trace("A2");
							npc.changeAIState( AIState_Enemy_Attack.getInstance() );
						}
						else if (npc is IHybridAttacker)
						{
							//trace("CHANGE");
							npc.changeAIState (AIState_Enemy_HybridAttack.getInstance());
							/*var range:int = player.x - npc.x;
							var dice:int = OpMath.randomNumber(6);
							if ( dice < 3)
							{
								npc.changeAIState( AIState_Enemy_AttackRanged.getInstance());
							}
							else
							{
								if (range < 30 && player.x > npc.x)
								{
									trace("AAAA");
									npc.changeAIState( AIState_Enemy_Attack.getInstance());
								}
								else
								{
									trace("EEEEEEE");
									npc.setCurrentFrame(1);
								}
							}*/
						}
						else
						{
							//trace("A3");
							npc.changeAIState( AIState_Enemy_AttackRanged.getInstance() );
						}
					//}
				}
				else
				{
					npc.setCurrentFrame(1);
				}
			}
			else
			{
				if ( !npc.isDestinationReached() && !npc.isDead() )
				{
					var length:Number = elapsedTime * npc.speed;
					npc.x -= (length - (length * npc.slowFactor));
					
					// slash enemy when near
					if ( !(npc is IRangeAttacker) && !CEnemyTeelos(npc).hitRun && npc.attackRange < 50 )
					{
						trace("A4");
						var enemy:CBaseTeelos = npc.getNearestEnemy();
						if ( enemy != null && !enemy.isDead() && enemy.x > npc.x && 
							(enemy.x - npc.x) < 30 && !(enemy is IInvulnerable) )
						{
						//	trace("A5");
							trace("BBBB");
							npc.attack(enemy);
							npc.changeAIState(AIState_Enemy_HitRun.getInstance());
							CEnemyTeelos(npc).hitRun = true;
						}
					}
				}
				else
				{
					npc.changeAIState(AIState_Enemy_Idle.getInstance());
				}
			}
		}
		
		static public function getInstance() : AIState_Enemy_Walk 
		{
			if ( m_instance == null )
			{
            	m_instance = new AIState_Enemy_Walk( new SingletonLock() );
            }
			return m_instance;
		}
		
	}
}

class SingletonLock{}