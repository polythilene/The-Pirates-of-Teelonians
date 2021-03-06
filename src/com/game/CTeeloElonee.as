///////////////////////////////////////////////////////////
//  CTeeloElonee.as
//  Macromedia ActionScript Implementation of the Class CTeeloElonee
//  Generated by Enterprise Architect
//  Created on:      15-Des-2010 23:57:25
//  Original author: poof!
///////////////////////////////////////////////////////////

package com.game
{
	import com.game.CPlayerTeelos;
	import flash.display.DisplayObjectContainer;

	/**
	 * @author poof!
	 * @version 1.0
	 * @created 15-Des-2010 23:57:25
	 */
	public class CTeeloElonee extends CPlayerTeelos implements IRangeAttacker
	{
		public function CTeeloElonee(){

		}
		
		override public function initialize():void 
		{
			super.initialize();
			
			m_baseAttack = 8;
			m_defense = 1;
			m_maxLife = 10;
			m_unitClass = UNITCLASS.MAGE;
			m_counterClass = UNITCLASS.ARCHER;
			m_counterBonus = 2;
			m_baseSpeed = 0.04; //siom, 21jan11 21:11
			m_baseCooldownTime = 10000; //siom, 21jan11 21:11
			m_trainCost = 500;
		}
		
		override protected function createSprite():void 
		{
			super.createSprite();
			m_sprite = new mcTeelo_Elonee();
		}
		
		override public function onCreate(lane:int, targetPosX:int, container:DisplayObjectContainer):void 
		{
			super.onCreate(lane, targetPosX, container);
			m_attackRange = 700;
		}
		
		override public function releaseProjectile():void
		{
			super.releaseProjectile();
			
			MissileManager.getInstance().launch( CMissileFireball_Elonee, m_container, m_sprite.x, m_sprite.y - 45, 
												 1, getFaction(), m_lane,
												 m_baseAttack, m_counterClass, m_counterBonus, m_level, m_detectInvisible, this,
												 {target:m_target, groundLevel:y} );
		}

	}//end CTeeloElonee

}