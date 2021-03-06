///////////////////////////////////////////////////////////
//  CCaptainSmith.as
//  Macromedia ActionScript Implementation of the Class CCaptainSmith
//  Generated by Enterprise Architect
//  Created on:      14-Dec-2010 3:02:06 PM
//  Original author: poof!
///////////////////////////////////////////////////////////

package com.game
{
	import com.game.ai.AIState;
	import com.game.CPlayerTeelos;
	import flash.display.DisplayObjectContainer;
	import com.game.fx.CEffect_Heal;

	/**
	 * @author poof!
	 * @version 1.0
	 * @created 14-Dec-2010 3:02:06 PM
	 */
	public class CCaptainSmith extends CPlayerCaptain implements IRangeAttacker
	{		
		public var m_powerUpDuration:int;
		public var m_rateUpDuration:int;
		public var m_doubleShotDuration:int;
		
		public var usePowerUp:Boolean;
		public var useRateUp:Boolean;
		public var useHeal:Boolean;
		public var useDoubleShot:Boolean;
		public var enchanceTarget:CBaseTeelos;
		
		public function CCaptainSmith(){

		}
		
		override public function initialize():void 
		{
			super.initialize();
			
			m_baseAttack = 2;
			m_defense = 5;
			m_maxLife = 10;
			m_unitClass = UNITCLASS.ARCHER;
			m_counterClass = UNITCLASS.INFANTRY;
			m_counterBonus = 1;
			m_baseSpeed = 0.8;
			m_baseCooldownTime = 1800;
			m_trainCost = 180;
			
			m_damageMultiplier = 3;
			m_powerUpDuration = 12000;
			
			m_rateMultiplier = 2;
			m_rateUpDuration = 10000;
			
			m_doubleShotMultiplier = 2;
			m_doubleShotDuration = 10000;
		}
		
		override public function onCreate(lane:int, targetPosX:int, container:DisplayObjectContainer):void 
		{
			super.onCreate(lane, targetPosX, container);
			m_attackRange = 700;
		}
		
		override protected function createSprite():void 
		{
			super.createSprite();
			m_sprite = new mcCaptain_Smith();
		}
		
		override public function update(elapsedTime:int):void 
		{
			super.update(elapsedTime);
			if ( isAnimationComplete())
			{
				if (usePowerUp)
				{
					ParticleManager.getInstance().add(CEffect_Heal, enchanceTarget.x, enchanceTarget.y);
					enchanceTarget.PowerUP(m_powerUpDuration, m_damageMultiplier);
					setCurrentFrame(1);
					usePowerUp = false;
				}
				else if (useRateUp)
				{
					ParticleManager.getInstance().add(CEffect_Heal, enchanceTarget.x, enchanceTarget.y);
					enchanceTarget.SpeedUP(m_rateUpDuration, m_rateMultiplier);
					setCurrentFrame(1);
					useRateUp = false;
				}
				else if (useDoubleShot)
				{
					ParticleManager.getInstance().add(CEffect_Heal, enchanceTarget.x, enchanceTarget.y);
					enchanceTarget.doubleSHOT(m_doubleShotDuration, m_doubleShotMultiplier);
					setCurrentFrame(1);
					useDoubleShot = false;
				}
				else if (useHeal)
				{
					ParticleManager.getInstance().add(CEffect_Heal, enchanceTarget.x, enchanceTarget.y);
					enchanceTarget.Heal();
					setCurrentFrame(1);
					useHeal = false;
				}
			}
		}
		
		
		override public function releaseProjectile():void
		{
			super.releaseProjectile();
			MissileManager.getInstance().launch( CMissileBall_Smith, m_container, m_sprite.x, m_sprite.y - 65, 
												 m_sprite.scaleX, getFaction(), m_lane,
												 m_baseAttack, m_counterClass, m_counterBonus, m_level, m_detectInvisible, this );
		}
	}//end CCaptainSmith

}