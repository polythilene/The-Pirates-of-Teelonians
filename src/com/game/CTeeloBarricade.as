///////////////////////////////////////////////////////////
//  CTeeloBarricade.as
//  Macromedia ActionScript Implementation of the Class CTeeloBarricade
//  Generated by Enterprise Architect
//  Created on:      22-Dec-2010 2:21:52 PM
//  Original author: poof!
///////////////////////////////////////////////////////////

package com.game
{
	import com.game.ai.AIState_Player_Barricade_Die;
	import com.game.ai.AIState_Player_Barricade_Enter;
	import com.game.CBaseTeelos;
	import com.game.CTeeloBaseBuilding;
	import flash.display.DisplayObjectContainer;

	/**
	 * @author poof!
	 * @version 1.0
	 * @created 22-Dec-2010 2:21:52 PM
	 */
	public class CTeeloBarricade extends CTeeloBaseBuilding
	{
		public function CTeeloBarricade(){

		}
		
		override public function initialize():void 
		{
			super.initialize();
			
			m_baseAttack = 0;
			m_defense = 10;	//siom, 24jan011 09:49
			m_maxLife = 300; //siom, 23jan011 12:09
			m_unitClass = UNITCLASS.BUILDING;
			m_counterClass = UNITCLASS.NONE;
			m_counterBonus = 0;
			m_baseSpeed = 0.05;
			m_baseCooldownTime = 2000;
			m_stealthUnit = false;
			m_trainCost = 750;
		}
		
		override protected function createSprite():void 
		{
			super.createSprite();
			m_sprite = new mcTeelo_Barricade();
		}
		
		override public function onCreate(lane:int, targetPosX:int, container:DisplayObjectContainer):void 
		{
			super.onCreate(lane, targetPosX, container);
			changeAIState( AIState_Player_Barricade_Enter.getInstance() );
		}
		
		override public function damage(value:int, source:CBaseTeelos):void 
		{
			if ( value > 0 )
			{
				var def:int = Math.ceil( defense / 2 );
				var dmg:int = (def > value) ? 1 : value - def;
			}
			else
			{
				dmg = value;
			}
			if (dmg == 0) dmg = 1;
			
			m_currLife -= dmg;
			if( m_currLife < 0 )
			{
				m_dead = true;
				changeAIState( AIState_Player_Barricade_Die.getInstance() );
			}
			
			m_currLife = Math.min(m_currLife, m_maxLife);		// cap value when unit is healed
			
			// tint sprite
			var col:int = (value > 0) ? 0xFF0000 : 0x00FF00;
			tintOnHit(col);
		}
		
		override public function onBuildComplete():void 
		{
			super.onBuildComplete();
			NPCManager.getInstance().add( CTeeloWorkerReturn, m_lane, m_sprite.x, m_container );
		}
	}
}