///////////////////////////////////////////////////////////
//  CTeeloEndrogee.as
//  Macromedia ActionScript Implementation of the Class CTeeloEndrogee
//  Generated by Enterprise Architect
//  Created on:      17-Dec-2010 11:30:39 AM
//  Original author: poof!
///////////////////////////////////////////////////////////

package com.game
{
	import com.game.CPlayerTeelos;
	import flash.display.DisplayObjectContainer;

	/**
	 * @author poof!
	 * @version 1.0
	 * @created 17-Dec-2010 11:30:39 AM
	 */
	public class CTeeloEndrogee extends CPlayerTeelos implements IRangeAttacker
	{
		public function CTeeloEndrogee(){

		}
		
		override public function initialize():void 
		{
			super.initialize();
			
			m_baseAttack = 1;
			m_defense = 1;
			m_maxLife = 10;
			m_unitClass = UNITCLASS.MAGE;
			m_counterClass = UNITCLASS.CAVALRY;
			m_counterBonus = 3;
			m_baseSpeed = 0.04;
			m_baseCooldownTime = 7000;
			m_trainCost = 400;
		}
		
		override protected function createSprite():void 
		{
			super.createSprite();
			m_sprite = new mcTeelo_Endrogee();
		}
		
		override public function onCreate(lane:int, targetPosX:int, container:DisplayObjectContainer):void 
		{
			super.onCreate(lane, targetPosX, container);
			m_attackRange = 600;
		}
		
		override public function releaseProjectile():void
		{
			super.releaseProjectile();
												 
			MissileManager.getInstance().launch( CMissileIceBall_Endrogee , m_container, m_sprite.x, m_sprite.y - 45, 
												 1, getFaction(), m_lane,
												 m_baseAttack, m_counterClass, m_counterBonus, m_level, m_detectInvisible, this,
												 {target:m_target, groundLevel:y} );
		}

	}//end CTeeloEndrogee

}